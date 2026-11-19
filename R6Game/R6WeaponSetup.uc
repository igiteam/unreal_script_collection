class R6WeaponSetup extends R6Config
    native
    hidecategories(Object);

var() /*0x04000000-0x00000000*/ SoundCue m_TriggerSound;
var() /*0x04000000-0x00000000*/ SoundCue m_FireSoundSingle;
var() /*0x04000000-0x00000000*/ SoundCue m_FireSound2Roundburst;
var() /*0x04000000-0x00000000*/ SoundCue m_FireSound3Roundburst;
var() /*0x04000000-0x00000000*/ SoundCue m_FireSoundAutoshot;
var() /*0x04000000-0x00000000*/ SoundCue m_FireSoundStopAutoshot;
var() /*0x04000000-0x00000000*/ SoundCue m_FireSoundForceStopAutoshot;
var() /*0x04000000-0x00000000*/ SoundCue m_EchoSingleShots;
var() /*0x04000000-0x00000000*/ SoundCue m_Echo2RoundBursts;
var() /*0x04000000-0x00000000*/ SoundCue m_Echo3RoundBursts;
var() /*0x04000000-0x00000000*/ SoundCue m_EchoAutoShotLoops;
var() /*0x04000000-0x00000000*/ SoundCue m_EchoAutoShotEnds;
var() /*0x04000000-0x00000000*/ SoundCue m_EquipSound;
var() /*0x04000000-0x00000000*/ SoundCue m_EquipStopSound;
var() /*0x04000000-0x00000000*/ SoundCue m_EquipSuppressorSound;
var() /*0x04000000-0x00000000*/ SoundCue m_UnequipSound;
var() /*0x04000000-0x00000000*/ SoundCue m_UnequipStopSound;
var() /*0x04000000-0x00000000*/ SoundCue m_ReloadSound;
var() /*0x04000000-0x00000000*/ SoundCue m_ReloadSoundEmpty;
var() /*0x04000000-0x00000000*/ SoundCue m_ReloadSoundChamberStart;
var() /*0x04000000-0x00000000*/ SoundCue m_ReloadSoundChamberCycle;
var() /*0x04000000-0x00000000*/ SoundCue m_ReloadSoundChamberEndTactical;
var() /*0x04000000-0x00000000*/ SoundCue m_ReloadSoundChamberEndEmpty;
var() /*0x04000000-0x00000000*/ SoundCue m_ReloadSoundShieldTactical;
var() /*0x04000000-0x00000000*/ SoundCue m_ReloadSoundShieldEmpty;
var() /*0x04000000-0x00000000*/ SoundCue m_FireModeChangeSound;
var() /*0x04000000-0x00000000*/ SoundCue m_PistolChamberSound;
var() /*0x04000000-0x00000000*/ SoundCue m_ShellsSoundSingle;
var() /*0x04000000-0x00000000*/ SoundCue m_ShellsSound2Roundburst;
var() /*0x04000000-0x00000000*/ SoundCue m_ShellsSound3Roundburst;
var() /*0x04000000-0x00000000*/ SoundCue m_ShellsSoundAutoshot;
var() /*0x04000000-0x00000000*/ SoundCue m_ShellsSoundStopAutoshot;
var() /*0x04000000-0x00000000*/ SoundCue m_ScopeOnSound;
var() /*0x04000000-0x00000000*/ SoundCue m_ScopeOffSound;
var() /*0x04000000-0x00000000*/ SoundCue m_DropSound;
var() /*0x04000000-0x00000000*/ SoundCue m_DropContactSound;
var() /*0x04000000-0x00000000*/ SoundCue m_AmmoPickupSound;
var() /*0x04000000-0x00000000*/ SoundCue m_BoltSound;

defaultproperties
{
    m_TriggerSound=SoundCue'Dare.W_Assault_Common.Play_W_AssaultTrigger'
    m_FireSoundSingle=SoundCue'Dare.W_Assault_M8.W_XM8_Singles'
    m_FireSound2Roundburst=SoundCue'Dare.W_Assault_M8.W_XM8_2Bursts'
    m_FireSound3Roundburst=SoundCue'Dare.W_Assault_M8.W_XM8_3Bursts'
    m_FireSoundAutoshot=SoundCue'Dare.W_Assault_M8.W_XM8_Loops'
    m_FireSoundStopAutoshot=SoundCue'Dare.W_Assault_M8.W_XM8_Ends'
    m_EquipSound=SoundCue'Dare.W_Assault_Common.Play_W_Assault_Equip'
    m_EquipStopSound=SoundCue'Dare.W_Assault_Common.Stop_W_Assault_Equip_Go'
    m_EquipSuppressorSound=SoundCue'Dare.W_Sub_Common.Play_W_Sub_Suppressors'
    m_UnequipSound=SoundCue'Dare.W_Assault_Common.Play_W_Assault_Unequip'
    m_UnequipStopSound=SoundCue'Dare.W_Assault_Common.Stop_W_Assault_Unequip_Go'
    m_ReloadSound=SoundCue'Dare.W_Assault_M8.W_XM8_Reload'
    m_ReloadSoundEmpty=SoundCue'Dare.W_Assault_M8.W_XM8_Reload_Empty'
    m_FireModeChangeSound=SoundCue'Dare.W_Common.Play_W_ROF'
    m_PistolChamberSound=SoundCue'Dare.W_Pistol_MK23.Play_W_MK23_Chamber'
    m_ShellsSoundSingle=SoundCue'Dare.W_Sub_Common.Play_W_Sub_Shells_Single'
    m_ShellsSound2Roundburst=SoundCue'Dare.W_Sub_Common.Play_W_Sub_Shells_2Burst'
    m_ShellsSound3Roundburst=SoundCue'Dare.W_Sub_Common.Play_W_Sub_Shells_3Burst'
    m_ShellsSoundAutoshot=SoundCue'Dare.W_Sub_Common.Play_W_Sub_Shells_FullAuto'
    m_ShellsSoundStopAutoshot=SoundCue'Dare.W_Sub_Common.Stop_W_Sub_Shells_FullAuto'
    m_ScopeOnSound=SoundCue'Dare.W_Common.Play_W_Scope_On'
    m_ScopeOffSound=SoundCue'Dare.W_Common.Play_W_Scope_Out'
    m_AmmoPickupSound=SoundCue'Dare.Player.Play_O_AmmoPickup'
    m_BoltSound=SoundCue'Dare.W_Sniper_M40A1.Play_W_M40A1_Bolt'
    m_szThumbnailTexture="KellerEditorMaterials.Damage"
    m_szDescription="Weapon Setup"
}