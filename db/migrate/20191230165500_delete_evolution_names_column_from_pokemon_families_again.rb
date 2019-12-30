class DeleteEvolutionNamesColumnFromPokemonFamiliesAgain < ActiveRecord::Migration[6.0]
  def change
    remove_column :pokemon_families, :evolution_names
  end
end
