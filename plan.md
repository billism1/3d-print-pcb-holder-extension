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

The extension is a **C-shaped channel** that slips onto the arm horizontally from the inner (PCB-facing) side, NOT from the top. The "outer" face is fully open.

- **+X = outer side** (away from PCB center) → **OPEN**; this is the side the extension is pressed onto the arm from
- **-X = inner side** (toward PCB center) → closed wall; carries top boss
- **+Y = front face** → closed wall; carries hand-screw through-hole
- **-Y = back face** → closed wall; carries hand-screw nut pocket
- **+Z = up** → origin Z = 0 sits at the top face of the arm (sleeve extends down to Z = -sleeve_depth, upper body extends up to Z = +extension_height)

## Geometry Breakdown

### 1. Sleeve (lower section, Z = -25 to 0)
- C-shaped tapered channel covering the upper portion of the arm
- Three walls: -X (inner), +Y (front), -Y (back); +X is open
- **Sleeve depth**: 25 mm
- **Cavity** matches arm taper + 0.2 mm/side tolerance:
  - At Z = 0: 16.4 × 20.4 mm
  - At Z = -25: ~18.9 × 23.5 mm
- **Outer**: cavity + 3 mm wall on each side
- Implementation: hull() outer tapered box, then subtract a cavity tapered box that's been widened in +X by `wall_thickness` so it punches through the +X wall entirely while leaving the -X wall intact

### 2. Lower mount — boss clearance hole on -X wall
- Located at Z = -15 (aligns with arm's retainer bolt hole)
- **Boss clearance hole**: 16.2 mm dia, cuts entirely through the 3 mm -X wall
  - The arm's 15.8 mm boss seats into this hole as the extension is pressed onto the arm from the +X open side
  - Boss protrudes 4 mm but wall is only 3 mm → boss tip sticks ~1 mm proud of the -X face (intentional and harmless)
- **Bolt + nut**: M4 bolt threads from -X side through the boss (4 mm hole) and through the arm; user holds an M4 nut against the arm's outer face — accessible because the +X side of the extension is open
- No captive nut feature on the lower mount (no room — the boss occupies the wall thickness)
- Alignment / anti-rotation comes from the snug 3-wall channel fit + the boss seated in the hole

### 3. Upper body (upper section, Z = 0 to +extension_height)
- Same C-shaped channel as the sleeve, continued upward
- Three walls (-X, +Y, -Y), open on +X
- Profile continues the arm's taper rates beyond the arm top:
  - X taper rate: (24-16)/80 = 0.1 mm/mm
  - Y taper rate: (30-20)/80 = 0.125 mm/mm
  - At Z = +40: inner ~12 × 15 mm, outer ~18 × 21 mm
- Implementation: same hull-outer-minus-cavity pattern as sleeve, with cavity widened in +X to punch the +X wall

### 4. Top mounting — mirrors original arm geometry
- Located 15 mm below the top of the extension
- **Bolt through-hole**: 4 mm + clearance along X axis, through the -X wall and through the boss
- **Boss on -X face**: 15.8 mm OD × 4 mm protrusion (added to the -X face of the upper body, concentric with the through-hole) — this is what the original PCB bracket clamps onto
- **Hand screw assembly** (front-to-back, Y axis, intersects the upper bolt hole):
  - 4 mm clearance through-hole along Y axis through both Y walls
  - 7 mm A/F hex nut pocket on the **-Y face**, ~3 mm deep, opens outward
  - Nut insertion: with the +X side open, the nut can be slid into the -Y pocket from inside the cavity OR loaded from the outside through the pocket opening
  - The screw tip presses on the bolt shaft to lock it, just like in the original arm

### 5. Assembly
- Render one piece (right-arm version)
- For the other arm: `mirror([1, 0, 0])` translated copy at the top level
- The piece is the same — same as the original arms being identical pieces, just rotated 180°

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
