clear all;
close all;
dir_smp = './DataSmpSeq/'; % Directory to save the data of the sampling points

addpath('C:\Program Files\Mosek\8\toolbox\r2014a');

n_arr = [8, 12, 16, 20, 24, 28, 32, 35]; % Array of the number of sampling points (integers)

w_fix_idx = [];
for n_idx = 1:length(n_arr)
    n = n_arr(n_idx);
    l = n; % l = n
    
    display(strcat('Processing the case n=', num2str(n), '.....'));

    %% 2D Sphere and candidate points
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
    x = sin(theta) .* cos(phi);
    y = sin(theta) .* sin(phi);
    z = cos(theta);

    %% Vectors of the sampled eigenfunctions
    tic;
    % Spherical inverse multiquadratics
    n_p = ceil(sqrt(2*n));
    a = [];
    for i=1:m
        ii = idx(i);
        count = 0;
        tmp = [];
        for r=0:n_p % r starts from zero.
            for s=1:(2*r+1)
                if(count >= n)
                    break;
                end
                tmp = [tmp, func_SpherHarm2D(r,s, theta(ii), phi(ii))]; 
                count = count+1;
            end
        end
        a = [a; tmp];
    end
    a = a';
    toc;

    %% Solving D-optimal design by SOCP.
    tic;
    [V, prob] = func_make_prob_Dopt_by_SOCP_wfix(l, m, n, a, w_fix_idx);
    toc;
    tic;
    [r, res] = mosekopt('maximize',prob); % MOSEK optimizer
    toc;

    % The primal solution and weights.
    p_sol = res.sol.itr.xx';
    w = 2*p_sol(V-m+1:V);

%     display(w);
%     hold off;
%     stem3(theta,phi,w,'filled');
%     title('weight (3D)');
%     xlim([0,pi]);
%     ylim([0,2*pi]);
% 
%     pause;

    %% Choosing sampling points
    w_p = [w(1)*ones(1,k-1), w(2:m-1), w(m)*ones(1,k-1)];
    idx_smpl = [];
    frst = 0;
    last = 0;
    for i=1:length(w_p)
        if(i <= k-1)
            idx_neigh = [k:2*(k-1)];
        elseif(i >= k*(k-1)-(k-2)) 
            idx_neigh = [(k-1)^2-(k-2):(k-1)^2];
        elseif(mod(i,k)==0)
            idx_neigh = [i-(k-1), i+(k-1), i-1, i-(k-2)];
        elseif(mod(i,k)==1)
            idx_neigh = [i-(k-1), i+(k-1), i+1, i+(k-2)];
        else
            idx_neigh = [i-(k-1), i+(k-1), i-1, i+1];
        end

        if(prod(w_p(i) > w_p(idx_neigh)))
            if((i <= k-1)&&(frst == 0))
                idx_smpl = [idx_smpl, 1];
                frst = 1;
            elseif((i >= k*(k-1)-(k-2))&&(last == 0)) 
                idx_smpl = [idx_smpl, (k-2)*(k-1)+2];
                last = 1;
            elseif((i > k-1)&&(i < k*(k-1)-(k-2)))
                idx_smpl = [idx_smpl, i-(k-2)];
            end
        end   
    end
    tmp_w_i = [w(idx_smpl)',idx_smpl'];
    tmp_w_i = sortrows(tmp_w_i, 'descend');

    % plot of all the local maxima
    [xx,yy,zz] = sphere;
    surf(xx,yy,zz,'FaceAlpha',0.1);
    hold on;
%     tmp_smpl = [x(idx(tmp_w_i(:,2))); y(idx(tmp_w_i(:,2))); z(idx(tmp_w_i(:,2)))];
%     scatter3(tmp_smpl(1,:), tmp_smpl(2,:), tmp_smpl(3,:), 'filled');
%     xlim([-1,1]);
%     ylim([-1,1]);
%     zlim([-1,1]);
% 
%     pause;

    if(length(tmp_w_i)>=n)
        % output and plot of the sampling points
        w_i = tmp_w_i(1:n,:); % choosing the first n points
        w_fix_idx = w_i(:,2); % storing the indices of the weights that are fixed in the next iteration.
        smpl = [x(idx(w_fix_idx))', y(idx(w_fix_idx))', z(idx(w_fix_idx))'];
        display(smpl);
        scatter3(smpl(:,1), smpl(:,2), smpl(:,3), 'filled');
        xlim([-1,1]);
        ylim([-1,1]);
        zlim([-1,1]);
        % output to a file
        filename = strcat(dir_smp,'sphere_smp_seq_n_', num2str(n), '.txt');
%         dlmwrite(filename, smpl);
    else
        display('The number of local maximums is less than n.');
    end
    
%     pause;

    hold off;
end
