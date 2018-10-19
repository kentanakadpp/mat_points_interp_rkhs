clear all;
close all;
dir_smp = './DataSmpSeq/'; % Directory to save the data of the sampling points
dir_cnd = './DataCnd/'; % Directory to save the data of the condition numbers

%% Kernels
% [Brownian kernel 1D]
K = @(x,y) min(x,y);
prefix = 'Brown1D';
n_arr = [4:4:24];

% [Gaussian kernel]
% eps = 1;
% alp = 1;
% K = @(x,y) exp(-eps * sum((x-y).^2)/(alp^2));
% [1D] 
% prefix = 'Gauss1D';
% n_arr = [4:4:24];
% [2D square]
% prefix = 'Gauss2D_sqr';
% n_arr = [[8:4:32],35];
% [2D triangle]
% prefix = 'Gauss2D_tri';
% n_arr = [[8:4:32],35];
% [2D disk]
% prefix = 'Gauss2D_dsk';
% n_arr = [[8:4:32],35];

% Spherical inverse multiquadratic kernel
% gamma = 0.1;
% K = @(x,y) 1/sqrt(1 + gamma^2 - 2*gamma*dot(x,y));
% prefix = 'sphere';
% n_arr = [[8:4:32],35];

%% Computation of condition numbers
I = length(n_arr);
arr_cond = zeros(1,I);
for k=1:I
    n = n_arr(k);
    filename = strcat(dir_smp, prefix, '_smp_seq_n_', num2str(n),'.txt');
    a = dlmread(filename);

    matK = zeros(n,n);
    for i=1:n
        for j=1:n
            matK(i,j) = K(a(i,:), a(j,:));
        end
    end
       
    arr_cond(k) = cond(matK);    
end

%% Output
plot(n_arr, log10(arr_cond),'--*',...
    'MarkerSize', 5,...
    'LineWidth', 2);
set(gca,'FontSize',16);
grid on; 
xlabel('n');
ylabel('log_{10}(Cond(K))');
legend('Algorithm 2', 'Location', 'NorthWest');

filename = strcat(dir_cnd, prefix, '_cnd_seq.txt');
% dlmwrite(filename, [n_arr', log10(arr_cond)']);
