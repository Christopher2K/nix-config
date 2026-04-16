# NixConfig

A cross-machine, cross-OS Nix flake configuration for NixOS and macOS (nix-darwin), managing
packages, dotfiles and system settings for a single user across multiple hosts.

Built around the [Dendritic Pattern](#the-dendritic-pattern).

---

## The Dendritic Pattern

This repository follows the **Dendritic Pattern**: every `.nix` file (except the entry points
`flake.nix` and host `default.nix` files) is a
[flake-parts](https://flake.parts) module. Modules are organised by **feature**, not by host or
configuration class. A single feature file covers NixOS system config, nix-darwin system config and
Home Manager config all in one place.

```nix
# modules/features/terminal.nix — one file owns everything "terminal" touches
{
  flake.modules.nixos.terminal     = { ... };   # system-level (NixOS)
  flake.modules.darwin.terminal    = { ... };   # system-level (macOS)
  flake.modules.homeManager.terminal = { ... }; # user-level (both platforms)
}
```

[`import-tree`](https://github.com/vic/import-tree) auto-imports every `.nix` file under
`modules/`, so dropping a new file in is enough — no manual registration in `flake.nix` needed.

**Why this pattern?**

- **Locality** - all config for a feature lives in one file.
- **No `specialArgs` pass-thru** - values are shared through the top-level `config` attrset
  instead of being threaded through `specialArgs`/`extraSpecialArgs`.
- **Free file paths** - files can be renamed, moved, or split without breaking anything. The path
  is just a name.
- **Automatic importing** - any `.nix` file added under `modules/` is picked up immediately.

**Sources & further reading**

- [`mightyiam/dendritic`](https://github.com/mightyiam/dendritic) — canonical pattern documentation
- [NixOS Discourse - The dendritic pattern](https://discourse.nixos.org/t/the-dendritic-pattern/61271) — original discussion thread
- [YouTube — Elevate Your Nix Config With Dendritic Pattern](https://www.youtube.com/watch?v=-TRbzkw6Hjs) — video walkthrough

---

## Folder Architecture

```
NixConfig/
├── flake.nix                        # Entry point — delegates to flake-parts via import-tree
├── flake.lock                       # Pinned input revisions
│
├── modules/                         # All Nix configuration logic (auto-imported by import-tree)
│   ├── flake-modules.nix            # Registers flake-parts + home-manager flake modules
│   ├── helpers.nix                  # Global options: username, supported systems, path helpers
│   ├── features/                    # Feature modules — one file per capability
│   ├── hosts/
│   │   ├── nixbook/                 # Primary Linux host (fully configured)
│   │   │   ├── default.nix          # Assembles nixosConfiguration from feature modules
│   │   │   ├── configuration.nix    # Boot, networking, display manager, users, locale
│   │   │   └── hardware-configuration.nix  # LUKS, GPU (AMD+Nvidia PRIME), Bluetooth
│   │   ├── macbook/
│   │   │   ├── default.nix          # Personal macOS host (nix-darwin + Homebrew)
│   │   │   └── configuration.nix    # macOS system settings, apps, Homebrew config
│   │   └── macbook-cookunity/
│   │       ├── default.nix          # Work macOS host (nix-darwin + Homebrew)
│   │       └── configuration.nix    # macOS system settings, apps, Homebrew config
│   └── users/
│       └── christopher.nix          # Minimal Home Manager base: username + stateVersion
└── assets/                          # Static files symlinked into $HOME at activation time
```

### Key design decisions

| Decision | Rationale |
|---|---|
| `config.flake.username` | Username is declared once in `helpers.nix`, never hardcoded elsewhere |
| `helpers.mkAssetsPath` | Returns a Nix store path to `assets/<path>` — used at eval time |
| `helpers.mkAssetsStringPath` | Returns a string `~/NixConfig/assets/<path>` — used for live symlinks that must not enter the store |
| `helpers.mkConfigPath` / `mkHomePath` | All `~/.config/` and `~/` paths go through helpers; no raw string paths scattered around |
| `helpers.mkHybrid` | Wraps a Home Manager module to conditionally apply config per platform (Linux vs. macOS) |
| `mkOutOfStoreSymlink` for `assets/nvim/` | Neovim config edits take effect immediately without a rebuild |
| Proton Pass secret pipeline | `env.template` + `secure-env-refresh.sh` + systemd service — secrets never touch the Nix store |

---

## Hosts

| Host | Platform | Status | Description |
|---|---|---|---|
| `nixbook` | `x86_64-linux` | Active | Main desktop — AMD+Nvidia PRIME, LUKS, Niri, SDDM |
| `macbook` | `aarch64-darwin` | Active | Personal MacBook — nix-darwin + Homebrew |
| `macbook-cookunity` | `aarch64-darwin` | Active | Work MacBook — nix-darwin + Homebrew |

---

## Getting Started

### Validate (no build)

```bash
nix flake check
```

### Build without applying

```bash
nix build .#nixosConfigurations.nixbook.config.system.build.toplevel
```

### Dry-run (build without activating)

```bash
sudo nixos-rebuild dry-activate --flake .#nixbook
```

### Apply — Linux

```bash
sudo nixos-rebuild switch --flake .#nixbook
```

### Apply — macOS

```bash
darwin-rebuild switch --flake .#macbook
# or using the shell alias:
switch
```

### Update all inputs

```bash
nix flake update
```

### Update a single input

```bash
nix flake update nixpkgs
```

### Format all Nix files

```bash
nixfmt **/*.nix
```

---

## Tools configuration

### Howdy

For adding a face for howdy, run:
```bash
sudo howdy add
```
