# frozen_string_literal: true

class AddTravelToWork < ActiveRecord::Migration[7.1]
  def up
    file = File.read(Rails.root.join('geojson', 'travel_to_work.json'))
    geojson = RGeo::GeoJSON.decode(file, json_parser: :json)

    LondonArea.create!(
      name: "Travel to work",
      area_type: "travel_to_work",
      score: 10,
      geometry: geojson.first.geometry,
    )
  end

  def down
    LondonArea.where(area_type: "travel_to_work").destroy_all
  end
end
