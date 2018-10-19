function [lam, phi] = func_Gauss_eigen(eps, alp, n, x)
    bet = (1 + (2*eps/alp)^2)^(1/4);
    del2 = alp^2*(bet^2-1)/2; 
    den = alp^2 + del2 + eps^2;
    
    lam = sqrt(alp^2/den) * (eps^2/den).^(n-1); % eigenvalue
    
    gam = sqrt(2.^(1-n) .* bet./gamma(n));
    phi = gam .* exp(-del2 * x.^2) .* hermiteH(n-1, alp * bet * x); % eigenfunction
end
