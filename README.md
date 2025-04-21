# SA-MP-Gazelle-Hunting-Job

# Gazelle Hunting Job for SA-MP

This is a **Gazelle Hunting Job** plugin for your SA-MP game mode. It allows players with the Hunter job to hunt gazelles, butcher them, collect meat, and sell it for profit.

## 📋 Features

- Spawns 24 gazelle objects at predefined locations on map.
- Allows players to start the Hunter job and receive a vehicle & weapon.
- Enables hunting behavior: shoot gazelles, butcher with `Y`, then ` /grab` meat.
- Limits carry to 5 gazelles per trip; sell at the trapper NPC for randomized pay.
- Auto-respawns gazelles after a set timer or upon quitting the job.
- Handles player disconnects: auto-pays for collected meat.
- Configurable job commands: `/findjob HUNTER`, `/grab`, `/quitjob`.
- Fully commented functions for easy editing, replacement, or extension.

## 🚀 Installation

1. Copy the plugin code into your server gamemode script (`.pwn` file).
2. Define the following at the top of your script:
   ```pawn
   #define GAZELLE_MODEL_ID 19315
   // Arrays and enums for gazelle job...
   ```
3. In your `OnGameModeInit`, add the initialization block under the comment `// look for stock`:
   ```pawn
   onGameModeInit()
   {
       // Gazelle job init...
   }
   ```
4. Hook into `OnPlayerConnect`, `OnPlayerDisconnect`, `OnPlayerPickUpDynamicPickup`, `OnPlayerWeaponShot`, `OnPlayerUpdate`, `OnPlayerKeyStateChange`, and add the provided forward declarations.
5. Add the new job type in your `enum JobType` list:
   ```pawn
   enum { JOB_NONE = -1, /* ... */ JOB_HUNTER };
   ```
6. Extend your `/jobhelp` and GPS locator to include the Hunter job.

## ⚙️ Configuration

- **Gazelle Positions**: Edit `gazellesloc[][]` array to change spawn points.
- **Timers**: Adjust respawn timers in `SetTimerEx("spawn_gazelle", 180000, ...)` and `spawn_gazelles` calls.
- **Pay Scale**: Modify `Random(10000,12000) + 2005` to adjust hunter earnings.
- **Vehicle & Weapon**: Change model IDs in `CreateActor` and `GiveWeapon` calls.

## 🎮 Usage

1. Player types `/findjob HUNTER` to mark the Hunter checkpoint.
2. Go to the dynamic pickup to start hunting; receive vehicle & rifle.
3. Drive to gazelle locations, shoot gazelles to knock them down.
4. Press `Y` near downed gazelle to start butchering animation.
5. After butchering, type `/grab` to collect meat (up to 5 gazelles).
6. Return to trapper NPC to sell meat and get paid.
7. Type `/quitjob` to leave job; automatically paid for any remaining meat.

## ✏️ Customization

All functions in the code are commented with instructions:

- **GetClosestGazelle / GetClosestMeat**: Customize detection logic.
- **spawn_gazelle / spawn_gazelles**: Change respawn behavior.
- **OnPlayerWeaponShot**: Adjust how gazelles react to weapon hits.
- **OnPlayerKeyStateChange**: Change interaction keys or animations.
- **CMD:grab / CMD:quitjob**: Modify commands, parameters, or messaging.

Simply locate the comment blocks above each function and follow the `// replace`, `// edit`, or `// add` notes to integrate into your existing gamemode.

## 📄 License

This plugin is open-source and free to use. Attribution is appreciated but not required.

---
*For detailed code comments and further editing instructions, refer directly to the source code under each function declaration.*

