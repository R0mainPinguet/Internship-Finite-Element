Point(1) = {0,0,0};
Point(2) = {0,1,0};
Point(3) = {0,-1,0};

Circle(1) = {2 , 1 , 3};
Circle(2) = {3 , 1 , 2};
Line(3) = {3,1};
Line(4) = {1,2}; 

Curve Loop(1) = {1,3,4};
Curve Loop(2) = {2,-4,-3};

Plane Surface(1) = {1};
Plane Surface(2) = {2};

Physical Surface(1) = {1};
Physical Surface(2) = {2};
Physical Curve(3) = {1};
Physical Curve(4) = {2};
Physical Curve(5) = {3,4};