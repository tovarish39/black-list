# frozen_string_literal: true

module ControllerHelpers # rubocop:disable Style/Documentation
  class << self
    def view_oracle_tips
      oracles_tips = Video.last.oracles_tips
      if !oracles_tips.nil?
        type = oracles_tips['type']
        file_id = oracles_tips['file_id']
        BotMain.send("send_#{type}", caption: Text.oracle_tips, reply_markup: M::Inline.link_to_oracles_tips, file_id:)
      else
        Send.mes(Text.oracle_tips, M::Inline.link_to_oracles_tips)
      end
    end
  end
end
