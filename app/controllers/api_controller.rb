require 'httparty'

class ApiController < ApplicationController
  def home
    # begin
      headers = { "$$app_token" => "#{ENV['APP_TOKEN']}"}
      query   = { "$where" => "within_circle(incident_location, 47.5951456, -122.331601, 1609.34)"}
      response = HTTParty.get(SEA_CRIME_URI, :headers => headers, :query => query)
      top_five_events(response)
      data = setup_data(response)
      code = :ok
    # rescue
    #   data = {}
    #   code = :no_content
    # end
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

  def top_five_events(response)
    hash = Hash.new(0)
    response.each do |event|
      group_name = event["event_clearance_group"]
      hash[group_name] += 1
    end
    hash.each_key do |key|
      response = response.select { |h| h["event_clearance_group"] == key}
    end
    binding.pry
    # response = hash.sort_by { |name, value| -value }.first(5)
    #hash.max(5) {|a,b| a[1] <=> b[1]}
  end
end
