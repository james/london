class CreateTubeStations < ActiveRecord::Migration[7.1]
  def change
    create_table :tube_stations do |t|
      t.string :name
      t.st_point :lonlat, geographic: true
      t.string :zone
      t.boolean :night

      t.timestamps
    end
  end
end
