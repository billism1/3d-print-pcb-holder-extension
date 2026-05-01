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
arm_x_bottom = 23.5;   // mm - "front view" width  (left-right, retainer bolt axis)
arm_x_top    = 16;
arm_y_bottom = 30;   // mm - "side view" width   (front-to-back, hand screw axis)
arm_y_top    = 20;
arm_height   = 80;   // mm

// Retainer-bolt hole on the arm
retainer_bolt_hole_d        = 5;     // mm
retainer_bolt_z_from_bottom = 65;    // mm - center of hole, from arm bottom
retainer_boss_od            = 16.5;  // mm - boss OD on the inner side face
retainer_boss_protrude      = 3.5;     // mm - how far the boss sticks toward center

// Hand screw (locks the retainer bolt; threads in from front-or-back face)
hand_screw_thread_d  = 3.85;  // mm - measured at thread crests
hand_screw_nut_af    = 7;     // mm - hex nut, across-flats (M4)
hand_screw_nut_thick = 3.0;   // mm - M4 hex nut typical axial thickness

//==============================================================================
// 2. EXTENSION PARAMETERS
//==============================================================================

extension_height = 60;   // mm - rise above arm top (parameter; tune as needed)
sleeve_depth     = 84;   // mm - how far the sleeve covers the arm from the top
wall_thickness   = 3;    // mm

// Vertical thickness of the sleeve ceiling. Defaults to wall_thickness so
// the ceiling matches the side walls. Increase to lower the ceiling: the
// arm seats deeper into the sleeve, and the lower bolt hole position
// follows automatically (see derived `lower_bolt_z`).
// Example: set to wall_thickness + 2 to lower the ceiling by 2 mm.
sleeve_ceiling_thickness = wall_thickness;   // mm

// Optional manual Z offset for the lower bolt hole, on top of the auto
// position derived from where the arm seats. Positive moves the hole up
// (less negative Z), negative moves it down. Use to fine-tune alignment
// with the actual arm if measurements drift.
lower_bolt_z_tweak = 3.5;   // mm

raise_base_ext_sep_wall = 2.5;

// Trim length of the side walls (+Y, -Y) and the closed -X wall along the
// X axis. Shrinks the outer body width by this amount on the open (+X) side
// only so the -X wall position is preserved and the +X face moves inward.
wall_x_trim      = 3.5;    // mm

// Mirrors original arm: top mounting hole this far below extension top
top_bolt_offset_from_top = 12;

// Boss clearance: hole on the -X wall at lower_bolt_z that lets the arm's
// 15.8 mm boss seat fully through the wall. With wall_thickness < boss
// protrusion, this hole punches all the way through the -X wall.
boss_recess_clearance = -0.45;   // mm - added to OD for slip fit over boss

// Inside boss: cylindrical sleeve on the cavity side of the -X wall around
// the upper bolt hole. Mimics the round wall on the original arm interior —
// reinforces the bolt mount with 3 mm of wall material around the 4 mm hole.
inside_boss_od     = 10;    // mm - OD (3 mm wall around 4 mm bolt hole)
inside_boss_length = 13;     // mm - extent into cavity in +X direction

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
nut_nook_z_clear  = 0.1;    // mm - vertical clearance past hex AF
nut_nook_y_center = -6.15;     // mm - Y of nut center along hand-screw path

// Hand-screw blind hole: enters from -Y, ends just past the bolt axis.
// Does NOT punch through the +Y wall.
hand_screw_blind_overshoot = 0.5;   // mm past bolt axis (into inside boss material)

// External top boss is hollowed into a stubby tube so the PCB bracket's
// round peg can insert into it. Wall thickness is the radial material left
// between the inlet (ID) and the boss OD.
top_boss_wall = 2;   // mm - radial wall of the boss tube

// Rounded edges (matches the look of the original arm in the photo):
// - edge_corner_radius rounds the two -X (PCB-facing) vertical edges, the
//   ones running the full sleeve+upper-body height.
// - top_corner_radius adds a chamfer at the very top of the upper body.
// edge_corner_radius must stay smaller than wall_thickness * sqrt(2)/(1+sqrt(2))
// (~1.76 mm at wall_thickness = 3 mm) or the rounded corner cuts past the
// inner cavity wall.
edge_corner_radius = 1.5;   // mm
top_corner_radius  = 2;     // mm

