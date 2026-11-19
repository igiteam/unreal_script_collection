class R6SniperM40A1 extends R6Sniper
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.Sniper.Sniper_M40A1_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsSniperM40A1'
    m_damageType=Class'R6DmgTypeSniperM40A1'
    m_ConfigClass=Class'ConfigR6SniperM40A1'
    m_AnimConfigClass=Class'R6WeaponAnimConfigSniperM40A1'
    ItemName="M40A1"
}