# frozen_string_literal: true

class AddPhoneAreas < ActiveRecord::Migration[7.1]
  def up
    file = File.read(Rails.root.join('geojson', '020.json'))
    geojson = RGeo::GeoJSON.decode(file, json_parser: :json)

    LondonArea.create!(
      name: "020",
      area_type: "phone",
      score: 10,
      geometry: geojson,
    )
  end

  def down
    LondonArea.where(area_type: "phone").destroy_all
  end
end
