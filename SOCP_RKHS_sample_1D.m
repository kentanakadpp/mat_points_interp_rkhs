clear all;
close all;
dir_smp = './DataSmp/'; % Directory to save the data of the sampling points
dir_time = './DataTime/'; % Directory to save the data of the times

addpath('C:\Program Files\Mosek\8\toolbox\r2014a');

m = 250; % Number of candidates (250 for 2 <= n <= 17 in "Gaussian" case. The case n=18 cannot be done even if m=500.)

time_arr = [];
for n=15:15 % Numbers of sampling points (integers)
    l = n;
    
    display(strcat('Processing the case n=', num2str(n), '.....'));    
    
    %% Vectors of the sampled eigenfunctions
    tic;
    % Brownian kernel.
    prefix = 'Brown';
    x = linspace(0,1,m);
    a = [];
    for i=1:m
        [lam, tmp] = func_Brown_eigen([1:n], x(i)); 
        a = [a; tmp];
    end
    a = a';

    % Gaussian kernel.
%     prefix = 'Gauss';
%     eps = 1;
%     alp = 1;
%     x = linspace(-1,1,m);
%     a = [];
%     for i=1:m
%         [lam, tmp] = func_Gauss_eigen(eps, alp, [1:n], x(i)); 
%         a = [a; tmp];
%     end
%     a = a';
    
    time_vec = toc;

    %% Solving D-optimal design by SOCP.
    tic;
    [V, prob] = func_make_prob_Dopt_by_SOCP(l, m, n, a);
    time_make = toc;
    tic;
    [r, res] = mosekopt('maximize',prob); % MOSEK optimizer
    time_solve = toc;

    % The primal solution and weights.
    p_sol = res.sol.itr.xx';
    w = 2*p_sol(V-m+1:V);
    plot(x, w);

    %% Choosing sampling points
    idx_smpl = [];
    for i=1:m
       if(i==1)
           idx_neigh = [2];
       elseif(i==m) 
           idx_neigh = [m-1];
       else
           idx_neigh = [i-1, i+1];
       end

       if(prod(w(i) > w(idx_neigh)))
            idx_smpl = [idx_smpl, i];   
       end   
    end

    tmp_w_i = [w(idx_smpl)',idx_smpl'];
    tmp_w_i = sortrows(tmp_w_i, 'descend');
    if(length(tmp_w_i)>=n)
        % output and plot of the sampling points
        w_i = tmp_w_i(1:n,:);  % choosing the first n points
        smpl = sort(x(w_i(:,2)));
        display(smpl);    
        % output to a file
        filename = strcat(dir_smp, prefix ,'1D_smp','_n_', num2str(n), '.txt');
%        dlmwrite(filename, smpl');
    else
        display('The number of local maximums is less than n.');
    end
    
    display(time_vec);
    display(time_make);
    display(time_solve);
    time_arr = [time_arr; [n, time_vec, time_make, time_solve]];
end

filename = strcat(dir_time, prefix ,'1D_smp_times.txt');
% dlmwrite(filename, time_arr);
