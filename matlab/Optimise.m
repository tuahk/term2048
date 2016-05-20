%% Optimise
clear;
clc;
tic

boardSize = 3;
goal = 64;
trainRuns = 250000;
testRuns = 25000;
train = 2;
alpha0 = 0.13;
gamma0 = 1.0;
epsilon0 = 0.85;

parameters0 = [alpha0 epsilon0];
FUN = @(parameters)qLearningOpt(boardSize,goal,trainRuns,testRuns,train,parameters,gamma0)*(-1); % *(-1) to find max

options = optimset('fminsearch');
options.Display = 'iter';
options.MaxFunEvals = 13;
options.TolX = 0.1;

[X,FVAL,EXITFLAG] = fminsearch(FUN,parameters0,options)


toc