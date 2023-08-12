module Text
    def self.lang   = "Выбрать язык бота\nSelect the bot`s language\nSeleccionar el idioma del bot\n选择机器人的语言"

    def self.greet 
        return 'Привет, чувак! Добро пожаловать в Oracle`s Rippers List Bot. Этот бот - часть сети Oracle. Он создан для того, чтобы защитить тебя от мошенников на 99%! Он позволит тебе подать жалобу на кидал, узнать информацию о твоем партнере, получить данные аккаунта в Telegram и многое другое. Окажи себе услугу, и посмотри видео выше, чтобы полностью разобраться в том, как использовать этого бота. Если его правильно использовать, это серьёзно сыграет тебе наруку.' if $lg == Ru
        return 'Hey, man! Welcome to the Oracle`s Rippers List Bot. This bot is part of the Oracle`s Network, designed to keep you safe from rippers - like a 99% ripper-free guarantee! It`ll let you report rippers, dig up info on your partner, get Telegram account details, and so much more. Do yourself a favor and check out the video above for the full scoop on how to use this bot. It`s a game-changer thing, if you will use it in a proper way.' if $lg == En            
        return '¡Hola, amigo! Bienvenido al bot de la Lista de Estafadores de Oracle. Este bot es parte de la Red de Oracle, diseñado para mantenerte seguro de los estafadores - ¡como una garantía del 99% libre de estafadores! Te permitirá reportar estafadores, obtener información sobre tu pareja, obtener detalles de la cuenta de Telegram, y mucho más. Hazte un favor y revisa el video de arriba para obtener toda la información sobre cómo usar este bot. Si lo usas correctamente, es algo que puede cambiar el juego.' if $lg == Es        
        return '嘿，伙计！欢迎使用Oracle的骗子名单机器人。这个机器人是Oracle网络的一部分，旨在让你远离骗子——就像有99%的保证让你远离骗子一样！它会让你举报骗子，挖掘关于你的伙伴的信息，获取Telegram账户的详细信息，以及更多。你应该对自己好点，看看上面的视频，以了解如何使用这个机器人的全部信息。如果你正确使用它，它将成为改变游戏规则的东西。' if $lg == Cn
    end
    def self.clear_account
        # return '' if $lg == Ru 
        # return '' if $lg == En 
        # return '' if $lg == Es 
        # return '' if $lg == Cn
        'Вы не находитесь в списке скамеров!' 
    end
    def self.search_user
        return 'Отправьте нам ID подозреваемого' if $lg == Ru 
        return 'Send us the suspect person`s ID.' if $lg == En 
        return 'Envíenos la ID del sospechoso.' if $lg == Es 
        return '请发送嫌疑人的ID给我们。' if $lg == Cn
    end
    def self.not_found
        return 'Пользователь не найден' if $lg == Ru 
        return 'User not found' if $lg == En 
        return 'Usuario no encontrado' if $lg == Es 
        return '用户未找到' if $lg == Cn
    end
    def self.complaint_text
        return "Пожалуйста, кратко изложите ситуацию. Убедитесь, что ваше описание кратко и находится в диапазоне от #{ENV['MIN_LENGTH_COMPLAINT_TEXT']} до #{ENV['MAX_LENGTH_COMPLAINT_TEXT']} символов." if $lg == Ru 
        return "Please provide a brief explanation of the situation. Ensure your description is succinct and falls within #{ENV['MIN_LENGTH_COMPLAINT_TEXT']} to #{ENV['MAX_LENGTH_COMPLAINT_TEXT']} characters." if $lg == En 
        return "Por favor, proporciona una breve explicación de la situación. Asegúrate de que tu descripción sea concisa y esté entre #{ENV['MIN_LENGTH_COMPLAINT_TEXT']} y #{ENV['MAX_LENGTH_COMPLAINT_TEXT']} caracteres." if $lg == Es 
        return "请简要说明情况。请确保您的描述简洁并且在#{ENV['MIN_LENGTH_COMPLAINT_TEXT']}至#{ENV['MAX_LENGTH_COMPLAINT_TEXT']}个字符之间。" if $lg == Cn
    end
    def self.more_then_max_length
        return "Вы превысили количество символов, отправьте сообщение длиной до #{ENV['MAX_LENGTH_COMPLAINT_TEXT']} символов" if $lg == Ru 
        return "You have exceeded the character limit, send a message up to #{ENV['MAX_LENGTH_COMPLAINT_TEXT']} characters long." if $lg == En 
        return "Has introducido demasiados pocos caracteres, envía un mensaje de al menos #{ENV['MAX_LENGTH_COMPLAINT_TEXT']} caracteres de longitud." if $lg == Es 
        return "您输入的字符太少，请发送至少#{ENV['MAX_LENGTH_COMPLAINT_TEXT']}个字符的消息。" if $lg == Cn
    end
    def self.less_then_min_length
        return "Вы ввели недостаточно символов отправьте сообщение длиной от #{ENV['MIN_LENGTH_COMPLAINT_TEXT']} символов" if $lg == Ru 
        return "You have entered too few characters, send a message at least #{ENV['MIN_LENGTH_COMPLAINT_TEXT']} characters long." if $lg == En 
        return "Has introducido demasiados pocos caracteres, envía un mensaje de al menos #{ENV['MIN_LENGTH_COMPLAINT_TEXT']} caracteres de longitud." if $lg == Es 
        return "您输入的字符太少，请发送至少#{ENV['MIN_LENGTH_COMPLAINT_TEXT']}个字符的消息。" if $lg == Cn
    end
    def self.complaint_photos
        return 'Пожалуйста, отправьте нам скриншоты, подтверждающие факт обмана, затем нажмите кнопку "Готово".' if $lg == Ru 
        return 'Please forward the screenshots proving the occurrence of the ripping to us, then select the "That`s it" button.' if $lg == En 
        return 'Por favor, envíenos las capturas de pantalla que demuestren la incidencia de estafa, luego seleccione el botón "Eso es todo".' if $lg == Es 
        return '请将证明欺诈行为的截图转发给我们，然后选择“就是这个”按钮。' if $lg == Cn
    end
    def self.notice_max_photos_size
        return "Максимальное количество фотографий #{ENV['MAX_PHOTOS_AMOUNT']}" if $lg == Ru 
        return "Maximum number of photos #{ENV['MAX_PHOTOS_AMOUNT']}" if $lg == En 
        return "Número máximo de fotos #{ENV['MAX_PHOTOS_AMOUNT']}" if $lg == Es 
        return "最大照片数量 #{ENV['MAX_PHOTOS_AMOUNT']}" if $lg == Cn
    end
    def self.notice_min_photos_size
        return 'Необходимо отправить фото' if $lg == Ru 
        return 'It is necessary to send a photo.' if $lg == En 
        return 'Es necesario enviar una foto.' if $lg == Es 
        return '需要发送照片。' if $lg == Cn
    end
    # def self.less_then_min_photos_size
    #     "Необходимо отправить хотя бы одно фото"
    # end
    def self.handle_photo photos_size
        return "Скриншот №#{photos_size} был успешно добавлен. Вы можете отправить дополнительные скриншоты или нажать кнопку 'Готово'." if $lg == Ru 
        return "Screenshot №#{photos_size} has been successfully added. You may send additional screenshots or click the 'That`s it' button." if $lg == En 
        return "La captura de pantalla №#{photos_size} ha sido agregada exitosamente. Puede enviar más capturas de pantalla o hacer clic en el botón 'Eso es todo'." if $lg == Es 
        return "截图编号#{photos_size}已成功添加。您可以发送更多的截图或点击“就是这个”按钮。" if $lg == Cn
        # "Изображение №#{photos_size} успешно принято, вы можете отправить еще или продолжить подачу жалобы нажав кнопку “Готово”"
    end
    def self.push_ready photos_size
        # return "" if $lg == Ru 
        # return "" if $lg == En 
        # return "" if $lg == Es 
        # return "" if $lg == Cn
        "Изображение №#{photos_size} успешно принято, нажмите 'Готово'"
    end
    def self.require_anothe_format_image
        # return '' if $lg == Ru 
        # return '' if $lg == En 
        # return '' if $lg == Es 
        # return '' if $lg == Cn
        'Отправьте другой формат картинки'
    end
    def self.compare_user_id
        return 'Перешлите нам сообщения от подозреваемого, подтверждающие достоверность скриншотов.' if $lg == Ru 
        return 'Forward to us the messages from the suspected person that back up the legitimacy of the screenshots.' if $lg == En 
        return 'Envíanos los mensajes de la persona sospechosa que respaldan la legitimidad de las capturas de pantalla.' if $lg == Es 
        return '将疑似人员的消息转发给我们，这些消息证实了屏幕截图的合法性。' if $lg == Cn
    end
    def self.user_info user
        return "User info: \nID: #{user.telegram_id} \n#{"First Name: #{user.first_name}\n" if user.first_name.present?}#{"Username: @#{user.username}\n" if user.username.present?}" if $lg == Ru 
        return "User info: \nID: #{user.telegram_id} \n#{"First Name: #{user.first_name}\n" if user.first_name.present?}#{"Username: @#{user.username}\n" if user.username.present?}" if $lg == En 
        return "Información del usuario: \nID: #{user.telegram_id} \n#{"First Name: #{user.first_name}\n" if user.first_name.present?}#{"Username: @#{user.username}\n" if user.username.present?}" if $lg == Es 
        return "用户信息: \nID: #{user.telegram_id} \n#{"Nombre: #{user.first_name}\n" if user.first_name.present?}#{"Nombre de usuario: @#{user.username}\n" if user.username.present?}" if $lg == Cn
    end
    def self.complaint_request_to_moderator complaint
        return "Ваша жалоба #N#{complaint.id} была успешно подана и в настоящее время ожидает рассмотрения. Вы будете уведомлены, как только будет принято решение. ⏳" if $lg == Ru 
        return "Your report #N#{complaint.id} has been successfully submitted and is currently awaiting review. You will be notified as soon as a decision has been made. ⏳" if $lg == En 
        return "Tu informe #N#{complaint.id} se ha enviado con éxito y está esperando revisión. Se te notificará tan pronto como se tome una decisión. ⏳" if $lg == Es 
        return "您的报告＃N#{complaint.id}已成功提交，目前正在等待审查。一旦做出决定，您将立即收到通知。⏳" if $lg == Cn
    end
    def self.moderator_complaint user, complaint
        return '' if $lg == Ru 
        return '' if $lg == En 
        return '' if $lg == Es 
        return '' if $lg == Cn
        %{\n
            <strong>Жалоба</strong> #N#{complaint.id}

<strong>ОТ</strong>
#{Text.user_info(user)}\n
<strong>На</strong>
#{Text.user_info(complaint)}
<strong>Ссылка</strong> <a href='#{complaint.telegraph_link}'>telegraph_link</a>
}
    end
