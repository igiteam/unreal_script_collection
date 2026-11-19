class R6GadgetExplosiveBreaching extends R6GadgetExplosive
    native
    config(GadgetsConfig)
    hidecategories(lighting);

var R6InteractiveDoor m_pDoor;
var int m_iIKAdjustStep;

// Export UR6GadgetExplosiveBreaching::execFillTcInfo(FFrame&, void* const)
native final function FillTcInfo();

event float GetUseAnimTime()
{
    local R6Pawn pPawn;

    // End:0xED
    if(m_bSetting)
    {
        pPawn = R6Pawn(Instigator);
        // End:0xDA
        if(pPawn != none)
        {
            // End:0x6F
            if(pPawn.IsInTakeCover())
            {
                // End:0x5C
                if(pPawn.m_bTcNearHandle)
                {
                    return GetGadgetsConfig().m_fBreachingUseTimeNearTc;                    
                }
                else
                {
                    return GetGadgetsConfig().m_fBreachingUseTimeFarTc;
                }                
            }
            else
            {
                // End:0xCA
                if(pPawn.m_bIsNPCPawn && (int(pPawn.m_eRainbowEntryLocation) == int(2)) || int(pPawn.m_eRainbowEntryLocation) == int(4))
                {
                    return GetGadgetsConfig().m_fBreachingUseTimeStacked;                    
                }
                else
                {
                    return GetGadgetsConfig().m_fBreachingUseTime;
                }
            }
        }
        return GetGadgetsConfig().m_fBreachingUseTime;        
    }
    else
    {
        return GetUseAnimTime();
    }
    return;
}

function SetDettachTimer()
{
    local R6Pawn pPawn;
    local float fTime;

    pPawn = R6Pawn(Instigator);
    // End:0x112
    if(pPawn != none)
    {
        // End:0x9A
        if(pPawn.IsInTakeCover())
        {
            // End:0x58
            if(pPawn.m_bTcNearHandle)
            {
                fTime = GetGadgetsConfig().m_fBreachDettachNearTc;                
            }
            else
            {
                // End:0x82
                if(pPawn.m_bTcSideLeft)
                {
                    fTime = GetGadgetsConfig().m_fBreachDettachFarLeftTc;                    
                }
                else
                {
                    fTime = GetGadgetsConfig().m_fBreachDettachFarRightTc;
                }
            }            
        }
        else
        {
            // End:0xFA
            if(pPawn.m_bIsNPCPawn && (int(pPawn.m_eRainbowEntryLocation) == int(2)) || int(pPawn.m_eRainbowEntryLocation) == int(4))
            {
                fTime = GetGadgetsConfig().m_fBreachDettachStacked;                
            }
            else
            {
                fTime = GetGadgetsConfig().m_fBreachingDettachTime;
            }
        }        
    }
    else
    {
        fTime = GetGadgetsConfig().m_fBreachingDettachTime;
    }
    SetTimer(fTime, false, 'DettachGadget');
    return;
}

