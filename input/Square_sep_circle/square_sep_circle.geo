
Point(1) = {-1,-1,0};   // Point construction
Point(2) = {1,-1,0};
Point(3) = {1,1,0};
Point(4) = {-1,1,0};
Point(5) = {0,0,0};
Point(6) = {-0.5,0,0};
Point(7) = {0.5,0,0};

Line(1) = {1,2};            //Lines
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,1};
Circle(5) = {6,5,7};
Circle(6) = {7,5,6};


Curve Loop(1) = {1,2,3,4};   // A Boundary
Curve Loop(2) = {-5,-6};

Plane Surface(1) = {1,2};     // A Surface
Plane Surface(2) = {-2};

Physical Surface(1) = {1};  // Setting a label to the Surface//+
Physical Surface(2) = {2};

Physical Curve(3) = {4};

Physical Curve(4) = {1};

Physical Curve(5) = {2};

Physical Curve(6) = {3};

Physical Curve(7) = {5,6};