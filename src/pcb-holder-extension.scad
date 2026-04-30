//==============================================================================
// PCB Holder Extension
//==============================================================================
// Target: Standard PCB holders with ~200x140mm max PCB capacity
// Compatible with:
//   - Noah NH-11E (Amazon B0CY4DRHWK)
//   - Pro's Kit SN-390 (Adafruit 3791)
//
// Function: C-shaped channel that slips onto the arm horizontally from the
//           inner side (toward PCB center). The arm's protruding retainer
//           boss enters through the open outer face. Secured through the
//           original retainer-bolt hole. Extends the arm upward and provides
//           an identical boss + nut pocket at its top so the original
//           spring-loaded PCB bracket and hand screw remount on the extension.
//
// Coordinate system (single piece, "right arm" version):
//   +X = outer side  — OPEN; this is the side the extension slips on from
//   -X = inner side  — closed wall; faces PCB center; carries top boss
//   +Y = front       — closed wall; carries hand-screw through-hole
//   -Y = back        — closed wall; carries hand-screw nut pocket
//   +Z = up          — origin Z = 0 sits at the top face of the arm
//==============================================================================

//==============================================================================
// 1. TARGET HOLDER DIMENSIONS (measured)
//==============================================================================

render_mirrored_piece = false;

// Arm cross-section (tapers linearly bottom -> top over arm_height)
arm_x_bottom = 24;   // mm - "front view" width  (left-right, retainer bolt axis)
arm_x_top    = 16;
arm_y_bottom = 30;   // mm - "side view" width   (front-to-back, hand screw axis)
arm_y_top    = 20;
arm_height   = 80;   // mm

// Retainer-bolt hole on the arm
retainer_bolt_hole_d        = 5;     // mm
retainer_bolt_z_from_bottom = 65;    // mm - center of hole, from arm bottom
retainer_boss_od            = 15.8;  // mm - boss OD on the inner side face
retainer_boss_protrude      = 4;     // mm - how far the boss sticks toward center

// Hand screw (locks the retainer bolt; threads in from front-or-back face)
hand_screw_thread_d  = 3.85;  // mm - measured at thread crests
hand_screw_nut_af    = 7;     // mm - hex nut, across-flats (M4)
hand_screw_nut_thick = 3.0;   // mm - M4 hex nut typical axial thickness

//==============================================================================
// 2. EXTENSION PARAMETERS
//==============================================================================

extension_height = 40;   // mm - rise above arm top (parameter; tune as needed)
sleeve_depth     = 25;   // mm - how far the sleeve covers the arm from the top
wall_thickness   = 3;    // mm

// Trim length of the side walls (+Y, -Y) and the closed -X wall along the
// X axis. Shrinks the outer body width by this amount on the open (+X) side
// only so the -X wall position is preserved and the +X face moves inward.
wall_x_trim      = 4;    // mm

// Mirrors original arm: top mounting hole this far below extension top
top_bolt_offset_from_top = 15;

// Boss clearance: hole on the -X wall at lower_bolt_z that lets the arm's
// 15.8 mm boss seat fully through the wall. With wall_thickness < boss
// protrusion, this hole punches all the way through the -X wall.
boss_recess_clearance = 0.4;   // mm - added to OD for slip fit over boss

// Inside boss: cylindrical sleeve on the cavity side of the -X wall around
// the upper bolt hole. Mimics the round wall on the original arm interior —
// reinforces the bolt mount with 3 mm of wall material around the 4 mm hole.
inside_boss_od     = 10;    // mm - OD (3 mm wall around 4 mm bolt hole)
inside_boss_length = 10;     // mm - extent into cavity in +X direction

