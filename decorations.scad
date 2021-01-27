$fa = 1;
$fs = .4;

include <settings.scad>

module round_vents(){
    linear_extrude(height=bevel_radius+epsilon)
    union(){
        circle(3);
        for (a = [0:60:300])
            rotate([0, 0, a])
            translate([7, 0, 0])
            circle(3);
    }
}

module shins(){
    translate([offset.x-slop/2, offset.y+top.y, offset.z+slop/2])
    rotate([90, 0, -90])
    resize(newsize=[top.y, top.z-slop/2, 0])
    linear_extrude(1)
    import(file = "svg/3.svg");

    translate([offset.x+top.x+slop/2, offset.y, offset.z+slop/2])
    rotate([90, 0, 90])
    resize(newsize=[top.y, top.z-slop/2, 0])
    linear_extrude(1)
    import(file = "svg/4.svg");
}

groove_depth = 1;

module grooves(){
    box_dims = [top.x+slop, top.y+slop, top.z];
    translate([offset.x-slop/2, offset.y-slop/2, offset.z+slop/2])
    for (i=[(box_dims.x)/4:(box_dims.x)/4:box_dims.x-box_dims.x/4]){
        translate([i, 0, 0])
        union(){
            translate([-groove_depth/2, -epsilon, 0])
            cube([groove_depth, groove_depth, box_dims.z-bevel_radius]); // front

            translate([-groove_depth/2, bevel_radius, box_dims.z-bevel_radius])
            rotate([90, -90, 90])
            rotate_extrude(angle=90) // front elbow
            translate([2, 0, 0])
            square([groove_depth, groove_depth]);

            translate([-groove_depth/2, bevel_radius, box_dims.z+epsilon])
            rotate([-90, 0, 0])
            cube([groove_depth, groove_depth, box_dims.y-bevel_radius*2]); // top

            translate([-groove_depth/2, box_dims.y-bevel_radius, box_dims.z-bevel_radius])
            rotate([90, 0, 90])
            rotate_extrude(angle=90) // back elbow
            translate([2, 0, 0])
            square([groove_depth, groove_depth]);

            translate([-groove_depth/2, -groove_depth+box_dims.y+epsilon, 0])
            cube([groove_depth, groove_depth, box_dims.z-bevel_radius]); // back
        }
    }
}

//https://opensiddur.org/wp-content/uploads/fonts/Mekorot-Rashi/Mekorot-Rashi.zip

use <ttf/BenOrRashiRegular.ttf>
text("\u05e9", font="Rashi", language="he");
// "רש״י"
//רש״י"רש\"י"
//"Mekorot\\-Rashi:style=Rashi"