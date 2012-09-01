class Number < ContactsRecordBase
  self.table_name = 'ABMultiValue'
  self.primary_key = 'UID'
  belongs_to :contact, :foreign_key => :record_id
  has_many :sms_messages, :class_name => :Message, :foreign_key => :address, :primary_key => :value #maybe???
  #has_many :iMessages, :class_name => :Message, :foreign_key => :madrid_handle, :primary_key => Proc.new{}
  alias_attribute :phone_number, :value

  scope :normal, where("value IS NOT NULL")
  scope :reserved, where(:value => nil)

  def self.parse_to_iMessage_num number_string
    parsed = number_string.gsub /[+()\s-]/, ""
    parsed = "+1"+parsed if parsed.length == 10
    parsed = "+" + parsed if parsed.length == 11
    parsed
  end

  def self.parse_to_parens_num number_string
    parsed = number_string.gsub /[+()\s-]/, ""
    parsed = parsed[1..-1] if parsed.starts_with? "1"
    parsed = "(#{parsed[0..2]}) #{parsed[3..5]}-#{parsed[6..9]}"
  end

  def self.number_values_like number_string
    @@number_values_like ||= {}
    if @@number_values_like[number_string].nil?
      if number_string.nil? || number_string.strip ==""
        @@number_values_like[number_string] = []
      end


      parsed_values =[]
      parsed_values << number_string
      parsed_values << Number.parse_to_iMessage_num(number_string)

      paren_num =  Number.parse_to_parens_num(number_string)
      parsed_values << paren_num
      parsed_values << "+1 " + paren_num
      parsed_values << "1 " + paren_num
      #parsed_values now contains possible number values for numbers similar to this one

      valids = parsed_values.reject{ |val| Number.where(:value =>val).all.size == 0 }.uniq
      @@number_values_like[number_string] = valids
    end
    @@number_values_like[number_string]
  end

  def self.numbers_like number
    if number.is_a? Number
      num_str = number.value
    elsif number.is_a? String
      num_str = number
    end
    Number.number_values_like(num_str).map do |num_val|
      Number.find_by_value(num_val)
    end
  end

  def iMessage_handle
    Number.parse_to_iMessage_num value
  end

  def iMessages
    iMessages = Message.where :madrid_handle => iMessage_handle
  end

  def messages
    #TODO -- rewrite with custom query that uses imessage handle.
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