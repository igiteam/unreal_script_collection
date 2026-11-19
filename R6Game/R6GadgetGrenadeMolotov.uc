class R6GadgetGrenadeMolotov extends R6GadgetGrenade
    config(GadgetsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_iMaxAmmoNormal=6
    m_iMaxAmmoVeteran=3
    m_iMaxAmmoElite=2
    m_iMaxAmmoMP=3
    m_bCanUseInTakeCover=true
    m_bSelectable=true
    m_strGadgetIcon="ic_gadget_Molotov_Cocktail"
    ItemName="MOLOTOV"
}