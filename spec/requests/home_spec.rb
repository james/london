require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "GET /index" do
    it "shows error message when postcode not found" do
      stub_request(:get, "https://api.postcodes.io/postcodes/ZZ1%201ZZ").
      to_return(status: 404, body: '{"status":404,"error":"Postcode not found"}')

      get root_path, params: { postcode: 'ZZ1 1ZZ' }

      expect(response).to have_http_status(:success)
      expect(response.body).to include("Postcode not found")
    end

    it "shows not London message if score is 0" do
      stub_request(:get, "https://api.postcodes.io/postcodes/TR18%205EG").
      to_return(status: 200, body:'{"status":200,"result":{"postcode":"TR18 5EG","quality":1,"eastings":146278,"northings":28452,"country":"England","nhs_ha":"South West","longitude":-5.549482,"latitude":50.101832,"european_electoral_region":"South West","primary_care_trust":"Cornwall and Isles of Scilly","region":"South West","lsoa":"Cornwall 070D","msoa":"Cornwall 070","incode":"5EG","outcode":"TR18","parliamentary_constituency":"St Ives","parliamentary_constituency_2024":"St Ives","admin_district":"Cornwall","parish":"Penzance","admin_county":null,"date_of_introduction":"198001","admin_ward":"Mousehole, Newlyn & St Buryan","ced":null,"ccg":"NHS Cornwall and the Isles of Scilly","nuts":"Cornwall","pfa":"Devon & Cornwall","codes":{"admin_district":"E06000052","admin_county":"E99999999","admin_ward":"E05013311","parish":"E04011505","parliamentary_constituency":"E14001511","parliamentary_constituency_2024":"E14001511","ccg":"E38000089","ccg_id":"11N","ced":"E99999999","nuts":"TLK30","lsoa":"E01019004","msoa":"E02003951","lau2":"E06000052","pfa":"E23000035"}}}')

      get root_path, params: { postcode: 'TR18 5EG' }

      expect(response).to have_http_status(:success)
      expect(response.body).to include("That's not even close to London")
    end

    describe "Leyton postcode E10 5LL" do
      before do
        stub_request(:get, "https://api.postcodes.io/postcodes/E10%205LL").
        to_return(status: 200, body:'{"status":200,"result":{"postcode":"E10 5LL","quality":1,"eastings":537798,"northings":186644,"country":"England","nhs_ha":"London","longitude":-0.013446,"latitude":51.56185,"european_electoral_region":"London","primary_care_trust":"Waltham Forest","region":"London","lsoa":"Waltham Forest 026C","msoa":"Waltham Forest 026","incode":"5LL","outcode":"E10","parliamentary_constituency":"Leyton and Wanstead","parliamentary_constituency_2024":"Leyton and Wanstead","admin_district":"Waltham Forest","parish":"Waltham Forest, unparished area","admin_county":null,"date_of_introduction":"198001","admin_ward":"Leyton","ced":null,"ccg":"NHS North East London","nuts":"Waltham Forest","pfa":"Metropolitan Police","codes":{"admin_district":"E09000031","admin_county":"E99999999","admin_ward":"E05013896","parish":"E43000221","parliamentary_constituency":"E14000790","parliamentary_constituency_2024":"E14001334","ccg":"E38000255","ccg_id":"A3A8R","ced":"E99999999","nuts":"TLI53","lsoa":"E01004429","msoa":"E02000920","lau2":"E09000031","pfa":"E23000001"}}}')
        get root_path, params: { postcode: 'E10 5LL' }
      end

      it "shows the score" do
        expect(Nokogiri::HTML(response.body).text).to include("E10 5LL is 56% in London")
      end

      it "shows drainage area" do
        expect(response.body).to include("Beckton sewage treatment works")
      end

      it "shows Outer Borough" do
        expect(response.body).to include("Waltham Forest, an Outer London Borough")
      end

      it "shows ULEZ 2021" do
        expect(response.body).to include("ULEZ since 2021")
      end

      it "shows ULEZ 2023" do
        expect(response.body).to include("ULEZ since 2023")
      end

      it "shows 020 phone area" do
        expect(response.body).to include("020 phone area")
      end

      it "shows Travel to Work area" do
        expect(response.body).to include("Travel to Work area")
      end

      it "shows London Post Code" do
        expect(response.body).to include("part of the E10 postcode district")
      end

      it "shows Zone 3" do
        expect(response.body).to include("Leyton, which is Zone 3")
      end

      it "shows Night Tube" do
        expect(response.body).to include("Night Tube")
      end

      it "shows TFL Travel Accessibility Rating" do
        expect(response.body).to include("TFL gives this area a rating of 2")
      end

      it "shows Zone miss" do
        expect(response.body).to include("Tube station not in Zone 1")
      end

      it "shows cycle dock miss" do
        expect(response.body).to include("No nearby cycle dock")
      end

      it "shows Pret miss" do
        expect(response.body).to include("No nearby Pret A Manger")
      end

      it "shows TFL rating miss" do
        expect(response.body).to include("Lower TFL Travel Accessibility Rating")
      end
    end

    describe "Westminster postcode SW1A 1AA" do
      before do
        stub_request(:get, "https://api.postcodes.io/postcodes/SW1A%201AA").
        to_return(status: 200, body:'{"status":200,"result":{"postcode":"SW1A 1AA","quality":1,"eastings":529090,"northings":179645,"country":"England","nhs_ha":"London","longitude":-0.141563,"latitude":51.50101,"european_electoral_region":"London","primary_care_trust":"Westminster","region":"London","lsoa":"Westminster 018C","msoa":"Westminster 018","incode":"1AA","outcode":"SW1A","parliamentary_constituency":"Cities of London and Westminster","parliamentary_constituency_2024":"Cities of London and Westminster","admin_district":"Westminster","parish":"Westminster, unparished area","admin_county":null,"date_of_introduction":"198001","admin_ward":"St James\'s","ced":null,"ccg":"NHS North West London","nuts":"Westminster","pfa":"Metropolitan Police","codes":{"admin_district":"E09000033","admin_county":"E99999999","admin_ward":"E05013806","parish":"E43000236","parliamentary_constituency":"E14001172","parliamentary_constituency_2024":"E14001172","ccg":"E38000256","ccg_id":"W2U3Z","ced":"E99999999","nuts":"TLI35","lsoa":"E01004736","msoa":"E02000977","lau2":"E09000033","pfa":"E23000001"}}}')
        get root_path, params: { postcode: 'SW1A 1AA' }
      end

      it "shows the score" do
        expect(Nokogiri::HTML(response.body).text).to include("SW1A 1AA is 100% in London")
      end

      it "shows Westminster borough" do
        expect(response.body).to include("Westminster, an Inner London Borough")
      end

      it "shows ULEZ 2021" do
        expect(response.body).to include("ULEZ since 2021")
      end

      it "shows Congestion Charge Zone" do
        expect(response.body).to include("Congestion Charge Zone")
      end

      it "shows ULEZ 2023" do
        expect(response.body).to include("ULEZ since 2023")
      end

      it "shows Zone 1" do
        expect(response.body).to include("Zone 1")
      end

      it "shows 020 phone area" do
        expect(response.body).to include("020 phone area")
      end

      it "shows Travel to Work area" do
        expect(response.body).to include("Travel to Work area")
      end

      it "shows London Post Code" do
        expect(response.body).to include("London Post Code")
      end

      it "shows Night Tube" do
        expect(response.body).to include("Victoria tube station is nearby, which runs 24 hours")
      end

      it "shows Cycle Dock" do
        expect(response.body).to include("Cycle Dock")
      end

      it "shows Nearby Pret A Manger" do
        expect(response.body).to include("Nearby Pret A Manger")
      end

      it "shows TFL Travel Accessibility Rating" do
        expect(response.body).to include("TFL gives this area a rating of 6b")
      end

      it "shows drainage area" do
        expect(response.body).to include("Beckton sewage treatment works")
      end
    end
  end
end
