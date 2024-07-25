# frozen_string_literal: true

class ImportBoroughs < ActiveRecord::Migration[7.1]
  def up
    file = File.read(Rails.root.join('geojson', 'london_boroughs.json'))
    geojson = RGeo::GeoJSON.decode(file, json_parser: :json)

    geojson.each do |feature|
      if feature.properties['inner_statistical']
        LondonArea.create!(
          name: feature.properties['name'],
          area_type: "Inner London Borough",
          score: 20,
          geometry: feature.geometry,
        )
      else
        LondonArea.create!(
          name: feature.properties['name'],
          area_type: "Outer London Borough",
          score: 10,
          geometry: feature.geometry,
        )
      end
      p "created #{feature.properties['name']}"
    end
  end

  def down
    LondonArea.destroy_all
  end
end
