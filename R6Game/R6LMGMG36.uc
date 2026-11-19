class R6LMGMG36 extends R6LightMachineGun
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.LMG.LMG_MG36_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsLMGMG36'
    m_damageType=Class'R6DmgTypeLMGMG36'
    m_ConfigClass=Class'ConfigR6LMGMG36'
    m_AnimConfigClass=Class'R6WeaponAnimConfigLMGMG36'
    ItemName="MG36"
}