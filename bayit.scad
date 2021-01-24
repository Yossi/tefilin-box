include <settings.scad>

module bayit() {
    cube(base);
    translate(offset)
    cube(top);
}

bayit();