// Snap-fit lips on the cavity side of the +Y/-Y walls, lower portion of the
// sleeve only. Wedge-shaped: flush with the cavity face at the -X end of
// the wedge, protruding into the cavity by snap_fit_lip at the +X end (the
// open mouth). The +Y/-Y walls flex outward as the arm is pushed past the
// wedge, gripping the arm via interference.
snap_fit_lip      = 1;    // mm - inward depth at the lip's +X tip
snap_fit_x_length = 1.5;      // mm - X length of the wedge ramp
snap_fit_z_top    = -25;    // mm - top Z of the lip range (extension coords)

// Wall X extension: where the snap-fit grips are, the +Y and -Y walls
// extend further in the +X direction by this amount, making the walls
// "longer" along X in the snap-fit region. The snap-fit lip wedge follows
// to the new leading edge so the lip is at the extended wall's tip.
snap_fit_wall_x_extend = 1;    // mm - extra X length of the walls in the snap-fit region

//==============================================================================
// 3. TOLERANCES
//==============================================================================

surface_tolerance = 0.0;   // mm - per side, sleeve cavity vs arm
bolt_clearance    = 0.35;  // mm - oversize on bolt through-holes
nut_pocket_depth  = 3;     // mm - hex pocket depth
eps               = 0.01;  // mm - epsilon to avoid coincident faces

//==============================================================================
// 4. RENDER QUALITY
//==============================================================================

$fn = 164;
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

// Where the arm's top seats in the sleeve. With a ceiling, the arm stops
// against the underside of the ceiling material at Z = -sleeve_ceiling_thickness.
arm_seat_top_z = -sleeve_ceiling_thickness - raise_base_ext_sep_wall;

// Lower bolt hole Z (in extension coords). The arm's bolt is
// (arm_height - retainer_bolt_z_from_bottom) below the arm's top, so the
// bolt's Z relative to the extension is the seat position minus that offset.
// Add the manual tweak for fine alignment.
lower_bolt_z = arm_seat_top_z
             - (arm_height - retainer_bolt_z_from_bottom)
             + lower_bolt_z_tweak;

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

// Top boss attachment X. Position uses the body's -X face at the TOP of the
// boss's vertical extent (Z = upper_bolt_z + boss_radius), where the upper
// body is narrowest. This guarantees the boss reaches the wall at the top of
// its circle (no gap there); at lower Z the body extends further -X so the
// boss embeds into the wall — a clean union, not a gap.
top_boss_top_z   = upper_bolt_z + retainer_boss_od / 2;
top_boss_x_face  = -(upper_outer_x_base
                     + (upper_outer_x_topz - upper_outer_x_base)
                       * (top_boss_top_z / extension_height)) / 2;

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

// Slab of thickness eps with rounded -X corners and sharp +X corners.
// Used as a layer in hull() to build a tapered body whose -X (PCB-facing)
// vertical edges are rounded. The +X side is left sharp because that face
// is open in the C-channel anyway.
module rounded_slab_2d(x, y, r) {
    union() {
        // Main rectangle from -x/2+r to +x/2 in X, full y in Y
        translate([-x/2 + r, -y/2, 0])
            cube([x - r, y, eps]);
        // -X strip between the two rounded corners
        translate([-x/2, -y/2 + r, 0])
            cube([r, y - 2 * r, eps]);
        // Two rounded corners
        translate([-x/2 + r, -y/2 + r, 0])
            cylinder(r = r, h = eps);
        translate([-x/2 + r, +y/2 - r, 0])
            cylinder(r = r, h = eps);
    }
}

