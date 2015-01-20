function  plot_cities(x,y,order,names)
%PLOT_CITIES Summary of this function goes here
%   Detailed explanation goes here

    plot(x(order(:)), y(order(:)), 'r-o');
    for i=1:length(names)-1
        text(x(order(i)), y(order(i)), [i ' ' names(order(i))]);
    
    end
end

