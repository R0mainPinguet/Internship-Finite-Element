
%= Hauteur, largeur de la zone d'étude, et géométrie du tissu mou =%
H = 1.5;
L = 0.9;
h = 0.36;
W = h;

geo = [H L];
%==%

%= Onde incidente =%
omega = 1;              % Pulsation
k_p_1 = 31.6228 / 5810; % Nombre d'ondes
U_I   = 1;              % Amplitude de l'onde P incidente

onde_incidente = [omega;
                  k_p_1;
                  U_I];
%==%

if ~(exist("mshfile")==1)
    
    %=== Default input file ===%
    mshfile='Square_sep_dent_4.msh';
    %==========================%
   
    disp("Loading default file !");
    disp(mshfile);
    disp("######");
    
end

%= ANALYSIS TYPE
% 10 -> 2D_elasto
analysis.type = 10;

%= ANALYSIS PROBLEM
%= 1 -> Fréquentiel : - \rho \omega^2 u - div( sigma(u) ) = f
%= 2 -> Temporel    : \rho \dfrac{\partial^2 u}{\partial t^2} - div( sigma(u) ) = f
analysis.problem = 1;

%= ANALYSIS SCHEME
%= Pour le problème temporel :
%= 1 -> Implicite : \rho \dfrac{ u^{n+1} - 2u^n + u^{n-1} }{\Delta t ^2} - div( sigma( u^{n+1} ) ) = f^{n+1}
%= 2 -> Explicite : \rho \dfrac{ u^{n+1} - 2u^n + u^{n-1} }{\Delta t ^2} - div( sigma( u^{n} ) ) = f^{n}
analysis.scheme = 1;


%=== MATERIAUX : Lambda, mu et rho ===%
if ~(exist("material")==1)

    % material = [235  42900 4.42;    % Implant
    %             2.25 1     1;       % Tissu Mou
    %             41.6 5990  1.85];   % Os

    material = [1 1 1;1 1 1;1 1 1]; 

    disp("Loading default materials !");
    disp("Material 1 (Implant) : lambda = "+num2str(material(1,1))+" GPa ; mu = "+num2str(material(1,2)) +" MPa ; rho = " + num2str(material(1,3))+" tonnes/m^3");
    disp("Material 2 (Tissu mou) : lambda = "+num2str(material(2,1))+" GPa ; mu = "+num2str(material(2,2)) +" MPa ; rho = " + num2str(material(2,3))+" tonnes/m^3");
    disp("Material 3 (Os) : lambda = "+num2str(material(3,1))+" GPa ; mu = "+num2str(material(3,2)) +" MPa ; rho = " + num2str(material(3,3))+" tonnes/m^3");
    disp("#####");
end
%==========================%

%=== SOLID: associates materials to sets ===%
% Here, if the fourth column of the gmsh elements ( the physical set ) is 1, the associated material is 1.
% If solid = [1 5;2 3], then the physical set 1 from gmsh is related to the fifth material, and the physical set 2 is related to the third material.
solid = [1 1;
         2 2;
         3 3];

%==========================%


%==== Choix de u exact et des conditions au bord

if ~(exist("uex")==1)
    
    % Default u exact
    uex = "Trigo_temporel";
    
    disp("Loading default solution !");
    disp(uex);
    disp("######");
    
end

