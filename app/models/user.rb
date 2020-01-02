class User < ActiveRecord::Base
    has_many :pokemons
    has_many :pokemon_families, through: :pokemons

    def catch_pokemon(name)
        if !PokemonFamily.find_pokemon_family_by_name(name)
            # puts "No such pokemon found!"   --------- Duplicate puts, a method in pokemon_familyalready puts Sorry, this Pokemon does not exist!
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
        # if !Pokemon.find(id)                   --------------------------It returns an error message
        #     puts "Sorry, I couldn't find this pokemon on my records"
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
        # enough_candies = self.all_my_pokemon.select { |poke|
        #     poke.my_candies_to_evolve <= self.see_my_candies
        # }
        enough_candies = self.all_my_pokemon
            binding.pry
        pokemon_array = []
        enough_candies.map { |poke| 
            myEvolvePokemon = Hash.new
            myEvolvePokemon[:id] = poke.id
            myEvolvePokemon[:name] = poke.pokemon_name
            myEvolvePokemon[:candies_to_evolve] = poke.my_candies_to_evolve 
            pokemon_array.push(myEvolvePokemon)
        }
        pokemon_array
    end

    def can_i_evolve_this_pokemon(poke_id) #----same problem here when user input an id that does not exist it gives an error message
        pokemonName = Pokemon.find(poke_id).pokemon_name
        if !self.all_my_pokemon.find { |poke| poke[:id] == poke_id }
            puts "Oh oh, it doesn't seem you have this pokemon."
        elsif !PokemonFamily.do_i_have_another_evolution(pokemonName)
            puts "Sorry, this pokemon has reached its maximum evolutions!"
        elsif self.which_pokemons_can_i_evolve.find { |poke| poke[:id] == poke_id }
            puts "Cool, you have enough candies to evolve your #{Pokemon.find_name_by_id(poke_id)}"
            true
        else
            puts "Sorry you don't have enough candies to evolve #{Pokemon.find_name_by_id(poke_id)}"
        end
    end

    def evolve_and_change_name(poke_id)
        pokemonToEvolve = Pokemon.find(poke_id)
        if self.can_i_evolve_this_pokemon(poke_id)
            evolutionNumber = PokemonFamily.find_evolution_level_by_name(pokemonToEvolve.pokemon_name)
            if evolutionNumber == 1
                pokemonToEvolve.pokemon_name = pokemonToEvolve.pokemon_family.evolution_2
                pokemonToEvolve.save
                self.candies -= pokemonToEvolve.my_candies_to_evolve
                puts "Evolved pokemon id: #{poke_id}! Now it's a #{pokemonToEvolve.pokemon_name}!"
            elsif evolutionNumber == 2
                pokemonToEvolve.pokemon_name = pokemonToEvolve.pokemon_family.evolution_3
                pokemonToEvolve.save
                self.candies -= pokemonToEvolve.my_candies_to_evolve
                puts "Evolved pokemon id: #{poke_id}! Now it's a #{pokemonToEvolve.pokemon_name}!"
            elsif evolutionNumber == 3 
                puts "Sorry, maximum evolutions achieved!!"
            end
            self.save
        end
                
    end

    



# write methods above here
    
end