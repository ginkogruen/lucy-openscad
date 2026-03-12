// Gleam's mascot Lucy in three dimensions.
//
// Branding colors are taken from:
// https://gleam.run/branding/

rotate(90, [1,0,0])
union() {
	color("#151515")
	minkowski() {
		sphere(25);
		linear_extrude(height = 50, center = true, convexity = 10, twist = 0, slices = 20, scale = 1.0) 
		lucy_outline();
	}

	color("#ffaff3")
	linear_extrude(height = 100, center = true, convexity = 10, twist = 0, slices = 20, scale = 1.0) 
	lucy_body();

	color("#151515")
	minkowski() {
		sphere(25);
		linear_extrude(height = 60, center = true, convexity = 10, twist = 0, slices = 20, scale = 1.0) 
		lucy_face();
	}
}


// Body of Lucy
module lucy_body() {
	import("../assets/lucy-body.svg");
}

// Outline of Lucy
module lucy_outline() {
  import("../assets/lucy-outline.svg");
}

// Face of Lucy
module lucy_face() {
	import("../assets/lucy-face.svg");
}
