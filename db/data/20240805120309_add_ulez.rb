# frozen_string_literal: true

class AddUlez < ActiveRecord::Migration[7.1]
  def up
    file = File.read(Rails.root.join('geojson', 'ulez.json'))
    geojson = RGeo::GeoJSON.decode(file, json_parser: :json)

    geojson.each do |feature|
      LondonArea.create!(
        name: feature.properties['layer'],
        area_type: "ULEZ",
        score: 20,
        geometry: feature.geometry,
      )
      p "created #{feature.properties['layer']}"
    end
  end

  def down
    LondonArea.where(area_type: "ULEZ").destroy_all
  end
end
