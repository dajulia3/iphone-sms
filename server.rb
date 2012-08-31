require 'sinatra'
require 'active_record'
require 'require_all'
require_all 'models/db_helpers'
require_all 'models'
require 'haml'

set :haml, :format => :html5

get '/' do
  @contacts = Contact.alphabetical_contacts
  haml :index
end

get '/convo/:contact' do
  contact = Contact.find(params[:contact])
  @contact_name = contact.full_name
  @messages = contact.messages
  haml :show
end

__END__

@@ layout
%html
  %head
    %title iPhone Text Messages
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
      li{ list-style-type: none; text-align:left; padding-bottom:40px }
      li.sent-by-you{ text-align:right;}
      li.sent-by-other{text-align:left;}
      p { color: #222; line-height: 1.5em; }
      .textMessage p, .iMessage p {padding:10px}
      .textMessage { text-align:left; padding-left:20px; position: relative; width: 450px; text-align: center; line-height: 100px; background-color: #91D15B; border: 8px solid #666; -webkit-border-radius: 30px; -moz-border-radius: 30px; border-radius: 30px; -webkit-box-shadow: 2px 2px 4px #888; -moz-box-shadow: 2px 2px 4px #888; box-shadow: 2px 2px 4px #888; }
      .textMessage:before { content: ' '; position: absolute; width: 0; height: 0; left: 30px; top: 100%; border: 25px solid;  background-color: transparent; border-color: #666 transparent transparent #666; }
      .textMessage:after { content: ' '; position: absolute; width: 0; height: 0; left: 38px; top: 100%; border: 15px solid; background-color: transparent; border-color: #91D15B transparent transparent #91D15B; }
      .iMessage { text-align:left; padding-left:20px; position: relative; width: 500px; text-align: center; line-height: 100px; background-color: #97C8F8; border: 8px solid #666; -webkit-border-radius: 30px; -moz-border-radius: 30px; border-radius: 30px; -webkit-box-shadow: 2px 2px 4px #888; -moz-box-shadow: 2px 2px 4px #888; box-shadow: 2px 2px 4px #888; }
      .iMessage:before { content: ' '; position: absolute; width: 0; height: 0; left: 30px; top: 100%; border: 25px solid; border-color: #666 transparent transparent #666; }
      .iMessage:after { content: ' '; position: absolute; width: 0; height: 0; left: 38px; top: 100%; border: 15px solid; background-color: transparent; border-color: #97C8F8 transparent transparent #91D15B; }
  %body
    #container
      %h1= "~ You and #{@contact_name} ~"
      = yield

@@ show
%h2= "Convo Between You and #{@contact_name}"
%ul{:class => [:messages, :month]}
- for message in @messages
  %li{:class =>(message.sent_by_me? ? "sent-by-you" : "sent-by-other")}
    %h3= message.sender_name
    %div{:class =>[:speech, (message.iMessage? ? 'iMessage' : 'textMessage')]}
      %p= message.text


@@ index
%ul{:class => [:messages]}
  - for contact in @contacts
    %li
      %a{:href=>"/convo/#{contact.id}"}= contact.full_name
