require_relative '../config/environment'
require 'rest-client'
require 'pry'
require 'json'
require 'tty-prompt'
require 'colorize'
ActiveRecord::Base.logger = nil

class BookClub
puts "Welcome to Movie Buff!".colorize(:red)

puts "Are you a New or Returning user?"

response = gets.chomp

    if response.downcase == "new"

        puts "New User, please choose a Username:"
        username = gets.chomp
        puts "Hi, #{username}!"

    else
        puts "Please enter your Username:"
        username = gets.chomp

        puts "Welcome Back, #{username}!"
    
    end

puts "What would you like to do today?:
    1- Read movie reviews
    2- Create new review
    3- Update a review
    4- Delete a review"

selection = gets.chomp
    if selection == "1"
        # def read_reviews
            puts "testing 1"
        # end
    elsif selection == "2"
        # def create_review
            puts "testing 2"
        # end

    elsif selection == "3"
        # def update_review
            puts "testing 3"
        # end

    else 
        # def delete_review
            puts "testing 4"
        # end

    end




end
# binding.pry
