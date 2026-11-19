class SkyAITurret extends SkyAIController
    native
    config(AI);

struct native TurretSkelControlMapping
{
    var() name SkelControlName;
    var transient SkySkelControl_TurretConstrained SkelControl;

    structdefaultproperties
    {
        SkelControlName="None"
        SkelControl=none
    }
};

struct native ThreatMapNode
{
    var transient Actor Actor;
    var transient float ThreatRating;

    structdefaultproperties
    {
        Actor=none
        ThreatRating=0.0000000
    }
};

var(BurstFire) float MinTimeBetweenFiringBursts;
var(BurstFire) float MaxTimeBetweenFiringBursts;
var(BurstFire) editconst float AbsTimeBetweenFiringBursts;
var(BurstFire) float MinDurationOfFiringBurst;
var(BurstFire) float MaxDurationOfFiringBurst;
var(BurstFire) editconst float AbsMinDurationOfFiringBurst;
var(Targeting) array<TurretSkelControlMapping> TurretSkelControls;
var(Targeting) float MaxTargetDistance;
var(Targeting) float FOV_Yaw;
var(Targeting) float MaxPitchUp;
var(Targeting) float MaxPitchDown;
var private transient float Sin_MaxPitchUp;
var private transient float Sin_MaxPitchDown;
var private transient float Cos_FOV_Yaw;
var(Targeting) array< class<Controller> > ValidTargetTypes;
var(Targeting) name TurretBarrelSocketName;
var(Targeting) bool bDontUseBaseRotation;
var transient bool bLockedEnemy;
var protected transient bool bForceFocalPoint;
var(Targeting) float AimAheadSeconds;
var(Team) int TurretTeam;
var(Targeting) float MinTargetEvalPeriod;
var(Targeting) float MaxTargetEvalPeriod;
var(Targeting) editconst float AbsMinTargetEvalPeriod;
var(Targeting) float AimErrorDegrees;
var(Targeting) float MinWaitTimeAfterLosingTarget;
var(Targeting) float MaxWaitTimeAfterLosingTarget;
var(Targeting) editconst float AbsMinWaitTimeAfterLosingTarget;
var(Targeting) float MinTargetLostEvalPeriod;
var(Targeting) float MaxTargetLostEvalPeriod;
var(Targeting) editconst float AbsTargetLostEvalTarget;
var(Targeting) int MaxPeriodsOutOfLineOfSight;
var transient int PeriodsOutOfLineOfSight;
var transient Actor LockedEnemy;
var transient Actor LostTarget;
var protected transient SkyBotControllerBase.EBurstFireState BurstFireState;

// Export USkyAITurret::execGetTeamNum(FFrame&, void* const)
native simulated function byte GetTeamNum();

// Export USkyAITurret::execIsAThreat(FFrame&, void* const)
native final function bool IsAThreat(Actor Target);

// Export USkyAITurret::execRateThreat(FFrame&, void* const)
native final function float RateThreat(Actor Target);

// Export USkyAITurret::execIsInLineOfSight(FFrame&, void* const)
native final function bool IsInLineOfSight(Actor Target);

// Export USkyAITurret::execIsInFieldOfView(FFrame&, void* const)
native final function bool IsInFieldOfView(Actor Target);

// Export USkyAITurret::execGetGreatestThreat(FFrame&, void* const)
native final function Actor GetGreatestThreat(optional bool bCheckLineOfSight);

// Export USkyAITurret::execQueueForEvaluation(FFrame&, void* const)
protected native final function QueueForEvaluation();

event ReadyForEvaluation()
{
    //return;    
}

