require 'net/http'

class HomeController < ApplicationController
  def index
    if params[:postcode]
      response = Net::HTTP.get(URI("https://api.postcodes.io/postcodes/#{URI.encode_uri_component(params[:postcode])}"))
      result = JSON.parse(response)

      if result['status'] == 200
        latitude = result['result']['latitude']
        longitude = result['result']['longitude']
        @areas = LondonArea.find_by_latitude_and_longitude(latitude, longitude)
        @nearest_tube = TubeStation.find_nearest(latitude, longitude)
      else
        @error = "Postcode not found"
      end
    end
  end
end
