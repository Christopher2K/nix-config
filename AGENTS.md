# NixConfig — Agent Guidelines

This is a NixOS/Home Manager configuration repository structured as a Nix flake. It manages
multiple hosts (`nixbook`, `macbook`, `macbook-cookunity`) and a single user (`christopher`). The
entire config is written in Nix using `flake-parts` and `import-tree` to auto-import all modules
under `modules/`.

---

## Repository Layout

```
flake.nix                  # Entrypoint: delegates to flake-parts via import-tree
modules/
  flake-modules.nix        # Imports flake-parts and home-manager flake modules
  helpers.nix              # Shared utilities (mkAssetsPath, mkHybrid, etc.) and flake-level options
  features/                # Feature modules (ai, browser, cli-tooling, coding, communication,
                           #   design, desktop-shell, gaming, gnome-apps, graphics, homebrew,
                           #   launcher, mise-fixes, productivity, security, sound, splashscreen,
                           #   storage, streaming, terminal, theme, window-manager, …)
  hosts/                   # Per-host configurations
    nixbook/               # Main Linux host (NixOS, x86_64-linux)
    macbook/               # Personal macOS host (nix-darwin, aarch64-darwin)
    macbook-cookunity/     # Work macOS host (nix-darwin, aarch64-darwin)
  users/
    christopher.nix        # Home Manager base user config
assets/                    # Static files symlinked into $HOME (nvim config, scripts, wallpapers, …)
```

---

## Build & Apply Commands

### Validate the flake (evaluation + type checks, no build)
```bash
nix flake check
```

### Build a NixOS configuration without switching
```bash
nix build .#nixosConfigurations.nixbook.config.system.build.toplevel
```

### Apply the NixOS config (on the nixbook host)
```bash
sudo nixos-rebuild switch --flake .#nixbook
```

### Apply the macOS (nix-darwin) config
```bash
sudo darwin-rebuild switch --flake .#macbook
# or from zsh alias:
switch
```

### Update all flake inputs
```bash
nix flake update
```

### Update a single input
```bash
nix flake update nixpkgs
```

---

## Formatting

The project uses `nixfmt` (version 1.2.0, the "RFC 166" style) for all `.nix` files.

### Format all Nix files
```bash
nixfmt **/*.nix
# or per-file:
nixfmt modules/features/ai.nix
```

There is no `formatter` output defined in the flake yet, so `nix fmt` will error — use `nixfmt`
directly.

---

## Testing / Linting

There is no automated test suite. The primary validation mechanism is:

```bash
nix flake check          # Evaluates all nixosConfigurations and nixosModules
```

To dry-run a configuration switch (build without activating):
```bash
sudo nixos-rebuild dry-activate --flake .#nixbook
```

To check a specific host evaluation only:
```bash
nix eval .#nixosConfigurations.nixbook.config.system.build.toplevel
```

---

## Nix Code Style

### Indentation & Formatting
- **2 spaces** for `.nix`, `.lua`, `.json`, `.jsonc` files (enforced by `.editorconfig`).
- **LF** line endings, files must end with a final newline.
- `nixfmt` is the canonical formatter — run it before committing changes.

### Function Argument Style
- Short argument lists go on one line: `{ inputs, ... }:`
- Longer lists use one argument per line with a trailing comma, closing brace on its own line:
  ```nix
  {
    inputs,
    config,
    ...
  }:
  ```

### `let` Bindings
- Always define `let … in` blocks at the top of a file or function body, not inline.
- Destructure helpers and commonly-used values early:
  ```nix
  let
    username = config.flake.username;
    helpers  = config.flake.helpers;
  in
  ```

### Module Structure
Each feature file exposes its configuration under three namespaces:
- `flake.modules.nixos.<name>` — NixOS system-level module
- `flake.modules.darwin.<name>` — nix-darwin system-level module
- `flake.modules.homeManager.<name>` — Home Manager user-level module

Not every feature needs all three; omit namespaces that don't apply.

### Attribute Sets
- Opening brace on the same line as the binding for short sets.
- Multi-line sets: opening brace at end of the assignment line, closing brace aligned with the
  binding keyword.
- Use `with pkgs;` only inside `home.packages = with pkgs; [ … ]` list expressions; avoid `with`
  elsewhere.

### Lists
- Short lists on one line: `[ "a" "b" ]`
- Longer lists: one element per line, brackets on their own lines:
  ```nix
  home.packages = with pkgs; [
    bat
    fzf
    ripgrep
  ];
  ```

### String Interpolation & Paths
- Use `helpers.mkAssetsPath "/subpath"` to reference files under `assets/` as a **Nix store path**
  (evaluated at build time).
- Use `helpers.mkAssetsStringPath hmConfig "/subpath"` to reference `assets/` files as a **string
  path** (`~/NixConfig/assets/<path>`) — use this for live symlinks that must not enter the store.
- Use `helpers.mkConfigPath hmConfig "/subpath"` for `~/.config/` paths.
- Use `helpers.mkHomePath hmConfig "/subpath"` for `~/` paths.
- Prefer `config.lib.file.mkOutOfStoreSymlink` for mutable/live-edited assets (e.g., the Neovim
  config) so changes don't require a rebuild.
- Use `helpers.mkHybrid { linux? darwin? common? }` to create a Home Manager module that
  conditionally applies config per platform — `common` is always included, `linux`/`darwin` are
  guarded with `lib.mkIf` for the matching platform.

### Naming Conventions
- Feature module names match their filename without extension (e.g., `cli-tooling`, `window-manager`).
- NixOS module attributes use `camelCase` for multi-word names when the filename uses kebab-case
  (e.g., `nixbookConfiguration`).
- Options and config keys follow nixpkgs conventions: `camelCase` for option names.

### Overlays
- Define overlays as a top-level `let` binding when shared across `nixos` and `darwin` modules:
  ```nix
  let
    overlays = [ inputs.foo.overlays.default … ];
  in
  {
    flake.modules.nixos.foo  = { nixpkgs.overlays = overlays; };
    flake.modules.darwin.foo = { nixpkgs.overlays = overlays; };
  }
  ```

### Comments
- Use `#` inline comments to explain non-obvious choices (e.g., workaround links, performance
  rationale).
- Section headers use a blank line above and a short `# Section title` comment.

---

## Important Notes for Agents

- **Never hardcode usernames** — always use `config.flake.username` (resolves to `"christopher"`).
- **Never hardcode home paths** — always use the `helpers.*` path functions.
- **`allowUnfree = true`** is set system-wide; proprietary packages are permitted.
- **Supported systems**: `x86_64-linux` and `aarch64-darwin` (defined in `helpers.nix`).
- `nixpkgs.config.allowUnfree` must be set in the NixOS/darwin system module, not in Home Manager.
- When adding a new feature, create `modules/features/<name>.nix` and add it to the relevant host's
  `default.nix` imports under both the system-level and `home-manager.users.${username}.imports`
  lists.
- `import-tree` automatically picks up any `.nix` file added under `modules/`; no manual
  registration in `flake.nix` is needed.
- The `switch` shell alias runs the correct rebuild command per platform (Linux vs. Darwin).
