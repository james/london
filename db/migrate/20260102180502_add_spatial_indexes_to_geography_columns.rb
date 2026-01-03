class AddSpatialIndexesToGeographyColumns < ActiveRecord::Migration[7.1]
  def change
    # Add GIST indexes for spatial queries on geography columns
    add_index :tube_stations, :lonlat, using: :gist, if_not_exists: true
    add_index :cycle_docks, :lonlat, using: :gist, if_not_exists: true
    add_index :prets, :lonlat, using: :gist, if_not_exists: true
    add_index :ptal_values, :lonlat, using: :gist, if_not_exists: true

    # Add index on night column for filtered queries
    add_index :tube_stations, :night, if_not_exists: true
  end
end
