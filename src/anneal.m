function [ solution ] = anneal_randomize_all( problem )
%ANNEAL Summary of this function goes here
%   Takes list of problem variables {'x', 'y'} that cost depends on,
%   in addition takes limits for those problem.limits {[1; 10], [-5; 10]}
%   and then the problem.cost function to be optimized as anonymous function.
%
%   See test_anneal and test_anneal_on_discrete for examples
%
%   in:             problem.definition.variables: {'x', 'y'}
%                   problem.definition.limits: {[1; 10], [-5; 10]}
%                       if limits is longer than 2, values are assumed to
%                       be discrete list of possible values for the
%                       variable.
%                   problem.definition.cost_function: @(variables)(function)
%                   problem.settings.randomize, either 'all' or 'random_one', or custom @(variables)(function)
%                   problem.settings.step_modifier
%                   problem.settings.cooling_rate
%                   problem.settings.max_accept_per_temp
%                   problem.settings.max_tries_per_temp
%                   problem.settings.stop_temperature
%                   problem.initial.temperature
%                   problem.initial.values
% (optional)        problem.plot = 'yes' or 'no'
% (optional)        problem.plot_function = @(variables)(function)
% (optional)        problem.plot_save_animation = 'yes' or 'no'
% (optional)        problem.plot_filename = 'discrete_annealing.gif'
% (optional)        problem.printing = 'yes' or 'no'
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
                                 
x = current_x;
current_cost = solution.optimum.cost;
plot_next = 20;    

while temp > problem.settings.stop_temperature
    
    tries_this_temp = 0;
    accepts_this_temp = 0;
    
    while ~( (tries_this_temp > problem.settings.max_tries_per_temp) ...
            || (accepts_this_temp > problem.settings.max_accept_per_temp))
    
        %generate set of random values for variables
        x = randomize(current_x, problem);
        
        %current_cost = calculate_cost(problem.definition.cost_function,...
        %                      current_x);
        new_cost = calculate_cost(problem.definition.cost_function, ...
                                        x);
        
        if accept(current_cost, new_cost, temp)
            
           current_x = x; 
           current_cost = new_cost;
           accepts_this_temp = accepts_this_temp + 1;
           tries_this_temp = tries_this_temp + 1;
        else
            tries_this_temp = tries_this_temp + 1;
        end
        
        if new_cost < solution.optimum.cost
           
            solution.optimum.values = x;
            solution.optimum.cost = new_cost;
        end

        if isfield(problem, 'printing') && strcmp(problem.printing, 'yes')
            display(sprintf('temperature: %f, current: %f, best: %f, solutions_accepted:%d, solutions_tried:%d', ...
                        temp, current_cost, solution.optimum.cost, accepts_this_temp, tries_this_temp));
        end
    end
                          
    if ((isfield(problem, 'plot') && strcmp(problem.plot, 'yes')) && plot_next > 10)
        plot_next = 0;
        if temp == problem.initial.temperature && isfield(problem,'figure')
            figure(problem.figure);
        end
        if isfield(problem, 'plot_function')
            problem.plot_function(current_x, current_cost, solution.optimum.cost, temp, ...
                     problem.initial.temperature);
        else
            plot_current(current_x, current_cost, solution.optimum.cost, temp, ...
                     problem.initial.temperature);
        end
        
        if isfield(problem, 'plot_save_animation') && strcmp(problem.plot_save_animation, 'yes')
            drawnow
            frame = getframe;
            im = frame2im(frame);
            [imind, cm] = rgb2ind(im,256);
            
            if  temp == problem.initial.temperature
                imwrite(imind,cm,problem.plot_filename,'gif','Loopcount',inf);
            else
                imwrite(imind,cm,problem.plot_filename,'gif','WriteMode','append');
            end
        end
        pause(0.01);
    end
    
    %cooldown:
    temp = temp*(1-problem.settings.cooling_rate);
    
    plot_next = plot_next + 1;
    
    if isfield(problem, 'printing') && strcmp(problem.printing, 'yes')
        display('current parameters:');
        for i=1:length(current_x)
       
            if isnumeric(current_x(i))
                display(sprintf('param%d: %f', i, current_x(i)));
            else
                display(current_x(i));
            end
        end
    
            display(sprintf('temperature: %f, current: %f, best: %f', ...
                        temp, current_cost, solution.optimum.cost));
    end
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

