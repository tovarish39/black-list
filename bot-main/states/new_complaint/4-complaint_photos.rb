# frozen_string_literal: true

class StateMachine
  class_eval do
    include AASM
    aasm do
      state :complaint_photos
      # rubocop:disable RuboCopLayout/SpaceBeforeComma
      # rubocop:disable Layout/LineLength
      event :complaint_photos_action, from: :complaint_photos do
        transitions if: -> { mes_text?(Button.ready) &&  in_min_limit? }, after: :to_compare_user_id    , to: :compare_user_id
        transitions if: -> { mes_text?(Button.ready) && !in_min_limit? }, after: :notice_min_photos_size, to: :complaint_photos

        transitions if: -> { mes_text?(Button.cancel) }                 , after: :to_start, to: :start

        transitions if: -> { mes_photo? &&  in_max_limit? }             , after: :handle_photo          , to: :complaint_photos
        transitions if: -> { mes_photo? && !in_max_limit? }             , after: :notice_max_photos_size, to: :complaint_photos
      end
      # rubocop:enable RuboCopLayout/SpaceBeforeComma
      # rubocop:enable Layout/LineLength
    end
  end
end

def get_size_now
  complaint = Complaint.find_by(id: $user.cur_complaint_id)
  return 0 if complaint.nil? # если нету скамера по причине, что пропущено состояние создания скамера

  size_now = complaint.photos_amount
end

def in_min_limit?
  get_size_now >= ENV['MIN_PHOTOS_AMOUNT'].to_i
  # puts get_size_now
end

def in_max_limit? # ..21
  get_size_now < ENV['MAX_PHOTOS_AMOUNT'].to_i
end

def write_file(file, complaint)
  file_path = file['result']['file_path']
  file_url = URI("https://api.telegram.org/file/bot#{ENV['TOKEN_MAIN']}/#{file_path}")
  #   puts   file_url
  dir_path = get_photo_dir_path(complaint)
  # puts dir_path
  Dir.mkdir(dir_path) unless Dir.exist?(dir_path)

  complaint.photos_amount += 1
  complaint.photos_dir_path = dir_path
  complaint.save

  photo_path = "#{dir_path}/#{complaint.photos_amount}.jpg"

  photo_data = Net::HTTP.get_response(file_url).body

  File.write(photo_path, photo_data, mode: 'wb')
end

def handle_photo
  min_size = 2 # availible 3 variants (indexes)
  file = $mes.photo[min_size]

  if file.nil? # неверныф формат
    Send.mes(Text.require_anothe_format_image)
    return
  end

  file = Get.file(file.file_id)
  complaint = Complaint.find($user.cur_complaint_id)

  photo_file_ids = deep_clone(complaint.photo_file_ids)
  photo_file_ids.push($mes.photo[0].file_id)

  complaint.update(photo_file_ids:)

  write_file(file, complaint) if file.present?

  if complaint.photos_amount == ENV['MAX_PHOTOS_AMOUNT'].to_i
    Send.mes(Text.handle_last_photo(complaint.photos_amount))
  else
    Send.mes(Text.handle_photo(complaint.photos_amount))
  end
end

def notice_max_photos_size
  Send.mes(Text.push_ready)
end

def notice_min_photos_size
  Send.mes(Text.notice_min_photos_size)
end

def to_compare_user_id
  compare_user_id = Video.last.compare_user_id
  if compare_user_id.present?
    type = compare_user_id['type']
    file_id = compare_user_id['file_id']
    BotMain.send("send_#{type}", caption: Text.compare_user_id, reply_markup: M::Reply.compare_user_id, file_id:)
  else
    Send.mes(Text.compare_user_id, M::Reply.compare_user_id)
  end
end