if uex=="Poly4_dent"
    
    % Dirichlet Boundary Condition
    dbc = [4 1 "0" ; 4 2 "0";
           5 1 "0" ; 5 2 "0";
           6 1 "0" ; 6 2 "0";
           7 1 "0" ; 7 2 "0";
           8 1 "0" ; 8 2 "0";
           9 1 "0" ; 9 2 "0";
           10 1 "0";10 2 "0"];

    % Continuous Boundary Condition
    % Here, for example :
    %  - Continuous Boundary condition between the material 1 and material 2 : \sigma_2(u) - \sigma_1(u)
    %  - Continuous Boundary condition between the material 1 and material 3 : \sigma_2(u) - \sigma_1(u)
    %  - Continuous Boundary condition between the material 2 and material 3 : \sigma_2(u) - \sigma_1(u)

    cbc = [11 1 3 "(l2-l1)*((L-2*x)*(H*H/4-y*y)+(x*L-x*x)*(-2*y))*[1 0;0 1] + 2*(m2-m1)*[(L-2*x)*(H*H/4-y*y) (L/2-x)*(H*H/4-y*y)+(x*L-x*x)*(-y);(L/2-x)*(H*H/4-y*y)+(x*L-x*x)*(-y) (x*L-x*x)*(-2*y)]";
           12 1 2 "(l2-l1)*((L-2*x)*(H*H/4-y*y)+(x*L-x*x)*(-2*y))*[1 0;0 1] + 2*(m2-m1)*[(L-2*x)*(H*H/4-y*y) (L/2-x)*(H*H/4-y*y)+(x*L-x*x)*(-y);(L/2-x)*(H*H/4-y*y)+(x*L-x*x)*(-y) (x*L-x*x)*(-2*y)]";
           13 2 3 "(l2-l1)*((L-2*x)*(H*H/4-y*y)+(x*L-x*x)*(-2*y))*[1 0;0 1] + 2*(m2-m1)*[(L-2*x)*(H*H/4-y*y) (L/2-x)*(H*H/4-y*y)+(x*L-x*x)*(-y);(L/2-x)*(H*H/4-y*y)+(x*L-x*x)*(-y) (x*L-x*x)*(-2*y)]"];

elseif uex=="Dent_inconnue"

    % dbc = [4 1 "0" ; 4 2 "0";
    %        5 1 "0" ; 5 2 "0";
    %        6 1 "0" ; 6 2 "0";
    %        7 1 "0" ; 7 2 "U_I*exp(j * k_p_1 * y)";
    %        8 1 "0" ; 8 2 "U_I*exp(j * k_p_1 * H/2)";
    %        9 1 "0" ; 9 2 "U_I*exp(j * k_p_1 * y)";
    %        10 1 "0";10 2 "0"];
    
    % Dirichlet Boundary Condition
    dbc = [4 1 "0" ; 4 2 "0";
           5 1 "0" ; 5 2 "0";
           6 1 "0" ; 6 2 "0";
           7 1 "0" ; 7 2 "0";
           8 1 "0" ; 8 2 "0";
           9 1 "0" ; 9 2 "0";
           10 1 "0";10 2 "0"];
    
    % Continuité de la traction
    cbc = [11 1 3 "0";
           12 1 2 "0";
           13 2 3 "0"];           

elseif uex=="Trigo_temporel"

    % Dirichlet Boundary Condition
    dbc = [4 1 "0" ; 4 2 "sin(t)*sin(y)/(y-3H/2)";
           5 1 "0" ; 5 2 "sin(t)*sin(y)/(y-3H/2)";
           6 1 "0" ; 6 2 "sin(t)*sin(y)/(y-3H/2)";
           7 1 "0" ; 7 2 "sin(t)*sin(y)/(y-3H/2)";
           8 1 "0" ; 8 2 "sin(t)*sin(y)/(y-3H/2)";
           9 1 "0" ; 9 2 "sin(t)*sin(y)/(y-3H/2)";
           10 1 "0";10 2 "sin(t)*sin(y)/(y-3H/2)"];

    % Continuité de la traction
    cbc = [11 1 3 "( sin(t)*( cos(y)*(y-3*H/2) - sin(y) )/( (y-3*H/2)^2 )*[l2-l1 0;0 l2-l1+2*(m2-m1)]";
           12 1 2 "( sin(t)*( cos(y)*(y-3*H/2) - sin(y) )/( (y-3*H/2)^2 )*[l2-l1 0;0 l2-l1+2*(m2-m1)]";
           13 2 3 "( sin(t)*( cos(y)*(y-3*H/2) - sin(y) )/( (y-3*H/2)^2 )*[l2-l1 0;0 l2-l1+2*(m2-m1)]"];           

    
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

