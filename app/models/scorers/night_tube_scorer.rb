module Scorers
  class NightTubeScorer < BaseScorer
    MAX_POINTS = 20
    MAX_DISTANCE = 2500

    def calculate
      if within_range?
        add_score(
          template: 'night_tube',
          name: nearest_station.name,
          geo_point: nearest_station.lonlat,
          points: MAX_POINTS
        )
      else
        add_miss(
          template: 'night_tube',
          name: nearest_station.name,
          geo_point: nearest_station.lonlat,
          points: MAX_POINTS
        )
      end
    end

    private

    def nearest_station
      @nearest_station ||= TubeStation.night_stations.find_nearest(latitude, longitude)
    end

    def distance_to_nearest
      @distance_to_nearest ||= nearest_station.distance_from(latitude, longitude)
    end

    def within_range?
      distance_to_nearest < MAX_DISTANCE
    end
  end
end
