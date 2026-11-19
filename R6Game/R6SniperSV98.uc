class R6SniperSV98 extends R6Sniper
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.Sniper.Sniper_SV98_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsSniperSV98'
    m_damageType=Class'R6DmgTypeSniperSV98'
    m_ConfigClass=Class'ConfigR6SniperSV98'
    m_AnimConfigClass=Class'R6WeaponAnimConfigSniperSV98'
    ItemName="SV-98"
}