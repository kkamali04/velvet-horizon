# Velvet Horizon — Packwiz Delta Pack

## What this is

This directory contains the Packwiz manifest for the **Velvet Horizon custom mod delta** — the 22 mods added on top of the base ATM10 (All the Mods 10) install.

### What is NOT tracked here

The ~449 base ATM10 mods (ATM10 ServerFiles 6.6) are **not** in this repo. They come from the player's ATLauncher or launcher install of ATM10. This pack only tracks the custom additions.

### Mods tracked (22 custom + 4 auto-resolved dependencies)

| Mod | Source |
|-----|--------|
| Automobility | Modrinth |
| Chat Heads | Modrinth |
| Cobblemon | Modrinth |
| Create: Copycats+ | Modrinth |
| Create Aeronautics | Modrinth |
| Create: New Age | Modrinth |
| Create: Power Loader | Modrinth |
| Create: Design n' Decor | Modrinth |
| Distant Horizons | Modrinth |
| Emotecraft | Modrinth |
| Enigmatic Legacy+ | Modrinth |
| Immersive Vehicles | Modrinth |
| Lightman's Currency | Modrinth |
| Mowzie's Mobs | Modrinth |
| Origins (NeoForge) | Modrinth |
| Steam 'n' Rails (NeoForge) | Modrinth |
| Create Slice & Dice | Modrinth |
| TACZ 1.21.1 NeoForge Port | Modrinth |
| Corail Tombstone | CurseForge |
| Simple Voice Chat | Modrinth |
| Xaero's Minimap | Modrinth |
| Xaero's World Map | Modrinth |
| *(Create — auto-dep of Copycats+)* | Modrinth |
| *(Kotlin for Forge — auto-dep of Cobblemon)* | Modrinth |
| *(Sable — auto-dep of Create Aeronautics)* | Modrinth |
| *(Jupiter — auto-dep of Origins)* | Modrinth |

### Excluded (removed from rotation, do NOT re-add)

- `create-1.21.1-6.0.9.jar` — version conflict (replaced by auto-resolved 6.0.10)
- `creaturechat-3.0.0+1.21.1-neoforge.jar` — broken, removed
- `embeddium-1.0.15+mc1.21.1.jar` — broken, removed

---

## How to add a mod

```bash
cd packwiz/

# From Modrinth (preferred):
packwiz modrinth add <slug-or-search-term> -y

# From CurseForge:
packwiz curseforge add <slug> -y

# From a direct download URL (GitHub releases, etc.):
packwiz url add "Mod Name" "https://example.com/mod.jar"

# Then commit and push:
git add packwiz/
git commit -m "feat(mods): add <mod-name>"
git push
```

Players with the Packwiz installer configured will receive the new mod automatically on next launcher start.

---

## How to remove a mod

```bash
cd packwiz/
packwiz remove <slug>   # slug = the .pw.toml filename without the extension
git add packwiz/
git commit -m "chore(mods): remove <mod-name>"
git push
```

---

## How to update all mods

```bash
cd packwiz/
packwiz update --all -y
git add packwiz/
git commit -m "chore(mods): update all to latest"
git push
```

---

## Export as Modrinth .mrpack

```bash
cd packwiz/
packwiz modrinth export
# Produces velvet-horizon-1.0.0.mrpack in the current directory
```

---

## Pack URL (for launcher / Packwiz installer)

Once GitHub Pages is enabled (Settings → Pages → Source: GitHub Actions), the
pack URL will be:

```
https://kkamali04.github.io/velvet-horizon/pack.toml
```

The `.mrpack` stable download URL (for Modrinth/Prism import):
```
https://github.com/kkamali04/velvet-horizon/releases/download/latest/velvet-horizon.mrpack
```

Players configure the `pack.toml` URL in Prism Launcher / ATLauncher using the
[packwiz-installer](https://github.com/packwiz/packwiz-installer) bootstrap jar.

**TODO:** Enable GitHub Pages in repo Settings → Pages → Source: GitHub Actions.
The CI/CD pipeline at `.github/workflows/publish-pack.yml` will auto-deploy on
every push that touches `packwiz/**`.

**NOTE:** The workflow is configured to trigger on the `main` branch. The repo
currently uses `master`. Either rename the branch or update the workflow trigger
before the first push.

---

## Pack details

- Minecraft: 1.21.1
- Loader: NeoForge 21.1.228
- Pack format: packwiz:1.1.0
- Author: Kian Kamali
