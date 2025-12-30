class Scorecard
  attr_accessor :latitude, :longitude, :scores, :misses

  def self.max_score
    self.new(51.501009, -0.141588).total_points
  end

  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
    @scores = []
    @misses = []

    areas.each do |area|
      scores << Score.new(name: area.name, template: area.area_type, points: area.score, geojson: area.geojson)
    end

    # Tube station scoring
    max_tube_points = 50
    if distance_to_nearest_tube_station < 5000
      points = case nearest_tube_station.zone.to_i
           when 1 then 50
           when 2 then 40
           when 3 then 30
           when 4 then 20
           when 5 then 10
           when 6 then 5
           when 7 then 4
           when 8 then 3
           when 9 then 2
           when 10 then 1
           else 0
           end

      if points > 0
        scores << Score.new(template: 'nearest_tube', name: nearest_tube_station.name, zone: nearest_tube_station.zone.to_i, geo_point: nearest_tube_station.lonlat, points: points)

        # Add miss if not the maximum score for this category
        if points < max_tube_points
          missed_points = max_tube_points - points
          misses << Score.new(template: 'nearest_tube_wrong_zone', name: nearest_tube_station.name, zone: nearest_tube_station.zone.to_i, geo_point: nearest_tube_station.lonlat, points: missed_points)
        end
      end
    else
      # No tube station within range
      misses << Score.new(template: 'nearest_tube_too_far', name: nearest_tube_station.name, zone: nearest_tube_station.zone.to_i, geo_point: nearest_tube_station.lonlat, points: max_tube_points)
    end

    # Night tube scoring
    max_night_tube_points = 20
    if distance_to_nearest_night_tube_station < 2500
      scores << Score.new(template: 'night_tube', name: nearest_night_tube_station.name, geo_point: nearest_night_tube_station.lonlat, points: max_night_tube_points)
    else
      misses << Score.new(template: 'night_tube', name: nearest_night_tube_station.name, geo_point: nearest_night_tube_station.lonlat, points: max_night_tube_points)
    end

    # Cycle dock scoring
    max_cycle_dock_points = 10
    if distance_to_nearest_cycle_dock < 500
      scores << Score.new(template: 'cycle_dock', name: nearest_cycle_dock.name, geo_point: nearest_cycle_dock.lonlat, points: max_cycle_dock_points)
    else
      misses << Score.new(template: 'cycle_dock', name: nearest_cycle_dock.name, geo_point: nearest_cycle_dock.lonlat, points: max_cycle_dock_points)
    end

    # Pret scoring
    max_pret_points = 10
    if distance_to_nearest_pret < 500
      scores << Score.new(template: 'pret', address: nearest_pret.address, geo_point: nearest_pret.lonlat, points: max_pret_points)
    else
      misses << Score.new(template: 'pret', address: nearest_pret.address, geo_point: nearest_pret.lonlat, points: max_pret_points)
    end

    # PTAL scoring
    max_ptal_points = 50
    if ptal_value
      points = case ptal_value.byptal
        when "1a" then 1
        when "1b" then 2
        when "2" then 5
        when "3" then 10
        when "4" then 20
        when "5" then 30
        when "6a" then 40
        when "6b" then 50
        else 0
        end

      scores << Score.new(template: 'ptal', name: ptal_value.byptal, points: points)

      # Add miss if not the maximum score for this category
      if points < max_ptal_points
        missed_points = max_ptal_points - points
        misses << Score.new(template: 'ptal', name: ptal_value.byptal, points: missed_points)
      end
    else
      misses << Score.new(template: 'ptal', name: nil, points: max_ptal_points)
    end
  end

  def areas
    @areas ||= LondonArea.find_by_latitude_and_longitude(latitude, longitude)
  end

  def nearest_tube_station
    @nearest_tube_station ||= TubeStation.find_nearest(latitude, longitude)
  end

  def distance_to_nearest_tube_station
    @distance_to_nearest_tube_station ||= nearest_tube_station.distance_from(latitude, longitude)
  end

  def nearest_night_tube_station
    @nearest_night_tube_station ||= TubeStation.night_stations.find_nearest(latitude, longitude)
  end

  def distance_to_nearest_night_tube_station
    @distance_to_nearest_night_tube_station ||= nearest_night_tube_station.distance_from(latitude, longitude)
  end

  def nearest_cycle_dock
    @nearest_cycle_dock ||= CycleDock.find_nearest(latitude, longitude)
  end

  def distance_to_nearest_cycle_dock
    @distance_to_nearest_cycle_dock ||= nearest_cycle_dock.distance_from(latitude, longitude)
  end

  def nearest_pret
    @nearest_pret ||= Pret.find_nearest(latitude, longitude)
  end

  def distance_to_nearest_pret
    @distance_to_nearest_pret ||= nearest_pret.distance_from(latitude, longitude)
  end

  def ptal_value
    @ptal_value ||=  PtalValue.within_radius(latitude, longitude, 100).first
  end

  def total_points
    scores.collect(&:points).sum
  end

  def percentage_of_max_score
    ((total_points.to_f / self.class.max_score.to_f) * 100).round
  end
end

class Score
  attr_accessor :name, :template, :points, :geojson, :zone, :geo_point
  def initialize(args = {})
    @name = args[:name]
    @template = args[:template]
    @points = args[:points]
    @geojson = args[:geojson]
    @zone = args[:zone]
    @geo_point = args[:geo_point]
  end
end
