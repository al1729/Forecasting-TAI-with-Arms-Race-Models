
%% Data Fitting
china = [0.129 0.448 1.808 3.476 6.009 10.24 12.747 9.823 17.21];
usa = [1.941 4.504 5.831 7.904 11.299 16.13 21.648 26.907 52.872];

numstartpoints = 100;
LowerBounds = [0.561 0.122 0.165 0.452];
UpperBounds = [46.55 2.376 1.396 3.431];
xstart=.5*(LowerBounds+UpperBounds); % initial param values

% define problem
problem = createOptimProblem('fmincon','objective',@SOLVE_RACE,'x0',xstart,'lb',LowerBounds,'ub',UpperBounds);
problem.options = optimoptions(problem.options,'MaxFunEvals',9999,'MaxIter',9999);

% uncomment to run
ms=MultiStart('UseParallel',true,'Display','iter');
[b,fval,exitflag,output,manymins]=run(ms,problem,numstartpoints); %runs the multistart 
Parameters = manymins(1).X;

%% Outputs state variables for "best" fit
disp(Parameters);
s = Parameters(1);
n = Parameters(2);
b = Parameters(3);
m = Parameters(4);

%% initial conditions and model dynamics
x0 = 1.941; % leader
y0 = 0.129; % follower

s = 4.1273;
n = 0.9332;
b = 0.6300;
m = 0.8633;

numTimeSteps = 8;
x = zeros(1,numTimeSteps);
y = zeros(1,numTimeSteps);
x(1) = x0;
y(1) = y0;

for t=1:numTimeSteps
    x(t+1) = s*y(t)^n;
    y(t+1) = b*x(t+1)^m;
    % y(t+1) = b*exp(m*x(t+1));
end

%% Plot the results
plot(x,'.-','MarkerSize',12); 
hold on 
plot(y,'.-','MarkerSize',12);  
hold off
title('Predicted Spending over Time', 'FontSize', 24);
set(gca,'FontSize',18)  
xlabel('Years since 2013')   
ylabel('Spending (billions USD)') 

figure()
plot(y,'.-','MarkerSize',12);  
hold on
plot(china,'.-','MarkerSize',12);   
hold off
title('Predicted v Actual CHN', 'FontSize', 24);
set(gca,'FontSize',18)  
xlabel('Years since 2013')   
ylabel('Spending (billions USD)') 

figure()
plot(usa,'.-','MarkerSize',12);   
hold on
plot(x,'.-','MarkerSize',12);   
hold off
title('Predicted v Actual USA', 'FontSize', 24);
set(gca,'FontSize',18)  
xlabel('Years since 2013')   
ylabel('Spending (billions USD)') 


function value=SOLVE_RACE(params)
s = params(:,1);
n = params(:,2);
b = params(:,3);
m = params(:,4);
% data
%x_real = [1.941 4.504 5.831 7.904 11.299 16.13 21.648 26.907];
%y_real = [0.129 0.448 1.808 3.476 6.009 10.24 12.747 9.823];
x_real = [1.941 4.504 5.831 7.904 11.299 16.13 21.648 26.907 52.872];
y_real = [0.129 0.448 1.808 3.476 6.009 10.24 12.747 9.823 17.21];
numTimeSteps = 8;
x = zeros(1,numTimeSteps);
y = zeros(1,numTimeSteps);
x(1) = 1.941;
y(1) = 0.129;
for t=1:numTimeSteps
    x(t+1) = s*y(t)^n;
    y(t+1) = b*x(t+1)^m;
    % y(t+1) = b*exp(m*x(t+1));
end
diff1 = x_real - reshape(x,size(x_real));
diff2 = y_real - reshape(y,size(y_real));
value=norm(diff1,2) + norm(diff2,2);

if value > 999999999
    value = 999999999;
end

end

