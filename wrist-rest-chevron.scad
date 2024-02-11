/*
A (Parametric) Keyboard Wrist Rest
with a Chevron Design
by Mike Kasberg

Default size optimized for WASD tenkeyless keyboards.

Tip: Print upside down for a smooth top and slightly rough/grippy bottom!

Use your slicer to cut for printing if needed.
https://help.prusa3d.com/article/cut-tool_1779
*/

// COMMON LENGTHS:
// 61-key      290
// Tenkeyless  360
// Full        440


// The height of the front of the wrist rest.
front_height =10;
// The height of the back of the wrist rest. Typically slightly larger than front height.
back_height = 18;
// The depth (front to back) of the wrist rest.
depth = 80;
// The length of the wrist rest in the longest direction.
length = 360;

// Radius of the rounded front corners.
corner_radius = 4;

// How far from the left to inset the design.
design_inset = 125;

// Extra cut on the right sie for smaller printers. 
extra_cut_inset = 290;

// Depth tolerance for connecting pins.
pin_depth_tolerance = 4;

// Size tolerance for connecting pins.
pin_size_tolerance = 0.4;

module base_shape() {
  translate([length, depth, 0]) rotate([0, 0, -90]) rotate([90, 0, 0]) {
    linear_extrude(height = length) {
      polygon([[0, 0], [depth, 0], [depth, front_height], [0, back_height]]);
    }
  }
}

module corner_cut() {
  difference() {
    translate([0, 0, (back_height / 2)])
      cube([2 * corner_radius, 2 * corner_radius, back_height + 2], center = true);
    translate([corner_radius, corner_radius, -1.1])
      cylinder(h = back_height + 2.2, r = corner_radius, $fn=64);
  }
}

module wrist_rest() {
  difference() {
    base_shape();
    corner_cut();
    translate([length, 0, 0]) rotate([0, 0, 90]) corner_cut();
  }
}

module pin(is_male=true) {
  if (is_male) {
    rotate([45, 0, 0]) cube([20, 4, 4]);
  } else {
    rotate([45, 0, 0])
      translate([0, -pin_size_tolerance / 2, -pin_size_tolerance / 2])
      cube([20, 4 + pin_size_tolerance, 4 + pin_size_tolerance]);
  }
}

module cutter(is_male = true) {
  translate([-300, depth/2, -1]) cylinder(h=back_height + 2, r = 300, $fn=6);
  
  tolerance = is_male ? 0 : pin_depth_tolerance;
  translate([-10 - depth/6 + tolerance, depth / 3, (front_height - 4/cos(45))/2])
    pin(is_male);
 
  translate([-10 - depth/6 + tolerance, 2 * depth / 3, (front_height - 4/cos(45))/2])
    pin(is_male);
}


intersection() {
  wrist_rest();
  translate([design_inset, 0, 0]) cutter(true);
}

translate([10, 0, 0]) intersection() {
  difference() {
    wrist_rest();
    translate([design_inset, 0, 0]) cutter(false);
  }
  translate([design_inset + depth / 6, 0, 0]) cutter(true);
}

translate([20, 0, 0]) intersection() {
  difference() {
    wrist_rest();
    translate([design_inset + depth / 6, 0, 0]) cutter(false);
  }
  translate([design_inset + depth / 6 + depth / 8, 0, 0]) cutter(true);
}

translate([30, 0, 0]) intersection() {
  difference() {
    wrist_rest();
    translate([design_inset + depth / 6 + depth / 8, 0, 0]) cutter(false);
  }
  translate([design_inset + 2 * depth / 6 + depth / 8, 0, 0]) cutter(true);
}
translate([40, 0, 0]) intersection() {
  difference() {
    wrist_rest();
    translate([design_inset + 2 * depth / 6 + depth / 8, 0, 0]) cutter(false);
  }
  translate([extra_cut_inset, 0, 0]) cutter(true);
}

translate([50, 0, 0]) difference() {
  wrist_rest();
  translate([extra_cut_inset, 0, 0]) cutter(false);
}
