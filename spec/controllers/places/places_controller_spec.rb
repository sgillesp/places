require 'rails_helper'


module Places

  RSpec.describe PlacesController, type: :controller do
    
    routes { Places::Engine.routes }

    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    # really just test that an invalid id (=1) fails
    describe "GET #show" do
      it "returns http success" do
        get :show, :id => 1
        expect(response).to have_http_status(:success)
      end
    end

  end
end