// Nut holder block: rectangular block adjacent to the inside cyl boss on
// the -Y side. Provides material for the hand-screw nut nook with floor +
// ceiling capture. Overlaps the cylindrical boss so they merge into one
// solid mass.
nut_holder_wall_thickness = wall_thickness;
nut_holder_x      = inside_boss_length;                                     // mm - X depth into cavity from -X cavity face
nut_holder_y_to   = -2;                                                     // mm - +Y extent (block runs from -Y inner wall to here)
nut_holder_z      = (nut_holder_wall_thickness * 2) + hand_screw_nut_af;    // mm - vertical height (centered on upper_bolt_z)

// Hand-screw nut nook (rectangular slot inside the nut holder block).
// Opens on +X so the nut is loaded through the open outer face during
// assembly. Floor and ceiling within the block capture the nut vertically;
// the slot's -Y wall backs up the nut when the screw is tightened.
nut_nook_x_clear  = 0.5;    // mm - radial clearance past hex AV
nut_nook_y_clear  = 0.4;    // mm - axial clearance past nut thickness
nut_nook_z_clear  = 0.2;    // mm - vertical clearance past hex AF
nut_nook_y_center = -6.0;     // mm - Y of nut center along hand-screw path

// Hand-screw blind hole: enters from -Y, ends just past the bolt axis.
// Does NOT punch through the +Y wall.
hand_screw_blind_overshoot = 0.5;   // mm past bolt axis (into inside boss material)

// External top boss is hollowed into a stubby tube so the PCB bracket's
// round peg can insert into it. Wall thickness is the radial material left
// between the inlet (ID) and the boss OD.
top_boss_wall = wall_thickness;   // mm - radial wall of the boss tube

//==============================================================================
// 3. TOLERANCES
//==============================================================================

surface_tolerance = 0.2;   // mm - per side, sleeve cavity vs arm
bolt_clearance    = 0.3;   // mm - oversize on bolt through-holes
nut_pocket_depth  = 3;     // mm - hex pocket depth
eps               = 0.01;  // mm - epsilon to avoid coincident faces

//==============================================================================
// 4. RENDER QUALITY
//==============================================================================

$fn = 64;
$fa = 0.5;
$fs = 0.1;

//==============================================================================
// 5. DERIVED DIMENSIONS
//==============================================================================

// Linear interpolation of arm width at a given height (z from arm bottom)
function arm_x_at(z) = arm_x_bottom + (arm_x_top - arm_x_bottom) * z / arm_height;
function arm_y_at(z) = arm_y_bottom + (arm_y_top - arm_y_bottom) * z / arm_height;

// Sleeve inner cavity = arm cross-section + tolerance per side
cavity_x_top = arm_x_top + 2 * surface_tolerance;
cavity_y_top = arm_y_top + 2 * surface_tolerance;
cavity_x_bot = arm_x_at(arm_height - sleeve_depth) + 2 * surface_tolerance;
cavity_y_bot = arm_y_at(arm_height - sleeve_depth) + 2 * surface_tolerance;

// Sleeve outer = cavity + wall on each side
sleeve_x_top = cavity_x_top + 2 * wall_thickness;
sleeve_y_top = cavity_y_top + 2 * wall_thickness;
sleeve_x_bot = cavity_x_bot + 2 * wall_thickness;
sleeve_y_bot = cavity_y_bot + 2 * wall_thickness;

// Upper body continues the arm taper rates above Z = 0.
// Base cavity dimensions match the sleeve cavity at its top (Z = 0) so the
// outer body dimensions match across the sleeve/upper body seam — making
// the exterior continuous (no visible step at Z = 0).
x_taper_rate = (arm_x_bottom - arm_x_top) / arm_height;
y_taper_rate = (arm_y_bottom - arm_y_top) / arm_height;

upper_x_base = arm_x_top + 2 * surface_tolerance;
upper_y_base = arm_y_top + 2 * surface_tolerance;
upper_x_topz = upper_x_base - x_taper_rate * extension_height;
upper_y_topz = upper_y_base - y_taper_rate * extension_height;

