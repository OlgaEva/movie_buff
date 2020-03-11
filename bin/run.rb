require_relative '../config/environment'
require_relative '../script.rb'
require 'pry'
require 'json'
require 'tty-prompt'
require 'colorize'
require 'omdb/api'

ActiveRecord::Base.logger = nil

class MovieBuff
puts "Welcome to Movie Buff!".colorize(:red)
    puts "
                                       /\\
                                      /  \\
                                     / /\\ \\
                                    / /  \\ \\
                                   / /    \\ \\
                                  / /      \\ \\
                                 / /        \\ \\
                                / /          \\ \\
                               / /            \\ \\
_ _____  _ _ _  ___ __________/ /              \\ \\_____________________________
`|_   _|| |_| || __|___________/                \\________________________  ,-'
   | |`-|  _  || _|                                                  ,-',-'
   |_|`-|_| |_||___|                                             _,-',-'
 ____    `-.`-____        ____        ___      ___  ___  _____,-_,-'________
|    \\      `/    |    ,-'    `-.    |   |    |   ||   ||        | /        |
|     \\     /     |-.,'  __  __  `.  |   |    |   ||   ||    ____||    _____|
|      \\   /      |-/   /  \\/  \\   \\ |   |    |   ||   ||   |____ |   (____
|       \\_/       ||    \\      /    ||   |    |   ||   ||        ||        \\
|   |\\       /|   ||     |     ]    | \\   \\  /   / |   ||    ____| \\____    |
|   | \\     / |   |/\\    |____|    /   \\   \\/   /  |   ||   |____  _____)   |
|   |  \\   /  |   | / .  ,' | `. ,'   , \\      /   |   ||        ||         |
|___|   \\_/   |___|/   `-.____,-'  ,-',`-\\____/    |___||________||________/
                / /             ,-',-' `-.`-.             \\ \\
               / /           ,-',-'       `-.`-.           \\ \\
              / /         ,-',-'             `-.`-.         \\ \\
             / /       ,-',-'                   `-.`-.       \\ \\
            / /     ,-',-'                         `-.`-.     \\ \\
           / /   ,-',-'                               `-.`-.   \\ \\
          / / ,-',-'                                     `-.`-. \\ \\
         / /-',-'                                           `-.`-\\ \\
        /_,-'`                                                 `'-._\\
                    ".colorize(:red)
#from https://www.asciiart.eu/movies/other
    def initialize 
        @prompt = TTY::Prompt.new
        @current_user = nil 
        fork{ exec 'afplay', "audio/383755__deleted-user-7146007__inception-style-movie-horn.wav"}
    end

    def everyone_first_interaction

        @prompt.select("Are you a New or Returning user?") do |menu|
            menu.choice "New", -> do
                puts ("New User, Hi! Please choose a Username:")
                new_user = gets.chomp
                new_user_to_table(new_user)
                new_user_first_selection
            end
            menu.choice "Returning", -> do
                returning_user = @prompt.ask("Please enter your Username:")
                    if @current_user = User.find_by(name: returning_user)
                        puts "Welcome back #{@current_user.name}!".colorize(:red)
                        returning_user_first_selection  
                        
                    else
                        @current_user == nil
                        puts "You are not a User yet. Please enter a Username:".colorize(:red)
                        new_user = gets.chomp
                        new_user_to_table(new_user)
                        new_user_first_selection
                end
            end       
        end
    end

    def new_user_to_table(new_users)

        @current_user = User.create(name: new_users)

    end

    def returning_user_first_selection

        @prompt.select("What would you like to do?") do |menu|
            menu.choice "1- Create a new movie review", -> do 
                user_response = @prompt.ask("What movie would you like to review?")
                
                searchMovieApi(user_response)
            end

            menu.choice "2- Read all movie reviews", -> do 
                if Review.all == []
                    puts "There are no reviews for you to read, yet... Create one, why don't you?"
                    returning_user_first_selection
                
                else
                review_selection

                exit_program_method
                end
            end

            menu.choice "3- Update one of my reviews", -> do 
                if @current_user.reviews == []
                    puts "You can't update a review; you don't have any yet".colorize(:red)
                    review_selection

                    exit_program_method

                else
                    all_my_reviews

                end
            end
            menu.choice "4- Exit", -> {exit_program_method}
        end
    end

    def new_user_first_selection

        @prompt.select("What would you like to do?") do |menu|
            menu.choice "1- Create a new movie review", -> do 
                user_response = @prompt.ask("What movie would you like to review?")

                searchMovieApi(user_response)

            end

            menu.choice "2- Read all moview reviews", -> do 
                if Review.all == []
                    puts "There are no reviews for you to read, yet... Create one, why don't you?"
                else
                review_selection
                end
              
                exit_program_method
            end

            menu.choice "3- Exit", -> {exit_program_method}
        end
    end

    def exit_program_method
        @prompt.select("Would you like to end this session?") do |menu|
            menu.choice ("Yes"), -> {puts "Goodbye! Thank you for participating in MovieBuff!".colorize(:red)}
            menu.choice ("No"), -> {returning_user_first_selection}
            fork{ exec 'afplay', "audio/165109__rickeyc__low-movie-boom.mp3"}
        end
    end

    def new_review_to_table(content, movie_id)
    
        @current_user.reviews << Review.create(content: content, movie_id: movie_id)    

    end

    def review_selection
        choices = Review.all.map {|review| review.content}
        fork{ exec 'afplay', "audio/251254__ekvelika__movie-piano-theme-em.wav.crdownload"}
        puts ("These are all movie reviews we have, so far...")
        puts choices
  
        # exit_program_method
              
    end

    def all_my_reviews
        fork{ exec 'afplay', "audio/261218__stereo-surgeon__guns-in-the-parking-lot-bass-loop.wav.crdownload"}
    
        choices = @current_user.reviews.map {|review| review.content}
        
        selected_review = @prompt.select("Here are your reviews:", choices)
        
        selected_review_id = Review.find_by(content: selected_review).id
        
        @prompt.select ("What would you like to do?") do |menu|
            menu.choice "1- Edit Review", -> do 
         
            to_edit = Review.find(selected_review_id)
            puts "Change your review as you please: "
            updated = gets.chomp

            to_edit.content = ("#{@current_user.name}" + " reviewed " + "#{to_edit.movie.title}" + " thusly: " + updated.colorize(:blue))
            to_edit.save
            
            exit_program_method
            end

        menu.choice "2- Delete my review", -> do

            variable = Review.find(selected_review_id)
            # binding.pry
            selected_review_for_user = @prompt.select("Choose a review to be deleted", choices)
            to_be_deleted = Review.find(selected_review_id)
            # binding.pry
            to_be_deleted.destroy
            
            puts "Your review has been deleted.".colorize(:red)
            exit_program_method
            
        end

        menu.choice "3- Go Back", -> do
    
            returning_user_first_selection

        end
    end
end


    def searchMovieApi(title_search)

        client = Omdb::Api::Client.new(api_key: API_KEY)
         
        movie_search = client.search(title_search)

        movie_titles = movie_search.movies.map { |movie| movie.title }

        choices = movie_titles

        selected = @prompt.select("Choose a movie title", choices)

        created_movie = Movie.create(title: selected)
    
        new_review = "#{@current_user.name}" + " reviewed " + "#{created_movie.title}" + " thusly: " + @prompt.ask("What did you think about this movie?").colorize(:blue)

            new_review_to_table(new_review, created_movie.id)
            exit_program_method
    end
end

cli = MovieBuff.new
cli.everyone_first_interaction