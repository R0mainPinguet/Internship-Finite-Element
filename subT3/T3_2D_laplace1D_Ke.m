%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%% GRAD u . GRAD v : T3
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

% X -> Coordonnées du triangle
% mate -> Matériau à l'intérieur du triangle
% quadra -> Quadrature à utiliser pour calculer les intégrales sur le triangle

function Ke = T3_2D_laplace1D_Ke(X,mate,quadra)

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

    Ke = zeros(3);

    for i=1:3
        for j=1:3
            Ke(i,j) = S * ( dphi_x(j)*dphi_x(i) + dphi_y(j)*dphi_y(i) );
        end
    end

    Ke = coeff_a * Ke;


    %= CA MARCHE =%
    % %= Dirichlet à droite
    % if x123>0
    %     for i=1:length(indexes_border)
    %         Ke(indexes_border(i),:) = zeros(1,3);
    %     end
    % end
    
    % if length(indexes_border)==2

    %     x1b = X(indexes_border(1),1) ; y1b = X(indexes_border(1),2);
    %     x2b = X(indexes_border(2),1) ; y2b = X(indexes_border(2),2);
    
    %     L = sqrt( (x2b-x1b)^2 + (y2b-y1b)^2 );

    %     %= Neumann à gauche
    %     if x123>0
    %         Ke(indexes_border(1),:) = Ke(indexes_border(1),:) - border_mate(2,1) * L * dphi_x / 2 ;
    %         Ke(indexes_border(2),:) = Ke(indexes_border(2),:) - border_mate(2,1) * L * dphi_x / 2 ;
    %     end
    
    % end
    
    Ke = Ke + coeff_b * S * [2 1 1;
                             1 2 1;
                             1 1 2]/12;

end

