#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'pony'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
  db = SQLite3::Database.new 'barbershop.db'
  db.results_as_hash = true
  return db
end

configure do
  db = get_db
  db.results_as_hash = true #выводим данные в виде хеша
  db.execute 'CREATE TABLE IF NOT EXISTS
      "Users"
      (
        "Id" INTEGER PRIMARY KEY  AUTOINCREMENT, 
        "Name" TEXT, 
        "Phone" TEXT, 
        "DateStamp" TEXT, 
        "Barber" TEXT, 
        "Color" TEXT
      )'
end

get '/' do
    erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"
end

get '/about' do
    erb :about
end

get '/visit' do
    erb :visit
end

get '/contacts' do
    erb :contacts
end

get '/login' do
    erb :login
end

get '/admin' do
    erb :admin
end

get '/showusers' do

end


post '/visit' do
  @username = params[:username]
  @phone = params[:phone]
  @datetime = params[:datetime]
  @barber = params[:barber]
  @color = params[:color]

  #hash
  hh = { username: 'Введите имя',
         phone: 'Введите телефон',
         datetime: 'Введите дату и время' }
  #для каждой пары ключ-значение
  @error = hh.select {|key,_| params[key] == ""}.values.join(", ")

  if @error != ''
    return erb :visit
  end

  db = get_db
  db.execute 'insert into
    Users
    (
      Name,
      Phone,
      DateStamp,
      Barber,
      Color
      )
      values 
      (?, ?, ?, ?, ?)', [@username, @phone, @datetime, @barber, @color]

  erb "OK, username is #{@username}, #{@phone}, #{@datetime}, #{@barber}, #{@color}"

end

post '/admin' do
  @login = params[:login]
  @password = params[:password]

  if @login == "admin" && @password == "secret"
      @logfile = File.open("./public/users.txt","r")
      erb :admin

  elsif @login =='admin' && @password == 'admin'
      @message = "Не плохая попытка хахаха"
      erb :login
  else
      @message = "Доступ запрещён"
      erb :login
  end
end

post '/contacts' do
  @sender = params[:sender]
  @comment = params[:comment]

  erb "<div class=\"alert alert-success\"><%=\"Спасибо #{@sender} мы свяжемся с Вами!\"%></div>"
end