function [lam, phi] = func_Brown_eigen(n, x)
    lam = 4./((2*n-1)*pi).^2; % eigenvalue    
    phi = sqrt(2)*sin((2*n-1)*pi*x./2); % eigenfunction
end
