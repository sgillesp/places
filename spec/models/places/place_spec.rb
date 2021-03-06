require 'spec_helper'

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

        end

        context 'tree structure' do
            let!(:places) { Array.new(3){ |index| build(:random_place_generator)} }
            
            it 'disallow direct circular reference' do
                expect { places[0].add_child(places[0]) }.to raise_error
            end

            it 'disallow circular reference (one deep)' do
                 places[0].add_child(places[1])
                 expect { places[1].add_child(places[0]) }.to raise_error
            end

            it 'disallow circular reference (two deep)' do
                places[0].add_child(places[1])
                places[1].add_child(places[2])
                expect { places[2].add_child(places[0]) }.to raise_error
            end

            it 'allow cycle through children' do
                places[0].children.each do |p|
                    expect {p}.not_to eq(nil)
                end
            end

            it 'allow real access to parent' do
                places[0].add_child(places[1])
                expect(places[1].parent).not_to eq(nil)
                expect { places[1].parent.name }.not_to raise_error
            end



        end



    end

end
