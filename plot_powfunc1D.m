clear all;
close all;
dir_smp = './DataSmp/'; % Directory to save the data of the sampling points
dir_smp_pg = './DataSmpPG/'; % Directory to save the data of the sampling points

n = 15;

%% Kernels
% [Brownian kernel]
K = @(x,y) min(x,y);
l = 10000;
x = linspace(0,1,l);
prefix = 'Brown';

% [Gaussian kernel]
% eps = 1;
% alp = 1;
% K = @(x,y) exp(-eps * sum((x-y).^2)/(alp^2));
% l = 1000;
% x = linspace(-1,1,l);
% prefix = 'Gauss';

%% Computing the power functions
% [SOCP]
filename = strcat(dir_smp, prefix ,'1D_smp','_n_', num2str(n), '.txt');
a_SOCP = dlmread(filename);
% [P-greedy]
filename = strcat(dir_smp_pg, prefix ,'1D_smp_pgreedy.txt');
a_PG = dlmread(filename);
a_PG = a_PG([1:n],2);

P_SOCP = zeros(1,l);
P_PG = zeros(1,l);
for k=1:l
    P_SOCP(k) = func_powfunc_1D(x(k),n,a_SOCP,K);
    P_PG(k) = func_powfunc_1D(x(k),n,a_PG,K);
end

%% Plot of the power functions
plot(x, P_SOCP,'LineWidth', 2);
hold on;
plot(x, P_PG,'-.', 'LineWidth', 2);
set(gca,'FontSize',16);
grid on; 
xlabel('x');
ylabel('P(x)');
title(strcat('Power functions for n=',num2str(n)));
legend('Algorithm 1', 'P-greedy');
% ylim([0,0.05]);
