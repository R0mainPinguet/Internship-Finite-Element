

function Be=T3_2D_helmholtz_Be(X,mate,quadra,indexes_border,border_mate,border_bc)
    
    coeff_a = mate(1);
    coeff_b = mate(2);
    
    %= Coordonnées des trois noeuds :
    %=   X1 = (x1,y1) // X2 = (x2,y2) // X3 = (x3,y3)
    x1=X(1,1); x2=X(2,1); x3=X(3,1);
    y1=X(1,2); y2=X(2,2); y3=X(3,2);
    
    x123 = (x1+x2+x3)/3; y123 = (y1+y2+y3)/3;
    
    %= Aire du triangle étudié
    S = .5*((x2-x1)*(y3-y1)-(x3-x1)*(y2-y1));
    
    Be = zeros(3);
    
    if x123<0
        
        if length(indexes_border)==2
            x1b = X(indexes_border(1),1);y1b = X(indexes_border(1),2);
            x2b = X(indexes_border(2),1);y2b = X(indexes_border(2),2);
            
            L = sqrt( (x2b-x1b)^2 + (y2b-y1b)^2 );
            
            Be(indexes_border,indexes_border) = - L * coeff_a * [1 1;1 1] / 2 ;
        end
        
    else
        
        dphi_x = [y2-y3 y3-y1 y1-y2]/(2*S);
        dphi_y = [x3-x2 x1-x3 x2-x1]/(2*S);
        
        % for i=1:length(indexes_border)
        %     Be(indexes_border(i),:) = dphi_x;
        % end
        
        for i=1:length(indexes_border)        
            Be(indexes_border(i),indexes_border) = dphi_x(indexes_border);
        end

        
    end
       
    
end

    


