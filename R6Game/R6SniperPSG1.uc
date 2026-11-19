class R6SniperPSG1 extends R6Sniper
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.Sniper.Sniper_PSG1_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsSniperPSG1'
    m_damageType=Class'R6DmgTypeSniperPSG1'
    m_ConfigClass=Class'ConfigR6SniperPSG1'
    m_AnimConfigClass=Class'R6WeaponAnimConfigSniperPSG1'
    ItemName="PSG1"
}