class Pokemon < ActiveRecord::Base
    belongs_to :user
    belongs_to :pokemon_family

    def self.find_name_by_id(poke_id)
        self.find(poke_id).pokemon_name
    end

    def my_candies_to_evolve
        self.pokemon_family.candies_to_evolve
    end

end