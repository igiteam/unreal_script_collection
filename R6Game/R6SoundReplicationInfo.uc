class R6SoundReplicationInfo extends R6SoundReplicationInfoAbstract
    native
    hidecategories(lighting);

var R6Pawn m_pawnOwner;
var Vector m_Location;
var R6PawnReplicationInfo m_PawnRepInfo;
var class<Inventory> m_pPrimaryWeaponClass;
var class<Inventory> m_pPistolWeaponClass;
var class<Inventory> m_pPrimaryGadgetClass;
var class<Inventory> m_pSecondaryGadgetClass;
var float m_fClientUpdateFrequency;
var float m_fClientLastUpdate;
var bool m_bIsSuppressed;
var transient R6EngineEnums.EWeaponSound m_LastPlayedWeaponSound;
var transient bool m_bLastSoundFullAuto;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_Location, m_PawnRepInfo, 
        m_bIsSuppressed, m_pawnOwner;

    // Pos:0x00D
    if((int(Role) == int(ROLE_Authority)) && !bNetOwner)
        m_pPistolWeaponClass, m_pPrimaryGadgetClass, 
        m_pPrimaryWeaponClass, m_pSecondaryGadgetClass;
}

// Export UR6SoundReplicationInfo::execPlayWeaponSound(FFrame&, void* const)
native final function PlayWeaponSound(R6EngineEnums.EWeaponSound EWeaponSound);

// Export UR6SoundReplicationInfo::execStopWeaponSound(FFrame&, void* const)
native final function StopWeaponSound();

// Export UR6SoundReplicationInfo::execForceStopWeaponSound(FFrame&, void* const)
native final function ForceStopWeaponSound();

defaultproperties
{
    m_fClientUpdateFrequency=1.0000000
    NetUpdateFrequency=10.0000000
}