require 'rubygems'
require 'sinatra'
require 'sinbook'

class App < Sinatra::Application
  
  facebook do
    api_key  '119118001500358'
    secret   'b140473706e8567150a196cccb776886'
    app_id   119118001500358
    url      'http://174.122.43.76/'
    callback 'http://174.122.43.76/'
  end
    
  get '/' do
    '<p>It still worked, Ronin! Or does it?</p>
    <p><a href="/fb">Go!</a></p>'
  end
  
  get '/fb' do
    fb.require_login!
    "Hi <fb:name uid=#{fb[:user]} useyou=false />!"
  end
  
end