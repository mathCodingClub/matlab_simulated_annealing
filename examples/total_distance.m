function d = total_distance(x, y, order)

    d = 0;
for i = 1:(length(order)-1)
    
    d = d + distance_between([x(order(i)) y(order(i))], ...
                            [x(order(i+1)) y(order(i+1))]) ...
                            ;
    
end