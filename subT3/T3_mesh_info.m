
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% Triangle : info sur le maillage
%    - Taille du maillage h
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


%= Coordonnées des trois noeuds :
%=   X1 = (x1,y1) // X2 = (x2,y2) // X3 = (x3,y3)
x1=Xe(1,1); x2=Xe(2,1); x3=Xe(3,1);
y1=Xe(1,2); y2=Xe(2,2); y3=Xe(3,2);
    
%= Aire du triangle étudié
S= .5*((x2-x1)*(y3-y1)-(x3-x1)*(y2-y1));

%= Calcul du pas de maillage h à partir du rayon du cercle circonscrit
a = norm( Xe(1,:) - Xe(2,:) );
b = norm( Xe(1,:) - Xe(3,:) );
c = norm( Xe(2,:) - Xe(3,:) );

h = max( h , a*b*c/(4*S) );
