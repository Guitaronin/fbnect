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
                appId:'#{196067387115119}', cookie:true, 
                status:true, xfbml:true 
             });
          </script>
          <fb:login-button redirect-uri="http://staging.numberguru.com/fb">Login with Facebook</fb:login-button>
        </body>
     </html>*
  end
  
  get '/fb' do
    'Glad you made it!'
  end
end