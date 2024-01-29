require 'telegram/bot'
require 'active_record'
require 'aasm'
require 'colorize'
require 'logger'
require 'dotenv'
require 'socket'
require 'i18n'

I18n.load_path += Dir["#{File.expand_path('locales')}/*.{yml,rb}"]
I18n.default_locale = :en # (note that `en` is already the default!)

Dotenv.load

BOT_MOD_INIT = Telegram::Bot::Client.new(ENV['TOKEN_MODERATOR'])
BOT_MAIN_INIT = Telegram::Bot::Client.new(ENV['TOKEN_MAIN'])

env = ENVIROMENT || 'development'

params = {
  adapter: 'postgresql',
  host: 'localhost',
  port: 5432,
  dbname: "black-list_adminka_#{env}",
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
PHOTOS_PATH = "#{$root_path}/photos"
UPLOAD_ON_FREEIMAGE = "#{$root_path}/on_freeimage_host.rb"

path_models = "#{$root_path}/adminka/app/models"
common_path = "#{$root_path}/common"

require_all path_models
require_all common_path
