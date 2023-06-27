
Point(1) = {-1,-1,0};   // Point construction
Point(2) = {1,-1,0};
Point(3) = {1,1,0};
Point(4) = {-1,1,0};
Point(5) = {0,-1,0};
Point(6) = {0,1,0};

Line(1) = {1,5};            //Lines
Line(2) = {5,2};
Line(3) = {2,3};
Line(4) = {3,6};
Line(5) = {6,4};
Line(6) = {4,1};
Line(7) = {5,6};

Curve Loop(1) = {1,7,5,6};   // A Boundary
Curve Loop(2) = {2,3,4,-7};

Plane Surface(1) = {1};     // A Surface
Plane Surface(2) = {2};

Physical Surface(1) = {1};  // Setting a label to the Surface//+
Physical Surface(2) = {2};

Physical Curve(3) = {6};

Physical Curve(4) = {1,2};

Physical Curve(5) = {3};

Physical Curve(6) = {4,5};

Physical Curve(7) = {7};