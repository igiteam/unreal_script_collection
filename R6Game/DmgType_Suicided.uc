class DmgType_Suicided extends KillZDamageType
    abstract
    native
    config(DamageTypesConfig);

defaultproperties
{
    DeathString="%o had an aneurysm."
    FemaleSuicide="%o had an aneurysm."
    MaleSuicide="%o had an aneurysm."
    bArmorStops=false
    bLocationalHit=false
    m_bDropWeaponOnKill=false
}