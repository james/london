class AddGeojsonToLondonAreas < ActiveRecord::Migration[7.1]
  def change
    add_column :london_areas, :geojson, :string
  end
end
