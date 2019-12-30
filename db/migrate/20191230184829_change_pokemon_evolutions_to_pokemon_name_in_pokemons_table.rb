class ChangePokemonEvolutionsToPokemonNameInPokemonsTable < ActiveRecord::Migration[6.0]
  def change
      rename_column :pokemons, :pokemon_evolution, :pokemon_name
  end
end
