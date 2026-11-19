class R6ShotgunSpas12 extends R6Shotgun
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.Shotgun.Shotgun_Spas12_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsShotgunSpas12'
    m_damageType=Class'R6DmgTypeShotgunSpas12'
    m_ConfigClass=Class'ConfigR6ShotgunSpas12'
    m_AnimConfigClass=Class'R6WeaponAnimConfigShotgunSpas12'
    ItemName="SPAS 12"
}