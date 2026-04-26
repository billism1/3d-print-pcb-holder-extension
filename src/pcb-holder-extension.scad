//==============================================================================
// PCB Holder Extension
//==============================================================================
// Target: Standard PCB holders with ~200x140mm max PCB capacity
// Compatible with:
//   - Noah NH-11E (Amazon B0CY4DRHWK)
//   - Pro's Kit SN-390 (Adafruit 3791)
//
// Function: Slides over the top of a vertical arm, secured through the
//           original retainer-bolt hole. Extends the arm upward and provides
//           an identical boss + nut pocket at its top so the original
//           spring-loaded PCB bracket and hand screw remount on the extension.
//
// Coordinate system (single piece, "right arm" version):
//   +X = outer side  (-X = inner side, faces PCB center; peg + boss live here)
//   +Y = front       (-Y = back; hand-screw nut pocket lives on -Y face)
//   +Z = up          (origin Z = 0 sits at the top face of the arm)
//==============================================================================

//==============================================================================
// 1. TARGET HOLDER DIMENSIONS (measured)
//==============================================================================

// Arm cross-section (tapers linearly bottom -> top over arm_height)
arm_x_bottom = 24;   // mm - "front view" width  (left-right, retainer bolt axis)
arm_x_top    = 16;
arm_y_bottom = 30;   // mm - "side view" width   (front-to-back, hand screw axis)
arm_y_top    = 20;
arm_height   = 80;   // mm

// Retainer-bolt hole on the arm
retainer_bolt_hole_d        = 4;     // mm
retainer_bolt_z_from_bottom = 65;    // mm - center of hole, from arm bottom
retainer_boss_od            = 15.8;  // mm - boss OD on the inner side face
retainer_boss_protrude      = 4;     // mm - how far the boss sticks toward center

// Hand screw (locks the retainer bolt; threads in from front-or-back face)
hand_screw_thread_d = 3.85;  // mm - measured at thread crests
hand_screw_nut_af   = 7;     // mm - hex nut, across-flats (M4)

//==============================================================================
// 2. EXTENSION PARAMETERS
//==============================================================================

extension_height = 40;   // mm - rise above arm top (parameter; tune as needed)
sleeve_depth     = 25;   // mm - how far the sleeve covers the arm from the top
wall_thickness   = 3;    // mm

// Mirrors original arm: top mounting hole this far below extension top
top_bolt_offset_from_top = 15;

// Boss clearance recess (cut into the -X inner cavity wall at the lower bolt
// height to receive the arm's protruding 15.8 mm boss).
boss_recess_clearance = 0.4;   // mm - added to OD for slip fit over boss
boss_recess_depth     = retainer_boss_protrude + 0.3;  // mm - clears full protrusion

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

// Upper body continues the arm taper rates above Z = 0
x_taper_rate = (arm_x_bottom - arm_x_top) / arm_height;
y_taper_rate = (arm_y_bottom - arm_y_top) / arm_height;

upper_x_base = arm_x_top;
upper_y_base = arm_y_top;
upper_x_topz = arm_x_top - x_taper_rate * extension_height;
upper_y_topz = arm_y_top - y_taper_rate * extension_height;

upper_outer_x_base = upper_x_base + 2 * wall_thickness;
upper_outer_y_base = upper_y_base + 2 * wall_thickness;
upper_outer_x_topz = upper_x_topz + 2 * wall_thickness;
upper_outer_y_topz = upper_y_topz + 2 * wall_thickness;

// Lower bolt hole Z (in extension coords; arm top at Z = 0; arm bolt 15 mm down)
lower_bolt_z = -(arm_height - retainer_bolt_z_from_bottom);  // = -15

// Upper bolt hole Z (mirrors arm geometry, measured from extension top)
upper_bolt_z = extension_height - top_bolt_offset_from_top;

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

