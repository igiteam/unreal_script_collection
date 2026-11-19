class R6SubMP9 extends R6SubMachineGun
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.SMG.SMG_MP9_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsSubMP9'
    m_damageType=Class'R6DmgTypeSubMP9'
    m_ConfigClass=Class'ConfigR6SubMP9'
    m_AnimConfigClass=Class'R6WeaponAnimConfigSubMP9'
    ItemName="MP9"
}