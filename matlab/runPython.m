%% Run Python script
clear;
clc;
t0 = tic;

% constant parameters
boardSize = 3;
goal = 128;
trainRuns = 500000;
testRuns = 50000;
train = 2;
alpha = 0.13;   % 0.0001 - 1.0
gamma = 1;      % 0.1    - 1.0
epsilon = 0.85; % 0.1    - 0.95

% variable parameters
len = 50
variable = linspace(0.01,1,len);

% results
Ratio = zeros(len,1);
Score = zeros(len,1); 

% run
parfor i = 1:len
    t1 = tic;
    alpha = variable(i);
    [Ratio(i),Score(i)] = runQLearning(boardSize,goal,trainRuns,testRuns,train,alpha,gamma,epsilon)
    disp(toc(t1))
end

%% Plot
figure(1)
plot(variable,Ratio,'o-');
grid on
xlabel('variable')
ylabel('ratio of winning states')

figure(2)
plot(variable,Score,'o-');
grid on
xlabel('variable')
ylabel('average score')

toc(t0)