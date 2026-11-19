class R6LMGM249SPW extends R6LightMachineGun
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.LMG.LMG_M249_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsLMGM249SPW'
    m_damageType=Class'R6DmgTypeLMGM249SPW'
    m_ConfigClass=Class'ConfigR6LMGM249SPW'
    m_AnimConfigClass=Class'R6WeaponAnimConfigLMGM249SPW'
    ItemName="M249 SPW"
}