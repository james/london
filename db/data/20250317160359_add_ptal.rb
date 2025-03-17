# frozen_string_literal: true

class AddPtal < ActiveRecord::Migration[7.1]
  def up
    require 'csv'
    file = File.open(Rails.root.join('geojson/ptal_values.csv'))
    csv = CSV.parse(file, headers: true)
    csv.each do |row|
      if row['BYAI'] != "0"
        ActiveRecord::Base.connection.execute(
          <<-SQL
            INSERT INTO ptal_values (lonlat, byai, byptal, created_at, updated_at)
            VALUES (
              ST_Transform(ST_SetSRID(ST_MakePoint(#{row["X"]}, #{row["Y"]}), 27700), 4326),
              '#{row['BYAI']}',
              '#{row['BYPTAL']}',
              '#{Time.now}',
              '#{Time.now}'
            )
          SQL
        )
        p "added ptal #{row['ID']}"
      end
    end
  end

  def down
    PtalValue.destroy_all
  end
end
