require 'httparty'

class ApiController < ApplicationController
  def home
    # begin
      headers = { "$$app_token" => "#{ENV['APP_TOKEN']}"}
      query   = { "$where" => "within_circle(incident_location, 47.5951456, -122.331601, 1609.34)"}
      response = HTTParty.get(SEA_CRIME_URI, :headers => headers, :query => query)
      shoot = top_five_events(response)
      data = setup_data(shoot)
      code = :ok
    # rescue
      # data = {}
      # code = :no_content
    # end
    render json: data.as_json, code: code
  end

  def top_five_events(response)
    hash = Hash.new(0)
    array = []
    response.each do |event|
      group_name = event["event_clearance_group"]
      hash[group_name] += 1
    end
    hash = hash.max(5) {|a,b| a[1] <=> b[1]}.to_h
    hash.each_key do |key|
      array << response.select { |h| h["event_clearance_group"] == key}
    end
    return array.flatten!
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
