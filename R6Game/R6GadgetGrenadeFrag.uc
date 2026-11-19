class R6GadgetGrenadeFrag extends R6GadgetGrenade
    native
    config(GadgetsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_GrenadeProjectileClass=Class'R6ProjectileFragGrenade'
    m_iMaxAmmoNormal=6
    m_iMaxAmmoVeteran=3
    m_iMaxAmmoElite=2
    m_iMaxAmmoMP=2
    m_bCanUseInTakeCover=true
    m_bSelectable=true
    m_strGadgetIcon="ic_gadget_fraggren_M67"
    ItemName="FRAG GRENADE"
}