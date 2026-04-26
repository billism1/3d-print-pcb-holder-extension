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
    
    // Calculate taper ratio for consistent narrowing
    taper_ratio = arm_width_front_top / arm_width_front_bottom;
    
    // Extension dimensions
    ext_total_height = arm_height + extension_height;
    ext_width_bottom = arm_width_front_bottom;
    ext_width_top = arm_width_front_top;
    
    // Create the tapered extension body
    difference() {
        // Main body with taper matching the original arm
        union() {
            // Bottom section (matches original arm width)
            translate([0, 0, 0])
                cube([ext_width_bottom, extension_depth, arm_height]);
            
            // Top section (tapered to match arm)
            translate([0, 0, arm_height])
                linear_extrude(height = extension_height)
                    polygon(points = [
                        [0, 0],
                        [ext_width_bottom - ext_width_top, 0],
                        [ext_width_bottom - ext_width_top, extension_depth],
                        [0, extension_depth]
                    ]);
        }
        
        // Cutout for retainer bolt hole
        // Positioned at the same height as the original bolt hole
        translate([
            ext_width_bottom / 2,
            extension_depth / 2,
            arm_height * 0.6  // Approximately where the original bolt hole is
        ]) {
            // Main bolt hole (through the extension)
            rotate([90, 0, 0])
                cylinder(h = extension_depth + 0.02, r = (mount_bolt_d / 2) + bolt_clearance);
            
            // Counterbore for nut (on the outside face)
            translate([0, extension_depth / 2 + 2, 0])
                rotate([90, 0, 0])
                    cylinder(h = 4, r = nut_size / 2 + 1);
        }
        
        // Optional: Lightening holes to reduce material
        for (y = [extension_depth * 0.25, extension_depth * 0.75]) {
            translate([ext_width_bottom / 2, y, arm_height * 0.3])
                rotate([90, 0, 0])
                    cylinder(h = 6, r = 4);
            translate([ext_width_bottom / 2, y, arm_height * 0.5])
                rotate([90, 0, 0])
                    cylinder(h = 6, r = 4);
            translate([ext_width_bottom / 2, y, arm_height * 0.7])
                rotate([90, 0, 0])
                    cylinder(h = 6, r = 4);
        }
    }
    
    // Add mounting tab for additional stability
    translate([ext_width_bottom / 2, -2, arm_height * 0.6])
        cube([10, 4, 15]);
}

//==============================================================================
// MODULE: Complete Assembly (both sides - mirrored)
//==============================================================================
module pcb_holder_extension_assembly() {
    
    // Left extension piece
    extension_piece(mirror = false);
    
    // Right extension piece (mirrored)
    translate([arm_width_front_bottom * 2 + 10, 0, 0])
        mirror([1, 0, 0])
            extension_piece(mirror = true);
}

//==============================================================================
// MODULE: Visualization with Holder Outline
//==============================================================================
module visualization() {
    
    // Original holder outline (approximate)
    color([0.7, 0.7, 0.7, 0.3])
        translate([0, 0, 0])
            cube([200, 20, 140]);
    
    // Left arm (tapered)
    color([0.5, 0.5, 0.5, 0.5]) {
        // Bottom section
        translate([0, 5, 0])
            cube([arm_width_front_bottom, 10, arm_height]);
        // Visual taper indication
        translate([0, 5, arm_height])
            linear_extrude(height = 1)
                polygon(points = [
                    [0, 0],
                    [arm_width_front_bottom - arm_width_front_top, 0],
                    [arm_width_front_bottom - arm_width_front_top, 10],
                    [0, 10]
                ]);
    }
    
    // Right arm (tapered)
    color([0.5, 0.5, 0.5, 0.5]) {
        translate([200 - arm_width_front_bottom, 5, 0])
            cube([arm_width_front_bottom, 10, arm_height]);
    }
    
    // Left extension (this design)
    color([0.2, 0.6, 0.9, 0.8])
        extension_piece(mirror = false);
    
    // Right extension (this design - mirrored)
    color([0.2, 0.6, 0.9, 0.8])
        translate([200 - arm_width_front_bottom + arm_width_front_bottom + 10, 0, 0])
            mirror([1, 0, 0])
                extension_piece(mirror = true);
}

//==============================================================================
// 5. OUTPUT - Uncomment the module you want to render
//==============================================================================

// Render just one extension piece
extension_piece(mirror = false);

// Render the complete assembly (both sides)
//pcb_holder_extension_assembly();

// Render visualization with holder outline
//visualization();

//==============================================================================
// DESIGN NOTES FOR REFINEMENT
//==============================================================================
// 
// Current measurements based on user description:
// - Side view: 30mm bottom → 20mm top
// - Front view: 24mm bottom → 16mm top  
// - Retainer bolt: 4mm hole, protrudes ~4mm toward center
//
// Mounting approach:
// 1. Extension slides through the retainer bolt hole from inside to outside
// 2. Bolt and nut secure it in place
// 3. Extension extends vertically above the original arm
// 4. Only one piece needed - mirror for the other side
//
// TODO: Verify the exact position of the retainer bolt hole on the arm
//       (currently estimated at 60% of arm height)
//==============================================================================
// PRINT SETTINGS RECOMMENDATIONS
//==============================================================================
// Material: PETG (recommended for durability) or PLA
// Layer height: 0.2 mm
// Infill: 20-25%
// Supports: May be needed depending on orientation
// Nozzle: 0.4 mm (minimum wall: 0.8-1.2 mm)
//==============================================================================