upper_outer_x_base = upper_x_base + 2 * wall_thickness;
upper_outer_y_base = upper_y_base + 2 * wall_thickness;
upper_outer_x_topz = upper_x_topz + 2 * wall_thickness;
upper_outer_y_topz = upper_y_topz + 2 * wall_thickness;

// Lower bolt hole Z (in extension coords; arm top at Z = 0; arm bolt 15 mm down)
lower_bolt_z = -(arm_height - retainer_bolt_z_from_bottom);  // = -15

// Upper bolt hole Z (mirrors arm geometry, measured from extension top)
upper_bolt_z = extension_height - top_bolt_offset_from_top;

// Upper-section cavity stops wall_thickness below the top to leave a solid
// roof. cap_inner_x/y are the cavity inner dimensions at that capped height.
cavity_top_z = extension_height - wall_thickness;
cap_inner_x  = upper_x_base + (upper_x_topz - upper_x_base) * (cavity_top_z / extension_height);
cap_inner_y  = upper_y_base + (upper_y_topz - upper_y_base) * (cavity_top_z / extension_height);

// Cavity inner dimensions at upper_bolt_z (linear interp from base to cap).
ub_z_frac      = upper_bolt_z / cavity_top_z;
cavity_x_at_ub = upper_x_base + (cap_inner_x - upper_x_base) * ub_z_frac;
cavity_y_at_ub = upper_y_base + (cap_inner_y - upper_y_base) * ub_z_frac + 1;

//==============================================================================
// 6. HELPER MODULES
//==============================================================================

// Centered tapered box: hull of two thin centered slabs at z_bot and z_top.
module tapered_box(x_bot, y_bot, x_top, y_top, z_bot, z_top) {
    hull() {
        translate([0, 0, z_bot])
            cube([x_bot, y_bot, eps], center = true);
        translate([0, 0, z_top])
            cube([x_top, y_top, eps], center = true);
    }
}

// Hex pocket along +Z, sized across-flats. cylinder($fn=6) is across-vertices,
// so scale by 1/cos(30) to get the desired across-flats dimension.
module hex_pocket(af, depth) {
    cylinder(d = af / cos(30), h = depth, $fn = 6);
}

//==============================================================================
// 7. COMPONENT MODULES
//==============================================================================

// C-shaped tapered channel over the arm top portion.
// Outer hull: Z = -sleeve_depth to Z = 0.
// Inner cavity is hollowed out AND extended outward in +X to remove the
// entire +X wall, leaving three walls (-X, +Y, -Y) plus the closed top cap.
// The arm and its protruding boss enter through the open +X side.
module sleeve_shell() {
    difference() {
        // Outer trimmed by wall_x_trim on the +X side (the open side).
        // Width is reduced and the body shifted -X by half the trim, keeping
        // the -X wall position unchanged.
        translate([-wall_x_trim / 2, 0, 0])
            tapered_box(sleeve_x_bot - wall_x_trim, sleeve_y_bot,
                        sleeve_x_top - wall_x_trim, sleeve_y_top,
                        -sleeve_depth, 0);
        // Cavity, shifted +X by wall_thickness so it punches the +X wall
        // entirely while leaving the -X wall intact at full thickness.
        // Cavity stops wall_thickness below the top of the sleeve so the
        // top of the sleeve becomes a horizontal ceiling (also acts as the
        // floor for the upper body interior). The arm seats with its top
        // against this ceiling at Z = -wall_thickness.
        translate([wall_thickness, 0, 0])
            tapered_box(cavity_x_bot + 2 * wall_thickness, cavity_y_bot,
                        cavity_x_top + 2 * wall_thickness, cavity_y_top,
                        -sleeve_depth - eps, -wall_thickness);
    }
}

