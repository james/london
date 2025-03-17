# frozen_string_literal: true

class AddCycleDocks < ActiveRecord::Migration[7.1]
  def up
    file = File.read(Rails.root.join('geojson', 'cycle_docks.json'))
    json = JSON.parse(file)

    json["stations"]["station"].each do |station|
      CycleDock.create!(
        name: station["name"],
        lonlat: "POINT(#{station["long"]} #{station["lat"]})",
      )
    end
  end

  def down
    CycleDock.destroy_all
  end
end
