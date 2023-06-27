
Point(1) = {-1,-1,0};   // Point construction
Point(2) = {1,-1,0};
Point(3) = {1,1,0};
Point(4) = {-1,1,0};

Line(1) = {1,2};            //Lines
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,1};

Curve Loop(1) = {1,2,3,4};   // A Boundary

Plane Surface(1) = {1};     // A Surface

Physical Surface(1) = {1};  // Setting a label to the Surface//+
Physical Curve("2") = {4};
//+
Physical Curve("3") = {1};
//+
Physical Curve("4") = {2};
//+
Physical Curve("5") = {3};
