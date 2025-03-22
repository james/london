class MakePtalLonlatGeographic < ActiveRecord::Migration[7.1]
  def change
    change_column :ptal_values, :lonlat, :st_point, geographic: true
  end
end
