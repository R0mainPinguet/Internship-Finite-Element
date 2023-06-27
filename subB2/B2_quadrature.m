%= B2 Quadrature on the reference segment (0,0) - (1,0) =%

%= Gauss Legendre quadrature
function res = B2_quadrature(f,type)
    
    if type=="order_1"

        x0 = 1/2.;
        
        res = f(x0);
        
    elseif type=="order_3"

        x0 = 1/2. - 1/(2.*sqrt(3.));
        x1 = 1/2. + 1/(2.*sqrt(3.));
        
        res = ( f(x0) + f(x1) )/2. ;

    elseif type=="order_5"

        x0 = 1/2.;
        x1 = 1/2. - sqrt(3./5.)/2.;
        x2 = 1/2. + sqrt(3./5.)/2.;

        res = ( 4*f(x0) + 2.5*f(x1)+2.5*f(x2) ) / 9.;
        
    end
    

end

