class R6AssaultMTAR21 extends R6AssaultRifle
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.Assault.Assault_MTAR21_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsAssaultMTAR21'
    m_damageType=Class'R6DmgTypeAssaultMTAR21'
    m_ConfigClass=Class'ConfigR6AssaultMTAR21'
    m_AnimConfigClass=Class'R6WeaponAnimConfigAssaultMTAR21'
    ItemName="MTAR21"
}