# от модератора
    def self.complaint_published complaint
        return "Ваша жалоба #N#{complaint.id} была рассмотрена и принята модераторами. Вы можете проверить её по <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>ссылке</a>" if complaint.user.lg == Ru 
        return "Your report #N#{complaint.id} has been reviewed and accepted by the moderators. You can check it at the <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>link</a>" if complaint.user.lg == En 
        return "Su queja #N#{complaint.id} ha sido revisada y aceptada por los moderadores. Puede verificarla en el <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>enlace</a>" if complaint.user.lg == Es 
        return "您的投诉 #N#{complaint.id} 已经被版主审查并接受。您可以在链接中查看<a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>它</a>" if complaint.user.lg == Cn
    end
# от модератора
    def self.handle_explanation complaint, potincial_scamer
        return "Жалоба #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\nСсылка: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nСтатус: Отклонена \nПричина: #{complaint.explanation_by_moderator}" if complaint.user.lg == Ru 
        return "Report #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\nDirect Link: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nStatus: Rejected \nReason: #{complaint.explanation_by_moderator}" if complaint.user.lg == En 
        return "Informe #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\nEnlace directo: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nEstado: Rechazado \n<Razón: #{complaint.explanation_by_moderator}" if complaint.user.lg == Es 
        return "报告 #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\n直接链接: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \n状态: 已拒绝 \n原因: #{complaint.explanation_by_moderator}" if complaint.user.lg == Cn
    end
