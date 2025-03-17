require 'rails_helper'

RSpec.describe Scorecard, type: :model do
  describe "Leyton" do
    let(:latitude) { 51.5650 }
    let(:longitude) { -0.0300 }
    let(:scorecard) { Scorecard.new(latitude, longitude) }
    it "returns Leyton Midland station as the nearest station" do
      leyton_midland_station = TubeStation.find_by(name: 'Leyton Midland Road')
      expect(scorecard.nearest_tube_station).to eq(leyton_midland_station)
    end

    it "returns Leyton station as the nearest night station" do
      leyton_station = TubeStation.find_by(name: 'Leyton')
      expect(scorecard.nearest_night_tube_station).to eq(leyton_station)
    end

    it "returns Here East North as nearest cycle dock" do
      cycle_dock = CycleDock.find_by(name: 'Here East North, Queen Elizabeth Olympic Park')
      expect(scorecard.nearest_cycle_dock).to eq(cycle_dock)
    end

    it "returns 1881 for distance to nearest cycle dock" do
      expect(scorecard.distance_to_nearest_cycle_dock).to eq(1881)
    end

    it "returns 69% as percentage of maximum score" do
      expect(scorecard.percentage_of_max_score).to eq(68)
    end
  end

  describe "#max_score" do
    it "returns the maximum score" do
      expect(Scorecard.max_score).to eq(190)
    end
  end
end
