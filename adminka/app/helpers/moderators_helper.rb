module ModeratorsHelper
  def default_options(statuses, moderator_status)
    new_order_statuses = [moderator_status]
    statuses.each do |status|
      new_order_statuses.push(status) if moderator_status != status
    end
    new_order_statuses
  end
end
