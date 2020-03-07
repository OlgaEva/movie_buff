require_relative '../config/environment'
require_relative '../script.rb'
# require 'rest-client'
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
`|_   _|| |_| || __|___________/                \________________________  ,-'
 | |`-|  _  || _|                                                  ,-',-'
 |_|`-|_| |_||___|                                             _,-',-'
____    `-.`-____        ____        ___      ___  ___  _____,-_,-'________
|    \      `/    |    ,-'    `-.    |   |    |   ||   ||        | /        |
|     \     /     |-.,'  __  __  `.  |   |    |   ||   ||    ____||    _____|
|      \   /      |-/   /  \/  \   \ |   |    |   ||   ||   |____ |   (____
|       \_/       ||    \      /    ||   |    |   ||   ||        ||        \
|   |\       /|   ||     |     ]    | \   \  /   / |   ||    ____| \____    |
|   | \     / |   |/\    |____|    /   \   \/   /  |   ||   |____  _____)   |
|   |  \   /  |   | / .  ,' | `. ,'   , \      /   |   ||        ||         |
|___|   \_/   |___|/   `-.____,-'  ,-',`-\____/    |___||________||________/
                    / /             ,-',-' `-.`-.             \ \
                  / /           ,-',-'       `-.`-.            \ \
                 / /         ,-',-'             `-.`-.          \ \
               / /       ,-',-'                   `-.`-.        \ \
              / /     ,-',-'                         `-.`-.     \ \
            / /   ,-',-'                               `-.`-.    \ \
           / / ,-',-'                                     `-.`-. \ \
         / /-',-'                                           `-.`-\ \
        /_,-'`                                                `'-._\
                    ".colorize(:red)

    def initialize 
        @prompt = TTY::Prompt.new
        @current_user = nil 
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
# binding.pry

    def returning_user_first_selection

        @prompt.select("What would you like to do?") do |menu|
            menu.choice "1- Create a new movie review", -> do 
                user_response = @prompt.ask("What movie would you like to review?")
                # binding.pry
                searchMovieApi(user_response)
            end

            menu.choice "2- Read all movie reviews", -> do 
                review_selection

            end

            menu.choice "3- Update one of my reviews", -> do 
                if @current_user.reviews == []
                    puts "You can't update a review; you don't have any yet".colorize(:red)
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
                review_selection
                exit_program_method
            end

            # menu.choice "3- Exit", -> {exit_program_method}
        end
    end

    def exit_program_method
        @prompt.select("Would you like to end this session?") do |menu|
            menu.choice ("Yes"), -> {puts "Goodbye! Thank you for participating in MovieBuff!".colorize(:red)}
            menu.choice ("No"), -> {returning_user_first_selection}
        end
    end

    def new_review_to_table(content, movie_id)
    
        @current_user.reviews << Review.create(content: content, movie_id: movie_id)    

    end

    def review_selection
        choices = Review.all.map {|review| review.content}
        puts ("These are all movie reviews we have, so far...")
        # chosen_review =  @prompt.select("These are all movie reviews we have, so far...", choices) 
        exit_program_method
        binding.pry
        # puts Review.find_by(content: content)
        # id_of_chosen_review = Review.find_by(content: content).id
        # binding.pry

#     variable = Review.find_by(id: id_of_chosen_review)
#     puts variable.comments.map {|cont| cont.contributions}
       
#    @prompt.select("Would you like to add a comment?") do |menu|
#     menu.choice "Yes", -> do
#         user_comment = @current_user.name + " -> " + gets.chomp
#         new_comment = Comment.create(forum_id: id_of_chosen_forum , contributions: user_comment, user_id: @current_user.id)
#         puts "Your comment has been posted.".colorize(:red)
#         exit_program_method
              
    #   end
      
    # menu.choice "No", -> {returning_user_first_selection}

#    end 
            exit_program_method
    end

    def all_my_reviews
    
        choices = @current_user.reviews.map {|review| review.content}
        
        selected_review = @prompt.select("Here are your reviews:", choices)
        
        selected_review_id = Review.find_by(review_title: selected_review).id
        
        @prompt.select ("What would you like to do?") do |menu|
            menu.choice "1 -Edit Review", -> do 
         
            exit_program_method

            end

        menu.choice "2 - Delete my review", -> do

            variable = Review.find_by(id: selected_review_id)
            selected_review_for_user = @prompt.select("Choose a review to edit", choices)
            # to_edit = Review.find_by(review)
            
            #     reviews_belonging_to_user = variable.map {|cont| cont.contributions}
            #  if  
            #     comments_belonging_to_user == []
            #     puts "You do not have any comments to delete.".colorize(:red)
                    exit_program_method
                
            
                
                choices = reviews_belonging_to_user
            
                selected_comment_for_user = @prompt.select("Choose a comment to be deleted", choices)
                to_be_deleted = Review.find_by(reviews: selected_comment_for_user)
                
                to_be_deleted.destroy
                exit_program_method
            
        end

        menu.choice "3- Go Back", -> {to_destroy = Review.find_by(review_title: selected_review)
        exit_program_method
        # to_destroy.destroy # deletes forum in DB
        # @current_user.reviews.destroy(to_destroy)# delete forum from instance variable
            puts "Your review has been deleted.".colorize(:red)
        returning_user_first_selection

        }
    end
end


    def searchMovieApi(title_search)

        client = Omdb::Api::Client.new(api_key: API_KEY)
        # client.search(title_search)    
        movie_search = client.search(title_search)

        movie_titles = movie_search.movies.map { |movie| movie.title }

        choices = movie_titles

        selected = @prompt.select("Choose a movie title", choices)

        created_movie = Movie.create(title: selected)
        # binding.pry 

        new_review = "#{@current_user.name}" + " reviewed " + "#{created_movie.title}" + " thusly: " + @prompt.ask("What did you think about this movie?").colorize(:blue)

            new_review_to_table(new_review, created_movie.id)
            exit_program_method

        binding.pry 
    end

end

cli = MovieBuff.new
cli.everyone_first_interaction