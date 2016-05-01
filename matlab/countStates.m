%% Machine Learning - Project - Count States
clc;

format shortG

filename = '/Users/Ajrok/Documents/MATLAB/MachineLearning/Project/term2048/term2048/states.csv';
M = csvread(filename,0,0);

filename = '/Users/Ajrok/Documents/MATLAB/MachineLearning/Project/term2048/term2048/results.csv';
N = csvread(filename,1,0);

goal = 8
runs = length(M)
numberOfStates = M(end,1)
possibleStates = 16*log2(goal) + log2(goal)^16
discoveredPart = numberOfStates/possibleStates

M(:,2) = M(:,2)./N(:,1);

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

figure(4)
clf
hold on
plot(X1,M(:,2))
plot(X2,Y2,'LineWidth',4)
legend('update','moving average')
hold off
xlabel('run')
ylabel('number of new states')

figure(5)
semilogy(X2,Y2)