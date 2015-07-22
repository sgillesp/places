class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy]

  # GET /people
  def index
    @people = Person.all
  end

  # GET /people/1
  def show
    find_nearby
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people
  def create
    @person = Person.new(person_params)

    if @person.save
      redirect_to @person, notice: 'Person was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /people/1
  def update
    if @person.update(person_params)
      redirect_to @person, notice: 'Person was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /people/1
  def destroy
    @person.destroy
    redirect_to people_url, notice: 'Person was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    def find_nearby
      near_q = @person.place_avatar.nearbys(10)
      @nearby = near_q.to_a
      #@nearby = Places::Place.find(@person.place_avatar.nearbys(10))
      #@nearby = Places::Place.geo_near(:loc => @person.place_avatar.to_coordinates).max_distance(10))
      if @nearby != nil
      #  @nearby.nullify(@person.place_avatar)
      end
    end

    # Only allow a trusted parameter "white list" through.
    def person_params
      params.require(:person).permit(:name, :address)
    end
end
