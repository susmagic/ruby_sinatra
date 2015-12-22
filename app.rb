#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
    erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"
end

get '/about' do
    @error = "something error"
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
  hh.each do |k, v|
    #если параметр пуст
    if params[k] == ''
      @error = hh[k]
      return erb :visit
    end
  end

end

=begin
  if @username != ''
    @message = "Спасибо #{@username}, мы будем ждать Вас #{@datetime}."

    f = File.open("./public/users.txt","a")
    f.write "User: #{@username}, Phone #{@phone}, Date and time: #{@datetime}, barber: #{@barber} and color: #{@color}\n"

    erb :visit
  else
    @message = "Не все данные введены."
    erb :visit
  end
end
=end

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