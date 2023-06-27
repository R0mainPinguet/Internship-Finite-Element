% Cette fonction calcule les forces nodales associees au chargement p passe
% en argument. Elle retrourne Fe, un vecteur Fe (2x1) de longueur ddl*noeuds 
% contenant les contributions de l'element a chauqe noeud n1 et n2, projete
% sur chaque ddl (1 seul ddl par noeud en fluide car equations scalaires).


function Fe=B2_2A_fluid_Fe_surf(p,Xe,e1,e2,parametres,elements_frontiere,tn)
psi1=@(x)(1+x)/2; psi2=@(x)(1-x)/2;
x11=Xe(1,1); x12=Xe(1,2);                      % first node
x21=Xe(2,1); x22=Xe(2,2);                      % second node
H=sqrt((x21-x11)^2+(x22-x12)^2);             % element length
Poids=parametres.Poids; 
Points=parametres.Points;  % points de Gauss

% ASSEMBLAGE
V=[p(e1,tn);p(e2,tn)]; 
somme=(H/2)*diag(Poids)*[psi1(Points.'),psi2(Points.')]*V;
Fe=[sum(diag(psi1(Points))*somme);sum(diag(psi2(Points))*somme)];

end

% ASSEMBLAGE
%chargement_xy=p(e,tn);
%if e==E
%    chargement_x2y2=p(1,tn);
%else
%    chargement_x2y2=p(e+1,tn);
%end
%V=[chargement_xy;chargement_x2y2]; 
%somme=(H/2)*diag(Poids)*[psi1(Points.'),psi2(Points.')]*V;
%Fe=[sum(diag(psi1(Points))*somme);sum(diag(psi2(Points))*somme)];
