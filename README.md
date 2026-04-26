# 3D Print Model Repository Template

Use this template as a clean starting point for a single 3D model (or small model set), with source design files separated from publication-ready assets.

## Repository Layout

- `src/`  
  Editable source/design files.
  - Examples: CAD files, project files, parametric models, working exports.
  - In derived repos, add tool-specific subfolders as needed.

- `publication/`  
  Platform-specific release folders.
  - In derived repos, create one subfolder per destination platform.
  - Examples: `publication/MakerWorld/`, `publication/Printables/`.

Each top-level folder includes its own `README.md` with folder-specific guidance.

## Suggested Workflow

1. Create or update design files in `src/`.
2. Export/prepare release assets for each destination.
3. Place destination-specific files in `publication/<platform>/`.
4. Keep source and publication assets separate to avoid confusion.

## What to Edit in Derived Repositories (Minimal)

- Update this README title/intro with the model name.
- Add platform folders under `publication/`.
- Add tool/app subfolders under `src/`.
- Optionally add a short changelog section for versioned releases.

## Optional Additions for Derived Repos

- A model photo/renders folder (if desired).
- License details for model usage/remix terms.
- Print settings summary (material, layer height, infill, supports).
- Bill of materials or assembly notes for multi-part models.

## Naming Tips

- Use clear, stable folder names (tool or platform names).
- Prefer versioned filenames for major releases (for example `v1`, `v2`).
- Keep naming consistent across source and publication assets.

## Release Checklist

- [ ] Confirm source files are up to date in `src/`.
- [ ] Export final printable files and place platform-ready assets in `publication/<platform>/`.
- [ ] Add final screenshots/renders and listing text for each platform.
- [ ] Verify print settings notes (material, layer height, supports, infill) are included.
- [ ] Check license/remix terms are clearly documented.
- [ ] Tag a release version after publishing.

## Included Template Files

- `.gitignore` for common temporary/cache/export artifacts from CAD and slicer workflows.
- `.gitattributes` with normalization and common 3D file-type hints.
