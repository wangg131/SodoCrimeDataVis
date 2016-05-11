require 'httparty'

class ApiController < ApplicationController
  def home
    @data = HTTParty.get(SEA_CRIME_URI + "?$where=within_circle(incident_location, 47.5951456, -122.331601, 1609.34)")
  end
end
