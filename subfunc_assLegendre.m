function output = subfunc_assLegendre(l,k,x)
    P = legendre(l,x);
    if k > l
        output = 0;
    elseif k >= 0
        output = P(k+1);
    else
    	k = -k;
        output = (-1)^k * factorial(l-k)/factorial(l+k) * P(k+1);
    end
end
