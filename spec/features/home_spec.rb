require 'rails_helper'

RSpec.feature "Home page postcode lookup", type: :feature do
  scenario "shows error message when postcode not found" do
    stub_request(:get, "https://api.postcodes.io/postcodes/ZZ1%201ZZ").
    to_return(status: 404, body: '{"status":404,"error":"Postcode not found"}')

    visit root_path(postcode: 'ZZ1 1ZZ')

    expect(page).to have_text("Postcode not found")
  end

  scenario "shows not London message if score is 0" do
    stub_request(:get, "https://api.postcodes.io/postcodes/TR18%205EG").
    to_return(status: 200, body:'{"status":200,"result":{"postcode":"TR18 5EG","quality":1,"eastings":146278,"northings":28452,"country":"England","nhs_ha":"South West","longitude":-5.549482,"latitude":50.101832,"european_electoral_region":"South West","primary_care_trust":"Cornwall and Isles of Scilly","region":"South West","lsoa":"Cornwall 070D","msoa":"Cornwall 070","incode":"5EG","outcode":"TR18","parliamentary_constituency":"St Ives","parliamentary_constituency_2024":"St Ives","admin_district":"Cornwall","parish":"Penzance","admin_county":null,"date_of_introduction":"198001","admin_ward":"Mousehole, Newlyn & St Buryan","ced":null,"ccg":"NHS Cornwall and the Isles of Scilly","nuts":"Cornwall","pfa":"Devon & Cornwall","codes":{"admin_district":"E06000052","admin_county":"E99999999","admin_ward":"E05013311","parish":"E04011505","parliamentary_constituency":"E14001511","parliamentary_constituency_2024":"E14001511","ccg":"E38000089","ccg_id":"11N","ced":"E99999999","nuts":"TLK30","lsoa":"E01019004","msoa":"E02003951","lau2":"E06000052","pfa":"E23000035"}}}')

    visit root_path(postcode: 'TR18 5EG')

    expect(page).to have_text("TR18 5EG is 0% in London")
  end

  describe "Leyton postcode E10 5LL" do
    before do
      stub_request(:get, "https://api.postcodes.io/postcodes/E10%205LL").
      to_return(status: 200, body:'{"status":200,"result":{"postcode":"E10 5LL","quality":1,"eastings":537798,"northings":186644,"country":"England","nhs_ha":"London","longitude":-0.013446,"latitude":51.56185,"european_electoral_region":"London","primary_care_trust":"Waltham Forest","region":"London","lsoa":"Waltham Forest 026C","msoa":"Waltham Forest 026","incode":"5LL","outcode":"E10","parliamentary_constituency":"Leyton and Wanstead","parliamentary_constituency_2024":"Leyton and Wanstead","admin_district":"Waltham Forest","parish":"Waltham Forest, unparished area","admin_county":null,"date_of_introduction":"198001","admin_ward":"Leyton","ced":null,"ccg":"NHS North East London","nuts":"Waltham Forest","pfa":"Metropolitan Police","codes":{"admin_district":"E09000031","admin_county":"E99999999","admin_ward":"E05013896","parish":"E43000221","parliamentary_constituency":"E14000790","parliamentary_constituency_2024":"E14001334","ccg":"E38000255","ccg_id":"A3A8R","ced":"E99999999","nuts":"TLI53","lsoa":"E01004429","msoa":"E02000920","lau2":"E09000031","pfa":"E23000001"}}}')
      visit root_path(postcode: 'E10 5LL')
    end

    scenario "shows the score" do
      expect(page).to have_text("E10 5LL is 56% in London")
    end

    scenario "shows drainage area" do
      expect(page).to have_text("Beckton sewage treatment works")
    end

    scenario "shows Outer Borough" do
      expect(page).to have_text("Waltham Forest, an Outer London Borough")
    end

    scenario "shows ULEZ 2021" do
      expect(page).to have_text("ULEZ since 2021")
    end

    scenario "shows ULEZ 2023" do
      expect(page).to have_text("ULEZ since 2023")
    end

    scenario "shows 020 phone area" do
      expect(page).to have_text("020 phone area")
    end

    scenario "shows Travel to Work area" do
      expect(page).to have_text("Travel to Work area")
    end

    scenario "shows London Post Code" do
      expect(page).to have_text("part of the E10 postcode district")
    end

    scenario "shows Zone 3" do
      expect(page).to have_text("Leyton, which is Zone 3")
    end

    scenario "shows Night Tube" do
      expect(page).to have_text("Night Tube")
    end

    scenario "shows TFL Travel Accessibility Rating" do
      expect(page).to have_text("TFL gives this area a rating of 2")
    end

    scenario "shows Zone miss" do
      expect(page).to have_text("Tube station not in Zone 1")
    end

    scenario "shows cycle dock miss" do
      expect(page).to have_text("No nearby cycle dock")
    end

    scenario "shows Pret miss" do
      expect(page).to have_text("No nearby Pret A Manger")
    end

    scenario "shows TFL rating miss" do
      expect(page).to have_text("Lower TFL Travel Accessibility Rating")
    end
  end

  describe "Westminster postcode SW1A 1AA" do
    before do
      stub_request(:get, "https://api.postcodes.io/postcodes/SW1A%201AA").
      to_return(status: 200, body:'{"status":200,"result":{"postcode":"SW1A 1AA","quality":1,"eastings":529090,"northings":179645,"country":"England","nhs_ha":"London","longitude":-0.141563,"latitude":51.50101,"european_electoral_region":"London","primary_care_trust":"Westminster","region":"London","lsoa":"Westminster 018C","msoa":"Westminster 018","incode":"1AA","outcode":"SW1A","parliamentary_constituency":"Cities of London and Westminster","parliamentary_constituency_2024":"Cities of London and Westminster","admin_district":"Westminster","parish":"Westminster, unparished area","admin_county":null,"date_of_introduction":"198001","admin_ward":"St James\'s","ced":null,"ccg":"NHS North West London","nuts":"Westminster","pfa":"Metropolitan Police","codes":{"admin_district":"E09000033","admin_county":"E99999999","admin_ward":"E05013806","parish":"E43000236","parliamentary_constituency":"E14001172","parliamentary_constituency_2024":"E14001172","ccg":"E38000256","ccg_id":"W2U3Z","ced":"E99999999","nuts":"TLI35","lsoa":"E01004736","msoa":"E02000977","lau2":"E09000033","pfa":"E23000001"}}}')
      visit root_path(postcode: 'SW1A 1AA')
    end

    scenario "shows the score" do
      expect(page).to have_text("SW1A 1AA is 100% in London")
    end

    scenario "shows Westminster borough" do
      expect(page).to have_text("Westminster, an Inner London Borough")
    end

    scenario "shows ULEZ 2021" do
      expect(page).to have_text("ULEZ since 2021")
    end

    scenario "shows Congestion Charge Zone" do
      expect(page).to have_text("Congestion Charge Zone")
    end

    scenario "shows ULEZ 2023" do
      expect(page).to have_text("ULEZ since 2023")
    end

    scenario "shows Zone 1" do
      expect(page).to have_text("Zone 1")
    end

    scenario "shows 020 phone area" do
      expect(page).to have_text("020 phone area")
    end

    scenario "shows Travel to Work area" do
      expect(page).to have_text("Travel to Work area")
    end

    scenario "shows London Post Code" do
      expect(page).to have_text("London Post Code")
    end

    scenario "shows Night Tube" do
      expect(page).to have_text("Victoria tube station is nearby, which runs 24 hours")
    end

    scenario "shows Cycle Dock" do
      expect(page).to have_text("Cycle Dock")
    end

    scenario "shows Nearby Pret A Manger" do
      expect(page).to have_text("Nearby Pret A Manger")
    end

    scenario "shows TFL Travel Accessibility Rating" do
      expect(page).to have_text("TFL gives this area a rating of 6b")
    end

    scenario "shows drainage area" do
      expect(page).to have_text("Beckton sewage treatment works")
    end

    scenario "shows no misses" do
      expect(page).not_to have_text("Here are the things keeping SW1A 1AA from being more London")
    end
  end

  describe "Bristol postcode BS1 1NG" do
    before do
      stub_request(:get, "https://api.postcodes.io/postcodes/BS1%201NG").
      to_return(status: 200, body:'{"status":200,"result":{"postcode":"BS1 1NG","quality":1,"eastings":358767,"northings":172859,"country":"England","nhs_ha":"South West","longitude":-2.594796,"latitude":51.4532,"european_electoral_region":"South West","primary_care_trust":"Bristol","region":"South West","lsoa":"Bristol 061B","msoa":"Bristol 061","incode":"1NG","outcode":"BS1","parliamentary_constituency":"Bristol Central","parliamentary_constituency_2024":"Bristol Central","admin_district":"Bristol, City of","parish":"Bristol, City of, unparished area","admin_county":null,"date_of_introduction":"201808","admin_ward":"Central","ced":null,"ccg":"NHS Bristol, North Somerset and South Gloucestershire","nuts":"Bristol, City of","pfa":"Avon and Somerset","nhs_region":"South West","ttwa":"Bristol","national_park":"England (non-National Park)","bua":"Bristol","icb":"NHS Bristol, North Somerset and South Gloucestershire Integrated Care Board","cancer_alliance":"Somerset, Wiltshire, Avon and Gloucestershire","lsoa11":"Bristol 032B","msoa11":"Bristol 032","lsoa21":"Bristol 061B","msoa21":"Bristol 061","oa21":"E00174295","ruc11":"(England/Wales) Urban city and town","ruc21":"Urban: Nearer to a major town or city","lep1":"West of England","lep2":null,"codes":{"admin_district":"E06000023","admin_county":"E99999999","admin_ward":"E05010892","parish":"E43000019","parliamentary_constituency":"E14001131","parliamentary_constituency_2024":"E14001131","ccg":"E38000222","ccg_id":"15C","ced":"E99999999","nuts":"TLK51","lsoa":"E01033908","msoa":"E06006952","lau2":"E06000023","pfa":"E23000036","nhs_region":"E40000006","ttwa":"E30000180","national_park":"E65000001","bua":"E63012168","icb":"E54000039","cancer_alliance":"E56000033","lsoa11":"E01014540","msoa11":"E02003043","lsoa21":"E01033908","msoa21":"E02006952","oa21":"E00174295","ruc11":"C1","ruc21":"UN1","lep1":"E37000037","lep2":null}}}')
      visit root_path(postcode: 'BS1 1NG')
    end

    scenario "shows low score" do
      expect(page).to have_text("BS1 1NG is 4% in London")
    end

    scenario "shows nearby Pret" do
      expect(page).to have_text("Nearby Pret A Manger")
    end

    scenario "shows miss for inner borough" do
      expect(page).to have_text("Not in an inner London borough")
    end

    scenario "shows miss for outer borough" do
      expect(page).to have_text("Not in an outer London borough")
    end

    scenario "shows miss for phone area" do
      expect(page).to have_text("Not in a London phone area")
    end

    scenario "shows miss for postcode" do
      expect(page).to have_text("Not in a London postcode area")
    end

    scenario "shows miss for sewage" do
      expect(page).to have_text("Not in Thames Water sewage area")
    end

    scenario "shows miss for travel to work area" do
      expect(page).to have_text("Not in London travel to work area")
    end

    scenario "shows miss for ULEZ" do
      expect(page).to have_text("Not in ULEZ area")
    end

    scenario "shows miss for tube station" do
      expect(page).to have_text("No nearby tube station")
    end

    scenario "shows miss for night tube" do
      expect(page).to have_text("No nearby Night Tube")
    end

    scenario "shows miss for cycle dock" do
      expect(page).to have_text("No nearby cycle dock")
    end

    scenario "shows miss for PTAL" do
      expect(page).to have_text("Lower TFL Travel Accessibility Rating")
    end
  end
end
