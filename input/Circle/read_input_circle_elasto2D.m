
if ~(exist("mshfile")==1)
    
    %=== Default input file ===%
    mshfile='Circle_2.msh';
    %==========================%
    
    disp("Loading default file !");
    disp(mshfile);
    disp("######");    
end

%=== MATERIAL: lambda,mu et rho*omega^2 ===%
material= [3 5 2];
%==========================%

%=== SOLID: associates materials to sets ===%
% Here, if the fourth column of the gmsh elements ( the physical set ) is 1, the associated material is 1.
% If solid = [1 5;2 3], then the physical set 1 from gmsh is related to the fifth material, and the physical set 2 is related to the third material.
solid = [1 1];
%==========================%

%= ANALYSIS TYPE
% 10 -> 2D_elasto
analysis.type=10;

%==== Choix de u exact et des conditions au bord
%=-- Poly2 -> (1-(x*x+y*y))(ex+ey)


if ~(exist("uex")==1)
    % Default u exact
    uex = "Poly2_circle";

    disp("Loading default solution !");
    disp(uex);
    disp("######");
    
end

if uex=="Poly2_circle"
    
    dbc= [2 1 "0";2 2 "0"];
    
end


%= DBC: each row a Displacement boundary condition :
%=   Physical set, direction, val
% For example, for dbc= [2 1 "0";2 2 "0"] : 2 boundary conditions :
%   On the physical set 2 -> u.x = 0 , u.y = 0

%== TBC: each row a Traction boundary condition :
%=   Physical set, direction, val
% For example here, 1 boundary conditions :
%   On the physical set 4 -> sigma(u).n = 0
%   ( by convention, a direction of 0 means the normal direction )

% tbc = [4 1 0;4 2 0];



%==== Choix de la quadrature T3

if ~(exist("quadrature_T3")==1)
    % Default T3 quadrature
    quadrature_T3 = "order_3";
    
    disp("Loading default T3 quadrature !");
    disp(quadrature_T3);
    disp("######");
end

%==== Choix de la quadrature B2

if ~(exist("quadrature_B2")==1)
    % Default B2 quadrature
    quadrature_B2 = "order_5";
        
    disp("Loading default B2 quadrature !");
    disp(quadrature_B2);
    disp("######");    
end

