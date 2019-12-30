class CreatePokemonFamilies < ActiveRecord::Migration[6.0]
  def change
    create_table :pokemon_families do |t|
      t.string :evolution_1
      t.string :evolution_2
      t.string :evolution_3
    end
  end
end
