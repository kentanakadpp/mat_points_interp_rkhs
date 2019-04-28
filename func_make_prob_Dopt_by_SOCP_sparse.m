function [V, prob] = func_make_prob_Dopt_by_SOCP_sparse(l, m, n, a)

    p = ceil(log2(l)); 
    q = 2*(2^p-1); % Number of u's (1 copy for each)
    V = q + l + 3*m*l;

    [r, res] = mosekopt('symbcon'); % MOSEK

    % Specify the non-conic part of the problem.
    prob.c   = [1, zeros(1,V-1)];

    A = [];

    % A_1
    tmp_B = [];
    for i=1:q/2
        tmp_B = sparse([tmp_B; zeros(1,2*(i-1)), 1, -1, zeros(1,q-2*i)]);
    end
    tmp_B = sparse([tmp_B, zeros(q/2, V-q)]);
    A = sparse([A;tmp_B]);

    % A_2
    for i=1:(l-1)
        A = sparse([A; [zeros(m,V-m*l), zeros(m,m*(i-1)), eye(m,m), -eye(m,m), zeros(m,m*(l-i-1))]]);
    end
        
    % A_3
    for i=l:-1:1
        for j=1:i
            if j==1
                if (i==1) && (mod(l,2)==1)
                    A = sparse([A; [zeros(1,q),zeros(1,l-i),-2, zeros(1,i-1), zeros(1,m*(l-i)), a(l-i+1,:), zeros(1,m*(i-1)), zeros(1,2*m*l)]]);
                else
                    A = sparse([A; [zeros(1,q),zeros(1,l-i),-sqrt(2), zeros(1,i-1), zeros(1,m*(l-i)), a(l-i+1,:), zeros(1,m*(i-1)), zeros(1,2*m*l)]]);
                end
            else
                A = sparse([A; [zeros(1,q),zeros(1,l), zeros(1,m*(l-i+j-1)), a(l-i+1,:), zeros(1,m*(i-j)), zeros(1,2*m*l)]]);
            end
        end
    end

    % A_4
    A = sparse([A; [zeros(1,V-m), ones(1,m)]]);

    % A_5
    for i=l:-1:1
        if (i==1) && (mod(l,2)==1)
            A = sparse([A; [zeros(1,q), zeros(1,l-i),-2, zeros(1,i-1), zeros(1,m*l), zeros(1,m*(l-i)), ones(1,m), zeros(1,m*(i-1)), zeros(1,m*l)]]);
        else
            A = sparse([A; [zeros(1,q), zeros(1,l-i),-sqrt(2), zeros(1,i-1), zeros(1,m*l), zeros(1,m*(l-i)), ones(1,m), zeros(1,m*(i-1)), zeros(1,m*l)]]); 
        end
    end
     
    if mod(l,2)==0
        tmp_I = 2^(p-1)-l/2;
        tmp_J = 2^(p-1)+l/2;
    else
        tmp_I = 2^(p-1)-(l+1)/2;
        tmp_J = 2^(p-1)+(l+1)/2;
    end

    % A_6
    tmp_B = [];
    for i=1:tmp_I
        tmp_B = sparse([tmp_B; [-1,0,zeros(1,2*(tmp_J-2)), zeros(1,2*(i-1)), 1, 0 , zeros(1, 2*tmp_I-2*i), zeros(1, l+3*m*l)]]);
    end
    A = sparse([A; tmp_B]);
    
    prob.a   = sparse(A);

    prob.blc = [zeros(1,q/2), zeros(1,m*(l-1)), zeros(1,l*(l+1)/2), n/2, -inf*ones(1,l), -inf*ones(1,tmp_I)];
    prob.buc = [zeros(1,q/2), zeros(1,m*(l-1)), zeros(1,l*(l+1)/2), n/2, zeros(1,l), zeros(1,tmp_I)];

    prob.blx = [zeros(q+l,1); -inf*ones(m*l,1); zeros(2*m*l,1)];
    prob.bux = [inf*ones(V-m*l,1); (1/2)*ones(m*l,1)];

    % Specify the cones.
    prob.cones.type   = [ones(1, tmp_J-1+m*l)]; % 1 = res.symbcon.MSK_CT_RQUAD
    prob.cones.sub    = [];
    for i=1:(2^(p-1)-1)
        prob.cones.sub = [prob.cones.sub, 4*i+1, 4*i-1, 2*i];
    end
    for i=2^(p-1):(tmp_J-1)
        j=i-2^(p-1);
        if (i==tmp_J-1) && (mod(l,2)==1)
            prob.cones.sub = [prob.cones.sub, 1, q+2*j+1, 2*i];
        else
            prob.cones.sub = [prob.cones.sub, q+2*j+2, q+2*j+1, 2*i];
        end
    end

    for i=1:m*l
        prob.cones.sub = [prob.cones.sub, q+l+i+2*m*l, q+l+i+m*l, q+l+i];
    end
    prob.cones.subptr = [];
    for i=1:(tmp_J-1+m*l)
        prob.cones.subptr = [prob.cones.subptr, 1+3*(i-1)];
    end

end
