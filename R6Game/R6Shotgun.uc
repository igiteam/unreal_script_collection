class R6Shotgun extends R6Weapon
    abstract
    native
    config(WeaponsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_eWeaponAnimType=4
    m_damageType=Class'R6DmgTypeShotgun'
    m_iNbFiredBulletsAtOnce=9
    m_AnimConfigClass=Class'R6WeaponAnimConfigShotgun'
    ItemName="SHOTGUN"
}