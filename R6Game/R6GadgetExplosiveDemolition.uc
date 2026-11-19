class R6GadgetExplosiveDemolition extends R6GadgetExplosive
    native
    config(GadgetsConfig)
    hidecategories(lighting);

// Export UR6GadgetExplosiveDemolition::execGetUseAnimTime(FFrame&, void* const)
native function float GetUseAnimTime();

// Export UR6GadgetExplosiveDemolition::execGetThrowTime(FFrame&, void* const)
native final function float GetThrowTime();

// Export UR6GadgetExplosiveDemolition::execCanUseGadget(FFrame&, void* const)
native simulated function bool CanUseGadget();

simulated function name GetGadgetAttachSocket(bool bFPMesh)
{
    // End:0x24
    if(m_bSetting)
    {
        // End:0x1B
        if(bFPMesh)
        {
            return 'R65_C4_LHand';            
        }
        else
        {
            return 'R65_BCharge_LHand';
        }        
    }
    else
    {
        return 'R65_Detonator_LHand';
    }
    return;
}

function SetDettachTimer()
{
    SetTimer(GetThrowTime(), false, 'DettachGadget');
    return;
}

defaultproperties
{
    m_ExplosiveClass=Class'R6ExplosiveDemolition'
    m_iMaxAmmoNormal=6
    m_iMaxAmmoVeteran=3
    m_iMaxAmmoElite=2
    m_iMaxAmmoMP=3
    m_bCanUseInTakeCover=true
    m_bSelectable=true
    m_strGadgetIcon="ic_gadget_C4"
    // Reference: StaticMeshComponent'Default__R6GadgetExplosiveDemolition.GadgetMeshTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6GadgetExplosive.GadgetMeshTP'
    begin object name="GadgetMeshTP"
        StaticMesh=StaticMesh'RS5Weapons.Gadgets.W_Gad_C4'
    end object
    m_MeshTP=GadgetMeshTP
    ItemName="C4"
    // Reference: StaticMeshComponent'Default__R6GadgetExplosiveDemolition.GadgetMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6GadgetExplosive.GadgetMesh'
    begin object name="GadgetMesh"
        StaticMesh=StaticMesh'RS5Weapons.Gadgets.W_Gad_C4'
    end object
    m_Mesh=GadgetMesh
}