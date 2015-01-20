function x = randomize(current_x)
%get two random cities to have their order swapped, don't swap
        %first or "last", since we start from first and end up there too.
        x = current_x;
        names = current_x{4};
        order = current_x{3};
        start = order(end);
        
        city1 = random_city(names);
        while strcmp(names(start), city1)
            city1 = random_city(names);
        end
        
        city2=random_city(names);
        while (strcmp(city1, city2) ...
           || strcmp(names(start), city2))
            city2=random_city(names);
        end
    
        randCity1 = find(strcmp(names, city1));
        randCity2 = find(strcmp(names, city2));
    
        x{3} = swap_2_cities(randCity1, randCity2, order);
        
end