// Hollow tapered cap covering the top of the arm.
// Outer: Z = -sleeve_depth to Z = 0.
// Inner cavity: open at bottom, capped at Z = 0 by wall_thickness.
module sleeve_shell() {
    difference() {
        tapered_box(sleeve_x_bot, sleeve_y_bot,
                    sleeve_x_top, sleeve_y_top,
                    -sleeve_depth, 0);
        tapered_box(cavity_x_bot, cavity_y_bot,
                    cavity_x_top, cavity_y_top,
                    -sleeve_depth - eps, 0 - eps);
    }
}

// Solid tapered post above Z = 0
module upper_body() {
    tapered_box(upper_outer_x_base, upper_outer_y_base,
                upper_outer_x_topz, upper_outer_y_topz,
                0, extension_height);
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

//==============================================================================
// 8. SUBTRACTIONS (holes + nut pockets)
//==============================================================================

// Lower bolt through-hole + boss clearance recess + hex nut pocket on outer face.
module lower_mount_subtractions() {
    // Bolt through-hole spans both sleeve walls at lower_bolt_z.
    translate([0, 0, lower_bolt_z])
        rotate([0, 90, 0])
            cylinder(d = retainer_bolt_hole_d + bolt_clearance,
                     h = sleeve_x_top + sleeve_x_bot,
                     center = true);

    // Inner cavity -X half-width at lower_bolt_z (interpolated over sleeve).
    z_frac_lo = (lower_bolt_z - (-sleeve_depth)) / sleeve_depth;
    cavity_x_half_at_lo =
        (cavity_x_bot + (cavity_x_top - cavity_x_bot) * z_frac_lo) / 2;

    // Boss clearance recess: receives the arm's 15.8 mm boss on the -X cavity
    // wall. Starts at the cavity wall (-cavity_x_half_at_lo) and cuts outward
    // in -X. Will punch through the 3 mm sleeve wall, leaving an opening on
    // the -X face large enough for the boss to seat.
    translate([-cavity_x_half_at_lo, 0, lower_bolt_z])
        rotate([0, 90, 0])
            cylinder(d = retainer_boss_od + boss_recess_clearance,
                     h = boss_recess_depth + eps);

    // Outer (+X) sleeve half-width at lower_bolt_z (interpolated).
    sleeve_x_half_at_lo =
        (sleeve_x_bot + (sleeve_x_top - sleeve_x_bot) * z_frac_lo) / 2;

    // Hex nut pocket recessed into the +X outer face for an M4 nut.
    // Opens outward (+X) so the nut is inserted from outside, then captured
    // while the bolt is threaded in from the inner side.
    translate([sleeve_x_half_at_lo - nut_pocket_depth, 0, lower_bolt_z])
        rotate([0, -90, 0])
            hex_pocket(hand_screw_nut_af, nut_pocket_depth + eps);
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

// Hand screw: through-hole along Y at upper_bolt_z + hex pocket on -Y face.
// The hole intersects upper_bolt_hole so the screw tip can press on the bolt.
module hand_screw_subtractions() {
    z_frac = upper_bolt_z / extension_height;
    y_outer_half =
        (upper_outer_y_base + (upper_outer_y_topz - upper_outer_y_base) * z_frac) / 2;

    // Through-hole along Y for the threaded shaft.
    translate([0, -y_outer_half - eps, upper_bolt_z])
        rotate([-90, 0, 0])
            cylinder(d = hand_screw_thread_d + bolt_clearance,
                     h = 2 * y_outer_half + 2 * eps);

    // Hex nut pocket on -Y face. rotate([90,0,0]) maps +Z -> -Y.
    translate([0, -y_outer_half + nut_pocket_depth, upper_bolt_z])
        rotate([90, 0, 0])
            hex_pocket(hand_screw_nut_af, nut_pocket_depth + eps);
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
        }
        lower_mount_subtractions();
        upper_bolt_hole();
        hand_screw_subtractions();
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
    translate([-assembly_gap / 2, 0, 0])
        mirror([1, 0, 0])
            extension_piece();
}

assembly();
