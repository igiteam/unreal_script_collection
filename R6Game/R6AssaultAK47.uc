class R6AssaultAK47 extends R6AssaultRifle
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.Assault.Assault_AK47_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsAssaultAK47'
    m_damageType=Class'R6DmgTypeAssaultAK47'
    m_ConfigClass=Class'ConfigR6AssaultAK47'
    m_AnimConfigClass=Class'R6WeaponAnimConfigAssaultAK47'
    ItemName="AK-47"
}