%% Machine Learning - Project - Count States
clc;

format shortG

filename = 'states_50k_r1.csv';
M = csvread(filename,0,0);

runs = length(M)
numberOfStates = M(end,1)

%% Analyse All
initSize = 1000;    % the size of data we fit linear function to
X1 = linspace(1,runs,runs);
F1 = fit(X1(1:initSize)',M(1:initSize,1),'poly1')
Y1 = F1.p1 .* X1 + F1.p2;

figure(3)
plot(X1,M(:,1),'-',X1,Y1,'-')
legend('number of states','linear fit','Location','northwest')
xlabel('runs')
ylabel('number of states')


%% Analyse Update
windowSize = 1000;  % interval size for average
y = filter((1/windowSize)*ones(1,windowSize),1,M(:,2));

X2 = linspace(windowSize,runs,runs-windowSize+1);
Y2 = y(windowSize:end);

F2 = fit(X1',M(:,2),'poly1')
Y3 = F2.p1 .* X1 + F2.p2;

expectedNumberOfRuns = -F2.p2/F2.p1

figure(4)
clf
hold on
plot(X1,M(:,2))
plot(X2,Y2,'LineWidth',4)
plot(X1,Y3,'--','LineWidth',1)
legend('update','moving average','linear fit')
hold off
xlabel('run')
ylabel('number of new states')