// Tapered body with rounded -X vertical edges and an optional rounded top.
// r_corner: vertical-edge radius. r_top: top-edge radius (0 = sharp top).
// The top rounding follows a quarter-circle profile, sampled with N slabs
// hulled together so the result is a smooth curve, not a flat bevel.
module rounded_tapered_body(x_bot, y_bot, x_top, y_top, z_bot, z_top,
                            r_corner, r_top = 0) {
    if (r_top > 0) {
        z_round_start = z_top - r_top;
        z_frac        = (z_round_start - z_bot) / (z_top - z_bot);
        x_at_round    = x_bot + (x_top - x_bot) * z_frac;
        y_at_round    = y_bot + (y_top - y_bot) * z_frac;
        n_top_samples = 12;
        union() {
            // Main body up to where the rounding starts
            hull() {
                translate([0, 0, z_bot])
                    rounded_slab_2d(x_bot, y_bot, r_corner);
                translate([0, 0, z_round_start])
                    rounded_slab_2d(x_at_round, y_at_round, r_corner);
            }
            // Rounded top cap. Each sample's (z_sample, inset) lies on a
            // quarter-circle centered at (x_at_round/2 - r_top, z_round_start)
            // with radius r_top. Hulling all the sample slabs produces a
            // smoothly curved top edge.
            hull() {
                for (i = [0 : n_top_samples]) {
                    angle    = (i / n_top_samples) * 90;
                    inset    = r_top * (1 - cos(angle));
                    dz       = r_top * sin(angle);
                    z_sample = z_round_start + dz;
                    x_sample = max(x_at_round - 2 * inset, 2 * r_corner + eps);
                    y_sample = max(y_at_round - 2 * inset, 2 * r_corner + eps);
                    translate([0, 0, z_sample])
                        rounded_slab_2d(x_sample, y_sample, r_corner);
                }
            }
        }
    } else {
        hull() {
            translate([0, 0, z_bot])
                rounded_slab_2d(x_bot, y_bot, r_corner);
            translate([0, 0, z_top])
                rounded_slab_2d(x_top, y_top, r_corner);
        }
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
        // the -X wall position unchanged. -X vertical edges are rounded.
        translate([-wall_x_trim / 2, 0, 0])
            rounded_tapered_body(sleeve_x_bot - wall_x_trim, sleeve_y_bot,
                                 sleeve_x_top - wall_x_trim, sleeve_y_top,
                                 -sleeve_depth, 0,
                                 edge_corner_radius);
        // Cavity, shifted +X by wall_thickness so it punches the +X wall
        // entirely while leaving the -X wall intact at full thickness.
        // Cavity stops wall_thickness below the top of the sleeve so the
        // top of the sleeve becomes a horizontal ceiling (also acts as the
        // floor for the upper body interior). The arm seats with its top
        // against this ceiling at Z = -wall_thickness.
        translate([wall_thickness, 0, 0])
            tapered_box(cavity_x_bot + 2 * wall_thickness, cavity_y_bot,
                        cavity_x_top + 2 * wall_thickness, cavity_y_top,
                        -sleeve_depth - eps, arm_seat_top_z);
    }
}

