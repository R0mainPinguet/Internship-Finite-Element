

function u=U_ex(x,y,geo,dir,uex)

    if uex=="Poly4" | uex=="Poly4_mixte_1" | uex=="Poly4_mixte_2" | uex=="Poly4_mixte_3" | uex=="Poly4_mixte_4" | uex=="Poly4_laplace1D" | uex=="Poly4_laplace2D"
        
        u = (x-1)*(x+1)*(y-1)*(y+1);
        
    elseif uex=="Poly4_dent"

        H = geo(1);
        L = geo(2);
        
        u = x*(L-x)*(H/2-y)*(y+H/2);

    elseif uex=="Dent_inconnue"

        u = 0;

    elseif uex=="Trigo_temporel"

        if dir==1
            u = 0;
        else
            u = sin(t)*sin(y)/(y-3*H/2);
        end
        
    elseif uex=="Trigo_laplace1D"

        u = sin(pi*x) + cos(pi*y);

    elseif uex=="Expo_laplace1D"

        u = exp(x*y)+exp(-x*y);
        
    elseif uex=="Trigo"

        if dir==1
            u=sin(pi*x)+cos(pi*y);
        else
            u=cos(pi*x)+sin(pi*y);
        end
        
    elseif uex=="Expo"

        if dir==1
            u = exp(x*y);
        else
            u = exp(-x*y);
        end
        
    elseif uex=="Poly2"

        if dir==1
            u = x*y;
        else
            u = -x*y;
        end
        
    elseif uex=="log"

        if dir==1
            u = log(1+x*x);
        else
            u = log(1+y*y);
        end
        
    elseif uex=="abs"

        if x>0
            u = x*x/2;
        else
            u = -x*x/2;
        end

    elseif uex=="Poly2_circle"

        u = 1-(x*x+y*y);

    elseif uex=="testContinu"

        if dir==1
            u = y*y/2;
        else
            u = -x*y;
        end

    elseif uex=="testContinu2"

        if dir==1
            u = x*x*y*y/2;
        else
            u = -x*x*x*y/3;
        end

    elseif uex=="test_trigo"

        if x<0
            u = sin(pi*x)+cos(pi*y);
        else
            u = sin(pi*x/2)+cos(pi*y);
        end
        
    end
    
end

