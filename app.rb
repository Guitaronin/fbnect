# APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

require 'rubygems'
require 'sinatra'
require 'koala'

# register your app at facebook to get those infos
# APP_ID = 196067387115119 # your app id
APP_ID = 119118001500358 # your app id
SECRET = 'b140473706e8567150a196cccb776886' # your app code
SITE_URL = 'http://staging.numberguru.com/' # your app site url

class App < Sinatra::Application
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

	include Koala  

  # set :root, APP_ROOT  
	enable :sessions

	get '/' do
    if session['access_token']
      'You are logged in! <a href="/logout">Logout</a>'    
    else
      '<a href="/login">Login</a>'
    end
	end

	get '/login' do
		%Q*<html>
        <head>
          <title>My Facebook Login Page</title>
        </head>
        <body>
          <div id="fb-root"></div>
          <script src="http://connect.facebook.net/en_US/all.js">
          </script>
          <script>
             FB.init({ 
                appId:'#{APP_ID}', cookie:true, 
                status:true, xfbml:true 
             });
          </script>
          <fb:registration perms="email,user_location,user_status,user_photos" fields="[{'name':'name'}, {'name':'email'}]" redirect-uri="http://staging.numberguru.com/profile">
           </fb:registration>
        </body>
     </html>*
	end
	
	get '/profile' do
	  oauth     = Koala::Facebook::OAuth.new(APP_ID, SECRET)
    user_info = oauth.get_user_info_from_cookies(request.cookies)
    
    if user_info
      graph = Koala::Facebook::GraphAPI.new(user_info['access_token'])
      data  = graph.get_object('me')
      return data.inspect
      # @name  = data['name']
      # @email = data['email']
      
    else
      redirect '/login'
    end
  end

	get '/logout' do
		session[:oauth] = nil
		session[:access_token] = nil
		redirect '/'
	end
	
	#method to handle the redirect from facebook back to you
	get '/callback' do
		#get the access token from facebook with your code
    session[:oauth] = Facebook::OAuth.new(APP_ID, SECRET, SITE_URL + 'callback')
	  session[:access_token] = session[:oauth].get_access_token(params['code'])
	  
	  graph = Koala::Facebook::GraphAPI.new(session[:access_token])
	  
    output = graph.get_object('me')
    return output.inspect
    # redirect '/'
	end
	
	get '/v2' do
	  %Q*<html> 
       <head> 
         <title>Client Flow Example</title> 
       </head> 
       <body> 
       <script> 
         function displayUser(user) {
           var userName = document.getElementById('userName');
           var greetingText = document.createTextNode('Greetings, '
             + user.name + '.');
       userName.appendChild(greetingText);
         }

         var appID = #{APP_ID};
         if (window.location.hash.length == 0) {
           var path = 'https://www.facebook.com/dialog/oauth?';
       var queryParams = ['client_id=' + appID,
         'redirect_uri=' + window.location,
         'response_type=token'];
       var query = queryParams.join('&');
       var url = path + query;
       window.open(url);
         } else {
           var accessToken = window.location.hash.substring(1);
           var path = "https://graph.facebook.com/me?";
       var queryParams = [accessToken, 'callback=displayUser'];
       var query = queryParams.join('&');
       var url = path + query;

       // use jsonp to call the graph
           var script = document.createElement('script');
           script.src = url;
           document.body.appendChild(script);        
         }
       </script> 
       <p id="userName"></p> 
       </body> 
      </html>*
  end

end

