%% initial conditions and model dynamics
x0 = 52.872; % leader
y0 = 17.21; % follower 1 (china)
z0 = 6.424; % follower 2 (eu)

s = 2.433;
n = 1.0766;
b1 = 0.7824;
m1 = 0.7999;
b2 = 0.165;
m2 = 1.0137;

numTimeSteps = 20;
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

s = zeros(1,numTimeSteps);
for t=1:numTimeSteps+1
    s(t) = x(t) + y(t);
end
%% scaling
s = log10(s);
s = s + 9 - s(1);
writematrix(reshape(s,[numTimeSteps + 1,1]),'s3_extended.csv') 

%% Plot the results
plot(x,'.-','MarkerSize',12); 
hold on 
plot(y,'.-','MarkerSize',12);  
plot(z,'.-','MarkerSize',12);
hold off
title('Predicted Spending over Time', 'FontSize', 24);
set(gca,'FontSize',18)  
xlabel('Years since 2020')   
ylabel('Spending (Billions USD)')