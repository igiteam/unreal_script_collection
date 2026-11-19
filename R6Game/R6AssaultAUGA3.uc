class R6AssaultAUGA3 extends R6AssaultRifle
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.Assault.Assault_AUGA3_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsAssaultAUGA3'
    m_damageType=Class'R6DmgTypeAssaultAUGA3'
    m_ConfigClass=Class'ConfigR6AssaultAUGA3'
    m_AnimConfigClass=Class'R6WeaponAnimConfigAssaultAUGA3'
    ItemName="AUG A3"
}