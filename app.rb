#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exists? db, name
  db.execute('select * from Barbers where name=?', [name]).length > 0
end

def seed_db db, barbers
  barbers.each do |barber|
    if !is_barber_exists? db, barber
      db.execute 'insert into Barbers (name) values (?)', [barber]
    end
  end
end

def get_db
  db = SQLite3::Database.new 'barbershop.db'
  db.results_as_hash = true
  return db
end

before do
  db = get_db
  @barbers = db.execute 'select * from Barbers'
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

  db.execute 'CREATE TABLE IF NOT EXISTS
    "Barbers"
    (
      "Id" INTEGER PRIMARY KEY  AUTOINCREMENT, 
      "name" TEXT
    )'

  seed_db db, ['Jessie Pinkman', 'Walter White', 'Gus Fring', 'Marta Stuard']
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
    db = get_db
    @results = db.execute 'select * from Users order by Id desc'
    
    erb :showusers
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

  erb "<h2>Спасибо, Вы записались!</h2>"

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