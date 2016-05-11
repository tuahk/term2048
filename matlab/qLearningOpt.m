function r = qLearningOpt(parameters)
%qLearningOpt runs the runQLearning function with specified parameters
%
%   r = qLearningOpt(parameters)
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


boardSize = 3;
goal = 128;
runs = 5000;
train = 2;
alpha = parameters(1);
gamma = parameters(2);
epsilon = parameters(3);

[r,~] = runQLearning(boardSize,goal,runs,train,alpha,gamma,epsilon);