
require 'faker'

FactoryGirl.define do
  factory :places_place, :class => 'Places::Place' do
    name "Seattle"
    description "The emerald city."
  end

  factory :random_place_generator, :class => 'Places::Place' do
    name { Faker::Address.city }
    description { Faker::Lorem.paragraph }

    trait :city do
        name { Faker::Address.city }
    end

    trait :state do 
        name { Faker::Address.state }
    end

    trait :county do
        name { Faker::Name.last_name }
    end

    trait :country do
        name 'United States'
    end
  end

end
