epsilon = 0.001;

wall_thickness = 1.5;
padding_thickness = .3;
top = [40.7, 40.8, 43.2];
slop = wall_thickness + padding_thickness;

case_cut_y = 19.5;
case_cut_z = 18;
case_thickness = 2.6;

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

$fs = 0.4; // for final renderering

//mirror([0,1,0])  // uncomment for righty (left arm) tefilin
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
    cylinder(top.z+padding_thickness, r=wall_thickness/2, $fn = 90);                       // spaces around the corners to not rub them down
    translate([0, top.y, 0])
    cylinder(top.z+padding_thickness, r=wall_thickness/2, $fn = 90);
    translate([top.x, top.y, 0])
    cylinder(top.z+padding_thickness, r=wall_thickness/2, $fn = 90);
}
translate([-slop-case_thickness, case_cut_y-slop*2, 0])
cube([case_thickness+wall_thickness, wall_thickness, case_cut_z]);       // knot holder wall thing
