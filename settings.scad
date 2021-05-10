// we will define a bayit to have a top cube (where the scroll(s) go) and a base rectangle
// each will have x, y, and z measurements
// also we need an offset to locate the cube on top of the base



// these are the variables and types than need to be passed in
strap_width = 0;
cutout = [];
top = [];
base_raw = [0,0,0];
offset_raw = [0,0];

hand = "";
nusach = "";
location = "";
your_name = [""];

padding_thickness = .4; // thickness of the padding you will put inside the box
strap_percent = .7; // size of shoulder for wrapping straps



// computed based off the measurements provided. no need to tamper with these
diagonal = sqrt(pow(base_raw.y, 2) + pow(base_raw.z, 2));
offset = [max(strap_width*strap_percent, offset_raw.x), offset_raw.y+diagonal-base_raw.y, base_raw.z];
base = [top.x+2*max(strap_width*strap_percent, offset_raw.x), diagonal, base_raw.z]; // calculated to allow the bottom to clear the corner when opening

wall_thickness = 1.5; // inner box wall thickness
bevel_radius = 2.5; // case wall thickness
slop = 2*(padding_thickness+bevel_radius);

// hinge related settings
extra_hinge_space = 1;

bump = [bevel_radius*0.8, 0.4, 44]; // diameter, height, angle
arm = [bevel_radius, 1.25, extra_hinge_space, 0];  // height, thickness, extra, esides
dim = [base.x, 22, 0.1];  // len, hinges(>=2), clearance, 0:male 1:female 2:reverable
patt = [0, 1];  // 0:bump-norm 1:bump-rev 2:dimp-norm 3:dimp:rev

hinge = [dim, patt, arm, bump];

epsilon = 0.001;
