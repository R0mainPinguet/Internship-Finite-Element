

function Be=T3_2D_elasto_Be(X,mate,quadra,indexes_border,border_mate,border_bc)

    lambda = mate(1);
    mu = mate(2);
    
    %= Coordonnées des trois noeuds :
    %=   X1 = (x1,y1) // X2 = (x2,y2) // X3 = (x3,y3)
    x1=X(1,1); x2=X(2,1); x3=X(3,1);
    y1=X(1,2); y2=X(2,2); y3=X(3,2);

    x123 = (x1+x2+x3)/3; y123 = (y1+y2+y3)/3;
    
    %= Aire du triangle étudié
    S = .5*((x2-x1)*(y3-y1)-(x3-x1)*(y2-y1));

    dphi_x = [y2-y3 y3-y1 y1-y2]/(2*S);
    dphi_y = [x3-x2 x1-x3 x2-x1]/(2*S);
    
    Be = zeros(6);
    
    if length(indexes_border)==2

        x1b = X(indexes_border(1),1);y1b = X(indexes_border(1),2);
        x2b = X(indexes_border(2),1);y2b = X(indexes_border(2),2);

        L = sqrt( (x2b-x1b)^2 + (y2b-y1b)^2 );

        B11 = zeros(3); B12 = zeros(3); B21 = zeros(3); B22 = zeros(3);

        % FRONTIERE VERTICALE
        if 1

            if x123<0
                
                %= Neumann à droite
                for i=1:2
                    B11(indexes_border(i),:) = (lambda+2*mu)*dphi_x;
                    B12(indexes_border(i),:) =    lambda    *dphi_y;
                    B21(indexes_border(i),:) =      mu      *dphi_y;
                    B22(indexes_border(i),:) =      mu      *dphi_x;
                end
                
                Be = L*[B11 B12;
                        B21 B22]/2;
                
            else
                
                %= Neumann à gauche
                for i=1:2
                    B11(indexes_border(i),:) = (lambda+2*mu)*dphi_x;
                    B12(indexes_border(i),:) =    lambda    *dphi_y;
                    B21(indexes_border(i),:) =      mu      *dphi_y;
                    B22(indexes_border(i),:) =      mu      *dphi_x;
                end
                
                Be = -L*[B11 B12;
                          B21 B22]/2;
                
            end

        else
            
            disp("A IMPLEMENTER");            
            
        end
        
    end

    
end

