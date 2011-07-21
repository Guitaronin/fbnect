require 'rubygems'
require 'sinatra'
require 'sinbook'

class App < Sinatra::Application
    
  get '/' do
    %Q*<html>
       <head>
         <title>My Facebook Login Page</title>
       </head>
       <body>
         <div id="fb-root"></div>
         <script src="http://connect.facebook.net/en_US/all.js"></script>
         <script>
            FB.init({ 
               appId:#{196067387115119}, cookie:true, 
               status:true, xfbml:true 
            });
         </script>
         <fb:registration
                 fields="[{'name':'name'}, {'name':'email'},
                 {'name':'phone_number','description':'What is your phone number?',
                 'type':'text'}]" redirect-uri="http://staging.numberguru.com/fb">
         </fb:registration>
       </body>
    </html>*
  end
  
  post '/fb' do
    %Q*<html>
       <head>
         <title>My Facebook Logged In Page</title>
       </head>
       <body>
          <h1>Hi, #{params[:name]}</h1>
          <p>your email is #{params[:email]}</p>
          <p>your phone is #{params[:phone_number]}</p>
          
          <p>#{params.inspect}</p>
       </body>
    </html>*
  end
  
end