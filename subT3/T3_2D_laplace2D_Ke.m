%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

% X -> Coordonnées du triangle
% mate -> Matériau à l'intérieur du triangle
% quadra -> Quadrature à utiliser pour calculer les intégrales sur le triangle

function Ke=T3_2D_laplacien2D_Ke(X,mate,quadra)

    coeff_a = mate(1);
    coeff_b = mate(2);
    
    %= Coordonnées des trois noeuds :
    %=   X1 = (x1,y1) // X2 = (x2,y2) // X3 = (x3,y3)
    x1=X(1,1); x2=X(2,1); x3=X(3,1);
    y1=X(1,2); y2=X(2,2); y3=X(3,2);

    x123 = (x1+x2+x3)/3.;
    y123 = (y1+y2+y3)/3.;
    
    %= Aire du triangle étudié
    S = .5*((x2-x1)*(y3-y1)-(x3-x1)*(y2-y1));

    dphi_x = [y2-y3 y3-y1 y1-y2]/(2*S);
    dphi_y = [x3-x2 x1-x3 x2-x1]/(2*S);
    
    Ke = zeros(6);

    K11 = zeros(3);

    for i=1:3
        for j=1:3
            K11(j,i) = coeff_a * S * (dphi_x(i) * dphi_x(j) + dphi_y(i) * dphi_y(j) );
        end
    end

    K11 = K11 + coeff_b * 2*S* [2 1 1;1 2 1;1 1 2]/24;

    Ke = [K11 zeros(3)
          zeros(3) K11];         
    
    
end

