//==============================================================================
// PCB Holder Long Arm
//==============================================================================
// Target: Standard PCB holders with ~200x140mm max PCB capacity
// Compatible with:
//   - Noah NH-11E (Amazon B0CY4DRHWK)
//   - Pro's Kit SN-390 (Adafruit 3791)
//
// Function: Full replacement for the holder's stock arm. A rail base at the
//           bottom slides over the holder's fixed rectangular rail; the body
//           rises above the rail to a top boss + nut pocket that mate with
//           the original spring-loaded PCB bracket and hand screw. Provides
//           extra reach above the rail vs. the stock arm.
//
// Coordinate system (single piece, "right arm" version):
//   +X = outer side  — OPEN side of the body cavity; rail enters/exits in X
//   -X = inner side  — closed wall; faces PCB center; carries top boss
//   +Y = front       — closed wall; carries hand-screw through-hole
//   -Y = back        — closed wall; carries hand-screw nut pocket
//   +Z = up          — internally, Z = 0 sits at the "shoulder" plane where
//                      the top boss, upper bolt, and hand-screw hardware
//                      attach. The final long_arm() output is lifted so the
//                      bottom of the rail base rests on the Z = 0 plane
//                      (ready to drop straight onto a printer bed).
//==============================================================================

//==============================================================================
// 1. INTERFACING HARDWARE (must match the existing PCB bracket)
//==============================================================================

render_mirrored_piece = false;

// Retainer bolt: axis runs along X. Hole passes through the upper part of
// the body and through the inside cylindrical boss on the cavity side.
retainer_bolt_hole_d        = 5;     // mm
retainer_boss_od            = 16.5;  // mm - boss OD on the inner (-X) side face
retainer_boss_protrude      = 3.5;   // mm - how far the boss sticks in -X direction

// Hand screw (locks the retainer bolt; threads in from the -Y back face)
hand_screw_thread_d  = 3.85;  // mm - measured at thread crests
hand_screw_nut_af    = 7;     // mm - hex nut, across-flats (M4)
hand_screw_nut_thick = 3.0;   // mm - M4 hex nut typical axial thickness

//==============================================================================
// 2. BODY DIMENSIONS
//==============================================================================

// The body is a tapered tube split at Z = 0 (the "shoulder" plane where the
// top boss, upper bolt hole, and hand-screw nut attach). Below the shoulder
// the body runs down to the rail base; above the shoulder it rises to a
// closed top cap. Cross-section tapers linearly across the entire height
// (no kink at the shoulder).

// Body OUTER cross-section at the BOTTOM (Z = -lower_height)
body_x_bottom = 29.875;   // mm - X width  (left-right, retainer bolt axis)
body_y_bottom = 31.25;    // mm - Y depth  (front-to-back, hand screw axis)

// Body OUTER cross-section at the TOP (Z = upper_height)
body_x_top    = 20;     // mm
body_y_top    = 20;     // mm

// Section heights, split at Z = 0
lower_height = 84;   // mm - body extent below the shoulder (down to rail base)
upper_height = 80;   // mm - body extent above the shoulder (up to top cap)

wall_thickness = 3;  // mm

// Trim on the open (+X) side of the body. Shrinks the outer body width by
// this amount on +X only so the -X wall position is preserved and the +X
// face moves inward.
wall_x_trim = 3.5;   // mm

// Upper bolt hole position, measured down from the top of the body
top_bolt_offset_from_top = 12;

// Inside boss: cylindrical sleeve on the cavity side of the -X wall around
// the upper bolt hole. Reinforces the bolt mount with material around the
// 4 mm hole.
inside_boss_od     = 10;    // mm - OD (3 mm wall around 4 mm bolt hole)
inside_boss_length = 13;    // mm - extent into cavity in +X direction

