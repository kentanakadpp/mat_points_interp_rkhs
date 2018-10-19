clear all;
close all;
dir_smp = './DataSmpPG/'; % Directory to save the data of the sampling points
dir_pwr = './DataPwr/'; % Directory to save the data of the power functions
dir_time = './DataTime/'; % Directory to save the data of the times

%% Spherical inverse multiquadratic kernel
gamma = 0.1;
K = @(x,y) 1/sqrt(1 + gamma^2 - 2*gamma*dot(x,y));

%% Sphere.
k = 25; % Number of the division of the longitude and latitude axis
pre_theta = linspace(0,pi,k);
pre_phi = linspace(0,2*pi,k);
pre_phi = pre_phi(1:k-1);
theta = zeros(1,(k-1)*(k-2)+2);
phi = zeros(1,(k-1)*(k-2)+2);
p = 0;
for i=1:k
    if i==1
        p = p+1;
        theta(p) = 0;
        phi(p) = 0;
    elseif i==k
        p = p+1;
        theta(p) = pi;
        phi(p) = 0;        
    else
        for j=1:k-1
            p = p+1;
            theta(p) = pre_theta(i);
            phi(p) = pre_phi(j);
        end
    end
end
idx = [1:p];
m = length(idx); % Number of candidates
xx = sin(theta) .* cos(phi);
yy = sin(theta) .* sin(phi);
zz = cos(theta);

x = [xx', yy', zz'];

n_max = 35;

%% P-greedy algorithm
smpl = zeros(n_max+1,3);
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
        
%     scatter3(theta, phi, y ,'filled');
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

filename = strcat(dir_smp, 'sphere_smp_pgreedy_gamma_', num2str(gamma) ,'.txt');
% dlmwrite(filename, [[1:n_max]', smpl(1:n_max,:)]);

filename = strcat(dir_pwr, 'sphere_powfunc_max_pgreedy_gamma_', num2str(gamma) ,'.txt');
% dlmwrite(filename, [[1:n_max]', log10(max_y_arr)']);

filename = strcat(dir_time, 'sphere_smp_times_pgreedy.txt');
% dlmwrite(filename, [[1:n_max]', time_acc_arr']);
