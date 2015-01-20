%%
clear all;
close all;

problem.definition.variables = {'x', 'y'};
problem.definition.limits = {[-5; 5], [-5; 5]};
problem.definition.cost_function = @(x, y)(200.*sin(8.*x.*y).^2+200.*cos(x+y) ...
    + (800.*cos(4.*x)+600.*sin(4.*y))).*exp(-(x.*y)./(8.*pi));
problem.settings.step_modifier = 8;
problem.settings.cooling_rate = 0.001;
problem.settings.max_accept_per_temp = 10;
problem.settings.max_tries_per_temp = 100;
problem.settings.stop_temperature = 1;
problem.plot = 'yes';
problem.initial.temperature = 10000;
problem.initial.values = [1, 1];


[x, y] = meshgrid(-5:0.05:5);
surf(x,y, problem.definition.cost_function(x,y), 'FaceColor', 'interp', 'EdgeColor','none');

problem.figure = figure(101);
contour(x,y, problem.definition.cost_function(x,y));
hold on;

%%
problem.settings.randomize = 'all';
solution_rand_all = anneal(problem);

%%
problem.settings.randomize = 'random_one';
solution_rand_one = anneal(problem);