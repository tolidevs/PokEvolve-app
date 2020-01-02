require 'tty-prompt'
class CLI #< ActiveRecord::Base

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

    $prompt = TTY::Prompt.new

    def greet_user
        puts "Hi trainer, please type the number of the option you'd like:"
        # prompt = TTY::Prompt.new
        choice = $prompt.select("Choose an option", ["Log In", "Create Account", "Exit"])
        if choice == "Log In"
            login
        elsif choice == "Create Account"
            create_new_user
        else
            exit
        end
    end


    def login
        prompt = TTY::Prompt.new
        response = prompt.ask("Please enter a username => ").capitalize
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
        response = prompt.ask("Please enter a username => ").capitalize
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
            "3: See how many candies I have", "4: See which Pokémon I can evolve", "5: Can I evolve this Pokémon?", 
            "6: Evolve a Pokémon", "7: Send a Pokémon to the Professor", "8: Exit"])
        if choice == "1: Catch Pokémon"
            catch_pokemon_name
            return_main_menu
        elsif choice == "2: See my Pokémon"
            see_my_pokemon 
        elsif choice == "3: See how many candies I have"
             p "You have #{@@current_user.see_my_candies} candies."
             sleep(1)
             return_main_menu
        elsif choice == "4: See which Pokémon I can evolve"
            see_wich_pokemon_can_i_evolve
        elsif choice == "5: Can I evolve this Pokémon?"
             can_i_evolve_pokemon_id
        elsif choice == "6: Evolve a Pokémon"
            evolve_pokemon_with_id
        elsif choice == "7: Send a Pokémon to the Professor"
            send_pokemon_to_professor
        else
            exit
        end
    end

    def return_main_menu
        prompt = TTY::Prompt.new
        choice = prompt.select("What would you like to do now?", ["Return to main menu", "Exit"])
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

 
    def can_i_evolve_pokemon_id
        prompt = TTY::Prompt.new
        pokemon_id = prompt.ask("Please enter Pokémon id => ").to_i
        if @@current_user.can_i_evolve_this_pokemon_true(pokemon_id)
            puts "You have enough candies to evolve your #{Pokemon.find(pokemon_id).pokemon_name}."
            choice = prompt.select("Would you like to evolve this Pokémon now?", ["Hell yeah!", "Not right now"])
                if choice == "Hell yeah!"
                    @@current_user.evolve_and_change_name(pokemon_id)
                    puts "You still have #{@@current_user.candies} candies left!"
                    sleep(1)
                    return_main_menu
                else
                    sleep(0.2)
                    return_main_menu
                end
        else
            @@current_user.can_i_evolve_this_pokemon(pokemon_id)
            sleep(1)
            return_main_menu
        end
    end

    def evolve_pokemon_with_id
        prompt = TTY::Prompt.new
            pokemon_id = prompt.ask("Please enter Pokémon id => ").to_i
            puts "You are about to evolve #{Pokemon.find_name_by_id(pokemon_id)} for #{Pokemon.find(pokemon_id).my_candies_to_evolve} candies"
            choice = prompt.select("Are you sure?", ["Yeah, let's evolve!", "Not right now"])
            if choice == "Yeah, let's evolve!"
                @@current_user.evolve_and_change_name(pokemon_id)
                puts "You still have #{@@current_user.candies} candies left!"
                sleep(1)
                return_main_menu
            else
                sleep(0.2)
                return_main_menu
            end
    end

    def see_my_pokemon
        @@current_user.see_all_my_pokemon_with_id.each { |poke| puts "ID: #{poke[:id]} - #{poke[:name]}" }
        sleep(1)
        return_main_menu
    end

    def see_wich_pokemon_can_i_evolve
        prompt = TTY::Prompt.new
        puts "-----You currently have #{@@current_user.candies} candies-----"
        @@current_user.which_pokemons_can_i_evolve.each { |poke| puts "ID: #{poke[:id]} - #{poke[:name]} - Candies: #{poke[:candies_to_evolve]}"}
        choice = prompt.select("Would you like to evolve a Pokémon now?", ["Yeah, let's evolve!", "Not right now"])
        if choice == "Yeah, let's evolve!"
            evolve_pokemon_with_id
        else
            sleep(0.2)
            return_main_menu
        end
    end

    def send_pokemon_to_professor
        prompt = TTY::Prompt.new
        pokemon_id = prompt.ask("Please enter Pokémon id => ").to_i
        puts "You are about to send #{Pokemon.find_name_by_id(pokemon_id)} to the professor."
        choice = prompt.select("This can't be undone, are you sure?", ["Yes, send it to the professor", "No I'll hang on to it"])
        if choice == "Yes, send it to the professor"
            @@current_user.delete_pokemon_by_id(pokemon_id)
            puts "Your Pokémon is now with the professor, he sent you a candy in return."
            puts "You now have #{@@current_user.candies} candies."
            sleep(1)
            return_main_menu
        else
            sleep(0.2)
            return_main_menu
        end
    end

    def exit
        puts "Goodby, thanks for using"
        sleep(0.5)
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