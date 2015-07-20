#lib/task/db_populate
require 'factory_girl'

namespace :db do
    namespace :pop do

        # method to create a place
        def make_place (ptype)
            case ptype
                when 'country'
                    FactoryGirl.create(:random_country_generator)
                when 'state'
                    FactoryGirl.create(:random_state_generator)
                when 'county'
                    FactoryGirl.create(:random_county_generator)
                when 'city'
                    FactoryGirl.create(:random_city_generator)
                else
                    FactoryGirl.create(:random_place_generator, ptype)
            end
        end

        # method which generates entries
        def pop_places (count, ptype = 'city')

            print "Creating #{count} "; print "#{count > 1 ? ptype.pluralize : ptype} in ".green; print "#{Rails.env}".green.bold; print " database ".green
            
            # include all of the factories in spec
            Dir['./spec/factories/*.rb'].each { |f| require f.to_s }
            
            dval = [ (count / 10), 1 ].max
            for i in 1..count
                place = make_place(ptype)
                if i % dval == 0
                    print('.'.green)
                end
            end
            puts " done!".green.bold
        end

        # call should be db:pop:places (is app:db:pop:places -- NEED TO FIX THAT?)
        desc 'Seed database with development place data'
        task :places, [:type, :count] => :environment do |t, args|

            count = (args[:count] || 10).to_i

            puts
            puts "Seeding database with development place data".gray
            print "Using ".gray; print "#{Rails.env}".bold.gray; print " database.".gray
            puts
            
            fail "Cannot instantiate #{count} places! Terminating...".red.bold if count < 1
            
            pop_places(count,args[:type] || 'city')

        end

    end # namespace :places
end