require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'mongo'

configure :development do
  set :db, Mongo::Connection.new.db('spikes').collection('redirects')
end

configure :production do
    db_uri = URI.parse(ENV['MONGOHQ_URL'])
    db_name = db_uri.path.gsub(/^\//, '')
    db_connection = Mongo::Connection.new(db_uri.host, db_uri.port).db(db_name)
    db_connection.authenticate(db_uri.user, db_uri.password) unless (db_uri.user.nil?)
    set :db, db_connection.collection('redirects')
end

get '/' do
  @redirects = settings.db.find.to_a
  erb :index
end

get '/clear' do
  settings.db.remove
  redirect to '/'
end


get '/redirect' do
  target = params[:target]
  data = { :timestamp => Time.now.getutc, :target => target}
  settings.db.insert(data)
  redirect target
end
