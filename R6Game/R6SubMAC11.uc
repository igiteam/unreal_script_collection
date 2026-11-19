class R6SubMAC11 extends R6SubMachineGun
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_eWeaponAnimType=1
    m_bForceMGAnim=true
    m_weaponSetup=R6WeaponSetup'WeaponSetups.SMG.SMG_Mac11_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsSubMAC11'
    m_damageType=Class'R6DmgTypeSubMAC11'
    m_ConfigClass=Class'ConfigR6SubMAC11'
    m_AnimConfigClass=Class'R6WeaponAnimConfigSubMAC11'
    ItemName="MAC 11"
}