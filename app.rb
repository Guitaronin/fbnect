require 'rubygems'
require 'sinatra'
require 'sinbook'

class App < Sinatra::Application
  get '/' do
    'It still worked, Ronin!'
  end
end