require 'httparty'

class ApiController < ApplicationController
  def home
    @geojson = Array.new
    headers = { "$$app_token" => "#{ENV['APP_TOKEN']}"}
    query   = { "$where" => "within_circle(incident_location, 47.5951456, -122.331601, 1609.34)"}
    @data = HTTParty.get(SEA_CRIME_URI, :headers => headers, :query => query)
  end
end
