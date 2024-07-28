# frozen_string_literal: true

class ImportTubeStations < ActiveRecord::Migration[7.1]
  def up
    file_path = Rails.root.join('geojson', 'tube_stations.json')
    tube_stations_data = JSON.parse(File.read(file_path))['features']

    tube_stations_data.each do |station|
      TubeStation.create!(
        name: station['properties']['name'],
        lonlat: "POINT(#{station['geometry']['coordinates'].first} #{station['geometry']['coordinates'].last})",
        zone: station['properties']['zone'],
        night: station['properties']['lines'].select{|x| x['nightopened']}.present?
      )
      p "created #{station['properties']['name']}"
    end
  end

  def down
    TubeStation.destroy_all
  end
end
