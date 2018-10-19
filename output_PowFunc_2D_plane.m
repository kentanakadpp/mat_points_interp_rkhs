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
% Gaussian kernel
eps = 1;
alp = 1;
K = @(x,y) exp(-eps * sum((x-y).^2)/(alp^2));

%% Regions
% ([-1,1] * [-1,1])
% dom = @(x,y)(-1<=x && x<=1 && -1<=y && y<=1); 
% k = 32; % Number of the division of each axis
% prefix = 'sqr';
% (A triangle in [-1,1] * [-1,1])
% dom = @(x,y)(x+y>=0 && x<=1 && y<=1); 
% k = 45; % Number of the division of each axis
% prefix = 'tri';
% (A circle in [-1,1] * [-1,1])
dom = @(x,y)(x^2+y^2<=1); 
k = 37; % Number of the division of each axis
prefix = 'dsk';

if seq
%     n_first = 8;
%     n_last = 20;
%     n_diff = 4;    
% 
    n_arr = [8, 12, 16, 20, 24, 28, 32, 35];
else
%     n_first = 3;
%     n_last = 35;
%     n_diff = 1;
%
    n_arr = [3:35];
end

xx = linspace(-1,1,k);
yy = linspace(-1,1,k);
x = zeros(k*k, 2);

l = 0;
for i=1:k
    for j=1:k
        if(dom(xx(i), yy(j)))
            l = l+1;
            x(l,1) = xx(i);
            x(l,2) = yy(j);
        end
    end
end
x = x(1:l,:);

%% Computing the power functions and their maximum values
arr_P = zeros(1, length(n_arr));
num_p = 0;
for i = 1:length(n_arr)
    n = n_arr(i);
    str_n = num2str(n);
    if length(str_n) == 1
        str_n = strcat('0', str_n);
    end
    if seq
        filename = strcat(dir_smp, 'Gauss2D_', prefix ,'_smp_seq_n_', num2str(n), '.txt');
    else
        filename = strcat(dir_smp, 'Gauss2D_', prefix ,'_smp_n_', num2str(n), '.txt');
    end
    a = dlmread(filename);

    P = zeros(1,l);
    for k=1:l
        P(k) = func_powfunc_multiD(x(k,:),n,a,K); % multi-dimensional
    end

    num_p = num_p+1;
    arr_P(num_p) = max(P);
    scatter3(x(:,1), x(:,2) , P, 'filled');
    set(gca,'FontSize',16);
    grid on; 
    xlabel('x');
    ylabel('y');
    title(strcat('Power function for n=',num2str(n)));
%     zlim([0,1]);

    pause;
end

%% Plot of the maximum values
plot(n_arr, log10(arr_P),'--.',...
    'MarkerSize', 25,...
    'LineWidth', 2);
set(gca,'FontSize',16);
grid on; 
xlabel('n');
ylabel('log_{10} (max |P(x)|)');

if seq
    filename = strcat(dir_pwr, 'Gauss2D_', prefix ,'_powfunc_max_seq.txt');
else
    filename = strcat(dir_pwr, 'Gauss2D_', prefix ,'_powfunc_max.txt');    
end
dlmwrite(filename, [n_arr; log10(arr_P)]');
