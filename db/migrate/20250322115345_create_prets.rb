class CreatePrets < ActiveRecord::Migration[7.1]
  def change
    create_table :prets do |t|
      t.st_point :lonlat, geographic: true
      t.string :address
      t.string :address_extra

      t.timestamps
    end
  end
end
