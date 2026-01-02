module Scorers
  class PtalScorer < BaseScorer
    MAX_POINTS = 50
    SEARCH_RADIUS = 100

    LEVEL_POINTS = {
      "1a" => 1,
      "1b" => 2,
      "2" => 5,
      "3" => 10,
      "4" => 20,
      "5" => 30,
      "6a" => 40,
      "6b" => 50
    }.freeze

    def calculate
      if ptal_value
        points = calculate_level_points

        add_score(
          template: 'ptal',
          name: ptal_value.byptal,
          points: points
        )

        add_level_miss(points) if points < MAX_POINTS
      else
        add_no_data_miss
      end
    end

    private

    def ptal_value
      @ptal_value ||= PtalValue.within_radius(latitude, longitude, SEARCH_RADIUS).first
    end

    def calculate_level_points
      LEVEL_POINTS[ptal_value.byptal] || 0
    end

    def add_level_miss(points)
      missed_points = MAX_POINTS - points
      add_miss(
        template: 'ptal',
        name: ptal_value.byptal,
        points: missed_points
      )
    end

    def add_no_data_miss
      add_miss(
        template: 'ptal',
        name: nil,
        points: MAX_POINTS
      )
    end
  end
end
