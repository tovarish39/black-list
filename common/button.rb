module Button
  def self.all_main
    [
      make_a_complaint,
      request_status,
      account_status,
      verify_by_userbot,
      '/start'
    ]
  end

  # !
  def self.ru = 'Русский 🇷🇺'
  def self.en = 'English 🇺🇸'
  def self.es = 'Española 🇪🇸'
  def self.cn = '中文  🇨🇳'

  # !
  def self.request_status
    return '📔 Cтатус поданных жалоб' if $lg == Ru
    return '📔 Review Submitted Reports' if $lg == En
    return '📔 Revisar Informes Enviados' if $lg == Es

    '📔 查看提交的报告' if $lg == Cn
  end

  # !
  def self.make_a_complaint
    return '⚙ Подать жалобу' if $lg == Ru
    return '⚙ Submit a Report' if $lg == En
    return '⚙ Enviar un Informe' if $lg == Es

    '⚙ 提交报告' if $lg == Cn
  end

  # !
  def self.account_status
    return '📛 Проверить статус моего аккаунта' if $lg == Ru
    return '📛 Check My Account Status' if $lg == En
    return '📛 Verificar el Estado de Mi Cuenta' if $lg == Es

    '📛 检查我的账户状态' if $lg == Cn
  end

  # !
  def self.support_inline
    return '🪖 Связаться с поддержкой' if $lg == Ru
    return '🪖 Contact Support Service' if $lg == En
    return '🪖 Contactar con el Servicio de Soporte' if $lg == Es

    '🪖 联系支持服务' if $lg == Cn
  end

  # !
  def self.support
    return '🪖 Связаться с поддержкой' if $lg == Ru
    return '🪖 Contact Support Service' if $lg == En
    return '🪖 Contactar con el Servicio de Soporte' if $lg == Es

    '🪖 联系支持服务' if $lg == Cn
  end

  # !
  def self.oracle_tips
    '📌 Oracle`s Tips'
  end

  # !
  def self.select_user
    return '🔎 Выбрать' if $lg == Ru
    return '🔎 Select' if $lg == En
    return '🔎 Confirmar' if $lg == Es

    '🔎 选择' if $lg == Cn
  end

  # !
  def self.cancel
    return '❌ Отмена' if $lg == Ru
    return '❌ Cancel' if $lg == En
    return '❌ Cancelar' if $lg == Es

    '❌ 取消' if $lg == Cn
  end

  # !
  def self.verify_potential_scamer
    return '✅ Подтвердить' if $lg == Ru
    return '✅ Confirm' if $lg == En
    return '✅ Confirmar' if $lg == Es

    '✅ 确认' if $lg == Cn
  end

  # !
  def self.ready
    return '❇️ Готово' if $lg == Ru
    return '❇️  That`s it' if $lg == En
    return '❇️ Listo' if $lg == Es

    '❇️ 完成' if $lg == Cn
  end

  # !
  def self.skip
    return '✔️ Пропустить' if $lg == Ru
    return '✔️ Pass it' if $lg == En
    return '✔️ Pásalo' if $lg == Es

    '✔️ 转发它' if $lg == Cn
  end

  # !
  def self.justification
    return '♻️ Оспорить' if $lg == Ru
    return '♻️ Dispute' if $lg == En
    return '♻️ Disputar' if $lg == Es

    '♻️ 争议' if $lg == Cn
  end

  # !
  def self.verify_by_userbot
    return '⚡️ Проверить контрагента' if $lg == Ru
    return '⚡️ Lookup the counterparty' if $lg == En
    return '⚡️ Verificar al contratante' if $lg == Es

    '⚡️ 检查对方' if $lg == Cn
  end

  # !
  def self.oracle_tips_inline
    return 'Ознакомиться прямо сейчас!' if $lg == Ru
    return 'Check it out right now!' if $lg == En
    return '¡Revíselo ahora mismo!' if $lg == Es

    '现在就来看看！' if $lg == Cn
  end

  ############################################## для модератора
  # !
  def self.active_complaints
    'Активные заявки'
  end

  # !
  def self.accept
    'Одобрить'
  end

  # !
  def self.reject
    '❌Отклонить'
  end

  # !
  def self.block_user
    '❌ Внести в список кидков'
  end
end
