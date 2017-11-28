# = Gemfile containing requirements for this app =
#     see http://gembundler.com/ for more on how to use this file

# = source (there are others but whatever)
source :rubygems

# = All =
gem "rack"                      # the base of the base
gem "sinatra"                   # the base of our web app
gem "sinatra-contrib"
gem "sinatra-cross_origin"
#gem "rack-flash"                # enables flash[:notice] && flash[:error]
gem "thin"                      # thin server
gem "mysql2", '0.3.21'
gem "json"
#gem "savon", "~>1.0"
gem "sinatra-contrib"
gem "shotgun"

gem "activerecord"
gem "sinatra-activerecord"

#cvent-ruby specific
gem 'httparty'
gem 'savon', '~> 2.0.2'

group :production do
  gem 'pony'
end

group :development do
  gem 'compass'
end