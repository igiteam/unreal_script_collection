class R6AssaultM8 extends R6AssaultRifle
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.Assault.Assault_M8_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsAssaultM8'
    m_damageType=Class'R6DmgTypeAssaultM8'
    m_ConfigClass=Class'ConfigR6AssaultM8'
    m_AnimConfigClass=Class'R6WeaponAnimConfigAssaultM8'
    ItemName="M8"
}