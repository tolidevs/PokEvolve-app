class CreateNewEvolutionNamesColumnAsArrayType < ActiveRecord::Migration[6.0]                                                             
  def change
    add_column :pokemon_families, :evolution_names, :text, array: true
  end
end
