
Point(1) = {-1,-1,0};   // Point construction
Point(2) = {1,-1,0};
Point(3) = {1,1,0};
Point(4) = {-1,1,0};
Point(5) = {-1,-0.414,0};
Point(6) = {1,0.414,0};
Point(7) = {0,0,0};

Line(1) = {1,2};            //Lines
Line(2) = {2,6};
Line(3) = {6,3};
Line(4) = {3,4};
Line(5) = {4,5};
Line(6) = {5,1};
Circle(7) = {5,4,7};
Circle(8) = {7,2,6};


Curve Loop(1) = {7,8,3,4,5};
Curve Loop(2) = {1,2,-8,-7,6};   // A Boundary


Plane Surface(1) = {1};     // A Surface
Plane Surface(2) = {2};

Physical Surface(1) = {1};  // Setting a label to the Surface//+
Physical Surface(2) = {2};

// Bord gauche
Physical Curve(3) = {5};
Physical Curve(4) = {6};

// Bord bas
Physical Curve(5) = {1};

// Bord droit
Physical Curve(6) = {2};
Physical Curve(7) = {3};

// Bord haut
Physical Curve(8) = {4};

// Frontière sinusoïdale
Physical Curve(9) = {7,8};