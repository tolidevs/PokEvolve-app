class Pokemon < ActiveRecord::Base
    belongs_to :user
    belongs_to :pokemon_family

    def self.find_name_by_id(poke_id)
        self.find(poke_id).pokemon_name
    end

    def my_candies_to_evolve
        self.pokemon_family.candies_to_evolve
    end

    def do_i_have_another_evolution
        name = self.pokemon_name
        family = PokemonFamily.find_pokemon_family_by_name(name)
        if family.evolution_1 == name && family.evolution_2 != nil
            true
        elsif  family.evolution_2 == name && family.evolution_3 != nil
            true
        elsif  family.evolution_3 == name 
            false
        end
    end


end