clear all;
close all;
dir_smp = './DataSmpPG/'; % Directory to save the data of the sampling points
dir_cnd = './DataCnd/'; % Directory to save the data of the condition numbers

%% Kernels
% [Brownian kernel 1D]
K = @(x,y) min(x,y);
prefix = 'Brown1D';

% [Gaussian kernel]
% eps = 1;
% alp = 1;
% K = @(x,y) exp(-eps * sum((x-y).^2)/(alp^2));
% [1D] 
% prefix = 'Gauss1D';
% [2D square]
% prefix = 'Gauss2D_sqr';
% [2D triangle]
% prefix = 'Gauss2D_tri';
% [2D disk]
% prefix = 'Gauss2D_dsk';

% Spherical inverse multiquadratic kernel
% gamma = 0.1;
% K = @(x,y) 1/sqrt(1 + gamma^2 - 2*gamma*dot(x,y));
% prefix = 'sphere';

%% Computation of condition numbers
if prefix(1) == 's'
    filename = strcat(dir_smp, prefix, '_smp_pgreedy_gamma_0.1.txt');
else
    filename = strcat(dir_smp, prefix, '_smp_pgreedy.txt');
end
na = dlmread(filename);
n = na(length(na(:,1)),1);
na(:,1) = [];
a = na;
arr_cond = zeros(1,n);

matK = [K(a(1,:), a(1,:))];
arr_cond(1) = cond(matK);  
if n>1
    for i=2:n
        tmp_clm = zeros(i-1,1);
        for j=1:(i-1)
            tmp_clm(j,1) = K(a(i,:), a(j,:));
        end            
        matK = [matK, tmp_clm];
        matK = [matK; [tmp_clm', K(a(i,:), a(i,:))]];
        
        arr_cond(i) = cond(matK);    
    end
end

%% Output
plot([1:n], log10(arr_cond),'--*',...
    'MarkerSize', 5,...
    'LineWidth', 2);
set(gca,'FontSize',16);
grid on; 
xlabel('n');
ylabel('log_{10}(Cond(K))');
legend('P-greedy', 'Location', 'NorthWest');

filename = strcat(dir_cnd, prefix, '_cnd_pg.txt');
% dlmwrite(filename, [[1:n]', log10(arr_cond)']);
