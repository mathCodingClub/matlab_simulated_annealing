function custom_cities_plot( current_x, current_cost, optimum_cost, temp, init_t )
%PLOT_CITIES Summary of this function goes here
%   Detailed explanation goes here

    order = current_x{3};
    x = current_x{1};
    y = current_x{2};
    names = current_x{4};
                
    plot_cities(x,y,order,names);
    
    title(sprintf('temperature: %0.2f, cost: %0.2f, best: %0.2f', ...
                    temp, current_cost, optimum_cost));
    
end

