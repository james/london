module Scorers
  class CycleDockScorer < BaseScorer
    MAX_POINTS = 10
    MAX_DISTANCE = 500

    def calculate
      if within_range?
        add_score(
          template: 'cycle_dock',
          name: nearest_dock.name,
          geo_point: nearest_dock.lonlat,
          points: MAX_POINTS
        )
      else
        add_miss(
          template: 'cycle_dock',
          name: nearest_dock.name,
          geo_point: nearest_dock.lonlat,
          points: MAX_POINTS
        )
      end
    end

    private

    def nearest_dock
      @nearest_dock ||= CycleDock.find_nearest(latitude, longitude)
    end

    def distance_to_nearest
      @distance_to_nearest ||= nearest_dock.distance_from(latitude, longitude)
    end

    def within_range?
      distance_to_nearest < MAX_DISTANCE
    end
  end
end
