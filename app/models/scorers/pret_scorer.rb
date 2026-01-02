module Scorers
  class PretScorer < BaseScorer
    MAX_POINTS = 10
    MAX_DISTANCE = 500

    def calculate
      if within_range?
        add_score(
          template: 'pret',
          address: nearest_pret.address,
          geo_point: nearest_pret.lonlat,
          points: MAX_POINTS
        )
      else
        add_miss(
          template: 'pret',
          address: nearest_pret.address,
          geo_point: nearest_pret.lonlat,
          points: MAX_POINTS
        )
      end
    end

    private

    def nearest_pret
      @nearest_pret ||= Pret.find_nearest(latitude, longitude)
    end

    def distance_to_nearest
      @distance_to_nearest ||= nearest_pret.distance_from(latitude, longitude)
    end

    def within_range?
      distance_to_nearest < MAX_DISTANCE
    end
  end
end
