$fa = 1;
$fs = 0.4;

// this file will describe the actual tefilin bayit.
// we will define a bayit to have a top cube (where the scroll(s) go) and a base rectangle
// each will have x, y, and z measurements
// also we need an offset to locate the cube on top of the base

// these measurements are from my rashi shel rosh (shins on the sides are already factored in)
function top_x() = 44.6;
function top_y() = 41.7;
function top_z() = 43.9;

function base_x() = 56.9;
function base_y() = 77.0;
function base_z() = 23.6;

function offset_x() = 6.4;
function offset_y() = 7.0;
function offset_z() = base_z();

function strap_width() = 16;

module bayit() {
    cube([base_x(), base_y(), base_z()]);
    translate([offset_x(), offset_y(), base_z()])
    cube([top_x(), top_y(), top_z()]);
}

bayit();