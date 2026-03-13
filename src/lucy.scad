// Gleam's mascot Lucy in three dimensions.
//
// Branding colors are taken from:
// https://gleam.run/branding/

//rotate(90, [1,0,0])
// union() {
// 	color("#151515")
// 	minkowski() {
// 		sphere(25);
// 		linear_extrude(height = 50, center = true, convexity = 10, twist = 0, slices = 20, scale = 1.0) 
// 		lucy_outline();
// 	}

// 	color("#ffaff3")
// 	linear_extrude(height = 100, center = true, convexity = 10, twist = 0, slices = 20, scale = 1.0) 
// 	lucy_body();

// 	color("#151515")
// 	minkowski() {
// 		sphere(25);
// 		linear_extrude(height = 60, center = true, convexity = 10, twist = 0, slices = 20, scale = 1.0) 
// 		lucy_face();
// 	}
// }

$fn=20;

color("#ffaff3")
minkowski() {
sphere(r = 0.5);
	union() {
			intersection() {
				// Extruded and centered Lucy
				linear_extrude(height = 5, center = true, convexity = 10, twist = 0, slices = 20, scale = 1.0) 
					translate(v = [-0.2,0.3,0]) 
						rotate(a = [0,0,-9]) 
							scale([0.02,0.02,0])
								lucy_body();

				// Squashed sphere, used to round Lucy
				scale([1,1,0.3])
					sphere(d = 15);
			}


}
}
		linear_extrude(height = 5, center = true, convexity = 10, twist = 0, slices = 20, scale = 1.0) 
			translate(v = [-0.2,0.3,0]) 
				rotate(a = [0,0,-9]) 
					scale([0.02,0.02,0])
						lucy_face();


// Body of Lucy
module lucy_body() {
	import("../assets/lucy-body.svg", center = true);
}

// Outline of Lucy
module lucy_outline() {
  import("../assets/lucy-outline.svg", center = true);
}

// Face of Lucy
module lucy_face() {
	import("../assets/lucy-face.svg", center = true);
}
