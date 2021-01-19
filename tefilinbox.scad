$fa = 1;
$fs = 0.4;

use <bayit.scad>;

epsilon = 0.001;

bevel_radius = 1.75;

wall_thickness = 2 - bevel_radius;
padding_thickness = 0.1;

clearance = wall_thickness + padding_thickness;

module tefilin_box_bottom(){
    box_bottom_x = 2*clearance+base_x();
    box_bottom_y = 2*clearance+base_y();
    box_bottom_z = clearance+base_z()-epsilon;

    translate([bevel_radius,bevel_radius,bevel_radius])
    difference(){
        hull(){
            cube([box_bottom_x, box_bottom_y, box_bottom_z]);

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
            color("black")
            translate([clearance, clearance, clearance])
            #bayit();

            // padding
            translate([clearance-padding_thickness, clearance-padding_thickness, clearance-padding_thickness])
            cube([2*padding_thickness+base_x(), 2*padding_thickness+base_y(), padding_thickness+base_z()+epsilon]);

            // holes for straps
            color("red")
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

tefilin_box_bottom();
