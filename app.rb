#encoding: utf-8
require 'rubygems'
require 'sinatra'
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

  if @username != ""
    @message = "Спасибо #{@username}, мы будем ждать Вас #{@datetime}."

    f = File.open("./public/users.txt","a")
    f.write "User: #{@username}, Phone #{@phone}, Date and time: #{@datetime}, barber: #{@barber}\n"

    erb :visit
  else
    @message = "Не все данные введены."
    erb :visit
  end
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
=begin
Добавить post обработчик для visti
Добавить все введеные даныне в ./public/users.txt
Добавить страницу /contacts со следующими полями:
email
сообщения(посмотреть html-элемент text area)
=====================
На странице /vist пользователь должен иметь возможность выбрать парикмахера из списка: 

Walter White
Jessie Pinkman
Gus Fring

Необходимо использовать html-контрол (тег), который называется select

Программа должна сохранять введеные данные в тот же файл.
=====================
Вход по логину и по паролю с помощью sinatra bootsterap урок 21, кто не сделал.


=end