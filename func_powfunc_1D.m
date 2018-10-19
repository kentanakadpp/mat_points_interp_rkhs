function y = func_powfunc_1D(x, n, a, K)

    matK = zeros(n,n);
    for i=1:n
        for j=1:n
            matK(i,j) = K(a(i), a(j));
        end
    end
    
    l = length(a);
    u = zeros(l, 1);
    for i=1:l
        u(i) = K(x, a(i));
    end
        
    y = sqrt(abs(K(x,x) - u'*(matK\u)));
    
end
