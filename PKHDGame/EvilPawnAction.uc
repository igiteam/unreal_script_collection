class EvilPawnAction extends Object
    abstract
    native(PawnAction);

var EvilPawn PawnOwner;
var EvilPlayerController PCOwner;
var EvilAIController AIOwner;
var class<EvilAICmd_Base_PushedByPawnAction> DefaultAICommand;
var EvilAICmd_Base_PushedByPawnAction AICommand;
var() float SpeedModifier;
var const bool bLockPawnRotation;
var private bool bPawnRotationLocked;
var const bool bForceRotation;
var private bool bLastCanDoTurnInPlace;
var const bool bCoverExitMirrorTransition;
var const bool bDisableMovement;
var private bool bMovementDisabled;
var const bool bDisableTurnInPlace;
var const bool bDisableAI;
var const bool bDisablePOIs;
var const bool bBreakFromCover;
var const bool bDisableCollision;
var const bool bDisablePhysics;
var const bool bDisableHeadTracking;
var bool bLastCanDoSpecialMove;
var bool bDisableIK;
var transient float LastCanDoSpecialMoveTime;
var BasedPosition OldFocalPoint;
var Vector OldAccel;

function Tick(float DeltaTime)
{
    //return;    
}

function bool CanOverrideWithCurrentAction()
{
    return false;
    //return ReturnValue;    
}

function bool CanChainAction(byte NextAction)
{
    return false;
    //return ReturnValue;    
}

function bool CanOverrideActionWith(byte NewAction)
{
    return false;
    //return ReturnValue;    
}

function bool CanOverrideAction(byte inAction)
{
    return false;
    //return ReturnValue;    
}

final function bool CanDoPawnAction(optional bool bForceCheck)
{
    // End:0xBD
    if(PawnOwner != none)
    {
        // End:0xB2
        if(bForceCheck || PawnOwner.WorldInfo.TimeSeconds != LastCanDoSpecialMoveTime)
        {
            bLastCanDoSpecialMove = InternalCanDoPawnAction();
            LastCanDoSpecialMoveTime = PawnOwner.WorldInfo.TimeSeconds;
        }
        return bLastCanDoSpecialMove;
    }
    return false;
    //return ReturnValue;    
}

function bool CanInteractWithPawn(EvilPawn OtherPawn)
{
    return false;
    //return ReturnValue;    
}

function bool AimOffsetOverride(out Rotator DeltaRot)
{
    return false;
    //return ReturnValue;    
}

protected function bool InternalCanDoPawnAction()
{
    return true;
    //return ReturnValue;    
}

function PawnActionStarted(bool bForced, byte PrevAction)
{
    PCOwner = EvilPlayerController(PawnOwner.Controller);
    AIOwner = EvilAIController(PawnOwner.Controller);
    PawnOwner.OnIKStatusUpdate();
    // End:0x162
    if(((AIOwner != none) && DefaultAICommand != none) && (AIOwner.GetActiveCommand() == none) || AIOwner.GetActiveEvilCommand().AllowPushOfDefaultCommandForPawnAction(PawnOwner.PawnAction))
    {
        AICommand = DefaultAICommand.static.PushSpecialMoveCommand(AIOwner);
        // End:0x162
        if(AICommand == none)
        {
        }
    }
    // End:0x1BA
    if(bForceRotation)
    {
        bLastCanDoTurnInPlace = PawnOwner.bCanDoTurnInPlaceAnim;
        PawnOwner.bCanDoTurnInPlaceAnim = false;
    }
    // End:0x1D2
    if(default.bLockPawnRotation)
    {
        SetLockPawnRotation(true);
    }
    // End:0x200
    if(bDisableTurnInPlace)
    {
        PawnOwner.bCanDoTurnInPlaceAnim = false;
    }
    // End:0x221
    if(bDisableCollision)
    {
        TogglePawnCollision(PawnOwner, false);
    }
    // End:0x290
    if(bDisablePhysics)
    {
        PawnOwner.ZeroMovementVariables();
        // End:0x290
        if(int(PawnOwner.Role) == int(ROLE_Authority))
        {
            PawnOwner.SetPhysics(0);
        }
    }
    // End:0x2A7
    if(bBreakFromCover)
    {
        BreakFromCover();
    }
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    // End:0xB9
    if(((AIOwner != none) && DefaultAICommand != none) && AICommand != none)
    {
        // End:0xAE
        if(AIOwner.GetActiveCommand() == AICommand)
        {
            AICommand.Status = 'Success';
            AIOwner.PopCommand(AICommand);
        }
        AICommand = none;
    }
    // End:0xC8
    if(PCOwner != none)
    {
    }
    // End:0xFF
    if(bForceRotation)
    {
        PawnOwner.bCanDoTurnInPlaceAnim = bLastCanDoTurnInPlace;
    }
    // End:0x120
    if(bDisableCollision)
    {
        TogglePawnCollision(PawnOwner, true);
    }
    // End:0x170
    if(bDisablePhysics)
    {
        // End:0x170
        if(int(PawnOwner.Role) == int(ROLE_Authority))
        {
            PawnOwner.SetPhysics(2);
        }
    }
    // End:0x17D
    if(bMovementDisabled)
    {
    }
    // End:0x195
    if(bPawnRotationLocked)
    {
        SetLockPawnRotation(false);
    }
    // End:0x1E1
    if(bDisableTurnInPlace)
    {
        PawnOwner.bCanDoTurnInPlaceAnim = PawnOwner.default.bCanDoTurnInPlaceAnim;
    }
    PawnOwner.OnIKStatusUpdate();
    //return;    
}