# от юзера
    def self.notify_reject_complaint complaint, potincial_scamer
        return "Жалоба #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\nСсылка: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nСтатус: Отклонена \nПричина: #{complaint.explanation_by_moderator}" if $lg == Ru 
        return "Report #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\nDirect Link: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nStatus: Rejected \nReason: #{complaint.explanation_by_moderator}" if $lg == En 
        return "Informe #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\nEnlace directo: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nEstado: Rechazado \n<Razón: #{complaint.explanation_by_moderator}" if $lg == Es 
        return "报告 #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\n直接链接: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \n状态: 已拒绝 \n原因: #{complaint.explanation_by_moderator}" if $lg == Cn
    end
    def self.notify_access_complaint complaint, potincial_scamer
        return "Жалоба #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\nСсылка: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nСтатус: Одобрена" if $lg == Ru 
        return "Report #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\nDirect Link: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nStatus: Approved" if $lg == En 
        return "Informe #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\nEnlace directo: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nEstado: Aprobado" if $lg == Es 
        return "报告 #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\n直接链接: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \n状态: 已批准" if $lg == Cn
    end
    def self.notify_pending_complaint complaint, potincial_scamer
        return "Жалоба #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\nСсылка: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nСтатус: Рассмотрение" if $lg == Ru 
        return "Report #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\nDirect Link: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nStatus: Under review" if $lg == En 
        return "Informe #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\nEnlace directo: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nEstado: En revisión" if $lg == Es 
        return "报告 #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\n直接链接: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \n状态: 审核中" if $lg == Cn
    end
