class R6PistolUSP40 extends R6Pistol
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.Pistol.Pistol_USP40_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsPistolUSP40'
    m_damageType=Class'R6DmgTypePistolUSP40'
    m_ConfigClass=Class'ConfigR6PistolUSP40'
    m_AnimConfigClass=Class'R6WeaponAnimConfigPistolUSP40'
    ItemName="USP40"
}