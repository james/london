# frozen_string_literal: true

class ImportPostcodes < ActiveRecord::Migration[7.1]
  def up
    Dir.glob(Rails.root.join('geojson', 'postcodes', '*.geojson')).each do |file_path|
      file = File.read(file_path)
      geojson = RGeo::GeoJSON.decode(file, json_parser: :json)

      geojson.each do |feature|
        LondonArea.create!(
          name: feature.properties['description'],
          area_type: "London Post Code",
          score: 10,
          geometry: feature.geometry,
        )
        p "Created #{feature.properties['description']}"
      end
    end
  end

  def down
    LondonArea.where(area_type: "London Post Code").destroy_all
  end
end
