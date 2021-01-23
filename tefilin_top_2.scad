$fa = 1;
$fs = 1;
// $fs = 0.4; // for final renderering. looks great but makes the model take more than 10 seconds to render
// $fn = 8;

use <bayit.scad>;
use <snap_hinge.scad>;

epsilon = 0.001;

padding_thickness = 1;
bevel_radius = 3; // also the wall thickness

slop = 2*(padding_thickness+bevel_radius);

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

module inside_bevel(){
    translate([offset_x()-slop/2, offset_y()-slop/2, offset_z()+padding_thickness-epsilon])
    difference(){
        cube([top_x()+slop, top_y()+slop, bevel_radius]);

        translate([0, 0, bevel_radius])
        rotate([0, 90, 0])
        cylinder(r=bevel_radius, h=top_x()+slop);

        translate([0, top_y()+slop, bevel_radius])
        rotate([0, 90, 0])
        cylinder(r=bevel_radius, h=top_x()+slop);

        translate([0, 0, bevel_radius])
        rotate([-90, 0, 0])
        cylinder(r=bevel_radius, h=top_y()+slop);

        translate([top_x()+slop, 0, bevel_radius])
        rotate([-90, 0, 0])
        cylinder(r=bevel_radius, h=top_y()+slop);
    }
}

module hinge_bevel(){
    // translate([-slop/2, base_y()+padding_thickness, -bevel_radius/2])
    // difference(){
    //     translate([0, bevel_radius/2, 0])
    //     cube([base_x()+slop, bevel_radius/2+epsilon*2, bevel_radius/2]);

    //     translate([-epsilon, bevel_radius/2, bevel_radius/2])
    //     rotate([0, 90, 0])
    //     cylinder(r=bevel_radius/2, h=base_x()+slop+2*epsilon);
    // }
    translate([-slop/2, base_y()+padding_thickness+bevel_radius/2, 0])
    rotate([-45, 0, 0])
    cube([base_x()+slop, bevel_radius, bevel_radius]);
}

module padding_model(){
    hull(){ corner_points([0, 0, 0], [base_x(), base_y(), base_z()]) pad_cube(); }
    hull(){ corner_points([offset_x(), offset_y(), offset_z()], [offset_x()+top_x(), offset_y()+top_y(), offset_z()+top_z()]) pad_cube(); }
}

module full_box_model(){
    hull(){corner_points([-padding_thickness, -padding_thickness, -padding_thickness], [base_x()+padding_thickness, base_y()+padding_thickness, base_z()+padding_thickness]) sphere(bevel_radius);}
    hull(){corner_points([offset_x()-padding_thickness, offset_y()-padding_thickness, offset_z()+padding_thickness], [offset_x()+top_x()+padding_thickness, offset_y()+top_y()+padding_thickness, offset_z()+top_z()+padding_thickness]) sphere(bevel_radius);}
}

module strap_cutout(){
    translate([-slop/2-epsilon, base_y()-2.1*strap_width(), -epsilon])
    rotate([90,0,90])
    linear_extrude(height=base_x()+slop+2*epsilon)
    polygon([
        [0, 0],
        [2*strap_width(), 0],
        [(2*strap_width()-(strap_width()-2)/2), 4*base_z()/5],
        [(strap_width()-2)/2, 4*base_z()/5]
    ]);
}

module tefilin_top_2(){

    difference(){
        full_box_model();

        padding_model();
        inside_bevel();
        strap_cutout();
        hinge_bevel();

        // translate([-slop/2, -slop/2, -slop/2])
        // cube([base_x()+slop+epsilon, base_y()+slop+epsilon, slop/2]); // slice off bottom

        // translate([0, base_y()+padding_thickness+bevel_radius/2, 0])
        // rotate([0, 90, 0])
        // #cylinder(r=bevel_radius/2, h=base_x());

        translate([0, base_y()+padding_thickness-epsilon, -bevel_radius/2])
        cube([base_x(), bevel_radius+epsilon*2, bevel_radius]); // make space for hinge

    }

    bump = [bevel_radius*0.8, 0.4, 55]; // diameter, height, angle
    arm = [bevel_radius, 1, 0, 0];  // height, thick, extra, esides
    dim = [base_x(), 25, 0.1];  // len, hinges(>=2), clearance, 0:male 1:female 2:reverable
    patt = [0, 1];  // 0:bump-norm 1:bump-rev 2:dimp-norm 3:dimp:rev
    hinge = [dim, patt, arm, bump];

    translate([0, base_y()+padding_thickness+bevel_radius/2, 0])
    rotate([-90, 0, 0])
    snap_hinge(hinge, 0);

    translate([0, base_y()+padding_thickness+bevel_radius/2, 0])
    rotate([-90, 0, 0])
    snap_hinge(hinge, 1);


}

tefilin_top_2();
