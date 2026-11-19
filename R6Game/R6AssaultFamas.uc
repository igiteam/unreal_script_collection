class R6AssaultFamas extends R6AssaultRifle
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.Assault.Assault_Famas_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsAssaultFamas'
    m_damageType=Class'R6DmgTypeAssaultFamas'
    m_ConfigClass=Class'ConfigR6AssaultFamas'
    m_AnimConfigClass=Class'R6WeaponAnimConfigAssaultFamas'
    ItemName="FAMAS"
}