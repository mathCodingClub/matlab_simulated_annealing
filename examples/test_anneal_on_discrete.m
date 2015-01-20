%%
clear all;
close all;

cities = 30;

[x, y, side, names] = build_world(cities);

problem.figure = figure(101);
plot(x, y, 'o');

for i=1:length(names)
    text(x(i), y(i), [' ' ' ' names(i)]);
    
end

%select starting city and close the "loop" of cities:
%choose first city, could be any other too:
%first (and last) city is never swapped, so the name can be the same
%start = find(strcmp(names, 'Huittinen'), 1, 'first');
start=1;

names(cities + 1) = names(start);
x(cities + 1) = x(start);
y(cities + 1) = y(start);
side(cities + 1) = side(start);

%initial solution: visit cities in their index order
order = 1:1:length(names);
%swap starting city as first city:
order = swap_2_cities(start, 1, order);

% wrapper for custom randomizing function
random = @(current_x, problem) ...
    ( ...
    randomize(current_x)...
    ...
    )...
    ;

% wrapper for custom cost function
cost = @(x, y, z, k)(total_distance(x, y, z));

%define problem:
problem.definition.variables = {'x', 'y', 'order', 'names'};
problem.definition.limits = {x, y, order, names};
problem.definition.cost_function = cost;
problem.settings.randomize = random;
problem.settings.step_modifier = 4;
problem.settings.cooling_rate = 0.01;
problem.settings.max_accept_per_temp = 10;
problem.settings.max_tries_per_temp = 100;
problem.settings.stop_temperature = 1;
problem.initial.temperature = 1000;
problem.initial.values = {x, y, order, names};
problem.plot = 'yes';
problem.plot_function = @custom_cities_plot;
problem.plot_save_animation = 'yes';
problem.plot_filename = 'discrete_annealing.gif';
        
problem.printing = 'no';
%%
solution = anneal(problem);

x = solution.optimum.values{1};
y = solution.optimum.values{2};
order = solution.optimum.values{3};
%plot current route

plot_cities(x,y,order,names);
title('final')