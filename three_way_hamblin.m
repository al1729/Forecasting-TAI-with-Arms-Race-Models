%% Data Fitting
china = [0.129 0.448 1.808 3.476 6.009 10.24 12.747 9.823 17.21];
usa = [1.941 4.504 5.831 7.904 11.299 16.13 21.648 26.907 52.872];
eu = [0.471 0.575 0.314 0.531 0.881 1.355 2.233 2.013 6.424];

numstartpoints = 100;
% parameters: [s n b1 m1 b2 m2]
LowerBounds = [0.561 0.122 0.165 0.452 0.165 0.452];
UpperBounds = [46.55 2.376 1.396 3.431 1.396 3.431];
xstart=.5*(LowerBounds+UpperBounds); % initial param values

% define problem
problem = createOptimProblem('fmincon','objective',@SOLVE_RACE,'x0',xstart,'lb',LowerBounds,'ub',UpperBounds);
problem.options = optimoptions(problem.options,'MaxFunEvals',9999,'MaxIter',9999);

% uncomment to run
ms=MultiStart('UseParallel',true,'Display','iter');
[b,fval,exitflag,output,manymins]=run(ms,problem,numstartpoints); %runs the multistart 
Parameters = manymins(1).X;
s = Parameters(1);
n = Parameters(2);
b1 = Parameters(3);
m1 = Parameters(4);
b2 = Parameters(5);
m2 = Parameters(6);

%% initial conditions
x0 = 1.941; % leader
y0 = 0.129; % follower
z0 = 0.471; % follower 2

numTimeSteps = 8;
x = zeros(1,numTimeSteps);
y = zeros(1,numTimeSteps);
z = zeros(1,numTimeSteps);
x(1) = x0;
y(1) = y0;
z(1) = z0;

for t=1:numTimeSteps
    x(t+1) = s*(y(t)^n + z(t)^n);
    y(t+1) = b1*x(t+1)^m1;
    z(t+1) = b2*x(t+1)^m2;
end

%% Plot the results
subplot(1,3,1);
plot(y,'.-','MarkerSize',12);  
hold on
plot(china,'.-','MarkerSize',12);   
hold off
title('Predicted v Actual CHN', 'FontSize', 24);
set(gca,'FontSize',18)  
xlabel('Years since 2013')   
ylabel('Spending (billions USD)') 

subplot(1,3,2);
plot(usa,'.-','MarkerSize',12);   
hold on
plot(x,'.-','MarkerSize',12);   
hold off
title('Predicted v Actual USA', 'FontSize', 24);
set(gca,'FontSize',18)  
xlabel('Years since 2013')   
ylabel('Spending (billions USD)')

subplot(1,3,3);
plot(eu,'.-','MarkerSize',12);   
hold on
plot(z,'.-','MarkerSize',12);   
hold off
title('Predicted v Actual EU', 'FontSize', 24);
set(gca,'FontSize',18)  
xlabel('Years since 2013')   
ylabel('Spending (billions USD)')

function value=SOLVE_RACE(params)
s = params(:,1);
n = params(:,2);
b1 = params(:,3);
m1 = params(:,4);
b2 = params(:,5);
m2 = params(:,6);
% data
x_real = [1.941 4.504 5.831 7.904 11.299 16.13 21.648 26.907 52.872];
y_real = [0.129 0.448 1.808 3.476 6.009 10.24 12.747 9.823 17.21];
z_real = [0.471 0.575 0.314 0.531 0.881 1.355 2.233 2.013 6.424];

numTimeSteps = 8;
x = zeros(1,numTimeSteps);
y = zeros(1,numTimeSteps);
z = zeros(1,numTimeSteps);
x(1) = 1.941;
y(1) = 0.129;
z(1) = 0.471;

for t=1:numTimeSteps
    x(t+1) = s*(y(t)^n + z(t)^n);
    y(t+1) = b1*x(t+1)^m1;
    z(t+1) = b2*x(t+1)^m2;
end
diff1 = x_real - reshape(x,size(x_real));
diff2 = y_real - reshape(y,size(y_real));
diff3 = z_real - reshape(z,size(z_real));
value=norm(diff1,2) + norm(diff2,2) + norm(diff3,2);

if value > 999999999
    value = 999999999;
end

end
