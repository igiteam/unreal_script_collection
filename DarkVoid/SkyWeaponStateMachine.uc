class SkyWeaponStateMachine extends Object
    native;

enum ESkyWeaponState
{
    SkyWeapon_Unarmed,              // 0
    SkyWeapon_Acquiring,            // 1
    SkyWeapon_Discarding,           // 2
    SkyWeapon_Drawn,                // 3
    SkyWeapon_Holstering,           // 4
    SkyWeapon_Drawing,              // 5
    SkyWeapon_Holstered,            // 6
    SkyWeapon_SwitchingHands,       // 7
    SkyWeapon_Swapping,             // 8
    SkyWeapon_MAX                   // 9
};

enum ESkyWeaponSocket
{
    SkyWeaponSocket_None,           // 0
    SkyWeaponSocket_Default,        // 1
    SkyWeaponSocket_Alternate,      // 2
    SkyWeaponSocket_Holster,        // 3
    SkyWeaponSocket_MAX             // 4
};

enum EReloadState
{
    Reload_None,                    // 0
    Reload_Full,                    // 1
    Reload_Short,                   // 2
    Reload_Begin,                   // 3
    Reload_Loop,                    // 4
    Reload_End,                     // 5
    Reload_Finished,                // 6
    Reload_MAX                      // 7
};

struct native SkyWSMDrawnFlags
{
    var bool Targeting;
    var bool Firing;
    var bool Ready;
    var bool Zooming;
    var bool Reloading;

    structdefaultproperties
    {
        Targeting=false
        Firing=false
        Ready=false
        Zooming=false
        Reloading=false
    }
};

struct native SkyWSMTimeouts
{
    var() float NoCover;
    var() float HCover;
    var() float VUpCover;
    var() float VDownCover;
    var() float HCoverCrouch;

    structdefaultproperties
    {
        NoCover=0.0000000
        HCover=0.0000000
        VUpCover=0.0000000
        VDownCover=0.0000000
        HCoverCrouch=0.0000000
    }
};

var protected transient SkyPawn Owner;
var protected transient SkyWeaponStateMachine.ESkyWeaponState State;
var protected SkyWeaponStateMachine.EReloadState ReloadState;
var protected transient byte FiringModeRequested;
var protected transient name CurrentIKControl;
var protected transient name CurrentIKRefBone;
var protected transient name CurrentSocket;
var protected transient float TimeInCurrentState;
var protected transient SkyWSMDrawnFlags DrawnState;
var protected transient float FiringDelayCountdown;
var(GenericTimeouts) protected SkyWSMTimeouts FiringDelays;
var protected transient float ReadyExpirationCountdown;
var(DrawnStateTimeouts) protected SkyWSMTimeouts ReadyExpirationTimeouts;
var protected transient float AutoHolsterCountdown;
var(DrawnStateTimeouts) protected SkyWSMTimeouts AutoHolsterTimeout;
var(TransitionTimeouts) protected SkyWSMTimeouts DrawingTimeouts;
var(TransitionTimeouts) protected SkyWSMTimeouts HolsteringTimeouts;
var(TransitionTimeouts) protected SkyWSMTimeouts AcquiringTimeouts;
var(TransitionTimeouts) protected SkyWSMTimeouts DiscardingTimeouts;
var(TransitionTimeouts) protected SkyWSMTimeouts SwitchingHandsTimeouts;
var(TransitionTimeouts) protected SkyWSMTimeouts SwappingTimeouts;
var protected transient bool TargetingRequested;
var protected transient bool ZoomingRequested;
var protected transient bool FiringRequested;
var protected transient bool PersistantFireRequested;
var transient bool bSwapOccurred;
var transient bool bLastSwapFinished;
var transient bool bAllowAcquireTimouts;
var protected const Color DebugColor;
var protected const name DebugName;

// Export USkyWeaponStateMachine::execGetState(FFrame&, void* const)
native function SkyWeaponStateMachine.ESkyWeaponState GetState();

// Export USkyWeaponStateMachine::execChangeState(FFrame&, void* const)
native function ChangeState(SkyWeaponStateMachine.ESkyWeaponState NewState);

// Export USkyWeaponStateMachine::execSetReloadState(FFrame&, void* const)
native function SetReloadState(SkyWeaponStateMachine.EReloadState NewState);

// Export USkyWeaponStateMachine::execAttachWeaponToPawn(FFrame&, void* const)
native function AttachWeaponToPawn();

// Export USkyWeaponStateMachine::execInit(FFrame&, void* const)
native function Init(bool Drawn);

// Export USkyWeaponStateMachine::execTargetingInput(FFrame&, void* const)
native function TargetingInput(bool Pressed);

// Export USkyWeaponStateMachine::execZoomingInput(FFrame&, void* const)
native function ZoomingInput(bool Pressed);

// Export USkyWeaponStateMachine::execFiringInput(FFrame&, void* const)
native function FiringInput(bool Pressed, optional byte FireModeNum, optional bool Persistant);

// Export USkyWeaponStateMachine::execTryDraw(FFrame&, void* const)
native function TryDraw(optional bool Immediately);

// Export USkyWeaponStateMachine::execTryHolster(FFrame&, void* const)
native function TryHolster(optional bool Immediately);

// Export USkyWeaponStateMachine::execTrySwap(FFrame&, void* const)
native function TrySwap(optional bool Immediately);

// Export USkyWeaponStateMachine::execHolster(FFrame&, void* const)
protected native function Holster(optional bool Immediately);

