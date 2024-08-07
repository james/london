require 'rails_helper'

RSpec.describe TubeStation, type: :model do
  describe "#find_nearest" do
    it "returns the nearest tube station" do
      tube_station = TubeStation.find_by(name: "Leyton Midland Road")
      nearest_station = TubeStation.find_nearest(51.5650, -0.0300)
      expect(nearest_station).to eq(tube_station)
    end
  end

  describe "#distance_from" do
    it "returns the correct distance from the given coordinates" do
      tube_station = TubeStation.find_by(name: "Leyton Midland Road")
      distance = tube_station.distance_from(51.5650, -0.0300)
      expect(distance).to eq(1654)
    end
  end
end
