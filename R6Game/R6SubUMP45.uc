class R6SubUMP45 extends R6SubMachineGun
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.SMG.SMG_UMP45_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsSubUMP45'
    m_damageType=Class'R6DmgTypeSubUMP45'
    m_ConfigClass=Class'ConfigR6SubUMP45'
    m_AnimConfigClass=Class'R6WeaponAnimConfigSubUMP45'
    ItemName="UMP45"
}