
Point(1) = {-1,-1,0};   // Point construction
Point(2) = {1,-1,0};
Point(3) = {1,1,0};
Point(4) = {-1,1,0};
Point(5) = {1,0,0};
Point(6) = {0,0,0};

Line(1) = {1,2};            //Lines
Line(2) = {2,5};
Line(3) = {5,3};
Line(4) = {3,4};
Line(5) = {4,1};
Line(6) = {1,6};
Line(7) = {4,6};
Line(8) = {6,5};

Curve Loop(1) = {5,6,-7};
Curve Loop(2) = {3,4,7,8};
Curve Loop(3) = {1,2,-8,-6};   // A Boundary

Plane Surface(1) = {1};     // A Surface
Plane Surface(2) = {2};
Plane Surface(3) = {3};

Physical Surface(1) = {1};  // Setting a label to the Surface
Physical Surface(2) = {2};
Physical Surface(3) = {3};

Physical Curve(4) = {5};
Physical Curve(5) = {1};
Physical Curve(6) = {2};
Physical Curve(7) = {3};
Physical Curve(8) = {4};
Physical Curve(9) = {7};
Physical Curve(10) = {6};
Physical Curve(11) = {8};