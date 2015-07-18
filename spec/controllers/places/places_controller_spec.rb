require 'rails_helper'
require 'spec_helper'
require 'places/place'

module Places

  RSpec.describe PlacesController, type: :controller do
    
    #routes { Places::Engine.routes }

    before :all do
      # populate the database prior to trying index/get
      @sample = FactoryGirl.create(:random_place_generator)
    end

    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    # really just test that an invalid id (=1) fails
    describe "GET #show" do
      it "returns http success" do
        get :show, :id => @sample.id
        expect(response).to have_http_status(:success)
      end
    end

  end
  
end
