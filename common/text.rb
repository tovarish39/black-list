module Text
  # !
  def self.lang = "✈️ Выбрать язык бота\n✈️ Select the bot`s language\n✈️ Seleccionar el idioma del bot\n✈️ 选择机器人的语言"

  # !
  def self.greet
    if $lg == Ru
      return "Привет, чувак! \n\nДобро пожаловать в Oracle`s Rippers List Bot. Этот бот - часть сети Oracle. Он создан для того, чтобы защитить тебя от мошенников пополной! Здесь ты можешь подать жалобу на кидал, узнать информацию о твоем партнере, получить данные аккаунта в Telegram и многое другое. \n\nОкажи себе услугу, и посмотри видео выше, чтобы полностью разобраться в том, как использовать этого бота. \n\n💡 Если его правильно использовать, это серьёзно сыграет тебе наруку."
    end
    if $lg == En
      return "Hey, man! \n\nWelcome to the Oracle's Rippers List Bot. This bot is part of the Oracle's Network, designed to keep you safe from rippers - like a 99% ripper-free guarantee! It'll let you report rippers, dig up info on your partner, get Telegram account details, and so much more. \n\n💡 Do yourself a favor and check out the video above for the full scoop on how to use this bot. It's a game-changer thing, if you will use it in a proper way."
    end
    if $lg == Es
      return "¡Hola, amigo! \n\nBienvenido al bot de la Lista de Estafadores de Oracle. Este bot es parte de la Red de Oracle, diseñado para mantenerte seguro de los estafadores - ¡como una garantía del 99% libre de estafadores! Te permitirá reportar estafadores, obtener información sobre tu pareja, obtener detalles de la cuenta de Telegram, y mucho más. \n\n💡 Hazte un favor y revisa el video de arriba para obtener toda la información sobre cómo usar este bot. Si lo usas correctamente, es algo que puede cambiar el juego."
    end
    return unless $lg == Cn

    "嘿，伙计！欢迎使用Oracle的骗子名单机器人。这个机器人是Oracle网络的一部分，旨在让你远离骗子——就像有99%的保证让你远离骗子一样！它会让你举报骗子，挖掘关于你的伙伴的信息，获取Telegram账户的详细信息，以及更多。 \n\n你应该对自己好点，看看上面的视频，以了解如何使用这个机器人的全部信息。 \n\n💡 如果你正确使用它，它将成为改变游戏规则的东西。"
  end

  # !
  def self.clear_account
    if $lg == Ru
      return "💎 Вы не были обнаружены в списке скамеров. \n\nТак держать! Если же вы хотите пройти верификацию, и получить статус верифицированного или проверенного продавца, свяжитесь с @oraclesupport"
    end
    if $lg == En
      return "💎 You were not found on the scammers' list. \n\nKeep it up! If you want to undergo verification and obtain the status of a verified or trusted seller, contact @oraclesupport."
    end
    if $lg == Es
      return "💎 No fue encontrado en la lista de estafadores. \n\n¡Sigue así! Si desea pasar por una verificación y obtener el estado de vendedor verificado o confiable, contacte a @oraclesupport."
    end

    "💎 您没有被列入骗子名单。 \n\n继续保持！如果您想要进行验证并获得已验证或受信任的卖家的身份，请联系@oraclesupport。" if $lg == Cn
    # 'Вы не находитесь в списке скамеров!'
  end

  # !
  def self.search_user
    return 'Отправьте нам ID/@username подозреваемого. Или выберите его из списка.' if $lg == Ru
    return "Send us the suspect person's ID/@username. Or choose the chat with the feature below." if $lg == En
    return 'Envíenos la ID/@username del sospechoso.' if $lg == Es

    '请发送嫌疑人的ID给我们。' if $lg == Cn
  end

  # !
  def self.not_found
    return '🔴 Пользователь не найден' if $lg == Ru
    return '🔴 User not found' if $lg == En
    return '🔴 Usuario no encontrado' if $lg == Es

    '🔴 用户未找到' if $lg == Cn
  end

  # !
  def self.complaint_text
    if $lg == Ru
      return "Пожалуйста, кратко изложите ситуацию. \n\nУбедитесь, что ваше описание кратко и находится в диапазоне от #{ENV['MIN_LENGTH_COMPLAINT_TEXT']} до #{ENV['MAX_LENGTH_COMPLAINT_TEXT']} символов."
    end
    if $lg == En
      return "Please provide a brief explanation of the situation. \n\nEnsure your description is succinct and falls within #{ENV['MIN_LENGTH_COMPLAINT_TEXT']} to #{ENV['MAX_LENGTH_COMPLAINT_TEXT']} characters."
    end
    if $lg == Es
      return "Por favor, proporciona una breve explicación de la situación. \n\nAsegúrate de que tu descripción sea concisa y esté entre #{ENV['MIN_LENGTH_COMPLAINT_TEXT']} y #{ENV['MAX_LENGTH_COMPLAINT_TEXT']} caracteres."
    end
    return unless $lg == Cn

    "请简要说明情况。 \n\n请确保您的描述简洁并且在#{ENV['MIN_LENGTH_COMPLAINT_TEXT']}至#{ENV['MAX_LENGTH_COMPLAINT_TEXT']}个字符之间。"
  end

  # !
  def self.more_then_max_length
    if $lg == Ru
      return "🗒 Вы превысили лимит длины сообщения, отправьте сообщение длиной до #{ENV['MAX_LENGTH_COMPLAINT_TEXT']} символов"
    end
    if $lg == En
      return "🗒 You have exceeded the character limit, send a message up to #{ENV['MAX_LENGTH_COMPLAINT_TEXT']} characters long."
    end
    if $lg == Es
      return "🗒 Has introducido demasiados pocos caracteres, envía un mensaje de al menos#{ENV['MAX_LENGTH_COMPLAINT_TEXT']} caracteres de longitud."
    end

    "🗒 您输入的字符太少，请发送至少#{ENV['MAX_LENGTH_COMPLAINT_TEXT']}个字符的消息。" if $lg == Cn
  end

  # !
  def self.less_then_min_length
    if $lg == Ru
      return "📝 Вы ввели слишком короткое сообщение. Введите сообщение длиной минимум #{ENV['MIN_LENGTH_COMPLAINT_TEXT']} символов"
    end
    if $lg == En
      return "📝 You have entered too few characters, send a message at least #{ENV['MIN_LENGTH_COMPLAINT_TEXT']} characters long."
    end
    if $lg == Es
      return "📝 Has introducido demasiados pocos caracteres, envía un mensaje de al menos #{ENV['MIN_LENGTH_COMPLAINT_TEXT']} caracteres de longitud."
    end

    "📝 您输入的字符太少，请发送至少#{ENV['MIN_LENGTH_COMPLAINT_TEXT']}个字符的消息。" if $lg == Cn
  end

  # !
  def self.complaint_photos
    if $lg == Ru
      return 'Пожалуйста, отправьте нам скриншоты, подтверждающие факт обмана, затем нажмите кнопку "Готово".'
    end
    if $lg == En
      return 'Please forward the screenshots proving the occurrence of the ripping to us, then select the "That`s it" button.'
    end
    if $lg == Es
      return 'Por favor, envíenos las capturas de pantalla que demuestren la incidencia de estafa, luego seleccione el botón "Eso es todo".'
    end

    '请将证明欺诈行为的截图转发给我们，然后选择“就是这个”按钮。' if $lg == Cn
  end

  # !
  def self.notice_max_photos_size
    return "🦷 Максимальное количество фото #{ENV['MAX_PHOTOS_AMOUNT']}" if $lg == Ru
    return "🦷 Maximum number of photos #{ENV['MAX_PHOTOS_AMOUNT']}" if $lg == En
    return "🦷 Número máximo de fotos #{ENV['MAX_PHOTOS_AMOUNT']}" if $lg == Es

    "🦷 最大照片数量 #{ENV['MAX_PHOTOS_AMOUNT']}" if $lg == Cn
  end

  # !
  def self.notice_min_photos_size
    return 'Вы должны отправить как минимум 1 фото.' if $lg == Ru
    return 'It is necessary to send a photo.' if $lg == En
    return 'Es necesario enviar una foto.' if $lg == Es

    '需要发送照片。' if $lg == Cn
  end

  # def self.less_then_min_photos_size
  #     "Необходимо отправить хотя бы одно фото"
  # end
  # !
  def self.handle_photo(photos_size)
    if $lg == Ru
      return "Скриншот №#{photos_size} был успешно добавлен. Вы можете отправить дополнительные скриншоты или нажать кнопку \"Готово\"."
    end
    if $lg == En
      return "Screenshot №#{photos_size} has been successfully added. You may send additional screenshots or click the 'That`s it' button."
    end
    if $lg == Es
      return "La captura de pantalla №#{photos_size} ha sido agregada exitosamente. Puede enviar más capturas de pantalla o hacer clic en el botón 'Eso es todo'."
    end

    "截图编号#{photos_size}已成功添加。您可以发送更多的截图或点击“就是这个”按钮。" if $lg == Cn
    # "Изображение №#{photos_size} успешно принято, вы можете отправить еще или продолжить подачу жалобы нажав кнопку “Готово”"
  end

  # !
  def self.handle_last_photo(photos_size)
    return "Скриншот №#{photos_size} был успешно добавлен." if $lg == Ru
    return "Screenshot №#{photos_size} has been successfully added." if $lg == En
    return "La captura de pantalla №#{photos_size} ha sido agregada exitosamente." if $lg == Es

    "截图编号#{photos_size}已成功添加。" if $lg == Cn
  end

  # !
  def self.push_ready
    return '⛑ Достигнут лимит изображений!' if $lg == Ru
    return '⛑ Image limit reached!' if $lg == En
    return '⛑ ¡Límite de imágenes alcanzado!' if $lg == Es

    '⛑ 已达到图片限制！' if $lg == Cn
    # "Изображение №#{photos_size} успешно принято, нажмите \"Готово\""
  end

  # !
  def self.require_anothe_format_image
    return 'Пожалуйста, отправьте скришот повторно в формате сжатого изображения. 🖼' if $lg == Ru
    return 'Please resend the screenshot in a compressed image format. 🖼' if $lg == En
    return 'Por favor, reenvíe la captura de pantalla en formato de imagen comprimida. 🖼' if $lg == Es

    '请以压缩图像格式重新发送截图。 🖼' if $lg == Cn
    # 'Отправьте другой формат картинки'
  end

  # !
  def self.compare_user_id
    return 'Перешлите нам сообщения от подозреваемого, подтверждающие достоверность скриншотов.' if $lg == Ru
    if $lg == En
      return 'Forward to us the messages from the suspected person that back up the legitimacy of the screenshots.'
    end
    if $lg == Es
      return 'Envíanos los mensajes de la persona sospechosa que respaldan la legitimidad de las capturas de pantalla.'
    end

    '将疑似人员的消息转发给我们，这些消息证实了屏幕截图的合法性。' if $lg == Cn
  end

  # !
  def self.complaint_request_to_moderator(complaint)
    if $lg == Ru
      return "Ваша жалоба #N#{complaint.id} была успешно подана и в настоящее время ожидает рассмотрения. Вы будете уведомлены, как только будет принято решение. ⏳"
    end
    if $lg == En
      return "Your report #N#{complaint.id} has been successfully submitted and is currently awaiting review. You will be notified as soon as a decision has been made. ⏳"
    end
    if $lg == Es
      return "Tu informe #N#{complaint.id} se ha enviado con éxito y está esperando revisión. Se te notificará tan pronto como se tome una decisión. ⏳"
    end

    "您的报告＃N#{complaint.id}已成功提交，目前正在等待审查。一旦做出决定，您将立即收到通知。⏳" if $lg == Cn
  end

  # !
  def self.notify_request_complaints(complaint, potincial_scamer)
    status = Text.complaint_status complaint
    if $lg == Ru
      return "🧸 Report #N#{complaint.id} \nОт\n#{Text.user_info_without_prefix($user)} \nНа\n#{Text.user_info_without_prefix(potincial_scamer)} \nСсылка: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nСтатус: #{status}"
    end
    if $lg == En
      return "🧸 Report #N#{complaint.id} \nFrom\n#{Text.user_info_without_prefix($user)} \nAgainst\n#{Text.user_info_without_prefix(potincial_scamer)} \nLink: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nStatus: #{status}"
    end
    if $lg == Es
      return "🧸 Informe #N#{complaint.id} \nDe\n#{Text.user_info_without_prefix($user)} \nContra\n#{Text.user_info_without_prefix(potincial_scamer)} \nEnlace: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nEstado: #{status}"
    end
    return unless $lg == Cn

    "🧸 报告 #N#{complaint.id} \n来自\n#{Text.user_info_without_prefix($user)} \n针对\n#{Text.user_info_without_prefix(potincial_scamer)} \n链接: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \n状态: #{status}"
  end

  # !
  def self.become_scamer
    if $lg == Ru
      return "💔💔💔 Вы были обнаружены в списке кидков!  💔💔💔 \n\n🚸 Опротестуйте решение модератора, чтобы восстановить своё честное имя и опубликовать опровержение!"
    end
    if $lg == En
      return "💔💔💔 You have been found on the list of rippers! 💔💔💔 \n\n🚸 Appeal the moderator's decision to restore your honest name and post a rebuttal!"
    end
    if $lg == Es
      return "💔💔💔 ¡Has sido encontrado en la lista de rippers! 💔💔💔 \n\n🚸 ¡Apela la decisión del moderador para restaurar tu nombre honesto y publicar una refutación!"
    end

    "💔💔💔 您已被列入欺诈者名单！ 💔💔💔 \n\n🚸 上诉版主的决定，恢复您的清白名誉并发布反驳！" if $lg == Cn
  end

  # !
  def self.view_complaints(telegraph_links)
    text_body = telegraph_links.map { |link| "\n#{Text.link}: <a href='#{link}'>telegraph_link</a>\n" }
    if $lg == Ru
      return "⛔️ We have found the ongoing claim against you! If you believe this to be false, please let us know and file an appeal against this report. \n\n#{text_body.join('')}"
    end
    if $lg == En
      return "⛔️ We have found the ongoing claim against you! If you believe this to be false, please let us know and file an appeal against this report. \n\n#{text_body.join('')}"
    end
    if $lg == Es
      return "⛔️ We have found the ongoing claim against you! If you believe this to be false, please let us know and file an appeal against this report. \n\n#{text_body.join('')}"
    end
    return unless $lg == Cn

    "⛔️ We have found the ongoing claim against you! If you believe this to be false, please let us know and file an appeal against this report. \n\n#{text_body.join('')}"

    # text_body = telegraph_links.map {|link| "\n#{Text.link}: <a href='#{link}'>telegraph_link</a>\n"}
    # return "⚠️ Вы обнаружены в списке скамеров! \n\n#{text_body.join('')}" if $lg == Ru
    # return "⚠️ You have been found on the scammers' list! \n\n#{text_body.join('')}" if $lg == En
    # return "⚠️ ¡Has sido encontrado en la lista de rippers! \n\n#{text_body.join('')}" if $lg == Es
    # return "⚠️ 您被发现在骗子名单上！ \n\n#{text_body.join('')}" if $lg == Cn
  end

  # !
  def self.explain_justification
    return '🌐 Пожалуйста, опишите вашу версию событий!' if $lg == Ru
    return '🌐 Describe this case from your perspective please! ' if $lg == En
    return '🌐 ¡Por favor, describa este caso desde su perspectiva!' if $lg == Es

    '🌐 请从您的角度描述这个案例！' if $lg == Cn
  end

  # !
  def self.justification_already_used
    return '⚜️ Ваша заявка находится на рассмотрении!' if $lg == Ru
    return '⚜️ Your appeal is under review!' if $lg == En
    return '⚜️ ¡Su apelación está bajo revisión!' if $lg == Es

    '⚜️ 您的上诉正在审查中！' if $lg == Cn
    # return 'Ваша заявка находится на рассмотрении!' if $lg == Ru
  end

  # !
  # от модератора
  def self.complaint_published(complaint)
    if complaint.user.lg == Ru
      return "💕 Ваша жалоба #N#{complaint.id} была рассмотрена и принята модераторами. Вы можете проверить её по <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>ссылке</a>"
    end
    if complaint.user.lg == En
      return "💕 Your report #N#{complaint.id} has been reviewed and accepted by the moderators. You can check it at the <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>link</a>"
    end
    if complaint.user.lg == Es
      return "💕 Su queja #N#{complaint.id} ha sido revisada y aceptada por los moderadores. Puede verificarla en el <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>enlace</a>"
    end
    return unless complaint.user.lg == Cn

    "💕 您的投诉 #N#{complaint.id} 已经被版主审查并接受。您可以在链接中查看<a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>它</a>"
  end

  # !
  # от модератора
  def self.handle_explanation_self(complaint, potincial_scamer)
    if complaint.user.lg == Ru
      return "Жалоба #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\nСсылка: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nСтатус: Отклонена \nПричина: #{complaint.explanation_by_moderator}"
    end
    if complaint.user.lg == En
      return "Report #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\nDirect Link: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nStatus: Rejected \nReason: #{complaint.explanation_by_moderator}"
    end
    if complaint.user.lg == Es
      return "Informe #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\nEnlace directo: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nEstado: Rechazado \nRazón: #{complaint.explanation_by_moderator}"
    end
    if complaint.user.lg == Cn
      return "报告 #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\n直接链接: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \n状态: 已拒绝 \n原因: #{complaint.explanation_by_moderator}"
    end

    "Жалоба #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\nСсылка: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nСтатус: Отклонена \nПричина: #{complaint.explanation_by_moderator}"
  end

  # !
  def self.handle_explanation_to_user(complaint, potincial_scamer)
    if complaint.user.lg == Ru
      return "Жалоба #N#{complaint.id} \n#{Text.user_info(potincial_scamer)} \nВаша жалоба была отклонена. \nПричина: #{complaint.explanation_by_moderator}"
    end
    if complaint.user.lg == En
      return "Report #N#{complaint.id} \n#{Text.user_info(potincial_scamer)} \nYour complaint has been rejected. \nReason: #{complaint.explanation_by_moderator}"
    end
    if complaint.user.lg == Es
      return "Informe #N#{complaint.id} \n#{Text.user_info(potincial_scamer)} \nTu queja ha sido rechazada. \nRazón: #{complaint.explanation_by_moderator}"
    end
    return unless complaint.user.lg == Cn

    "报告 #N#{complaint.id} \n#{Text.user_info(potincial_scamer)} \n你的投诉已被拒绝。 \n原因: #{complaint.explanation_by_moderator}"
  end

  # !
  def self.you_not_scamer(scamer)
    if scamer.lg == Ru
      return "❎ Ваш аккаунт не ограничен. Против вас не зарегистрировано никаких жалоб. \n\nПродолжайте в том же духе!"
    end
    if scamer.lg == En
      return "❎ Your account is not subject to any restrictions. There are no pending or approved ripper reports against you. \n\nContinue to maintain this standard."
    end
    if scamer.lg == Es
      return "❎ Su cuenta no tiene ninguna restricción. No hemos encontrado informes pendientes ni aprobados de estafas en su contra. \n\nPor favor, siga manteniendo esta conducta ejemplar."
    end

    "❎ 您的账户没有任何限制。我们未发现任何针对您的未解决或已经核实的欺诈报告。 \n\n请继续保持这种合规行为。" if scamer.lg == Cn
    # 'Ура, вы не скамер'
  end

  # !
  def self.you_blocked(complaint, scamer)
    if scamer.lg == Ru
      return "👁‍🗨 Оказывается, вы были добавлены в список кидков! <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>Ссылка</a>"
    end
    if scamer.lg == En
      return "👁‍🗨 As it has been determined, you've been added to the ripper list! <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>Link</a>"
    end
    if scamer.lg == Es
      return "👁‍🗨 Como se ha determinado, ¡has sido agregado a la lista de estafadores! <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>Enlace</a>"
    end
    return unless scamer.lg == Cn

    "👁‍🗨 经确定，您已被添加到欺诈者名单中！链<a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>接</a>"

    # "Вы заблокированы"
  end

  # !
  def self.require_subscribe_channel
    return "☢️ Подпишитесь на канал <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}'>канал</a>! Быстро!" if $lg == Ru
    if $lg == En
      return "☢️ It is necessary to subscribe to the <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}'>channel</a>."
    end
    return "☢️ Es necesario suscribirse al <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}'>canal</a>." if $lg == Es

    "☢️ 需要订阅该频<a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}'>道</a>。" if $lg == Cn
    # "Необходимо подписаться на <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}'>канал</a>"
  end

  # !
  def self.verifyed(users_data)
    return "#{users_data}  - ⚜️ Верифицированный" if $lg == Ru
    return "#{users_data}  - ⚜️ Verified" if $lg == En
    return "#{users_data}  - ⚜️ Verificado" if $lg == Es

    "#{users_data}  - ⚜️ 已验证" if $lg == Cn
    # проверенный
  end

  # !
  def self.not_scamer(users_data)
    return "#{users_data}  - ✅ Мужик (не кидок)" if $lg == Ru
    return "#{users_data}  - ✅ Not a ripper" if $lg == En
    return "#{users_data}  - ✅ No es una ripper" if $lg == Es

    "#{users_data}  - ✅ 不是骗局" if $lg == Cn
    # "#{users_data}  - не скамер"
  end

  # !
  def self.is_scamer(users_data, complaint)
    if $lg == Ru
      return "#{users_data}  - 🚫 Кидок. <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>Cсылка</a>."
    end
    if $lg == En
      return "#{users_data}  - 🚫 Ripper. <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>Link</a>."
    end
    if $lg == Es
      return "#{users_data}  - 🚫 Ripper. <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>Enlace</a>."
    end
    return unless $lg == Cn

    "#{users_data}  - 🚫 骗子. <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>它</a>."

    # "#{users_data}  - скамер <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>ссылка</a> на пост"
  end



  def self.verifying_data(data, status)
    # return '' if $lg == Ru
    # return '' if $lg == En
    # return '' if $lg == Es
    # return '' if $lg == Cn
    "\n#{data} #{status} <a href='#{ENV['ORACLE_LIST']}'>@oraclelist</a>"
    # "\n#{data} #{status} <a href='https://t.me/ripperlistbot'>@oraclelist</a>"
  end

  # !
  def self.support
    if $lg == Ru
      return "<b>Вы можете связаться с поддержкой Oracle для решения экстренных вопросов, подачи заявлений на верификацию, по вопросам сотрудничества и прочему. \n\nПожалуйста, подавайте ваши жалобы с помощью интерфейса бота, а не через службу поддержки.</b>"
    end
    if $lg == En
      return "<b>You can contact Oracle support for urgent matters, to apply for verification, for collaboration inquiries, and more. \n\nPlease submit your reports using the bot interface, not through the support service.</b>"
    end
    if $lg == Es
      return "<b>Puede ponerse en contacto con el soporte de Oracle para asuntos urgentes, para solicitar verificación, para consultas de colaboración y más. \n\nPor favor, envíe sus informes utilizando la interfaz del bot, no a través del servicio de soporte.</b>"
    end

    "<b>您可以联系Oracle支持解决紧急问题、申请验证、合作咨询等。\n\n请通过机器人界面提交您的报告，而不是通过支持服务。</b>" if $lg == Cn
    # 'Связаться c поддержкой'
  end

  # !
  def self.oracle_tips
    if $lg == Ru
      return "<b>Каждый день мы получаем десятки репортов о кидке. Но по-настоящему изящных кидков из них не более 10%. Остальные 90% кидков работают по древним и тупым схемам. \n\nВы можете защить себя, подробно изучив наши инструкции и советы по безопасной работе в Telegram в разделе Oracle's Tips.</b>"
    end
    if $lg == En
      return "<b>Every day, we receive dozens of scam reports. However, only about 10% of them are truly sophisticated scams. The other 90% operate on old and dull schemes. \n\nYou can protect yourself from these by thoroughly studying our instructions and safety tips for working in Telegram under the Oracle's Tips section.</b>"
    end
    if $lg == Es
      return "<b>Todos los días recibimos decenas de informes de estafas. Sin embargo, solo alrededor del 10% de ellos son estafas verdaderamente sofisticadas. El otro 90% opera con esquemas antiguos y simplones. \n\nPuede protegerse de estos estudiando detalladamente nuestras instrucciones y consejos de seguridad para trabajar en Telegram en la sección Consejos de Oracle."
    end
    return unless $lg == Cn

    "<b>我们每天都收到数十份有关欺诈的报告。但其中真正精细的欺诈只占大约10%。其他90%的欺诈都是使用古老且愚蠢的手段。 \n\n您可以通过仔细研究我们在Oracle's Tips部分的Telegram安全工作指南和建议来保护自己免受这些欺诈的侵害。</b>"
  end

  # !
  def self.option_details
    if $lg == Ru
      return '👹 <b>Пожалуйста, прикрепите всю доступную вам информацию о человеке, включая его платежные реквизиты, ники, имена, голосовые сообщение, IP адреса, скриншоты его экрана, отправленные им кружочки, и прочую информацию.</b>'
    end
    if $lg == En
      return '👹 <b>Please provide all available information about the person, including their payment details, nicknames, names, voice messages, IP addresses, screenshots of their screen, circles sent by them, and other information.</b>'
    end
    if $lg == Es
      return '👹 <b>Por favor, adjunte toda la información disponible que tenga sobre la persona, incluyendo sus datos de pago, apodos, nombres, mensajes de voz, direcciones IP, capturas de pantalla de su pantalla, los círculos enviados por él y otra información relevante.</b>'
    end

    '👹 <b>请提供您所掌握的有关此人的所有信息，包括支付数据、昵称、姓名、语音消息、IP地址、屏幕截图、他发送的圆圈等其他相关信息。</b>' if $lg == Cn
  end

  # !
  def self.to_userbot
    if $lg == Ru
      return '⛳️ Пожалуйста, выберите чат с человеком, которого хотите проверить. Так же, вы можете отправь ссылку на аккаунт или ІD.'
    end
    if $lg == En
      return '⛳️ Please select the chat with the person you want to check. Also, you can send a link to the account or ID.'
    end
    if $lg == Es
      return '⛳️ Por favor, seleccione el chat con la persona que desea verificar. También puede enviar un enlace a la cuenta o ID.'
    end

    '⛳️ 请选择您想要检查的人的聊天。您也可以发送账户链接或ID。' if $lg == Cn
  end

  # !
  def self.checking
    return '♾ Проверяем...' if $lg == Ru
    return '♾ Checking...' if $lg == En
    return '♾ Verificando...' if $lg == Es

    '♾ 正在检查...' if $lg == Cn
  end

  def self.not_availible
    'Сервис временно недоступен'
  end

  def self.publication_in_channel(complaint, scammer, invite_link_data)
    %(NEW REPORT #N#{complaint.id}
#{"@#{scammer.username} " if scammer.username.present?}suspect · 嫌疑人 · sospechoso · подозреваемый

<a href='#{complaint.telegraph_link}'>#{complaint.telegraph_link}</a>

#{"#{"<b>ID:</b> <code>#{scammer.telegram_id}</code>" if scammer.telegram_id}"}

⚠️ IN REVIEW · 审核中 · EN REVISIÓN · EN COURS D'EXAMEN · НА РАССМОТРЕНИИ

🛡 <a href='#{ENV['TO_SUBMIT_AN_APPEAL_CONTACT_US']}'>TO SUBMIT AN APPEAL, CONTACT US</a>

<a href='#{ENV['ORACLE_LIST']}'>@oraclelist</a>

#{"<a href='#{invite_link_data['invite_link']}'>additional information</a>" if invite_link_data['result'] === 'success'}
    )
  end

  # old
  # def self.publication_in_channel complaint, scammer, invite_link_data
  #     %{NEW REPORT #N#{complaint.id}
  #     #{"@#{scammer.username} " if scammer.username.present?}ripper · 骗子 · scammer

  #     <a href='#{complaint.telegraph_link}'>Link</a>

  #     #{"#{"<b>ID:</b> <code>#{scammer.telegram_id}</code>" if scammer.telegram_id}"}

  #     ✅ APPROVED · 已确认 · SE CONFIRMA · CONFIRMÉ

  #     🛡 <a href='#{ENV['MAIN_BOT_LINK']}'>SUBMIT A REPORT OR AN APPEAL</a>

  #     <a href='#{ENV['ORACLE_LIST']}'>@oraclelist</a>

  #     #{"<a href='#{invite_link_data['invite_link']}'>additional information</a>" if invite_link_data['result'] === 'success'}
  #         }
  #         end

  # !
  def self.notify_already_has_requesting_complaint
    if $lg == Ru
      return "🥴 На выбранного пользователя уже была отправлена жалоба.\n\nВ данный момент она на рассмотрении. В случае её отклонения модератором, появится возможность отправлять новую жалобу."
    end
    if $lg == En
      return "🥴 A complaint has already been filed against the selected user.\n\nCurrently, it is under review. If it is rejected by the moderator, you will have the opportunity to submit a new complaint."
    end
    if $lg == Es
      return "🥴 Ya se ha presentado una queja contra el usuario seleccionado.\n\nActualmente, está en revisión. Si es rechazada por el moderador, tendrás la oportunidad de presentar una nueva queja."
    end
    return "🥴 对所选用户已经提交了投诉。\n\n目前正在审查中。如果被管理员拒绝，您将有机会提交新的投诉。" if $lg == Cn

    "🥴 На выбранного пользователя уже была отправлена жалоба.\n\nВ данный момент она на рассмотрении. В случае её отклонения модератором, появится возможность отправлять новую жалобу."
  end

  # !
  def self.notify_already_scammer_status
    if $lg == Ru
      return "Выбранный пользователь находится в списке скамеров.\n\nНовые жалобы можно будет отправлять, после того как текущая претензия будет снята."
    end
    if $lg == En
      return "The selected user is on the scammers list.\n\nYou will be able to file new complaints after the current claim is lifted."
    end
    if $lg == Es
      return "El usuario seleccionado está en la lista de estafadores.\n\nPodrás presentar nuevas quejas una vez que se retire la reclamación actual."
    end
    return "所选用户在骗子名单上。\n\n在当前索赔解除后，您将能够提交新的投诉。" if $lg == Cn

    "Выбранный пользователь находится в списке скамеров.\n\nНовые жалобы можно будет отправлять, после того как текущая претензия будет снята."
  end

  # !
  def self.media_data_getted
    return "✍🏽 Данные приняты, вы можете отправить дополнительную информацию, или нажать кнопку 'Готово'." if $lg == Ru
    if $lg == En
      return "✍🏽 Your information has been received. You can send additional information or click the 'That`s it' button."
    end
    if $lg == Es
      return "✍🏽 Hemos recibido tu información. Puedes enviar información adicional o hacer clic en el botón 'Listo'."
    end
    return '✍🏽 我们已收到您的信息。您可以发送附加信息或点击“完成”按钮。' if $lg == Cn

    "✍🏽 Данные приняты, вы можете отправить дополнительную информацию, или нажать кнопку 'Готово'."
  end

  def self.private_channel_post_text
    "If you possess additional information regarding this individual, please promptly contact the moderator at <a href='#{ENV['ORACLE_LIST']}'>@oraclelist</a>. We would greatly appreciate your assistance in sharing any details about this person. \n\nLet's make Telegram free of brokes. \n\n<a href='#{ENV['ORACLE_LIST']}'>@oraclelist</a>"
  end

  def self.private_channel_post_video_caption
    %(Are you tired of hams around? Have you been ripped twice during last week?

Even the most popular ripper walls are scamming now...

Follow our brand new Rippers Wall  -  <a href='#{ENV['ORACLE_LIST']}'>ORACLE BLACK LIST</a>

Learn how to avoid rippers and doing your business in a safe way with <a href='#{ENV['ORACLES_TIPS_PATH']}'>ORACLE'S TIPS</a>

Check trusted and verifed <a href='#{ENV['SELLERS_WHITELIST']}'>SELLERS' WHITELIST</a>

DONT LET LOW LIFE SCAMMERS FOOL YOU

<a href='#{ENV['SUBMIT_AN_APPLICATION']}'>SUBMIT AN APPLICATION</a>

<a href='#{ENV['SUPPORT_PATH']}'>CONTACT SUPPORT</a>

<a href='#{ENV['ORACLE_LIST']}'>BLACK LIST</a>


<u><i><a href='#{ENV['ORACLE_LIST']}'>O  R  A  C  L  E        L  I  S  T</a></i></u>
    )
  end
  # !

  def self.user_info_word
    return 'User info:' if $lg == Ru
    return 'User info:' if $lg == En
    return 'Información del usuario:' if $lg == Es
    return '用户信息:' if $lg == Cn

    'User info:'
  end

  def self.user_info(user)
    return "#{Text.user_info_word} #{if user.telegram_id.present?
                                       "\n#{Text.id} #{user.telegram_id}"
                                     end}#{if user.first_name.present?
                                             "\n#{Text.first_name} #{user.first_name}"
                                           end}#{"\n#{Text.username} @#{user.username}\n" if user.username.present?}"
    "User info: #{if user.telegram_id.present?
                    "\nID: #{user.telegram_id}"
                  end}#{if user.first_name.present?
                          "\nFirst Name: #{user.first_name}"
                        end}#{if user.username.present?
                                                                                     "\nUsername: @#{user.username}"
                                                                                   end}\n"
  end

  # от юзера
  def self.complaint_status(complaint)
    status = complaint.status

    if $lg == Ru
      return 'одобрена' if status == 'accepted_complaint'
      return 'отклонена' if status == 'rejected_complaint'

      'на рассмотрении' if status == 'request_to_moderator'
    elsif $lg == En
      return 'Approved' if status == 'accepted_complaint'
      return 'Rejected' if status == 'rejected_complaint'

      'Under Review' if status == 'request_to_moderator'
    elsif $lg == Es
      return 'Aprobado' if status == 'accepted_complaint'
      return 'Rechazado' if status == 'rejected_complaint'

      'En revisión' if status == 'request_to_moderator'
    elsif $lg == Cn
      return '已批准' if status == 'accepted_complaint'
      return '已拒绝' if status == 'rejected_complaint'

      '审核中' if status == 'request_to_moderator'
    end
  end

  def self.id
    return 'ID:' if $lg == Ru
    return 'ID:' if $lg == En
    return 'ID:' if $lg == Es
    return 'ID:' if $lg == Cn

    'ID:'
  end

  def self.first_name
    return 'First Name:' if $lg == Ru
    return 'First Name:' if $lg == En
    return 'Nombre:' if $lg == Es
    return '名字:' if $lg == Cn

    'First Name:'
  end

  def self.username
    return 'Username:' if $lg == Ru
    return 'Username:' if $lg == En
    return 'Nombre de usuario:' if $lg == Es
    return '用户名:' if $lg == Cn

    'Username:'
  end

  def self.user_info_without_prefix(user)
    return "#{if user.telegram_id.present?
                "\n#{Text.id} #{user.telegram_id}"
              end}#{if user.first_name.present?
                      "\n#{Text.first_name} #{user.first_name}"
                    end}#{if user.username.present?
                                                                                        "\n#{Text.username} @#{user.username}\n"
                                                                                      end}"
    "User info: #{if user.telegram_id.present?
                    "\nID: #{user.telegram_id}"
                  end}#{if user.first_name.present?
                          "\nFirst Name: #{user.first_name}"
                        end}#{if user.username.present?
                                                                                     "\nUsername: @#{user.username}"
                                                                                   end}\n"
  end

  # def self.notify_reject_complaint complaint, potincial_scamer
  #     return "Жалоба #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\nСсылка: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nСтатус: Отклонена \nПричина: #{complaint.explanation_by_moderator}" if $lg == Ru
  #     return "Report #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\nDirect Link: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nStatus: Rejected \nReason: #{complaint.explanation_by_moderator}" if $lg == En
  #     return "Informe #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\nEnlace directo: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nEstado: Rechazado \nRazón: #{complaint.explanation_by_moderator}" if $lg == Es
  #     return "报告 #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\n直接链接: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \n状态: 已拒绝 \n原因: #{complaint.explanation_by_moderator}" if $lg == Cn
  # end
  # def self.notify_access_complaint complaint, potincial_scamer
  #     return "Жалоба #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\nСсылка: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nСтатус: Одобрена" if $lg == Ru
  #     return "Report #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\nDirect Link: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nStatus: Approved" if $lg == En
  #     return "Informe #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\nEnlace directo: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nEstado: Aprobado" if $lg == Es
  #     return "报告 #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\n直接链接: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \n状态: 已批准" if $lg == Cn
  # end
  # def self.notify_pending_complaint complaint, potincial_scamer
  #     return "Жалоба #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\nСсылка: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nСтатус: Рассмотрение" if $lg == Ru
  #     return "Report #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\nDirect Link: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nStatus: Under review" if $lg == En
  #     return "Informe #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\nEnlace directo: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \nEstado: En revisión" if $lg == Es
  #     return "报告 #N#{complaint.id}\n#{Text.user_info(potincial_scamer)}\n直接链接: <a href='#{complaint.telegraph_link}'>telegraph_link</a> \n状态: 审核中" if $lg == Cn
  # end
  #############################
  def self.link
    return 'Ссылка' if $lg == Ru
    return 'Link' if $lg == En
    return 'Enlace' if $lg == Es

    '链接' if $lg == Cn
  end

  def self.handle_username(username)
    "⚠️ Принят юзернейм @#{username}"
  end

  def self.input_username
    case $lg
    when En
      'ATTENTION ⚠️ Send the last known @username of the user.'
    when Es
      'IMPORTANTE ⚠️ Envía el último @nombredeusuario conocido del usuario.'
    when Cn
      '重要 ⚠️ 发送已知的最后一个用户@用户名。'
    else # Ru
      'ВАЖНО ⚠️ Отправьте последний известный вам @username пользователя.'
    end
  end

  ################ option_details

  def self.moderator_complaint(userFrom, userTo, complaint)
    answer = %(
<b>Жалоба</b> #N#{complaint.id}

<b>ОТ</b>
#{Text.user_info(userFrom)}\n
<b>На</b>
#{Text.user_info(userTo)}
)
    answer << "\nДополнительная информация" if complaint.media_data['texts'].size > 0
    complaint.media_data['texts'].each do |text|
      answer << "\n\n #{text}"
    end
    answer << "\n<b>Ссылка</b> <a href='#{complaint.telegraph_link}'>telegraph_link</a>"
    answer
  end

  def self.date_time_now(date_time_now)
    "Сейчас #{date_time_now}"
  end

  def self.justification_request_to_moderator(accepted_complaints, scamer)
    text_body = accepted_complaints.map do |complaint|
      "\n<strong>Жалоба</strong> #N#{complaint.id}\n<strong>Ссылка</strong> <a href='#{complaint.telegraph_link}'>telegraph_link</a>\n<strong>Ссылка</strong> <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>пост</a>\n\n <b>Объяснение:</b> #{scamer.justification} "
    end
    if text_body.empty? # решение от администратора, когда не было претензий
      return "Решение принято администратором\n⚖️Оспорить решение⚖️\nОправдание от пользователя:\n" + scamer.justification
    end

    "⚖️Оспорить решение⚖️\n" + text_body.join('')
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
    'Введите причину отклонения'
  end

  def self.handle_accept_complaint(complaint)
    %(Обработано. <a href='#{ENV['TELEGRAM_CHANNEL_USERNAME']}/#{complaint.mes_id_published_in_channel}'>ссылка</a> на пост на канале  )
  end

  def self.was_handled
    'Был ранее обработан'
  end

  def self.greeting_mod
    'Че по чем?'
  end

  def self.accessing_justification(post_links)
    text = 'Обработано!'
    if post_links.any?
      text << "\n Не забудьте изменить пост жалобы"
      post_links.each do |link|
        text << "\n<a href='#{link}'>Ссылка на пост</a>"
      end
    end
    text
  end

  def self.blocking_user
    'Юзер заблокирован'
  end

  def self.not_complaints
    case $lg
    when En
      '⚠️ Reports not found.'
    when Es
      '⚠️ No se encontraron informes.'
    when Cn
      '⚠️ 未找到报告。'
    else
      '⚠️ Заявки не зарегистрированы'
    end
  end

  def self.complaint(scamer)
    "Жалоба #N#{scamer.id}"
  end

  def self.loading_requiest
    'Запрос обрабатывается...'
  end
end
