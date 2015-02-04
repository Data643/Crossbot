// z_ends
// Author: sdavi



include <configuration.scad>
include <dimensions.scad>


z_length = 70;
z_width = 55;
z_height = 15;

nema_mount_thickness = 10;
nema_mount_height = 30;


translate([z_length+8, 0,0]) bearing_mount();

translate([0, 8, 0])z_motor_end();
mirror([0,1,0]) z_motor_end();



module z_motor_end(){
	difference(){	
		union(){
			cube_fillet([z_length, z_width, z_height], vertical=[3,3,3,3]);
			cube_fillet([z_length, nema_mount_thickness, nema_mount_height], vertical=[0,0,3,3], top=[0,3,0,3]);
		}

		//cutout for frame
		translate([z_length-20, z_width-20, 0])cube([20,20,z_height]);

		//curved end
		translate([0,z_width, 0])cylinder(d=60, h=z_height, $fn=60);		

		//frame holes
		translate([z_length-10,-0.1,z_height/2 ])rotate([-90,0,0])cylinder(d=frame_screw, h=z_width+0.2, $fn=60);

		translate([0,z_width-10,z_height/2 ])rotate([-90,0,-90])cylinder(d=frame_screw, h=z_length, $fn=60);
		translate([0,z_width-10,z_height/2 ])rotate([-90,0,-90])cylinder(d=10.5, h=z_length-40, $fn=60);//countersink into round end



		//nema holes
		translate([13, -0.1, nema_mount_height-5.5]){
			rotate([-90,0,0]) 
				cylinder(d=M3, h=nema_mount_thickness+0.4, $fn=60);
			translate([nema17_holes, 0,0]) rotate([-90,0,0]) 
				cylinder(d=M3, h=nema_mount_thickness+0.2, $fn=60);
			translate([nema17_holes/2, 0, nema17_holes/2]) rotate([-90,0,0])
				cylinder(d=28, h=nema_mount_thickness+0.2, $fn=60);// central nema hole
		}

		
	}

}


module bearing_mount(){

	bearing_end_length=BEARING_6300[1]+8 + 15+15; 
	bearing_end_width=20;
	bearing_end_height=20;


	difference(){
		union(){
			translate([6+nema17_holes/2, 0,0]) 
				cylinder(d=BEARING_6300[1]+8, h=bearing_end_height, $fn=30);
			translate([0,-bearing_end_length/2,0])
				cube_fillet([bearing_end_width, bearing_end_length, bearing_end_height], vertical=[3,0,0,3]);
			
		}
	
		//center hole for rod
		translate([6+nema17_holes/2,0,0]) 
			cylinder(d=BEARING_6300[1]-3, h=bearing_end_height, $fn=30);
		
		//hole for bearing 6300z
		translate([6+nema17_holes/2,0,bearing_end_height-BEARING_6300[2]]) 
			cylinder(d=BEARING_6300[1]+0.4, h=BEARING_6300[2], $fn=30);
	
		//frame_holes
		translate([-0.1,-bearing_end_length/2+15/2, bearing_end_height/2]) 
			rotate([0,90,0])cylinder(d=frame_screw, h=bearing_end_width+0.2, $fn=30);
		translate([-0.1, bearing_end_length/2-15/2, bearing_end_height/2])
			rotate([0,90,0])cylinder(d=frame_screw, h=bearing_end_width+0.2, $fn=30);
		
	}

}


