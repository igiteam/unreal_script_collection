class R6Shotgun870MCS extends R6Shotgun
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.Shotgun.Shotgun_870MCS_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsShotgun870MCS'
    m_damageType=Class'R6DmgTypeShotgun870MCS'
    m_ConfigClass=Class'ConfigR6Shotgun870MCS'
    m_AnimConfigClass=Class'R6WeaponAnimConfigShotgun870MCS'
    ItemName="870MCS"
}