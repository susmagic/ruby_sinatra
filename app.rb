#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'pony'
require 'sinatra/reloader'

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

  erb "ok, username is #{@username}"

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