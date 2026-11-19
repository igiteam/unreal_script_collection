class R6PistolMK23 extends R6Pistol
    native
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.Pistol.Pistol_MK23_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsPistolMK23'
    m_damageType=Class'R6DmgTypePistolMK23'
    m_ConfigClass=Class'ConfigR6PistolMK23'
    m_AnimConfigClass=Class'R6WeaponAnimConfigPistolMK23'
    ItemName="MK.23"
}