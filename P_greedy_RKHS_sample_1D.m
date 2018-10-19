clear all;
close all;
dir_smp = './DataSmpPG/'; % Directory to save the data of the sampling points
dir_pwr = './DataPwr/'; % Directory to save the data of the power functions
dir_time = './DataTime/'; % Directory to save the data of the times

m = 250; % Number of candidates 

%% Kernels
% Brownian kernel.
% prefix = 'Brown';
% K = @(x,y) min(x,y);
% x = linspace(0,1,m);
% n_max = 32;

% Gaussian kernel.
prefix = 'Gauss';
eps = 1;
alp = 1;
K = @(x, y) exp(-eps * sum((x-y).^2)/(alp)^2);
x = linspace(-1,1,m);
n_max = 18;

%% P-greedy algorithm
smpl = zeros(1,n_max+1);
smpl(1) = x(m); % First sampling point
max_y_arr = zeros(1,n_max);
time_arr = zeros(1,n_max);
time_acc_arr = zeros(1,n_max);
for n = 1:n_max

    display(strcat('Processing the case n=', num2str(n), '.....'));
    
    tic;
    
    y = zeros(1,m);
    for k=1:m
        y(k) = func_powfunc_1D(x(k), n, smpl(1:n), K);
    end

    [max_y, max_k] = max(y);

    max_y_arr(n) = max_y;
    smpl(n+1) = x(max_k);

    time_arr(1,n) = toc;
    if n==1
        time_acc_arr(1,n) = time_arr(1,n);
    else        
        time_acc_arr(1,n) = time_acc_arr(1,n-1) + time_arr(1,n);
    end
    
%     plot(x, y,'LineWidth', 3);
%     set(gca,'FontSize',16);
%     grid on; 
%     xlabel('x');
%     ylabel('P(x)');
%     title(strcat('Power function for n=',num2str(n)));
%     
%     pause;
end

%% Output
plot([1:n_max], log10(max_y_arr),'--.',...
    'MarkerSize', 25,...
    'LineWidth', 2);
set(gca,'FontSize',16);
grid on; 
xlabel('n');
ylabel('log_{10} (max |P(x)|)');

filename = strcat(dir_smp, prefix, '1D_smp_pgreedy.txt');
% dlmwrite(filename, [[1:n_max]', smpl(1:n_max)']);

filename = strcat(dir_pwr, prefix, '1D_powfunc_max_pgreedy.txt');
% dlmwrite(filename, [[1:n_max]', log10(max_y_arr)']);

filename = strcat(dir_time, prefix, '1D_smp_times_pgreedy.txt');
% dlmwrite(filename, [[1:n_max]', time_acc_arr']);
