// X-Carriage
// Author: sdavi


//Inspired from Aggressive's carriage: http://www.thingiverse.com/thing:150237

include <../configuration.scad>


x_bearing_block_length = x_bearing[2]*2 + 1.5 + 8;
x_bearing_block_width = x_bearing[1]+5+5;//5 for space for zipties
x_bearing_block_height = 12;

carriage_width=x_bearing_block_length;
carriage_length = x_bearing_block_width+x_rod_distance;

echo("Carriage Width: ", carriage_width);
echo("Carriage Length: ", carriage_length);

max_height = 20; //max height 
x_rod_height = 13.5;


padding = 2.5; // belt padding

flange_thickness=1.1; //thickness of flange on bearing

mount_screw_distance = 30;
center_thickness=17;


//clamp screws use 15mm or 20mm length

//x_carriage_clamps();
//x_carriage();
//%illustration();


module x_carriage(){

	difference(){
		x_carriage_main();
		translate([-0.1, x_bearing_block_width/2+x_rod_distance/2-min_beltbearing_height/2-padding-0.1, x_rod_height+GT2_belt_thickness/2-(GT2_belt_thickness-GT2_belt_tooth_height)+0.1])cube([11+0.2, min_beltbearing_height+padding*2+0.2, 20]);
		translate([x_bearing_block_length-11, x_bearing_block_width/2+x_rod_distance/2-min_beltbearing_height/2-padding-0.1, x_rod_height+GT2_belt_thickness/2-(GT2_belt_thickness-GT2_belt_tooth_height)+0.1])cube([11, min_beltbearing_height+padding*2+0.2, 20]);
	}

}

module x_carriage_clamps(){
	difference(){
		intersection(){
			x_carriage_main();
			union(){
				translate([-0.1, x_bearing_block_width/2+x_rod_distance/2-min_beltbearing_height/2-padding, x_rod_height+GT2_belt_thickness/2-(GT2_belt_thickness-GT2_belt_tooth_height)+0.1])cube([11, min_beltbearing_height+padding*2, 20]);
				translate([x_bearing_block_length-11, x_bearing_block_width/2+x_rod_distance/2-min_beltbearing_height/2-padding, x_rod_height+GT2_belt_thickness/2-(GT2_belt_thickness-GT2_belt_tooth_height)+0.1])cube([11, min_beltbearing_height+padding*2, 20]);
			}
		}
	
		//cut short edge to let belt go through so doesnt need to be exact length
		translate([11-2, x_bearing_block_width/2+x_rod_distance/2-min_beltbearing_height/2-padding, x_rod_height-GT2_belt_thickness/2])cube([4, 40, 20]);

		translate([x_bearing_block_length-11-0.1, x_bearing_block_width/2+x_rod_distance/2-min_beltbearing_height/2-padding, x_rod_height-GT2_belt_thickness/2])cube([2.8, 40, 20]);



	}

}


module illustration(){
	color("green")translate([4+1.5/2,x_bearing_block_width/2,x_rod_height]) 
		rotate([90,0,90])
			cylinder(d=x_bearing[1], h=x_bearing[2]*2,$fn=50); //bottom
	color("green")translate([4+1.5/2,x_bearing_block_width/2+x_rod_distance,x_rod_height]) 
		rotate([90,0,90])
			cylinder(d=x_bearing[1], h=x_bearing[2]*2,$fn=50);//top
	//rods
	color("red")translate([-10,x_bearing_block_width/2,x_rod_height]) 
		rotate([90,0,90])
			cylinder(d=x_bearing[0], h=carriage_width+20,$fn=50); //bottom
	color("red")translate([-10,x_bearing_block_width/2+x_rod_distance,x_rod_height]) 
		rotate([90,0,90])
			cylinder(d=x_bearing[0], h=carriage_width+20,$fn=50);//top



	
	color("gray") translate([-10, x_bearing_block_width/2+x_rod_distance/2-min_beltbearing_height/2+m4_washer_thickness+flange_thickness, x_rod_height-GT2_belt_thickness/2])
		cube([20, GT2_belt_width, GT2_belt_thickness]); //belt low
	color("gray") translate([-10, x_bearing_block_width/2+x_rod_distance/2+min_beltbearing_height/2-m4_washer_thickness-belt_bearing[2]+flange_thickness, x_rod_height-GT2_belt_thickness/2])
		cube([20, GT2_belt_width, GT2_belt_thickness]); //belt high



		

}


module x_carriage_base() {

	union(){

