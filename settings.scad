// we will define a bayit to have a top cube (where the scroll(s) go) and a base rectangle
// each will have x, y, and z measurements
// also we need an offset to locate the cube on top of the base

// these measurements are from my rashi shel rosh (shins on the sides are already factored in)
top = [44.6, 41.7, 43.9];
base = [56.9, 77.0, 20.2];
offset = [6.4, 7.0, base.z];

strap_width = 16;

padding_thickness = 1.5; // thickness of the padding you will put inside the box. in my case i have 1mm thick felt
bevel_radius = 3; // and wall thickness

slop = 2*(padding_thickness+bevel_radius);

/////// hinge related settings (best not to touch) ///////
extra_hinge_space = 1;

bump = [bevel_radius*0.8, 0.4, 44]; // diameter, height, angle
arm = [bevel_radius, 1, extra_hinge_space, 0];  // height, thickness, extra, esides
dim = [base.x, 20, 0.1];  // len, hinges(>=2), clearance, 0:male 1:female 2:reverable
patt = [0, 1];  // 0:bump-norm 1:bump-rev 2:dimp-norm 3:dimp:rev

hinge = [dim, patt, arm, bump];

epsilon = 0.001;