// Nut holder block: rectangular block adjacent to the inside cyl boss on
// the -Y side. Provides material for the hand-screw nut nook with floor +
// ceiling capture. Overlaps the cylindrical boss so they merge into one
// solid mass.
nut_holder_wall_thickness = 1.5;
nut_holder_x      = inside_boss_length;                                 // mm - X depth into cavity from -X cavity face
nut_holder_y_to   = -6;                                                     // mm - +Y extent (block runs from -Y inner wall to here)
nut_holder_z      = (nut_holder_wall_thickness * 2) + hand_screw_nut_af;    // mm - vertical height (centered on upper_bolt_z)

// Hand-screw nut nook (rectangular slot inside the nut holder block).
// Opens on +X so the nut is loaded through the open outer face during
// assembly. Floor and ceiling within the block capture the nut vertically;
// the slot's -Y wall backs up the nut when the screw is tightened.
nut_nook_x_clear  = 0.5;    // mm - radial clearance past hex AV
nut_nook_y_clear  = 0.2;    // mm - axial clearance past nut thickness
nut_nook_z_clear  = 0.1;    // mm - vertical clearance past hex AF
nut_nook_y_center = -5.5;   // mm - Y of nut center along hand-screw path

// Hand-screw blind hole: enters from -Y, ends just past the bolt axis.
// Does NOT punch through the +Y wall.
hand_screw_blind_overshoot = 0.5;   // mm past bolt axis (into inside boss material)

// External top boss is hollowed into a stubby tube so the PCB bracket's
// round peg can insert into it. Wall thickness is the radial material left
// between the inlet (ID) and the boss OD.
top_boss_wall = 2.1;   // mm - radial wall of the boss tube

// Rounded edges (matches the look of the original arm in the photo):
// - edge_corner_radius rounds the two -X (PCB-facing) vertical edges, the
//   ones running the full body height.
// - top_corner_radius adds a chamfer at the very top of the upper body.
// edge_corner_radius must stay smaller than wall_thickness * sqrt(2)/(1+sqrt(2))
// (~1.76 mm at wall_thickness = 3 mm) or the rounded corner cuts past the
// inner cavity wall.
edge_corner_radius = 1.5;   // mm
top_corner_radius  = 2;     // mm

// Top-edge style:
//   false = beveled (single flat chamfer slab — original look)
//   true  = rounded (quarter-circle profile, smooth dome)
// Default: beveled.
use_rounded_top = false;

// Rail base: rectangular box at the bottom of the body with a through-hole
// along the X axis. The fixed rail slides through the hole; the entire arm
// translates along the rail in X. The rail runs parallel to the retainer
// bolt axis. Wall thickness around the rail matches `wall_thickness`.
rail_y         = 29;     // mm - rail cross-section width  (Y axis)
rail_z         = 14;     // mm - rail cross-section height (Z axis)
rail_clearance = 0.3;    // mm - per-side slip-fit clearance around the rail
rail_base_x    = 40;     // mm - X length of the rail base (grip along the rail)
rail_base_corner_r = 1.75;  // mm - radius on the 4 outer corners (viewed along X)

// Screw plate mount: flat flange tabs on the bottom of the rail base sticking
// out in +Y and -Y, for screwing the holder down to a platform. Plate bottoms
// are flush with the rail base bottom so the whole mount sits flat. Only the
// 2 outer corners (at the far Y end of each plate) are rounded; screw holes
// will be added later.
screw_plate_x        = 29;   // mm - X width (centered on the rail base)
screw_plate_extend_y = 10;   // mm - Y extent past the rail base outer face
screw_plate_z        = 3;    // mm - plate thickness (Z)
screw_plate_corner_r = 2;    // mm - radius on the 2 outer corners

// One of the two screw plates is half-width to clear room for another part.
// Pick which Y side gets the half-width plate, and which X edge stays at its
// full-width position; the other X edge moves to the rail base X center
// (so the half plate ends up half the original X width).
screw_plate_half_y_dir  = +1;  // -1: -Y plate is half-width; +1: +Y plate is half-width
screw_plate_half_x_keep = +1;  // -1: keep -X edge; +1: keep +X edge

