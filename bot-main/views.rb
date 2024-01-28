# frozen_string_literal: true

# подготовка данных для отображения + отображение
module View
  class << self
    def start
      with_or_media(:start, Text.greet, M::Reply.start)
    end

    def search_user
      with_or_media(:search_user, Text.search_user, M::Reply.search_user)
    end

    def complaint_text
      with_or_media(:complaint_text, Text.complaint_text, M::Reply.complaint_text)
    end

    def complaint_photos
      with_or_media(:complaint_photos, Text.complaint_photos, M::Reply.complaint_photos)
    end

    def compare_user_id
      with_or_media(:compare_user_id, Text.compare_user_id, M::Reply.compare_user_id)
    end

    def option_details
      with_or_media(:option_details, Text.option_details, M::Reply.to_6_point)
    end

    def input_username
      with_or_media(:input_username, Text.input_username, M::Reply.input_username)
    end

    private

    def with_or_media(column_db, text, markup = nil)
      column = Video.last.send(column_db)
      if column.present?
        type = column['type']
        file_id = column['file_id']
        BotMain.send("send_#{type}", caption: text, reply_markup: markup, file_id:)
      else
        Send.mes(text, markup)
      end
    end
  end
end
