include <settings.scad>
a = sqrt(2)/2;

difference(){
    cube([base.x, base.y, 1]);

    translate([top.x/2+offset.x, top.y/2+offset.y, -.5])
    linear_extrude(height = 2)
    union(){
        circle(13);
        polygon(points = [
                            [0, -a],
                            [-top.x/2+a, -top.y/2],
                            [-top.x/2, -top.y/2],
                            [-top.x/2, -top.y/2+a],

                            [-a, 0],
                            [-top.x/2, top.y/2-a],
                            [-top.x/2, top.y/2],
                            [-top.x/2+a, top.y/2],

                            [0, a],
                            [top.x/2-a, top.y/2],
                            [top.x/2, top.y/2],
                            [top.x/2, top.y/2-a],

                            [a, 0],
                            [top.x/2, -top.y/2+a],
                            [top.x/2, -top.y/2],
                            [top.x/2-a, -top.y/2]
                        ]
        );
    }
}