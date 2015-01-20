%%
clear all;
close all;

problem.definition.variables = {'x', 'y'};
problem.definition.limits = {[-3; 3], [-3; 3]};
problem.definition.cost_function = @(x, y)(200.*sin(8.*x.*y).^2+200.*cos(x+y) ...
    + (200.*cos(4.*x)+200.*sin(4.*y)));
problem.settings.step_modifier = 4;
problem.settings.cooling_rate = 0.001;
problem.settings.max_accept_per_temp = 10;
problem.settings.max_tries_per_temp = 100;
problem.settings.stop_temperature = 1;
problem.initial.temperature = 1000;
problem.initial.values = [0, 0];

[x, y] = meshgrid(-4:0.05:4);
surf(x,y, problem.definition.cost_function(x,y), 'FaceColor', 'interp', 'EdgeColor','none');

problem.plot='yes';
problem.figure = figure(101);
contour(x,y, problem.definition.cost_function(x,y));
hold on;

%%
problem.settings.randomize = 'all';
solution_rand_all = anneal(problem);

%%
problem.figure = figure(102);
contour(x,y, problem.definition.cost_function(x,y));
hold on;

problem.settings.randomize = 'random_one';
solution_rand_one = anneal(problem);