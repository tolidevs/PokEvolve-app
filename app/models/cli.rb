require 'tty-prompt'
class CLI 

    def array_all_pokemon_i_can_evolve
        @current_user.array_which_pokemons_can_i_evolve
    end

    def array_all_my_pokemon
        arr = Array.new
        @current_user.see_all_my_pokemon_with_id.each {|e| arr.push(e[:name])}
        arr
    end

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
        choice = $prompt.select("Hi trainer, please select the option you'd like:", ["Log In", "Create Account", "Exit"])
        if choice == "Log In"
            login
        elsif choice == "Create Account"
            check_username_available
        else
            exit_app
        end
    end

    # abstract out check username valid
    def check_username
        @response = $prompt.ask("Please enter a username => ").capitalize
        User.find_by(username: @response)
    end

    # use check_username to check validity
    # if it is valid, commence login,
    # otherwise ask again.
    def login
        user = check_username
        if user
            @current_user = user
            puts "Hi #{@current_user.username}! Welcome back trainer!"
            main_menu
        else 
            choice = $prompt.select("That username doesn't exist, would you like to create an account?", ["Yes", "No, return to start"])
            if choice == "Yes"
                check_username_available
            else
                greet_user
            end
        end
    end

    def check_username_available
        @user = check_username
        if @user
            option = $prompt.select("Sorry, that username is already taken!",["1: Try a different username","2: Take me to Login", "3: Exit"])
            if option == "1: Try a different username"
                sleep(0.1)
                check_username_available
            elsif option == "2: Take me to Login"
                sleep(0.1)
                login
            else
                exit_app
            end
        else
            set_up_account
        end
    end

    def set_up_account
        puts "Setting up account:"
        @current_user = User.new(username:@response)
        candy_set = $prompt.ask("How many candies do you have?") do |q|
                q.validate(/^-?[0-9]+$/, "Invalid input, please type a number")
            end
        @current_user.candies = candy_set
        @current_user.save
        puts "Welcome #{@response}, you have created an account with #{candy_set} candies."
        import_choice = $prompt.select("Do you have any existing Pokémon to import?", ["Yes","No"])
        if import_choice == "Yes"
            import_existing_pokemon
        end
        sleep(0.1)
        main_menu
    end

    def import_existing_pokemon
        poke_name = $prompt.ask("Please input Pokémon name => ").capitalize
        if PokemonFamily.find_pokemon_family_by_name(poke_name)
            @current_user.import_pokemon(poke_name)
            puts "#{poke_name} added to your list!"
            import_choice = $prompt.select("Would you like to add another one?", ["Yes","No"])
            if import_choice == "Yes"
                import_existing_pokemon
            end
        else
            puts "Try again!"
            import_existing_pokemon
        end
        sleep(0.2)
        main_menu
    end

    def main_menu
        choice = $prompt.select("What would you like to do?", ["1: Catch Pokémon", "2: See all of my Pokémon", 
            "3: See how many candies I have", "4: See which Pokémon I can evolve", "5: Send a Pokémon to the Professor", "8: Exit"])
        if choice == "1: Catch Pokémon"
            catch_pokemon_name
        elsif choice == "2: See all of my Pokémon"
            see_my_pokemon 
        elsif choice == "3: See how many candies I have"
             p "You have #{@current_user.see_my_candies} candies."
             sleep(1)
             return_main_menu
        elsif choice == "4: See which Pokémon I can evolve" #####thi one we are going to keep
            see_wich_pokemon_can_i_evolve
        # elsif choice == "5: Can I evolve this Pokémon?" ####### The one I have changed
        #     can_i_evolve_pokemon_by_name
        # elsif choice == "6: Evolve a Pokémon"
        #     evolve_pokemon_with_id
        elsif choice == "5: Send a Pokémon to the Professor"
            send_pokemon_to_professor
        else
            exit_app
        end
    end

    def return_main_menu
        choice = $prompt.select("What would you like to do now?", ["Return to main menu", "Exit"])
        if choice == "Return to main menu"
            main_menu
        else
            exit_app
        end
    end

    def catch_pokemon_name
        poke_name = $prompt.ask("Please enter Pokémon name => ").capitalize
        if PokemonFamily.find_pokemon_family_by_name(poke_name)
            @current_user.catch_pokemon(poke_name)
            puts "Nice, you caught a #{poke_name}!"
        else
            puts "Try again!"
            catch_pokemon_name
        end
        sleep(0.5)
        return_main_menu
    end


    def can_i_evolve_pokemon_by_name ####### it's working
        pokemon_array = @current_user.array_which_pokemons_can_i_evolve
        poke_evol = $prompt.select("Which Pokémon would you like to evolve now??", Array[pokemon_array])
        puts "You have enough candies to evolve your #{poke_evol}."
        choice = $prompt.select("Would you like to evolve this Pokémon now?", ["Hell yeah!", "Not right now"])
            if choice == "Hell yeah!"
                @current_user.evolve_and_change_name_by_name(poke_evol)
                puts "You still have #{@current_user.candies} candies left!"
            end    
        # sleep(0.2)
        # return_main_menu
    end

    # def evolve_pokemon_with_id
    #     pokemon_id = $prompt.ask("Please enter Pokémon id => ").to_i
    #     puts "You are about to evolve #{Pokemon.find_name_by_id(pokemon_id)} for #{Pokemon.find(pokemon_id).my_candies_to_evolve} candies"
    #     choice = $prompt.select("Are you sure?", ["Yeah, let's evolve!", "Not right now"])
    #     if choice == "Yeah, let's evolve!"
    #         @current_user.evolve_and_change_name(pokemon_id)
    #         puts "You still have #{@current_user.candies} candies left!"
    #     end
    #     sleep(1)
    #     return_main_menu
    # end

    def see_my_pokemon
        if !@current_user.all_my_pokemon.empty?
            @current_user.see_all_my_pokemon_with_id.each { |poke| puts "ID: #{poke[:id]} - #{poke[:name]}" }
        else
            puts "Oh no, it doesn't seem you have any Pokémon, try catch them all"
        end   
        sleep(1)
        return_main_menu
    end

    def see_wich_pokemon_can_i_evolve
        puts "-----You currently have #{@current_user.candies} candies-----"
        if !@current_user.array_which_pokemons_can_i_evolve.empty?
            @current_user.array_which_pokemons_can_i_evolve.each { |poke| puts "#{poke}"} #had to delete the candies to evolve
            choice = $prompt.select("Would you like to evolve a Pokémon now?", ["Yeah, let's evolve!", "Not right now"])
                if choice == "Yeah, let's evolve!"
                    can_i_evolve_pokemon_by_name
                end
        else
            puts "Oh no, it seems you don't have any Poémon to evolve, try catching them."
        end
        sleep(0.2)
        return_main_menu
    end

    def send_pokemon_to_professor
        if !@current_user.all_my_pokemon.empty?
            send_away = $prompt.select("Who would you like to send to the professor?", Array[array_all_my_pokemon])
            puts "You are about to send #{send_away} to the professor."
            choice = $prompt.select("This can't be undone, are you sure?", ["Yes, send it to the professor", "No I'll hang on to it"])
            if choice == "Yes, send it to the professor"
                @current_user.delete_pokemon_by_name(send_away)
                puts "Your Pokémon is now with the professor, he sent you a candy in return."
                puts "You now have #{@current_user.candies} candies."
            end
        else
            puts "Oh no, it doesn't seem you have any Pokémon, try catch them all"
        end
        sleep(0.2)
        return_main_menu
    end


    def exit_app
        puts "Goodbye, thanks for using"
        sleep(0.2)
        puts"
█▀█ █▀█ █▄▀ █▀▀ █░█ █▀█ █░░ █░█ █▀▀
█▀▀ █▄█ █░█ ██▄ ▀▄▀ █▄█ █▄▄ ▀▄▀ ██▄"
        sleep(1)
    end
# write methods above here
end
