module Scorers
  class TubeScorer < BaseScorer
    MAX_POINTS = 50
    MAX_DISTANCE = 5000

    ZONE_POINTS = {
      1 => 50,
      2 => 40,
      3 => 30,
      4 => 20,
      5 => 10,
      6 => 5,
      7 => 4,
      8 => 3,
      9 => 2,
      10 => 1
    }.freeze

    def calculate
      if within_range?
        points = calculate_zone_points

        if points > 0
          add_score(
            template: 'nearest_tube',
            name: nearest_station.name,
            zone: nearest_station.zone.to_i,
            geo_point: nearest_station.lonlat,
            points: points
          )

          add_zone_miss(points) if points < MAX_POINTS
        end
      else
        add_distance_miss
      end
    end

    private

    def nearest_station
      @nearest_station ||= TubeStation.find_nearest(latitude, longitude)
    end

    def distance_to_nearest
      @distance_to_nearest ||= nearest_station.distance_from(latitude, longitude)
    end

    def within_range?
      distance_to_nearest < MAX_DISTANCE
    end

    def calculate_zone_points
      ZONE_POINTS[nearest_station.zone.to_i] || 0
    end

    def add_zone_miss(points)
      missed_points = MAX_POINTS - points
      add_miss(
        template: 'nearest_tube_wrong_zone',
        name: nearest_station.name,
        zone: nearest_station.zone.to_i,
        geo_point: nearest_station.lonlat,
        points: missed_points
      )
    end

    def add_distance_miss
      add_miss(
        template: 'nearest_tube_too_far',
        name: nearest_station.name,
        zone: nearest_station.zone.to_i,
        geo_point: nearest_station.lonlat,
        points: MAX_POINTS
      )
    end
  end
end
