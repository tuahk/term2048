function a = qLearningOpt(boardSize,goal,trainRuns,testRuns,train,parameters,gamma)
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

alpha = parameters(1);
%gamma = parameters(2);
epsilon = parameters(2);

[~,a] = runQLearning(boardSize,goal,trainRuns,testRuns,train,alpha,gamma,epsilon);