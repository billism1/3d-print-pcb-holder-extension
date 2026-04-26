# PCB Holder Extension — Design Plan

## Target Hardware (measured)

| Property | Value |
|---|---|
| Arm height | 80 mm |
| Arm cross-section, bottom | 24 mm (front view, L-R) × 30 mm (side view, F-B) |
| Arm cross-section, top | 16 mm (front view, L-R) × 20 mm (side view, F-B) |
| Retainer bolt hole | 4 mm dia, axis runs **left-right** through the 24 mm width |
| Retainer bolt hole height | 65 mm from arm bottom (= 15 mm from top) |
| Boss around bolt hole | 15.8 mm OD, protrudes 4 mm from **inner side face** |
| Hand screw axis | **front-to-back** through the arm |
| Hand screw thread OD | 3.85 mm (use ~4 mm clearance hole) |
| Hand screw nut | 7 mm across flats (M4 hex) |

## Coordinate Convention

- **X axis**: left-right (matches arm's "front view" / 24 mm dimension; retainer bolt axis)
- **Y axis**: front-to-back (matches arm's "side view" / 30 mm dimension; hand screw axis)
- **Z axis**: vertical (arm height)
- Origin at the bottom-center of the arm's top face when the extension is seated (i.e., extension's sleeve cavity ceiling sits at Z = 0; positive Z goes up into the extension; negative Z goes down into the sleeve over the arm)

## Geometry Breakdown

### 1. Sleeve over arm top (negative Z region)
- Hollow tapered cap that slides down over the arm's top
- **Sleeve depth**: 25 mm (covers bolt hole at 15 mm + 10 mm extra grip)
- **Inner cavity** matches arm taper + tolerance:
  - At Z = 0 (arm top, extension ceiling): 16 mm (X) × 20 mm (Y) + 0.2 mm per side → 16.4 × 20.4
  - At Z = -25 (bottom of sleeve): linearly interpolated arm width at (80 - 25) = 55 mm from bottom = 16 + (24-16) × 25/80 = 18.5 mm (X), 20 + (30-20) × 25/80 = 23.125 mm (Y) + tolerance → ~18.9 × 23.5
- **Outer wall**: inner cavity + 3 mm wall thickness on each side
- Built with `hull()` of two stacked rounded rectangles (top + bottom of sleeve) for outer shell, then subtract a `hull()` of inner cavity profiles

### 2. Lower mount — bolt hole + boss clearance recess + nut pocket
- Located at Z = -15 (aligns with arm's retainer bolt hole)
- **Through-hole**: 4 mm + clearance (4.3 mm) along X axis through both sleeve walls
- **Boss clearance recess**: cylindrical pocket on the **-X (inner) cavity wall**, sized to receive the arm's protruding boss
  - Diameter: 15.8 + 0.4 = 16.2 mm
  - Depth: 4.3 mm (clears the 4 mm boss protrusion + 0.3 mm clearance)
  - Punches through the 3 mm sleeve wall, leaving an opening on the -X face — this is intended; the boss seats into the opening and acts as the primary alignment feature
- **Nut pocket**: hex recess on the **+X (outer) face**
  - 7 mm A/F, 3 mm deep, captures M4 nut, opens outward
- **Assembly**: insert nut into +X pocket from outside, slide extension over arm (boss snaps into recess), thread M4 bolt from -X (inner side) through arm and into captured nut
- Note: the snug taper-fit of the sleeve over the arm + the boss-in-recess engagement provide alignment and anti-rotation; the bolt provides the fastening

### 3. Upper extension (positive Z region)
- Rises `extension_height` mm above arm top (default: 40 mm, parameterized)
- Profile continues the arm's taper:
  - At Z = 0 (base of upper section): matches arm-top outer dimensions = 16 × 20 mm + walls = 22 × 26 mm outer (matches sleeve outer at top)
  - At Z = `extension_height` (top of extension): narrows further at the same taper rate as the arm
    - X taper rate: (24-16)/80 = 0.1 mm/mm → at Z = 40, X = 16 - 0.1 × 40 = 12 mm; outer = 18 mm
    - Y taper rate: (30-20)/80 = 0.125 mm/mm → at Z = 40, Y = 20 - 0.125 × 40 = 15 mm; outer = 21 mm
- Solid body (no internal cavity in the upper section)
- Built with `hull()` of two stacked rounded rectangles (base + top of upper section)

### 4. Top mounting — mirrors original arm geometry
- Located 15 mm below the top of the extension (mirrors original arm's 15-mm-from-top bolt position)
- **Through-hole**: 4 mm dia along X axis, all the way through
- **Boss on inner side face**: 15.8 mm OD × 4 mm protrusion (cylinder added to the inner face, concentric with through-hole)
- **Hand screw assembly** (front-to-back, Y axis):
  - 4 mm clearance through-hole along Y axis (for 3.85 mm threaded shaft)
  - 7 mm A/F hex nut pocket on the **back face** (Y- side), ~3 mm deep, captures the M4 nut
  - Same height as the top through-hole, intersects it (the screw tip presses on the bolt to lock it, just like in the original arm)

### 5. Assembly
- Render one piece (e.g., the right-arm version, with peg/boss on the X- inner face)
- For the other arm: `mirror([1, 0, 0])` translated copy
- The top-level assembly produces both pieces side by side for visualization

## Parameters Summary

| Parameter | Default | Notes |
|---|---|---|
| `extension_height` | 40 mm | Vertical rise above arm top |
| `sleeve_depth` | 25 mm | How far down sleeve covers arm |
| `wall_thickness` | 3 mm | Sleeve and upper extension wall |
| `surface_tolerance` | 0.2 mm | Per-side clearance in sleeve cavity |
| `bolt_clearance` | 0.3 mm | Through-hole oversize for M4 bolt |
| `top_bolt_offset_from_top` | 15 mm | Mirrors arm's bolt-from-top distance |
| `boss_recess_clearance` | 0.4 mm | Added to boss OD for slip fit |
| `boss_recess_depth` | 4.3 mm | Clears 4 mm boss protrusion |
| `boss_od` | 15.8 mm | Matches arm boss for bracket remount |
| `boss_protrusion` | 4 mm | Matches arm boss |
| `nut_size` | 7 mm | M4 hex A/F |
| `nut_depth` | 3 mm | Pocket depth |
| `arm_height` | 80 mm | Reference, used to compute taper |
| Arm taper constants | (as measured) | Used to compute sleeve cavity at any Z |

## File Organization (per OpenSCAD prompt guidance)

1. Constants & parameters (target arm + extension)
2. Derived dimensions (taper interpolations, outer dimensions)
3. Helper modules (`rounded_rect`, `tapered_box`, `hex_pocket`)
4. Component modules (`sleeve`, `lower_mount_features`, `upper_body`, `top_mount_features`)
5. Top-level: `extension_piece()` module unioning components and subtracting holes; `assembly()` placing one + mirrored copy
