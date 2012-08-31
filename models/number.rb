class Number < ContactsRecordBase
  self.table_name = 'ABMultiValue'
  self.primary_key = 'UID'
  belongs_to :contact, :foreign_key => :record_id
  has_many :sms_messages, :class_name => :Message, :foreign_key => :address, :primary_key => :value #maybe???
  has_many :iMessages, :class_name => :Message, :foreign_key => :madrid_handle, :primary_key => :value
  alias_attribute :phone_number, :value

  def messages
    (iMessages + sms_messages).sort_by{|msg| msg.id}
  end

  def entry_type
    if identifier == 0
      "mobile"
    elsif identifier == 1
      "iPhone"
    else
      "other" #TODO: figure out other kinds of number types' int representations
    end

  end
end