%%
clear all;
close all;

problem.definition.variables = {'x'};
problem.definition.limits = {[0; 20]};
problem.definition.cost_function = @(x)100*sin(pi.*x).*exp(-x./(2.*pi));
problem.settings.step_modifier = 8;
problem.settings.cooling_rate = 0.005;
problem.settings.max_accept_per_temp = 10;
problem.settings.max_tries_per_temp = 100;
problem.settings.stop_temperature = 1;
problem.initial.temperature = 10000;
problem.initial.values = [10];
problem.plot = 'yes';
problem.plot_filename = 'annealing.gif';
problem.plot_save_animation = 'yes';

x=(0:0.05:20)
problem.figure = figure(101);
plot(x, problem.definition.cost_function(x));
hold on;

%%
problem.settings.randomize = 'all';
solution_rand_all = anneal(problem);

%%
problem.settings.randomize = 'random_one';
solution_rand_one = anneal(problem);