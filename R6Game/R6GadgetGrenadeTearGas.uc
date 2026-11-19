class R6GadgetGrenadeTearGas extends R6GadgetGrenade
    native
    config(GadgetsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_GrenadeProjectileClass=Class'R6ProjectileTearGasGrenade'
    m_iMaxAmmoNormal=6
    m_iMaxAmmoVeteran=3
    m_iMaxAmmoElite=2
    m_iMaxAmmoMP=3
    m_bCanUseInTakeCover=true
    m_bSelectable=true
    m_strGadgetIcon="ic_gadget_teargasgrenade"
    // Reference: StaticMeshComponent'Default__R6GadgetGrenadeTearGas.GadgetMeshTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6GadgetGrenade.GadgetMeshTP'
    begin object name="GadgetMeshTP"
        StaticMesh=StaticMesh'RS5Weapons.Gadgets.Tear_Gas'
    end object
    m_MeshTP=GadgetMeshTP
    ItemName="TEAR GAS"
    // Reference: StaticMeshComponent'Default__R6GadgetGrenadeTearGas.GadgetMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6GadgetGrenade.GadgetMesh'
    begin object name="GadgetMesh"
        StaticMesh=StaticMesh'RS5Weapons.Gadgets.Tear_Gas'
    end object
    m_Mesh=GadgetMesh
}