function PostBeginPlay()
{
    local float Clamped_MaxPitchUp, Clamped_MaxPitchDown, Clamped_FOV_Yaw, DegreesToRadians;

    super.PostBeginPlay();
    Clamped_MaxPitchUp = FClamp(MaxPitchUp, 0.0000000, 89.0000000);
    Clamped_MaxPitchDown = FClamp(MaxPitchDown, 0.0000000, 89.0000000);
    Clamped_FOV_Yaw = FClamp(FOV_Yaw, 0.0000000, 360.0000000);
    DegreesToRadians = 3.1415930 / 180.0000000;
    Sin_MaxPitchUp = Sin(DegreesToRadians * Clamped_MaxPitchUp);
    Sin_MaxPitchDown = Sin(DegreesToRadians * Clamped_MaxPitchDown);
    Cos_FOV_Yaw = Cos(DegreesToRadians * (Clamped_FOV_Yaw / 2.0000000));
    //return;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local Vector ScreenLoc, FocusLoc, ToBotVect;

    ToBotVect = Normal(Pawn.Location - HUD.PlayerOwner.PlayerCamera.Location);
    // End:0x74
    if((ToBotVect Dot Vector(HUD.PlayerOwner.PlayerCamera.Rotation)) < 0.7500000)
    {
        return;
    }
    HUD.Canvas.SetPos(4.0000000, out_YPos);
    HUD.Canvas.SetDrawColor(255, 255, 255);
    // End:0x18A
    if(Focus != none)
    {
        FocusLoc = HUD.Canvas.Project(Focus.Location);
        HUD.Canvas.SetPos(FocusLoc.X, FocusLoc.Y);
        HUD.Canvas.DrawText(string(Focus.Name), false);
        DrawDebugLine(Pawn.Location, Focus.Location, 255, 255, 0);        
    }
    else
    {
        FocusLoc = HUD.Canvas.Project(GetFocalPoint());
        HUD.Canvas.SetPos(FocusLoc.X, FocusLoc.Y);
        HUD.Canvas.DrawText("Focus Point", false);
        DrawDebugLine(Pawn.Location, GetFocalPoint(), 0, 255, 255);
    }
    ScreenLoc = HUD.Canvas.Project(Pawn.Location);
    ScreenLoc.X += float(50);
    HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
    HUD.Canvas.DrawText(((("Pawn:" @ string(Pawn.Name)) @ "(Team:") @ string(GetTeamNum())) @ ")", false);
    ScreenLoc.Y += out_YL;
    HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
    HUD.Canvas.DrawText("Controller:" @ string(Name), false);
    ScreenLoc.Y += out_YL;
    HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
    HUD.Canvas.DrawText("CurrentState:" @ string(GetStateName()), false);
    ScreenLoc.Y += out_YL;
    HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
    HUD.Canvas.DrawText("BurstFireState:" @ string(GetEnum(Enum'SkyBotControllerBase.EBurstFireState', int(BurstFireState))), false);
    ScreenLoc.Y += out_YL;
    HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
    HUD.Canvas.DrawText("Focus:" @ string(Focus), false);
    // End:0x5F3
    if((Pawn.GangName != 'None') && HUD.ShouldDisplayDebug('Gangs'))
    {
        ScreenLoc.Y += out_YL;
        HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
        HUD.Canvas.DrawText("Gang:" @ string(Pawn.GangName), false);
    }
    //return;    
}

event SetTeam(int inTeamIdx)
{
    TurretTeam = inTeamIdx;
    //return;    
}

function Possess(Pawn aPawn, bool bVehicleTransition)
{
    local int ControlIdx;

    super.Possess(aPawn, bVehicleTransition);
    // End:0xF1
    if((aPawn != none) && aPawn.Mesh != none)
    {
        ControlIdx = 0;
        J0x3A:

        // End:0xF1 [Loop If]
        if(ControlIdx < TurretSkelControls.Length)
        {
            TurretSkelControls[ControlIdx].SkelControl = SkySkelControl_TurretConstrained(aPawn.Mesh.FindSkelControl(TurretSkelControls[ControlIdx].SkelControlName));
            // End:0xB5
            if(TurretSkelControls[ControlIdx].SkelControl == none)
            {
                // [Explicit Continue]
                goto J0xE7;
            }
            // End:0xE7
            if(FOV_Yaw < 360.0000000)
            {
                TurretSkelControls[ControlIdx].SkelControl.bDoNotRotatePast180DegreesYaw = true;
            }
            J0xE7:

            ++ControlIdx;
            // [Loop Continue]
            goto J0x3A;
        }
    }
    SetTeam(TurretTeam);
    //return;    
}

