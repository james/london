class RenameLondonAreasTypeToAreaType < ActiveRecord::Migration[7.1]
  def change
    rename_column :london_areas, :type, :area_type
  end
end
