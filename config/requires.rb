require 'telegram/bot'
require 'active_record'
require 'aasm'
require 'colorize'
require 'logger'
require 'dotenv'
require 'socket'
Dotenv.load

params = {
    adapter: 'postgresql',
    host: 'localhost',
    port: 5432,
    dbname: 'black-list_adminka_development',
    user: ENV['DB_USERNAME'],
    password: ENV['DB_PASSWORD']
}

ActiveRecord::Base.establish_connection(params)


Ru = 'ru'
En = 'en'
Es = 'es'
Cn = 'cn'


CallbackQuery        = Telegram::Bot::Types::CallbackQuery
Message              = Telegram::Bot::Types::Message
ChatMemberUpdated    = Telegram::Bot::Types::ChatMemberUpdated
ReplyKeyboardMarkup  = Telegram::Bot::Types::ReplyKeyboardMarkup
InlineKeyboardMarkup = Telegram::Bot::Types::InlineKeyboardMarkup
InlineKeyboardButton = Telegram::Bot::Types::InlineKeyboardButton

def require_all(path)
    Dir.glob("#{path}/**/*.rb").sort.each { |file| require file }
end

$root_path = Dir.pwd
PHOTOS_PATH="#{$root_path}/photos"
UPLOAD_ON_FREEIMAGE="#{$root_path}/on_freeimage_host.rb"

path_models = "#{$root_path}/adminka/app/models"
common_path = "#{$root_path}/common"

require_all path_models
require_all common_path


