require 'sinatra'
require 'sqlite3'
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


most_recent_backup_dir = Dir.glob(File.expand_path '~' + "/Library/Application Support/MobileSync/Backup/*").max_by {|f| File.mtime(f)} +"/"

SMS_DB_FILE_NAME= "3d0d7e5fb2ce288813306e4d4636395e047a3d28"
CONTACTS_DB_FILE_NAME = most_recent_backup_dir+"31bb7ba8914766d4ba40d6dfb6113c8b614be442"


SMS_DB = SQLite3::Database.new( most_recent_backup_dir+SMS_DB_FILE_NAME)
CONTACTS_DB = SQLite3::Database.new( most_recent_backup_dir+CONTACTS_DB_FILE_NAME)

#Get Colin's name and number
#SELECT First, Last, value FROM ABPerson, ABMultiValue WHERE ABPerson.First = "Colin"
#AND ABPerson.ROWID = ABMultiValue.record_id
#

get '/' do
  @messages = SMS_DB.execute( "select strftime('%Y-%m', date, 'unixepoch'), text, flags from message m0 where address = '#{ENV['ADDRESS']}'" ).inject({}) do |h, r|
    month = r.shift ; h[month] ||= [] ; h[month] << r ; h
  end
  haml :index, :format => :html5
end

__END__

@@ layout
%html
  %head
    %title Happy Valentine's Day
    %meta{name: 'viewport', content: 'width=device-width'}/
    :css
      html,body,div,span,applet,object,iframe,h1,h2,h3,h4,h5,h6,p,blockquote,pre,a,abbr,acronym,address,big,cite,code,del,dfn,em,img,ins,kbd,q,s,samp,small,strike,strong,sub,sup,tt,var,b,u,i,center,dl,dt,dd,ol,ul,li,fieldset,form,label,legend,table,caption,tbody,tfoot,thead,tr,th,td,article,aside,canvas,details,embed,figure,figcaption,footer,header,hgroup,menu,nav,output,ruby,section,summary,time,mark,audio,video { border:0; font-size:100%; font:inherit; vertical-align:baseline; margin:0; padding:0; } article,aside,details,figcaption,figure,footer,header,hgroup,menu,nav,section { display:block; } body { line-height:1; } ol,ul { list-style:none; } blockquote,q { quotes:none; } blockquote:before,blockquote:after,q:before,q:after { content:none; } table { border-collapse:collapse; border-spacing:0; }
      body { padding: 0 15px; }
      #container { width: 100%; max-width: 500px; margin: 0 auto; text-align: center; }
      h1 { margin-top: 2.5em; font-size: 2em; color: #333; }
      h2 { font-size: 1.5em; color: #666; }
      h3 { margin: 0.5em 0; font-size: 1.2em; color: #999; }
      h2, ul.messages li { margin-bottom: 1em; padding-bottom: 1em; border-bottom: 1px dotted #CCC; }
      h2 { border-bottom-color: #666; margin: 2em 0 1em 0; padding-bottom: 0.5em; }
      p { color: #222; line-height: 1.5em; }
  %body
    #container
      %h1 ~ You and Me ~
      = yield

@@ index
- @messages.each do |month, messages|
  %h2= month
  %ul{:class => [:messages, month]}
    - for message in messages
      %li
        %h3= %[#{message[1] == 2 ? 'You' : 'Me'}:]
        %p= message[0]