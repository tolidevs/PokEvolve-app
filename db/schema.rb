# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_30_145910) do

  create_table "pokemon_families", force: :cascade do |t|
    t.integer "candies_to_evolve"
    t.string "evolution_names"
  end

  create_table "pokemons", force: :cascade do |t|
    t.string "pokemon_evolution"
    t.integer "pokemon_family_id"
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.integer "candies"
  end

end
