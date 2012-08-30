class Number < ContactsRecordBase
  self.table_name = 'ABMultiValue'
  self.primary_key = 'UID'
  belongs_to :contact, :foreign_key => :record_id

  alias_attribute :phone_number, :value

  def number_type
    if identifier == 0
      "mobile"
    elsif identifier == 1
      "iPhone"
    else
      "other" #TODO: figure out other kinds of number types' int representations
    end

  end
end