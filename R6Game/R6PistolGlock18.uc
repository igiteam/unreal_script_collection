class R6PistolGlock18 extends R6Pistol
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.Pistol.Pistol_Glock18_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsPistolGlock18'
    m_damageType=Class'R6DmgTypePistolGlock18'
    m_ConfigClass=Class'ConfigR6PistolGlock18'
    m_AnimConfigClass=Class'R6WeaponAnimConfigPistolGlock18'
    ItemName="GLOCK 18"
}