#############################
    def self.view_complaints telegraph_links
        # return '' if $lg == Ru 
        # return '' if $lg == En 
        # return '' if $lg == Es 
        # return '' if $lg == Cn
        text_body = telegraph_links.map {|link| "\nСсылка:<a href='#{link}'>telegraph_link</a>"}
        return "Вы обнаружены в списке скамеров!" + text_body.join('')
    end
    def self.explain_justification
        return 'Пожалуйста, опишите вашу версию событий!' if $lg == Ru 
        return 'Describe this case from your perspective please! ' if $lg == En 
        return '¡Por favor, describa este caso desde su perspectiva!' if $lg == Es 
        return '请从您的角度描述这个案例！' if $lg == Cn
    end
    def self.justification_already_used
        return 'Ваша заявка находится на рассмотрении!' if $lg == Ru 
        return 'Your appeal is under review!' if $lg == En 
        return '¡Su apelación está bajo revisión!' if $lg == Es 
        return '您的上诉正在审查中！' if $lg == Cn
    end
    def self.justification_request_to_moderator accepted_complaints, scamer
        # return '' if $lg == Ru 
        # return '' if $lg == En 
        # return '' if $lg == Es 
        # return '' if $lg == Cn
        text_body = accepted_complaints.map {|complaint| "\n<strong>Жалоба</strong> #N#{complaint.id}\n<strong>Ссылка</strong> <a href='#{complaint.telegraph_link}'>telegraph_link</a>\n<strong>Ссылка</strong> пост\n\n <b>Объяснение:</b> #{scamer.justification} "}
        if text_body.empty? # решение от администратора, когда не было претензий
            return "Решение принято администратором\n⚖️Оспорить решение⚖️\nОправдание от пользователя:\n" + scamer.justification 
        end

        return "⚖️Оспорить решение⚖️\n" + text_body.join('')
    end
    def self.you_not_scamer
        return 'Ваш аккаунт не ограничен. Против вас не зарегистрировано никаких жалоб. Продолжайте в том же духе!' if $lg == Ru 
        return 'Your account is not subject to any restrictions. There are no pending or approved ripper reports against you. Continue to maintain this standard.' if $lg == En 
        return 'Su cuenta no tiene ninguna restricción. No hemos encontrado informes pendientes ni aprobados de estafas en su contra. Por favor, siga manteniendo esta conducta ejemplar.' if $lg == Es 
        return '您的账户没有任何限制。我们未发现任何针对您的未解决或已经核实的欺诈报告。请继续保持这种合规行为。' if $lg == Cn
        # 'Ура, вы не скамер'
    end
    def self.you_blocked complaint, scamer
        return "Оказывается, вы были добавлены в список кидков! <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>Ссылка</a>" if scamer.lg == Ru 
        return "As it has been determined, you've been added to the ripper list! <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>Link</a>" if scamer.lg == En 
        return "Como se ha determinado, ¡has sido agregado a la lista de estafadores! <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>Enlace</a>" if scamer.lg == Es 
        return "经确定，您已被添加到欺诈者名单中！链<a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>接</a>" if scamer.lg == Cn
        # "Вы заблокированы"
    end
    def self.require_subscribe_channel
        return "Необходимо подписаться на <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}'>канал</a>" if $lg == Ru 
        return "It is necessary to subscribe to the <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}'>channel</a>." if $lg == En 
        return "Es necesario suscribirse al <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}'>canal</a>." if $lg == Es 
        return "需要订阅该频<a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}'>道</a>。" if $lg == Cn
        # "Необходимо подписаться на <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}'>канал</a>"
    end
    def self.verifyed users_data
        return "#{users_data}  - Верифицированный" if $lg == Ru 
        return "#{users_data}  - Verified" if $lg == En 
        return "#{users_data}  - Verificado" if $lg == Es 
        return "#{users_data}  - 已验证" if $lg == Cn
        # проверенный
    end
    def self.not_scamer users_data
        return "#{users_data}  - Не кидок" if $lg == Ru 
        return "#{users_data}  - Not a ripper" if $lg == En 
        return "#{users_data}  - No es una ripper" if $lg == Es 
        return "#{users_data}  - 不是骗局" if $lg == Cn
        # "#{users_data}  - не скамер"
    end
    def self.is_scamer users_data, complaint
        return "#{users_data}  - Кидок. <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>Cсылка</a>." if $lg == Ru 
        return "#{users_data}  - Ripper. <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>Link</a>." if $lg == En 
        return "#{users_data}  - Ripper. <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>Enlace</a>." if $lg == Es 
        return "#{users_data}  - 骗子. <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>它</a>." if $lg == Cn
        # "#{users_data}  - скамер <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>ссылка</a> на пост"
    end

    def self.verifying_user user, status
        # return '' if $lg == Ru 
        # return '' if $lg == En 
        # return '' if $lg == Es 
        # return '' if $lg == Cn
        "#{Text.user_info(user)} \n#{status}"
    end

    def self.verifying_data data, status
        # return '' if $lg == Ru 
        # return '' if $lg == En 
        # return '' if $lg == Es 
        # return '' if $lg == Cn
        "#{data} #{status}"
    end
    def self.support
        return 'Связаться с поддержкой' if $lg == Ru 
        return 'Contact Support Service' if $lg == En 
        return 'Contactar con el Servicio de Soporte' if $lg == Es 
        return '联系支持服务' if $lg == Cn
        # 'Связаться c поддержкой'
    end
    def self.oracle_tips
        'Oracle`s Tips'
    end
























    def self.date_time_now date_time_now
        "Сейчас #{date_time_now}"
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
        'Че по чем?'
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