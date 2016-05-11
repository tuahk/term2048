%% Run Python script
clear;
clc;
tic;

% constant parameters
boardSize = 3;
goal = 64;
runs = 1000;
train = 1;
alpha = 1;
gamma = 1;
epsilon = 0.9;

% variable parameters
Alpha = 0.1:0.1:1;

% results
Ratio = zeros(length(Alpha),1);
Score = zeros(length(Alpha),1); 

% run
for i = 1:length(Alpha)
    disp(i)
    alpha = Alpha(i);
    [Ratio(i),Score(i)] = runQLearning(boardSize,goal,runs,train,alpha,gamma,epsilon);
end

% plot
figure(1)
plot(Alpha,Ratio);

figure(2)
plot(Alpha,Score);

toc