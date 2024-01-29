# frozen_string_literal: true

module MediaHandler # rubocop:disable Style/Documentation
  exclude_columns = %w[id created_at updated_at]
  availible_columns = Video.column_names.filter { |column| !exclude_columns.include?(column) }

  COMMANDS = availible_columns.map do |column|
    "/write_to #{column}"
  end

  TYPES = %w[
    video
    animation
  ].freeze

  class << self
    def user_try_write_media?(mes)
      return false unless mes.respond_to?(:caption)

      command = mes.caption

      command &&
        COMMANDS.include?(command) &&
        TYPES.any? { |type| mes.send(type).present? } # если есть что-то из этого списка
    end

    def write_media(mes)
      type = TYPES.find do |local_type|
        mes.send(local_type).present?
      end
      file_id = mes.send(type).file_id
      db_field = mes.caption.split(' ').last.to_sym
      save(db_field:, type:, file_id:)
    rescue StandardError
      Send.mes('что-то пошло не так, отправьте файл, который пытались установить разработчику')
    end

    private

    def save(db_field:, type:, file_id:)
      Video.last.update!(db_field => { type:, file_id: })
      Send.mes('Успешно добавлено')
    end
  end
end
