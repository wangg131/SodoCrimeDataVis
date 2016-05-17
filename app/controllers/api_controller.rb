require 'httparty'

class ApiController < ApplicationController
  def home
    # begin
      headers = { "$$app_token" => "#{ENV['APP_TOKEN']}"}
      query   = { "$where" => "within_circle(incident_location, 47.5951456, -122.331601, 1609.34)"}
      response = HTTParty.get(SEA_CRIME_URI, :headers => headers, :query => query)
      # response = top_five_events(response)
      data = geojson(top_five_events(response))
      @top_events_hash
      # raise
      # data = top_five_events(response)
    # rescue
    #   data = {}
    # end
    # raise
    respond_to do |format|
      format.html
      format.json { render json: data}
    end
    # render json: data.as_json
  end

  private

  def top_five_events(response)
    @top_events_hash = Hash.new(0)
    top_events_array = []
    response.each do |event|
      group_name = event["event_clearance_group"]
      @top_events_hash[group_name] += 1
    end
    @top_events_hash = @top_events_hash.max(5) {|a,b| a[1] <=> b[1]}.to_h
    @top_events_hash.each_key do |key|
      top_events_array << response.select { |h| h["event_clearance_group"] == key}
    end
    # geojson(top_events_array)
    return top_events_array.flatten!
  end

  def geojson(crime_data)
    @geojson_object = []
    crime_data.each do |data|
      @geojson_object <<
      {
        "type": "FeatureCollection",
        "features": [
          {
            "type": "Feature",
            "geometry": {
              "type": "Point",
              "coordinates": [
                data["longitude"],
                data["latitude"]
              ]
            },
            "properties": {
              "description": "<div class=\"marker-title\">#{data["event_clearance_description"]}</div>
                <p>Event Clearance Code:  #{data["event_clearance_code"]}</p>
                <p>CAD Event Number:  #{data["cad_event_number"]}</p>
                <p>Event Clearance Subgroup:  #{data["event_clearance_subgroup"]}</p>
                <p>Event Clearance Group:  #{data["event_clearance_group"]}</p>
                <p>CAD CWD ID:  #{data["cad_cdw_id"]}</p>
                <p>District Sector:  #{data["district_sector"]}</p>
                <p>Hundred Block Location:  #{data["hundred_block_location"]}</p>
                <p>General Offense Number:  #{data["general_offense_number"]}</p>
                <p>Incident Location:  #{data["latitude"]}, #{data["longitude"]}</p>
                <p>Cencus Tract:  #{data["census_tract"]}</p>
                <p>Initial Type Description:  #{data["initial_type_description"]}</p>
                <p>Initial Type Subgroup:  #{data["initial_type_subgroup"]}</p>
                <p>Initial Type Group:  #{data["initial_type_group"]}</p>
                <p>At Scene Time:  #{data["at_scene_time"]}</p>
                <p>Incident Location Address:</p>
                <p>#{data["incident_location_address"]} #{data["incident_location_city"]} #{data["incident_location_state"]} #{data["incident_location_zip"]}</p>"
            }
          }
        ]
      }
    end
    return @geojson_object
  end

  # def fetch_data(response)
  #   response.each do |event|
  #     response = {
        # event_clearance_code: event.fetch("event_clearance_code", ""),
        # cad_event_number: event.fetch("cad_event_number", ""),
        # event_clearance_subgroup: event.fetch("event_clearance_subgroup", ""),
        # event_clearance_group: event.fetch("event_clearance_group", ""),
        # cad_cdw_id: event.fetch("cad_cdw_id", ""),
        # event_clearance_date: event.fetch("event_clearance_date", ""),
        # district_sector: event.fetch("district_sector", ""),
        # hundred_block_location: event.fetch("hundred_block_location", ""),
        # general_offense_number: event.fetch("general_offense_number", ""),
        # event_clearance_description: event.fetch("event_clearance_description", ""),
        # longitude: event.fetch("longitude", ""),
        # latitude: event.fetch("latitude", ""),
        # census_tract: event.fetch("census_tract", ""),
        # indcident_location_city: event.fetch("incident_location_city", "")
    #   }
    # end
  # end
end
