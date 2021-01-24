$fa = 1;
$fs = 1;
// $fs = 0.4; // for final renderering. looks great but makes the model take more than 10 seconds to render
// $fn = 8;

include <settings.scad>

use <bayit.scad>;
use <snap_hinge.scad>;

epsilon = 0.001;

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
    translate([offset.x-slop/2, offset.y-slop/2, offset.z+padding_thickness-epsilon])
    difference(){
        cube([top.x+slop, top.y+slop, bevel_radius]);

        translate([0, 0, bevel_radius])
        rotate([0, 90, 0])
        cylinder(r=bevel_radius, h=top.x+slop);

        translate([0, top.y+slop, bevel_radius])
        rotate([0, 90, 0])
        cylinder(r=bevel_radius, h=top.x+slop);

        translate([0, 0, bevel_radius])
        rotate([-90, 0, 0])
        cylinder(r=bevel_radius, h=top.y+slop);

        translate([top.x+slop, 0, bevel_radius])
        rotate([-90, 0, 0])
        cylinder(r=bevel_radius, h=top.y+slop);
    }
}

module hinge_cutout(){
    difference(){
        translate([-slop/2, base.y+padding_thickness-epsilon, -slop/2])
        cube([base.x+slop, bevel_radius+epsilon*2, bevel_radius]); // make space for hinge

        translate([-slop/2-epsilon, base.y+padding_thickness+bevel_radius/2, (bevel_radius-slop)/2])
        union(){
            rotate([0, 90, 0])
            cylinder(r=bevel_radius/2, h=slop/2+epsilon);

            translate([0, -bevel_radius/2-2*epsilon, 0])
            cube([slop/2+epsilon, bevel_radius+4*epsilon, bevel_radius/2+epsilon]);
        }

        translate([base.x+epsilon, base.y+padding_thickness+bevel_radius/2, (bevel_radius-slop)/2])
        union(){
            rotate([0, 90, 0])
            cylinder(r=bevel_radius/2, h=slop/2+epsilon);

            translate([0, -bevel_radius/2-2*epsilon, 0])
            cube([slop/2+epsilon, bevel_radius+4*epsilon, bevel_radius/2+epsilon]);
        }
    }
}

module padding_model(){
    hull(){ corner_points([0, 0, 0], base) pad_cube(); }
    hull(){ corner_points(offset, [offset.x+top.x, offset.y+top.y, offset.z+top.z]) pad_cube(); }
}

module full_box_model(){
    hull(){corner_points([-padding_thickness, -padding_thickness, -padding_thickness], [base.x+padding_thickness, base.y+padding_thickness, base.z+padding_thickness]) sphere(bevel_radius);}
    hull(){corner_points([offset.x-padding_thickness, offset.y-padding_thickness, offset.z+padding_thickness], [offset.x+top.x+padding_thickness, offset.y+top.y+padding_thickness, offset.z+top.z+padding_thickness]) sphere(bevel_radius);}
}

module strap_cutout(){
    translate([-slop/2-epsilon, base.y-2.1*strap_width, -epsilon])
    rotate([90,0,90])
    linear_extrude(height=base.x+slop+2*epsilon)
    polygon([
        [0, 0],
        [2*strap_width, 0],
        [(2*strap_width-(strap_width-2)/2), 4*base.z/5],
        [(strap_width-2)/2, 4*base.z/5]
    ]);
}

module tefilin_top_2(){

    difference(){
        full_box_model();

        padding_model();
        inside_bevel();
        strap_cutout();
        hinge_cutout();

        translate([-slop/2, -slop/2, -slop/2])
        #cube([base.x+slop+epsilon, base.y+slop/2+padding_thickness, slop/2]); // slice off bottom

    }

    translate([0, base.y+padding_thickness+bevel_radius/2, (bevel_radius-slop)/2])
    rotate([-90, 0, 0])
    snap_hinge(hinge, 0); // top hinge

    // translate([0, base.y+padding_thickness+bevel_radius/2, (bevel_radius-slop)/2])
    // rotate([180, 0, 0])
    // snap_hinge(hinge, 1); // bottom hinge

}

tefilin_top_2();
