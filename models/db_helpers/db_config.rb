require 'active_record'

MOST_RECENT_BACKUP_BASE_PATH = Dir.glob(File.expand_path '~' + "/Library/Application Support/MobileSync/Backup/*").max_by {|f| File.mtime(f)} +"/"
SMS_DB_FILE_NAME= "3d0d7e5fb2ce288813306e4d4636395e047a3d28"
CONTACTS_DB_FILE_NAME = +"31bb7ba8914766d4ba40d6dfb6113c8b614be442"

config.active_record.pluralize_table_names = false

ActiveRecord::Base.configurations['SMS'] = {
    :adapter => "sqlite",
    :database => MOST_RECENT_BACKUP_BASE_PATH + SMS_DB_FILE_NAME
}

ActiveRecord::Base.configurations['Contacts'] = {
    :adapter => "sqlite",
    :database => MOST_RECENT_BACKUP_BASE_PATH + CONTACTS_DB_FILE_NAME
}

class SMSRecordBase < ActiveRecord::Base
  establish_connection 'SMS'
  self.abstract_class = true
  def readonly?
    true
  end
end

class ContactsRecordBase < ActiveRecord::Base
  establish_connection 'Contacts'
  self.abstract_class = true
  def readonly?
    true
  end
end