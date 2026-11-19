class R6LMG21E extends R6LightMachineGun
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_bSupportStrap=true
    m_weaponSetup=R6WeaponSetup'WeaponSetups.LMG.LMG_21E_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsLMG21E'
    m_damageType=Class'R6DmgTypeLMG21E'
    m_ConfigClass=Class'ConfigR6LMG21E'
    m_AnimConfigClass=Class'R6WeaponAnimConfigLMG21E'
    ItemName="21E"
}