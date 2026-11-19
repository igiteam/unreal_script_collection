class R6GadgetSnakeCam extends R6Gadget
    native
    config(GadgetsConfig)
    hidecategories(lighting);

var R6SnakeCamViewer m_pViewer;
var R6InteractiveDoor m_pDoor;
var bool m_bCamIn;
var bool m_bCamOut;
var bool m_bSnakeCamActive;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_bCamIn, m_bCamOut, 
        m_bSnakeCamActive, m_pDoor, 
        m_pViewer;
}

// Export UR6GadgetSnakeCam::execActivateCam(FFrame&, void* const)
native final function ActivateCam(bool bValue);

// Export UR6GadgetSnakeCam::execGetViewerLocRot(FFrame&, void* const)
native final function GetViewerLocRot(out Vector vPos, out Rotator rRot);

event float GetUseAnimTime()
{
    local float fTime;

    // End:0x4B
    if(m_bCamIn)
    {
        // End:0x33
        if(Instigator.bIsCrouched)
        {
            fTime = GetGadgetsConfig().m_fCamUseCrouch;            
        }
        else
        {
            fTime = GetGadgetsConfig().m_fCamUse;
        }        
    }
    else
    {
        // End:0x75
        if(Instigator.bIsCrouched)
        {
            fTime = GetGadgetsConfig().m_fCamRemoveCrouch;            
        }
        else
        {
            fTime = GetGadgetsConfig().m_fCamRemove;
        }
        // End:0xB3
        if(Instigator.IsInTakeCover())
        {
            fTime *= GetGadgetsConfig().m_fCamRemoveTcMod;
        }
    }
    return fTime;
    return;
}

function SetActionTimer()
{
    // End:0x51
    if(m_bCamIn)
    {
        // End:0x36
        if(Instigator.bIsCrouched)
        {
            SetTimer(GetGadgetsConfig().m_fCamActivateCrouch, false, 'ActivateCamTimer');            
        }
        else
        {
            SetTimer(GetGadgetsConfig().m_fCamActivate, false, 'ActivateCamTimer');
        }        
    }
    else
    {
        // End:0x74
        if(m_bCamOut)
        {
            ActivateCam(false);
            m_pViewer.Destroy();
            m_pViewer = none;
        }
    }
    return;
}

function ActivateCamTimer()
{
    ActivateCam(true);
    return;
}

simulated state Set
{
    function BeginState(name PreviousState)
    {
        BeginState(PreviousState);
        m_bCamIn = false;
        m_bCamOut = false;
        ResetAnim();
        return;
    }

    simulated event bool CanUseGadget()
    {
        return true;
        return;
    }

    function UseGadget()
    {
        local R6Pawn pPawn;
        local Rotator rRot;

        pPawn = R6Pawn(Instigator);
        m_bCamIn = false;
        m_bCamOut = true;
        ResetAnim();
        R6Pawn(Instigator).m_fUseGadgetCounter = 0.0000000;
        SetUseTimer();
        SetActionTimer();
        // End:0xC4
        if(!pPawn.m_bIsNPCPawn && pPawn.Controller != none)
        {
            rRot = pPawn.Controller.Rotation;
            rRot.Pitch = 0;
            R6PlayerController(pPawn.Controller).ClientUpdateRotation(rRot);
        }
        GotoState('Unsetting');
        return;
    }
    stop;
}

simulated state Unsetting
{
    function BeginState(name PreviousState)
    {
        BeginState(PreviousState);
        m_bCamIn = false;
        m_bCamOut = true;
        return;
    }

    function EndUseGadget()
    {
        EndUseGadget();
        m_pDoor.TriggerEventClass(Class'SeqEvent_R6DoorSnakeCamExited', Instigator);
        RemoveFromArray(m_pDoor.m_aSnakeCaming, R6Pawn(Instigator));
        m_pDoor = none;
        GotoState('Ready');
        Instigator.Controller.PropagateReturnFromInteractState();
        R6Character(Instigator).AttachSnakeCamHelmet();
        return;
    }
    stop;
}

auto simulated state Ready
{
    function BeginState(name PreviousState)
    {
        BeginState(PreviousState);
        m_bCamIn = true;
        m_bCamOut = false;
        return;
    }

    simulated event bool CanUseGadget()
    {
        // End:0xE4
        if((int(GetGameManager().GetGameMode()) != int(8)) && m_pViewer == none)
        {
            // End:0xE4
            if(m_pDoor != none)
            {
                // End:0xB7
                if((Instigator.IsInTakeCover() && m_pDoor.m_pDoubleDoor != none) && VSizeSq(Instigator.Location - m_pDoor.Location) > VSizeSq(Instigator.Location - m_pDoor.m_pDoubleDoor.Location))
                {
                    return false;
                }
                // End:0xE4
                if(m_pDoor.CanUseSnakeCam() && m_pDoor.HasSpaceToSnakeCam(Instigator))
                {
                    return true;
                }
            }
        }
        return false;
        return;
    }

    function UseGadget()
    {
        local Vector vPos;
        local Rotator rRot;
        local R6Pawn pR6Pawn;

        // End:0xBE
        if(m_pDoor != none)
        {
            pR6Pawn = R6Pawn(Instigator);
            pR6Pawn.m_bTcSideLeft = m_pDoor.IsActorLeftFromDoor(pR6Pawn);
            GetViewerLocRot(vPos, rRot);
            AddUniqueToArray(m_pDoor.m_aSnakeCaming, pR6Pawn);
            m_pViewer = __NFUN_278__(Class'R6SnakeCamViewer', pR6Pawn,, vPos, rRot);
            m_pViewer.Instigator = pR6Pawn;
            ResetAnim();
            SetUseTimer();
            SetActionTimer();
            GotoState('Setting');            
        }
        else
        {
            CouldNotUseGadget();
        }
        return;
    }
    stop;
}

simulated state Setting
{
    function EndUseGadget()
    {
        EndUseGadget();
        R6Pawn(Instigator).m_iResetGadgetAnim = GetGTicksGame() + 1;
        Instigator.Controller.SetTimer(GetGadgetsConfig().m_fSnakeCamMovieDuration, false, 'PropagateReturnFromInteractState');
        GotoState('Set');
        return;
    }
    stop;
}

defaultproperties
{
    m_bCamIn=true
    m_bOnlyOneAllowed=true
    m_bCanUseInTakeCover=true
    m_bSelectable=true
    m_eGadgetType=3
    m_strGadgetIcon="ic_gadget_snakecam"
    ItemName="SNAKE CAMERA"
    m_Mesh=none
}