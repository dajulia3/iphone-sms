class Message < SMSRecordBase
  self.primary_key = 'ROWID'

  has_many :sms_numbers, :class_name => "Number" , :primary_key => "address", :foreign_key => "value"
  has_many :imessage_numbers, :class_name => "Number", :primary_key => "madrid_handle", :foreign_key => "value"

  #TODO: Implement groups in future
  #belongs_to :group

  def number
    if !sms_numbers.nil? && !sms_numbers[0].nil? && !sms_numbers[0].value.nil? && !(sms_numbers.size > 1)
      sms_numbers[0]
    elsif !imessage_numbers.nil? && !imessage_numbers[0].value.nil?
      imessage_numbers[0]
    else
      #custom query this mofo
      if iMessage?
        Number.numbers_like(madrid_handle).first
      else
        Number.numbers_like(address).first
      end
    end
  end
  def is_group_message?
    group_id != 0
  end

  def sent_by_me?
    (iMessage? && madrid_flags == 12289) || flags != 2
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