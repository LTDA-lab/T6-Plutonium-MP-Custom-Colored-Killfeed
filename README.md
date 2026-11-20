# T6 Plutonium MP - Custom Colored Killfeed (GSC)

A lightweight, zero-delay GSC script for **Call of Duty: Black Ops II (Plutonium T6 Multiplayer)** that displays private, color-coded kill and death notifications to each player involved in a gunfight.

Instead of relying on external RCON plugins, this script hooks directly into the server's `callbackPlayerKilled` event for instant on-screen feedback with zero network overhead.

---

## Features

* **Per-Player Color Highlighting:** Only the attacker and the victim see the colored feed message—no global chat spam.
  * **Attacker View:** `^2YourName ^7[WEAPON] ^1VictimName ^3[Headshot]`
  * **Victim View:** `^1AttackerName ^7[WEAPON] ^5YourName ^3[Headshot]`
* **Zero Delay:** Executes before the native death callback, displaying immediately on kill/death without waiting for killcam animations.
* **Automatic Weapon & Scorestreak Resolution:** Dynamically reads weapon and killstreak display names straight from the game's internal `mp/statstable.csv` (stripping attachments and internal prefixes).
* **Scorestreak Owner Detection:** Properly credits the player who called in a scorestreak (`eInflictor.owner`).
* **Headshot Indicator:** Automatically appends a yellow `[Headshot]` tag when `sHitLoc` registers a `head` or `helmet` hit.

---

## Installation

1. Download `custom_killfeed.gsc` from this repository.
2. Place the file inside your Plutonium T6 server's multiplayer scripts directory:
   ```text
   <server_folder>/storage/t6/scripts/mp/custom_killfeed.gsc
   ```
3. Restart your server or perform a `map_restart` so Plutonium compiles and loads the script.

---

## Color Customization

You can easily customize the colors by editing the `^` color codes in `custom_killfeed.gsc`:

| Code | Color |
| :--- | :--- |
| `^1` | Red |
| `^2` | Green |
| `^3` | Yellow |
| `^4` | Dark Blue |
| `^5` | Cyan |
| `^6` | Magenta |
| `^7` | White |

### Relevant Lines in `custom_killfeed.gsc`
```c
// Attacker message
realAttacker iPrintLn("^2" + realAttacker.name + " ^7[" + weaponName + "^7] ^1" + self.name + headshotTag);

// Victim message
self iPrintLn("^1" + realAttacker.name + " ^7[" + weaponName + "^7] ^5" + self.name + headshotTag);
```

---

## Compatibility

* **Game:** Call of Duty: Black Ops II (T6 Multiplayer)
* **Client/Server:** Plutonium T6
* **RCON / IW4MAdmin:** Fully compatible. Does not interfere with RCON tools or admin managers.

---

## License

Free to use, modify, and distribute for your Plutonium T6 servers.
