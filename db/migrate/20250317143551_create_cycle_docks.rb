class CreateCycleDocks < ActiveRecord::Migration[7.1]
  def change
    create_table :cycle_docks do |t|
      t.string :name
      t.st_point :lonlat, geographic: true

      t.timestamps
    end
  end
end
