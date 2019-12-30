class User < ActiveRecord::Base
    has_many :pokemons
    has_many :pokemon_families, through: :pokemons

    def self.catch_pokemon(name)
        PokemonFamily.find_pokemon_by_name(name)
        
    end

    
end