clear all;
close all;
seq = 1; % 'Sequential' or not
if seq
    dir_smp = './DataSmpSeq/'; % Directory to save the data of the sampling points
else    
    dir_smp = './DataSmp/'; % Directory to save the data of the sampling points
end
dir_pwr = './DataPwr/'; % Directory to save the data of the power functions

%% Kernel
% Spherical inverse multiquadratic kernel
gamma = 0.1;
K = @(x,y) 1/sqrt(1 + gamma^2 - 2*gamma*dot(x,y));

%% Region
k = 35; % Number of the division of the longitude and latitude axis
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
l = length(idx); % Number of candidates
xx = sin(theta) .* cos(phi);
yy = sin(theta) .* sin(phi);
zz = cos(theta);
x = [xx', yy', zz'];

if seq
%     n_first = 8;
%     n_last = 20;
%     n_diff = 4;    
%     
    n_arr = [8, 12, 16, 20, 24, 28, 32, 35];    
else
%     n_first = 2;
%     n_last = 35;
%     n_diff = 1;
%
%     n_arr = [2:35];
    n_arr = [[2:23],[26:35]];
end

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
        filename = strcat(dir_smp, 'sphere_smp_seq_n_', num2str(n), '.txt');
    else
        filename = strcat(dir_smp, 'sphere_smp_n_', num2str(n), '.txt');
    end
    a = dlmread(filename);

    P = zeros(1,l);
    for k=1:l
        P(k) = func_powfunc_multiD(x(k,:),n,a,K); % multi-dimensional
    end

    num_p = num_p + 1;
    arr_P(num_p) = max(P);
    scatter3(theta, phi , P, 'filled');
    set(gca,'FontSize',16);
    grid on;
    xlabel('theta');
    ylabel('phi');
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
    filename = strcat(dir_pwr, 'sphere_powfunc_max_gamma_', num2str(gamma) ,'_seq.txt');
else
    filename = strcat(dir_pwr, 'sphere_powfunc_max_gamma_', num2str(gamma) ,'.txt');
end    
dlmwrite(filename, [n_arr; log10(arr_P)]');
