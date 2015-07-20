
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

  factory :random_city_generator, :class => 'Places::City' do
    name { Faker::Address.city }
    description { Faker::Lorem.paragraph }
  end

  factory :random_state_generator, :class => 'Places::State' do
    name { Faker::Address.state }
    description { Faker::Lorem.paragraph }
  end

  factory :random_county_generator, :class => 'Places::County' do
    name { Faker::Name.last_name }
    description { Faker::Lorem.paragraph }
  end

  factory :random_country_generator, :class => 'Places::Country' do
    name { Faker::Address.country }
    description { Faker::Lorem.paragraph }
  end

end
