require 'rubygems'
require 'sinatra'
require 'base64'

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
                 {'name':'phone_number','description':'phone number',
                 'type':'text'}]" redirect-uri="http://staging.numberguru.com/fb">
         </fb:registration>
       </body>
    </html>*
  end
  
  post '/fb' do
    s = params[:signed_request]
    a = s.split('.')
    
    secret = Base64.decode64(a.first)
    data   = Base64.decode64(a.last)
    
    %Q*<html>
       <head>
         <title>My Facebook Logged In Page</title>
       </head>
       <body>
        <p>response: #{s}</p>
        <p>secret: #{secret}</p>
        <p>secret: #{data}</p>
          
       </body>
    </html>*
  end
  
end