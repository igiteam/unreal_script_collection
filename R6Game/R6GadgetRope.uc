class R6GadgetRope extends R6Gadget
    native
    config(GadgetsConfig)
    hidecategories(lighting);

var Vector m_vPlace;
var R6InteractiveRopePlace m_pRopePlace;
var R6InteractiveRope m_pRope;

// Export UR6GadgetRope::execCalculateHookPosRot(FFrame&, void* const)
native final function CalculateHookPosRot(out Vector vHookPos, out Rotator rHookRot);

event float GetUseAnimTime()
{
    // End:0x25
    if(m_pRope.m_bFastRope)
    {
        return GetGadgetsConfig().m_fPlantRopeFastRope;        
    }
    else
    {
        return GetGadgetsConfig().m_fPlantRopeRappel;
    }
    return;
}

simulated function name GetGadgetAttachSocket(bool bFPMesh)
{
    return 'R65_Hook_RH';
    return;
}

auto state Ready
{
    simulated event bool CanUseGadget()
    {
        // End:0x1E
        if(m_pRopePlace != none)
        {
            return m_pRopePlace.CanPlantRope();            
        }
        else
        {
            return false;
        }
        return;
    }

    function UseGadget()
    {
        // End:0x31
        if(m_pRopePlace != none)
        {
            // End:0x31
            if(m_pRopePlace.PlantRope())
            {
                m_pRope = m_pRopePlace.m_pRope;
            }
        }
        // End:0x71
        if(m_pRope != none)
        {
            m_pRope.Hide(true);
            R6Pawn(Instigator).ClimbRope(m_pRope, true);
            SetUseTimer();            
        }
        else
        {
            CouldNotUseGadget();
        }
        return;
    }

    function EndUseGadget()
    {
        local Vector vHookPos;
        local Rotator rHookRot;

        DettachMesh(none, m_MeshTP);
        m_bGadgetAttached = false;
        CalculateHookPosRot(vHookPos, rHookRot);
        m_pRope.Hide(false);
        m_pRope.CreateAttachmentMesh(m_MeshTP, vHookPos, rHookRot);
        m_pRopePlace = none;
        m_pRope = none;
        EndUseGadget();
        return;
    }
    stop;
}

defaultproperties
{
    m_eGadgetType=2
    // Reference: StaticMeshComponent'Default__R6GadgetRope.GadgetMeshTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6Gadget.GadgetMeshTP'
    begin object name="GadgetMeshTP"
        StaticMesh=StaticMesh'RS5Weapons.Gadgets.Hook'
    end object
    m_MeshTP=GadgetMeshTP
    m_Mesh=none
}