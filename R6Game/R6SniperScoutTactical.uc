class R6SniperScoutTactical extends R6Sniper
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.Sniper.Sniper_Scout_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsSniperScoutTactical'
    m_damageType=Class'R6DmgTypeSniperScoutTactical'
    m_ConfigClass=Class'ConfigR6SniperScoutTactical'
    m_AnimConfigClass=Class'R6WeaponAnimConfigSniperScoutTactical'
    ItemName="SCOUT TACTICAL"
}