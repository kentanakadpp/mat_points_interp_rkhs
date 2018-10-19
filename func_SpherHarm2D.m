function  output = func_SpherHarm2D(l,k,theta,phi)
    if k < l+1
        k = (l+1) - k;
        output = subfunc_coeff(l,k) * subfunc_assLegendre(l,k,cos(theta)) * sin(k*phi);
    elseif k == l+1
        output = subfunc_coeff(l,0) * subfunc_assLegendre(l,0,cos(theta));
    else
        k = k - (l+1);
        output = subfunc_coeff(l,k) * subfunc_assLegendre(l,k,cos(theta)) * cos(k*phi);
    end
end
