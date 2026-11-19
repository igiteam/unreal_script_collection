class R6SubP90 extends R6SubMachineGun
    native
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.SMG.SMG_P90_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsSubP90'
    m_damageType=Class'R6DmgTypeSubP90'
    m_ConfigClass=Class'ConfigR6SubP90'
    m_AnimConfigClass=Class'R6WeaponAnimConfigSubP90'
    ItemName="P90"
}