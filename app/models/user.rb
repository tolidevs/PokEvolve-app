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
        pokemon_array = []
        self.all_my_pokemon.map { |poke|
                myPokemons = Hash.new
                myPokemons[:id] = poke.id 
                myPokemons[:name] = poke.pokemon_name
                pokemon_array.push(myPokemons)
        }
        pokemon_array
    end

    # send to the professor!
    # in CLI add are you sure, this can't be undone!
    def delete_pokemon_by_id(id)
        if Pokemon.find(id).user_id == self.id
            puts "#{Pokemon.find_name_by_id(id)} (ID:#{Pokemon.find(id).id}) sent to the professor!!"
            Pokemon.delete(id)
            self.candies += 1
            self.save
        else
            puts "Invalid Pokemon ID."
        end
    end

    def which_pokemons_can_i_evolve
        enough_candies = self.all_my_pokemon.select { |poke|
            poke.pokemon_family.candies_to_evolve <= self.see_my_candies
        }
        pokemon_array = []
        enough_candies.map { |poke| 
            myEvolvePokemon = Hash.new
            myEvolvePokemon[:id] = poke.id
            myEvolvePokemon[:name] = poke.pokemon_name
            myEvolvePokemon[:candies_to_evolve] = poke.pokemon_family.candies_to_evolve 
            pokemon_array.push(myEvolvePokemon)
        }
        pokemon_array
    end

    def can_i_evolve_this_pokemon(poke_id)
        if !self.all_my_pokemon.find { |poke| poke.id == poke_id }
            puts "Oh oh, it doesn't seem you have this pokemon."
        elsif self.which_pokemons_can_i_evolve.find { |poke| poke.id == poke_id }
            puts "Yes, you have enough candies to evolve your #{Pokemon.find_name_by_id(poke_id)}"
            true
        else
            puts "Sorry you don't have enough candies to evolve #{Pokemon.find_name_by_id(poke_id)}"
        end
    end




# write methods above here
    
end