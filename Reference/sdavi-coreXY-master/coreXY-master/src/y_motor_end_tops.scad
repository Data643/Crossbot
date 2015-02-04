// y_motor end top
// Author: sdavi

include <lib/y_motor_end.scad>

translate([5,0,0]) y_motor_end_top();
mirror([1,0,0])y_motor_end_top();
