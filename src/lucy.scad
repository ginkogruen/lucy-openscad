// Gleam's mascot Lucy in three dimensions.

// CONFIG ----------------------------------------------------------------------

// These variables are "safe" to change:

// Choose your favorite Lucy variants:
// Available variants: "default", happy", "sleep", "super", // TODO: Implement
lucy_variant = "default";

$fn = 20; // TODO: Change back to 100 - 200

// Branding colors are taken from:
// https://gleam.run/branding/
pink = "#ffaff3";
black = "#151515";

outer_circle_rad = 10; // Circle touching the outer vertices of the star (controls size)
inner_circle_rad = outer_circle_rad * (0.5 + (0.1 / 3)); // Circle touching the inner vertices

position_upright() {
  // Lucy Face
  color(black)
    extruded_face();
  // Star Body
  color(pink)
    minkowski() {
      // Sphere for slight rounding via `minkowski()`
      sphere(0.02 * outer_circle_rad);
      // Round Lucy from above via cylinder
      intersection() {
        mirror_copy(v=[0, 0, 1]) {
          extruded_lucy();
        }
        mirror_copy(v=[0, 0, 1]) {
          rounding_cylinder();
        }
      }
    }
}

module extruded_face() {
  linear_extrude(height=0.14 * outer_circle_rad)
    lucy_face();
}

// Linear extrusion of the base 2D model to get it into 3D
module extruded_lucy(extrude_scale = 0.8) {
  linear_extrude(height=0.1 * outer_circle_rad, scale=extrude_scale)
    lucy_flat(num_rays=5);
}

module rounding_cylinder() {
  cylinder(h=0.125 * outer_circle_rad, r1=outer_circle_rad, r2=inner_circle_rad);
}

module position_upright() {
  translate([0, 0, outer_circle_rad * 0.8])
    rotate([0, -90, 90])
      children();
}

// Mirror object while retaining copy
module mirror_copy(v = [1, 0, 0]) {
  children();
  mirror(v) children();
}

// LUCY FLAT
module lucy_flat(
  num_rays = 5,
  // Amount of rounding applied to the ray tips (unlocks Flower Lucy)
  // Controls the position of the 'rounding circle' from (0.0: star center) to (1.0: ray tip)
  ray_rounding = 0.9,
  inner_vert_rounding = 1.3
) {
  ray_angle = 360 / num_rays;

  // From Wikipedia:
  // https://en.wikipedia.org/wiki/Distance_from_a_point_to_a_line#Line_defined_by_two_points
  function point_to_line_distance(point_a, point_b, distance_point) =
    let (
      numerator = abs(( (point_b[1] - point_a[1]) * distance_point[0]) - ( (point_b[0] - point_a[0]) * distance_point[1]) + (point_b[0] * point_a[1]) - (point_a[0] * point_b[1])),
      denominator = sqrt(pow(point_b[1] - point_a[1], 2) + (pow(point_b[0] - point_a[0], 2)))
    ) numerator / denominator;

  // Operator module for rotating all star rays to their current position by iterating
  module rotate_by_ray_angle(iterator) { rotate(iterator * ray_angle) children(); }

  // Lucy star with rounded corners but without rounded inner vertices
  for (i = [0:num_rays - 1]) {
    sine = sin(ray_angle / 2) * inner_circle_rad;
    cosine = cos(ray_angle / 2) * inner_circle_rad;

    hull() {
      rotate_by_ray_angle(iterator=i) {
        polygon(points=[[cosine, sine], [cosine, -sine], [0, 0]], paths=[[0, 1, 2]]);
        // Point fitting inside the triangle of a ray (at any distance from the origin)
        translate([outer_circle_rad * ray_rounding, 0])
          circle(point_to_line_distance(point_a=[cosine, sine], point_b=[outer_circle_rad, 0], distance_point=[outer_circle_rad * ray_rounding, 0]));
      }
    }
  }

  // Rounded corners for the inner vertices
  rotate(ray_angle / 2)for (i = [0:num_rays - 1]) {
    sine = sin(ray_angle / 2) * outer_circle_rad;
    cosine = cos(ray_angle / 2) * outer_circle_rad;

    difference() {
      // Triangle polygon
      rotate_by_ray_angle(iterator=i) {
        polygon(points=[[inner_circle_rad - 0.0001, 0], [cosine, sine], [cosine, -sine], [cosine, sine], [cosine, -sine]], paths=[[0, 1, 3, 4, 2]]);
      }

      // Triangle with curve
      hull() {
        rotate_by_ray_angle(iterator=i) {
          polygon(points=[[cosine - 0.01, sine], [cosine - 0.01, -sine], [cosine + outer_circle_rad, sine], [cosine + outer_circle_rad, -sine]], paths=[[0, 2, 3, 1]]);
          // Circle for rounding the inner vertices
          translate([inner_circle_rad * inner_vert_rounding, 0])
            circle(point_to_line_distance(point_a=[cosine, sine], point_b=[inner_circle_rad, 0], distance_point=[inner_circle_rad * inner_vert_rounding, 0]));
        }
      }
    }
  }
}

// LUCYS Face
module lucy_face() {
  lucy_mouth(){};
  lucy_eyes(){};
}

// LUCYS EYES
module lucy_eyes(
  // Variants: "default", "happy", "sleep"
  variant = "default"
) {
  // Single eye default variant
  module single_eye() {
    scale([1, 1, 0.8])
      translate([0, -outer_circle_rad * 0.30, 0.1 * outer_circle_rad])
        circle(outer_circle_rad * 0.09);
  }

  // Left and right eye
  mirror_copy(v=[0, 1, 0]) {
    single_eye();
  }
}

// LUCYS MOUTH
module lucy_mouth() {
  mouth_outer_circle = 0.1125 * outer_circle_rad;
  mouth_inner_circle = 0.025 * outer_circle_rad;
  mouth_height_ratio = 0.135 * outer_circle_rad;
  mouth_extrusion_height = 0.14 * outer_circle_rad;
  mouth_corner_circle = (mouth_outer_circle - mouth_inner_circle) / 2;

  // Helper circle for the rounded corners of Lucy's mouth
  module mouth_corner_circle() {
    translate([-mouth_height_ratio, mouth_inner_circle + mouth_corner_circle, 0])
      circle(mouth_corner_circle);
  }

  // Complete mouth
  // Left and right mouth corner circles
  mirror_copy(v=[0, 1, 0]) {
    mouth_corner_circle();
  }

  // U-shaped mouth
  difference() {
    // Circle with hole in the center forming the mouth
    translate(v=[-mouth_height_ratio, 0])
      difference() {
        circle(mouth_outer_circle);
        circle(mouth_inner_circle);
      }

    // Square used to cut away the upper half of the circle forming the mouth
    translate(v=[-mouth_height_ratio, -outer_circle_rad / 8, 0])
      square(size=outer_circle_rad / 4, center=false);
  }
}

// SVG IMPORTS -----------------------------------------------------------------

// Body of Lucy
module lucy_body() {
  import("../assets/lucy-body.svg", center=true);
}

// Outline of Lucy
module lucy_outline() {
  import("../assets/lucy-outline.svg", center=true);
}

// Face of Lucy
module lucy_svg_face() {
  import("../assets/lucy-face.svg", center=true);
}
