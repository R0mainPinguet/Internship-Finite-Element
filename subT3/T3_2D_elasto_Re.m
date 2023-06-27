
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% Elastodynamic gradient matrix
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

function Re=T3_2D_elasto_Re(X)
    
    %= Coordonnées des trois noeuds :
    %=   X1 = (x1,y1) // X2 = (x2,y2) // X3 = (x3,y3)
    x1=X(1,1); x2=X(2,1); x3=X(3,1);
    y1=X(1,2); y2=X(2,2); y3=X(3,2);

    %= Aire du triangle étudié
    S= .5*((x2-x1)*(y3-y1)-(x3-x1)*(y2-y1));

    if 1
        M1 = [(y2-y3)*(y2-y3) (y2-y3)*(y3-y1) (y2-y3)*(y1-y2);
              (y2-y3)*(y3-y1) (y3-y1)*(y3-y1) (y3-y1)*(y1-y2);
              (y2-y3)*(y1-y2) (y1-y2)*(y3-y1) (y1-y2)*(y1-y2)];

        M2 = [(x2-x3)*(x2-x3) (x2-x3)*(x3-x1) (x2-x3)*(x1-x2);
              (x2-x3)*(x3-x1) (x3-x1)*(x3-x1) (x3-x1)*(x1-x2);
              (x2-x3)*(x1-x2) (x1-x2)*(x3-x1) (x1-x2)*(x1-x2)];

        R11 = (M1+M2)/(4*S);
        
        Re = [R11 zeros(3);
              zeros(3) R11];
    else

        B = [y3-y1 y1-y2;
             x1-x3 x2-x1]/(2*S);
        
        grad_lambda_hat = [-1 1 0;
                           -1 0 1];

        R11 = zeros(3);
        for i=1:3
            for j=1:3
                R11(j,i) = grad_lambda_hat(:,j).' * B.' * B * grad_lambda_hat(:,i);
            end
        end

        Re = S * [R11 zeros(3);
                  zeros(3) R11];

    end
    
end
