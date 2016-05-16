require 'httparty'

class ApiController < ApplicationController
  def home
    begin
      headers = { "$$app_token" => "#{ENV['APP_TOKEN']}"}
      query   = { "$where" => "within_circle(incident_location, 47.5951456, -122.331601, 1609.34)"}
      response = HTTParty.get(SEA_CRIME_URI, :headers => headers, :query => query)
      data = setup_data(response)
      code = :ok
    rescue
      data = {}
      code = :no_content
    end
    render json: data.as_json, code: code
  end

  def setup_data(response)
    response.each do |event|
      response = {
        event_clearance_code: event.fetch("event_clearance_code", ""),
        cad_event_number: event.fetch("cad_event_number", ""),
        event_clearance_subgroup: event.fetch("event_clearance_subgroup", ""),
        event_clearance_group: event.fetch("event_clearance_group", ""),
        cad_cdw_id: event.fetch("cad_cdw_id", ""),
        event_clearance_date: event.fetch("event_clearance_date", ""),
        district_sector: event.fetch("district_sector", ""),
        hundred_block_location: event.fetch("hundred_block_location", ""),
        general_offense_number: event.fetch("general_offense_number", ""),
        event_clearance_description: event.fetch("event_clearance_description", ""),
        longitude: event.fetch("longitude", ""),
        latitude: event.fetch("latitude", ""),
        census_tract: event.fetch("census_tract", ""),
        indcident_location_city: event.fetch("incident_location_city", "")
      }
    end
  end
end
