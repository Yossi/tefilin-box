$fa = 1;
$fs = 1;

include <settings.scad>

use <snap_hinge.scad>;
use <decorations.scad>;

module bayit() {
    cube(base);

    translate(offset)
    cube(top);
}

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
    translate([0, base.y+padding_thickness-extra_hinge_space-epsilon, base.z+slop/2-bevel_radius-extra_hinge_space])
    difference(){
        union(){
            cube([base.x, bevel_radius+extra_hinge_space, bevel_radius+extra_hinge_space]);

            translate([-slop/2, extra_hinge_space+bevel_radius/2, extra_hinge_space-2*epsilon])
            cube([base.x+slop, bevel_radius/2, bevel_radius]);
        }
        translate([-slop/2-epsilon, extra_hinge_space+bevel_radius/2, extra_hinge_space+bevel_radius/2])
        rotate([0, 90, 0])
        cylinder(r=bevel_radius/2, h=slop/2+epsilon);

        translate([base.x, extra_hinge_space+bevel_radius/2, extra_hinge_space+bevel_radius/2])
        rotate([0, 90, 0])
        cylinder(r=bevel_radius/2, h=slop/2+epsilon);
    }
}

module split_top_bottom_3(){
    difference(){
        translate([-slop/2, -slop/2-1-epsilon, -slop/2-epsilon])
        cube([base.x+slop+epsilon, base.y+slop+1+epsilon, base.z+slop/2+padding_thickness*2]);

        hull(){
            translate([-padding_thickness, -padding_thickness, base.z+padding_thickness-epsilon])
            cylinder(h=padding_thickness+epsilon, r1=0, r2=bevel_radius);

            translate([base.x+padding_thickness, -padding_thickness, base.z+padding_thickness-epsilon])
            cylinder(h=padding_thickness+epsilon, r1=0, r2=bevel_radius);

            translate([base.x+padding_thickness, base.y+padding_thickness, base.z+padding_thickness-epsilon])
            cylinder(h=padding_thickness+epsilon, r1=0, r2=bevel_radius);

            translate([-padding_thickness, base.y+padding_thickness, base.z+padding_thickness-epsilon])
            cylinder(h=padding_thickness+epsilon, r1=0, r2=bevel_radius);
        }

        translate([-slop/2, base.y-2*strap_width, base.z+padding_thickness-epsilon])
        cube([base.x+slop, strap_width*2+slop/2, padding_thickness]);
    }
}

module padding_model(){
    hull(){ corner_points([0, 0, 0], base) pad_cube(); }
    hull(){ corner_points(offset, [offset.x+top.x, offset.y+top.y, offset.z+top.z]) pad_cube(); }
}

module full_box_model(half){
    hull(){corner_points([-padding_thickness, -padding_thickness, -padding_thickness], [base.x+padding_thickness, base.y+padding_thickness, base.z+padding_thickness]) sphere(bevel_radius);}
    if (half == "top")
        hull(){corner_points([offset.x-padding_thickness, offset.y-padding_thickness, offset.z+padding_thickness], [offset.x+top.x+padding_thickness, offset.y+top.y+padding_thickness, offset.z+top.z+padding_thickness]) sphere(bevel_radius);}
}

module strap_cutout(){
    translate([-slop/2-epsilon, base.y-2*strap_width, padding_thickness+base.z/5])
    cube([base.x+slop+2*epsilon, strap_width*2, 4*base.z/5]);
}

module tefilin_box_3(half){
    difference(){
        union(){
            full_box_model(half);

            // additive decorations here
            shins();
            your_name();
            rashi_label();
        }

        padding_model();
        hinge_cutout();

        if (half == "top") {
            inside_bevel();

            split_top_bottom_3();

            // subtractive decorations here
            grooves();

        } else {
            difference(){ // slice off the top
                translate([-slop/2, -slop/2-1-epsilon, -slop/2])
                cube([base.x+slop, base.y+slop+1+epsilon, base.z+top.z+slop+1+epsilon]);
                split_top_bottom_3();
            }

            strap_cutout();

            translate([top.x/2+offset.x, top.y/2+offset.y, -slop/2])
            round_vents();
        }
    }
    if (half == "top") {
        translate([0, base.y+padding_thickness+bevel_radius/2, base.z+padding_thickness+bevel_radius/2])
        rotate([0, 0, 0])
        snap_hinge(hinge, 0); // top hinge
    } else {
        translate([0, base.y+padding_thickness+bevel_radius/2, base.z+padding_thickness+bevel_radius/2])
        rotate([-90, 0, 0])
        snap_hinge(hinge, 1); // bottom hinge
    }

}


// hinge_cutout();

// split_top_bottom();
// strap_cutout();


// $fs = 0.4; // for final renderering. looks great but makes the model take more than 10 seconds to render
// tefilin_box_3("bottom");
tefilin_box_3("top");