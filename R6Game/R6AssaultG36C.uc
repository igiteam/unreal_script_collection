class R6AssaultG36C extends R6AssaultRifle
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.Assault.Assault_G36C_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsAssaultG36C'
    m_damageType=Class'R6DmgTypeAssaultG36C'
    m_ConfigClass=Class'ConfigR6AssaultG36C'
    m_AnimConfigClass=Class'R6WeaponAnimConfigAssaultG36C'
    ItemName="G36C"
}