// y_motor end
// Author: sdavi


include <../configuration.scad>
include <../dimensions.scad>

nema_arm_height = 10;
nema_mount_width = nema17_holes+11;
 

y_block_length = y_bearing_block_width/2+xy_bearing_distance+belt_bearing[1]/2+nema_mount_width+20;
y_block_width = y_bearing_block_length; 
y_block_height = 4;


lid_thickness = y_block_height+min_beltbearing_height/2-y_bearing[0]/2-3;

echo("block length:", y_block_length);
echo("block width:", y_block_width);
echo("block height:", y_block_height);

echo("Total Height:", y_block_height*2+min_beltbearing_height);


//translate([5,0,0])frame_spacer();
//mirror([1,0,0])frame_spacer();

//translate([5,0,0]) y_motor_end_top();
//mirror([1,0,0])y_motor_end_top();

//translate([5,0,0]) y_motor_end_bottom();
//mirror([1,0,0])y_motor_end_bottom();







//calculate positions for bearings and motor
nema_center=[	y_block_width-nema_mount_width/2,
				y_block_length-nema_mount_width/2, 
				0];

inner_bearing_pos = [	y_block_width-nema_mount_width/2+GT2_pulley_geared_diameter/2+(GT2_belt_thickness-GT2_belt_tooth_height)+belt_bearing[2]/2, 
						y_bearing_block_width/2+xy_bearing_distance, 
						0];

outer_bearing_pos = [	inner_bearing_pos[0]-end_belt_bearing_distance, 
						inner_bearing_pos[1]-5, 
						0 ];

tension_bearing_start_pos = [nema_center[0],nema_center[1]- (nema_center[1]-outer_bearing_pos[1])/2,0];//starting position = max tension
h=tension_bearing_start_pos[1]*(((nema_center[0]-GT2_pulley_geared_diameter/2)-(outer_bearing_pos[0]-belt_bearing[2]/2))/2)/(nema_center[1]-outer_bearing_pos[1]);//distance from top of gt2 pulley which provides no tension
echo(h);
tension_bearing_end_pos = [nema_center[0]- GT2_pulley_geared_diameter/2-h-belt_bearing[1]/2,nema_center[1]- (nema_center[1]-outer_bearing_pos[1])/2,0]; // end position= no tension on belt

echo(tension_bearing_end_pos);
echo(tension_bearing_start_pos);

module y_motor_end_top(){

	difference(){
		y_motor_end();
		cube([y_block_width+0.2,y_block_length,y_block_height*2+min_beltbearing_height-lid_thickness]);

	}

}

module y_motor_end_bottom(){
	intersection(){
		y_motor_end();
		cube([y_block_width+0.2,y_block_length,y_block_height*2+min_beltbearing_height-lid_thickness]);

	}
}



module frame_spacer(){

	difference(){

		union(){
			difference(){
				cube_fillet([y_block_width,y_block_length,frame_spacer_height], vertical=[3,3,3,3]);
				//corner
				cube([20,20,frame_spacer_height]);
				//cutout
				translate([20,20,0]) cube([y_block_width, y_block_length, frame_spacer_height]);
			}

			linear_extrude(height=frame_spacer_height,center=false,convexity=10, twist=0)
				polygon( points=[[20,20],[40,20],[20,50]] );		

			
		}
	
		frame_screws();

		//bearing inner
		translate(inner_bearing_pos)  
			cylinder(d=m4_washer_diameter, h=5, $fn=60);
		//bearing outer
		translate(outer_bearing_pos)  
			cylinder(d=m4_washer_diameter, h=5, $fn=60);
		
		//adjustable tension bearing
		translate([0,tension_bearing_start_pos[1],0]){
			translate([tension_bearing_end_pos[0],0,0]) 
				cylinder(d=m4_washer_diameter, h=5, $fn=60);
		}

	}
	

}


module y_motor_end(){

	difference(){
		base();

		//y rod hole	
		translate([y_block_width-11.5,y_bearing_block_width/2, y_block_height+min_beltbearing_height/2])
			rotate([0,90,0]) cylinder(d=y_bearing[0]+0.2, h=13, $fn=30);

		bearing_holes();
		nema17_holes();
		frame_screws();

	}//end difference
}