function OnAnimEndFromNotify()
{
    //return;    
}

function OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    PawnOwner.EndPawnAction();
    //return;    
}

function bool ButtonPress(name ButtonName)
{
    return false;
    //return ReturnValue;    
}

function RootMotionModeChanged(SkeletalMeshComponent SkelComp)
{
    //return;    
}

function RootMotionExtracted(SkeletalMeshComponent SkelComp, out BoneAtom ExtractedRootMotionDelta)
{
    //return;    
}

function FirePressedNotification()
{
    //return;    
}

function bool ShouldReplicate()
{
    return true;
    //return ReturnValue;    
}

final function TogglePawnCollision(EvilPawn aPawn, bool bToggleOn)
{
    local Vector ColCompOffset, OriginalLocation, ZCheck, ColLocation, out_HitLoc, out_HitNormal,
	    CollisionAdjustedOffset, Delta2D;

    // End:0x4AA
    if(bToggleOn)
    {
        // End:0x4A7
        if((aPawn.bCollideWorld != aPawn.default.bCollideWorld) || aPawn.bBlockActors != aPawn.default.bBlockActors)
        {
            OriginalLocation = aPawn.Location;
            aPawn.SetCollision(aPawn.bCollideActors, aPawn.default.bBlockActors);
            aPawn.bCollideWorld = aPawn.default.bCollideWorld;
            CollisionAdjustedOffset = aPawn.Location - OriginalLocation;
            ColCompOffset = ((aPawn.CollisionComponent != none) ? aPawn.CollisionComponent.Translation : vect(0.0000000, 0.0000000, 0.0000000));
            // End:0x339
            if(VSizeSq(CollisionAdjustedOffset) > 0.0001000)
            {
                Delta2D = CollisionAdjustedOffset;
                Delta2D.Z = 0.0000000;
                // End:0x339
                if(VSizeSq(Delta2D) > 0.0001000)
                {
                    ColLocation = aPawn.Location + ColCompOffset;
                    // End:0x339
                    if(aPawn.Trace(out_HitLoc, out_HitNormal, ColLocation - Delta2D, ColLocation, true, aPawn.GetCollisionExtent(),, aPawn.8) != none)
                    {
                        aPawn.SetLocation(out_HitLoc - ColCompOffset);
                    }
                }
            }
            ColLocation = aPawn.Location + ColCompOffset;
            ZCheck = vect(0.0000000, 0.0000000, 1.0000000) * aPawn.CylinderComponent.CollisionHeight;
            // End:0x474
            if(aPawn.Trace(out_HitLoc, out_HitNormal, ColLocation - ZCheck, ColLocation + ZCheck, true, aPawn.GetCollisionExtent(),, aPawn.8) != none)
            {
                aPawn.SetLocation(out_HitLoc - ColCompOffset);
            }
            CollisionAdjustedOffset = aPawn.Location - OriginalLocation;
        }        
    }
    else
    {
        aPawn.SetCollision(aPawn.bCollideActors, false);
        aPawn.bCollideWorld = false;
    }
    //return;    
}

final function BreakFromCover()
{
    // End:0x46
    if(PawnOwner.CurrentLink != none)
    {
        AIOwner.InvalidateCover(,, true, true);
    }
    //return;    
}

final function SetLockPawnRotation(bool bLock)
{
    // End:0x5E
    if(bPawnRotationLocked != bLock)
    {
        bPawnRotationLocked = bLock;
        // End:0x5E
        if(!bLock)
        {
            PawnOwner.InterpolatePawnRotation();
        }
    }
    //return;    
}

final function bool IsPawnRotationLocked()
{
    return bPawnRotationLocked;
    //return ReturnValue;    
}

defaultproperties
{
    SpeedModifier=1.0000000
    bDisableIK=true
}