auto state Ready
{
    function UseGadget()
    {
        local bool bSide, bWorking;
        local R6Pawn pPawn;
        local bool bHolster;

        // End:0x1B4
        if(m_pDoor != none)
        {
            bSide = m_pDoor.GetLocationSide(Instigator.Location);
            // End:0x1B4
            if(m_pDoor.CanBreach(bSide))
            {
                bWorking = true;
                m_iIKAdjustStep = 0;
                m_pDoor.m_bBlocked = true;
                m_pDoor.NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
                // End:0xA5
                if(Instigator.IsInTakeCover())
                {
                    FillTcInfo();
                }
                UseGadget();
                // End:0x1B4
                if(int(GetSettingType()) != int(1))
                {
                    pPawn = R6Pawn(Instigator);
                    // End:0x142
                    if(pPawn.m_bIsNPCPawn && (int(pPawn.m_eRainbowEntryLocation) == int(2)) || int(pPawn.m_eRainbowEntryLocation) == int(4))
                    {
                        bHolster = true;
                        pPawn.SetTimer(GetGadgetsConfig().m_fBreachDropWeaponStacked, false, 'HolsterOnInteraction');                        
                    }
                    else
                    {
                        // End:0x183
                        if(pPawn.bIsCrouched || !pPawn.IsInTakeCover())
                        {
                            bHolster = true;
                            pPawn.HolsterOnInteraction();
                        }
                    }
                    // End:0x1A3
                    if(bHolster)
                    {
                        pPawn.SetEquipOnInteractionTimer(GetUseAnimTime());
                    }
                    pPawn.m_bUseAnimPosture = true;
                }
            }
        }
        // End:0x1DB
        if(!bWorking)
        {
            ActivateEventClass(Class'SeqEvent_R6CantBreachDoor', Instigator, GeneratedEvents);
            CouldNotUseGadget();
        }
        return;
    }

    simulated event bool CanUseGadget()
    {
        // End:0x105
        if((m_pDoor != none) && !m_bExhausted)
        {
            // End:0xAF
            if(((Instigator.IsInTakeCover() && Instigator.IsHumanControlled()) && m_pDoor.m_pDoubleDoor != none) && VSizeSq(Instigator.Location - m_pDoor.Location) > VSizeSq(Instigator.Location - m_pDoor.m_pDoubleDoor.Location))
            {
                return false;
            }
            return (m_pDoor.CanBreach(m_pDoor.GetLocationSide(Instigator.Location)) && m_pDoor.HasSpaceToPlaceBreachCharge(Instigator)) && CanUseGadget();            
        }
        else
        {
            return false;
        }
        return;
    }

    simulated function bool BlocksView()
    {
        return true;
        return;
    }

    simulated event bool BlocksActionForPC()
    {
        return true;
        return;
    }
    stop;
}

state Setting
{
    function UseGadget()
    {
        // End:0x33
        if(((Instigator != none) && Instigator.m_bIsNPCPawn) && !m_bGadgetAttached)
        {
            Explode();
        }
        return;
    }

    function EndUseGadget()
    {
        local R6Pawn pPawn;

        EndUseGadget();
        pPawn = R6Pawn(Instigator);
        pPawn.PlaceLHand(false);
        pPawn.PlaceRHand(false);
        pPawn.m_bUseAnimPosture = false;
        m_pDoor.m_bBlocked = false;
        m_pDoor.NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
        m_pDoor = none;
        Instigator.Controller.ReturnFromInteractState();
        return;
        return;
    }

    simulated function bool BlocksView()
    {
        return true;
        return;
    }

    simulated event bool BlocksActionForPC()
    {
        return true;
        return;
    }
    stop;
}

defaultproperties
{
    m_ExplosiveClass=Class'R6ExplosiveBreaching'
    m_iMaxAmmoNormal=6
    m_iMaxAmmoVeteran=3
    m_iMaxAmmoElite=2
    m_iMaxAmmoMP=3
    m_bCanUseInTakeCover=true
    m_bSelectable=true
    m_strGadgetIcon="ic_gadget_breachingcharge"
    // Reference: StaticMeshComponent'Default__R6GadgetExplosiveBreaching.GadgetMeshTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6GadgetExplosive.GadgetMeshTP'
    begin object name="GadgetMeshTP"
        StaticMesh=StaticMesh'RS5Weapons.Gadgets.W_Gad_BreachingCharge'
    end object
    m_MeshTP=GadgetMeshTP
    ItemName="BREACHING CHARGE"
    // Reference: StaticMeshComponent'Default__R6GadgetExplosiveBreaching.GadgetMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6GadgetExplosive.GadgetMesh'
    begin object name="GadgetMesh"
        StaticMesh=StaticMesh'RS5Weapons.Gadgets.W_Gad_BreachingCharge'
    end object
    m_Mesh=GadgetMesh
}