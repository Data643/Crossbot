// y-idler end
// Author: sdavi


include <../configuration.scad>
include <../dimensions.scad>



y_block_length = 60; //TODO: parametric?
y_block_width = 40; //TODO: parametric?
y_block_height = 4;

lid_thickness = y_block_height+min_beltbearing_height/2-y_bearing[0]/2-3;


echo("block length:", y_block_length);
echo("block width:", y_block_width);
echo("block height:", y_block_height);


//translate([5,0,0])frame_spacer();
//mirror([1,0,0]) frame_spacer();

//translate([5,0,0]) y_idler_end_top();
//mirror([1,0,0])y_idler_end_top();

//translate([5,0,0])y_idler_end_bottom();
//mirror([1,0,0])y_idler_end_bottom();



idler_end_belt_bearing_distance = 18; 




//calculate positions for bearings and motor


inner_bearing_pos = [	13, 
							y_bearing_block_width/2+xy_bearing_distance, 
							0];

outer_bearing_pos = [	inner_bearing_pos[0]+idler_end_belt_bearing_distance, 
							inner_bearing_pos[1]-5, 
							0 ];


module y_idler_end_top(){

	difference(){
		y_idler_end();
		cube([	y_block_width+0.2,
				y_block_length,
				y_block_height*2+min_beltbearing_height-lid_thickness]);

	}

}

module y_idler_end_bottom(){
	intersection(){
		y_idler_end();
		cube([	y_block_width+0.2,
				y_block_length,
				y_block_height*2+min_beltbearing_height-lid_thickness]);

	}
}


module frame_spacer(){

	difference(){

		union(){
			difference(){
				cube_fillet([y_block_width,y_block_length,frame_spacer_height], vertical=[3,3,3,3]);
				//corner
				translate([y_block_width-20, 0,0])cube([20,20,frame_spacer_height]);
				
			

				//cutout
				translate([0,20,0]) cube([20, y_block_length, frame_spacer_height]);
			}
			
			linear_extrude(height=frame_spacer_height,center=false,convexity=10, twist=0)
				polygon( points=[[0,20],[20,20],[20,40]] );		
		}

		frame_screws();//
		
		//bearing inner screw head
		translate(inner_bearing_pos)
		  	cylinder(d=m4_washer_diameter, h=5, $fn=60);
		//bearing outer screw head
		translate(outer_bearing_pos)
		  	cylinder(d=m4_washer_diameter, h=5, $fn=60);

	

		//add an extra screw in the corner piece
		translate([10,10,0]){
		 	cylinder(d=frame_screw, h=frame_spacer_height, $fn=60);
			//space for head of screw //work out screw length
			cylinder(d=9.5, h=frame_spacer_height-5, $fn=60);//m5x10;
		
		}
		
		

		
	}
	

}



module y_idler_end(){

	difference(){
		union(){
			base();

			//illustration
			%color("green")translate(inner_bearing_pos)translate([0,0,y_block_height])  
				cylinder(d=belt_bearing[1], h=belt_bearing[2], $fn=60);
			%color("green")translate(outer_bearing_pos)translate([0,0,y_block_height])  
				cylinder(d=belt_bearing[1], h=belt_bearing[2], $fn=60);		

		}//end union

		
		//y rod hole	
		translate([-0.1,y_bearing_block_width/2, y_block_height+min_beltbearing_height/2])
			rotate([0,90,0]) cylinder(d=y_bearing[0]+0.2, h=y_block_width+0.2, $fn=60);

		bearing_holes();
		frame_screws(d=frame_screw);

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
		
			//innter bearing corner
			translate([0,y_block_length-19, 0])
				cube_fillet([inner_bearing_pos[0]-belt_bearing[0]/2,19, min_beltbearing_height+y_block_height*2], vertical=[3,3,3,3]);

			hull(){
				//outer bearing support block, middle of vslot
				translate([y_block_width-10, y_block_length-19+(frame_screw+4)/2, 0])
					cylinder(d=frame_screw+4, h=min_beltbearing_height+y_block_height*2, $fn=60);
				translate([y_block_width-10-5/2, y_block_length-1, 0])	
					cube([5,1,min_beltbearing_height+y_block_height*2]);
			}			


		}//end union

		//corner cutaway
		translate([y_block_width-20,0,0])
			cube([20,20,min_beltbearing_height+y_block_height*2]);
		
		// frame mount screw holes
		//outter bearing hole
;
		//frame mount under y_rod hole
		translate([-.01,y_bearing_block_width/2, (y_block_height+min_beltbearing_height/2-y_bearing[0]/2)/2])
			rotate([0,90,0]) cylinder(d=frame_screw, h=y_block_width+0.2, $fn=60);

		//m3 screw for corner
		translate([(inner_bearing_pos[0]-belt_bearing[0]/2)/2,y_block_length-19/2, 0])
			cylinder(d=M3, h=min_beltbearing_height+y_block_height*2, $fn=60);

	}//end difference
}


module frame_screws(d=frame_screw){
	translate([y_block_width-10, y_block_length-19+(frame_screw+4)/2, 0])
			cylinder(d=d, h=min_beltbearing_height+y_block_height*2, $fn=60);
}

module bearing_holes(){
	//belt bearing holes

	//bearing inner
	translate(inner_bearing_pos){
	  	cylinder(d=belt_bearing[0], h=y_block_height*2+min_beltbearing_height, $fn=60);
		//bearing outer padding space
		translate([0,0,y_block_height]) 
			cylinder(d=belt_bearing[1]*1.8, h=min_beltbearing_height, $fn=30);
	}
	//bearing outer
	translate(outer_bearing_pos){
	  	cylinder(d=belt_bearing[0], h=y_block_height*2+min_beltbearing_height, $fn=60);
	}

}



