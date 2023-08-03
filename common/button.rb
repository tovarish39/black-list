module Button
    def self.all_main
        [
            self.make_a_complaint,
            self.request_status,
            self.account_status,
            # self.request_history,
            '/start'
        ]
    end
    def self.ru = '🇷🇺 Русский 🇷🇺'
    def self.en = '🇺🇸 English 🇺🇸'
    def self.request_status 
        '📔 Статус поданных заявок'
    end
    def self.make_a_complaint 
        "⚙️ Подать жалобу" # if lg == Ru    
    end
    def self.account_status 
        '📛 Статус аккаунта'
    end
    # def self.request_history 
    #     '🏛 История заявок'
    # end
    def self.select_user
        '🔎 Выбрать'
    end
    def self.cancel
        'Отмена'
    end
    def self.verify_potential_scamer
        'Подтвердить'
    end
    def self.ready
        'Готово'
    end
    def self.skip
        'Пропустить'        
    end
    def self.active_complaints
        'Активные заявки'
    end
    def self.accept
        'Одобрить'
    end
    def self.reject
        '❌Отклонить'
    end
    def self.justification
        "Оспорить"
    end
    def self.block_user
        "❌Заблокировать юзера"
    end
end