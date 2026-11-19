class R6InteractiveLadder extends R6InteractiveActor
    native
    config(Game)
    editinlinenew
    placeable
    hidecategories(lighting,Object);

var(Ladder) float m_fTemporaryHeight;
var float m_fCalculatedHeight;
var array<R6Pawn> m_aUsers;

// Export UR6InteractiveLadder::execIsPawnAtTop(FFrame&, void* const)
native final function bool IsPawnAtTop(Pawn pPawn);

// Export UR6InteractiveLadder::execIsBottomBlocked(FFrame&, void* const)
native final function bool IsBottomBlocked(R6Pawn pPawn, bool bSkipIncapacitated);

// Export UR6InteractiveLadder::execIsTopBlocked(FFrame&, void* const)
native final function bool IsTopBlocked(R6Pawn pPawn, bool bSkipIncapacitated);

// Export UR6InteractiveLadder::execEnableTopVolume(FFrame&, void* const)
native final function EnableTopVolume(bool bVal, R6Pawn pPawn);

// Export UR6InteractiveLadder::execEnableBottomVolume(FFrame&, void* const)
native final function EnableBottomVolume(bool bVal, R6Pawn pPawn);

function ResetOriginalData()
{
    m_aUsers.Length = 0;
    ResetOriginalData();
    return;
}

function InteractSuccesful(Pawn pInteractor)
{
    local R6Pawn pPawn;

    InteractSuccesful(pInteractor);
    pPawn = R6Pawn(pInteractor);
    // End:0x37
    if(pPawn != none)
    {
        pPawn.ClimbR6Ladder(self);
    }
    return;
}

function bool IsInterestingForPC(R6PlayerController Controller)
{
    local bool bFound;
    local int I;

    // End:0x13
    if(!IsInterestingForPC(Controller))
    {
        return false;
    }
    I = 0;
    J0x1A:

    // End:0x63 [Loop If]
    if((I < m_aUsers.Length) && !bFound)
    {
        bFound = Controller.m_R6Pawn == m_aUsers[I];
        I++;
        // [Loop Continue]
        goto J0x1A;
    }
    return !bFound;
    return;
}

defaultproperties
{
    m_VolumeClass=Class'R6InteractingVolume'
    m_bWalkAfterInteract=false
    m_bCheckInteractRotation=true
    m_eInteractDesc=21
    bMovable=false
    // Reference: SpriteComponent'Default__R6InteractiveLadder.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__R6InteractiveActor.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.S_Ladder'
    end object
    Components[0]=Sprite
    // Reference: StaticMeshComponent'Default__R6InteractiveLadder.InteractiveActorMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6InteractiveActor.InteractiveActorMesh'
    begin object name="InteractiveActorMesh"
    end object
    Components[1]=InteractiveActorMesh
    // Reference: ArrowComponent'Default__R6InteractiveLadder.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="Arrow" class=Class'Engine.ArrowComponent'
        ArrowColor=(R=150,G=100,B=150,A=255)
        ArrowSize=5.0000000
    end object
    Components[2]=Arrow
    TickGroup=1
}