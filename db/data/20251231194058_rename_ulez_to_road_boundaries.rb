# frozen_string_literal: true

class RenameUlezToRoadBoundaries < ActiveRecord::Migration[7.1]
  def up
    # Map ULEZ zones to their corresponding road boundaries
    name_mapping = {
      "ULEZ 2019" => "London Inner Ring Road",
      "ULEZ 2021" => "North and South Circular",
      "ULEZ 2023" => "M25"
    }

    # Update existing ULEZ records to use road boundary names and type
    name_mapping.each do |old_name, new_name|
      area = LondonArea.find_by(name: old_name, area_type: "ulez")
      if area
        area.update!(name: new_name, area_type: "road_boundary")
        p "renamed #{old_name} to #{new_name}"
      else
        p "warning: #{old_name} not found"
      end
    end
  end

  def down
    # Reverse the mapping
    name_mapping = {
      "London Inner Ring Road" => "ULEZ 2019",
      "North and South Circular" => "ULEZ 2021",
      "M25" => "ULEZ 2023"
    }

    # Revert road boundary records back to ULEZ names and type
    name_mapping.each do |old_name, new_name|
      area = LondonArea.find_by(name: old_name, area_type: "road_boundary")
      if area
        area.update!(name: new_name, area_type: "ulez")
        p "reverted #{old_name} to #{new_name}"
      end
    end
  end
end
