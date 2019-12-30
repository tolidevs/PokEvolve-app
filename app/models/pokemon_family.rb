class PokemonFamily < ActiveRecord::Base
    has_many :pokemons


    def self.find_pokemon_by_name(name)
        if self.find_by(evolution_1:name)
            self.find_by(evolution_1:name)
        elsif self.find_by(evolution_2:name)
            self.find_by(evolution_2:name)
        elsif self.find_by(evolution_3:name)
            self.find_by(evolution_3:name)
        else 
            puts "Sorry, this Pokemon does not exist!"
        end
    end

end