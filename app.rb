SECRET# APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

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
			# do some stuff with facebook here
			# for example:
			# @graph = Koala::Facebook::GraphAPI.new(session["access_token"])
			# publish to your wall (if you have the permissions)
			# @graph.put_wall_post("I'm posting from my new cool app!")
			# or publish to someone else (if you have the permissions too ;) )
			# @graph.put_wall_post("Checkout my new cool app!", {}, "someoneelse's id")			
		else
			'<a href="/login">Login</a>'
		end
	end

	get '/login' do
		# generate a new oauth object with your app data and your callback url
		session['oauth'] = Facebook::OAuth.new(APP_ID, SECRET, SITE_URL + 'callback')
		# redirect to facebook to get your code
		redirect session['oauth'].url_for_oauth_code()
	end

	get '/logout' do
		session['oauth'] = nil
		session['access_token'] = nil
		redirect '/'
	end
	
	#method to handle the redirect from facebook back to you
	get '/callback' do
    # return params.inspect
		#get the access token from facebook with your code
		if session['oauth']
		  session['access_token'] = session['oauth'].get_access_token(params['code'])
	  else
	    return session.inspect
    end
		redirect '/'
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

