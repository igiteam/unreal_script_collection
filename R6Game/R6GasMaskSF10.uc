class R6GasMaskSF10 extends R6GadgetGasMask
    native
    config(GadgetsConfig)
    hidecategories(lighting);

defaultproperties
{
    m_strGadgetIcon="ic_gadget_GasMaskSF10"
    // Reference: StaticMeshComponent'Default__R6GasMaskSF10.GadgetMeshTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6GadgetGasMask.GadgetMeshTP'
    begin object name="GadgetMeshTP"
        StaticMesh=StaticMesh'RS5MPCharacters_Gear_Boots.Male.RS5MPC_GasmaskSF10'
    end object
    m_MeshTP=GadgetMeshTP
    ItemName="SF10 GAS MASK"
}