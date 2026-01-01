# frozen_string_literal: true

class AddCityOfLondon < ActiveRecord::Migration[7.1]
  def up
    file = File.read(Rails.root.join('geojson', 'london_wall.geojson'))
    data = JSON.parse(file)
    factory = RGeo::Geographic.spherical_factory(srid: 4326)

    data['features'].each do |feature|
      next unless feature['geometry'] && feature['geometry']['coordinates']

      begin
        geometry = case feature['geometry']['type']
        when 'Polygon'
          coordinates = feature['geometry']['coordinates'][0]
          next if coordinates.length < 4 # Skip invalid polygons
          factory.polygon(factory.linear_ring(coordinates.map { |c| factory.point(c[0], c[1]) }))
        when 'MultiPolygon'
          polygons = feature['geometry']['coordinates'].map do |poly|
            next if poly[0].length < 4 # Skip invalid polygons
            factory.polygon(factory.linear_ring(poly[0].map { |c| factory.point(c[0], c[1]) }))
          end.compact
          factory.multi_polygon(polygons)
        else
          next # Skip unsupported geometry types
        end

        LondonArea.create!(
          name: "Historical London Wall",
          area_type: "london_wall",
          score: 20,
          geometry: geometry,
          geojson: feature.to_json
        )
        p "created Historical London Wall"
      rescue StandardError => e
        puts "Error processing feature: #{e.message}"
        next
      end
    end
  end

  def down
    LondonArea.where(area_type: "london_wall").destroy_all
  end
end
