class R6GadgetGasMask extends R6Gadget
    native
    config(GadgetsConfig)
    hidecategories(lighting);

var const localized string m_sKitName;

simulated event bool CanUseGadget()
{
    return false;
    return;
}

event string GetKitRestrictionName()
{
    return m_sKitName;
    return;
}

defaultproperties
{
    m_sKitName="GAS MASK"
    m_bOnlyOneAllowed=true
    m_eGadgetType=6
    m_strGadgetIcon="ic_gadget_GasMask"
    // Reference: StaticMeshComponent'Default__R6GadgetGasMask.GadgetMeshTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6Gadget.GadgetMeshTP'
    begin object name="GadgetMeshTP"
        StaticMesh=StaticMesh'RS5MPCharacters_Gear_Boots.Male.RS5MPC_GAS_MASK'
        m_bDontSupportFirstPersonPOVInThird=true
    end object
    m_MeshTP=GadgetMeshTP
    ItemName="XM50 GAS MASK"
}