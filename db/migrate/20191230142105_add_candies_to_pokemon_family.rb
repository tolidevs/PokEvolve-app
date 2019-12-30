class AddCandiesToPokemonFamily < ActiveRecord::Migration[6.0]
  def change
    add_column :pokemon_families, :candies_to_evolve, :integer
  end
end
