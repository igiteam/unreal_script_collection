class R6AssaultG3KA4 extends R6AssaultRifle
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.Assault.Assault_G3KA4_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsAssaultG3KA4'
    m_damageType=Class'R6DmgTypeAssaultG3KA4'
    m_ConfigClass=Class'ConfigR6AssaultG3KA4'
    m_AnimConfigClass=Class'R6WeaponAnimConfigAssaultG3KA4'
    ItemName="G3KA4"
}