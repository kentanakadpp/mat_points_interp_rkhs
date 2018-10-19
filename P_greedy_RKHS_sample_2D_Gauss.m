clear all;
close all;
dir_smp = './DataSmpPG/'; % Directory to save the data of the sampling points
dir_pwr = './DataPwr/'; % Directory to save the data of the power functions
dir_time = './DataTime/'; % Directory to save the data of the times

%% Gaussian kernel.
prefix = 'Gauss';
eps = 1;
alp = 1;
K = @(x, y) exp(-eps * sum((x-y).^2)/(alp)^2);

%% Regions
% ([-1,1] * [-1,1])
% dom = @(x,y)(-1<=x && x<=1 && -1<=y && y<=1); 
% k = 23; % Number of the division of each axis
% prefix = 'sqr';
% (A triangle in [-1,1] * [-1,1])
% dom = @(x,y)(x+y>=0 && x<=1 && y<=1); 
% k = 32; % Number of the division of each axis
% prefix = 'tri';
% (A circle in [-1,1] * [-1,1])
dom = @(x,y)(x^2+y^2<=1); 
k = 27; % Number of the division of each axis
prefix = 'dsk';

n_max = 35;

xx = linspace(-1,1,k);
yy = linspace(-1,1,k);
x = zeros(k*k,2);

p = 0;
for i=1:k
    for j=1:k
        if(dom(xx(i), yy(j)))
            p = p+1;
            x(p,1) = xx(i);
            x(p,2) = yy(j);
        end
    end
end
m = p;
x = x(1:m,:);

%% P-greedy algorithm
smpl = zeros(n_max+1,2);
smpl(1,:) = x(m,:); % First sampling point
max_y_arr = zeros(1,n_max);
time_arr = zeros(1,n_max);
time_acc_arr = zeros(1,n_max);
for n = 1:n_max
    
    display(strcat('Processing the case n=', num2str(n), '.....'));
    
    tic;
    
    y = zeros(1,m);
    for k=1:m
        y(k) = func_powfunc_multiD(x(k,:), n, smpl(1:n,:), K);
    end

    [max_y, max_k] = max(y);

    max_y_arr(n) = max_y;
    smpl(n+1,:) = x(max_k,:);
    
    time_arr(1,n) = toc;
    if n==1
        time_acc_arr(1,n) = time_arr(1,n);
    else        
        time_acc_arr(1,n) = time_acc_arr(1,n-1) + time_arr(1,n);
    end
        
%     scatter3(x(:,1), x(:,2), y ,'filled');
%     set(gca,'FontSize',16);
%     grid on; 
%     xlabel('x');
%     ylabel('y');
%     zlabel('P(x)');
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

filename = strcat(dir_smp, 'Gauss2D_', prefix, '_smp_pgreedy.txt');
% dlmwrite(filename, [[1:n_max]', smpl(1:n_max,:)]);

filename = strcat(dir_pwr, 'Gauss2D_', prefix, '_powfunc_max_pgreedy.txt');
% dlmwrite(filename, [[1:n_max]', log10(max_y_arr)']);

filename = strcat(dir_time, 'Gauss2D_', prefix, '_smp_times_pgreedy.txt');
% dlmwrite(filename, [[1:n_max]', time_acc_arr']);