// Export USkyWeaponStateMachine::execDraw(FFrame&, void* const)
protected native function Draw(optional bool Immediately);

// Export USkyWeaponStateMachine::execSwap(FFrame&, void* const)
protected native function Swap();

// Export USkyWeaponStateMachine::execAcquire(FFrame&, void* const)
native function Acquire(bool bTimeout);

// Export USkyWeaponStateMachine::execDiscard(FFrame&, void* const)
native function Discard();

// Export USkyWeaponStateMachine::execAcquisitionComplete(FFrame&, void* const)
native function AcquisitionComplete();

// Export USkyWeaponStateMachine::execResetAutoHolsterTimer(FFrame&, void* const)
native function ResetAutoHolsterTimer();

// Export USkyWeaponStateMachine::execIsTargeting(FFrame&, void* const)
native function bool IsTargeting();

// Export USkyWeaponStateMachine::execHasTargetingBeenRequested(FFrame&, void* const)
native function bool HasTargetingBeenRequested();

// Export USkyWeaponStateMachine::execIsFiring(FFrame&, void* const)
native function bool IsFiring();

// Export USkyWeaponStateMachine::execIsFiringDelayed(FFrame&, void* const)
native function bool IsFiringDelayed();

// Export USkyWeaponStateMachine::execIsAttemptingFire(FFrame&, void* const)
native function bool IsAttemptingFire();

// Export USkyWeaponStateMachine::execIsReady(FFrame&, void* const)
native function bool IsReady();

// Export USkyWeaponStateMachine::execIsZooming(FFrame&, void* const)
native function bool IsZooming();

// Export USkyWeaponStateMachine::execIsReloading(FFrame&, void* const)
native function bool IsReloading();

// Export USkyWeaponStateMachine::execIsTransitioning(FFrame&, void* const)
native function bool IsTransitioning();

// Export USkyWeaponStateMachine::execIsBeingUsed(FFrame&, void* const)
native function bool IsBeingUsed();

// Export USkyWeaponStateMachine::execIsUnarmed(FFrame&, void* const)
native function bool IsUnarmed();

// Export USkyWeaponStateMachine::execIsSwapping(FFrame&, void* const)
native function bool IsSwapping();

// Export USkyWeaponStateMachine::execIsAcquiring(FFrame&, void* const)
native function bool IsAcquiring();

// Export USkyWeaponStateMachine::execStartReload(FFrame&, void* const)
native function StartReload(optional bool Short);

// Export USkyWeaponStateMachine::execStopReload(FFrame&, void* const)
native function StopReload();

// Export USkyWeaponStateMachine::execGetReloadState(FFrame&, void* const)
native function SkyWeaponStateMachine.EReloadState GetReloadState();

// Export USkyWeaponStateMachine::execAllowAttachmentNotifies(FFrame&, void* const)
native function bool AllowAttachmentNotifies();

// Export USkyWeaponStateMachine::execAllowingManualTransitions(FFrame&, void* const)
native function bool AllowingManualTransitions();

event SetOwner(SkyPawn NewOwner)
{
    Owner = NewOwner;
    //return;    
}

function DisplayDebug(Canvas Canvas, float YL, out float out_YPos)
{
    Canvas.SetDrawColor(DebugColor.R, DebugColor.G, DebugColor.B, DebugColor.A);
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.DrawText((string(DebugName) $ ": ") $ string(State));
    out_YPos += YL;
    Canvas.SetPos(4.0000000, out_YPos);
    // End:0x377
    if(int(State) == int(3))
    {
        Canvas.DrawText("{");
        out_YPos += YL;
        Canvas.SetPos(4.0000000, out_YPos);
        // End:0x164
        if(DrawnState.Targeting)
        {
            Canvas.DrawText("    Targeting");
            out_YPos += YL;
            Canvas.SetPos(4.0000000, out_YPos);
        }
        // End:0x1C1
        if(DrawnState.Firing)
        {
            Canvas.DrawText("    Firing");
            out_YPos += YL;
            Canvas.SetPos(4.0000000, out_YPos);            
        }
        else
        {
            // End:0x21F
            if(FiringRequested)
            {
                Canvas.DrawText("    FiringDelay " $ string(FiringDelayCountdown));
                out_YPos += YL;
                Canvas.SetPos(4.0000000, out_YPos);
            }
        }
        // End:0x282
        if(DrawnState.Ready)
        {
            Canvas.DrawText("    Ready " $ string(ReadyExpirationCountdown));
            out_YPos += YL;
            Canvas.SetPos(4.0000000, out_YPos);
        }
        // End:0x2DD
        if(DrawnState.Zooming)
        {
            Canvas.DrawText("    Zooming");
            out_YPos += YL;
            Canvas.SetPos(4.0000000, out_YPos);
        }
        // End:0x33A
        if(DrawnState.Reloading)
        {
            Canvas.DrawText("    Reloading");
            out_YPos += YL;
            Canvas.SetPos(4.0000000, out_YPos);
        }
        Canvas.DrawText("}");
        out_YPos += YL;
        Canvas.SetPos(4.0000000, out_YPos);
    }
    Canvas.DrawText("TargetingRequested: " $ string(TargetingRequested));
    out_YPos += YL;
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.DrawText("ZoomingRequested: " $ string(ZoomingRequested));
    out_YPos += YL;
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.DrawText("FiringRequested: " $ string(FiringRequested));
    out_YPos += YL;
    Canvas.SetPos(4.0000000, out_YPos);
    //return;    
}
