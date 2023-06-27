
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% 2D scalar Laplace : Termes de frontière
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

% X -> Coordonnées du triangle
% mate -> Matériau à l'intérieur du triangle
% quadra -> Quadrature à utiliser pour calculer les intégrales sur le triangle
% indexes -> Indexs locaux des sommets présents sur la frontière ( [] si pas de bords en commun )
% materials -> Matériaux ( lambda et mu ) des éléments présents à gauche et à droite de la frontière

function frontiere = B2_2D_laplace1D_frontiere(X,quadra,left_mat,right_mat,jump_func)

    a_1 = left_mat(1);
    a_2 = right_mat(1);
    
    x1 = X(1,1) ; x2 = X(2,1);
    y1 = X(1,2) ; y2 = X(2,2);

    x12 = (x1+x2)/2.;
    y12 = (y1+y2)/2.;

    % Longueur de la frontière
    L = sqrt( (x1-x2)^2 + (y1-y2)^2 );

    lambda1 = @(u) 1-u;
    lambda2 = @(u) u;

    % <!> ATTENTION <!>
    % La normale extérieure est définie à partir de l'orientation de la frontière, qui vient en premier lieu du fichier .geo
    n = [y2-y1;x1-x2];
    n = n/norm(n);
    % Normale extérieure au premier domaine : rotation de 90° dans le sens horaire        
    frontiere = - L * [ B2_quadrature( @(u) g(u) * n * lambda1(u) , quadra);
                        B2_quadrature( @(u) g(u) * n * lambda2(u) , quadra)];
                       
    function res = g(u)
        x = x1+u*(x2-x1);
        y = y1+u*(y2-y1);
    
        res = eval(jump_func);
        
    end
    
end

