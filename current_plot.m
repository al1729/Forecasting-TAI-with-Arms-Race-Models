china = [0.129 0.448 1.808 3.476 6.009 10.24 12.747 9.823 17.21];
usa = [1.941 4.504 5.831 7.904 11.299 16.13 21.648 26.907 52.872];
eu = [0.471 0.575 0.314 0.531 0.881 1.355 2.233 2.013 6.424];

%% Plot the results
plot(china,'.-','MarkerSize',12); 
hold on 
plot(usa, '.-','MarkerSize',12);  
plot(eu, '.-','MarkerSize',12); % can be commented out
hold off
title('AI Spending over Time', 'FontSize', 24);
set(gca,'FontSize',18)  
xlabel('Years since 2013')   
ylabel('Spending (billions USD)') 