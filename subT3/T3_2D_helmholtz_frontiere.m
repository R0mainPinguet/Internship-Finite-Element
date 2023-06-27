

function frontiere=T3_2D_helmholtz_frontiere(X,mate,quadra,indexes_border,border_mate,border_bc)

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
    
    % frontiere = zeros(1,3);
    % for i=1:length(indexes_border)
    %     frontiere(indexes_border(i)) = dphi_x(indexes_border(i));
    % end

    frontiere = dphi_x/2;
    
    
    
end
