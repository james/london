require 'net/http'

class HomeController < ApplicationController
  def index
    if params[:postcode]
      response = Net::HTTP.get(URI("https://api.postcodes.io/postcodes/#{URI.encode_uri_component(params[:postcode])}"))
      result = JSON.parse(response)
      params[:postcode] = result['result']['postcode']

      if result['status'] == 200
        @scorecard = Scorecard.new(result['result']['latitude'], result['result']['longitude'])
      else
        @error = "Postcode not found"
      end
    end
  end
end
