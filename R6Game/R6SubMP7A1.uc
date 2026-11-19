class R6SubMP7A1 extends R6SubMachineGun
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.SMG.SMG_MP7A1_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsSubMP7A1'
    m_damageType=Class'R6DmgTypeSubMP7A1'
    m_ConfigClass=Class'ConfigR6SubMP7A1'
    m_AnimConfigClass=Class'R6WeaponAnimConfigSubMP7A1'
    ItemName="MP7A1"
}