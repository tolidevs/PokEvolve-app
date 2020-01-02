require 'tty-prompt'
class CLI

    $state = {
        "user" => " "
    }

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
    end

    def greet_user
        sleep(1)
        puts "Hi trainer, please type the number of the option you'd like:"
        prompt = TTY::Prompt.new
        choice = prompt.select("Choose an option", ["Log In", "Create Account", "Exit"])
        if choice == "Log In"
            login
        elsif choice == "Create Account"
            create_new_user
        else
            puts "Goodbye!"
            sleep(1)
            opening_credits
            sleep(1)
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
            @current_user = user
            puts "Hi #{@current_user.username}! Welcome back trainer!"
        else   
            # puts "That username doesn't exist, would you like to create an account?"
            choice = prompt.select("That username doesn't exist, would you like to create an account?", ["Yes", "No, return to main menu"])
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
            puts "Sorry, that username is already taken!"
            create_new_user
        else
            newUser = User.create(username:response)
            candy_set = prompt.ask("How many candies do you have?") do |q|
                    q.validate(/^-?[0-9]+$/, "Invalid input, please type a number")
                end
            newUser.candies = candy_set
            puts "Welcome #{response}, you have created an account with #{candy_set} candies."
        end
    end



# write methods above here
end

# cli = CLI.new
# # cli.opening_credits
# cli.greet_user
# login
# check_username