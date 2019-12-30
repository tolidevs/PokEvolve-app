class DeletePokemonFamilyEvolutionColumnsAddName < ActiveRecord::Migration[6.0]
  def change
    add_column :pokemon_families, :evolution_names, :string 
    remove_column :pokemon_families, :evolution_1
    remove_column :pokemon_families, :evolution_2
    remove_column :pokemon_families, :evolution_3
  end
end
