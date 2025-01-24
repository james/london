require 'net/http'

class HomeController < ApplicationController
  def index
    if params[:postcode]
      response = Net::HTTP.get(URI("https://api.postcodes.io/postcodes/#{URI.encode_uri_component(params[:postcode])}"))
      result = JSON.parse(response)

      if result['status'] == 200
        params[:postcode] = result['result']['postcode']
        @scorecard = Scorecard.new(result['result']['latitude'], result['result']['longitude'])
      else
        @error = "Postcode not found"
      end
    end
  end
end
