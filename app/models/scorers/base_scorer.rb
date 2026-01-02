module Scorers
  class BaseScorer
    attr_reader :latitude, :longitude, :scores, :misses

    def initialize(latitude, longitude)
      @latitude = latitude
      @longitude = longitude
      @scores = []
      @misses = []
    end

    # Override in subclasses
    def calculate
      raise NotImplementedError, "#{self.class} must implement #calculate"
    end

    protected

    def add_score(**attributes)
      @scores << Score.new(attributes)
    end

    def add_miss(**attributes)
      @misses << Score.new(attributes)
    end
  end
end
