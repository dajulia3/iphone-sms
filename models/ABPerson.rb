class ABPerson < ContactsRecordBase
  self.primary_key = 'ROWID'
  self.table_name = 'ABPerson'

  def full_name
    First + Last
  end
end