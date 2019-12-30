class Pokemon < ActiveRecord::Base
    belongs_to :user
    belongs_to :pokemon_families

end