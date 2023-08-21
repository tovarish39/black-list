require_relative './config/requires.rb'
require 'faraday'
require 'faraday/multipart'
require 'fileutils'

UPLOAD_ON_TELEGRAPH_PATH='./on_telegraph.rb'

complaint_id = ARGV[0]
user_id   = ARGV[1]


complaint = Complaint.find(complaint_id)
photos_dir_path = complaint.photos_dir_path
photo_names = Dir.entries(photos_dir_path).filter {|file| file =~ /.jpg$/}

BOT = Telegram::Bot::Client.new(ENV['TOKEN_MAIN'])
key = '6d207e02198a847aa98d0a2a901485a5'
url = "https://freeimage.host/api/1/upload?key=#{key}&format=json"

$counter = 0

def upload_and_get_direct_link base64_image, url
  begin
    conn = Faraday.new(url: url) {|faraday| faraday.options.timeout = 1 }# Устанавливаем время ожидания в 2 секунды
    # Определяем параметры запроса, включая тело в формате Base64
    payload = {'source' => base64_image}
    # Отправляем POST-запрос с данными
    response = conn.post do |req|
      # req.url '/endpoint' # Укажите URL-адрес вашего сервера
      req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      req.body = URI.encode_www_form(payload)
    end

    return direct_link = JSON.parse(response.body)['image']['url']
  rescue => exception
    if $counter >= 20 
      $counter = 0
      raise $counter 
    end
    BOT.api.send_message(text:"error #{$counter} freeimage #{url}",                          chat_id:ENV['CHAT_ID_MY'])
    $counter += 1
    return upload_and_get_direct_link(base64_image, url)
  end
end

begin
    photo_names.each do |photo_name|
      file_path = "#{photos_dir_path}/#{photo_name}"
      
      # Открываем файл и читаем его содержимое в бинарном режиме
      file_content = File.open(file_path, 'rb') { |file| file.read }
      base64_image = Base64.encode64(file_content)
      
      if base64_image.present?
        direct_link = upload_and_get_direct_link(base64_image, url)
        urls = complaint.photo_urls_remote_tmp || []
        complaint.update!(photo_urls_remote_tmp:urls << direct_link)
      else next
      end
    end
      
    ############ удаление папки с фотками
    FileUtils.rm_rf(photos_dir_path)
    system("bundle exec ruby #{UPLOAD_ON_TELEGRAPH_PATH} #{complaint.id} #{user_id}")
          
rescue => exception
    BOT.api.send_message(text:exception,                          chat_id:ENV['CHAT_ID_MY'])
    BOT.api.send_message(text:exception.backtrace,                chat_id:ENV['CHAT_ID_MY'])
end

    