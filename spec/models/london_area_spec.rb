require 'rails_helper'

RSpec.describe LondonArea, type: :model do
  describe "find_by_latitude_and_longitude" do
    let(:areas) { LondonArea.find_by_latitude_and_longitude(51.5650, -0.0300) }
    # Leyton
    it "returns the E post code" do
      postcode = LondonArea.find_by(name: 'E10 postcode district')
      expect(areas).to include(postcode)
    end

    it "returns Waltham Forest" do
      borough = LondonArea.find_by(name: 'Waltham Forest')
      expect(areas).to include(borough)
    end

    it "includes nothing else" do
      expect(areas.count).to eq(2)
    end
  end
end
