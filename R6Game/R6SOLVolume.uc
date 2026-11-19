class R6SOLVolume extends Volume
    native
    hidecategories(lighting,Object,Movement,Display);

var(SOL) R6InteractiveSOLActor m_pLinkedSOLActor;
var(SOLTeammates) Actor m_pPreciseMoveToDemoGuy;
var(SOLTeammates) Actor m_pPreciseMoveToHacker;
var(SOLTeammates) bool m_bSendMoveToToDemoGuy;
var(SOLTeammates) bool m_bSendMoveToToHacker;
var(SOLTeammates) bool m_bSwitchDemoGuyToZombie;
var(SOLTeammates) bool m_bSwitchHackerToZombie;
var(SOLTeammates) bool m_bAllowDemoGuyToCrouchAtDestination;
var(SOLTeammates) bool m_bAllowHackerToCrouchAtDestination;
var(SOLTeammates) bool m_bAllowDemoGuyToTakeCoverAtDestination;
var(SOLTeammates) bool m_bAllowHackerToTakeCoverAtDestination;
var(SOLConfig) bool m_bLoganSaysGenericOrderVO;
var(SOLConfig) float m_MaxDistanceToAcceptGeneralMoveTo;
var(SOLConfig) Vector m_MaxDistanceForTeamOrder;

// Export UR6SOLVolume::execGetInteractDistance(FFrame&, void* const)
native function float GetInteractDistance(Pawn pPawn);

// Export UR6SOLVolume::execGetInteractLocation(FFrame&, void* const)
native function Vector GetInteractLocation(Pawn pPawn, optional bool bUseLoc, optional Vector vPos);

// Export UR6SOLVolume::execGetInteractRotation(FFrame&, void* const)
native function Rotator GetInteractRotation(Pawn pPawn);

// Export UR6SOLVolume::execIsInteractRotationGood(FFrame&, void* const)
native function bool IsInteractRotationGood(Pawn pPawn);

// Export UR6SOLVolume::execCanInteract(FFrame&, void* const)
native function bool CanInteract(Pawn pInteractor, optional bool bUseLoc, optional Vector vPos);

// Export UR6SOLVolume::execNeedsMoveToInteract(FFrame&, void* const)
native function bool NeedsMoveToInteract(Pawn pPawn);

// Export UR6SOLVolume::execPreInteract(FFrame&, void* const)
native function PreInteract(Pawn pPawn);

// Export UR6SOLVolume::execInteract(FFrame&, void* const)
native function Interact(Pawn pInteractor);

// Export UR6SOLVolume::execSpecialInteraction(FFrame&, void* const)
native function bool SpecialInteraction(Pawn pPawn, Vector vHitLocation);

simulated event bool GetInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, optional PlayerController PC)
{
    eDesc = 30;
    return true;
    return;
}

event InteractSuccesful(Pawn pInteractor)
{
    InteractSuccesful(pInteractor);
    return;
}

function OnR6DisableInteraction(SeqAct_R6DisableInteraction Action)
{
    // End:0x24
    if(Action.InputLinks[0].bHasImpulse)
    {
        m_bInteractDisabled = false;        
    }
    else
    {
        // End:0x45
        if(Action.InputLinks[1].bHasImpulse)
        {
            m_bInteractDisabled = true;
        }
    }
    // End:0x66
    if(m_pLinkedSOLActor != none)
    {
        m_pLinkedSOLActor.m_bInteractDisabled = m_bInteractDisabled;
    }
    return;
}

defaultproperties
{
    m_bSendMoveToToDemoGuy=true
    m_bSendMoveToToHacker=true
    m_bSwitchDemoGuyToZombie=true
    m_bSwitchHackerToZombie=true
    m_bAllowDemoGuyToCrouchAtDestination=true
    m_bAllowHackerToCrouchAtDestination=true
    m_bLoganSaysGenericOrderVO=true
    m_MaxDistanceToAcceptGeneralMoveTo=300.0000000
    m_MaxDistanceForTeamOrder=(X=1500.0000000,Y=1500.0000000,Z=500.0000000)
    // Reference: BrushComponent'Default__R6SOLVolume.BrushComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: BrushComponent'Engine.Default__Volume.BrushComponent0'
    begin object name="BrushComponent0"
        BlockZeroExtent=true
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}