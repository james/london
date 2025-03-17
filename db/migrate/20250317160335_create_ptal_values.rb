class CreatePtalValues < ActiveRecord::Migration[7.1]
  def change
    create_table :ptal_values do |t|
      t.st_point :lonlat, geographic: true
      t.float :byai
      t.string :byptal

      t.timestamps
    end
  end
end
