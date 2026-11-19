class R6InteractiveWindow extends R6InteractiveActor
    native
    config(Game)
    editinlinenew
    placeable
    hidecategories(lighting,Object);

enum EWindowOpeningDir
{
    WINDOW_OPEN_UP,                 // 0
    WINDOW_OPEN_DOWN,               // 1
    WINDOW_OPEN_LEFT,               // 2
    WINDOW_OPEN_RIGHT,              // 3
    WINDOW_OPEN_MAX                 // 4
};

var(Window) repnotify bool m_bOpen;
var(Window) bool m_bCanBeClimbed;
var(Window) bool m_bCanBeOpened;
var bool sm_bOpen;
var bool m_bBroken;
var bool m_bChange;
var bool m_bUseRopeInFront;
var(Window) R6InteractiveWindow.EWindowOpeningDir m_eOpeningDir;
var float m_fHeight;
var float m_fWidth;
var float m_fChangeCount;
var repnotify R6InteractiveRope m_pRope;
var R6InteractiveRopePlace m_pRopePlace;
var Vector m_vStackTCLeft[2];
var Vector m_vStackTCRight[2];
var Vector m_vStackStandLeft[2];
var Vector m_vStackStandRight[2];
var Vector m_vStackStandCenter[2];
var Vector m_vEntryLeft[2];
var Vector m_vEntryRight[2];
var Vector m_vEntryFront[2];
var Vector m_vCover[2];
var int m_iWindowBordersIdx[2];
var int m_iLeftBordersIdx[2];
var int m_iRightBordersIdx[2];
var export editinline R6BreakableGlassComponent m_pBreakableGlassComponent;
var R6BreakableGlassTemplate m_pBreakableGlassTemplate;
var SR6BreakableGlassDamageReplicateStruct m_DamageReplication;
var(R6Sound) /*0x04000000-0x00000000*/ SoundCue m_OpeningSound;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_bBroken, m_bChange, 
        m_bOpen, m_fChangeCount, 
        m_pRope;

    // Pos:0x00D
    if((int(Role) == int(ROLE_Authority)) && !bNetInitial)
        m_DamageReplication;
}

// Export UR6InteractiveWindow::execGlassTakeDamage(FFrame&, void* const)
native final function bool GlassTakeDamage(float Damage, Pawn pInstigator, Vector HitLocation, PrimitiveComponent pHitPrimitive, Vector fireOrigin, bool isExplosion, bool isFire, optional int Index, optional bool bSkipDistCheck);

// Export UR6InteractiveWindow::execOpen(FFrame&, void* const)
native final function Open(R6Pawn pPawn);

// Export UR6InteractiveWindow::execBreak(FFrame&, void* const)
native final function Break(R6Pawn pPawn, optional R6GameEnums.EPawnInteractionType eFromPosition);

// Export UR6InteractiveWindow::execIsWindowSuitableForAssault(FFrame&, void* const)
native final function bool IsWindowSuitableForAssault(Vector vStartLocation);

// Export UR6InteractiveWindow::execUpdatePeekFlags(FFrame&, void* const)
native final function UpdatePeekFlags(ENavMesh pNavMesh);

// Export UR6InteractiveWindow::execTimerBreak(FFrame&, void* const)
native final function TimerBreak();

event StartOpenTimer(float fTime)
{
    SetTimer(fTime, false, 'TimerOpen');
    return;
}

event TimerOpen()
{
    // End:0xA1
    if(!m_bChange && !m_bOpen)
    {
        ActivateEventClass(Class'SeqEvent_R6WindowOpened', m_pUser, GeneratedEvents);
        m_bChange = true;
        m_bOpen = true;
        m_fChangeCount = 0.0000000;
        NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
        UpdatePeekFlags(none);
        // End:0x85
        if(m_pVolume != none)
        {
            m_pVolume.EnableCollide(true);
        }
        // End:0xA1
        if(m_R6Sound != none)
        {
            m_R6Sound.m_bDontActivate = false;
        }
    }
    return;
}

event StartBreakTimer(float fTime)
{
    SetTimer(fTime, false, 'TimerBreak');
    return;
}

