Point(1) = {0,0,0};
Point(2) = {1,0,0};
Point(3) = {0,1,0};
Point(4) = {-1,0,0};
Point(5) = {0,-1,0};

Circle(1) = {2 , 1 , 3};
Circle(2) = {3 , 1 , 4};
Circle(3) = {4 , 1 , 5};
Circle(4) = {5 , 1 , 2};

Curve Loop(1) = {2,3,4,1};

Plane Surface(1) = {1};

Physical Surface(1) = {1};
Physical Curve(2) = {1,2,3,4};