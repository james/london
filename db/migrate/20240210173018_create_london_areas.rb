class CreateLondonAreas < ActiveRecord::Migration[7.1]
  def change
    create_table :london_areas do |t|
      t.string :name
      t.string :type
      t.integer :score
      t.geometry :geometry

      t.timestamps
    end
  end
end
