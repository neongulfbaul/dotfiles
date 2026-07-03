# System Context: NixOS Flake & Hyprland Workspace

## Core Stack & Host Specs
- **OS:** NixOS (Flake architecture) | **Host:** `atlas` | **User:** `neon`
- **Desktop:** Hyprland (Native Lua configuration engine)
- **Apps:** `foot` (Terminal), `rofi` (Launcher), `mako` (Notifications)

## Structural Constraints
1. **Zero External Frameworks:** Do NOT use or reference Henrik Lissner's custom `hey` CLI, `dms-shell`, or `matugen` modules. 
2. **No UWSM:** Keep session initialization strictly native via standard NixOS window manager options (`withUWSM = false`).
3. **File Isolation:** Do NOT import or reference external helper/utility modules unless they are explicitly visible in this directory tree. Every script generated must be completely self-contained.

## Coding & Deployment Style
- Mimic Lissner's hyper-organized style, featuring explicit section titles:
  `-- ── SECTION TITLE ─────────────────────────────────────────────`
- Nix modules (`modules/desktop/hyprland.nix`) must strictly handle the bootstrap block, passing the local monitor array and hostname to `~/.config/hypr/hyprland.lua`. 
- Delegate all keybinds, shortcuts, and core layout rules to a clean, decoupled local file like `config/hypr/hyprland_main.lua`.

## Interaction Protocol
- Always outline a bulleted file blueprint before writing code.
- Ask for permission before modifying files.
- Prompt the user to run `nixos-rebuild build` after changes to verify syntax alignment.
