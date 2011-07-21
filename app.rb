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
         <fb:login-button redirect-uri="http://174.122.43.76/fb">
            Login with Facebook
         </fb:login-button>
       </body>
    </html>*
  end
  
  get '/fb' do
    "Hi!"
  end
  
end