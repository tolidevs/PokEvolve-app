class CreatePokemons < ActiveRecord::Migration[6.0]
  def change
        create_table :pokemons do |t|
          t.string :pokemon_name
          t.integer :pokemon_family_id
          t.integer :user_id
        end
  end
end
