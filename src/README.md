# Source Files

This folder contains OpenSCAD source files for the PCB holder extension.

## Compatible Holders

Both holders have **200×140mm max PCB capacity**:

| Brand | Model | Material | Link |
|-------|-------|----------|------|
| Noah | NH-11E | Metal base, plastic clamps | [Amazon](https://www.amazon.com/Noah-Adjustable-Soldering-Desoldering-Rotation/dp/B0CY4DRHWK/) |
| Pro's Kit | SN-390 | ABS arms + metal base | [Adafruit](https://www.adafruit.com/product/3791) |

![PCB Holder](../images/pcb-holder-proskit.png)

### Pro's Kit SN-390 Specifications (from Adafruit)
- **Dimensions**: 300 × 165 × 125mm
- **Weight**: 450g
- **Features**: 4 slots for varying PCB thicknesses, non-slip rubber pads, 360° rotation

## OpenSCAD File

- `pcb-holder-extension.scad` — Parametric design for the extension

### Key Parameters (in the .scad file)

| Parameter | Default | Description |
|-----------|---------|-------------|
| `arm_width_side_bottom` | 30mm | Width at bottom (side view) |
| `arm_width_side_top` | 20mm | Width at top (side view) |
| `arm_width_front_bottom` | 24mm | Width at bottom (front view) |
| `arm_width_front_top` | 16mm | Width at top (front view) |
| `arm_height` | 80mm | Total height of vertical arm |
| `extension_height` | 40mm | Extra height above original arm |
| `retainer_bolt_hole_d` | 4mm | Diameter of retainer bolt hole |

### Mounting Approach

- Extension slides through the retainer bolt hole from inside to outside
- Secured with M4 bolt and nut through the extension
- Only one piece needed - mirror for the other side
- Height parameter allows customization

### Design Notes

- **Parametric**: Adjust dimensions at the top of the file to match your specific holder
- **FDM-optimized**: Includes tolerances for 3D printing (0.5mm clearance for press-fit)
- **Two pieces**: One for left side, one for right side
- **Visualization**: Includes a preview showing the extension in context with the holder

## Design Notes

- Uses FDM-optimized tolerances (see main README for print settings)
- Parametric design — modify variables at the top of each `.scad` file to customize
- Includes measurement notes for refining the design after measuring your holder
