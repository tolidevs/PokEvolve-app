class ChangePokemonFamilyEvolutionNameToArray < ActiveRecord::Migration[6.0]
  def change
    change_column :pokemon_families, :evolution_names, :string, array: true
  end
end