// Mounting screw through-holes in the screw plates. One hole is centered on
// the half-width plate; the other is on the full-width plate, centered on
// the half opposite to the half-width plate (so the two holes sit on a
// diagonal across the rail base).
screw_plate_screw_d = 2.5;       // mm - mounting screw diameter

// Side nut holder: a block on the outer Y face of the rail base (on the same
// Y side as the half-width screw plate), centered above the half-width
// plate's missing half. Captures a hand-screw nut for the rail-locking screw.
// The screw enters from the outer Y face, passes through the nut and the
// rail base wall, and presses against the rail to lock the arm in place
// along the rail. Reuses the same nut and screw size as the upper hand-screw.
side_nut_holder_x_size = screw_plate_x / 2;   // mm - X width (matches the empty area span)

//==============================================================================
// 3. TOLERANCES
//==============================================================================

bolt_clearance    = 0.35;  // mm - oversize on bolt through-holes
nut_pocket_depth  = 3;     // mm - hex pocket depth
eps               = 0.01;  // mm - epsilon to avoid coincident faces

//==============================================================================
// 4. RENDER QUALITY
//==============================================================================

$fn = 44;
$fa = 0.5;
$fs = 0.1;

//==============================================================================
// 5. DERIVED DIMENSIONS
//==============================================================================

// Total taper distance, used to interpolate cross-section at any Z.
total_height = lower_height + upper_height;

// Outer body cross-section at any absolute Z, by linear interpolation
// between the bottom (Z = -lower_height) and top (Z = upper_height).
function body_outer_x_at(z) =
    body_x_bottom + (body_x_top - body_x_bottom) * (z + lower_height) / total_height;
function body_outer_y_at(z) =
    body_y_bottom + (body_y_top - body_y_bottom) * (z + lower_height) / total_height;

// Cavity = outer minus a wall on each side.
function cavity_x_at(z) = body_outer_x_at(z) - 2 * wall_thickness;
function cavity_y_at(z) = body_outer_y_at(z) - 2 * wall_thickness;

// Outer dimensions at the shoulder seam (Z = 0)
outer_x_at_seam = body_outer_x_at(0);
outer_y_at_seam = body_outer_y_at(0);

// Cavity dimensions at bottom and seam (used by the cavity tapered-box cuts)
cavity_x_at_bottom = cavity_x_at(-lower_height);
cavity_y_at_bottom = cavity_y_at(-lower_height);
cavity_x_at_seam   = cavity_x_at(0);
cavity_y_at_seam   = cavity_y_at(0);

// Upper bolt hole Z, measured down from the top of the body
upper_bolt_z = upper_height - top_bolt_offset_from_top;

// Upper-section cavity stops wall_thickness below the top to leave a solid
// roof. cap_inner_x/y are the cavity inner dimensions at that capped height.
cavity_top_z = upper_height - wall_thickness;
cap_inner_x  = cavity_x_at(cavity_top_z);
cap_inner_y  = cavity_y_at(cavity_top_z);

// Cavity inner dimensions at upper_bolt_z (Y gets +1 of headroom for the
// inside boss / nut holder cluster — room to breathe on the +Y side).
cavity_x_at_ub = cavity_x_at(upper_bolt_z);
cavity_y_at_ub = cavity_y_at(upper_bolt_z) + 1;

// Top boss attachment X. Position uses the body's -X face at the TOP of the
// boss's vertical extent (Z = upper_bolt_z + boss_radius), where the upper
// body is narrowest. This guarantees the boss reaches the wall at the top of
// its circle (no gap there); at lower Z the body extends further -X so the
// boss embeds into the wall — a clean union, not a gap.
top_boss_top_z   = upper_bolt_z + retainer_boss_od / 2;
top_boss_x_face  = -body_outer_x_at(top_boss_top_z) / 2;

// Rail base derived dimensions.
// Inner cavity = rail cross-section + slip-fit clearance per side.
// Outer       = cavity + wall_thickness per side.
rail_cavity_y     = rail_y + 2 * rail_clearance;
rail_cavity_z     = rail_z + 2 * rail_clearance;
rail_base_outer_y = rail_cavity_y + 2 * wall_thickness;
rail_base_outer_z = rail_cavity_z + 2 * wall_thickness;

