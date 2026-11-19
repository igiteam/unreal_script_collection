class R6Assault552Commando extends R6AssaultRifle
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_weaponSetup=R6WeaponSetup'WeaponSetups.Assault.Assault_552Commando_Setup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsAssault552Commando'
    m_damageType=Class'R6DmgTypeAssault552Commando'
    m_ConfigClass=Class'ConfigR6Assault552Commando'
    m_AnimConfigClass=Class'R6WeaponAnimConfigAssault552Commando'
    ItemName="552 COMMANDO"
}