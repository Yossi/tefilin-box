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
