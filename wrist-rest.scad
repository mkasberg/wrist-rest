/*
A (Parametric) Keyboard Wrist Rest
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
length = 440;

// Radius of the rounded front corners
corner_radius = 4;


module wrist_rest() {
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

difference() {
  wrist_rest();
  corner_cut();
  translate([length, 0, 0]) rotate([0, 0, 90]) corner_cut();
}
