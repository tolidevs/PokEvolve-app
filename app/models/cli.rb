require 'tty-prompt'
class CLI < ActiveRecord::Base

    # $state = {
    #     "user" => " "
    # }

    def opening_credits
        puts "
            ██████╗░░█████╗░██╗░░██╗███████╗██╗░░░██╗░█████╗░██╗░░░░░██╗░░░██╗███████╗
            ██╔══██╗██╔══██╗██║░██╔╝██╔════╝██║░░░██║██╔══██╗██║░░░░░██║░░░██║██╔════╝
            ██████╔╝██║░░██║█████═╝░█████╗░░╚██╗░██╔╝██║░░██║██║░░░░░╚██╗░██╔╝█████╗░░
            ██╔═══╝░██║░░██║██╔═██╗░██╔══╝░░░╚████╔╝░██║░░██║██║░░░░░░╚████╔╝░██╔══╝░░
            ██║░░░░░╚█████╔╝██║░╚██╗███████╗░░╚██╔╝░░╚█████╔╝███████╗░░╚██╔╝░░███████╗
            ╚═╝░░░░░░╚════╝░╚═╝░░╚═╝╚══════╝░░░╚═╝░░░░╚════╝░╚══════╝░░░╚═╝░░░╚══════╝

                            Your Pokémon Go Candy Tracking App

        "
        sleep(1)
    end

    def greet_user
        puts "Hi trainer, please type the number of the option you'd like:"
        prompt = TTY::Prompt.new
        choice = prompt.select("Choose an option", ["Log In", "Create Account", "Exit"])
        if choice == "Log In"
            login
        elsif choice == "Create Account"
            create_new_user
        else
            exit
        end
    end

    # def user_input
    #     gets.chomp
    # end

    def login
        prompt = TTY::Prompt.new
        response = prompt.ask("Please enter a username => ")
        user = User.all.find { |user| user.username == response }
        if user
            @@current_user = user
            puts "Hi #{@@current_user.username}! Welcome back trainer!"
            main_menu
        else   
            # puts "That username doesn't exist, would you like to create an account?"
            choice = prompt.select("That username doesn't exist, would you like to create an account?", ["Yes", "No, return to start"])
            if choice == "Yes"
                create_new_user
            else
                greet_user
            end
        end
    end

    # def check_username
    #     print @username
    # end

    def create_new_user
        prompt = TTY::Prompt.new
        response = prompt.ask("Please enter a username => ")
        user = User.all.find { |user| user.username == response }
        if user
            option = prompt.select("Sorry, that username is already taken!",["1: Try a different username","2: Take me to Login", "3: Exit"])
            if option == "1: Try a different username"
                create_new_user
            elsif option == "2: Take me to Login"
                login
            else
                exit
            end
        else
            @@current_user = User.create(username:response)
            candy_set = prompt.ask("How many candies do you have?") do |q|
                    q.validate(/^-?[0-9]+$/, "Invalid input, please type a number")
                end
            @@current_user.candies = candy_set
            puts "Welcome #{response}, you have created an account with #{candy_set} candies."
            main_menu
        end
    
    end

    def main_menu
        prompt = TTY::Prompt.new
        choice = prompt.select("What would you like to do?", ["1: Catch Pokémon", "2: See my Pokémon", 
            "3: See how many candies I have", "4: See which Pokémon I can evolve", "5: Can I evolve this Pokémon?", "6: Evolve a Pokémon", "7: Exit"])
        if choice == "1: Catch Pokémon"
            catch_pokemon_name
            return_main_menu
        elsif choice == "2: See my Pokémon"
            puts @@current_user.see_all_my_pokemon_with_id 
        elsif choice == "3: See how many candies I have"
             p "You have #{@@current_user.see_my_candies} candies."
             return_main_menu
        elsif choice == "4: See which Pokémon I can evolve"
             p @@current_user.which_pokemons_can_i_evolve
             return_main_menu
        elsif choice == "5: Can I evolve this Pokémon?"
             
        elsif choice == "6: Evolve a Pokémon"
             
        else
            exit
        end
    end

    def return_main_menu
        prompt = TTY::Prompt.new
        choice = prompt.select("What would you like to don now?", ["Return to main menu", "exit"])
        if choice == "Return to main menu"
            main_menu
        else
            exit
        end
    end

    def catch_pokemon_name
        prompt = TTY::Prompt.new
        poke_name = prompt.ask("Please enter Pokémon name => ").capitalize
        @@current_user.catch_pokemon(poke_name)
        puts "Nice, you caught a #{poke_name}!"
    end

    def exit
        puts "Goodby, thanks for using"
        sleep(1)
        puts"
█▀█ █▀█ █▄▀ █▀▀ █░█ █▀█ █░░ █░█ █▀▀
█▀▀ █▄█ █░█ ██▄ ▀▄▀ █▄█ █▄▄ ▀▄▀ ██▄"
        sleep(1)

    end
# write methods above here
end

# cli = CLI.new
# # cli.opening_credits
# cli.greet_user
# login
# check_username