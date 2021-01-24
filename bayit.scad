$fa = 1;
$fs = 0.4;

include <settings.scad>

module bayit() {
    cube(base);
    translate(offset)
    cube(top);
}

bayit();