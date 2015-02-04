// Endstop Holder for ReprapDiscount Hall-effect Endstop
// Author: sdavi 

include <configuration.scad>
include <dimensions.scad>

include <lib/endstop_holder.scad>

switch_length = 27;
switch_width = 10.5;
switch_holes = [5, 22]; //17mm spacing


endstop_holder(diameter=12);
translate([17,0,9]) magnetHolder();

magnet_d = 4; //magnet diameter
magnet_h = 2; //magnet height

length = 16;
height = magnet_h + 5;
width = magnet_d*2;


//magnet holder for t/v-slot
module magnetHolder(){

		difference(){
			union(){
				hull(){
					translate([10,8,-9])cylinder(d=15, h=10, $fn=60);
					translate([0,-length/2-0.5,-9])cube([width, length, 10]);
				}
				translate([width/2,0,0]) magnetbase();			
			}
			translate([10,8,-9+3])cylinder(d=10.5, h=10, $fn=60);
			translate([10, 8, -9.1]) cylinder(d=M5, h=20, $fn=30 );
	}
}


module magnetbase(){
	difference(){
			hull(){
	  		  	cube([width,length,.1], center=true);
	  	  		cylinder(r=magnet_d/2+2,h=height);
		}
		translate([0,0,height-magnet_h-0.1]) cylinder(r=magnet_d/2+0.2, h=magnet_h+0.1, $fn=60);
	}
}