		hull(){
			//bottom bearing block
			translate([carriage_width/2-x_bearing_block_length/2,0,0 ])
				cube([x_bearing_block_length, x_bearing_block_width, x_bearing_block_height]);	
			//top bearing block
			translate([carriage_width/2-x_bearing_block_length/2,x_rod_distance,0 ])
				cube([x_bearing_block_length, x_bearing_block_width, x_bearing_block_height]);	
			//center
			translate([0, carriage_length/2-8, 0])cube([carriage_width, 16, center_thickness]);

		}
		//extra thickness for clamps
		translate([0, x_bearing_block_width/2+x_rod_distance/2-min_beltbearing_height/2-padding, x_rod_height-GT2_belt_thickness/2])cube([11, min_beltbearing_height+padding*2, 20]);
		translate([x_bearing_block_length-11, x_bearing_block_width/2+x_rod_distance/2-min_beltbearing_height/2-padding, x_rod_height-GT2_belt_thickness/2])cube([11, min_beltbearing_height+padding*2, 20]);

	}//end union
}

module screw_holes(){
	//mount screws
	translate([carriage_width/2, carriage_length/2, 0]){
		for(x=[30, -30]){
			//30mm Extruder mounting holes
 				translate([x/2,0,0]) cylinder(r=1.7, h=20, $fn=32);
			translate([x/2,0,11]) cylinder(r=3.3, h=20, $fn=6); 
		}
	}


	//accessories holes 
	for(x=[carriage_width/2-25/2, carriage_width/2+25/2]){
		translate([x,carriage_length+1.5,8]) cylinder(r=1.7+2, h=20, $fn=32);
  			translate([x,carriage_length+1.5,0]) cylinder(r=1.7, h=20, $fn=32);
	}
}

module x_bearing_holes(){
	//bottom bearing hole
	translate([4,x_bearing_block_width/2,x_rod_height]) rotate([90,0,90])
		cylinder(d=x_bearing[1], h=x_bearing[2]*2 + 1.5 ,$fn=50);
	//top bearing hole
	translate([4,x_bearing_block_width/2+x_rod_distance,x_rod_height]) 
		rotate([90,0,90])
			cylinder(d=x_bearing[1], h=x_bearing[2]*2 + 1.5 ,$fn=50);

	//retainers
	translate([-0.1,x_bearing_block_width/2,x_rod_height]) 
		rotate([90,0,90])
			cylinder(d=x_bearing[0]+(x_bearing[1]-x_bearing[0])/2, h=carriage_width+0.2, $fn=50);
	translate([-0.1,x_bearing_block_width/2+x_rod_distance,x_rod_height]) 
		rotate([90,0,90])
			cylinder(d=x_bearing[0]+(x_bearing[1]-x_bearing[0])/2, h=carriage_width+0.2, $fn=50);

	//cut overhang on retainers
	color("yellow")translate([0,x_bearing_block_width/2-(x_bearing[0]+(x_bearing[1]-x_bearing[0])/2)/2,x_rod_height]) 
		cube([carriage_width, x_bearing[0]+(x_bearing[1]-x_bearing[0])/2,10]);
	color("yellow")translate([0,x_bearing_block_width/2+x_rod_distance-(x_bearing[0]+(x_bearing[1]-x_bearing[0])/2)/2,x_rod_height]) 
		cube([carriage_width, x_bearing[0]+(x_bearing[1]-x_bearing[0])/2,10]);
}

module belt_holder(){
	//cutout for Belt Holder
	belt_padding = 1;
	//belt low
	bl_bottom = x_bearing_block_width/2+x_rod_distance/2-min_beltbearing_height/2+m4_washer_thickness+flange_thickness;
	bl_top = bl_bottom+GT2_belt_width;
	//belt high
	bh_bottom = x_bearing_block_width/2+x_rod_distance/2+m4_washer_thickness+flange_thickness;
	bh_top = bh_bottom+GT2_belt_width;


	//belts left
	 translate([-1, bl_bottom-belt_padding, x_rod_height-GT2_belt_thickness/2])
		belt(len=10, width=GT2_belt_width+belt_padding*2, top=0);//belt low
	 translate([-1, bh_bottom-belt_padding, x_rod_height-GT2_belt_thickness/2])
		belt(len=10, width=GT2_belt_width+belt_padding*2, top=10); //belt high
	

