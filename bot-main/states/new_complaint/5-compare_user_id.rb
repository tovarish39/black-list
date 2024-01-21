class StateMachine
  class_eval do
    include AASM
    aasm do
      state :compare_user_id

      event :compare_user_id_action, from: :compare_user_id do
        transitions if: -> { mes_text?(Button.cancel) }, after: :to_start, to: :start
        transitions if: -> { mes_text?(Button.skip) }, after: :skip_proof, to: :option_details

        transitions if: -> { forwarted? &&  match? }, after: :handle_proof, to: :option_details
        transitions if: -> { forwarted? && !match? }, after: :nothing, to: :compare_user_id
      end
    end
  end
end

def forwarted?
  $mes.forward_from.present?
end

def match?
  complaint = Complaint.find_by(id: $user.cur_complaint_id)
  forwarded_telegram_id = $mes.forward_from.id.to_s
  writed_telegram_id = complaint.telegram_id
  forwarded_telegram_id == writed_telegram_id
end

def nothing; end

def handle_proof
  media_data_default = { 'texts' => [], 'voice_file_ids' => [], 'video_note_file_ids' => [] }
  complaint = Complaint.find_by(id: $user.cur_complaint_id)
  complaint.update(is_proofed_by_forwarted_mes: true, media_data: media_data_default)

  view_next_step_option_details
end

def skip_proof
  media_data_default = { 'texts' => [], 'voice_file_ids' => [], 'video_note_file_ids' => [] }
  complaint = Complaint.find_by(id: $user.cur_complaint_id)
  complaint.update(photo_urls_remote_tmp: [], media_data: media_data_default) # чтоб не добавлялись фото, при неудачной загрузке не телеграф
  view_next_step_option_details
end

def view_next_step_option_details
  option_details = Video.last.option_details
  if option_details.present?
    type = option_details['type']
    file_id = option_details['file_id']
    BotMain.send("send_#{type}", caption: Text.option_details, reply_markup: M::Reply.to_6_point, file_id:)
  else
    Send.mes(Text.option_details, M::Reply.to_6_point)
  end
end
