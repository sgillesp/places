require_dependency "places/application_controller"
require 'mongoid'

module Places
  class PlacesController < ApplicationController
    
    def index
        @places = Place.all
    end

    def new
        @place = Place.new
    end

    def create
        @place = Place.new(place_params)
        if @place.save
            redirect_to root_url, :notice => "Created place"
        else
            render 'new'
        end
    rescue Moped::Errors::OperationFailure => err
        # check for the appropriate error message indicating a duplicate index
        if err.message =~ /11000/
            @places.errors.add(:place_name, "alread exists for another Place")
        else
            @places.errors.add(:base, err.message)
        end
                            
        render 'new'
    end

    def show
        # try to find the place, but catch if the place cannot be found
        @place = Place.find(:id)
    rescue ::Mongoid::Errors::DocumentNotFound => err
        flash[:message] = "No such Place in database."
        render 'index'
    rescue ::Moped::Errors::OperationFailure => err
        # check for the appropriate error message indicating a duplicate index
        # if err.message =~ /name_index/
        #     @place.errors.add(:email, "already exists for another account")
        # else
        #     @place.errors.add(:base, err.message)
        # end        
        flash[:message] = "Duplicate entry for Place"

        render 'index'
    end

    private

        def place_params
            params.require(:place).permit(:place_name, :place_description)
        end
  end
end
