include <settings.scad>

template = false;
padding_thickness = .4;
slop = wall_thickness + padding_thickness;

case_cut_y = top.y/2 + slop;
case_cut_z = top.z/2;
case_thickness = bevel_radius;

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

module inside_box(){
    difference(){
        full_box_model();                                                    // create outer dimentions
        padding_model();                                                     // cut out interior

        translate([-slop, -slop,-slop+epsilon])
        cube([top.x+2*slop, top.y+2*slop, slop]);                            // trim off bottom

        translate([top.x/2, top.y/2, top.z])
        cylinder(slop, d=min(top.x, top.y)*.9, $fn = 90);                    // hole in the top

        translate([-slop, -slop, 0])
        cube([slop*2, case_cut_y-slop, top.z*.5]);                           // side cutout

        translate([0, 0, 0])
        cylinder(top.z+padding_thickness, r=wall_thickness/2, $fn = 90);
        translate([top.x, 0, 0])
        cylinder(top.z+padding_thickness, r=wall_thickness/2, $fn = 90);     // spaces around the corners to not rub them down
        translate([0, top.y, 0])
        cylinder(top.z+padding_thickness, r=wall_thickness/2, $fn = 90);
        translate([top.x, top.y, 0])
        cylinder(top.z+padding_thickness, r=wall_thickness/2, $fn = 90);
    }
    translate([-slop-case_thickness, case_cut_y-slop*2, 0])
    cube([case_thickness+wall_thickness, wall_thickness, case_cut_z]);       // knot holder wall thing
}

module padding_template(){
    x = top.z;
    y = top.x + top.y;
    s = slop;
    xcut = top.z * .5;
    ycut = case_cut_y - 2*slop;
    o = 3;

    points = [
        [0, y-s],   [xcut, y-s],     [xcut, y],     [x, y],     [x, 0],   [xcut, 0],   [xcut, ycut],     [0, ycut],
        [o, y-s-o], [xcut+o, y-s-o], [xcut+o, y-o], [x-o, y-o], [x-o, o], [xcut+o, o], [xcut+o, ycut+o], [o, ycut+o]
    ];

    paths = [[0, 1, 2, 3, 4, 5, 6, 7],
             [8, 9,10,11,12,13,14,15]];
    linear_extrude(height = 1)
    polygon(points, paths, 10);
}

// $fs = 0.4; // for final renderering

if (template) {
    padding_template();
} else {
    if (hand == "left") {
        inside_box();
    } else {
        mirror([0,1,0])  // uncomment for righty (left arm) tefilin
        inside_box();
    }
}