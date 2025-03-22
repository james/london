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

    it "shows not London message if postcode in Bristol" do
      stub_request(:get, "https://api.postcodes.io/postcodes/TR18%205EG").
      to_return(status: 200, body:'{"status":200,"result":{"postcode":"TR18 5EG","quality":1,"eastings":146278,"northings":28452,"country":"England","nhs_ha":"South West","longitude":-5.549482,"latitude":50.101832,"european_electoral_region":"South West","primary_care_trust":"Cornwall and Isles of Scilly","region":"South West","lsoa":"Cornwall 070D","msoa":"Cornwall 070","incode":"5EG","outcode":"TR18","parliamentary_constituency":"St Ives","parliamentary_constituency_2024":"St Ives","admin_district":"Cornwall","parish":"Penzance","admin_county":null,"date_of_introduction":"198001","admin_ward":"Mousehole, Newlyn & St Buryan","ced":null,"ccg":"NHS Cornwall and the Isles of Scilly","nuts":"Cornwall","pfa":"Devon & Cornwall","codes":{"admin_district":"E06000052","admin_county":"E99999999","admin_ward":"E05013311","parish":"E04011505","parliamentary_constituency":"E14001511","parliamentary_constituency_2024":"E14001511","ccg":"E38000089","ccg_id":"11N","ced":"E99999999","nuts":"TLK30","lsoa":"E01019004","msoa":"E02003951","lau2":"E06000052","pfa":"E23000035"}}}')

      get root_path, params: { postcode: 'TR18 5EG' }

      expect(response).to have_http_status(:success)
      expect(response.body).to include("That's not even close to London")
    end

    it "shows latitude and longitude when provided with postcode parameter" do
      stub_request(:get, "https://api.postcodes.io/postcodes/E10%205LL").
      to_return(status: 200, body:'{"status":200,"result":{"postcode":"E10 5LL","quality":1,"eastings":537798,"northings":186644,"country":"England","nhs_ha":"London","longitude":-0.013446,"latitude":51.56185,"european_electoral_region":"London","primary_care_trust":"Waltham Forest","region":"London","lsoa":"Waltham Forest 026C","msoa":"Waltham Forest 026","incode":"5LL","outcode":"E10","parliamentary_constituency":"Leyton and Wanstead","parliamentary_constituency_2024":"Leyton and Wanstead","admin_district":"Waltham Forest","parish":"Waltham Forest, unparished area","admin_county":null,"date_of_introduction":"198001","admin_ward":"Leyton","ced":null,"ccg":"NHS North East London","nuts":"Waltham Forest","pfa":"Metropolitan Police","codes":{"admin_district":"E09000031","admin_county":"E99999999","admin_ward":"E05013896","parish":"E43000221","parliamentary_constituency":"E14000790","parliamentary_constituency_2024":"E14001334","ccg":"E38000255","ccg_id":"A3A8R","ced":"E99999999","nuts":"TLI53","lsoa":"E01004429","msoa":"E02000920","lau2":"E09000031","pfa":"E23000001"}}}')

      get root_path, params: { postcode: 'E10 5LL' }

      expect(response).to have_http_status(:success)
      expect(response.body).to include("Leyton")
      expect(response.body).to include("Waltham Forest")
      expect(response.body).to include("E10 postcode district")
    end
  end
end
