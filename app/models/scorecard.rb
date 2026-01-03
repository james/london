class Scorecard
  attr_reader :latitude, :longitude, :scores, :misses

  # Coordinate for maximum possible score (central London)
  MAX_SCORE_LOCATION = { latitude: 51.514188, longitude: -0.088622 }.freeze

  # Order matters: scorers are executed in this sequence
  SCORERS = [
    Scorers::AreaScorer,
    Scorers::TubeScorer,
    Scorers::NightTubeScorer,
    Scorers::CycleDockScorer,
    Scorers::PretScorer,
    Scorers::PtalScorer
  ].freeze

  def self.max_score
    new(MAX_SCORE_LOCATION[:latitude], MAX_SCORE_LOCATION[:longitude]).total_points
  end

  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
    @scores = []
    @misses = []

    calculate_scores
  end

  def total_points
    scores.sum(&:points)
  end

  def percentage_of_max_score
    ((total_points.to_f / self.class.max_score) * 100).round
  end

  # Legacy method for backwards compatibility
  def areas
    @areas ||= LondonArea.find_by_latitude_and_longitude(latitude, longitude)
  end

  # Legacy methods for backwards compatibility - delegate to scorer internals if needed
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
    @ptal_value ||= PtalValue.within_radius(latitude, longitude, 100).first
  end

  private

  def calculate_scores
    SCORERS.each do |scorer_class|
      scorer = scorer_class.new(latitude, longitude)
      scorer.calculate
      @scores.concat(scorer.scores)
      @misses.concat(scorer.misses)
    end
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

  def percentage_points
    ((points.to_f / Scorecard.max_score) * 100).round(1)
  end
end