// C-shaped tapered post above Z = 0. Same open-on-+X channel as the sleeve,
// extended upward by extension_height. Walls remain on -X, +Y, -Y, plus a
// solid top cap of wall_thickness sealing the top.
module upper_body() {
    difference() {
        // Outer trimmed by wall_x_trim on the +X side (the open side).
        // Same trim+shift pattern as sleeve_shell, preserving -X wall position.
        translate([-wall_x_trim / 2, 0, 0])
            tapered_box(upper_outer_x_base - wall_x_trim, upper_outer_y_base,
                        upper_outer_x_topz - wall_x_trim, upper_outer_y_topz,
                        0, extension_height);
        // Cavity, open on +X, sealed at the top by wall_thickness.
        translate([wall_thickness, 0, 0])
            tapered_box(upper_x_base + 2 * wall_thickness, upper_y_base,
                        cap_inner_x + 2 * wall_thickness, cap_inner_y,
                        0 - eps, cavity_top_z);
    }
}

// Inside cylindrical boss: round wall around the upper bolt hole on the
// cavity side of the -X wall. Sits coaxial with the bolt hole; will be cut
// open by upper_bolt_hole() to form a sleeve.
module inside_cyl_boss() {
    cavity_x_face = -cavity_x_at_ub / 2;
    translate([cavity_x_face, 0, upper_bolt_z])
        rotate([0, 90, 0])
            cylinder(d = inside_boss_od, h = inside_boss_length);
}

// Nut holder: rectangular block on the -Y side of the inside cyl boss, hosts
// the captive hand-screw nut. Overlaps the cylindrical boss so the two merge.
module nut_holder() {
    cavity_x_face = -cavity_x_at_ub / 2;
    cavity_y_face = -cavity_y_at_ub / 2;
    by_size  = nut_holder_y_to - cavity_y_face;
    bx_center = cavity_x_face + nut_holder_x / 2;
    by_center = ((cavity_y_face + nut_holder_y_to) / 2);
    translate([bx_center, by_center, upper_bolt_z])
        cube([nut_holder_x, by_size, nut_holder_z], center = true);
}

// Boss on the inner side face (-X side) at the upper bolt height.
// Matches the original arm boss so the PCB bracket can remount here.
module top_boss() {
    z_frac = upper_bolt_z / extension_height;
    x_outer_half_at_z =
        (upper_outer_x_base + (upper_outer_x_topz - upper_outer_x_base) * z_frac) / 2;
    translate([-x_outer_half_at_z, 0, upper_bolt_z])
        rotate([0, -90, 0])
            cylinder(d = retainer_boss_od, h = retainer_boss_protrude);
}

// Top boss inlet: hollows the external boss into a tube (stubby pipe) so
// the PCB bracket's round peg can insert into it. Cuts a cylindrical pocket
// through the full boss protrusion, stopping at the body's -X outer face so
// the wall material stays intact and continues to carry the bolt hole.
module top_boss_inlet() {
    z_frac = upper_bolt_z / extension_height;
    x_outer_half_at_z =
        (upper_outer_x_base + (upper_outer_x_topz - upper_outer_x_base) * z_frac) / 2;
    inlet_id = retainer_boss_od - 2 * top_boss_wall;
    translate([-x_outer_half_at_z - retainer_boss_protrude - eps, 0, upper_bolt_z])
        rotate([0, 90, 0])
            cylinder(d = inlet_id, h = retainer_boss_protrude + eps);
}

//==============================================================================
// 8. SUBTRACTIONS (holes + nut pockets)
//==============================================================================

// Boss clearance hole through the -X wall at lower_bolt_z.
// Sized to let the arm's 15.8 mm boss seat fully through the wall as the
// extension is pressed onto the arm from the inside. The boss tip will
// protrude slightly past the -X face (boss is 4 mm, wall is 3 mm).
// The bolt threads through the boss + arm; the user holds an M4 nut against
// the arm's outer face, which is accessible through the open +X side.
//
// The cylinder is centered at X = 0 and made longer than the full sleeve
// width so it punches the -X wall cleanly at every Z within its vertical
// extent (the sleeve tapers, so a per-Z fit would leave thin slivers at the
// top/bottom of the boss cut). The +X half passes through open cavity.
module lower_mount_subtractions() {
    translate([0, 0, lower_bolt_z])
        rotate([0, 90, 0])
            cylinder(d = retainer_boss_od + boss_recess_clearance,
                     h = sleeve_x_bot * 2,
                     center = true);
}

