function [r,a] = runQLearning(boardSize,goal,trainRuns,testRuns,train,startClean,alpha,gamma,epsilon)
%runQLearning runs the python script with Q-Learning algorithm
%
%   [r,a] = runQLearning(boardSize,goal,trainRuns,testRuns,train,alpha,gamma,epsilon)
%
%   boardSize = the size of the 2048 game board
%   goal      = the goal after which we stop the game
%   trainRuns = number of runs training
%   testRuns  = number of runs testing
%   train     = 0 -> no, only test
%               1 -> yes, test simultaneously
%               2 -> both (first train and then test)
%   startClean = 0 -> no, start with empty states file
%                1 -> yes, use existing states
%
%   Update rule:
%   Q(s,a) <- Q(s,a) + alpha * [reward + gamma * max(Q(s',a')) - Q(s,a)]
%
%   alpha     = learning rate
%   gamma     = the discount factor
%   epsilon   = exploration rate
%
%   r         = ratio between times goal is achieved and number of runs
%   a         = average score



% run
location = '/Users/Ajrok/Documents/MATLAB/MachineLearning/Project/term2048/term2048';
filename = '/ai.py';

if train == 0
    epsilon = 1;
    commandStr = strcat('python',{' '},location,filename);
    commandStr = strcat(commandStr,{' '},num2str(boardSize));
    commandStr = strcat(commandStr,{' '},num2str(testRuns));
    commandStr = strcat(commandStr,{' '},num2str(train));
    commandStr = strcat(commandStr,{' '},num2str(alpha));
    commandStr = strcat(commandStr,{' '},num2str(gamma));
    commandStr = strcat(commandStr,{' '},num2str(epsilon));
    commandStr = strcat(commandStr,{' '},num2str(goal));
    commandStr = strcat(commandStr,{' '},num2str(startClean));
    [~,~] = system(commandStr{1});
elseif train == 1
    commandStr = strcat('python',{' '},location,filename);
    commandStr = strcat(commandStr,{' '},num2str(boardSize));
    commandStr = strcat(commandStr,{' '},num2str(trainRuns));
    commandStr = strcat(commandStr,{' '},num2str(train));
    commandStr = strcat(commandStr,{' '},num2str(alpha));
    commandStr = strcat(commandStr,{' '},num2str(gamma));
    commandStr = strcat(commandStr,{' '},num2str(epsilon));
    commandStr = strcat(commandStr,{' '},num2str(goal));
    commandStr = strcat(commandStr,{' '},num2str(startClean));
    [~,~] = system(commandStr{1});
else
    train = 1;
    commandStr = strcat('python',{' '},location,filename);
    commandStr = strcat(commandStr,{' '},num2str(boardSize));
    commandStr = strcat(commandStr,{' '},num2str(trainRuns));
    commandStr = strcat(commandStr,{' '},num2str(train));
    commandStr = strcat(commandStr,{' '},num2str(alpha));
    commandStr = strcat(commandStr,{' '},num2str(gamma));
    commandStr = strcat(commandStr,{' '},num2str(epsilon));
    commandStr = strcat(commandStr,{' '},num2str(goal));
    commandStr = strcat(commandStr,{' '},num2str(startClean));
    [~,~] = system(commandStr{1});
    train = 0;
    epsilon = 1;
    commandStr = strcat('python',{' '},location,filename);
    commandStr = strcat(commandStr,{' '},num2str(boardSize));
    commandStr = strcat(commandStr,{' '},num2str(testRuns));
    commandStr = strcat(commandStr,{' '},num2str(train));
    commandStr = strcat(commandStr,{' '},num2str(alpha));
    commandStr = strcat(commandStr,{' '},num2str(gamma));
    commandStr = strcat(commandStr,{' '},num2str(epsilon));
    commandStr = strcat(commandStr,{' '},num2str(goal));
    commandStr = strcat(commandStr,{' '},num2str(startClean));
    [~,~] = system(commandStr{1});
end

% read results
filename = 'results.csv';
M = csvread(filename,1,0);
runs = length(M);

% count achieved goals
timesGoal = length(M((M(:, 2) >= goal),:));
r = timesGoal/runs;

% get the average score
a = mean(M(:,3));