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

    it "returns the ULEZ zones" do
      ulez2021 = LondonArea.find_by(name: 'ULEZ 2021')
      ulez2023 = LondonArea.find_by(name: 'ULEZ 2023')
      expect(areas).to include(ulez2021)
      expect(areas).to include(ulez2023)
    end

    it "returns the 020 area code" do
      area_code = LondonArea.find_by(name: '020')
      expect(areas).to include(area_code)
    end

    it "returns the travel to work area" do
      travel_to_work_area = LondonArea.find_by(name: 'Travel to work')
      expect(areas).to include(travel_to_work_area)
    end

    it "includes nothing else" do
      expect(areas.count).to eq(6)
    end
  end
end