// Upper bolt hole: through the upper body and the boss, axis = X.
module upper_bolt_hole() {
    z_frac = upper_bolt_z / extension_height;
    x_outer_half =
        (upper_outer_x_base + (upper_outer_x_topz - upper_outer_x_base) * z_frac) / 2;
    L = 2 * x_outer_half + retainer_boss_protrude + 2 * eps;
    translate([-x_outer_half - retainer_boss_protrude - eps, 0, upper_bolt_z])
        rotate([0, 90, 0])
            cylinder(d = retainer_bolt_hole_d + bolt_clearance, h = L);
}

// Hand-screw blind hole along Y at upper_bolt_z. Enters from -Y outer face,
// passes through -Y wall, captive nut, cavity material, and into the inside
// cylindrical boss. Stops just past the bolt axis so the screw tip presses
// on the retainer bolt. Does NOT punch through to +Y — blind on +Y side.
//
// Start uses the worst-case -Y face position (at Z = 0 base of upper body,
// where the body is widest) so the hole punches cleanly at every Z within
// its vertical range despite the upper-body taper.
module hand_screw_subtractions() {
    start_y = -upper_outer_y_base / 2 - eps;
    end_y   = hand_screw_blind_overshoot;
    translate([0, start_y, upper_bolt_z])
        rotate([-90, 0, 0])
            cylinder(d = hand_screw_thread_d + bolt_clearance,
                     h = end_y - start_y);
}

// Nut nook: rectangular slot inside the inside boss, holding the hand-screw
// hex nut. Open on +X (extends well past the +X face of the body so the nut
// is loaded from outside through the open cavity). Floor and ceiling within
// the boss block capture the nut vertically; the slot's -Y end backs up the
// nut axially when the screw is tightened.
module nut_nook_subtraction() {
    nut_av = hand_screw_nut_af / cos(30);
    nx = nut_av                + 2 * nut_nook_x_clear;   // X: hex AV + clearance
    ny = hand_screw_nut_thick  + 2 * nut_nook_y_clear;   // Y: nut thickness + clearance
    nz = hand_screw_nut_af     + 2 * nut_nook_z_clear;   // Z: hex AF + clearance

    // Slot extends from -nx/2 (deepest into block) to well past the +X face
    // of the body so it is fully open on +X.
    slot_x_min = -nx / 2;
    slot_x_far = upper_outer_x_base / 2 + 20;
    slot_x_size  = slot_x_far - slot_x_min;
    slot_x_center = (slot_x_min + slot_x_far) / 2;

    translate([slot_x_center, nut_nook_y_center, upper_bolt_z])
        cube([slot_x_size, ny, nz], center = true);
}

//==============================================================================
// 9. TOP-LEVEL EXTENSION PIECE
//==============================================================================

module extension_piece() {
    difference() {
        union() {
            sleeve_shell();
            upper_body();
            top_boss();
            inside_cyl_boss();
            nut_holder();
        }
        lower_mount_subtractions();
        upper_bolt_hole();
        top_boss_inlet();
        hand_screw_subtractions();
        nut_nook_subtraction();
    }
}

//==============================================================================
// 10. ASSEMBLY
//==============================================================================
// Renders both pieces side by side. For printing, render extension_piece()
// alone and duplicate / mirror in the slicer, or comment out one branch.
//==============================================================================

assembly_gap = 60;  // mm - visual separation in preview

module assembly() {
    translate([assembly_gap / 2, 0, 0])
        extension_piece();

    if (render_mirrored_piece)
        translate([-assembly_gap / 2, 0, 0])
            mirror([1, 0, 0])
                extension_piece();
}

assembly();
