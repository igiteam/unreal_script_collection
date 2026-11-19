class R6FixedLMGM249 extends R6FixedLMG
    native
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.LMG.LMG_FixedM249_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsFixedLMGM249'
    m_damageType=Class'R6DmgTypeFixedLMGM249'
    m_ConfigClass=Class'ConfigR6FixedLMGM249'
    m_AnimConfigClass=Class'R6WeaponAnimConfigFixedLMGM249'
}