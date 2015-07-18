require_dependency "application_controller" 
require 'mongoid'
require '../../app/models/places/place.rb'
include Places

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
            redirect_to :action => 'show', :id => @place.id, :notice => "Created #{@place.name}"
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
        # must have a valid :id to show that 
        if params[:id] == nil
            flash[:message] = "No such Place in database"
            render 'index'
            return
        end

        # try to find the place, but catch if the place cannot be found
        @place = Place.find(params[:id])

    rescue ::Mongoid::Errors::DocumentNotFound => err
        flash[:error] = "No such Place in database."
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

    def edit 
        # try to find the place, but catch if the place cannot be found
        @place = Place.find(params[:id])

    rescue ::Mongoid::Errors::DocumentNotFound => err
        flash[:error] = "No such Place in database."
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

    def update
        # try to find the place, but catch if the place cannot be found
        @place = Place.find(params[:id])
        if @place.update_attributes(place_params) 
            if @place.save
                flash[:message] = "#{@place.name} updated"
                redirect_to :action => 'show', :id => @place.id
            else
                redirect_to(:action => 'show', :id => @place.id, :error => "Utter failure".red)
            end
        else
            puts "BAD NEWS".red.bold
            render 'edit'
        end

    rescue ::Mongoid::Errors::DocumentNotFound => err
        flash[:error] = "No such Place in database."
        render 'edit'
    rescue ::Moped::Errors::OperationFailure => err
        # check for the appropriate error message indicating a duplicate index
        # if err.message =~ /name_index/
        #     @place.errors.add(:email, "already exists for another account")
        # else
        #     @place.errors.add(:base, err.message)
        # end        
        flash[:message] = "Duplicate entry for Place"

        render 'edit'
    end

    def addchild
        @place = Place.find(params[:id])
        if @place
            child = Place.find(params[:place])
            if child 
                if @place.add_child(child)
                    if @place.save()
                        flash[:message] = "#{child.name} added to #{@place.name}"
                    else
                        flash[:error] = "unable to save #{@place.name}, after attempted addition of child #{child.name}"
                    end
                else
                    flash[:error] = "unable to add #{child.name} to #{@place.name}"
                end
            else
                flash[:error] = "could not find child #{:place.id}"
            end
        else
            flash[:error] = "could not find place, corresponding to #{:id}"
        end
        # ?? no need to redirect, right? - fall back to page (i.e. edit)
    
        render 'edit'

    # this should not happen if raise_not_found_error = false in mongoid.yml
    rescue ::Mongoid::Errors::DocumentNotFound => err
            flash[:error] = "No such Place in database."
            render 'edit'
    end

    def remchild
        @place = Place.find(params[:id])
        if @place
            child = Place.find(params[:place])
            if child 
                if @place.remove_child(child)
                    if @place.save()
                        flash[:message] = "#{child.name} removed from #{@place.name}"
                    else
                        flash[:error] = "unable to save #{@place.name}, after attempted removal of child #{child.name}"
                    end
                else
                    flash[:error] = "unable to remove #{child.name} from #{@place.name}"
                end
            else
                flash[:error] = "could not find child #{:place.id} in #{@place.name}"
            end
        else
            flash[:error] = "could not find place, corresponding to #{:id}"
        end
        # ?? no need to redirect, right? - fall back to page (i.e. edit)
    
        render 'edit'

        # this should not happen if raise_not_found_error = false in mongoid.yml
    rescue ::Mongoid::Errors::DocumentNotFound => err
            flash[:error] = "No such Place in database."
            render 'edit'
    end

    def breakparent
        @place = Place.find(params[:id])
        if @place
            # this could be made more complex so as to avoid specifying whether there is or 
            # is not a single parent (not enforcing tree structure in the controller)
            @place.remove_parent
        else
            flash[:error] = "could not find place, corresponding to #{:id}"
        end

        render 'edit'

    rescue ::Mongoid::Errors::DocumentNotFound => err
        flash[:error] = "No such Place in database."
        render 'edit'
    end

    private
        # actual method is hidden to keep hidden
        def do_addchild(pm)
            @place.add_child(Place.find(params[:place]))
        end

        def do_remchild(pm)
            @place.remove_child(Place.find(params[:place]))
        end

        def place_params
            params.require(:place).permit(:name, :description)
        end

        def add_params
            params.require(:place)
            params.permit(:addid)
        end

        def rem_params
            params.require(:place)
            params.permit(:remid)
        end
end
