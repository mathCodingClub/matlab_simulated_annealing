function [x, y, side, names] = build_world(cities)

    x = zeros(cities, 1);
    y = zeros(cities, 1);
    side = zeros(cities, 1);
    names = cell(cities, 1);
    
    for i = 1:cities
        
        x(i) = randi(100, 1, 1);
        y(i) = randi(100, 1, 1);
        city = random_city();
        while find(strcmp(names, city))
           
            city = random_city();
            
        end
        
        names(i) = city;
        
        if x(i) <= 50 
            
            side(i) = -1;
            
        else
            
            side(i) = 1;
        end
        
    end

end