# frozen_string_literal: true

class AddGeojsonCache < ActiveRecord::Migration[7.1]
  def up
    LondonArea.find_each do |area|
      area.update_column(:geojson, RGeo::GeoJSON.encode(area.geometry).to_json)
    end
  end

  def down
    LondonArea.update_all(geojson: nil)
  end
end
