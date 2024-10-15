
<h1 style="text-align: center;">
  <img src="https://github.com/fivemdevx/ValoriaAC/blob/main/ValoriaAC/ui/assists/logo.png" alt="ValoriaAC logo" height="20" width="20"> 
  ValoriaAC 
  <img src="https://github.com/fivemdevx/ValoriaAC/blob/main/ValoriaAC/ui/assists/logo.png" alt="ValoriaAC logo" height="20" width="20">
</h1>
<h1 style="text-align: center;">

  <img src="https://d.top4top.io/p_3209n1zqf1.png" alt="ValoriaAC proof">
</h1>

<p style="text-align: center;">
  <strong>
    <a href="[https://www.youtube.com/@Fivemdev-b7b](https://www.youtube.com/watch?v=dbqOYR2wxt0)">Anticheat Preview Video</a>
  </strong>
</p>

---

### Overview

[ValoriaAC](https://github.com/fivemdevx/ValoriaAC) is a powerful anti-cheat system designed for FiveM servers. It offers comprehensive protection against various exploits and cheats, maintaining a secure gaming environment for all players. ValoriaAC actively monitors in-game activities and prevents hacking methods such as aimbot, wallhacks, and speed mods. With its lightweight design, it ensures minimal server impact while providing real-time detection, automated actions (e.g., kicks, bans), and alerts for admins.

**Key Features:**

- Real-time cheat detection and prevention.
- Customizable thresholds for actions (e.g., kick, ban).
- Detailed logging and alert system.
- Frequent updates to combat new exploits.
- Seamless integration with existing FiveM server frameworks.
- Easy-to-use admin panel for configuration and monitoring.

ValoriaAC helps server owners maintain a competitive and cheat-free environment, giving peace of mind against intruders.

---

### Requirements

<table style="text-align: center;">
  <tr>
    <td>
      <a href="https://github.com/jaimeadf/discord-screenshot/releases">discord-screenshot</a><br>For capturing in-game screenshots
    </td>
    <td>
      <a href="https://github.com/overextended/oxmysql/releases">oxmysql</a><br>For managing SQL data
    </td>
  </tr>
</table>

---

### Key Protections

#### Client-Side Protection

- [Anti-Teleport/No clip](https://github.com/fivemdevx/ValoriaAC/blob/main/Proof.gif)
- Anti-Track Players
- Anti-Health Hack
- Anti-Armor Hack
- Anti-Infinite Ammo
- Anti-Spectate
- Anti-Ragdoll
- Anti-Menyoo
- Anti-Aim Assist
- Anti-Infinite Stamina
- Anti-Aim Bot
- Anti-Blacklist Weapon
- Anti-God Mode
- Anti-Noclip
- Anti-Teleport Vehicle
- Anti-Teleport Ped
- Anti-Rainbow Vehicle
- Anti-Invisible
- Anti-Change Speed
- Anti-Plate Changer
- Anti-Night Vision
- Anti-Thermal Vision
- Anti-Super Jump
- Anti-Suicide

#### Server-Side Protection

- Anti-Spam Chat
- Anti-Blacklist Commands
- Anti-Weapon Damage Modifiers
- Anti-Vehicle Damage Modifiers
- Anti-Blacklist Word
- Anti-Bring All
- Anti-Blacklist Trigger
- Anti-Spam Trigger
- Anti-Explosion Spam
- Anti-Clear Ped Tasks
- Anti-Inject
- Anti-Blacklist Explosions
- Anti-Blacklist Objects
- Anti-Blacklist Peds
- Anti-Blacklist Vehicles
- Anti-Vehicle Spam
- Anti-Ped Spam
- Anti-Object Spam
- Anti-Change Permissions
- Anti-Play Sound

---

### Inject Protection

**Server-Side Protection**

- Block unauthorized resource start/stop/restart
- Prevent adding unauthorized commands

---

### Connection Protection

**Server-Side Protection**

- Anti-VPN connections
- Anti-Hosting from unauthorized locations
- Anti-Blacklist name enforcement

---

### Ban Methods

Ban users by the following identifiers:

- FiveM License
- Steam Identifier
- IP Address
- Microsoft ID (LIVE ID)
- Xbox Live ID (XBL ID)
- Discord ID
- FiveM Player Tokens

---

### Logging

Logging methods include:

- Console
- Discord integration
- Chat
- Screenshots

---

### Installation Instructions

Add the following to your `server.cfg` file:

```
ensure ValoriaAC
ensure screenshot-basic
ensure discord-screenshot
```

---

### Whitelisting

Manage your authorized users via the in-game admin menu.

---

### Server-Side Exports

- `ValoriaAC_CHANGE_TEMP_WHITELIST`: Add or remove players from the temporary whitelist.

```lua
-- Add to whitelist
exports['ValoriaAC']:ValoriaAC_CHANGE_TEMP_WHITELIST(source, true)

-- Remove from whitelist
exports['ValoriaAC']:ValoriaAC_CHANGE_TEMP_WHITELIST(source, false)
```

- `ValoriaAC_CHECK_TEMP_WHITELIST`: Check if a player is in the temporary whitelist.

```lua
-- Check whitelist status
exports['ValoriaAC']:ValoriaAC_CHECK_TEMP_WHITELIST(source)
```

- `ValoriaAC_ACTION`: Execute actions like BAN, KICK, or WARN against players.

```lua
-- Ban player
exports['ValoriaAC']:ValoriaAC_ACTION(source, "BAN", reason, details)

-- Kick player
exports['ValoriaAC']:ValoriaAC_ACTION(source, "KICK", reason, details)

-- Warn player
exports['ValoriaAC']:ValoriaAC_ACTION(source, "WARN", reason, details)
```

---

### Client-Side Exports

- `ValoriaAC_CHANGE_TEMP_WHITELIST`: Add or remove a player from the temporary whitelist on the client side.

```lua
-- Add to whitelist
exports['ValoriaAC']:ValoriaAC_CHANGE_TEMP_WHITELIST(true)

-- Remove from whitelist
exports['ValoriaAC']:ValoriaAC_CHANGE_TEMP_WHITELIST(false)
```

- `ValoriaAC_CHECK_TEMP_WHITELIST`: Verify the whitelist status of a player.

```lua
-- Check whitelist status
exports['ValoriaAC']:ValoriaAC_CHECK_TEMP_WHITELIST()
```

- `ValoriaAC_ACTION`: Ban, kick, or warn a player from the client side.

```lua
-- Ban player
exports['ValoriaAC']:ValoriaAC_ACTION("BAN", reason, details)

-- Kick player
exports['ValoriaAC']:ValoriaAC_ACTION("KICK", reason, details)

-- Warn player
exports['ValoriaAC']:ValoriaAC_ACTION("WARN", reason, details)
```

---

### Commands

| Command                                 | Description                                                                                         |
| --------------------------------------- | --------------------------------------------------------------------------------------------------- |
| `/unban [Ban ID]`                       | Unban a player via the database (admin only).                                                        |
| `/addadmin [ID (Player in server)]`     | Add an admin to the database, granting access to the admin menu.                                      |
| `/addwhitelist [ID (Player in server)]` | Add a player to the whitelist, giving them full server permissions.                                   |

---

### Tutorial

For a full installation guide, visit the FiveM Dev channel. **https://www.youtube.com/@Fivemdev-b7b**
