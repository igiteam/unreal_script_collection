class R6InteractiveRope extends R6InteractiveActor
    native
    config(Game)
    notplaceable
    hidecategories(lighting);

const kRopeCylinderRadius = 35.f;
const kPawnRappellingRadius = 70.f;
const kPawnFastRopeRadius = 34.f;

var Vector m_vRopeStart;
var Vector m_vStart;
var Vector m_vEnd;
var transient R6SBActorRapelRope m_pSoftBody;
var bool m_bFastRope;
var bool m_bChopperLike;
var bool m_bHidden;
var bool m_bNoSpin;
var bool m_bInitialized;
var Vector m_vAttachmentPoint;
var array<R6InteractiveWindow> m_aWindows;
var R6InteractiveRopePlace m_pRopePlace;
var float m_fMaxLength;
var export editinline MeshComponent m_pAttachmentMesh;
var StaticMesh m_pAttachmentStaticMesh;
var SkeletalMesh m_pAttachmentSkeletalMesh;
var Vector m_vAttachmentPos;
var Rotator m_rAttachmentRot;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_bChopperLike, m_bFastRope, 
        m_bInitialized, m_fMaxLength, 
        m_pAttachmentSkeletalMesh, m_pAttachmentStaticMesh, 
        m_pRopePlace, m_rAttachmentRot, 
        m_vAttachmentPoint, m_vAttachmentPos, 
        m_vEnd, m_vRopeStart, 
        m_vStart;
}

// Export UR6InteractiveRope::execGetStart(FFrame&, void* const)
native final function Vector GetStart();

// Export UR6InteractiveRope::execGetEnd(FFrame&, void* const)
native final function Vector GetEnd();

// Export UR6InteractiveRope::execIsTopBlocked(FFrame&, void* const)
native final function bool IsTopBlocked(R6Pawn pPawn, bool bSkipIncapacitated);

// Export UR6InteractiveRope::execIsBottomBlocked(FFrame&, void* const)
native final function bool IsBottomBlocked(R6Pawn pPawn, bool bSkipIncapacitated);

// Export UR6InteractiveRope::execIsWindowBlocked(FFrame&, void* const)
native final function bool IsWindowBlocked(R6Pawn pPawn, R6InteractiveWindow pWindow, bool bSkipIncapacitated);

// Export UR6InteractiveRope::execIsFastRope(FFrame&, void* const)
native final function bool IsFastRope();

// Export UR6InteractiveRope::execAddRopeToRopePlace(FFrame&, void* const)
native final function AddRopeToRopePlace();

// Export UR6InteractiveRope::execAddWindowToRope(FFrame&, void* const)
native final function AddWindowToRope(R6InteractiveWindow pWindow);

// Export UR6InteractiveRope::execCreateAttachmentMesh(FFrame&, void* const)
native final function CreateAttachmentMesh(MeshComponent Mesh, Vector vPos, Rotator rRot);

// Export UR6InteractiveRope::execIsBadInteractionFromBottom(FFrame&, void* const)
native final function bool IsBadInteractionFromBottom(Pawn pPawn);

function ResetOriginalData()
{
    ResetOriginalData();
    return;
}

simulated event SetDeleteOnReset(bool bVal)
{
    // End:0x21
    if(m_pSoftBody != none)
    {
        m_pSoftBody.SetDeleteOnReset(bVal);
    }
    SetDeleteOnReset(bVal);
    return;
}

function InteractSuccesful(Pawn pInteractor)
{
    local R6Pawn pPawn;

    InteractSuccesful(pInteractor);
    pPawn = R6Pawn(pInteractor);
    // End:0x38
    if(pPawn != none)
    {
        pPawn.ClimbRope(self, false);
    }
    return;
}

simulated event bool GetInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, optional PlayerController PC)
{
    // End:0x22
    if((m_pRopePlace != none) && m_pRopePlace.m_bTerroOnly)
    {
        return false;
    }
    // End:0x69
    if(IsFastRope())
    {
        // End:0x5E
        if((m_pRopePlace != none) && R6Helicopter(m_pRopePlace.Owner) != none)
        {
            eDesc = 0;
            return false;            
        }
        else
        {
            eDesc = 15;
        }        
    }
    else
    {
        eDesc = 25;
    }
    return true;
    return;
}

simulated event Hide(bool bVal)
{
    m_bHidden = bVal;
    bHidden = bVal;
    // End:0x3B
    if(m_pSoftBody != none)
    {
        m_pSoftBody.bHidden = bVal;
    }
    return;
}

simulated event bool GetBusyInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, PlayerController PC)
{
    // End:0x21
    if((m_pRopePlace != none) && m_pRopePlace.m_bTerroOnly)
    {
        return false;
    }
    // End:0x3A
    if(IsBadInteractionFromBottom(PC.Pawn))
    {
        return false;
    }
    return GetBusyInteractDesc(eDesc, PC);
    return;
}

defaultproperties
{
    m_ActorName="Rope"
    m_bWalkAfterInteract=false
    m_eInteractDesc=25
    bNoDelete=false
    bReplicateMovement=true
    bUpdateSimulatedPosition=true
    bBlockActors=false
    // Reference: SpriteComponent'Default__R6InteractiveRope.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__R6InteractiveActor.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    // Reference: StaticMeshComponent'Default__R6InteractiveRope.InteractiveActorMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6InteractiveActor.InteractiveActorMesh'
    begin object name="InteractiveActorMesh"
    end object
    Components[1]=InteractiveActorMesh
    // Reference: CylinderComponent'Default__R6InteractiveRope.CollisionRope'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="CollisionRope" class=Class'Engine.CylinderComponent'
        CollisionHeight=0.0000000
        CollisionRadius=0.0000000
        CollideActors=true
        Translation=(X=10.0000000,Y=0.0000000,Z=0.0000000)
    end object
    Components[2]=CollisionRope
    TickGroup=1
    CollisionComponent=CollisionRope
}