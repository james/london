# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_03_22_131146) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "cycle_docks", force: :cascade do |t|
    t.string "name"
    t.geography "lonlat", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
  end

  create_table "london_areas", force: :cascade do |t|
    t.string "name"
    t.string "area_type"
    t.integer "score"
    t.geography "geometry", limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "geojson"
    t.index ["geometry"], name: "index_london_areas_on_geometry", using: :gist
  end

  create_table "prets", force: :cascade do |t|
    t.geography "lonlat", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.string "address"
    t.string "address_extra"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ptal_values", force: :cascade do |t|
    t.geography "lonlat", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.float "byai"
    t.string "byptal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lonlat"], name: "index_ptal_values_on_lonlat"
  end

  create_table "tube_stations", force: :cascade do |t|
    t.string "name"
    t.geography "lonlat", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.string "zone"
    t.boolean "night"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
