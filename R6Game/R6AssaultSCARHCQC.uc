class R6AssaultSCARHCQC extends R6AssaultRifle
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.Assault.Assault_SCAR_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsAssaultSCARHCQC'
    m_damageType=Class'R6DmgTypeAssaultSCARHCQC'
    m_ConfigClass=Class'ConfigR6AssaultSCARHCQC'
    m_AnimConfigClass=Class'R6WeaponAnimConfigAssaultSCARHCQC'
    ItemName="SCAR-H CQC"
}