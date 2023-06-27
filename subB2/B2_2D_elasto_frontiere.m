
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% Elastodynamic terme de frontiere : T3
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

% X -> Coordonnées du triangle
% mate -> Matériau à l'intérieur du triangle
% quadra -> Quadrature à utiliser pour calculer les intégrales sur le triangle
% indexes -> Indexs locaux des sommets présents sur la frontière ( [] si pas de bords en commun )
% materials -> Matériaux ( lambda et mu ) des éléments présents à gauche et à droite de la frontière

function frontiere = B2_2D_elasto_frontiere(Xe,quadra,geo,left_mat,right_mat,jump_func)

    H = geo(1);
    L = geo(2);
    
    l1 = left_mat(1)  ; m1 = left_mat(2)  ;
    l2 = right_mat(1) ; m2 = right_mat(2) ;    
    
    x1 = Xe(1,1); x2 = Xe(2,1);
    y1 = Xe(1,2); y2 = Xe(2,2);

    x12 = (x1+x2)/2.;
    y12 = (y1+y2)/2.;

    % Longueur de la frontière
    longueur = sqrt( (x1-x2)^2 + (y1-y2)^2 );

    phi1 = @(u) 1-u;
    phi2 = @(u) u;

    % <!> ATTENTION <!>
    % La normale extérieure est définie à partir de l'orientation de la frontière, qui vient en premier lieu du fichier .geo
    n = [y2-y1;x1-x2];
    n = n/norm(n);
    % Normale extérieure au premier domaine : rotation de 90° dans le sens horaire
    
    frontiere = longueur * [ B2_quadrature( @(u) ([phi1(u) 0] * (g(u) * n)) , quadra);
                             B2_quadrature( @(u) ([phi2(u) 0] * (g(u) * n)) , quadra);
                             B2_quadrature( @(u) ([0 phi1(u)] * (g(u) * n)) , quadra);
                             B2_quadrature( @(u) ([0 phi2(u)] * (g(u) * n)) , quadra)];
    
    function res = g(u)
        x = x1 + u*(x2-x1);
        y = y1 + u*(y2-y1);
        
        res = eval(jump_func);
        
    end
    
end

