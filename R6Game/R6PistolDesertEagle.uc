class R6PistolDesertEagle extends R6Pistol
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.Pistol.Pistol_DesertEagle_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsPistolDesertEagle'
    m_damageType=Class'R6DmgTypePistolDesertEagle'
    m_ConfigClass=Class'ConfigR6PistolDesertEagle'
    m_AnimConfigClass=Class'R6WeaponAnimConfigPistolDesertEagle'
    ItemName="DESERT EAGLE"
}