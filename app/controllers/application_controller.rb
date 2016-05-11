class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  SEA_CRIME_URI = "https://data.seattle.gov/resource/3k2p-39jp.json"
end
