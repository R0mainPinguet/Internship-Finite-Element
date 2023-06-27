
if ~(exist("mshfile")==1)
    
    %=== Default input file ===%
    mshfile='Square_sep_vert_1.msh';
    %==========================%
    
    disp("Loading default file !");
    disp(mshfile);
    disp("######");
    
end

%= ANALYSIS TYPE
% 11 -> Laplacien 1D : - div(a \GRAD u) + b u = f
analysis.type = 11;

%=== MATERIAUX : Lambda et mu ===%
if ~(exist("material")==1)
    material= [1 0;2 0];
    
    disp("Loading default materials !");
    
    for i_mat=1:length(material(:,1))
        disp("Material ("+num2str(i_mat)+") : coeff_a = "+num2str(material(i_mat,1)) +" - coeff_b = "+num2str(material(i_mat,2)));
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
    uex = "Trigo_laplace1D";
    
    disp("Loading default solution !");
    disp(uex);
    disp("######");
    
end

if uex=="Poly4_laplace1D"

    % Dirichlet Boundary Condition
    dbc = [3 1 "0";
           4 1 "0";
           5 1 "0";
           6 1 "0";
           7 1 "0";
           8 1 "0"];

    % Continuous Boundary Condition
    % Here, for example :
    %  - Continuity jump between the material 1 and material 2 : 0
    cbc = [9 1 2 "0"];

elseif uex=="Trigo_laplace1D"

    % Dirichlet Boundary Condition
    dbc = [3 1 "cos(pi*y)";
           4 1 "sin(pi*x)-1";
           5 1 "sin(pi*x)-1";
           6 1 "cos(pi*y)";
           7 1 "sin(pi*x)-1";
           8 1 "sin(pi*x)-1"];

    % Continuous Boundary Condition
    % Here, for example :
    %  - Continuity jump between the material 1 and material 2 : (a_2 - a_1) * pi * [ cos(pi x) ; - sin(pi y) ]
    cbc = [9 1 2 "(a_2-a_1)*pi*[cos(pi*x) -sin(pi*y)]"];

elseif uex=="Expo_laplace1D"

    % Dirichlet Boundary Condition
    dbc = [3 1 "exp(y)+exp(-y)";
           4 1 "exp(x)+exp(-x)";
           5 1 "exp(x)+exp(-x)";
           6 1 "exp(y)+exp(-y)";
           7 1 "exp(x)+exp(-x)";
           8 1 "exp(x)+exp(-x)"];

    % Continuous Boundary Condition
    % Here, for example :
    %  - Continuity jump between the material 1 and material 2 : 0
    cbc = [9 1 2 "0"];

elseif uex=="test_trigo"

    % Dirichlet Boundary Condition
    dbc = [3 1 "cos(pi*y)";
           4 1 "sin(pi*x)-1";
           5 1 "sin(pi*x/2)-1";
           6 1 "1+cos(pi*y)";
           7 1 "sin(pi*x/2)-1";
           8 1 "sin(pi*x)-1"];

    % Continuous Boundary Condition
    % Here, for example :
    %  - Continuous Boundary condition between the material 1 and material 2
    cbc = [9 1 2 "[0 0;0 0]"];
        
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

