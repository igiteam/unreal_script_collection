class R6AssaultRifle extends R6Weapon
    abstract
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_damageType=Class'R6DmgTypeAssault'
    m_AnimConfigClass=Class'R6WeaponAnimConfigAssaultRifle'
    ItemName="ASSAULT RIFLE"
}