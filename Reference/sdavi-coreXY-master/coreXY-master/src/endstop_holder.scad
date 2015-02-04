// Endstop Holder
// Author: sdavi

include <configuration.scad>
include <dimensions.scad>

include <lib/endstop_holder.scad>

switch_length = 20;
switch_width = 10.5;
switch_holes = [5, 15];


endstop_holder(diameter=8);
translate([30,0,0]) endstop_holder(8);
translate([-30,0,0]) endstop_holder(12);

