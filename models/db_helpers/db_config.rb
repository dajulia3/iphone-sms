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

##########################################################################
#                        USEFUL FOR DEBUGGING                            #
##########################################################################
#cd into most_recent_backup_dir then execute the command below to dump all sms history to a csv file
#sqlite3 -csv -separator , 3d0d7e5fb2ce288813306e4d4636395e047a3d28 "select * from message" > ~/smshistory.csv

#Below is from http://www.hrgeeks.com/2010/03/06/stupid-iphone-tricks/
#
#you can get access to a bunch of logs from your iPhone, without jailbreaking it!  There are number of SQLite databases stored in
#~/Library/Application Support/MobileSync/Backup/
#on your OS X machine that the iPhone syncs with.
#The filenames are SHA1 sums of their location on the iPhone [src].
#Through trial and error, I’ve figured out the following files that should be common to every iPhone:
#992df473bbb9e132f4b3b6e4d33f72171e97bc7a.mddata	 Voicemail list
#ff1324e6b949111b2fb449ecddb50c89c3699a78.mddata	 Call log
#3d0d7e5fb2ce288813306e4d4636395e047a3d28.mddata	 SMS Log
#740b7eaf93d6ea5d305e88bb349c8e9643f48c3b.mddata	 Notes database
#31bb7ba8914766d4ba40d6dfb6113c8b614be442.mddata Contact List
#
#In addition to these, a few interesting DBs I found that are specific to apps installed on my phone are:
#6639cb6a02f32e0203851f25465ffb89ca8ae3fa.mddata Facebook friends list
#970922f2258c5a5a6d449f85b186315a1b9614e9.mddata Flightstats
#5ad81c93601ac423bc635c7936963ae13177147b.mddata	 Daily Burn food log
##########################################################################