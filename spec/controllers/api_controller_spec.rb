require 'rails_helper'

  CRIME_DATA = { cassette_name: "TIMJ_search", record: :new_episodes }

  RSpec.describe ApiController, type: :controller do
    describe "interacting with the the Seattle crime dataset", vcr: CRIME_DATA do
      before :each do
        get :home
      end

      it "should be successful" do
        expect(response).to be_ok
      end
    end

end
