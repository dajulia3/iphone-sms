require "date"
class Message < SMSRecordBase
  self.primary_key = 'ROWID'

  #has_many :sms_numbers, :class_name => "Number" , :primary_key => "address", :foreign_key => "value"
  #has_many :imessage_numbers, :class_name => "Number", :primary_key => "madrid_handle", :foreign_key => "value"

  #TODO: Implement groups in future
  #belongs_to :group

  def number
    if iMessage?
      possible_num_vals = Number.number_values_like(madrid_handle)
    else
      possible_num_vals = Number.number_values_like(address)
    end
    Number.normal.where(:value => possible_num_vals ).first
  end

  def is_group_message?
    group_id != 0
  end

  def time_stamp
    Time.at(date).to_datetime
  end

  def pretty_time_stamp
    time_stamp.strftime("%m/%d/%Y %l:%M:%S %P")
  end

  def sent_by_me?
    if iMessage?
      madrid_flags != 12289
    else
      flags != 2
    end
  end

  def received_by_me?
    !sent_by_me?
  end

  def iMessage?
    is_madrid == 1
  end

  def sender_name
    if sent_by_me?
      "You"
    else
      number.contact.full_name
    end

  end
end