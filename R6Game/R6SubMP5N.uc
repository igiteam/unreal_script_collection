class R6SubMP5N extends R6SubMachineGun
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.SMG.SMG_MP5N_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsSubMP5N'
    m_damageType=Class'R6DmgTypeSubMP5N'
    m_ConfigClass=Class'ConfigR6SubMP5N'
    m_AnimConfigClass=Class'R6WeaponAnimConfigSubMP5N'
    ItemName="MP5N"
}