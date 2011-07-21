require 'rubygems'
require 'sinatra'
require 'sinbook'

class App < Sinatra::Application
  get '/' do
    'It worked, Ronin!'
  end
end