

ValoriaAC              = {}


ValoriaAC.Version      = "1.0"


ValoriaAC.ServerConfig = {


    Name  = "Valoria",



    Port  = "30120",


  
    Linux = false
}

ValoriaAC.ACE = {
    Enable = false,
    Admin = "ValoriaAC.Admin", 
    Whitelist = "ValoriaAC.Whitelist",
    Unban = "ValoriaAC.Unban" 
}

-- Chat Settings
ValoriaAC.ChatSettings             = {
    Enable      = false, -- Enable chat features
    PrivateWarn = false  -- Warn players for private messages
}

-- Screenshot Settings
ValoriaAC.ScreenShot               = {
    Enable  = true,  -- Enable screenshot feature
    Format  = "PNG", -- Screenshot format
    Quality = 1      -- Screenshot quality
}

-- Connection Settings
ValoriaAC.Connection               = {
    AntiBlackListName = true, -- Anti-blacklist server name
    AntiVPN           = true, -- Anti-VPN
    HideIP            = true  -- Hide player's IP
}

-- Spawn Settings
ValoriaAC.Spawn                    = {
    LongSpawnMode = true -- Enable long spawn mode
}

-- Message Settings
ValoriaAC.Message                  = {
    Kick = "⚡️ You've been kicked from the server protection by FIREAC®. Avoid cheating on this server.",
    Ban  = "⛔️ You've been banned from the server. Please create a support ticket for assistance.",
}

-- Admin Menu Settings
ValoriaAC.AdminMenu                = {
    Enable         = true, -- Enable admin menu
    Key            = "F9", -- Admin menu activation key
    MenuPunishment = "BAN" -- Punishment for unauthorized access
}

-- Anti-Track Player Settings
ValoriaAC.AntiTrackPlayer          = false
ValoriaAC.MaxTrack                 = 10
ValoriaAC.TrackPunishment          = "WARN"

-- Anti-Health Hack Settings
ValoriaAC.AntiHealthHack           = true
ValoriaAC.MaxHealth                = 200
ValoriaAC.HealthPunishment         = "BAN"

-- Anti-Armor Hack Settings
ValoriaAC.AntiArmorHack            = true
ValoriaAC.MaxArmor                 = 100
ValoriaAC.ArmorPunishment          = "BAN"

-- Anti-Blacklist Tasks Settings
ValoriaAC.AntiBlacklistTasks       = true
ValoriaAC.TasksPunishment          = "BAN"

-- Anti-Blacklist Anims Settings
ValoriaAC.AntiBlacklistAnims       = true
ValoriaAC.AnimsPunishment          = "BAN"

-- Safe Players Settings
ValoriaAC.SafePlayers              = true
ValoriaAC.AntiInfinityAmmo         = true

-- Anti-Spectate Settings
ValoriaAC.AntiSpectate             = true
ValoriaAC.SpactatePunishment       = "BAN"

-- Anti-BlackList Weapon Settings
ValoriaAC.AntiBlackListWeapon      = true
ValoriaAC.AntiAddWeapon            = true
ValoriaAC.AntiRemoveWeapon         = true
ValoriaAC.AntiWeaponsExplosive     = true
ValoriaAC.WeaponPunishment         = "BAN"

-- Anti-God Mode Settings
ValoriaAC.AntiGodMode              = true
ValoriaAC.GodPunishment            = "BAN"

-- Anti-Invisible Settings
ValoriaAC.AntiInvisible            = true
ValoriaAC.InvisiblePunishment      = "KICK"

-- Anti-Change Speed Settings
ValoriaAC.AntiChangeSpeed          = true
ValoriaAC.SpeedPunishment          = "KICK"

-- Anti-Free Cam Settings
ValoriaAC.AntiFreeCam              = false
ValoriaAC.CamPunishment            = "BAN"

-- Anti-Rainbow Vehicle Settings
ValoriaAC.AntiRainbowVehicle       = true
ValoriaAC.RainbowPunishment        = "BAN"

-- Anti-Plate Changer Settings
ValoriaAC.AntiPlateChanger         = true
ValoriaAC.AntiBlackListPlate       = true
ValoriaAC.PlatePunishment          = "BAN"

-- Anti-Vision Settings
ValoriaAC.AntiNightVision          = true
ValoriaAC.AntiThermalVision        = true
ValoriaAC.VisionPunishment         = "BAN"

-- Anti-Super Jump Settings
ValoriaAC.AntiSuperJump            = true
ValoriaAC.JumpPunishment           = "BAN"

-- Anti-Teleport Settings
ValoriaAC.AntiTeleport             = true
ValoriaAC.MaxFootDistance          = 200
ValoriaAC.MaxVehicleDistance       = 600
ValoriaAC.TeleportPunishment       = "BAN"