	//belts right
	translate([x_bearing_block_length-10, bl_bottom-belt_padding, x_rod_height-GT2_belt_thickness/2])
		belt(len=10, width=GT2_belt_width+belt_padding*2, top=0);//belt low
	 translate([x_bearing_block_length-10, bh_bottom-belt_padding, x_rod_height-GT2_belt_thickness/2])
		belt(len=10, width=GT2_belt_width+belt_padding*2, top=0); //belt high

	
	//clamp screws
	for(x=[4.5, carriage_width-4.5]){
		
		//clampscrew holes and nut traps
		translate([x,(bl_top+bh_bottom)/2,0]) {
			cylinder(r=1.7, h=20, $fn=32);//middle screw
			cylinder(r=3.3, h=max_height-15+3, $fn=6);//nut trap
		}
		translate([x, ((x_bearing_block_width/2+x_rod_distance/2+min_beltbearing_height/2+2)+bh_top)/2,0 ]){
		cylinder(r=1.7, h=20, $fn=32);//top
		cylinder(r=3.3, h=max_height-15+3, $fn=6); //nut trap
	}
		translate([x, ((x_bearing_block_width/2+x_rod_distance/2-min_beltbearing_height/2-3)+bl_bottom)/2,0 ]){	
			cylinder(r=1.7, h=20, $fn=32);//bottom
			cylinder(r=3.3, h=max_height-15+3, $fn=6);//nut trap
		}
	}
 
}


module zipties(){
	// Ziptie cutouts

	for(y=[x_bearing_block_width/2, x_bearing_block_width/2+x_rod_distance]){
		for ( i = [0 : 1] ){
	  		translate([3+x_bearing[2]*i,y,x_rod_height-1.5])
				difference(){
		   			union(){
	    				translate([x_bearing[2]/4,0,0]) 
							rotate([90,0,90]) cylinder(h=4, r=12.5, $fn=50);
	    				translate([3*x_bearing[2]/4,0,0])
							rotate([90,0,90]) cylinder(h=4, r=12.5, $fn=50);
	  			 	}
	  		 		rotate([90,0,90]) cylinder(h=24, r=10, $fn=50);
		 		}
		}
	}

}



module belt(len, width, top = 0){

	belt_thickness = GT2_belt_thickness-GT2_belt_tooth_height;
	tooth_height = 2;

    if (top == 1) {
		translate([0, 0, 0]) maketeeth(len=len, width=width);
    	cube([ len + 0.02, width,belt_thickness]);
    
    } else {
	   translate([0, 0, GT2_belt_thickness-2]) maketeeth(len=len, width=width);
		translate([0,0,GT2_belt_tooth_height])
 		   	cube([ len + 0.02, width,belt_thickness]);

	}
}


module maketeeth(len, width, tooth_height=2){
    for (i = [0:len/GT2_belt_pitch]) {
		translate([i*GT2_belt_pitch,0,0]) 
			cube([GT2_belt_pitch*GT2_belt_tooth_ratio, width, tooth_height], center = false);
    }
}



module x_carriage_corners(){

	cut_len=4;
	points=[
		[cut_len, 0],
		[carriage_width-cut_len,0],
		[carriage_width,cut_len],
		[carriage_width, carriage_length-cut_len],
		[carriage_width-cut_len, carriage_length],
		[cut_len, carriage_length],
		[0,carriage_length-cut_len],
		[0, cut_len]
	];
	linear_extrude(height=max_height, center=false, convexity=10, twist=0) polygon( points );


}

module accessory_mounts(){
	for(x=[carriage_width/2-25/2, carriage_width/2+25/2]){
    	difference() {
      		// Top accessory mounting holes
      		translate([x,carriage_length+1.5,0]) cylinder(r=1.7+2, h=8, $fn=32);
      		translate([x,carriage_length+1.5,0]) cylinder(r=1.7, h=20, $fn=32, center=true);
   		 }
	}
}


module x_carriage_main(){
	union(){
		difference(){
			intersection(){
				x_carriage_base();
				x_carriage_corners();
			}

			x_bearing_holes();
			zipties();
			belt_holder();
			screw_holes();
 		}
 		
		accessory_mounts();

		//thin layer to avoid suports on clamp nut traps - drill out
		translate([0, x_bearing_block_width/2+x_rod_distance/2-min_beltbearing_height/2-padding, max_height-15+3])cube([10, min_beltbearing_height+padding*2, 0.1]);
		translate([x_bearing_block_length-10, x_bearing_block_width/2+x_rod_distance/2-min_beltbearing_height/2-padding, max_height-15+3])cube([10, min_beltbearing_height+padding*2, 0.1]);	
	}
}











