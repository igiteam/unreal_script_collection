class R6ShotgunXM26LSS extends R6Shotgun
    native
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.Shotgun.Shotgun_XM26LSS_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsShotgunXM26LSS'
    m_damageType=Class'R6DmgTypeShotgunXM26LSS'
    m_ConfigClass=Class'ConfigR6ShotgunXM26LSS'
    m_AnimConfigClass=Class'R6WeaponAnimConfigShotgunXM26LSS'
    ItemName="XM-26 LSS"
}