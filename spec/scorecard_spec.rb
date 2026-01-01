require 'rails_helper'

RSpec.describe Scorecard, type: :model do
  describe "Leyton" do
    let(:latitude) { 51.56185 }
    let(:longitude) { -0.013446 }
    let(:scorecard) { Scorecard.new(latitude, longitude) }

    it "returns Leyton Midland station as the nearest station" do
      leyton_station = TubeStation.find_by(name: 'Leyton')
      expect(scorecard.nearest_tube_station).to eq(leyton_station)
    end

    it "returns Leyton station as the nearest night station" do
      leyton_station = TubeStation.find_by(name: 'Leyton')
      expect(scorecard.nearest_night_tube_station).to eq(leyton_station)
    end

    it "returns Here East North as nearest cycle dock" do
      cycle_dock = CycleDock.find_by(name: 'Lee Valley VeloPark, Queen Elizabeth Olympic Park')
      expect(scorecard.nearest_cycle_dock).to eq(cycle_dock)
    end

    it "returns 1881 for distance to nearest cycle dock" do
      expect(scorecard.distance_to_nearest_cycle_dock).to eq(1397)
    end

    it "returns a ptal value" do
      expect(scorecard.ptal_value).to be_a(PtalValue)
    end

    it "returns 52% as percentage of maximum score" do
      expect(scorecard.percentage_of_max_score).to eq(52)
    end
  end

  describe "#max_score" do
    it "returns the maximum score" do
      expect(Scorecard.max_score).to eq(280)
    end
  end

  describe "misses" do
    let(:latitude) { 51.5650 }
    let(:longitude) { -0.0300 }
    let(:scorecard) { Scorecard.new(latitude, longitude) }

    it "initializes misses array" do
      expect(scorecard.misses).to be_an(Array)
    end

    it "adds misses for non-maximum scores" do
      expect(scorecard.misses).not_to be_empty
    end

    it "includes missed points for tube zones not being Zone 1" do
      tube_miss = scorecard.misses.find { |m| m.template == 'nearest_tube_wrong_zone' }
      expect(tube_miss).to be_present
      expect(tube_miss.points).to be > 0
    end

    it "has night tube in scores (Leyton has night tube service)" do
      night_tube_score = scorecard.scores.find { |s| s.template == 'night_tube' }
      expect(night_tube_score).to be_present
      expect(night_tube_score.points).to eq(20)
    end

    it "includes miss for no nearby cycle dock" do
      cycle_miss = scorecard.misses.find { |m| m.template == 'cycle_dock' }
      expect(cycle_miss).to be_present
      expect(cycle_miss.points).to eq(10)
    end

    it "includes miss for no nearby Pret" do
      pret_miss = scorecard.misses.find { |m| m.template == 'pret' }
      expect(pret_miss).to be_present
      expect(pret_miss.points).to eq(10)
    end

    it "includes miss for PTAL not being 6b" do
      ptal_miss = scorecard.misses.find { |m| m.template == 'ptal' }
      expect(ptal_miss).to be_present
      expect(ptal_miss.points).to be > 0
    end

    context "for central London location" do
      let(:latitude) { 51.50101 }
      let(:longitude) { -0.141563 }
      let(:scorecard) { Scorecard.new(latitude, longitude) }

      it "has fewer misses" do
        expect(scorecard.misses.length).to be < 5
      end

      it "does not include tube miss if in Zone 1" do
        tube_score = scorecard.scores.find { |s| s.template == 'nearest_tube' }
        if tube_score&.zone == 1
          tube_miss = scorecard.misses.find { |m| m.template == 'nearest_tube' }
          expect(tube_miss).to be_nil
        end
      end
    end
  end
end