event UnPossess()
{
    local int ControlIdx;

    // End:0x93
    if((Pawn != none) && Pawn.Mesh != none)
    {
        ControlIdx = 0;
        J0x29:

        // End:0x93 [Loop If]
        if(ControlIdx < TurretSkelControls.Length)
        {
            // End:0x89
            if((TurretSkelControls[ControlIdx].SkelControl != none) && FOV_Yaw < 360.0000000)
            {
                TurretSkelControls[ControlIdx].SkelControl.bDoNotRotatePast180DegreesYaw = false;
            }
            ++ControlIdx;
            // [Loop Continue]
            goto J0x29;
        }
    }
    super.UnPossess();
    //return;    
}

simulated function HandleEnemySwitchedPawn(Pawn OldPawn, Pawn NewPawn)
{
    // End:0x46
    if(Focus == OldPawn)
    {
        Focus = NewPawn;
        // End:0x46
        if((bLockedEnemy == true) && LockedEnemy == OldPawn)
        {
            LockEnemy(NewPawn);
        }
    }
    super.HandleEnemySwitchedPawn(OldPawn, NewPawn);
    //return;    
}

function OnAIFreeze(SkySeqAct_AIFreeze FreezeAction)
{
    // End:0x31
    if(FreezeAction.InputLinks[0].bHasImpulse)
    {
        GotoState('Frozen');        
    }
    else
    {
        FreezeAction.ScriptLog(string(self) @ "received unfreeze request while not frozen");
    }
    //return;    
}

event Freeze(bool bFreeze)
{
    // DebugMode: 0
    assert(bFreeze == !IsInState('Frozen'));
    // End:0x35
    if(bFreeze)
    {
        GotoState('Frozen');        
    }
    else
    {
        GotoState('Start_State');
    }
    //return;    
}

protected function BurstFireReady()
{
    BurstFireState = 0;
    // End:0x1C
    if(!FireWeaponAt(Focus))
    {
    }
    //return;    
}

protected function BurstFireEnd()
{
    local float pauseDuration;
    local SkyGame GameInfo;

    pauseDuration = Lerp(MinTimeBetweenFiringBursts, MaxTimeBetweenFiringBursts, FRand());
    SetTimer(pauseDuration, false, 'BurstFireReady');
    BurstFireState = 2;
    GameInfo = SkyGame(WorldInfo.Game);
    // End:0x65
    if(GameInfo != none)
    {
        GameInfo.ReleaseFirePermit(self);
    }
    StopFiring();
    //return;    
}

protected function bool FireWeaponAtHelper(Actor TargetActor)
{
    local bool bFireSuccess;

    // End:0x38
    if(!Pawn.IsFiring())
    {
        bFireSuccess = Pawn.BotFire(false);        
    }
    else
    {
        // End:0x69
        if(!TargetActor.bDeleteMe)
        {
            bFireSuccess = Pawn.BotFire(false);
        }
    }
    return bFireSuccess;
    //return ReturnValue;    
}

function bool FireWeaponAt(Actor TargetActor)
{
    local bool Success;
    local float burstDuration;
    local SkyGame GameInfo;

    GameInfo = SkyGame(WorldInfo.Game);
    // End:0x177
    if(CheckFirePermit(TargetActor))
    {
        // End:0x4A
        if(TargetActor == none)
        {
            GameInfo.ReleaseFirePermit(self);
            return false;
        }
        // End:0x7A
        if((bLockedEnemy == true) && TargetActor != LockedEnemy)
        {
            GameInfo.ReleaseFirePermit(self);
            return false;
        }
        // End:0x170
        if((int(BurstFireState) == int(0)) || int(BurstFireState) == int(1))
        {
            // End:0xEB
            if(int(BurstFireState) == int(0))
            {
                burstDuration = Lerp(MinDurationOfFiringBurst, MaxDurationOfFiringBurst, FRand());
                SetTimer(burstDuration, false, 'BurstFireEnd');
                BurstFireState = 1;
                ClearTimer('BurstFireReady');
            }
            Success = FireWeaponAtHelper(TargetActor);
            // End:0x140
            if(!Success)
            {
                GameInfo.ReleaseFirePermit(self);
                ClearTimer('BurstFireEnd');
                SetTimer(0.5000000, false, 'BurstFireReady');
            }
            // End:0x170
            if(Success && SkyPawn(TargetActor) != none)
            {
                SkyPawn(TargetActor).FiredUpon();
            }
        }
        return Success;
    }
    return false;
    //return ReturnValue;    
}

