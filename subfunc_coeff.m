function output = subfunc_coeff(l,k)
    if k == 0
        output = sqrt(2*l+1);
    elseif k < l+1
        output = sqrt(2*(2*l+1)*factorial(l-k)/factorial(l+k));
    else
        k = k - (l+1);
        output = sqrt(2*(2*l+1)*factorial(l-k)/factorial(l+k));
    end
end
