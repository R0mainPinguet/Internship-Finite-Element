
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% Elastodynamic gradient matrix
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

function Re=T3_2D_laplacien2D_Re(X)
    
    %= Coordonnées des trois noeuds :
    %=   X1 = (x1,y1) // X2 = (x2,y2) // X3 = (x3,y3)
    x1=X(1,1); x2=X(2,1); x3=X(3,1);
    y1=X(1,2); y2=X(2,2); y3=X(3,2);

    %= Aire du triangle étudié
    S= .5*((x2-x1)*(y3-y1)-(x3-x1)*(y2-y1));

    dphi_x = [y2-y3 y3-y1 y1-y2]/(2*S);
    dphi_y = [x3-x2 x1-x3 x2-x1]/(2*S);

    Ree = zeros(3);

    for i=1:3
        for j=1:3
            Ree(i,j) = S * (dphi_x(j)*dphi_x(i) + dphi_y(j)*dphi_y(i));
        end
    end

    % Re = [Ree zeros(3) zeros(3);
    %       zeros(3) Ree zeros(3);
    %       zeros(3) zeros(3) Ree];
 
    Re = [Ree zeros(3)
          zeros(3) Ree];        
end
