$fa = 1;
$fs = 0.4;

use <bayit.scad>;

epsilon = 0.001;

bevel_radius = 1.75;

wall_thickness = 2 - bevel_radius;
padding_thickness = 0.1;

clearance = wall_thickness + padding_thickness;

box_bottom_x = 2*clearance+base_x();
box_bottom_y = 2*clearance+base_y();
box_bottom_z = clearance+base_z()-epsilon;

module tefilin_box_top(){
    translate([bevel_radius, bevel_radius, bevel_radius])
    difference(){
        union(){
            hull(){ // hull for cover of base
                // color("blue")
                // translate([0, 0, base_z()+clearance])
                // cube([box_bottom_x, box_bottom_y, clearance]);

                translate([0, 0, box_bottom_z]) cylinder(h=.1, r=bevel_radius);
                translate([box_bottom_x, 0, box_bottom_z]) cylinder(h=.1, r=bevel_radius);
                translate([0, box_bottom_y, box_bottom_z]) cylinder(h=.1, r=bevel_radius);
                translate([box_bottom_x, box_bottom_y, box_bottom_z]) cylinder(h=.1, r=bevel_radius);

                translate([0, 0, box_bottom_z+clearance]) sphere(bevel_radius);
                translate([box_bottom_x, 0, box_bottom_z+clearance]) sphere(bevel_radius);
                translate([0, box_bottom_y, box_bottom_z+clearance]) sphere(bevel_radius);
                translate([box_bottom_x, box_bottom_y, box_bottom_z+clearance]) sphere(bevel_radius);
            }
            translate([offset_x(), offset_y(), 0])
            hull(){ // hull for crown
                translate([0+clearance, 0+clearance, box_bottom_z+clearance+bevel_radius]) cylinder(h=.1, r=bevel_radius);
                translate([top_x()+clearance, 0+clearance, box_bottom_z+clearance+bevel_radius]) cylinder(h=.1, r=bevel_radius);
                translate([0+clearance, top_y()+clearance, box_bottom_z+clearance+bevel_radius]) cylinder(h=.1, r=bevel_radius);
                translate([top_x()+clearance, top_y()+clearance, box_bottom_z+clearance+bevel_radius]) cylinder(h=.1, r=bevel_radius);

                translate([0+clearance, 0+clearance, box_bottom_z+clearance+bevel_radius+top_z()]) sphere(bevel_radius);
                translate([top_x()+clearance, 0+clearance, box_bottom_z+clearance+bevel_radius+top_z()]) sphere(bevel_radius);
                translate([0+clearance, top_y()+clearance, box_bottom_z+clearance+bevel_radius+top_z()]) sphere(bevel_radius);
                translate([top_x()+clearance, top_y()+clearance, box_bottom_z+clearance+bevel_radius+top_z()]) sphere(bevel_radius);
            }
        }
        translate([-bevel_radius, -bevel_radius, box_bottom_z-bevel_radius])
        cube([base_x()+(bevel_radius+clearance)*2, base_y()+(bevel_radius+clearance)*2, bevel_radius]); // slice off protruding bottoms of spheres

        union(){
            // bayit
            // color("black")
            translate([clearance, clearance, clearance])
            bayit();

            // padding for cover of base
            translate([wall_thickness, wall_thickness, clearance+base_z()-epsilon])
            cube([2*padding_thickness+base_x(), 2*padding_thickness+base_y(), padding_thickness+epsilon]);

            // padding for inside crown
            translate([offset_x()+clearance, offset_y()+clearance, base_z()+clearance+padding_thickness])
            cube([top_x()+padding_thickness, top_y()+padding_thickness, top_z()+padding_thickness]);


        }
    }
}

module tefilin_box_bottom(){
    translate([bevel_radius, bevel_radius, bevel_radius])
    difference(){
        // color("white")
        hull(){
            // cube([box_bottom_x, box_bottom_y, box_bottom_z]);

            // bevel stuff
            sphere(bevel_radius);
            translate([box_bottom_x, 0, 0]) sphere(bevel_radius);
            translate([0, box_bottom_y, 0]) sphere(bevel_radius);
            translate([box_bottom_x, box_bottom_y, 0]) sphere(bevel_radius);
            translate([0, 0, box_bottom_z-.1]) cylinder(h=.1, r=bevel_radius);
            translate([box_bottom_x, 0, box_bottom_z-.1]) cylinder(h=.1, r=bevel_radius);
            translate([0, box_bottom_y, box_bottom_z-.1]) cylinder(h=.1, r=bevel_radius);
            translate([box_bottom_x, box_bottom_y, box_bottom_z-.1]) cylinder(h=.1, r=bevel_radius);
        }

        union(){
            // bayit
            // color("black")
            translate([clearance, clearance, clearance])
            bayit();

            // padding
            translate([clearance-padding_thickness, clearance-padding_thickness, clearance-padding_thickness])
            cube([2*padding_thickness+base_x(), 2*padding_thickness+base_y(), padding_thickness+base_z()+epsilon]);

            // holes for straps
            // color("red")
            translate([-5, box_bottom_y-2*strap_width()-8, epsilon])
            rotate([90,0,90])
            linear_extrude(height=70)
            polygon([
                [0, box_bottom_z],
                [2*strap_width(), box_bottom_z],
                [(2*strap_width()-(strap_width()-2)/2), 2*box_bottom_z/5],
                [(strap_width()-2)/2, 2*box_bottom_z/5]
            ]);

            // TODO: vents on bottom
        }
    }
}


translate([0, 0, 20])
tefilin_box_top();
tefilin_box_bottom();
