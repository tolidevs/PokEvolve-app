class ChangePokemonNameToEvolution < ActiveRecord::Migration[6.0]
  def change
    rename_column :pokemons, :pokemon_name, :pokemon_evolution
  end
end
