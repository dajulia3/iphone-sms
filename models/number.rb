class Number < ContactsRecordBase
  self.table_name = 'ABMultiValue'
  self.primary_key = 'UID'
  belongs_to :contact, :foreign_key => :record_id
  has_many :sms_messages, :class_name => :Message, :foreign_key => :address, :primary_key => :value #maybe???
  has_many :iMessages, :class_name => :Message, :foreign_key => :madrid_handle, :primary_key => :value
  alias_attribute :phone_number, :value


  def self.numbers_like number_string
    parsed_values =[]
    parsed = number_string.gsub /[+()\s]/, ""
    parsed = parsed[1..-1] if parsed.length == 11 && parsed.start_with?("1")
    parsed = "(#{parsed[0..2]}) #{parsed[3..5]}-#{parsed[6..10]}"

    parsed_values[0] = parsed
    parsed_values[1] = "+1 #{parsed}"
    #parsed_values now contains possible number values for numbers similar to this one

    valids = parsed_values.map{ |val| Number.where(:value =>val)}.reject{|results| results.size == 0}.flatten
  end

  def numbers_like_me
    Number.numbers_like value
  end
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