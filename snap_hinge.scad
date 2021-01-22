
// ----------------------------------------------------
// Snap hinge.
// Created by Stefan Bengtsson. 2018-04-22.
// stefanb.sbg@gmail.com
// ----------------------------------------------------

/************************************************************************

This code creates hinges that can snap on /off.

The code can model many diffenent variants of a hings.

modules:
    snap_hinge(hinge, model);

hinge = [dimensions, pattern, arm, bump];
    dimensions = [length of hinge, number of arms, clearance between arms];
        length = Total length of hinge.
        arms = Number of arms on hinge. Arm type is selected with pattern.
            The arms are placed on equal distance from each other in the
            length of the hinge.
        clearance = Distance between moving parts. 0.1 mm works good.
    pattern = [list of hinge arm types];
        If the list in patt is shorter than number of arms then it is repeated.
        The arm types are:
        0 - Bump, Normal
        1 - Bump, Reversed
        2 - Dimp, Normal
        3 - Dimp, Reversed
        4 - Flat, Normal
        5 - Flat, Reversed
    arm = [height, thicknes, extra length, sides on the end];
        height = The hinge and arm height.
        thicknes = The thickness of an arm.
        extra = An extra arm length adding to the height.
        sides = Number of sizes on the rounded part of the arm.
            If sizes are zero the end will be rounded with $fn sides.
    bump = [diameter, bump height, bump angle];
        diameter = The bump/dimp diameter.
            The diameter must be less than the arm height.
        height = Bump/dimp height.
            The bump height must be less than the arm thickness.
        angle = Controlls how steap the bump is.
            Around 40 works good.
model = Different types of hinge modells. The types are:
    0 - A normal hinge.
    1 - A mirroed hinge that fitts with type 0.
        The hinge is rendered rotated 180 degrees to fitt with type 0.
    2 - A reverable hinge. Two identical hinges fitts together.
        This model is used by the polyhedron designer.
        This model only uses half the pattern length as the other half
        is a mirror of the first.

************************************************************************/


// A hinge bump. This is used to create both a bump and a dimp.
module snap_hinge_bump(bump)
{
    diam = bump[0];
    height = bump[1];
    ang = bump[2];
    // Create bump with extra size.
    rotate(a = 90, v = [0, 1, 0])
    translate(v = [0, 0, -0.01])
    cylinder(h = height + 0.01, d1 = diam, d2 = diam - (2 * height / tan(ang)));
}

// A hinge arm.
module snap_hinge_basearm(arm)
{
    height = arm[0];
    thick = arm[1];
    exlen = arm[2];
    sides = arm[3];
    // Set number of sides on the arm end.
    steps = sides == 0 ? $fn : (sides + 1) * 2;
    ang = 360 / (steps * 2);
    // Create round part a litte larger.
    rotate(a = 90, v = [0, 1, 0])
    rotate(a = ang, v = [0, 0, 1])
    cylinder(h = thick, d = height / cos(ang), $fn = steps);
    // Create short arm with extra length.
    translate(v = [0, -exlen - height / 2 - 0.01, -height / 2])
    cube(size = [thick, exlen + height / 2 + 0.01, height]);
}

// A hinge arm with a bump.
module snap_hinge_arm_bump(part)
{
    arm = part[0];
    bump = part[1];
    thick = arm[1];
    //render()
    {
        snap_hinge_basearm(arm);
        translate(v = [thick, 0, 0])
        snap_hinge_bump(bump);
    }
}

// A hinge arm with a dimp.
module snap_hinge_arm_dimp(part)
{
    arm = part[0];
    bump = part[1];
    thick = arm[1];
    //render()
    {
        difference()
        {
            snap_hinge_basearm(arm);
            translate(v = [thick, 0, 0])
            rotate(a = 180, v = [0, 0, 1])
            snap_hinge_bump(bump);
        }
    }
}

// A hinge arm with a dimp or bump or none in the correct position.
module snap_hinge_arm(pat, clear, part)
{
    rev = pat % 2;
    type = floor(pat / 2);
    thick = part[0][1];
    translate(v = [(rev == 0 ? 0 : thick * 2 + clear), 0, 0])
    rotate(a = (rev == 0 ? 0 : 180), v = [0, 1, 0])
    {
        if (type == 0) snap_hinge_arm_bump(part);
        else if (type == 1) snap_hinge_arm_dimp(part);
        else snap_hinge_basearm(part[0]);
    }
}

// A full hinge.
module snap_hinge(hinge, model)
{
    hlen = hinge[0][0];
    cnt = hinge[0][1];
    clear = hinge[0][2];
    patt = hinge[1];
    arm = hinge[2];
    thick = hinge[2][1];
    bump = hinge[3];

    dist = (hlen - (2 * thick + clear)) / (cnt - 1);
    pattlen = len(patt);

    inv = [2, 3, 0, 1, 5, 4];

    for (i = [0 : cnt -  1])
    {
        if (model == 0) // male
        {
            ht = patt[i % pattlen];
            translate(v = [dist * i, 0, 0])
            snap_hinge_arm(ht, clear, [arm, bump]);
        }
        else if (model == 1) // female
        {
            ht = 3 - patt[i % pattlen];
            translate(v = [dist * i, 0, 0])
            rotate(a = 180, v = [1, 0, 0])
            snap_hinge_arm(ht, clear, [arm, bump]);
        }
        else if (model == 2) // reverse
        {
            hcnt = (cnt - 1) / 2;
            ri = i > hcnt ? cnt - i - 1 : i;
            ht = patt[ri % pattlen];
            htr = i > hcnt ? inv[ht] : (i == hcnt ? ht + 4 : ht);
            translate(v = [dist * i, 0, 0])
            snap_hinge_arm(htr, clear, [arm, bump]);
        }
    }
}

// Calculate max amout of arms on a hinge.
function hinge_max_arms(size, thick, clear, bumpheigt) =
    1 + floor((size - (2 * thick + clear)) / (2 * thick + clear + bumpheigt));

/***********************************************************************/

$fn = 20;

bump = [2, 0.4, 38]; // dia, height, ang
arm = [3, 1, 0, 9];  // height, thick, extra, esides
dim = [20, 8, 0.1];  // len, hinges(>=2), clear, 0:male 1:female 2:reverable
patt = [0, 1];  // 0:bump-norm 1:bump-rev 2:dimp-norm 3:dimp:rev
hinge = [dim, patt, arm, bump];

snap_hinge(hinge, 0);
translate(v = [0, 5, 0])
snap_hinge(hinge, 1);
