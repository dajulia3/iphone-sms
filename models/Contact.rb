class ABPerson < ContactsRecordBase
  set_primary_key 'ROWID'
  def full_name
    First + Last
  end
end