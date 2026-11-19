class R6Pistol92FS extends R6Pistol
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.Pistol.Pistol_92FS_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsPistol92FS'
    m_damageType=Class'R6DmgTypePistol92FS'
    m_ConfigClass=Class'ConfigR6Pistol92FS'
    m_AnimConfigClass=Class'R6WeaponAnimConfigPistol92FS'
    ItemName="92FS"
}