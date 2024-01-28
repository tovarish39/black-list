# frozen_string_literal: true

module Link # rubocop:disable Style/Documentation
  class << self
    def stop_status_1(telegraph_link) # rubocop:disable Naming/VariableNumber
      "<a href='#{telegraph_link}'>💥 CHECK THE REPORT OUT</a>"
    end

    def stop_status_2 # rubocop:disable Naming/VariableNumber
      "<a href='https://t.me/ripperlistbot'>🪓 APPEAL THE ACCUSATIONS</a>"
    end

    def stop_status_3 # rubocop:disable Naming/VariableNumber
      "<a href='http://t.me/oraclesupport'>🧨 CONTACT ORACLE'S SUPPORT TEAM</a>"
    end
  end
end
