source 'https://rubygems.org'

# Specify your gem's dependencies in pictie.gemspec

gem "bundler", "~> 1.6"        
gem "rake", "~> 10.0"          
gem "sinatra"                  
gem "sinatra-contrib"          
gem "thin"                     
gem "sequel"                   
gem "pg"                       
gem "json"                     
gem 'racksh'
gem 'crypt'
gem 'etcd'
gem 'gd2-ffij'

group :development, :test do
  gem 'rspec'
end

group :development do
  gem "capistrano"             
  gem "capistrano-rvm"
  gem "capistrano-bundler"     
  gem "capistrano-thin"        
end

group :test do
  gem 'fakeweb', require: 'fakeweb/safe'
  gem 'simplecov', require: false 
end
