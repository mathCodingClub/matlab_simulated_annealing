function order = swap_2_cities(first, second, currentOrder)
    
    order = currentOrder;
    order(currentOrder==first) = second;
    order(currentOrder==second) = first;

end