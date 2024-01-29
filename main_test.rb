# frozen_string_literal: true

# require 'minitest/autorun'

ENVIROMENT = 'test'
require_relative 'config'
require_all './bot-main'

# class TestMeme < Minitest::Test
# def setup
data = { 'update_id' => 283_619_939,
         'message' => { 'message_id' => 5858,
                        'from' => { 'id' => 1_964_112_204, 'is_bot' => false, 'first_name' => 'gorrus39', 'username' => 'gorrus39', 'language_code' => 'en' }, 'chat' => { 'id' => 1_964_112_204, 'first_name' => 'gorrus39', 'username' => 'gorrus39', 'type' => 'private' }, 'date' => 1_706_476_283, 'text' => '📌 Oracle`s Tips' } } # rubocop:disable Layout/LineLength

mes = Telegram::Bot::Types::Update.new(data).message
# end

# def test_that_kitty_can_eat
handle
# puts @mes.text
# puts @mes.inspect
# assert @meme == 'aaa'
#   end
# end
