require 'spec_helper'

module Places
    RSpec.describe Place, type: :model do
    #    pending "add some examples to (or delete) #{__FILE__}"
    end

    RSpec.describe :instantiation do
        let!(:place) { build(:random_place_generator, :city) }

        it 'instantiates a place' do
            expect(place.class.name).to eq("Places::Place")
        end

    end

end
