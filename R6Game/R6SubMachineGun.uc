class R6SubMachineGun extends R6Weapon
    abstract
    native
    config(WeaponsConfig)
    hidecategories(lighting);

var name m_leftIKHoldFlashlightSocketName;

defaultproperties
{
    m_leftIKHoldFlashlightSocketName="R65_IKM_LH_Hold"
    m_damageType=Class'R6DmgTypeSMG'
    m_AnimConfigClass=Class'R6WeaponAnimConfigSMG'
    ItemName="SUBMACHINE GUN"
}