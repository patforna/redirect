require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'mongo'

configure :development do
  set :db, Mongo::Connection.new.db('spikes').collection('todos')
end

configure :production do
    db_uri = URI.parse(ENV['MONGOHQ_URL'])
    db_name = db_uri.path.gsub(/^\//, '')
    db_connection = Mongo::Connection.new(db_uri.host, db_uri.port).db(db_name)
    db_connection.authenticate(db_uri.user, db_uri.password) unless (db_uri.user.nil?)
    set :db, db_connection.collection('todos')
end

get '/' do
  @todos = settings.db.find.to_a
  erb :index
end

post '/' do  
  data = JSON.parse request.body.read  
  settings.db.insert(data)
end

put '/:id' do
  data = JSON.parse request.body.read    
  settings.db.update({'_id' => bson_id(params[:id])}, {'$set' => data})
end

delete '/:id' do
  settings.db.remove(:_id => bson_id(params[:id]))
end

helpers do
  def bson_id val
    BSON::ObjectId.from_string(val)
  end
end