module base(){
	difference(){
		union(){
			
			cube_fillet([y_block_width,y_block_length,y_block_height], vertical=[3,3,3,3]);//bottom
			translate([0,0,y_block_height+min_beltbearing_height])
				cube_fillet([y_block_width,y_block_length,y_block_height], vertical=[3,3,3,3]);//top

			
			//Y rod block
			cube_fillet([y_block_width, y_bearing_block_width, min_beltbearing_height+y_block_height], vertical=[3,3,3,3]);
			//nema mount support	
	
			//back support/frame mount
			cube_fillet([20, y_block_length, min_beltbearing_height+y_block_height], vertical=[3,3,3,3]);
	
			//corner support block
			translate([0, y_block_length-20, 0]) cube_fillet([y_block_width,20,min_beltbearing_height+y_block_height], vertical=[3,3,3,3]);
			
			//support block near middle front
			translate([y_block_width-10, inner_bearing_pos[1]+belt_bearing[1]/2+10, 0]) cube_fillet([10, y_block_length-inner_bearing_pos[1]-belt_bearing[1]/2-10, min_beltbearing_height+y_block_height], vertical=[3,3,3,3]);
	
			//
	
		}//end union

		//front side nema cutaway
		translate([y_block_width-nema_mount_width/2, y_block_length-20, min_beltbearing_height+y_block_height-(nema17_holes-11)/2]){
			rotate([-90,0,0]) cylinder(d=nema17_holes-11, h=20, $fn=30);
			translate([-(nema17_holes-11)/2, 0, 0])cube([20, (nema17_holes-11),(nema17_holes-11)/2]);
		}

		//side nema cutaway
		translate([y_block_width-15, y_block_length-nema_mount_width/2, min_beltbearing_height+y_block_height-(nema17_holes-11)/2]){
			rotate([-90,0,-90]) cylinder(d=nema17_holes-11, h=20, $fn=30);
			translate([-10, -(nema17_holes-11)/2, 0])cube([25, (nema17_holes-11),(nema17_holes-11)/2]);
		}

		//corner cutaway
		cube([20,20,min_beltbearing_height+y_block_height*2]);

		//tension bearing side cutaway
		translate([0, y_block_length-20-40, y_block_height])
			cube([20, 40, min_beltbearing_height]);

		//outter bearing cutaway
		translate([0,20,y_block_height]) cube([20, 10, min_beltbearing_height]);

	}//end difference
}



module frame_screws(){
	// frame mount screw holes
		translate([10,37,0]) cylinder(d=frame_screw, h=min_beltbearing_height+y_block_height*2);
		translate([10,y_block_length-10, 0]) cylinder(d=frame_screw, h=min_beltbearing_height+y_block_height*2);
		translate([18+(y_block_width-20)/3, 10,0]) cylinder(d=frame_screw, h=min_beltbearing_height+y_block_height*2);
		color("red")translate([18+2*(y_block_width-20)/3+5, 10,0]) cylinder(d=frame_screw, h=min_beltbearing_height+y_block_height*2);
}


module bearing_holes(){
	//belt bearing holes

	//bearing inner
	translate(inner_bearing_pos)  cylinder(d=belt_bearing[0]+0.2, h=y_block_height*2+min_beltbearing_height, $fn=60);
	//bearing outer
	translate(outer_bearing_pos)  cylinder(d=belt_bearing[0]+0.2, h=y_block_height*2+min_beltbearing_height, $fn=60);
	//bearing outer padding space
	translate(outer_bearing_pos) translate([0,0,y_block_height]) cylinder(d=belt_bearing[1]*1.8, h=min_beltbearing_height, $fn=30);

	//adjustable tension bearing
	translate([0,tension_bearing_start_pos[1],0]){
		translate([tension_bearing_start_pos[0],0,0]) 
			cylinder(d=belt_bearing[0]+0.2, h=y_block_height*2+min_beltbearing_height, $fn=60);
		translate([tension_bearing_end_pos[0],0,0]) 
			cylinder(d=belt_bearing[0]+0.2, h=y_block_height*2+min_beltbearing_height, $fn=60);
		translate([tension_bearing_end_pos[0],-(belt_bearing[0]+0.2)/2,0])
			cube([tension_bearing_start_pos[0]-tension_bearing_end_pos[0],belt_bearing[0]+0.2, y_block_height*2+min_beltbearing_height]);


	}

}



module nema17_holes(){
	//nema17 placement

	//central hole for nema
	translate(nema_center){
		cylinder(d=24, h=min_beltbearing_height+y_block_height, $fn=60);
	
		//upper bigger central clearance hole
		translate([0,0,y_block_height]) cylinder(d=35, h=min_beltbearing_height, $fn=60);
	}

	translate([nema_center[0]-nema_mount_width/2,nema_center[1]-nema_mount_width/2,0]){
		//motor holes
		for(p=[[nema17_holes,0],[0, nema17_holes],[nema17_holes,nema17_holes]]){
			translate([p[0]+11/2, p[1]+11/2, 0]){
				cylinder(d=3.4, h=min_beltbearing_height+y_block_height*2, $fn=60);

			}
		}
	}


	




}