class R6ShotgunM3 extends R6Shotgun
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.Shotgun.Shotgun_M3_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsShotgunM3'
    m_damageType=Class'R6DmgTypeShotgunM3'
    m_ConfigClass=Class'ConfigR6ShotgunM3'
    m_AnimConfigClass=Class'R6WeaponAnimConfigShotgunM3'
    ItemName="M3"
}