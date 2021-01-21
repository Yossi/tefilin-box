$fa = 1;
$fs = 1;
// $fs = 0.4; // for final renderering. looks great but makes the model take more than 10 seconds to render

use <bayit.scad>;

epsilon = 0.001;

padding_thickness = 1;
bevel_radius = 2; // also the wall thickness

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
    translate([offset_x()-padding_thickness-bevel_radius, offset_y()-padding_thickness-bevel_radius, offset_z()+padding_thickness-epsilon])
    difference(){
        cube([top_x()+2*(padding_thickness+bevel_radius), top_y()+2*(padding_thickness+bevel_radius), bevel_radius]);

        translate([0, 0, bevel_radius])
        rotate([0, 90, 0])
        cylinder(r=bevel_radius, h=top_x()+(bevel_radius+padding_thickness)*2);

        translate([0, top_y()+(bevel_radius+padding_thickness)*2, bevel_radius])
        rotate([0, 90, 0])
        cylinder(r=bevel_radius, h=top_x()+(bevel_radius+padding_thickness)*2);

        translate([0, 0, bevel_radius])
        rotate([-90, 0, 0])
        cylinder(r=bevel_radius, h=top_y()+(bevel_radius+padding_thickness)*2);

        translate([top_x()+(bevel_radius+padding_thickness)*2, 0, bevel_radius])
        rotate([-90, 0, 0])
        cylinder(r=bevel_radius, h=top_y()+(bevel_radius+padding_thickness)*2);
    }
}

module padding_model(){
    hull(){ corner_points([0, 0, 0], [base_x(), base_y(), base_z()]) pad_cube(); }
    hull(){ corner_points([offset_x(), offset_y(), offset_z()], [offset_x()+top_x(), offset_y()+top_y(), offset_z()+top_z()]) pad_cube(); }
}

module full_box_model(){
    hull(){corner_points([-padding_thickness, -padding_thickness, -padding_thickness], [base_x()+padding_thickness, base_y()+padding_thickness, base_z()+padding_thickness]) sphere(bevel_radius);}
    hull(){corner_points([offset_x()-padding_thickness, offset_y()-padding_thickness, offset_z()+padding_thickness], [offset_x()+top_x()+padding_thickness, offset_y()+top_y()+padding_thickness, offset_z()+top_z()+padding_thickness]) sphere(bevel_radius);}
}

module tefilin_top_2(){

    difference(){
        full_box_model();

        slop = 2*(padding_thickness+bevel_radius);
        translate([-slop/2, -slop/2, -slop/2])
        cube([base_x()+slop+epsilon, base_y()+slop+epsilon, slop/2]); // slice off bottom

        padding_model();
        inside_bevel();
    }

}

tefilin_top_2();
