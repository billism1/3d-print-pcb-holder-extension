//==============================================================================
// Rail-Lock Plastic Pin
//==============================================================================
// Companion piece to the PCB Holder Long Arm. Sits between the rail-locking
// hand-screw and the rail: the screw presses on the pin head, and the pin's
// shaft tip presses on the rail through the rail base outer wall.
//
// Print orientation: head on the build plate, shaft tip pointing up
// (+Z). Dimensions are nominal — the receiving pocket and shaft hole in
// pcb-holder-long-arm.scad already include their own clearance.
//==============================================================================

//==============================================================================
// 1. PIN DIMENSIONS
//==============================================================================

pin_head_d     = 4.5;   // mm - head diameter
pin_head_thick = 2.0;   // mm - head thickness (axial)
pin_shaft_d    = 3;     // mm - shaft diameter
pin_shaft_len  = 3;     // mm - shaft length (tip-to-head)

//==============================================================================
// 2. RENDER QUALITY
//==============================================================================

$fn = 64;
$fa = 0.5;
$fs = 0.1;

//==============================================================================
// 3. GEOMETRY
//==============================================================================

module rail_lock_pin() {
    // Head rests on the build plate (Z = 0 to head thickness),
    // shaft rises from head's top face up to its tip.
    union() {
        // Head
        cylinder(d = pin_head_d, h = pin_head_thick);
        // Shaft, stacked on top of the head
        translate([0, 0, pin_head_thick])
            cylinder(d = pin_shaft_d, h = pin_shaft_len);
    }
}

rail_lock_pin();
