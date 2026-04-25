# Velvet Horizon

**KAIDO / Cognesia Modded Minecraft Server**

---

| MC 1.21.1 | NeoForge 21.1.224 | ATM10 v6.6 | 504 Client Mods | 100 Players |
|-----------|-------------------|------------|-----------------|-------------|

---

## Server Info

| Field | Value |
|-------|-------|
| Server IP | `178.104.226.110` |
| Domain | `play.cognesia.live` (DNS pending) |
| Discord | [discord.gg/sM8yXGRQ](https://discord.gg/sM8yXGRQ) |
| Version | Minecraft 1.21.1 |
| Modloader | NeoForge 21.1.224 |
| Modpack | All the Mods 10 v6.6 |
| Client Mods | 504 (478 ATM10 + 22 auto-downloaded + 4 manual) |
| Server Mods | 449 |

---

## Quick Start

Run one command to check Java, download all 22 custom mods, and set up your instance.

**Windows**
```bat
python setup.py
```

**Mac / Linux**
```bash
python3 setup.py
```

**Custom mods directory**
```bash
python3 setup.py --mods-dir /path/to/your/mods
```

The script will:
1. Verify Java 21+ is installed
2. Download all 22 custom mods directly from Modrinth
3. Create the correct instance folder structure
4. Print step-by-step instructions to finish setup in ATLauncher

---

## Features

- **Create** — Create mod with Steam 'n' Rails, Aeronautics, New Age, Power Loader, and Design 'n' Decor
- **Cobblemon** — full Pokemon integration
- **Guns** — TaCZ (Timeless and Classics Zero) firearms system
- **Vehicles** — Automobility cars and MTS (Minecraft Transport Simulator)
- **Dragons** — Ice and Fire dragons, serpents, and mythical creatures
- **Magic** — Iron's Spells 'n Spellbooks full magic system
- **Economy** — Lightman's Currency shop and trading system
- **Proximity Voice Chat** — Simple Voice Chat, talk to nearby players
- **AI NPCs** — CreatureChat for living, conversational NPCs powered by AI
- **Casino** — built-in gambling and games of chance
- **Bounty System** — player bounties and rewards
- **Distant Horizons** — LOD rendering for massive, beautiful view distances
- **Performance** — 100 player capacity on dedicated hardware

---

## Manual Setup

If you prefer not to use the script:

1. **Install Java 21+**
   - Adoptium Temurin 21 (recommended): https://adoptium.net/temurin/releases/?version=21

2. **Install ATLauncher**
   - Download from https://atlauncher.com/downloads

3. **Create an ATM10 instance**
   - Open ATLauncher → Packs tab
   - Search **All the Mods 10**
   - Click **New Instance** → select version **6.6** → Install
   - Name it **Velvet Horizon**

4. **Download custom mods manually**
   - Visit https://modrinth.com and search each mod slug listed in `setup.py`
   - Drop the `.jar` files into your instance mods folder:
     - Windows: `%APPDATA%\ATLauncher\instances\VelvetHorizon\mods\`
     - Mac: `~/Library/Application Support/ATLauncher/instances/VelvetHorizon/mods/`
     - Linux: `~/.atlauncher/instances/VelvetHorizon/mods/`

5. **Launch and connect**
   - Open ATLauncher → Instances → Play
   - Multiplayer → Add Server → enter `178.104.226.110`

---

## Custom Mod List

| Mod | Source |
|-----|--------|
| Simple Voice Chat | Modrinth |
| Emotecraft | Modrinth |
| Chat Heads | Modrinth |
| Xaero's Minimap | Modrinth |
| Xaero's World Map | Modrinth |
| Lightman's Currency | Modrinth |
| Automobility | Modrinth |
| Immersive Vehicles (MTS) | Modrinth |
| Cobblemon | Modrinth |
| Ice and Fire | Modrinth |
| Iron's Spells 'n Spellbooks | Modrinth |
| TaCZ (Timeless and Classics Zero) | Modrinth |
| Create: Aeronautics | Modrinth |
| Create: Steam 'n' Rails | Modrinth |
| Create: New Age | Modrinth |
| Create: Power Loader | Modrinth |
| Create: Design 'n' Decor | Modrinth |
| Copycats+ | Modrinth |
| Distant Horizons | Modrinth |
| CreatureChat | Modrinth |
| Origins (NeoForge) | Modrinth |
| Slice & Dice | Modrinth |

---

## Server Specs

| Field | Value |
|-------|-------|
| Provider | Hetzner |
| Server | cax31 (ARM64) |
| RAM | 16 GB |
| OS | Ubuntu 24.04 |
| Java | OpenJDK 21 |
| JVM Heap | 8–12 GB |
| Port | 25565 |
| Path | `/opt/minecraft/velvet-horizon/` |

---

## Community

Join the Discord to get announcements, report issues, and connect with other players.

**Discord:** https://discord.gg/sM8yXGRQ

---

## Credits

Created by **Kian Kamali** for the KAIDO / Cognesia community, 2026.

---

## License

MIT License — see [LICENSE](LICENSE) for details.
