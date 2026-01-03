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
      missed_area_types = all_area_types_with_scores.keys - found_area_types

      missed_area_types.each do |area_type|
        # Skip outer_borough miss if inner_borough was found
        next if area_type == 'outer_borough' && found_area_types.include?('inner_borough')

        max_score = all_area_types_with_scores[area_type] || 0
        add_miss(template: area_type, points: max_score)
      end
    end

    # Cache area types and their max scores to avoid N+1 queries
    def all_area_types_with_scores
      @all_area_types_with_scores ||= Rails.cache.fetch('london_area_types_with_max_scores', expires_in: 1.day) do
        LondonArea
          .where.not(area_type: nil)
          .group(:area_type)
          .maximum(:score)
      end
    end
  end
end
