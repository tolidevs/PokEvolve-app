class User < ActiveRecord::Base
    has_many :pokemons
    has_many :pokemon_families, through: :pokemons

    def catch_pokemon(name)
        if !PokemonFamily.find_pokemon_family_by_name(name)
            puts "No such pokemon found!"
        else
            Pokemon.create(pokemon_name: name, pokemon_family_id: PokemonFamily.find_id_by_name(name), user_id: self.id)
            self.candies += 5
            self.save
        end 
    end

    def see_my_candies
        self.candies
    end

    def all_my_pokemon
        self.pokemons.all
    end

    def see_all_my_pokemon_with_id
        myPokemons = Hash.new
        self.all_my_pokemon.map { |pokemon|
            myPokemons[pokemon.id] = pokemon.pokemon_name
        }
        myPokemons
    end

    # send to the professor!
    # in CLI add are you sure, this can't be undone!
    def delete_pokemon_by_id(id)
        if Pokemon.find(id).user_id == self.id
            puts "#{Pokemon.find(id).pokemon_name} (ID:#{Pokemon.find(id).id}) sent to the professor!!"
            Pokemon.delete(id)
            self.candies += 1
            self.save
        else
            puts "Invalid Pokemon ID."
        end
    end

    # def which_pokemons_can_i_evolve
    #     self.all_my_pokemon.select { |pokemon|
    #         pokemon.
    #     }
    # end




# write methods above here
    
end