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
  @print_view_url = "/convo/#{params[:contact]}/print-view"
  haml :show
end

get '/convo/:contact/print-view' do
  contact = Contact.find(params[:contact])
  @contact_name = contact.full_name
  @messages = contact.messages
  haml :show_print_view
end