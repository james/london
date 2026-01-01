# frozen_string_literal: true

class UpdateM25Geometry < ActiveRecord::Migration[7.1]
  def up
    # Load the correct M25 geometry from the high-res GeoJSON file
    file = File.read(Rails.root.join('geojson', 'm25_enclosure_highres.geojson'))
    data = JSON.parse(file)
    geojson = RGeo::GeoJSON.decode(file, json_parser: :json)

    # Find the M25 road boundary record
    m25 = LondonArea.find_by(name: "M25", area_type: "road_boundary")

    if m25 && geojson.first && data['features']&.first
      feature = data['features'].first

      # Update with the correct geometry and geojson from the file
      m25.update!(
        geometry: geojson.first.geometry,
        geojson: feature.to_json
      )
      p "Updated M25 geometry and geojson from high-res GeoJSON"
    else
      p "Warning: M25 road boundary not found or GeoJSON invalid"
    end
  end

  def down
    # This migration updates geometry and is not easily reversible
    raise ActiveRecord::IrreversibleMigration
  end
end
