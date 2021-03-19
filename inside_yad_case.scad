epsilon = 0.001;

right_handed = 0; // 1 for right handed sets (goes on the left arm), 0 for lefty sets
wall_thickness = 1.5;
padding_thickness = .1;
top = [40.7, 40.8, 43.2];
slop = wall_thickness + padding_thickness;


module pad_cube(){
    pad_coords = [ for (i = [1: 3]) 2*padding_thickness ];
    cube(pad_coords, center=true);
}

module corner_points(start_point, end_point){
    corners = [ for (x = [start_point.x, end_point.x],
                     y = [start_point.y, end_point.y],
                     z = [start_point.z, end_point.z])
                     [x, y, z]];
    for (corner = corners) translate(corner) children(0);
}

module padding_model(){
    hull(){ corner_points([0, 0, 0], top) pad_cube(); }
}

module full_box_model(){
    hull(){corner_points([-padding_thickness, -padding_thickness, -padding_thickness], [top.x+padding_thickness, top.y+padding_thickness, top.z+padding_thickness]) sphere(wall_thickness);}
}

$fs = 0.4; // for final renderering. looks great but makes the model take more than 10 seconds to render

difference(){
    full_box_model();
    padding_model();

    translate([-slop, -slop,-slop+epsilon])
    cube([top.x+2*slop, top.y+2*slop, slop]);

    translate([top.x/2, top.y/2, top.z])
    cylinder(slop, d=min(top.x, top.y)*.9);

    translate([-slop+top.x*right_handed, -slop, 0])
    cube([slop*2, top.y*.5, top.z*.5]);
}