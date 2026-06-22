# PCB Holder Arm Extension & Replacement: Hold Oversized PCBs (Noah NH-11E / Pro's Kit SN-390)

Two 3D-printable solutions for holding wider/taller PCBs that a standard PCB holder can't rotate: a cap-on **extension** that adds height to your existing arms, and a full **replacement arm** that swaps onto the base rail. Compatible with common ~200×140mm holders.

> **Disclaimer:** Independent, non-commercial project. **Not affiliated with, authorized, sponsored, or endorsed by Noah, Pro's Kit, or any holder manufacturer.** Brand and model names ("Noah," "NH-11E," "Pro's Kit," "SN-390") are used only to identify the holders these parts are compatible with (nominative fair use). All trademarks are the property of their respective owners.

> **Source & Documentation:** Full OpenSCAD source, photos, and documentation: [github.com/billism1/3d-print-pcb-holder-extension](https://github.com/billism1/3d-print-pcb-holder-extension)

This one's my dad's fault. He designs and works on PCBs bigger than these standard holders can handle. The spring-loaded braces grab the board fine, but it's just too long or wide to flip. So he asked me, very casually, if I could maybe make some kind of little extension for the arms. The fix is conceptually simple: just *more arm*, lifting the grip point higher so a big board clears the frame as it spins.

So I designed the snap-on extension. Done, right? Except then I had the thought every maker has had right before losing a weekend: "*...it really wouldn't be much more effort to just...*" And that's how the full arm replacement happened too. Turned out to be maybe 30% more effort, which my brain rounded down to "free". Now there are two solutions instead of one.

Full disclosure: I dabble in electronics, but I rarely touch PCBs big enough to actually need this. This was a Father's Day gift. And I'll be honest: when my dad came over for Father's Day this year (2026) and saw these, I'm fairly sure the parts got a warmer reception than the rest of us did. Which I completely understand and kind of expected, knowing my dad. A custom-fit arm for the exact holder that's been annoying you for months? *That* you don't see coming. No notes, Dad. Priorities respected.

Both designs are built to **reuse all the original hardware from your holder's stock arms**, with nothing proprietary and no extra parts to source. Specifically, they reuse:

- The **PCB grip bolt**
- The **washer**
- The **retainer clip**
- The **hand screw** (and its **M4 hex nut**)

If your holder is one of the common ~200×140mm ones, the included print files should drop right in. If it's something else, the OpenSCAD source is on GitHub and every measurement is a variable at the top of the file.

## Two Approaches (Pick One)

**Approach 1: Cap-On Extension**
A C-shaped sleeve that slips down over the **top of your existing vertical arm** from the inner (PCB-facing) side. It reuses the original retainer bolt hole to lock on, and gives you an identical boss + captive-nut pocket at *its* top so the original spring-loaded PCB bracket and hand screw remount on the extension instead. No disassembly of the holder, no base modification. Print **two** (one per arm).

**Approach 2: Full Replacement Long Arm**
A complete drop-in replacement for the holder's stock vertical arm. A rail base at the bottom slides onto the holder's fixed rectangular rail; the body rises taller than the stock arm to a matching top boss + nut pocket. Includes a **side rail-lock pin** so you can lock the arm's position on the rail independently. Slides on from either side. Print **two**.

Either way, you reuse the holder's original hardware (grip bolt, washer, retainer clip, hand screw).

## What's Included

| File | What it is |
|------|------------|
| `pcb-holder-extension.stl` | Cap-on extension. Print **two** (one per arm). |
| `pcb-holder-long-arm_140mm.stl` | Full replacement arm, 140 mm tall. Print **two**. |
| `pcb-holder-long-arm_164mm.stl` | Full replacement arm, taller 164 mm variant for extra reach. Print **two**. |
| `rail-lock-pin.stl` | Replacement rail-lock pin for the long arm. Print only if your original pin is lost or worn. |
| `pcb-holder-extension.3mf` | Pre-arranged 3MF project of the extension. Open straight in your slicer. |

Pick the extension **or** one of the two long-arm heights. The two long-arm files are just different reach amounts, so print whichever clears your board.

## Compatibility

Designed and measured against standard PCB holders with ~200×140mm max capacity:

- **Noah NH-11E** (Amazon B0CY4DRHWK)
- **Pro's Kit SN-390** (Adafruit 3791)

These two appear to share the same arm/rail geometry. If your holder looks like these, the default print files should fit. If you're not sure, measure your arm against the dimensions below before printing two of anything.

**Measured stock arm dimensions:**

| View | Bottom | Top |
|------|--------|-----|
| Side (force direction) | 30 mm | 20 mm |
| Front (facing PCB) | 24 mm | 16 mm |

Retainer bolt hole ~4 mm diameter; boss protrudes ~4 mm toward the board.

## Key Features

- **Reuses all original hardware:** grip bolt, washer, retainer clip, and hand screw all carry over. Nothing proprietary.
- **Captive nut pockets:** the hand-screw nut loads into a pocket through the open side and is captured top/bottom, so you're not fishing for a loose nut during assembly.
- **Rounded PCB-facing edges** to match the look of the stock arm.
- **Long arm has a side rail-lock pin** that presses the rail from the side, locking the arm's position without relying on the hand screw alone.
- **Self-supporting geometry:** bosses and internal blocks are tapered so most of it prints without support.
- **Fully parametric OpenSCAD:** every holder dimension is a variable. Different holder? Edit and re-export.

## Print Settings

- **Material:** PLA+, PETG, PCTG, ABS, ASA, or similar. Tested with PLA+ and PCTG; both showed no signs of weakness and either should be plenty strong for most users.
- **Layer height:** 0.2 mm
- **Infill:** 20–25%
- **Walls:** 0.4 mm nozzle, 0.8–1.2 mm minimum wall
- **Supports:** May be needed depending on orientation; the included files are oriented to minimize them.

## Assembly

**Shared hardware steps (both approaches):**
1. Slide the PCB grip bolt (reused from the original holder) through the bolt hole from the inside to the outside.
2. Place the original washer onto the bolt on the outside.
3. Press the original retainer clip onto the washer to lock it. The washer stops the grip bolt from sliding out; the inner grip holds the rest in place.

**Extension:**
1. Slide the extension cap down over the top of the existing vertical arm from the inner side.
2. Secure through the original retainer-bolt hole, then follow the shared hardware steps above.
3. Remount the spring-loaded PCB bracket and hand screw on the extension's top boss.
4. Repeat for the other arm.

**Long Arm (Replacement):**
1. Slide the original vertical arm off the base rail and remove the hand screw.
2. Slide the replacement arm onto the rail from either side.
3. Lock its position with the rail-lock pin and hand screw.
4. Follow the shared hardware steps above to remount the PCB bracket.
5. Repeat for the other arm.

> **Rail-lock pin:** The pin sits between the hand-tightened screw and the rail; tightening the screw presses the pin against the rail to lock the arm's position. A replacement pin STL is included in case the original is lost or worn. Position it carefully before tightening the screw.

## Customizing for a Different Holder

Everything is parametric. If your holder isn't one of the two listed above, grab the OpenSCAD source from GitHub, measure your arm (cross-section at top and bottom, bolt height, rail size), set the variables at the top of the file, and export your own STL.

- `pcb-holder-extension.scad`: cap-on extension
- `pcb-holder-long-arm.scad`: full arm replacement
- `rail-lock-pin.scad`: replacement rail-lock pin

## Notes

Test-fit with your largest PCB *before* you rely on this for a rotation. The whole point is clearing the frame on rotation, so spin it through the full range and make sure nothing collides. Use at your own risk; it's a printed bracket holding a board you presumably care about.

## Source & Documentation

OpenSCAD source, photos, and full documentation: [github.com/billism1/3d-print-pcb-holder-extension](https://github.com/billism1/3d-print-pcb-holder-extension)
