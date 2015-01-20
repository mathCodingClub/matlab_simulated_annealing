function [ solution ] = anneal_randomize_all( problem )
%ANNEAL Summary of this function goes here
%   Takes list of problem variables {'x', 'y'} that cost depends on,
%   in addition takes limits for those problem.limits {[1; 10], [-5; 10]}
%   and then the problem.cost function to be optimized as anonymous function.
%
%   in:             problem.definition.variables: {'x', 'y'}
%                   problem.definition.limits: {[1; 10], [-5; 10]}
%                       if limits is longer than 2, values are assumed to
%                       be discrete list of possible values for the
%                       variable.
%                   problem.definition.cost_function: @(variables)(function)
%                   problem.settings.step_modifier
%                   problem.settings.cooling_rate
%                   problem.settings.max_accept_per_temp
%                   problem.settings.max_tries_per_temp
%                   problem.settings.stop_temperature
%                   problem.initial.temperature
%                   problem.initial.values
%
%   returns solution structure: solution.variables: {'x', 'y' }
%                               solution.optimum.values: [2, 5]
%                               solution.optimum.cost
%                               solution.plots.distribution: for plotting the
%                                                   annealing process
%                               solution.plots.temperature

%set starting temperature:
temp = problem.initial.temperature;

%set initial variable values:
current_x = problem.initial.values;

%calculate first "optimum" values and cost:
solution.optimum.values = current_x;
solution.optimum.cost = calculate_cost(problem.definition.cost_function, ...
                                     solution.optimum.values);

current_cost = solution.optimum.cost;
                                 
while temp > problem.settings.stop_temperature
    
    tries_this_temp = 0;
    accepts_this_temp = 0;
    
    while ~( (tries_this_temp > problem.settings.max_tries_per_temp) ...
            || (accepts_this_temp > problem.settings.max_accept_per_temp))
    
        %generate set of random values for variables
        x = zeros(length(problem.definition.variables), 1);
        
        for i=1:length(x)
            limits = problem.definition.limits{i};
            lower = -((limits(2)-limits(1))/problem.settings.step_modifier);
            upper = ((limits(2)-limits(1))/problem.settings.step_modifier);
            
            %generate random value for the interval
            x(i) = current_x(i) + interval_rand(lower, upper);
               
            % "clip" to the limits:
            % first take minimum value between the new random value and
            % upper limit, then take maximum between the new value and
            % lower limit:
            x(i) = max(min(x(i), limits(2)), limits(1));
            
        end
        
        current_cost = calculate_cost(problem.definition.cost_function,...
                              current_x);
        new_cost = calculate_cost(problem.definition.cost_function, ...
                                        x);
        
        if accept(current_cost, new_cost, temp)
            
           current_x = x; 
           accepts_this_temp = accepts_this_temp + 1;
           tries_this_temp = tries_this_temp + 1;
        else
            tries_this_temp = tries_this_temp + 1;
        end
        
        if new_cost < solution.optimum.cost
           
            solution.optimum.values = x;
            solution.optimum.cost = new_cost;
        end
                                    
    end
    
    if temp == problem.initial.temperature
        figure(problem.figure);
        hold on;
    end
    current_cost = calculate_cost(problem.definition.cost_function,...
                              current_x);
    plot_current(current_x, current_cost, solution.optimum.cost, temp);
    
    %cooldown:
    temp = temp*(1-problem.settings.cooling_rate);
    
    pause(0.05);
end

end

function random = interval_rand(a, b)

    random = a + (b-a).*rand(1,1);
    
    

end

function ok = accept(old_cost, new_cost, temperature)

    if new_cost < old_cost
        %if test gives lower cost, always accept
       ok = 1; 
    else
       
        %otherwise calculate propability to accept worse solution
       probability = exp((old_cost-new_cost)/temperature);
       ok = (probability >= rand());
    end

end

function plot_current(x, current_cost, optimum_cost, temp)

    title(sprintf('temperature: %0.2f, cost: %0.2f, best: %0.2f', ...
                    temp, current_cost, optimum_cost));
switch(length(x))
    
    case 1
        plot(x, current_cost, 'o', 'Color', rand(1,3));
    case 2
        plot(x(1), x(2), 'o', 'Color', rand(1,3));
    otherwise
        warning('More than 2 variables cannot be visualized.');
end

end

function value = calculate_cost(cost, values)

switch(length(values))
    
    case 1
        value = cost(values(1));
    case 2
        value = cost(values(1), values(2));
    case 3
        value = cost(values(1), values(2), values(3));
    case 4
        value = cost(values(1), values(2), values(3), values(4));
    case 5
        value = cost(values(1), values(2), values(3), values(4), ...
            values(5));
    case 6
        value = cost(values(1), values(2), values(3), values(4), ...
            values(5), values(6));
    case 7
        value = cost(values(1), values(2), values(3), values(4), ...
            values(5), values(6), values(7));
    case 8
        value = cost(values(1), values(2), values(3), values(4), ...
            values(5), values(6), values(7), values(8));
    case 9
        value = cost(values(1), values(2), values(3), values(4), ...
            values(5), values(6), values(7), values(8), values(9));
    case 10
        value = cost(values(1), values(2), values(3), values(4), ...
            values(5), values(6), values(7), values(8), values(9), ...
            values(10));
    otherwise
        error('You need to add new case in anneal.m for more variables!');
end

end