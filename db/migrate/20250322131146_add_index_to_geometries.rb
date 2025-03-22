class AddIndexToGeometries < ActiveRecord::Migration[7.1]
  def change
    add_index :london_areas, :geometry, using: :gist
    add_index :ptal_values, :lonlat
  end
end
