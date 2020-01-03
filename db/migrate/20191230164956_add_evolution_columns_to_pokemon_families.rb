class AddEvolutionColumnsToPokemonFamilies < ActiveRecord::Migration[6.0]
  def change
    add_column :pokemon_families, :evolution_1, :string
    add_column :pokemon_families, :evolution_2, :string
    add_column :pokemon_families, :evolution_3, :string
  end
end
