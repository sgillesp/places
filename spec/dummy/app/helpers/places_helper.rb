module PlacesHelper

    def recurs_places(nodes)
        nodes.each do |n|
            render partial: 'place', locals: { node: n }
        end
    end

end
