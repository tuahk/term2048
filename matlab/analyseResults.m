%% Machine Learning - Project - Analyse results
%clc;

format shortG

filename = 'results.csv';
M = csvread(filename,1,0);
runs = length(M)

%% General analysis - of last 10%

Moves = [min(M(runs*0.9:end,1)); median(M(runs*0.9:end,1)); max(M(runs*0.9:end,1)); mean(M(runs*0.9:end,1)); std(M(runs*0.9:end,1))];
Score = [min(M(runs*0.9:end,3)); median(M(runs*0.9:end,3)); max(M(runs*0.9:end,3)); mean(M(runs*0.9:end,3)); std(M(runs*0.9:end,3))];
maxTile = [min(M(runs*0.9:end,2)); median(M(runs*0.9:end,2)); max(M(runs*0.9:end,2)); mean(M(runs*0.9:end,2)); std(M(runs*0.9:end,2))];

rows = {'Min';'Med';'Max';'Avg';'Std'};
T = table(Moves,Score,maxTile,'RowNames',rows)

figure(1)
H = histogram(M(:,3),'BinWidth',5);
xlim([Score(1) Score(3)])

% Write to .csv file
% csvwrite('randomAll.csv',[H.BinEdges(2:end)'-25 H.Values'])

%% Per max tile analysis

F8 = M((M(:, 2) == 8),:);
F16 = M((M(:, 2) == 16),:);
F32 = M((M(:, 2) == 32),:);
F64 = M((M(:, 2) == 64),:);
F128 = M((M(:, 2) == 128),:);
F256 = M((M(:, 2) == 256),:);
F512 = M((M(:, 2) == 512),:);

% number of runs that finished with specific max tile
v = [8; 16; 32; 64; 128; 256; 512];
n = [length(F8); length(F16); length(F32); length(F64); length(F128); length(F256); length(F512)];
p = n./runs;

columns = {'maxTile';'numberOfRuns';'part'};
R = table(v,n,p,'VariableNames',columns)

figure(2)
clf
xlim([Score(1) Score(3)])
binWidth = 5;
hold on
histogram(F8(:,3),'BinWidth',binWidth);
histogram(F16(:,3),'BinWidth',binWidth);
histogram(F32(:,3),'BinWidth',binWidth);
histogram(F64(:,3),'BinWidth',binWidth);
histogram(F128(:,3),'BinWidth',binWidth);
histogram(F256(:,3),'BinWidth',binWidth);
hold off
legend('max tile: 8','max tile: 16','max tile: 32','max tile: 64','max tile: 128','max tile: 256')

% Write to .csv file
% csvwrite('random32.csv',[H32.BinEdges(2:end)'-25 H32.Values'])
% csvwrite('random64.csv',[H64.BinEdges(2:end)'-25 H64.Values'])
% csvwrite('random128.csv',[H128.BinEdges(2:end)'-25 H128.Values'])
% csvwrite('random256.csv',[H256.BinEdges(2:end)'-25 H256.Values'])

%% Advancement analysis

windowSize = 5000;  % interval size for average
y = filter((1/windowSize)*ones(1,windowSize),1,M(:,3));

X = linspace(windowSize,runs,runs-windowSize+1);
Y = y(windowSize:end);

%% Reduce
xReduced = X;
yReduced = Y;
%[xReduced, yReduced] = reduceData(X,Y,1000);

figure(3)
plot(xReduced,yReduced)
xlabel('runs')
ylabel('score')