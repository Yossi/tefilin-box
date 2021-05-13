include <settings.scad>

thickness = 3;
s2 = sqrt(2)/2;
s3 = 3*sqrt(2 + s2);

b = base;
o = offset;
t = top;
c = [o.x + t.x/2, o.y + t.y/2]; // center
th = thickness;

points = [
    // box
    [0, 0],
    [b.x, 0],
    [b.x, b.y],
    [0, b.y],

    // x
    [o.x, o.y+s2],
    [o.x, o.y],
    [o.x+s2, o.y],
    [c.x, c.y-s2],

    [o.x+t.x-s2, o.y],
    [o.x+t.x, o.y],
    [o.x+t.x, o.y+s2],
    [c.x+s2, c.y],

    [o.x+t.x, o.y+t.y-s2],
    [o.x+t.x, o.y+t.y],
    [o.x+t.x-s2, o.y+t.y],
    [c.x, c.y+s2],

    [o.x+s2, o.y+t.y],
    [o.x, o.y+t.y],
    [o.x, o.y+t.y-s2],
    [c.x-s2, c.y],

    // >
    [c.x-s3, c.y],
    [th, o.y+s3-o.x+th],
    [th, o.y+t.y-s3+o.x-th],

    // ^
    [c.x, c.y-s3],
    [o.x+s3-o.y+th, th],
    [o.x+t.x-s3+o.y-th, th],

    // <
    [c.x+s3, c.y],
    [b.x-th, o.y+t.y-s3+b.x-th-o.x-t.x],
    [b.x-th, o.y+s3-b.x+th+o.x+t.x],

    // v
    [c.x, c.y+s3],
    [b.x-th, o.y+t.y+s3+o.x-th],
    [b.x-th, b.y-th],
    [th, b.y-th],
    [th, o.y+t.y+s3+o.x-th]

];
paths = [
    [0,1,2,3], // box
    [4,5,6,7, 8,9,10,11, 12,13,14,15, 16,17,18,19], // x
    [20,21,22], // >
    [23,24,25], // ^
    [26,27,28], // <
    [29,30,31,32,33] // v

];

linear_extrude(height = 1)
difference() {
    union() {
        translate(c)
        circle(16);

        polygon(points, paths);
    }
    translate(c)
    circle(13);
    polygon(points, [[4,5,6,7, 8,9,10,11, 12,13,14,15, 16,17,18,19]]);
}
