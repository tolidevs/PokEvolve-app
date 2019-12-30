class User < ActiveRecord::Base
    has_many :pokemons
    has_many :pokemon_families, through: :pokemons

end