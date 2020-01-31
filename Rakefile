# require 'app'
require 'sinatra/activerecord/rake'
require_relative 'config/environment'

desc 'starts a console'
task :console do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  Pry.start
end


# require 'sinatra/activerecord/rake'
# require_relative './config/environment'

# desc 'Start console sandbox to interact with models'
# task :console do
#   ActiveRecord::Base.logger = Logger.new(STDOUT)
#   Pry.start
# end