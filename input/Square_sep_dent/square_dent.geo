// L'unité de longueur est le millimètre

//=== VARIABLES ===//

// Amplitude du sinus à l'interface
h = 0.36;

// Hauteur totale
H = 1.5;

// Largeur totale
L = 0.9;

// Hauteur du tissu mou
W = h;

// Nombre de points composant la spline sinusoïdale
nSpline = 100;
//======//


//=== Extrémités du domaine ===//
Point(1) = {0,-H/2,0};
Point(2) = {L,-H/2,0};
Point(3) = {L,H/2,0};
Point(4) = {0,H/2,0};
//======//


//=== Points pour l'interface sinusoïdale ===//
placedBorder = 0;
xBorder = L/2 + L*Asin((h-W)/h)/Pi;

For i In {50:50+nSpline-1}

x = (i-50)*L/(nSpline-1);
    y = h * Sin(Pi*x/L-Pi/2);
    Point(i) = {x,y,0};

    //== On arrondit pour que le point de l'interface soit sur la Spline
    If ( x > xBorder && placedBorder==0)
       Point(6) = {L,y,0};
       Line(8) = {i,6};
       placedBorder = 1;
       iMax = i;
    EndIf
    
EndFor
//======//


// Frontières extérieure
Line(1) = {1,2};
Line(2) = {2,6};
Line(3) = {6,50+nSpline-1};
Line(4) = {50+nSpline-1,3};
Line(5) = {3,4};
Line(6) = {4,50};
Line(7) = {50,1};


// Interface Implant / Os 
Spline(9) = {50 ... iMax};

// Interface Implant / Tissu mou
Spline(10) = {iMax ... 50+nSpline-1};





//== IMPLANT ==//
Curve Loop(1) = {9,10,4,5,6};
Plane Surface(1) = {1};
Physical Surface(1) = {1};

//== TISSU MOU ==//
Curve Loop(2) = {3,-10,8};
Plane Surface(2) = {2};
Physical Surface(2) = {2};

//== OS ==//
Curve Loop(3) = {1,2,-8,-9,7};
Plane Surface(3) = {3};
Physical Surface(3) = {3};


Physical Curve(4) = {1};
Physical Curve(5) = {2};
Physical Curve(6) = {3};
Physical Curve(7) = {4};
Physical Curve(8) = {5};
Physical Curve(9) = {6};
Physical Curve(10) = {7};
Physical Curve(11) = {9};
Physical Curve(12) = {10};
Physical Curve(13) = {8};
