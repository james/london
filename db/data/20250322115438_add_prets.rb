# frozen_string_literal: true

class AddPrets < ActiveRecord::Migration[7.1]
  def up
    file = File.read(Rails.root.join('geojson', 'pret.json'))
    json = JSON.parse(file)

    json["response"]["locations"].each do |pret|
      Pret.create!(
        address: pret["streetAndNumber"],
        address_extra: pret["addressExtra"],
        lonlat: "POINT(#{pret["lng"]} #{pret["lat"]})",
      )
      p "added pret #{pret["id"]}"
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
