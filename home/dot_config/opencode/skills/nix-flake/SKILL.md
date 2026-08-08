---
name: nix-flake
description: >
  Scaffold and package Nix-based development projects with flakes, dev shells, and direnv.
  TRIGGER whenever the user wants to create a flake, set up nix for a project, add a dev shell,
  package something with nix, use nix-init, or mentions flake.nix, devShell, .envrc, or
  "nix develop". Also trigger for "add nix to this project", "create a nix package",
  "set up direnv", or any work involving project-level flake authoring outside the dotfiles repo.
argument-hint: "[language/framework or URL to package]"
---

# Nix Flake — Project Scaffolding & Packaging

## When to Use

This skill is for **project-level** Nix work — creating flakes, dev shells, and packages for
individual repositories. For NixOS configuration in this repo, work in the `nixos/` modules
instead of using this project-scaffolding skill.

## Tooling

- **Nix MCP tool**: use `nix(action: search, source: nixos, type: packages, query: <name>)` to
  find exact package attribute names. Use `nix(action: info, ...)` for version/license details.
  Use `nix(action: search, source: noogle, query: <function>)` to look up `lib.*` helpers.
- **`nix-init`**: generates Nix package expressions from URLs. Available via `nix run nixpkgs#nix-init`.
  Supports Rust (`buildRustPackage`), Python (`buildPythonPackage`), Go (`buildGoModule`), and
  generic (`stdenv.mkDerivation`). Use `--headless` for non-interactive mode.

## Scaffolding a New Flake

### 1. Determine project type

Ask what language/framework the project uses. This determines:
- Which **inputs** to add (e.g. `rust-overlay` for Rust)
- Which **build dependencies** are needed
- Whether GUI deps are required

### 2. Create `flake.nix`

Use `flake-utils.lib.eachDefaultSystem` for multi-platform support. Base structure:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            # development tools here
          ];
        };
      }
    );
}
```

### 3. Language-specific inputs

**Rust** — add `rust-overlay` for toolchain control:
```nix
inputs.rust-overlay = {
  url = "github:oxalica/rust-overlay";
  inputs.nixpkgs.follows = "nixpkgs";
};
```
Then in the `let` block:
```nix
pkgs = import nixpkgs {
  inherit system;
  overlays = [ rust-overlay.overlays.default ];
};
rustToolchain = pkgs.rust-bin.stable.latest.default.override {
  extensions = [ "rust-src" ];
};
```

For other languages, the nixpkgs toolchain is usually sufficient (e.g. `pkgs.go`, `pkgs.python3`,
`pkgs.nodejs`). Only add overlays when the project needs specific toolchain versions or extensions.

### 4. Platform-specific GUI dependencies

GUI applications need different libraries on Linux vs macOS. Use `lib.optionals` to handle this
cleanly — it keeps the flake buildable on both platforms without manual edits.

```nix
guiLibs = with pkgs; lib.optionals stdenv.isLinux [
  wayland
  libxkbcommon
  egl-wayland
  libglvnd
  mesa
  libx11
  libxcursor
  libxrandr
  libxi
  fontconfig
  dbus
  alsa-lib
] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
  AppKit
  CoreFoundation
  CoreGraphics
  Security
]);
```

Then include `guiLibs` in both `buildInputs` (for the package) and the dev shell's
`LD_LIBRARY_PATH` (Linux only):

```nix
shellHook = lib.optionalString stdenv.isLinux ''
  export LD_LIBRARY_PATH="${lib.makeLibraryPath guiLibs}:$LD_LIBRARY_PATH"
'';
```

Only add GUI deps when the project actually renders a window. CLI tools don't need any of this.

### 5. Create `.envrc`

Every project gets a `.envrc` for direnv integration (already configured system-wide via HM):

```
use flake
```

If the project uses environment variables (API keys, config), add:
```
source_env_if_exists .env
```

Make sure `.envrc` and `.direnv/` are in `.gitignore`.

### 6. Packaging (optional)

If the user wants a buildable package (not just a dev shell), add a `packages.default` output.
The builder depends on the language:

- **Rust**: `pkgs.rustPlatform.buildRustPackage` with `cargoLock.lockFile`
- **Go**: `pkgs.buildGoModule` with `vendorHash`
- **Python**: `pkgs.python3Packages.buildPythonApplication`
- **Generic**: `pkgs.stdenv.mkDerivation`

For GUI packages, add `makeWrapper` to `nativeBuildInputs` and wrap the binary:
```nix
postFixup = ''
  wrapProgram $out/bin/<name> \
    --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}"
'';
```

Use `cleanSourceWith` to filter the source and avoid rebuilds from unrelated file changes.

### 7. Desktop entry (GUI apps)

For installable GUI applications, add a `.desktop` file:
```nix
desktopItem = pkgs.makeDesktopItem {
  name = "<reverse-dns-id>";
  desktopName = "<Display Name>";
  comment = "<short description>";
  exec = "<binary-name>";
  icon = "<reverse-dns-id>";
  categories = [ "<category>" ];
  terminal = false;
};
```
Include it via `desktopItems = [ desktopItem ];` in the derivation and install the icon in
`postInstall`.

## Packaging from a URL with `nix-init`

When the user wants to package an existing project from a URL (GitHub repo, tarball, etc.):

1. Run `nix-init` in headless mode:
   ```bash
   nix run nixpkgs#nix-init -- --headless --url <URL> -y <output.nix>
   ```
   Add `--builder` to specify the build system if known (e.g. `buildRustPackage`).

2. Read the generated file and review it — `nix-init` gives a solid starting point but often
   needs refinement (missing deps, incorrect license, missing `postInstall` steps).

3. Apply the patterns from this skill (platform deps, wrapping, desktop entries) as needed.

4. Validate with `nix build` and test the result.

## Validation

After creating or modifying a flake:

```bash
nix flake check    # validate structure and evaluate
nix flake show     # inspect outputs
nix build          # test the package builds
nix develop        # test the dev shell enters
```

If the project has a `justfile`, prefer its targets over ad-hoc commands.