// C-shaped tapered post above Z = 0. Same open-on-+X channel as the sleeve,
// extended upward by extension_height. Walls remain on -X, +Y, -Y, plus a
// solid top cap of wall_thickness sealing the top.
module upper_body() {
    difference() {
        // Outer trimmed by wall_x_trim on the +X side (the open side).
        // Same trim+shift pattern as sleeve_shell, preserving -X wall position.
        // -X vertical edges rounded; top edges chamfered.
        translate([-wall_x_trim / 2, 0, 0])
            rounded_tapered_body(upper_outer_x_base - wall_x_trim, upper_outer_y_base,
                                 upper_outer_x_topz - wall_x_trim, upper_outer_y_topz,
                                 0, extension_height,
                                 edge_corner_radius, top_corner_radius);
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
// Positioned at top_boss_x_face — the body's -X face at the TOP of the boss
// circle — so the boss reaches the body all the way around its perimeter
// despite the upper-body taper.
module top_boss() {
    translate([top_boss_x_face, 0, upper_bolt_z])
        rotate([0, -90, 0])
            cylinder(d = retainer_boss_od, h = retainer_boss_protrude);
}

// Top boss inlet: hollows the external boss into a tube (stubby pipe) so
// the PCB bracket's round peg can insert into it. Cuts a cylindrical pocket
// through the full boss protrusion, stopping at top_boss_x_face (the boss's
// inner attachment plane). The wall material behind the inlet stays intact
// and continues to carry the bolt hole.
module top_boss_inlet() {
    inlet_id = retainer_boss_od - 2 * top_boss_wall;
    translate([top_boss_x_face - retainer_boss_protrude - eps, 0, upper_bolt_z])
        rotate([0, 90, 0])
            cylinder(d = inlet_id, h = retainer_boss_protrude + eps);
}

// Wall +X extension on one Y wall: in the snap-fit Z range, adds wall
// material from the regular wall +X edge outward (+X) by snap_fit_wall_x_extend.
// Material is at full wall thickness (between cavity_y face and outer_y face).
module snap_fit_wall_extension(y_sign) {
    z_bot       = -sleeve_depth;
    z_top       = snap_fit_z_top;
    z_frac_top  = (z_top + sleeve_depth) / sleeve_depth;

    sleeve_x_at_top = sleeve_x_bot + (sleeve_x_top - sleeve_x_bot) * z_frac_top;
    sleeve_y_at_top = sleeve_y_bot + (sleeve_y_top - sleeve_y_bot) * z_frac_top;
    cavity_y_at_top = cavity_y_bot + (cavity_y_top - cavity_y_bot) * z_frac_top;

    // Regular wall +X edge (without extension)
    x_reg_top = sleeve_x_at_top / 2 - wall_x_trim;
    x_reg_bot = sleeve_x_bot     / 2 - wall_x_trim;
    // Extended wall +X edge
    x_ext_top = x_reg_top + snap_fit_wall_x_extend;
    x_ext_bot = x_reg_bot + snap_fit_wall_x_extend;

    // Wall material spans the cavity face to the outer face
    cy_face_top = y_sign * cavity_y_at_top / 2;
    cy_face_bot = y_sign * cavity_y_bot    / 2;
    oy_face_top = y_sign * sleeve_y_at_top / 2;
    oy_face_bot = y_sign * sleeve_y_bot    / 2;

    // Rectangle in XY: from x_reg to x_ext in X, from cavity_y to outer_y in Y.
    // Vertex order chosen so the polygon is CCW for either y_sign.
    poly_bot = (y_sign > 0)
        ? [[x_reg_bot, cy_face_bot], [x_ext_bot, cy_face_bot],
           [x_ext_bot, oy_face_bot], [x_reg_bot, oy_face_bot]]
        : [[x_reg_bot, cy_face_bot], [x_reg_bot, oy_face_bot],
           [x_ext_bot, oy_face_bot], [x_ext_bot, cy_face_bot]];
    poly_top = (y_sign > 0)
        ? [[x_reg_top, cy_face_top], [x_ext_top, cy_face_top],
           [x_ext_top, oy_face_top], [x_reg_top, oy_face_top]]
        : [[x_reg_top, cy_face_top], [x_reg_top, oy_face_top],
           [x_ext_top, oy_face_top], [x_ext_top, cy_face_top]];

    hull() {
        translate([0, 0, z_bot])
            linear_extrude(height = eps)
                polygon(poly_bot);
        translate([0, 0, z_top])
            linear_extrude(height = eps)
                polygon(poly_top);
    }
}

// Snap-fit lip wedge on one Y wall (y_sign = +1 for +Y wall, -1 for -Y wall).
// Triangular wedge in XY: flush with the cavity face at the -X end of the
// wedge, protruding inward by snap_fit_lip at the +X tip (the open mouth).
// Hulled between two slabs at z_bot_lip and z_top_lip so it follows the
// cavity Y taper across its Z range.
module snap_fit_lip_wedge(y_sign) {
    z_bot_lip  = -sleeve_depth;
    z_top_lip  = snap_fit_z_top;
    z_frac_top = (z_top_lip + sleeve_depth) / sleeve_depth;

    cavity_y_at_top = cavity_y_bot + (cavity_y_top - cavity_y_bot) * z_frac_top;
    sleeve_x_at_top = sleeve_x_bot + (sleeve_x_top - sleeve_x_bot) * z_frac_top;

    // +X tip uses the EXTENDED wall edge so the lip ends at the new leading
    // edge of the wall (matching snap_fit_wall_extension).
    x_max_top = sleeve_x_at_top / 2 - wall_x_trim + snap_fit_wall_x_extend;
    x_max_bot = sleeve_x_bot     / 2 - wall_x_trim + snap_fit_wall_x_extend;

    cy_face_top = y_sign * cavity_y_at_top / 2;
    cy_face_bot = y_sign * cavity_y_bot    / 2;

    lip_in_top = cy_face_top - y_sign * snap_fit_lip;
    lip_in_bot = cy_face_bot - y_sign * snap_fit_lip;

    x_min_top = x_max_top - snap_fit_x_length;
    x_min_bot = x_max_bot - snap_fit_x_length;

    // Triangle vertex order chosen so the polygon is CCW for either y_sign,
    // so linear_extrude treats it as a solid (not a hole).
    triangle_bot = (y_sign > 0)
        ? [[x_min_bot, cy_face_bot], [x_max_bot, lip_in_bot], [x_max_bot, cy_face_bot]]
        : [[x_min_bot, cy_face_bot], [x_max_bot, cy_face_bot], [x_max_bot, lip_in_bot]];
    triangle_top = (y_sign > 0)
        ? [[x_min_top, cy_face_top], [x_max_top, lip_in_top], [x_max_top, cy_face_top]]
        : [[x_min_top, cy_face_top], [x_max_top, cy_face_top], [x_max_top, lip_in_top]];

    hull() {
        translate([0, 0, z_bot_lip])
            linear_extrude(height = eps)
                polygon(triangle_bot);
        translate([0, 0, z_top_lip])
            linear_extrude(height = eps)
                polygon(triangle_top);
    }
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
            snap_fit_lip_wedge(+1);
            snap_fit_lip_wedge(-1);
            snap_fit_wall_extension(+1);
            snap_fit_wall_extension(-1);
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
