
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% Elastodynamic mass matrix: T3
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

function Me=T3_2D_laplacien2D_Me(X)

    %= Coordonnées des trois noeuds :
    %=   X1 = (x1,y1) // X2 = (x2,y2) // X3 = (x3,y3)
    x1=X(1,1); x2=X(2,1); x3=X(3,1);
    y1=X(1,2); y2=X(2,2); y3=X(3,2);

    %= Aire du triangle étudié
    S = .5*((x2-x1)*(y3-y1)-(x3-x1)*(y2-y1));

    %= https://bthierry.pages.math.cnrs.fr/course-fem/lecture/elements-finis-triangulaires/contributions-elementaires/ =%
    elem_K_hat = [2 1 1
                  1 2 1
                  1 1 2]/24;

    Me = 2 * S * [elem_K_hat zeros(3)
                  zeros(3) elem_K_hat];
    
end
