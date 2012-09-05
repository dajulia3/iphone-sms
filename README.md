iPhone SMS Browser
===================

A project used to pull the sms records and contact information from the iPhone itunes backup to be used on a mac.  
It serves the project files to the browser using Sinatra.  
The motivation for this was that I was trying to share a particularly funny and long SMS conversation with a friend on facebook chat,
but I didn't want to type everything in. Also the iPhone doesn't display the exact time texts were sent/received for all texts,
and I'd prefer to have that when sharing the conversation.

How to use it
--------------
Backup your iPhone in itunes (do not check the box to use a password to encrypt your backup -- otherwise the app can't access your files).  
execute the command `ruby server.rb` from the project directory to run the project.  
The app will automatically use the newest backup created.  

Browse to [localhost:4567](localhost:4567) to view your sms conversations

Click on a contact to view your message record with them.  
Just like on the iPhone, sms messages are displayed in green speech bubbles, and iMessages are displayed in blue speech bubbles.  
  
To view an easily printable or copy/pastable version of the conversation, click on the "Printer Friendly Version" link at the top of the conversation.
The printer friendly version is particularly useful if you are trying to copy/paste the conversation to a friend, because it will maintain correct formatting when 
copied to your clipboard.

Internals
-----------
Within the project is an awesome set of Models using ActiveRecord to access the iPhone contacts, numbers, messages, etc and associate them.
Even though the naming scheme is not standard/preferred by ActiveRecord, the benefits of using ActiveRecord outweigh the slight configuration/fiddling around
needed to get the project to work.


FAQ
-------------
*   Can I use this on a PC?
    The directory structure for itunes backups and itunes location is different on PCs. 
    Eventually I may add support for that, but it's not high on my to-do list.

Future Improvements
-------------------
Turn it into something that I can deploy to the web for others to use to browse their text conversations online
*Ajaxy search
*Uploadable backups (so people can upload their sms logs and have them parsed/accessible). 
*anything else cool I feel like adding!


Credit
----------------
Original inspiration and the basic CSS -- not the css for the conversation bubbles (which was a pain to get right)
was taken from https://github.com/joshuap/valentine
However at this point, there's no code that I reused from his original project aside from the base layout and css.