function plot_current(x, current_cost, optimum_cost, temp, init_t)

    title(sprintf('temperature: %0.2f, cost: %0.2f, best: %0.2f', ...
                    temp, current_cost, optimum_cost));
switch(length(x))
    
    case 1
        plot(x, current_cost, 'o', 'Color', [(1-exp(-temp*3/init_t)) (1-exp(-temp*3/init_t)) (1-exp(-temp*3/init_t))]);
    case 2
        plot(x(1), x(2), 'o', 'Color', [(1-exp(-temp*3/init_t)) (1-exp(-temp*3/init_t)) (1-exp(-temp*3/init_t))]);
    otherwise
        warning('More than 2 variables cannot be visualized.');
end

end

function value = calculate_cost(cost, values)

switch(length(values))
    
    case 1
        if iscell(values)
            value = cost(values{1});
        else
            value = cost(values(1));
        end
    case 2
        if iscell(values)
            value = cost(values{1}, values{2});
        else
            value = cost(values(1), values(2));
        end
    case 3
        if iscell(values)
            value = cost(values{1}, values{2}, values{3});
        else
            value = cost(values(1), values(2), values(3));
        end
    case 4
        if iscell(values)
            value = cost(values{1}, values{2}, values{3}, values{4});
        else
            value = cost(values(1), values(2), values(3), values(4));
        end
    case 5
        if iscell(values)
            value = cost(values{1}, values{2}, values{3}, values{4}, ...
            values{5});
        else
            value = cost(values(1), values(2), values(3), values(4), ...
            values(5));
        end
    case 6
        if iscell(values)
            value = cost(values{1}, values{2}, values{3}, values{4}, ...
            values{5}, values{6});    
        else
            value = cost(values(1), values(2), values(3), values(4), ...
            values(5), values(6));
        end
    case 7
        if iscell(values)
            value = cost(values{1}, values{2}, values{3}, values{4}, ...
            values{5}, values{6}, values{7});    
        else
            value = cost(values(1), values(2), values(3), values(4), ...
            values(5), values(6), values(7));
        end
    case 8
        if iscell(values)
            value = cost(values{1}, values{2}, values{3}, values{4}, ...
            values{5}, values{6}, values{7}, values{8});    
        else
            value = cost(values{1}, values{2}, values{3}, values{4}, ...
            values{5}, values{6}, values{7}, values{8});
        end
    case 9
        if iscell(values)
            value = cost(values{1}, values{2}, values{3}, values{4}, ...
            values{5}, values{6}, values{7}, values{8}, values{9});    
        else
            value = cost(values(1), values(2), values(3), values(4), ...
            values(5), values(6), values(7), values(8), values(9));
        end
    case 10
        if iscell(values)
            value = cost(values{1}, values{2}, values{3}, values{4}, ...
            values{5}, values{6}, values{7}, values{8}, values{9}, ...
            values{10});
        else
            value = cost(values(1), values(2), values(3), values(4), ...
            values(5), values(6), values(7), values(8), values(9), ...
            values(10));
        end
    otherwise
        error('You need to add new case in anneal.m for more variables!');
end

end

function x = randomize(current_x, problem)

    x = current_x;

    if(strcmp(problem.settings.randomize,'all'))
        for i=1:length(current_x)
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
    elseif(strcmp(problem.settings.randomize,'random_one'))
        
       %change only one (random) variable per round:
        i=randi(length(current_x), 1, 1);
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
        
    else
        
        x = problem.settings.randomize(current_x, problem);
    end

end