module Text
    def self.lang   = 'выберите язык'
    def self.greet 
        'Текст приветствия к котопрому прикрекплекно видео'
    end
    def self.clear_account
       'Вы не находитесь в списке скамеров!' 
    end
    def self.search_user
        'Пришлите нам ID обвиняемогo или выберите чат с ним при помощи кнопки “🔎 Выбрать”'
    end
    def self.not_found
        'Пользователь не найден'
    end
    def self.user_info user
        "User info: \nID: #{user.telegram_id} \n#{"First Name: #{user.first_name}\n" if user.first_name.present?}#{"Username: @#{user.username}\n" if user.username.present?}"
    end
    def self.complaint_text
        "Объясните ситуацию, ввведите сообщение длиной от #{ENV['MIN_LENGTH_COMPLAINT_TEXT']} до #{ENV['MAX_LENGTH_COMPLAINT_TEXT']} символов"
    end
    def self.more_then_max_length
        "Вы превысили количество символов, отправьте сообщение длиной до #{ENV['MAX_LENGTH_COMPLAINT_TEXT']} символов"
    end
    def self.less_then_min_length
        "вы ввели недостаточно символов отправьте сообщение длиной от #{ENV['MIN_LENGTH_COMPLAINT_TEXT']} символов"
    end
    def self.complaint_photos
        'Отправьте скриншоты диалога на которых виден процесс обмана, после отправки нажмите кнопку “Готово”'
    end
    def self.notice_max_photos_size
        "Максимальное количество фотографий #{ENV['MAX_PHOTOS_AMOUNT']}"
    end
    def self.notice_min_photos_size
        'Необходимо отправить фото'
    end
    # def self.less_then_min_photos_size
    #     "Необходимо отправить хотя бы одно фото"
    # end
    def self.handle_photo photos_size
        "Изображение №#{photos_size} успешно принято, вы можете отправить еще или продолжить подачу жалобы нажав кнопку “Готово”"
    end
    def self.compare_user_id
        'Перешлите сообщения ответчика из чата, соответствующие скрину'
    end
    def self.complaint_request_to_moderator complaint
        "Ваша жалоба #N#{complaint.id} была отправлена на проверку модератором, ожидайте её рассмотрения о результатах вас оповестит бот ⏳"
    end
    def self.moderator_complaint user, scamer
        %{\n
<strong>Жалоба</strong> #N#{scamer.id}

<strong>ОТ</strong>
#{Text.user_info(user)}\n
<strong>На</strong>
#{Text.user_info(scamer)}
<strong>Ссылка</strong> <a href='#{scamer.telegraph_link}'>telegraph_link</a>
}
    end
    
    
    def self.complaint_published complaint
        %{Ваша жалоба #N#{complaint.id} Опубликована.  <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>ссылка</a> на пост}
    end
    def self.handle_explanation scamer
        "Жалоба #N#{scamer.id}\n❌Отклонена❌\n<b>Причина: </b>\n#{scamer.explanation_by_moderator}"
    end
    def self.view_complaints telegraph_links
        text_body = telegraph_links.map {|link| "\nСсылка:<a href='#{link}'>telegraph_link</a>"}
        return "Вы обнаружены в списке скамеров!" + text_body.join('')
    end
    def self.explain_justification
        "Опишите вашу версию событий"
    end
    def self.justification_already_used
        "Вы обнаружены в списке скамеров!\nВаше заявление на рассмотрении"
    end
    def self.justification_request_to_moderator accepted_complaints, scamer
        text_body = accepted_complaints.map {|complaint| "\n<strong>Жалоба</strong> #N#{complaint.id}\n<strong>Ссылка</strong> <a href='#{complaint.telegraph_link}'>telegraph_link</a>\n<strong>Ссылка</strong> пост\n\n <b>Объяснение:</b> #{scamer.justification} "}
        if text_body.empty? # решение от администратора, когда не было претензий
            return "Решение принято администратором\n⚖️Оспорить решение⚖️\nОправдание от пользователя:\n" + scamer.justification 
        end

        return "⚖️Оспорить решение⚖️\n" + text_body.join('')
    end
    def self.you_not_scamer
        'Ура, вы не скамер'
    end
    def self.you_blocked
        "Вы заблокированы"
    end
    def self.verifyed users_data
        "#{users_data}  - Проверенный"
    end
    def self.require_subscribe_channel
        "Необходимо подписаться на <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}'>канал</a>"
    end
    def self.not_scamer users_data
        "#{users_data}  - не скамер"
    end
    def self.is_scamer users_data, complaint
        "#{users_data}  - скамер <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>ссылка</a> на пост"
    end


    def self.require_registration
        'зарегистрируйтесь у администратора'
    end
    def self.require_active_account
        'активируйте аккаунт у администратора'
    end

    def self.managed_by_admin
        'Обработано администратором'
    end
   
    def self.already_not_scamer
        'Уже не скамер, обработано ранее'
    end

    def self.input_cause_of_reject
        'ВВедите причину отклонения'
    end
    def self.handle_accept_complaint complaint
        %{Обработано. <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>ссылка</a> на пост на канале  }
    end
    def self.was_handled
        'Был ранее обработан'
    end
    def self.greeting_mod
        'Приветствие модератору'
    end
    def self.accessing_justification
        "Обработано"
    end
    def self.blocking_user
        "Юзер заблокирован"
    end
    def self.not_complaints
        "Заявки не зарегистрированы"
    end
    def self.complaint scamer
        "Жалоба #N#{scamer.id}"
    end
   
end