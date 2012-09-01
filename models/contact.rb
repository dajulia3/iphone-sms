class Contact < ContactsRecordBase
  self.table_name  = 'ABPerson'
  self.primary_key = 'ROWID'
  has_many :numbers, :foreign_key => :record_id

  #Make the names prettier
  alias_attribute :first_name, :First
  alias_attribute :last_name, :Last

  def self.alphabetical_contacts
    #leave out contacts with no name -- I think those are reserved contacts for stuff apple does.
    self.order("Last ASC, First ASC").all.reject{|ctct| ctct.first_name.nil? && ctct.last_name.nil?}
  end

  def full_name
    "#{self.first_name unless self.first_name.nil?}"+" #{self.Last unless self.last_name.nil?}"
  end

  def messages
    msgs =[]
    numbers.each{|num|  Number.numbers_like(num)}.uniq.each{|n| msgs += n.messages}
    msgs
  end

end