-- Anti-Noclip Settings
ValoriaAC.AntiNoclip               = false
ValoriaAC.NoclipPunishment         = "KICK"

-- Anti-Ped Changer Settings
ValoriaAC.AntiPedChanger           = true
ValoriaAC.PedChangePunishment      = "BAN"

-- Anti-Infinite Stamina Settings
ValoriaAC.AntiInfiniteStamina      = false
ValoriaAC.InfinitePunishment       = "WARN"

-- Anti-Ragdoll Settings
ValoriaAC.AntiRagdoll              = false
ValoriaAC.RagdollPunishment        = "WARN"

-- Anti-Menyoo Settings
ValoriaAC.AntiMenyoo               = false
ValoriaAC.MenyooPunishment         = "WARN"

-- Anti-Aim Assist Settings
ValoriaAC.AntiAimAssist            = false
ValoriaAC.AimAssistPunishment      = "WARN"

-- Anti-Resource Stopper Settings
ValoriaAC.AntiResourceStopper      = true
ValoriaAC.AntiResourceStarter      = false
ValoriaAC.AntiResourceRestarter    = false
ValoriaAC.ResourcePunishment       = "WARN"

-- Anti-Tiny Ped Settings
ValoriaAC.AntiTinyPed              = true
ValoriaAC.PedFlagPunishment        = "BAN"

-- Anti-Suicide Settings
ValoriaAC.AntiSuicide              = false
ValoriaAC.SuicidePunishment        = "WARN"

-- Anti-Pickup Collect Settings
ValoriaAC.AntiPickupCollect        = true
ValoriaAC.PickupPunishment         = "BAN"

-- Anti-Spam Chat Settings
ValoriaAC.AntiSpamChat             = true
ValoriaAC.MaxMessage               = 10
ValoriaAC.CoolDownSec              = 3
ValoriaAC.ChatPunishment           = "BAN"

-- Anti-BlackList Commands Settings
ValoriaAC.AntiBlackListCommands    = true
ValoriaAC.CMDPunishment            = "BAN"

-- Anti-Change Damage Settings
ValoriaAC.AntiWeaponDamageChanger  = true
ValoriaAC.AntiVehicleDamageChanger = true
ValoriaAC.DamagePunishment         = "BAN"

-- Anti-BlackList Word Settings
ValoriaAC.AntiBlackListWord        = true
ValoriaAC.WordPunishment           = "KICK"

-- Anti-Bring All Settings
ValoriaAC.AntiBringAll             = true
ValoriaAC.BringAllPunishment       = "BAN"

-- Anti-Trigger Settings
ValoriaAC.AntiBlackListTrigger     = true
ValoriaAC.AntiSpamTrigger          = true
ValoriaAC.TriggerPunishment        = "BAN"

-- Anti-Clear Ped Tasks Settings
ValoriaAC.AntiClearPedTasks        = true
ValoriaAC.MaxClearPedTasks         = 5
ValoriaAC.CPTPunishment            = "BAN"

-- Anti-Taze Players Settings
ValoriaAC.AntiTazePlayers          = true
ValoriaAC.MaxTazeSpam              = 3
ValoriaAC.TazePunishment           = "KICK"

-- Anti-Inject Settings
ValoriaAC.AntiInject               = false
ValoriaAC.InjectPunishment         = "BAN"

-- Anti-Explosion Settings
ValoriaAC.AntiBlackListExplosion   = true
ValoriaAC.AntiExplosionSpam        = true
ValoriaAC.MaxExplosion             = 10
ValoriaAC.ExplosionSpamPunishment  = "BAN"

-- Anti-Entity Spawn Settings
ValoriaAC.AntiBlackListObject      = true
ValoriaAC.AntiBlackListPed         = true
ValoriaAC.AntiBlackListBuilding    = true
ValoriaAC.AntiBlackListVehicle     = true
ValoriaAC.EntityPunishment         = "BAN"

-- Anti-NPC Spawn Settings
ValoriaAC.AntiSpawnNPC             = false

-- Anti-Spam Entity Settings
ValoriaAC.AntiSpamVehicle          = true
ValoriaAC.MaxVehicle               = 10

ValoriaAC.AntiSpamPed              = true
ValoriaAC.MaxPed                   = 4

ValoriaAC.AntiSpamObject           = true
ValoriaAC.MaxObject                = 15

ValoriaAC.SpamPunishment           = "KICK"

-- Anti-Change Permission Settings
ValoriaAC.AntiChangePerm           = true
ValoriaAC.PermPunishment           = "BAN"

-- Anti-Play Sound Settings
ValoriaAC.AntiPlaySound            = true
ValoriaAC.SoundPunishment          = "KICK"