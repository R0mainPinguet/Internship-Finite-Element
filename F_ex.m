
function f = F_ex(x,y,t,mate,geo,onde_incidente,dir,uex)

    if uex=="Poly4_laplace1D" | uex=="Poly4_laplace2D"

        coeff_a = mate(1);
        coeff_b = mate(2);

        f = - 2*coeff_a*(x*x+y*y-2) + coeff_b*(x*x*y*y - x*x - y*y + 1) ;
        
    elseif uex=="Trigo_laplace1D"

        coeff_a = mate(1);
        coeff_b = mate(2);
        
        f = -sin(pi*x)*(coeff_b - coeff_a*pi*pi) - cos(pi*y)*(coeff_b - coeff_a*pi*pi);

    elseif uex=="Expo_laplace1D"
        
        coeff_a = mate(1);
        coeff_b = mate(2);
        
        f = - (coeff_b+coeff_a*(x*x+y*y) ) * (exp(x*y)+exp(-x*y) );

    elseif uex=="test_trigo"

        coeff_a = mate(1);

        if x<0
            f = coeff_a * pi * pi * ( sin(pi*x) + cos(pi*y) );
        else
            f = coeff_a * pi * pi * ( sin(pi*x/2)/4 + cos(pi*y) );
        end
        
    else
        
        lambda = mate(1);
        mu = mate(2);
        rho = mate(3);
        omega = onde_incidente(1);
        
        if uex=="Poly4" | uex=="Poly4_mixte_1" | uex=="Poly4_mixte_2" | uex=="Poly4_mixte_3" | uex=="Poly4_mixte_4" 
            
            if dir==1
                f = 2*y*y*(lambda+2*mu) + 4*x*y*(lambda+mu) + 2*mu*x*x - 2*(lambda+3*mu);
            else
                f = 2*x*x*(lambda+2*mu) + 4*x*y*(lambda+mu) + 2*mu*y*y - 2*(lambda+3*mu);
            end
            
            f = f + rho * omega^2 * (x-1)*(x+1)*(y-1)*(y+1);

        elseif uex=="Poly4_dent"

            H = geo(1);
            L = geo(2);

            if dir==1
                f = 2*(y*y-H*H/4)*(lambda+2*mu) + 2*mu*(x*x-L*x) + 2*(mu+lambda)*y*(2*x-L);
            else
                f = 2*(x*x-L*x)*(lambda+2*mu) + 2*mu*(y*y-H*H/4) + 2*(mu+lambda)*y*(2*x-L);
            end
            
            f = - f - rho * omega^2 * x*(L-x)*(H/2-y)*(y+H/2);

        elseif uex=="Dent_inconnue"

            f = 0;

        elseif uex=="Trigo_temporel"

            if dir==1
                f=0;
            else
                f = -rho*sin(t)*sin(y)/(y-3*H/2);
                f = f - (lambda+2*mu)*sin(t)*( -sin(y)*(y-3*H/2)^3 - (cos(y)*(y-3*H/2)-sin(y))*2*(y-3*H/2) )/((y-3*H/2)^4);
            end
                        
        elseif uex=="Trigo"
            
            if dir==1
                f =  -pi*pi*((lambda+2*mu)*sin(pi*x) + mu*cos(pi*y));
                f = f + rho * omega^2 * (sin(pi*x)+cos(pi*y));
            else
                f =  -pi*pi*((lambda+2*mu)*sin(pi*y) + mu*cos(pi*x));
                f = f + rho * omega^2 * (cos(pi*x)+sin(pi*y));
            end

        elseif uex=="Expo"

            if dir==1
                f = exp(x*y)*(lambda*y*y+2*mu*(y*y+x*x/2)) + exp(-x*y)*(lambda*(x*y-1)+mu*(x*y-1));
                f = f + rho * omega^2 * exp(x*y);
            else
                f = exp(-x*y)*(2*mu*(y*y/2+x*x)+lambda*x*x) + exp(x*y)*(mu*(1+x*y)+lambda*(1+x*y));
                f = f + rho * omega^2 * exp(-x*y);
            end
            
        elseif uex=="Poly2"

            if dir==1
                f = (lambda+mu);
            else
                f = -(lambda+mu);
            end
            
        elseif uex=="log"

            if dir==1
                f = - (lambda+2*mu)*2*(1-x*x)/((1+x*x)^2);
            else
                f = - (lambda+2*mu)*2*(1-y*y)/((1+y*y)^2);
            end
            
        elseif uex=="abs"

            if x>0
                if dir==1
                    f = -(lambda+2*mu);
                else
                    f = -mu;
                end    
            else
                if dir==1
                    f = (lambda+2*mu);
                else
                    f = mu;
                end
            end

        elseif uex=="Poly2_circle"

            f = - 2*(lambda+3*mu) + rhoOmegaCarre*(1-x*x-y*y);
            
        elseif uex=="testContinu"

            if dir==1
                f = -lambda;
            else
                f = 0;
            end

        elseif uex=="testContinu2"

            if dir==1
                f = (lambda+mu) * (y*y-x*x) + mu*(y*y+x*x);
            else
                f = (lambda+mu) * 2 * x *y + mu * (-2*x*y);
            end
            
        end
        
    end

    
end

