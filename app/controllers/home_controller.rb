require 'net/http'

class HomeController < ApplicationController
  def index
    if params[:postcode]
      begin
        result = fetch_postcode_data(params[:postcode])

        if result['status'] == 200
          params[:postcode] = result['result']['postcode']
          latitude = result['result']['latitude']
          longitude = result['result']['longitude']

          # Cache scorecard calculation per location
          cache_key = "scorecard/#{latitude}/#{longitude}"
          @scorecard = Rails.cache.fetch(cache_key, expires_in: 7.days) do
            Scorecard.new(latitude, longitude)
          end
        else
          @error = "Postcode not found"
        end
      rescue Net::OpenTimeout, Net::ReadTimeout => e
        Rails.logger.error("Postcode API timeout: #{e.message}")
        @error = "Service temporarily unavailable. Please try again."
      rescue StandardError => e
        Rails.logger.error("Postcode API error: #{e.message}")
        @error = "An error occurred. Please try again."
      end
    end
  end

  def heatmap
  end

  private

  def fetch_postcode_data(postcode)
    uri = URI("https://api.postcodes.io/postcodes/#{URI.encode_uri_component(postcode)}")

    # Add timeout to prevent hanging requests
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true,
                                open_timeout: 3, read_timeout: 5) do |http|
      request = Net::HTTP::Get.new(uri)
      http.request(request)
    end

    JSON.parse(response.body)
  end
end