final function bool IsFiring()
{
    return (Pawn.IsFiring() || IsTimerActive('BurstFireReady')) || IsTimerActive('BurstFireEnd');
    //return ReturnValue;    
}

final function StopAllFiring()
{
    ClearTimer('BurstFireReady');
    ClearTimer('BurstFireEnd');
    BurstFireState = 0;
    StopFiring();
    //return;    
}

final function bool TargetIsInRange(Actor Target)
{
    return VSizeSq(Target.GetTargetLocation(self) - Pawn.Location) <= Square(MaxTargetDistance);
    //return ReturnValue;    
}

final function bool TargetIsUnderReticle(Actor Target)
{
    local Vector BarrelLoc;
    local Rotator BarrelRot;
    local Vector ToTarget;

    // End:0x8C
    if(Pawn.Mesh != none)
    {
        Pawn.Mesh.GetSocketWorldLocationAndRotation(TurretBarrelSocketName, BarrelLoc, BarrelRot);
        ToTarget = Normal(Focus.GetTargetLocation(self) - BarrelLoc);
        return (Vector(BarrelRot) Dot ToTarget) >= Cos(AimErrorDegrees * (3.1415930 / 180.0000000));        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

simulated function LockEnemy(Actor newEnemy)
{
    // End:0x6D
    if(((Pawn(newEnemy) != none) && Pawn(newEnemy).DrivenVehicle != none) && Pawn(newEnemy).DrivenVehicle.bDriving == true)
    {
        newEnemy = Pawn(newEnemy).DrivenVehicle;
    }
    Enemy = newEnemy;
    bLockedEnemy = true;
    LockedEnemy = newEnemy;
    Focus = newEnemy;
    //return;    
}

simulated function ClearLockedEnemy()
{
    Enemy = none;
    bLockedEnemy = false;
    LockedEnemy = none;
    Focus = none;
    //return;    
}

event SetTeamNum(byte T)
{
    SetTeam(int(T));
    super(Actor).SetTeamNum(T);
    //return;    
}

auto state Start_State
{Begin:

    // End:0x19
    if(Pawn != none)
    {
        GotoState('Idle');
    }
    Sleep(1.0000000 + FRand());
    goto 'Begin';
    stop;                    
}

state Idle
{
    function BeginState(name PrevStateName)
    {
        super(Object).BeginState(PrevStateName);
        SetFocalPoint(Pawn.Location + (Vector(Pawn.Rotation) * 10000.0000000));
        SetTimer(RandRange(MinTargetEvalPeriod, MaxTargetEvalPeriod), true, 'QueueForEvaluation');
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('QueueForEvaluation');
        super(Object).EndState(NextStateName);
        //return;        
    }

    event ReadyForEvaluation()
    {
        FindTarget();
        //return;        
    }

    function FindTarget()
    {
        Focus = GetGreatestThreat(true);
        // End:0x26
        if(Focus != none)
        {
            GotoState('Targeting');
        }
        //return;        
    }
    stop;    
}

state Targeting
{
    function BeginState(name PrevStateName)
    {
        // End:0x2F
        if(TargetIsUnderReticle(Focus) && TargetIsInRange(Focus))
        {
            GotoState('Firing');            
        }
        else
        {
            SetTimer(RandRange(MinTargetEvalPeriod, MaxTargetEvalPeriod), true, 'QueueForEvaluation');
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('QueueForEvaluation');
        PeriodsOutOfLineOfSight = 0;
        super(Object).EndState(NextStateName);
        //return;        
    }

    event ReadyForEvaluation()
    {
        ReevaluateTarget();
        //return;        
    }

    function ReevaluateTarget()
    {
        local Actor Threat, PrevFocus;

        Threat = GetGreatestThreat();
        // End:0x52
        if(Threat == Focus)
        {
            // End:0x4F
            if(!IsInLineOfSight(Focus))
            {
                // End:0x4F
                if(++PeriodsOutOfLineOfSight > MaxPeriodsOutOfLineOfSight)
                {
                    PrevFocus = Focus;
                    Focus = none;
                }
            }            
        }
        else
        {
            // End:0x6E
            if(IsInLineOfSight(Threat))
            {
                Focus = Threat;                
            }
            else
            {
                Focus = GetGreatestThreat(true);
            }
        }
        // End:0xA2
        if(Focus == none)
        {
            LostTarget = PrevFocus;
            GotoState('TargetLost');            
        }
        else
        {
            // End:0xCE
            if(TargetIsUnderReticle(Focus) && TargetIsInRange(Focus))
            {
                GotoState('Firing');
            }
        }
        //return;        
    }
    stop;    
}

state TargetLost
{
    function BeginState(name PrevStateName)
    {
        super(Object).BeginState(PrevStateName);
        bForceFocalPoint = true;
        SetTimer(RandRange(MinWaitTimeAfterLosingTarget, MaxWaitTimeAfterLosingTarget), false, 'TimeOut');
        SetTimer(RandRange(MinTargetLostEvalPeriod, MaxTargetLostEvalPeriod), true, 'QueueForEvaluation');
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('TimeOut');
        ClearTimer('QueueForEvaluation');
        bForceFocalPoint = false;
        super(Object).EndState(NextStateName);
        //return;        
    }

    event ReadyForEvaluation()
    {
        ReevaluateTarget();
        //return;        
    }

    function ReevaluateTarget()
    {
        // End:0x47
        if(((LostTarget != none) && IsInLineOfSight(LostTarget)) && LostTarget == GetGreatestThreat())
        {
            Focus = LostTarget;
            GotoState('Firing');
        }
        //return;        
    }

    function TimeOut()
    {
        Focus = GetGreatestThreat(true);
        // End:0x29
        if(Focus != none)
        {
            GotoState('Targeting');            
        }
        else
        {
            GotoState('Idle');
        }
        //return;        
    }
    stop;    
}

state Firing
{
    function BeginState(name PrevStateName)
    {
        super(Object).BeginState(PrevStateName);
        FireWeaponAt(Focus);
        SetTimer(RandRange(MinTargetEvalPeriod, MaxTargetEvalPeriod), true, 'QueueForEvaluation');
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('QueueForEvaluation');
        PeriodsOutOfLineOfSight = 0;
        StopAllFiring();
        super(Object).EndState(NextStateName);
        //return;        
    }

    event ReadyForEvaluation()
    {
        ReevaluateTarget();
        //return;        
    }

    function ReevaluateTarget()
    {
        local Actor Threat, PrevFocus;

        Threat = GetGreatestThreat();
        // End:0x52
        if(Threat == Focus)
        {
            // End:0x4F
            if(!IsInLineOfSight(Focus))
            {
                // End:0x4F
                if(++PeriodsOutOfLineOfSight > MaxPeriodsOutOfLineOfSight)
                {
                    PrevFocus = Focus;
                    Focus = none;
                }
            }            
        }
        else
        {
            Focus = GetGreatestThreat(true);
        }
        // End:0x86
        if(Focus == none)
        {
            LostTarget = PrevFocus;
            GotoState('TargetLost');            
        }
        else
        {
            // End:0xB9
            if(!TargetIsUnderReticle(Focus) || !TargetIsInRange(Focus))
            {
                GotoState('Targeting');                
            }
            else
            {
                FireWeaponAt(Focus);
            }
        }
        //return;        
    }
    stop;    
}

state Frozen
{
    function BeginState(name PrevStateName)
    {
        super(Object).BeginState(PrevStateName);
        bForceFocalPoint = true;
        //return;        
    }

    function EndState(name NextStateName)
    {
        bForceFocalPoint = false;
        super(Object).EndState(NextStateName);
        //return;        
    }

    function OnAIFreeze(SkySeqAct_AIFreeze FreezeAction)
    {
        // End:0x31
        if(FreezeAction.InputLinks[1].bHasImpulse)
        {
            GotoState('Start_State');            
        }
        else
        {
            FreezeAction.ScriptLog(string(self) @ "- Received a freeze request while already frozen!");
        }
        //return;        
    }
    stop;    
}
