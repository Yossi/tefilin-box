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
