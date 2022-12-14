%% initial conditions and model dynamics
x0 = 52.872; % leader
y0 = 17.21; % follower

s = 4.1273;
n = 0.9332;
b = 1.6300;
m = 0.8633;

numTimeSteps = 20;
x = zeros(1,numTimeSteps);
y = zeros(1,numTimeSteps);
x(1) = x0;
y(1) = y0;

for t=1:numTimeSteps
    x(t+1) = s*y(t)^n;
    y(t+1) = b*x(t+1)^m;
end

s = zeros(1,numTimeSteps);
for t=1:numTimeSteps+1
    s(t) = x(t) + y(t);
end
%% scaling
s = log10(s);
s = s + 9 - s(1);
writematrix(reshape(s,[21,1]),'s2.csv') 

%% Plot the results
plot(x,'.-','MarkerSize',12); 
% plot(log10(x)+9,'.-','MarkerSize',12); 
hold on 
plot(y,'.-','MarkerSize',12); 
% plot(log10(y)+9,'.-','MarkerSize',12);  
hold off
title('Predicted Spending over Time', 'FontSize', 24);
set(gca,'FontSize',18)  
xlabel('Years since 2020')   
ylabel('Spending (Billions USD)')