// Top of the rail base meets the bottom of the body at Z = -lower_height.
rail_base_top_z    = -lower_height;
rail_base_bot_z    = rail_base_top_z - rail_base_outer_z;
rail_base_center_z = (rail_base_top_z + rail_base_bot_z) / 2;

// Side nut holder derived dimensions. The block sits on the outer Y face of
// the rail base (on the half-width plate's Y side), centered in X on the
// missing-half empty area, and centered in Z on the rail (so the screw axis
// runs through the rail).
side_nut_holder_y_size   = hand_screw_nut_thick + 2 * nut_nook_y_clear
                           + 2 * nut_holder_wall_thickness;
side_nut_holder_z_size   = nut_holder_z;
side_nut_holder_x_center = -wall_x_trim / 2
                           - screw_plate_half_x_keep * screw_plate_x / 4;
side_nut_holder_y_inner  = screw_plate_half_y_dir * rail_base_outer_y / 2;
side_nut_holder_y_center = side_nut_holder_y_inner
                           + screw_plate_half_y_dir * side_nut_holder_y_size / 2;
side_nut_holder_y_outer  = side_nut_holder_y_inner
                           + screw_plate_half_y_dir * side_nut_holder_y_size;
side_nut_holder_z_center = rail_base_center_z;

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

// Tapered body with rounded -X vertical edges and an optional top-edge
// treatment. r_corner: vertical-edge radius. r_top: top-edge radius
// (0 = sharp top). The top is either beveled (single flat chamfer) or
// rounded (quarter-circle profile sampled with N slabs hulled together),
// chosen by the global `use_rounded_top` flag.
module rounded_tapered_body(x_bot, y_bot, x_top, y_top, z_bot, z_top,
                            r_corner, r_top = 0) {
    if (r_top > 0) {
        z_round_start = z_top - r_top;
        z_frac        = (z_round_start - z_bot) / (z_top - z_bot);
        x_at_round    = x_bot + (x_top - x_bot) * z_frac;
        y_at_round    = y_bot + (y_top - y_bot) * z_frac;
        union() {
            // Main body up to where the top treatment starts
            hull() {
                translate([0, 0, z_bot])
                    rounded_slab_2d(x_bot, y_bot, r_corner);
                translate([0, 0, z_round_start])
                    rounded_slab_2d(x_at_round, y_at_round, r_corner);
            }
            if (use_rounded_top) {
                // Rounded top cap: quarter-circle profile sampled with N
                // slabs hulled together.
                n_top_samples = 12;
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
            } else {
                // Beveled top cap: single flat chamfer slab from the
                // full cross-section at z_round_start to a smaller
                // cross-section at z_top.
                hull() {
                    translate([0, 0, z_round_start])
                        rounded_slab_2d(x_at_round, y_at_round, r_corner);
                    translate([0, 0, z_top])
                        rounded_slab_2d(
                            max(x_at_round - 2 * r_top, 2 * eps),
                            max(y_at_round - 2 * r_top, 2 * eps),
                            max(r_corner - r_top, eps));
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

// Lower body: the section from Z = -lower_height up to the shoulder (Z = 0).
// Outer is a tapered C-channel open on +X (three walls: -X, +Y, -Y).
// Cavity merges with the upper body cavity at Z = 0 (no horizontal seam).
module lower_body() {
    difference() {
        // Outer trimmed by wall_x_trim on the +X side (the open side).
        // Width is reduced and the body shifted -X by half the trim, keeping
        // the -X wall position unchanged. -X vertical edges are rounded.
        translate([-wall_x_trim / 2, 0, 0])
            rounded_tapered_body(body_x_bottom - wall_x_trim, body_y_bottom,
                                 outer_x_at_seam - wall_x_trim, outer_y_at_seam,
                                 -lower_height, 0,
                                 edge_corner_radius);
        // Cavity, shifted +X by wall_thickness so it punches the +X wall
        // entirely while leaving the -X wall intact at full thickness.
        // Open all the way up to Z = 0 so it merges with the upper body
        // cavity (no horizontal ceiling at the seam).
        translate([wall_thickness, 0, 0])
            tapered_box(body_x_bottom, cavity_y_at_bottom,
                        outer_x_at_seam, cavity_y_at_seam,
                        -lower_height - eps, eps);
    }
}

// Upper body: the section from the shoulder (Z = 0) up to the top cap
// (Z = upper_height). Same open-on-+X channel as the lower body. Walls
// remain on -X, +Y, -Y, plus a solid top cap of wall_thickness sealing
// the top.
module upper_body() {
    difference() {
        // Outer trimmed by wall_x_trim on the +X side (the open side).
        // Same trim+shift pattern as lower_body, preserving -X wall position.
        // -X vertical edges rounded; top edges chamfered.
        translate([-wall_x_trim / 2, 0, 0])
            rounded_tapered_body(outer_x_at_seam - wall_x_trim, outer_y_at_seam,
                                 body_x_top - wall_x_trim, body_y_top,
                                 0, upper_height,
                                 edge_corner_radius, top_corner_radius);
        // Cavity, open on +X, sealed at the top by wall_thickness.
        translate([wall_thickness, 0, 0])
            tapered_box(outer_x_at_seam, cavity_y_at_seam,
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

// Rail base: rectangular box at the bottom of the arm. A rectangular rail
// (rail_y x rail_z cross-section) slides through it along the X axis, so
// the entire arm translates along the rail. Top of the base meets the
// bottom of the body at Z = -lower_height. Centered on Y = 0 (rail/bolt
// axis); centered in X on the body's outer center (-wall_x_trim/2).
module rail_base() {
    bx = rail_base_x;
    by = rail_base_outer_y;
    bz = rail_base_outer_z;

    cx = bx + 2 * eps;       // through-hole punches all the way through X
    cy = rail_cavity_y;
    cz = rail_cavity_z;

    r = min(rail_base_corner_r, by / 2 - eps, bz / 2 - eps);

    translate([-wall_x_trim / 2, 0, rail_base_center_z]) {
        difference() {
            // Outer body: hull of 4 X-aligned cylinders at the corners,
            // rounding the 4 edges visible looking along the X axis.
            hull() {
                for (dy = [-1, 1], dz = [-1, 1])
                    translate([0, dy * (by / 2 - r), dz * (bz / 2 - r)])
                        rotate([0, 90, 0])
                            cylinder(r = r, h = bx, center = true);
            }
            cube([cx, cy, cz], center = true);
        }
    }
}

// Screw plates: flat flange tabs on the bottom of the rail base sticking out
// in +Y and -Y. Bottoms flush with rail_base_bot_z so the assembly sits flat
// on a platform. Each plate's inner Y end overlaps the rail base by
// wall_thickness so the union covers the rail base bottom-corner rounding;
// the outer Y end has 2 rounded corners.
module screw_plates() {
    overlap = wall_thickness;
    plate_y_total = screw_plate_extend_y + overlap;
    r = screw_plate_corner_r;

    for (y_dir = [-1, +1]) {
        is_half = (y_dir == screw_plate_half_y_dir);
        plate_w = is_half ? screw_plate_x / 2 : screw_plate_x;
        // Half plate shifts so the kept X edge stays at its full-width
        // position; the cut X end ends at the rail base X center.
        x_shift = is_half ? screw_plate_half_x_keep * screw_plate_x / 4 : 0;

        translate([-wall_x_trim / 2 + x_shift,
                   y_dir * (rail_base_outer_y / 2 - overlap),
                   rail_base_bot_z])
            linear_extrude(height = screw_plate_z)
                hull() {
                    // Inner sharp edge at local y = 0 (sits inside the rail base)
                    translate([-plate_w / 2, -eps / 2])
                        square([plate_w, eps]);
                    // Outer rounded corners at local y = y_dir * (plate_y_total - r)
                    translate([-plate_w / 2 + r, y_dir * (plate_y_total - r)])
                        circle(r = r);
                    translate([+plate_w / 2 - r, y_dir * (plate_y_total - r)])
                        circle(r = r);
                }
    }
}

// Side nut holder block: rectangular block on the outer Y face of the rail
// base (on the half-width plate's Y side), centered above the missing-half
// of the screw plate. Sized in Z to match the upper nut holder; centered on
// the rail in Z so the screw axis runs through the rail. The underside is
// hulled down to the rail base bottom corner, producing a sloped self-
// supporting print face — no support material needed under the block.
module side_nut_holder() {
    hull() {
        // Main block, sized for the nut, centered on the rail in Z.
        translate([side_nut_holder_x_center,
                   side_nut_holder_y_center,
                   side_nut_holder_z_center])
            cube([side_nut_holder_x_size,
                  side_nut_holder_y_size,
                  side_nut_holder_z_size], center = true);
        // Anchor strip at the rail base outer Y face, at the rail base
        // bottom Z. The hull pulls the block's outer-bottom edge down to
        // here along a flat slope so the underside is self-supporting.
        translate([side_nut_holder_x_center,
                   side_nut_holder_y_inner,
                   rail_base_bot_z + rail_base_corner_r])
            cube([side_nut_holder_x_size, eps, eps], center = true);
    }
}

//==============================================================================
// 8. SUBTRACTIONS (holes + nut pockets)
//==============================================================================

// Upper bolt hole: through the top boss, the upper body, AND the inside
// cylindrical boss on the cavity side. The inside boss's +X tip can reach
// further out than the body's +X face once the upper body has tapered narrow
// (large upper_height), so the far end is taken as the max of the two.
module upper_bolt_hole() {
    x_outer_half = body_outer_x_at(upper_bolt_z) / 2;
    inside_boss_tip_x = -cavity_x_at_ub / 2 + inside_boss_length;
    start_x = -x_outer_half - retainer_boss_protrude - eps;
    end_x   = max(x_outer_half, inside_boss_tip_x) + eps;
    L = end_x - start_x;
    translate([start_x, 0, upper_bolt_z])
        rotate([0, 90, 0])
            cylinder(d = retainer_bolt_hole_d + bolt_clearance, h = L);
}

// Hand-screw blind hole along Y at upper_bolt_z. Enters from -Y outer face,
// passes through -Y wall, captive nut, cavity material, and into the inside
// cylindrical boss. Stops just past the bolt axis so the screw tip presses
// on the retainer bolt. Does NOT punch through to +Y — blind on +Y side.
//
// Start uses the worst-case -Y face position (at the shoulder Z = 0, where
// the body is widest in this section) so the hole punches cleanly at every
// Z within its vertical range despite the upper-body taper.
module hand_screw_subtractions() {
    start_y = -outer_y_at_seam / 2 - eps;
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
    slot_x_far = outer_x_at_seam / 2 + 20;
    slot_x_size  = slot_x_far - slot_x_min;
    slot_x_center = (slot_x_min + slot_x_far) / 2;

    translate([slot_x_center, nut_nook_y_center, upper_bolt_z])
        cube([slot_x_size, ny, nz], center = true);
}

// Screw plate mounting holes: one through the half-width plate (centered on
// it) and one through the full-width plate at its OPPOSITE half (i.e. mirrored
// across both rail base axes), so the two screws sit on a diagonal.
module screw_plate_holes() {
    hole_d  = screw_plate_screw_d + bolt_clearance;
    x_base  = -wall_x_trim / 2;
    x_off   = screw_plate_x / 4;                              // half-of-half center
    y_off   = rail_base_outer_y / 2 + screw_plate_extend_y / 2; // center of the exposed flange
    z_start = rail_base_bot_z - eps;
    h       = screw_plate_z + 2 * eps;

    // Hole in the half-width plate
    translate([x_base + screw_plate_half_x_keep * x_off,
               screw_plate_half_y_dir * y_off,
               z_start])
        cylinder(d = hole_d, h = h);

    // Hole in the full-width plate, on the half opposite to the half-width plate
    translate([x_base - screw_plate_half_x_keep * x_off,
               -screw_plate_half_y_dir * y_off,
               z_start])
        cylinder(d = hole_d, h = h);
}

// Side nut nook: rectangular slot inside the side nut holder block, holding
// the rail-locking hand-screw nut. Open on +X (extends well past the +X face
// of the block so the nut is loaded from outside in -X direction). Floor and
// ceiling within the block capture the nut vertically; the slot's outer-Y
// end backs up the nut axially when the screw is tightened.
module side_nut_nook_subtraction() {
    nut_av = hand_screw_nut_af / cos(30);
    nx = nut_av                + 2 * nut_nook_x_clear;   // X: hex AV + clearance
    ny = hand_screw_nut_thick  + 2 * nut_nook_y_clear;   // Y: nut thickness + clearance
    nz = hand_screw_nut_af     + 2 * nut_nook_z_clear;   // Z: hex AF + clearance

    // Slot extends from -nx/2 (deepest into block) to well past the +X face
    // of the block (open for nut loading from +X).
    slot_x_min    = side_nut_holder_x_center - nx / 2;
    slot_x_far    = side_nut_holder_x_center + side_nut_holder_x_size / 2 + 20;
    slot_x_size   = slot_x_far - slot_x_min;
    slot_x_center = (slot_x_min + slot_x_far) / 2;

    translate([slot_x_center, side_nut_holder_y_center, side_nut_holder_z_center])
        cube([slot_x_size, ny, nz], center = true);
}

// Rail-locking screw hole: cylinder along Y, from the outer Y face of the
// side nut holder, through the captive nut, through the rail base outer Y
// wall, and into the rail cavity (stops past the rail base center so it
// fully pierces the wall). The screw tip presses on the rail's outer Y face
// to lock the arm in place.
module side_screw_subtraction() {
    end_y_inside = -screw_plate_half_y_dir * eps;
    L = abs(side_nut_holder_y_outer - end_y_inside) + eps;

    translate([side_nut_holder_x_center,
               side_nut_holder_y_outer + screw_plate_half_y_dir * eps,
               side_nut_holder_z_center])
        rotate([screw_plate_half_y_dir * 90, 0, 0])
            cylinder(d = hand_screw_thread_d + bolt_clearance, h = L);
}

//==============================================================================
// 9. TOP-LEVEL LONG ARM PIECE
//==============================================================================

module long_arm() {
    // Lift so the bottom of the rail base sits at Z = 0.
    translate([0, 0, lower_height + rail_base_outer_z])
    difference() {
        union() {
            lower_body();
            upper_body();
            top_boss();
            // Hull blends the rectangular nut holder block into the
            // cylindrical inside boss so the exterior transitions smoothly
            // (no sharp 90° corner between block and cylinder). The
            // interior nut nook and bolt hole are still subtracted below,
            // so the rectangular nut pocket is preserved.
            hull() {
                inside_cyl_boss();
                nut_holder();
            }
            rail_base();
            screw_plates();
            side_nut_holder();
        }
        upper_bolt_hole();
        top_boss_inlet();
        hand_screw_subtractions();
        nut_nook_subtraction();
        screw_plate_holes();
        side_nut_nook_subtraction();
        side_screw_subtraction();
    }
}

//==============================================================================
// 10. ASSEMBLY
//==============================================================================
// Renders both pieces side by side. For printing, render long_arm() alone
// and duplicate / mirror in the slicer, or comment out one branch.
//==============================================================================

assembly_gap = 60;  // mm - visual separation in preview

module assembly() {
    translate([assembly_gap / 2, 0, 0])
        long_arm();

    if (render_mirrored_piece)
        translate([-assembly_gap / 2, 0, 0])
            mirror([1, 0, 0])
                long_arm();
}

assembly();
