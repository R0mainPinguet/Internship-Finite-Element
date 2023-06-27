
if ~(exist("mshfile")==1)
    
    %=== Default input file ===%
    mshfile='Square_sep_sinus_1.msh';
    %==========================%
    
    disp("Loading default file !");
    disp(mshfile);
    disp("######");
    
end

%= ANALYSIS TYPE
% 10 -> 2D_elasto
analysis.type = 10;

%=== MATERIAUX : Lambda, mu et rho*omega^2 ===%
if ~(exist("material")==1)
    material= [2 8 3;4 5 7];
    
    disp("Loading default materials !");

    for i_mat=1:length(material(:,1))
        disp("Material ("+num2str(i_mat)+") : lambda = "+num2str(material(i_mat,1))+" ; mu = "+num2str(material(i_mat,2)) +" ; rho * omega^2 = " + num2str(material(i_mat,3)));
    end
    disp("#####");
end
%==========================%

%=== SOLID: associates materials to sets ===%
% Here, if the fourth column of the gmsh elements ( the physical set ) is 1, the associated material is 1.
% If solid = [1 5;2 3], then the physical set 1 from gmsh is related to the fifth material, and the physical set 2 is related to the third material.
solid = [1 1;
         2 2];

%==========================%


%==== Choix de u exact et des conditions au bord
%=-- Poly4 -> (x-1)(x+1)(y-1)(y+1)(ex+ey)

if ~(exist("uex")==1)
    
    % Default u exact
    uex = "Poly4";
    
    disp("Loading default solution !");
    disp(uex);
    disp("######");
    
end

if uex=="Poly4"
    
    % Dirichlet Boundary Condition
    dbc = [3 1 "0";3 2 "0";
           4 1 "0";4 2 "0";
           5 1 "0";5 2 "0";
           6 1 "0";6 2 "0";
           7 1 "0";7 2 "0";
           8 1 "0";8 2 "0"];

    % Continuous Boundary Condition
    % Here, for example :
    %  - Continuous Boundary condition between the material 1 and material 2 : \sigma_2(u) - \sigma_1(u)
    cbc = [9 1 2 "(l2-l1)*2*(x*(y*y-1)+y*(x*x-1))*[1 0;0 1] + 2*(m2-m1)*[2*x*(y*y-1) x*(y*y-1)+y*(x*x-1);x*(y*y-1)+y*(x*x-1) 2*y*(x*x-1)]"];
    
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

