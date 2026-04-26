# PCB Holder Extension

An OpenSCAD-designed extension for standard PCB holders that enables mounting wider/longer PCBs that exceed the original holder's capacity.

## Target Holders

This extension is designed for standard PCB holders with ~200×140mm max capacity:

| Brand | Model | Max PCB Size | Link |
|-------|-------|--------------|------|
| Noah | NH-11E | 200×140mm | [Amazon](https://www.amazon.com/Noah-Adjustable-Soldering-Desoldering-Rotation/dp/B0CY4DRHWK/) |
| Pro's Kit | SN-390 | 200×140mm | [Adafruit](https://www.adafruit.com/product/3791) |

![PCB Holder](images/pcb-holder-proskit.png)

### Pro's Kit SN-390 Specifications
- **Material**: ABS arms + metal base
- **Dimensions**: 300 × 165 × 125mm
- **Weight**: 450g
- **Features**: 4 slots for varying PCB thicknesses, non-slip rubber pads, 360° rotation

## Problem

Standard PCB holders (like the Noah model above) allow:
- Horizontal expansion left and right
- Rotation of PCBs in spring-loaded braces

However, they have size limitations. When PCBs exceed these limits, rotation becomes impossible because the PCB hits the holder's frame.

## Solution

This extension mounts on **both sides** of the vertical holders, effectively widening the usable area to accommodate larger PCBs that need to be rotated during assembly or testing.

### Mounting Method

The extension pieces:
1. **Slide through** the retainer-help bolt hole from inside to outside
2. **Secure with a bolt and nut** through the extension
3. **Extend vertically** above the original arm (height is a parameter)
4. Only one piece needed - **mirror** for the other side

### Measured Arm Dimensions

| View | Bottom | Top |
|------|--------|-----|
| Side (force direction) | 30mm | 20mm |
| Front (facing PCB) | 24mm | 16mm |

- **Retainer bolt hole**: 4mm diameter, protrudes ~4mm toward center

## Repository Layout

- `src/`  
  OpenSCAD source files for the extension design.
  - Parametric design allowing customization for different holder sizes.
  - Includes tolerance values optimized for FDM 3D printing.

- `publication/`  
  Platform-specific release folders.
  - In derived repos, create one subfolder per destination platform.
  - Examples: `publication/MakerWorld/`, `publication/Printables/`.

Each top-level folder includes its own `README.md` with folder-specific guidance.

## Design Specifications

- **Material**: PETG or PLA (PETG recommended for durability)
- **Layer height**: 0.2 mm
- **Infill**: 20-25%
- **Supports**: May be required depending on orientation
- **Nozzle**: 0.4 mm (minimum wall: 0.8-1.2 mm)

## Key Features

- Mounts to both sides of vertical PCB holder posts
- Maintains compatibility with spring-loaded brace mechanism
- Parametric design for customization
- FDM-optimized with proper tolerances

## Suggested Workflow

1. Customize dimensions in OpenSCAD for your specific holder.
2. Export to STL for your slicer.
3. Print with appropriate settings for your material.
4. Mount extension pieces to both sides of holder posts.
5. Test fit with your largest PCB before rotation.
