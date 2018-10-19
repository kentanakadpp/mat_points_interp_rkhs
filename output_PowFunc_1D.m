clear all;
close all;
seq = 1; % 'Sequential' or not
if seq
    dir_smp = './DataSmpSeq/'; % Directory to save the data of the sampling points
else    
    dir_smp = './DataSmp/'; % Directory to save the data of the sampling points
end
dir_pwr = './DataPwr/'; % Directory to save the data of the power functions

%% Kernels
% Brownian kernel
% K = @(x,y) min(x,y);
% l = 1000;
% x = linspace(0,1,l);
% prefix = 'Brown';
% n_number = 24;

% Gaussian kernel
eps = 1;
alp = 1;
K = @(x,y) exp(-eps * sum((x-y).^2)/(alp^2));
l = 1000;
x = linspace(-1,1,l);
prefix = 'Gauss';
n_number = 16;

if seq
    n_first = 4;
    n_last = 24;
    n_diff = 4;    
else
    n_first = 2;
    n_last = n_first + n_number - 1;
    n_diff = 1;
end

%% Computing the maximum values of the power functions
arr_P = zeros(1, (n_last-n_first)/n_diff+1);
num_p = 0;
for n = n_first:n_diff:n_last
    str_n = num2str(n);
    if length(str_n) == 1
        str_n = strcat('0', str_n);
    end
    if seq
        filename = strcat(dir_smp, prefix ,'1D_smp_seq','_n_', num2str(n), '.txt');
    else
        filename = strcat(dir_smp, prefix ,'1D_smp','_n_', num2str(n), '.txt');
    end        
    a = dlmread(filename);

    P = zeros(1,l);
    for k=1:l
        P(k) = func_powfunc_1D(x(k),n,a,K); % 1-dimensional
    end

    num_p = num_p + 1;
    arr_P(num_p) = max(P);
    plot(x, P,'LineWidth', 3);
    set(gca,'FontSize',16);
    grid on; 
    xlabel('x');
    ylabel('P(x)');
    title(strcat('Power function for n=',num2str(n)));
%    ylim([0,0.05]);

    pause;
end

%% Output of the maximum values
plot([n_first:n_diff:n_last], log10(arr_P),'--.',...
    'MarkerSize', 25,...
    'LineWidth', 2);
set(gca,'FontSize',16);
grid on; 
xlabel('n');
ylabel('log_{10} (max |P(x)|)');

if seq
    filename = strcat(dir_pwr, prefix ,'1D_powfunc_max_seq.txt');
else
    filename = strcat(dir_pwr, prefix ,'1D_powfunc_max.txt');
end
% dlmwrite(filename, [[n_first:n_diff:n_last]; log10(arr_P)]');
