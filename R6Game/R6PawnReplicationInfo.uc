class R6PawnReplicationInfo extends R6SoundReplicationInfoAbstract
    native
    hidecategories(lighting);

var Controller m_ControllerOwner;
var class<R6Weapon> m_WeaponClass;
var bool m_bDoNotPlayFullAutoSound;
var float m_fLocationUpdateLastTime;
var SoundCue m_TriggerSound;
var SoundCue m_FireSoundSingle;
var SoundCue m_FireSound2Roundburst;
var SoundCue m_FireSound3Roundburst;
var SoundCue m_FireSoundAutoshot;
var SoundCue m_FireSoundStopAutoshot;
var SoundCue m_FireSoundForceStopAutoshot;
var SoundCue m_EchoSingleShots;
var SoundCue m_Echo2RoundBursts;
var SoundCue m_Echo3RoundBursts;
var SoundCue m_EchoAutoShotLoops;
var SoundCue m_EchoAutoShotEnds;
var SoundCue m_ReloadSound;
var SoundCue m_ReloadSoundEmpty;
var SoundCue m_ReloadSoundChamberStart;
var SoundCue m_ReloadSoundChamberCycle;
var SoundCue m_ReloadSoundChamberEndTactical;
var SoundCue m_ReloadSoundChamberEndEmpty;
var SoundCue m_ReloadSoundShieldTactical;
var SoundCue m_ReloadSoundShieldEmpty;
var SoundCue m_PistolChamberSound;
var SoundCue m_ShellsSoundSingle;
var SoundCue m_ShellsSound2Roundburst;
var SoundCue m_ShellsSound3Roundburst;
var SoundCue m_ShellsSoundAutoshot;
var SoundCue m_ShellsSoundStopAutoshot;
var SoundCue m_EquipSuppressorSound;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_ControllerOwner, m_WeaponClass;
}

simulated event AssignSound(class<Weapon> WeaponClass)
{
    local class<R6Weapon> R6WeaponClass;

    R6WeaponClass = class<R6Weapon>(WeaponClass);
    LogInternal("AssignSound - R6WeaponClass:" @ string(R6WeaponClass),, 16);
    // End:0x361
    if(R6WeaponClass != none)
    {
        m_WeaponClass = R6WeaponClass;
        m_TriggerSound = R6WeaponClass.default.m_weaponSetup.m_TriggerSound;
        m_FireSoundSingle = R6WeaponClass.default.m_weaponSetup.m_FireSoundSingle;
        m_FireSound2Roundburst = R6WeaponClass.default.m_weaponSetup.m_FireSound2Roundburst;
        m_FireSound3Roundburst = R6WeaponClass.default.m_weaponSetup.m_FireSound3Roundburst;
        m_FireSoundAutoshot = R6WeaponClass.default.m_weaponSetup.m_FireSoundAutoshot;
        m_FireSoundStopAutoshot = R6WeaponClass.default.m_weaponSetup.m_FireSoundStopAutoshot;
        m_FireSoundForceStopAutoshot = R6WeaponClass.default.m_weaponSetup.m_FireSoundForceStopAutoshot;
        m_EchoSingleShots = R6WeaponClass.default.m_weaponSetup.m_EchoSingleShots;
        m_Echo2RoundBursts = R6WeaponClass.default.m_weaponSetup.m_Echo2RoundBursts;
        m_Echo3RoundBursts = R6WeaponClass.default.m_weaponSetup.m_Echo3RoundBursts;
        m_EchoAutoShotLoops = R6WeaponClass.default.m_weaponSetup.m_EchoAutoShotLoops;
        m_EchoAutoShotEnds = R6WeaponClass.default.m_weaponSetup.m_EchoAutoShotEnds;
        m_ReloadSound = R6WeaponClass.default.m_weaponSetup.m_ReloadSound;
        m_ReloadSoundEmpty = R6WeaponClass.default.m_weaponSetup.m_ReloadSoundEmpty;
        m_ReloadSoundChamberStart = R6WeaponClass.default.m_weaponSetup.m_ReloadSoundChamberStart;
        m_ReloadSoundChamberCycle = R6WeaponClass.default.m_weaponSetup.m_ReloadSoundChamberCycle;
        m_ReloadSoundChamberEndTactical = R6WeaponClass.default.m_weaponSetup.m_ReloadSoundChamberEndTactical;
        m_ReloadSoundChamberEndEmpty = R6WeaponClass.default.m_weaponSetup.m_ReloadSoundChamberEndEmpty;
        m_ReloadSoundShieldTactical = R6WeaponClass.default.m_weaponSetup.m_ReloadSoundShieldTactical;
        m_ReloadSoundShieldEmpty = R6WeaponClass.default.m_weaponSetup.m_ReloadSoundShieldEmpty;
        m_PistolChamberSound = R6WeaponClass.default.m_weaponSetup.m_PistolChamberSound;
        m_ShellsSoundSingle = R6WeaponClass.default.m_weaponSetup.m_ShellsSoundSingle;
        m_ShellsSound2Roundburst = R6WeaponClass.default.m_weaponSetup.m_ShellsSound2Roundburst;
        m_ShellsSound3Roundburst = R6WeaponClass.default.m_weaponSetup.m_ShellsSound3Roundburst;
        m_ShellsSoundAutoshot = R6WeaponClass.default.m_weaponSetup.m_ShellsSoundAutoshot;
        m_ShellsSoundStopAutoshot = R6WeaponClass.default.m_weaponSetup.m_ShellsSoundStopAutoshot;
        m_EquipSuppressorSound = R6WeaponClass.default.m_weaponSetup.m_EquipSuppressorSound;
    }
    return;
}
