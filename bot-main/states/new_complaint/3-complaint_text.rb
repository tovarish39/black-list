# frozen_string_literal: true

class StateMachine
  class_eval do
    include AASM
    aasm do
      state :complaint_text

      event :complaint_text_action, from: :complaint_text do
        transitions if: -> { mes_text?(Button.cancel) }, after: :to_start, to: :start

        transitions if: lambda {
                          mes_text? && invalid_complaint_length?
                        }, after: :notify_complaint_length, to: :complaint_text
        transitions if: lambda {
                          mes_text?
                        }, after: :to_complaint_photos, to: :complaint_photos
      end
    end
  end
end

def notify_complaint_length
  Send.mes(Text.more_then_max_length) if more_then_max_length?
  Send.mes(Text.less_then_min_length) if less_then_min_length?
end

def to_complaint_photos
  complaint = Complaint.find_by(
    id: $user.cur_complaint_id,
    status: 'filling_by_user'
  )
  complaint.update(
    complaint_text: $mes.text,
    photo_file_ids: []
  )

  dir_path = get_photo_dir_path(complaint)
  FileUtils.rm_rf(dir_path) if Dir.exist?(dir_path)

  complaint.update(
    photos_amount: 0,
    photo_file_ids: []
  )

  View.complaint_photos
end

def more_then_max_length?
  length = $mes.text.size
  length > ENV['MAX_LENGTH_COMPLAINT_TEXT'].to_i
end

def less_then_min_length?
  length = $mes.text.size
  length < ENV['MIN_LENGTH_COMPLAINT_TEXT'].to_i
end

def invalid_complaint_length?
  more_then_max_length? || less_then_min_length?
end
