//==============================================================================
// PCB Holder Extension
//==============================================================================
// Target: Standard PCB holders with ~200x140mm max PCB capacity
// Compatible with:
//   - Noah NH-11E (Amazon B0CY4DRHWK)
//   - Pro's Kit SN-390 (Adafruit 3791)
//     * Specifications: 300x165x125mm, 450g, ABS arms + metal base
//     * Max PCB: 200x140mm, 4 slots for PCB thickness, 360° rotation
//
// Mounting: Slides through the retainer-help bolt hole from inside to outside
//           Secured with bolt and nut through the extension
//==============================================================================

//==============================================================================
// 1. TARGET HOLDER DIMENSIONS (measured)
//==============================================================================

// Vertical arm dimensions (side view - where force is applied to press bracket)
// The arm tapers from wider at bottom to narrower at top
arm_width_side_bottom = 30;   // mm - width at bottom of arm (side view)
arm_width_side_top = 20;      // mm - width at top of arm (side view)

// Vertical arm dimensions (front view - facing PCB)
// The arm tapers from wider at bottom to narrower at top
arm_width_front_bottom = 24;  // mm - width at bottom of arm (front view)
arm_width_front_top = 16;     // mm - width at top of arm (front view)

// Retainer-help bolt specifications
retainer_bolt_hole_d = 4;     // mm - diameter of the hole for the bolt
retainer_bolt_protrusion = 4; // mm - how far the bolt head protrudes toward center

// Height of the original holder arm (for reference)
arm_height = 80;              // mm - total height of the vertical arm

//==============================================================================
// 2. EXTENSION PARAMETERS
//==============================================================================

// How much extra vertical height to add above the original arm
extension_height = 40;        // mm - extra height above the original arm top

// Wall thickness for the extension
wall_thickness = 3;           // mm

// Depth/thickness of the extension (matches arm depth)
extension_depth = 10;        // mm - thickness from front to back

// Bolt hole diameter for securing the extension
mount_bolt_d = 4;            // mm - M4 bolt through the retainer hole
nut_size = 7;                // mm - hex nut size for M4

//==============================================================================
// 3. TOLERANCES FOR FDM 3D PRINTING
//==============================================================================

// Clearance for bolt hole (press-fit)
bolt_clearance = 0.3;         // mm - extra for bolt fit

// Tolerance for mating surfaces
surface_tolerance = 0.2;      // mm

//==============================================================================
// 4. RENDER QUALITY SETTINGS
//==============================================================================

$fn = 64;                      // Facet count for smooth curves
$fa = 0.5;                    // Minimum angle in degrees
$fs = 0.1;                    // Minimum facet size in mm

//==============================================================================
// MODULE: Single Extension Piece
//==============================================================================
// Creates one extension piece that:
//   - Slides through the retainer bolt hole from inside to outside
//   - Extends vertically above the original arm
//   - Tapers to match the arm's narrowing profile
//
// Parameters:
//   mirror = false for left side, true for right side
//==============================================================================
module extension_piece(mirror = false) {
    
}
