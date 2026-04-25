# Velvet Horizon

**KAIDO / Cognesia Modded Minecraft Server**

---

| MC 1.21.1 | NeoForge | ATM10 | 500+ Mods | 100 Players |
|-----------|----------|-------|-----------|-------------|

---

## Quick Start

Run one command to download all custom mods automatically.

**Windows**
```bat
python setup.py
```

**Mac / Linux**
```bash
python3 setup.py
```

**One-liner (any platform)**
```bash
curl -sL https://raw.githubusercontent.com/kiankamali/velvet-horizon/main/setup.py | python3
```

**Custom mods directory**
```bash
python3 setup.py --mods-dir /path/to/your/mods
```

The script will:
1. Verify Java 21+ is installed
2. Guide you through ATLauncher setup if needed
3. Download all custom mods straight from Modrinth
4. Print step-by-step instructions to finish in ATLauncher

---

## Features

- **Voice Chat** — proximity voice chat with Simple Voice Chat
- **Emotes** — full Emotecraft expression library
- **Player Heads** — see faces next to chat messages with Chat Heads
- **Minimap + World Map** — Xaero's Minimap and World Map
- **Economy** — Lightman's Currency shop system
- **Vehicles** — Automobility cars and Immersive Vehicles
- **Pokemon** — full Cobblemon integration
- **Mobs** — Mowzie's Mobs bosses and creatures
- **Create Suite** — Create Aeronautics, Steam 'n' Rails, New Age, Power Loader, Design 'n' Decor
- **Building** — Copycats+ and Slice & Dice
- **Origins** — play as a unique race/class with Origins (NeoForge)
- **Performance** — Distant Horizons LOD rendering for massive view distances
- **AI NPCs** — CreatureChat for living, conversational NPCs

---

## Server Info

| Field | Value |
|-------|-------|
| Server IP | Coming Soon |
| Discord | [discord.gg/sM8yXGRQ](https://discord.gg/sM8yXGRQ) |
| Version | Minecraft 1.21.1 |
| Modloader | NeoForge (via ATM10) |

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
   - Click **New Instance** → pick the latest 1.21.1 version → Install

4. **Download custom mods manually**
   - Visit https://modrinth.com and search each mod slug listed in `setup.py`
   - Drop the `.jar` files into:
     - Windows: `%APPDATA%\ATLauncher\instances\VelvetHorizon\mods\`
     - Mac: `~/Library/Application Support/ATLauncher/instances/VelvetHorizon/mods/`
     - Linux: `~/.atlauncher/instances/VelvetHorizon/mods/`

5. **Launch and connect**
   - Open ATLauncher → Instances → Play
   - Multiplayer → Add Server → paste the server IP

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
| Immersive Vehicles | Modrinth |
| Cobblemon | Modrinth |
| Mowzie's Mobs | Modrinth |
| Create: Aeronautics | Modrinth |
| Copycats+ | Modrinth |
| Create: New Age | Modrinth |
| Slice & Dice | Modrinth |
| Create: Power Loader | Modrinth |
| Enigmatic Legacy+ | Modrinth |
| Distant Horizons | Modrinth |
| CreatureChat | Modrinth |
| TACZ (1.21.1) | Modrinth |
| Create: Steam 'n' Rails (1.21.1) | Modrinth |
| Origins (NeoForge) | Modrinth |
| Create: Design 'n' Decor | Modrinth |

---

## Community

Join the Discord to get the live server IP, report issues, and connect with other players.

**Discord:** https://discord.gg/sM8yXGRQ

---

## Credits

Created by **Kian Kamali** for the KAIDO / Cognesia community, 2026.

---

## License

MIT License — see [LICENSE](LICENSE) for details.
