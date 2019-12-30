class PokemonFamily < ActiveRecord::Base
    has_many :pokemons
end