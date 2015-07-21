require 'spec_helper'
require 'places/place'
require 'places/country'
require 'places/state'
require 'places/county'
require 'places/city'

module Places
    RSpec.describe Place, type: :model do
    
        context 'model function' do
            let!(:place) { build(:random_place_generator, :city) }

            it 'instantiates a place' do
                expect(place.class.name).to eq("Places::Place")
            end

            it 'destroys a place' do
                expect { place.destroy }.not_to raise_error
            end

            it 'sets the name' do
                place.name = "new_name"
                expect(place.name).to eq("new_name")
            end

            it 'sets the description' do
                place.description = "new_description"
                expect(place.description).to eq("new_description")
            end

            it 'allow access to children' do
                expect { place.children }.not_to raise_error
            end

            it 'allow access to parent' do
                expect { place.parent }.not_to raise_error
            end

            it 'returns an address' do
                if (Place.config.use_geocoder)
                    expect { place.address }.not_to raise_error
                end
            end

            it 'returns latitude' do
                expect { place.latitude }.not_to raise_error
            end

            it 'returns longitude' do
                expect { place.longitude }.not_to raise_error
            end

        end

        context 'tree structure' do
            let!(:places) { Array.new(3){ |index| build(:random_place_generator)} }
            
            it 'to disallow direct circular reference' do
                # rephrase to check validity
                places[0].children << places[0]
                expect(places[0].valid?).to eq(false)
                
                #expect { places[0].children << places[0] }.to raise_error
            end

            it 'to disallow circular reference (one deep)' do
                 places[0].children << places[1]
                 places[1].children << places[0]
                 expect(places[0].valid?).to eq(false)

                 #expect { places[1].children << places[0] }.to raise_error
            end

            it 'to disallow circular reference (two deep)' do
                places[0].children << places[1]
                places[1].children << places[2]
                places[2].children << places[0]
                expect(places[0].valid?).to eq(false)

                #expect { places[2].children << places[0] }.to raise_error
            end

            it 'to allow cycle through children' do
                places[0].children.each do |p|
                    expect {p}.not_to eq(nil)
                end
            end

            it 'to allow real access to parent' do
                places[0].children << places[1]
                expect(places[1].parent).not_to eq(nil)
                expect { places[1].parent.name }.not_to raise_error
            end


            # it 'to disallow direct circular reference' do
            #     expect { places[0].add_child(places[0]) }.to raise_error
            # end

            # it 'to disallow circular reference (one deep)' do
            #      places[0].add_child(places[1])
            #      expect { places[1].add_child(places[0]) }.to raise_error
            # end

            # it 'to disallow circular reference (two deep)' do
            #     places[0].add_child(places[1])
            #     places[1].add_child(places[2])
            #     expect { places[2].add_child(places[0]) }.to raise_error
            # end

            # it 'to allow cycle through children' do
            #     places[0].children.each do |p|
            #         expect {p}.not_to eq(nil)
            #     end
            # end

            # it 'to allow real access to parent' do
            #     places[0].add_child(places[1])
            #     expect(places[1].parent).not_to eq(nil)
            #     expect { places[1].parent.name }.not_to raise_error
            # end

        end

        context 'places hierarchy' do
            before(:each) do
                country = FactoryGirl.build( :random_country_generator )
                @state = FactoryGirl.build(:random_state_generator)
                @county = FactoryGirl.build(:random_county_generator)
                @city = FactoryGirl.build(:random_city_generator)
            end

            it 'to allow city in county' do
                expect { @county.children << @city }.not_to raise_error
            end

            it 'to allow city in state' do
                expect { @state.children << @city }.not_to raise_error
            end

            it 'not to allow county in city' do
                expect { @city.children << @county }.to raise_error
            end

            it 'not to allow state in city' do
                expect { @city.children << @state }.to raise_error
            end

            it 'not to allow country in city' do
                expect { @city.children << @country }.to raise_error
            end

            it 'not to allow state in county' do
                expect { @county.children << @state }.to raise_error
            end

            it 'not to allow country in county' do
                expect { @county.children << @state }.to raise_error
            end

            it 'not to allow city in country' do
                expect { @country.children << @city }.to raise_error
            end

            # it 'to allow city in county' do
            #     expect { @county.add_child(@city) }.not_to raise_error
            # end

            # it 'to allow city in state' do
            #     expect { @state.add_child(@city) }.not_to raise_error
            # end

            # it 'not to allow county in city' do
            #     expect { @city.add_child(@county) }.to raise_error
            # end

            # it 'not to allow state in city' do
            #     expect { @city.add_child(@state) }.to raise_error
            # end

            # it 'not to allow country in city' do
            #     expect { @city.add_child(@country) }.to raise_error
            # end

            # it 'not to allow state in county' do
            #     expect { @county.add_child(@state) }.to raise_error
            # end

            # it 'not to allow country in county' do
            #     expect { @county.add_child(@state) }.to raise_error
            # end

            # it 'not to allow city in country' do
            #     expect { @country.add_child(@city) }.to raise_error
            # end

        end

    end

end