function Close()
{
    // End:0x53
    if(!m_bChange && m_bOpen)
    {
        m_bChange = true;
        m_bOpen = false;
        m_fChangeCount = 0.0000000;
        NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
        UpdatePeekFlags(none);
    }
    return;
}

function InteractSuccesful(Pawn pInteractor)
{
    local R6Pawn pPawn;

    InteractSuccesful(pInteractor);
    pPawn = R6Pawn(pInteractor);
    // End:0x15F
    if(pPawn != none)
    {
        // End:0xAE
        if(((((int(pPawn.m_ePawnInteraction) == int(16)) || int(pPawn.m_ePawnInteraction) == int(17)) || int(pPawn.m_ePawnInteraction) == int(18)) || int(pPawn.m_ePawnInteraction) == int(19)) || int(pPawn.m_ePawnInteraction) == int(20))
        {
            return;
        }
        // End:0x132
        if(m_bOpen || m_bBroken)
        {
            // End:0xF5
            if(m_pRope != none)
            {
                m_pRope.Interact(pPawn);
                pPawn.m_pOnWindow = self;                
            }
            else
            {
                // End:0x12F
                if(m_bCanBeClimbed && HasSpaceToClimb(pPawn))
                {
                    pPawn.ClimbActor(self);
                    pPawn.m_pOnWindow = self;
                }
            }            
        }
        else
        {
            // End:0x146
            if(m_bCanBeOpened)
            {
                Open(pPawn);
            }
            pInteractor.Controller.PropagateReturnFromInteractState();
        }
    }
    return;
}

simulated function bool BlocksView()
{
    return m_bOpen;
    return;
}

simulated function bool DisableCameraMoveWhileUsing()
{
    return false;
    return;
}

simulated event bool GetInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, optional PlayerController PC)
{
    // End:0x44
    if(m_bOpen || m_bBroken)
    {
        // End:0x2B
        if(m_pRope != none)
        {
            eDesc = 25;            
        }
        else
        {
            // End:0x3F
            if(m_bCanBeClimbed)
            {
                eDesc = 8;                
            }
            else
            {
                return false;
            }
        }        
    }
    else
    {
        // End:0x58
        if(m_bCanBeOpened)
        {
            eDesc = 7;            
        }
        else
        {
            return false;
        }
    }
    return !m_bInteractDisabled;
    return;
}

simulated event bool GetBusyInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, PlayerController PC)
{
    // End:0x16
    if(m_bInteractDisabled || m_bShutdown)
    {
        return false;
    }
    // End:0x57
    if(((PC != none) && PC.Pawn != none) && PC.Pawn.IsInTakeCover())
    {
        return false;
    }
    // End:0x8A
    if(!m_bOpen && !m_bBroken)
    {
        // End:0x85
        if(m_bCanBeOpened)
        {
            eDesc = 7;
            return true;            
        }
        else
        {
            return false;
        }        
    }
    else
    {
        // End:0xA2
        if(m_pRope != none)
        {
            eDesc = 25;
            return true;            
        }
        else
        {
            // End:0xB8
            if(m_bCanBeClimbed)
            {
                eDesc = 8;
                return true;                
            }
            else
            {
                return false;
            }
        }
    }
    return;
}

defaultproperties
{
    m_bCanBeClimbed=true
    m_bCanBeOpened=true
    // Reference: R6BreakableGlassComponent'Default__R6InteractiveWindow.BreakableGlassCpt'
    begin object name="BreakableGlassCpt" class=Class'Engine.R6BreakableGlassComponent'
    end object
    m_pBreakableGlassComponent=BreakableGlassCpt
    m_VolumeClass=Class'R6InteractingVolume'
    m_bWalkAfterInteract=false
    m_bCanBeUsedByTeam=false
    m_eType=3
    // Reference: SpriteComponent'Default__R6InteractiveWindow.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__R6InteractiveActor.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'KellerEditorMaterials.Window_64'
    end object
    Components[0]=Sprite
    // Reference: StaticMeshComponent'Default__R6InteractiveWindow.InteractiveActorMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6InteractiveActor.InteractiveActorMesh'
    begin object name="InteractiveActorMesh"
    end object
    Components[1]=InteractiveActorMesh
    Components[2]=BreakableGlassCpt
    TickGroup=1
    SupportedEvents=/* Array type was not detected. */
}