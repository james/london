module Scorers
  class AreaScorer < BaseScorer
    def calculate
      found_area_types = []

      areas.each do |area|
        add_score(
          name: area.name,
          template: area.area_type,
          points: area.score,
          geojson: area.geojson
        )
        found_area_types << area.area_type
      end

      add_area_misses(found_area_types)
    end

    private

    def areas
      @areas ||= LondonArea.find_by_latitude_and_longitude(latitude, longitude)
    end

    def add_area_misses(found_area_types)
      all_area_types = LondonArea.distinct.pluck(:area_type).compact
      missed_area_types = all_area_types - found_area_types

      missed_area_types.each do |area_type|
        # Skip outer_borough miss if inner_borough was found
        next if area_type == 'outer_borough' && found_area_types.include?('inner_borough')

        max_score = LondonArea.where(area_type: area_type).maximum(:score) || 0
        add_miss(template: area_type, points: max_score)
      end
    end
  end
end
