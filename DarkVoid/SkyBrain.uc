class SkyBrain extends Actor
    native
    notplaceable;

var transient SkyBot OwnerController;
var transient SightMemory EnemySighting;
var transient float CurrentSightingThreshold;
var transient Vector InvestigateLocation;
var transient NavigationPoint InvestigateAnchor;
var transient int InvestigateID;
var transient float InvestigateDisturbanceTime;
var transient SkyMemory.DisturbanceType InvestigationType;
var transient float CoverHideStartingHealth;
var transient float CoverHideTimeout;
var transient CoverInfo BetterCover;
var transient bool bScriptedCoverShouldShoot;
var transient bool bScriptedCoverShootTargetLocked;
var transient Actor Evade_DangerObject;
var transient int BrainFreezeRefCount;
var() float Passive_EnemySighting;
var() float Agitated_EnemySighting;
var() float Agitated_InvestigateDistance;
var() float Shooting_EnemySighting;
var() float Raging_ChaseEnemyDistance;
var() float Cover_SwatTurnTimeout;
var() float Cover_SwatTurnProbability;
var transient float Cover_SwatTurnTimer;
var() float SeekingCover_ChaseDistanceWhenNoCover;
var() float SeekingCover_MinCoverDistanceFromEnemy;
var() float SeekingCover_MaxCoverDistanceFromEnemy;
var() float HideInCover_DamageThreshold;
var() float HideInCover_MinHidingTime;
var() float HideInCover_MaxHidingTime;
var() float InCover_WaitToSeeEnemyTimeout;
var() float InCover_FlushOutEnemyTimeout;
var() float Vertical_MinCoverDistanceFromMe;
var() float Vertical_MaxCoverDistanceFromMe;
var() float Vertical_MinDistFromEnemy;
var() float Vertical_MaxDistFromEnemy;
var() float Vertical_WaitToSeeEnemyTimeout;
var() float Vertical_FallbackToMinDistFromEnemyTimeout;
var() float Vertical_ApproachToMaxDistFromEnemyTimeout;
var() float Vertical_DesiredCoverConeAngle;
var transient float Vertical_FallbackTimer;
var transient float Vertical_ApproachTimer;
var() float PostHunt_MinCombatTimeBeforeCover;
var() float PostHunt_MaxCombatTimeBeforeCover;
var() float PostHunt_MinStrafeDistance;
var() float PostHunt_MaxStrafeDistance;
var transient float PostHunt_Timer;
var() float Dodge_DamageAmount;
var() float Dodge_DamageTime;
var() float Dodge_Probability;
var transient float Dodge_PreviousHealth;
var() float Evade_UseEvadeAnimationProbability;
var transient float InteractionCheckTime;
var(Melee) float MeleeWaitTimeMin;
var(Melee) float MeleeWaitTimeMax;
var(Melee) float MeleeChance;
var(Personality) float FleeHealthPercent;
var(Personality) float RageHealthPercent;
var(Avoidance) float AvoidanceRadius;

function PostBeginPlay()
{
    local float SetAngle;

    super.PostBeginPlay();
    CurrentSightingThreshold = Passive_EnemySighting;
    SetTimer(0.5000000, true, 'CurrentEnemyUpkeep');
    SetTimer(1.0000000, true, 'TryTaunt');
    SetTimer(0.5000000, true, 'DangerEvade');
    // End:0x8B
    if(Vertical_DesiredCoverConeAngle > 0.0000000)
    {
        SetAngle = FClamp(Vertical_DesiredCoverConeAngle, 0.0000000, 180.0000000);
        Vertical_DesiredCoverConeAngle = Cos((3.1415930 * SetAngle) / 360.0000000);
    }
    Dodge_PreviousHealth = 0.0000000;
    // End:0xB8
    if(Dodge_DamageTime > 0.0000000)
    {
        SetTimer(Dodge_DamageTime, true, 'DodgeEvaluate');
    }
    // End:0xEC
    if(InteractionCheckTime > 0.0000000)
    {
        SetTimer(InteractionCheckTime + ((FRand() * 0.0500000) * InteractionCheckTime), false, 'InteractionEvaluate');
    }
    // End:0x10E
    if(AvoidanceRadius > 0.0000000)
    {
        SetTimer(1.0000000, true, 'AvoidanceEvaluate');
    }
    //return;    
}

function TryTaunt()
{
    //return;    
}

function BrainDead()
{
    SetMood(0);
    GotoState('BrainDeath');
    //return;    
}

function BrainFreeze(bool bActivate)
{
    // End:0x2E
    if(bActivate)
    {
        // End:0x24
        if(BrainFreezeRefCount == 0)
        {
            PushState('BrainFrozen');
        }
        BrainFreezeRefCount++;        
    }
    else
    {
        // End:0x4F
        if(!IsInState('BrainFrozen') || BrainFreezeRefCount <= 0)
        {
            return;
        }
        BrainFreezeRefCount--;
        // End:0x68
        if(BrainFreezeRefCount == 0)
        {
            PopState();
        }
    }
    //return;    
}

function bool OnAIUseCover(SkySeqAct_AIUseCover Action)
{
    local CoverInfo ClaimThisCover;
    local Pawn CoverFocus;
    local SeqVar_Object ObjVar;

    // End:0x0D
    if(BrainFreezeRefCount > 0)
    {
        return false;
    }
    // End:0x193
    if(((Action.TargetCoverLink != none) && Action.TargetSlotIdx >= 0) && Action.TargetSlotIdx < Action.TargetCoverLink.Slots.Length)
    {
        ClaimThisCover.Link = Action.TargetCoverLink;
        ClaimThisCover.SlotIdx = Action.TargetSlotIdx;
        // End:0xC5
        if(!OwnerController.ClaimCover(ClaimThisCover))
        {
            return false;
        }
        CoverFocus = none;
        // End:0x125
        foreach Action.LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Engage Enemy")
        {
            CoverFocus = Pawn(ObjVar.GetObjectValue());
            // End:0x124
            if(CoverFocus != none)
            {
                // End:0x125
                break;
            }            
        }        
        // End:0x151
        if(CoverFocus != none)
        {
            OwnerController.CurrentEnemy = CoverFocus;
            bScriptedCoverShootTargetLocked = true;            
        }
        else
        {
            bScriptedCoverShootTargetLocked = false;
        }
        bScriptedCoverShouldShoot = Action.bEnableShooting;
        // End:0x190
        if(!IsInState('ScriptedCover'))
        {
            GotoState('ScriptedCover');
        }        
    }
    else
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function RenderBestCover()
{
    local CoverInfo FoundCover;
    local CoverSlotMarker BestMarker;

    FlushPersistentDebugLines();
    // End:0x91
    if(OwnerController.FindCover(0, OwnerController.CurrentEnemy, FoundCover))
    {
        BestMarker = FoundCover.Link.Slots[FoundCover.SlotIdx].SlotMarker;
        DrawDebugSphere(BestMarker.Location, 32.0000000, 8, 255, 255, 255, true);        
    }
    else
    {
        DrawDebugSphere(GetPawnLocation(), 32.0000000, 8, 255, 0, 0, true);
    }
    //return;    
}

final function Vector GetPawnLocation()
{
    return OwnerController.Pawn.Location;
    //return ReturnValue;    
}

final function Rotator GetPawnRotation()
{
    return OwnerController.Pawn.Rotation;
    //return ReturnValue;    
}

final function float GetPawnRadius()
{
    return OwnerController.Pawn.GetCollisionRadius();
    //return ReturnValue;    
}

final function bool IsPawnFacing(Vector Point)
{
    local Vector ToPoint, myFacing;

    ToPoint = Point - OwnerController.Pawn.Location;
    ToPoint.Z = 0.0000000;
    myFacing = Vector(OwnerController.Rotation);
    myFacing.Z = 0.0000000;
    // End:0x9F
    if((VSizeSq(ToPoint) <= 0.1000000) || (Normal(myFacing) Dot Normal(ToPoint)) >= 0.8500000)
    {
        return true;        
    }
    else
    {
        OwnerController.LookAt(Point);
        return false;
    }
    //return ReturnValue;    
}

final function bool IsInCover()
{
    return OwnerController.super(SkyBrain).IsInCover();
    //return ReturnValue;    
}

final function float GetHealthPercent()
{
    return float(OwnerController.Pawn.Health) / float(Pawn(OwnerController.Pawn.ObjectArchetype).Health);
    //return ReturnValue;    
}

final function Vector GetLastKnownLocation(Pawn EnemyTest)
{
    return OwnerController.BotMemory.GetMemoryOf(EnemyTest).LastLocation;
    //return ReturnValue;    
}

final function Vector GetLastKnownMoveDirection(Pawn EnemyTest)
{
    return OwnerController.BotMemory.GetMemoryOf(EnemyTest).LastVelocity;
    //return ReturnValue;    
}

final function float GetEnemySeenDuration(Pawn EnemyTest)
{
    return OwnerController.BotMemory.GetMemoryOf(EnemyTest).SeenDuration;
    //return ReturnValue;    
}

final function SkyMemory.PawnStatus GetEnemyStatus(Pawn EnemyTest)
{
    return OwnerController.BotMemory.GetMemoryOf(EnemyTest).LastStatus;
    //return ReturnValue;    
}

final function int GetEnemyMemoryID(Pawn EnemyTest)
{
    return OwnerController.BotMemory.GetMemoryOf(EnemyTest).MemoryID;
    //return ReturnValue;    
}

final function bool IsEnemyCoverTargeting(Pawn EnemyTest)
{
    return ((SkyPawnCoverUser(EnemyTest) != none) && SkyPawnCoverUser(EnemyTest).IsInCover()) && SkyPawn(EnemyTest).PrimaryWSM.IsTargeting();
    //return ReturnValue;    
}

final function bool IsOnMyLevel(Pawn EnemyTest)
{
    local float deltaZ;

    deltaZ = EnemyTest.Location.Z - OwnerController.Pawn.Location.Z;
    return Abs(deltaZ) <= OwnerController.Pawn.CylinderComponent.CollisionHeight;
    //return ReturnValue;    
}

final function bool IsInDesiredCoverConeOf(Pawn EnemyTest)
{
    local Vector Delta;

    Delta = Normal(GetPawnLocation() - EnemyTest.Location);
    return Abs(Delta.Z) >= Vertical_DesiredCoverConeAngle;
    //return ReturnValue;    
}

final function SetMood(SkyPawn.EMood NewMood)
{
    // End:0x43
    if(SkyPawnGrunt(OwnerController.Pawn) != none)
    {
        SkyPawnGrunt(OwnerController.Pawn).SetMood(NewMood);
    }
    //return;    
}

// Export USkyBrain::execCanPrimaryWeaponFire(FFrame&, void* const)
native final function bool CanPrimaryWeaponFire();

function bool FindNewDisturbance()
{
    local int NewId;
    local Vector NewLocation;
    local float NewTime;
    local SkyMemory.DisturbanceType NewDisturbance;

    // End:0x12
    if(int(InvestigationType) == int(4))
    {
        return false;
    }
    NewDisturbance = OwnerController.BotMemory.GetMostRecentDisturbance(NewLocation, NewId, NewTime);
    // End:0xE0
    if(int(NewDisturbance) != int(0))
    {
        // End:0xE0
        if((InvestigateID == -1) || NewTime > InvestigateDisturbanceTime)
        {
            ForgetDisturbance();
            InvestigateID = NewId;
            InvestigateDisturbanceTime = NewTime;
            InvestigationType = NewDisturbance;
            // End:0xD3
            if(int(NewDisturbance) == int(4))
            {
                InvestigateLocation = GetPawnLocation() + (Normal(NewLocation - GetPawnLocation()) * 1000.0000000);                
            }
            else
            {
                InvestigateLocation = NewLocation;
            }
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool NeedMoveToDisturbance()
{
    return (InvestigateID > -1) && !OwnerController.InRange(InvestigateLocation, Agitated_InvestigateDistance);
    //return ReturnValue;    
}

function ForgetDisturbance()
{
    // End:0x2E
    if(InvestigateID > -1)
    {
        OwnerController.BotMemory.PurgeMemory(InvestigateID);
    }
    InvestigateID = -1;
    InvestigateAnchor = none;
    InvestigateLocation = vect(0.0000000, 0.0000000, 0.0000000);
    InvestigateDisturbanceTime = -1.0000000;
    InvestigationType = 0;
    //return;    
}

function bool CheckShouldRandomSwatTurn()
{
    // End:0xA5
    if(Cover_SwatTurnTimeout > 0.0000000)
    {
        // End:0x9A
        if(IsInCover() && OwnerController.CanSwatTurn())
        {
            // End:0x54
            if(Cover_SwatTurnTimer <= 0.0000000)
            {
                Cover_SwatTurnTimer = WorldInfo.TimeSeconds;                
            }
            else
            {
                // End:0x97
                if((WorldInfo.TimeSeconds - Cover_SwatTurnTimer) > Cover_SwatTurnTimeout)
                {
                    Cover_SwatTurnTimer = WorldInfo.TimeSeconds;
                    // End:0x97
                    if(FRand() < Cover_SwatTurnProbability)
                    {
                        return true;
                    }
                }
            }            
        }
        else
        {
            Cover_SwatTurnTimer = -1.0000000;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool ShouldFlee()
{
    // End:0x12
    if(GetHealthPercent() <= FleeHealthPercent)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool ShouldSeekCover()
{
    // End:0x12
    if(GetHealthPercent() > RageHealthPercent)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsInVerticalSpace(Actor TargetEnemy)
{
    local Pawn TargetPawn;

    // End:0x63
    if(((SkyPawnCoverUser(TargetEnemy) != none) && int(SkyPawnCoverUser(TargetEnemy).GetCoverState()) != int(0)) && int(SkyPawnCoverUser(TargetEnemy).CurrentLink.CoverOrientation) != int(0))
    {
        return true;
    }
    TargetPawn = Pawn(TargetEnemy);
    // End:0xD8
    if(TargetPawn != none)
    {
        // End:0xAC
        if((TargetPawn.Controller == none) || TargetPawn.Health <= 0)
        {
            return false;
        }
        // End:0xD8
        if((SkyPawn(TargetEnemy) != none) && SkyPawn(TargetEnemy).super(SkyBrain).IsInVerticalSpace())
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function CurrentEnemyUpkeep()
{
    // End:0x89
    if(((OwnerController.CurrentEnemy != none) && OwnerController.BotMemory.CanSee(OwnerController.CurrentEnemy, CurrentSightingThreshold, EnemySighting)) && int(EnemySighting.LastStatus) != int(0))
    {
        OwnerController.CurrentEnemy = none;
        GotoState('RealizedEnemyDied');
    }
    //return;    
}

function DangerEvade()
{
    // End:0x15
    if(OwnerController.IsDoingCoverManeuver())
    {
        return;
    }
    Evade_DangerObject = OwnerController.FindDangerObjectNearby(1000.0000000);
    // End:0x91
    if(Evade_DangerObject != none)
    {
        // End:0x91
        if((Projectile(Evade_DangerObject) != none) && OwnerController.InRange(Evade_DangerObject.Location, Projectile(Evade_DangerObject).DamageRadius))
        {
            GotoState('EvadingDanger');
        }
    }
    //return;    
}

function DodgeEvaluate()
{
    // End:0x79
    if(Dodge_PreviousHealth > 0.0000000)
    {
        // End:0x79
        if(!IsInCover() && !OwnerController.IsDoingCoverManeuver())
        {
            // End:0x79
            if((float(OwnerController.Pawn.Health) <= (Dodge_PreviousHealth - Dodge_DamageAmount)) && FRand() < Dodge_Probability)
            {
                GotoState('DodgingDamage');
            }
        }
    }
    Dodge_PreviousHealth = float(OwnerController.Pawn.Health);
    //return;    
}

function bool InteractionEvaluate()
{
    local bool bDidInteraction;

    bDidInteraction = false;
    // End:0x50
    if((OwnerController != none) && OwnerController.Pawn != none)
    {
        bDidInteraction = SkyPawn(OwnerController.Pawn).TryAnInteraction();
    }
    SetTimer(InteractionCheckTime + ((FRand() * 0.0500000) * InteractionCheckTime), false, 'InteractionEvaluate');
    return bDidInteraction;
    //return ReturnValue;    
}

function AvoidanceEvaluate()
{
    local Pawn AvoidPawn;

    // End:0xA9
    if(int(OwnerController.Pawn.Physics) == int(1))
    {
        // End:0xA8
        foreach OwnerController.Pawn.VisibleCollidingActors(Class'Engine.Pawn', AvoidPawn, AvoidanceRadius)
        {
            // End:0xA7
            if((int(AvoidPawn.Physics) == int(1)) && VSizeSq(AvoidPawn.Location - GetPawnLocation()) < Square(AvoidanceRadius))
            {
                GotoState('PerformingAvoidance');
                // End:0xA8
                break;
            }            
        }        
    }
    //return;    
}

state Root_Mindset
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        //return;        
    }

    function PushedState()
    {
        //return;        
    }

    function PoppedState()
    {
        //return;        
    }

    function ContinuedState()
    {
        //return;        
    }

    function PausedState()
    {
        //return;        
    }
    stop;    
}

state BrainDeath extends Root_Mindset
{Begin:

    OwnerController.StopAllFiring();
    OwnerController.StopTargeting();
    stop;                
}

state BrainFrozen extends Root_Mindset
{    stop;    
}

auto state Passive extends Root_Mindset
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0xBC
        if(OwnerController != none)
        {
            OwnerController.UnlockFocus();
            OwnerController.StopAllFiring();
            OwnerController.StopTargeting();
            OwnerController.Pawn.MaxDesiredSpeed = 0.5000000;
            // End:0x8D
            if(!OwnerController.IsScriptedMoving())
            {
                OwnerController.ResumePatrol();                
            }
            else
            {
                OwnerController.LookAt(GetPawnLocation() + (Vector(GetPawnRotation()) * 100000.0000000));
            }
            SetMood(1);
        }
        //return;        
    }

    function ContinuedState()
    {
        super.ContinuedState();
        OwnerController.Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        // End:0x55
        if(!OwnerController.IsScriptedMoving())
        {
            OwnerController.ResumePatrol();            
        }
        else
        {
            OwnerController.LookAt(GetPawnLocation() + (Vector(GetPawnRotation()) * 100000.0000000));
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        // End:0x23
        if(OwnerController.IsScriptedMoving())
        {
            OwnerController.AbortScriptedMove();
        }
        OwnerController.Pawn.MaxDesiredSpeed = Pawn(OwnerController.Pawn.ObjectArchetype).MaxDesiredSpeed;
        ForgetDisturbance();
        super.EndState(NextStateName);
        //return;        
    }

    function CurrentEnemyUpkeep()
    {
        local Pawn TestEnemy;
        local SightMemory TestSighting;

        TestEnemy = OwnerController.BotMemory.GetClosestEnemyBySight(GetPawnLocation(), TestSighting);
        // End:0x92
        if(((TestEnemy != none) && TestSighting.SeenDuration > CurrentSightingThreshold) && int(TestSighting.LastStatus) == int(0))
        {
            OwnerController.CurrentEnemy = TestEnemy;
            GotoState('FirstEngagingEnemy');
        }
        //return;        
    }
Begin:

    CurrentSightingThreshold = Passive_EnemySighting;
    // End:0xC1
    if(FindNewDisturbance())
    {
        SetMood(3);
        // End:0x43
        if(OwnerController.IsScriptedMoving())
        {
            OwnerController.AbortScriptedMove();
        }
        OwnerController.LookAt(InvestigateLocation);
        J0x58:

        // End:0x73 [Loop If]
        if(!IsPawnFacing(InvestigateLocation))
        {
            Sleep(0.1000000);
            // [Loop Continue]
            goto J0x58;
        }
        // End:0xB3
        if(int(InvestigationType) == int(1))
        {
            OwnerController.PlayReaction(5);
            J0x95:

            // End:0xB3 [Loop If]
            if(OwnerController.IsPlayingReaction())
            {
                Sleep(0.1000000);
                // [Loop Continue]
                goto J0x95;
            }
        }
        GotoState('Agitated');
    }
    Sleep(0.2500000);
    goto 'Begin';
    stop;                    
}

state FirstEngagingEnemy extends Root_Mindset
{Begin:

    SetMood(2);
    // End:0x23
    if(ShouldFlee())
    {
        GotoState('FreakedOut');
    }
    OwnerController.LockFocusOn(OwnerController.CurrentEnemy);
    Sleep(0.2500000);
    OwnerController.PlayReaction(1);
    J0x5C:

    // End:0x7A [Loop If]
    if(OwnerController.IsPlayingReaction())
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x5C;
    }
    GotoState('EvaluatingEnemy');
    stop;                
}

state StartledByEnemy extends Root_Mindset
{Begin:

    SetMood(2);
    OwnerController.PlayReaction(8);
    J0x1A:

    // End:0x38 [Loop If]
    if(OwnerController.IsPlayingReaction())
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x1A;
    }
    GotoState('EvaluatingEnemy');
    stop;        
}

state RealizedEnemyDied extends Root_Mindset
{Begin:

    SetMood(1);
    OwnerController.PlayReaction(3);
    J0x1A:

    // End:0x38 [Loop If]
    if(OwnerController.IsPlayingReaction())
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x1A;
    }
    OwnerController.CurrentEnemy = OwnerController.BotMemory.GetBiggestThreatEnemy(true);
    // End:0x87
    if(OwnerController.CurrentEnemy != none)
    {
        GotoState('EvaluatingEnemy');
    }
    OwnerController.BotMemory.PurgeMemoriesBefore(WorldInfo.TimeSeconds);
    GotoState('Passive');
    stop;        
}

state EvaluatingEnemy extends Root_Mindset
{Begin:

    // End:0x2D
    if(IsInVerticalSpace(OwnerController.CurrentEnemy))
    {
        GotoState('VerticalCombative');        
    }
    else
    {
        // End:0x4B
        if(ShouldFlee())
        {
            GotoState('FreakedOut');            
        }
        else
        {
            // End:0x69
            if(ShouldSeekCover())
            {
                GotoState('SeekingCover');                
            }
            else
            {
                GotoState('Raging');
            }
        }
    }
    stop;                    
}

state ScriptedCover extends Root_Mindset
{
    function EndState(name NextStateName)
    {
        // End:0x24
        if(OwnerController.IsMovingToGoal())
        {
            OwnerController.AbortMove();
        }
        // End:0x3D
        if(IsInCover())
        {
            OwnerController.ExitCover();
        }
        bScriptedCoverShouldShoot = false;
        bScriptedCoverShootTargetLocked = false;
        super.EndState(NextStateName);
        //return;        
    }

    function bool OnAIUseCover(SkySeqAct_AIUseCover Action)
    {
        GotoState('ScriptedCover', 'BailOnCover');
        return true;
        //return ReturnValue;        
    }
Begin:

    SetMood(2);
    // End:0x3C
    if(OwnerController.CurrentEnemy != none)
    {
        OwnerController.LockFocusOn(OwnerController.CurrentEnemy);
    }
MoveToCover:


    OwnerController.SetMoveGoal(OwnerController.GetClaimedCoverMarker());
    J0x60:

    // End:0xAA [Loop If]
    if(OwnerController.IsMovingToGoal())
    {
        // End:0x9F
        if(bScriptedCoverShouldShoot)
        {
            OwnerController.FireWeaponAt(OwnerController.CurrentEnemy);
        }
        Sleep(0.2500000);
        // [Loop Continue]
        goto J0x60;
    }
    // End:0xE4
    if(!OwnerController.HasReachedGoal())
    {
        OwnerController.ClearLatentAction(Class'SkySeqAct_AIUseCover', true);
        GotoState('Passive');
    }
    // End:0x152
    if(!IsInCover())
    {
        // End:0x122
        if(OwnerController.TakeCover())
        {
            J0x104:

            // End:0x122 [Loop If]
            if(OwnerController.IsEnteringCover())
            {
                Sleep(0.2500000);
                // [Loop Continue]
                goto J0x104;
            }
        }
        // End:0x152
        if(!IsInCover())
        {
            OwnerController.ClearLatentAction(Class'SkySeqAct_AIUseCover', true);
            GotoState('Passive');
        }
    }
    OwnerController.ClearLatentAction(Class'SkySeqAct_AIUseCover', false);
    OwnerController.LockFocusOn(OwnerController.CurrentEnemy);
InCover:


    // End:0x1AD
    if(!OwnerController.IsTargeting())
    {
        OwnerController.StartTargeting();
    }
    // End:0x2C7
    if(bScriptedCoverShouldShoot)
    {
        // End:0x1FF
        if(OwnerController.CurrentEnemy != none)
        {
            // End:0x1FF
            if(!OwnerController.IsBurstFiring())
            {
                OwnerController.StartBurstFiring(OwnerController.CurrentEnemy);
            }
        }
        // End:0x2C7
        if(!bScriptedCoverShootTargetLocked)
        {
            // End:0x2C7
            if(!OwnerController.BotMemory.CanSee(OwnerController.CurrentEnemy, 0.0000000, EnemySighting) || OwnerController.CurrentEnemy.Health <= 0)
            {
                OwnerController.CurrentEnemy = OwnerController.BotMemory.GetBiggestThreatEnemy(false);
                // End:0x2C7
                if(OwnerController.CurrentEnemy != OwnerController.GetFireTarget())
                {
                    OwnerController.StopAllFiring();
                }
            }
        }
    }
    Sleep(0.2500000);
    goto 'InCover';
BailOnCover:


    OwnerController.StopTargeting();
    OwnerController.StopAllFiring();
    OwnerController.ExitCover();
    J0x309:

    // End:0x327 [Loop If]
    if(OwnerController.IsExitingCover())
    {
        Sleep(0.2500000);
        // [Loop Continue]
        goto J0x309;
    }
    OwnerController.ClearLatentAction(Class'SkySeqAct_AIUseCover', false);
    GotoState('Passive');
    stop;                
}

state SeekingCover extends Root_Mindset
{
    function EndState(name NextStateName)
    {
        // End:0x24
        if(OwnerController.IsMovingToGoal())
        {
            OwnerController.AbortMove();
        }
        // End:0x37
        if(IsInCover())
        {
            ChooseBestCoverExit();
        }
        super.EndState(NextStateName);
        //return;        
    }

    function TryTaunt()
    {
        OwnerController.AttemptTaunt(1);
        //return;        
    }

    function CurrentEnemyUpkeep()
    {
        local Pawn TestEnemy;

        // End:0x2C
        if(IsInVerticalSpace(OwnerController.CurrentEnemy))
        {
            GotoState('VerticalCombative');
            return;
        }
        // End:0x4B
        if(!ShouldSeekCover())
        {
            GotoState('Raging');
            return;
        }
        TestEnemy = OwnerController.BotMemory.GetBiggestThreatEnemy(true, OwnerController.CurrentEnemy);
        // End:0xCE
        if(((TestEnemy != none) && TestEnemy != OwnerController.CurrentEnemy) && int(GetEnemyStatus(TestEnemy)) == int(0))
        {
            OwnerController.CurrentEnemy = TestEnemy;
        }
        global.CurrentEnemyUpkeep();
        //return;        
    }

    final function bool DoesCoverSuck()
    {
        local float DistToEnemy;
        local CoverSlotMarker CSM;

        CSM = OwnerController.GetClaimedCoverMarker();
        // End:0x23
        if(CSM == none)
        {
            return false;
        }
        // End:0xA0
        if(!OwnerController.IsClaimedCoverExposed(false))
        {
            // End:0x50
            if(OwnerController.CurrentEnemy == none)
            {
                return false;
            }
            DistToEnemy = VSize(GetLastKnownLocation(OwnerController.CurrentEnemy) - CSM.Location);
            // End:0xA0
            if((DistToEnemy >= SeekingCover_MinCoverDistanceFromEnemy) && DistToEnemy <= SeekingCover_MaxCoverDistanceFromEnemy)
            {
                return false;
            }
        }
        return true;
        //return ReturnValue;        
    }

    function bool ChooseBestCoverExit()
    {
        // End:0x93
        if(DoesCoverSuck())
        {
            // End:0x90
            if((OwnerController.GetCoverNormal() Dot Normal(OwnerController.CurrentEnemy.Location - GetPawnLocation())) > 0.0000000)
            {
                // End:0x6C
                if(OwnerController.CanMantleOverCover())
                {
                    return OwnerController.MantleOverCover();
                }
                // End:0x90
                if(OwnerController.CanSlipOutOfCover())
                {
                    return OwnerController.SlipOutOfCover();
                }
            }            
        }
        else
        {
            // End:0xB7
            if(OwnerController.CanDiveOutOfCover())
            {
                return OwnerController.DiveOutOfCover();
            }
        }
        return OwnerController.ExitCover();
        //return ReturnValue;        
    }
Begin:

    CurrentSightingThreshold = Shooting_EnemySighting;
    SetMood(2);
FindCover:


    // End:0x61
    if(!OwnerController.BotMemory.CanSee(OwnerController.CurrentEnemy, CurrentSightingThreshold, EnemySighting))
    {
        Sleep(0.1000000);
        GotoState('Hunting');
    }
    OwnerController.RestoreDefaultCoverDistances();
    OwnerController.SetFindCoverDistances(SeekingCover_MinCoverDistanceFromEnemy, SeekingCover_MaxCoverDistanceFromEnemy, -1.0000000, -1.0000000);
    // End:0x1E7
    if(OwnerController.FindAndClaimCover(OwnerController.CurrentEnemy))
    {
        OwnerController.LockFocusOn(OwnerController.CurrentEnemy);
        OwnerController.StartTargeting();
        OwnerController.SetMoveGoal(OwnerController.GetClaimedCoverMarker());
        J0x10A:

        // End:0x177 [Loop If]
        if(OwnerController.IsMovingToGoal())
        {
            OwnerController.FireWeaponAt(OwnerController.CurrentEnemy);
            // End:0x16C
            if(DoesCoverSuck())
            {
                OwnerController.AbortMove();
                Sleep(0.2500000);
                goto 'FindCover';
            }
            Sleep(0.2500000);
            // [Loop Continue]
            goto J0x10A;
        }
        // End:0x1DD
        if(!IsInCover())
        {
            OwnerController.StopTargeting();
            OwnerController.StopAllFiring();
            Sleep(0.5000000);
            // End:0x1DD
            if(OwnerController.TakeCover())
            {
                J0x1BF:

                // End:0x1DD [Loop If]
                if(OwnerController.IsEnteringCover())
                {
                    Sleep(0.2500000);
                    // [Loop Continue]
                    goto J0x1BF;
                }
            }
        }
        goto 'InCover';
    }
    Sleep(0.2500000);
    goto 'ChaseTimed';
ChaseTimed:


    // End:0x30D
    if(OwnerController.BotMemory.CanSee(OwnerController.CurrentEnemy, CurrentSightingThreshold, EnemySighting))
    {
        OwnerController.LockFocusOn(OwnerController.CurrentEnemy);
        OwnerController.StartTargeting();
        OwnerController.SetMovePoint(GetLastKnownLocation(OwnerController.CurrentEnemy), none, SeekingCover_ChaseDistanceWhenNoCover);
        J0x28B:

        // End:0x2FC [Loop If]
        if(OwnerController.IsMovingToGoal())
        {
            OwnerController.FireWeaponAt(OwnerController.CurrentEnemy);
            // End:0x2F1
            if(OwnerController.InRange(GetLastKnownLocation(OwnerController.CurrentEnemy), SeekingCover_ChaseDistanceWhenNoCover))
            {
                // [Explicit Break]
                goto J0x2FC;
            }
            Sleep(0.2500000);
            // [Loop Continue]
            goto J0x28B;
        }
        J0x2FC:

        OwnerController.AbortMove();
    }
    Sleep(0.2500000);
    goto 'FindCover';
InCover:


    CoverHideStartingHealth = float(OwnerController.Pawn.Health);
InCoverLoop:


    // End:0x3D5
    if((OwnerController.IsClaimedCoverExposed(false) || !CanPrimaryWeaponFire()) || CheckShouldRandomSwatTurn())
    {
        OwnerController.StopAllFiring();
        // End:0x3CB
        if(OwnerController.CanSwatTurn())
        {
            OwnerController.SwatTurn();
            J0x3A3:

            // End:0x3C1 [Loop If]
            if(OwnerController.IsSwatTurning())
            {
                Sleep(0.2500000);
                // [Loop Continue]
                goto J0x3A3;
            }
            goto 'InCover';
        }
        goto 'BailOnCover';
    }
    // End:0x46E
    if(OwnerController.InRange(OwnerController.CurrentEnemy.Location, SeekingCover_MinCoverDistanceFromEnemy) || !OwnerController.InRange(OwnerController.CurrentEnemy.Location, SeekingCover_MaxCoverDistanceFromEnemy))
    {
        // End:0x46E
        if(OwnerController.FindCover(0, OwnerController.CurrentEnemy, BetterCover))
        {
            goto 'BailOnCover';
        }
    }
    OwnerController.StartTargeting();
    Sleep(0.5000000);
    OwnerController.FireWeaponAt(OwnerController.CurrentEnemy);
    // End:0x568
    if(OwnerController.BotMemory.CanSee(OwnerController.CurrentEnemy, CurrentSightingThreshold, EnemySighting) || OwnerController.BotMemory.FindEnemyLocation(OwnerController.CurrentEnemy, EnemySighting.LastLocation))
    {
        // End:0x556
        if(float(OwnerController.Pawn.Health) < (CoverHideStartingHealth - HideInCover_DamageThreshold))
        {
            goto 'HideInCover';            
        }
        else
        {
            Sleep(0.5000000);
            goto 'InCoverLoop';
        }
    }
    // End:0x5B4
    if((InCover_WaitToSeeEnemyTimeout < float(0)) || EnemySighting.LastUpdated > (WorldInfo.TimeSeconds - InCover_WaitToSeeEnemyTimeout))
    {
        Sleep(0.5000000);
        goto 'InCoverLoop';
    }
BailOnCover:


    OwnerController.StopTargeting();
    OwnerController.StopAllFiring();
    OwnerController.LookAt(GetPawnLocation() + (OwnerController.GetCoverNormal() * 5000.0000000));
    Sleep(0.5000000);
    ChooseBestCoverExit();
    J0x615:

    // End:0x633 [Loop If]
    if(OwnerController.IsExitingCover())
    {
        Sleep(0.2500000);
        // [Loop Continue]
        goto J0x615;
    }
    // End:0x64E
    if(IsInCover())
    {
        Sleep(0.2500000);
        goto 'BailOnCover';
    }
    OwnerController.LookAt(GetLastKnownLocation(OwnerController.CurrentEnemy));
    Sleep(0.5000000);
    // End:0x6CA
    if((ShouldSeekCover()) && OwnerController.BotMemory.CanSee(OwnerController.CurrentEnemy, 0.0000000, EnemySighting))
    {
        goto 'FindCover';
    }
    GotoState('Hunting');
HideInCover:


    OwnerController.StopTargeting();
    OwnerController.StopAllFiring();
    OwnerController.LookAt(GetPawnLocation() + (OwnerController.GetCoverNormal() * 5000.0000000));
    CoverHideTimeout = WorldInfo.TimeSeconds + RandRange(HideInCover_MinHidingTime, HideInCover_MaxHidingTime);
    J0x74E:

    // End:0x785 [Loop If]
    if(WorldInfo.TimeSeconds < CoverHideTimeout)
    {
        // End:0x77A
        if(DoesCoverSuck())
        {
            goto 'BailOnCover';
        }
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x74E;
    }
    OwnerController.LockFocusOn(OwnerController.CurrentEnemy);
    OwnerController.StartTargeting();
    Sleep(0.5000000);
    goto 'InCover';
    stop;        
}

state VerticalCombative extends Root_Mindset
{
    function EndState(name NextStateName)
    {
        // End:0x24
        if(OwnerController.IsMovingToGoal())
        {
            OwnerController.AbortMove();
        }
        OwnerController.StopAllFiring();
        ClearTimer('RecheckEnemyVertical');
        super.EndState(NextStateName);
        //return;        
    }

    function TryTaunt()
    {
        OwnerController.AttemptTaunt(1);
        //return;        
    }

    function CurrentEnemyUpkeep()
    {
        // End:0x55
        if((OwnerController.CurrentEnemy == none) || OwnerController.CurrentEnemy.Health <= 0)
        {
            OwnerController.CurrentEnemy = none;
            GotoState('RealizedEnemyDied');
        }
        // End:0x9E
        if(!IsInVerticalSpace(OwnerController.CurrentEnemy))
        {
            // End:0x9B
            if(!IsTimerActive('RecheckEnemyVertical'))
            {
                SetTimer(3.0000000, false, 'RecheckEnemyVertical');
            }            
        }
        else
        {
            ClearTimer('RecheckEnemyVertical');
        }
        //return;        
    }

    function RecheckEnemyVertical()
    {
        // End:0x43
        if((OwnerController.CurrentEnemy != none) && !IsInVerticalSpace(OwnerController.CurrentEnemy))
        {
            GotoState('EvaluatingEnemy');
        }
        //return;        
    }

    function bool FindCloseCover()
    {
        local CoverInfo FindCoverInfo;

        OwnerController.SetFindCoverDistances(Vertical_MinCoverDistanceFromMe, Vertical_MaxCoverDistanceFromMe, Vertical_MinCoverDistanceFromMe, Vertical_MaxCoverDistanceFromMe);
        // End:0x63
        if(OwnerController.FindCover(2, OwnerController.Pawn, FindCoverInfo))
        {
            return OwnerController.ClaimCover(FindCoverInfo);
        }
        return false;
        //return ReturnValue;        
    }

    function bool FindBetterNoPassingCover()
    {
        local CoverInfo FindCoverInfo;
        local bool bFoundCover;

        OwnerController.SetFindCoverDistances(Vertical_MinDistFromEnemy, Vertical_MaxDistFromEnemy, 0.0000000, 10000.0000000);
        OwnerController.SetProhibitPassingEnemyForCover(true);
        // End:0x66
        if(Vertical_DesiredCoverConeAngle > 0.0000000)
        {
            OwnerController.SetValidCoverCone(vect(0.0000000, 0.0000000, 1.0000000), Vertical_DesiredCoverConeAngle);
        }
        bFoundCover = OwnerController.FindCover(0, OwnerController.CurrentEnemy, FindCoverInfo);
        OwnerController.SetProhibitPassingEnemyForCover(false);
        OwnerController.RestoreDefaultValidCoverCone();
        // End:0xD3
        if(bFoundCover)
        {
            return OwnerController.ClaimCover(FindCoverInfo);
        }
        return false;
        //return ReturnValue;        
    }

    function bool CheckBetterCoverTimers()
    {
        // End:0x93
        if(Vertical_FallbackToMinDistFromEnemyTimeout > 0.0000000)
        {
            // End:0x88
            if(OwnerController.InRange(GetLastKnownLocation(OwnerController.CurrentEnemy), Vertical_MinDistFromEnemy))
            {
                // End:0x63
                if(Vertical_FallbackTimer <= 0.0000000)
                {
                    Vertical_FallbackTimer = WorldInfo.TimeSeconds;                    
                }
                else
                {
                    // End:0x85
                    if((WorldInfo.TimeSeconds - Vertical_FallbackTimer) > Vertical_FallbackToMinDistFromEnemyTimeout)
                    {
                        return true;
                    }
                }                
            }
            else
            {
                Vertical_FallbackTimer = 0.0000000;
            }
        }
        // End:0x144
        if(Vertical_ApproachToMaxDistFromEnemyTimeout > 0.0000000)
        {
            // End:0x139
            if(!OwnerController.InRange(GetLastKnownLocation(OwnerController.CurrentEnemy), Vertical_MaxDistFromEnemy) || !IsInDesiredCoverConeOf(OwnerController.CurrentEnemy))
            {
                // End:0x114
                if(Vertical_ApproachTimer <= 0.0000000)
                {
                    Vertical_ApproachTimer = WorldInfo.TimeSeconds;                    
                }
                else
                {
                    // End:0x136
                    if((WorldInfo.TimeSeconds - Vertical_ApproachTimer) > Vertical_ApproachToMaxDistFromEnemyTimeout)
                    {
                        return true;
                    }
                }                
            }
            else
            {
                Vertical_ApproachTimer = 0.0000000;
            }
        }
        return false;
        //return ReturnValue;        
    }
Begin:

    CurrentSightingThreshold = Shooting_EnemySighting;
    SetMood(2);
    // End:0x39
    if(IsInVerticalSpace(OwnerController.Pawn))
    {
        goto 'FindCover';
    }
GetMyselfVertical:


    OwnerController.SetMovePoint(OwnerController.CurrentEnemy.Location, none, 0.0000000);
    J0x6A:

    // End:0xA7 [Loop If]
    if(OwnerController.IsMovingToGoal())
    {
        Sleep(0.5000000);
        // End:0xA4
        if(IsInVerticalSpace(OwnerController.Pawn))
        {
            // [Explicit Break]
            goto J0xA7;
        }
        // [Loop Continue]
        goto J0x6A;
    }
    J0xA7:

    // End:0xF6
    if(!IsInVerticalSpace(OwnerController.Pawn))
    {
        // End:0xE4
        if(!OwnerController.HasReachedGoal())
        {
            goto 'StandingAttack';
        }
        Sleep(1.0000000);
        goto 'GetMyselfVertical';
    }
    J0xF6:

    // End:0x114 [Loop If]
    if(OwnerController.IsDoingCoverManeuver())
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0xF6;
    }
    // End:0x13D
    if(IsInCover())
    {
        Vertical_ApproachTimer = 0.0000000;
        Vertical_FallbackTimer = 0.0000000;
        goto 'InCover';
    }
    // End:0x212
    if(FindCloseCover())
    {
        OwnerController.StopTargeting();
        OwnerController.StopAllFiring();
        Sleep(0.5000000);
        OwnerController.SetMoveGoal(OwnerController.GetClaimedCoverMarker());
        J0x196:

        // End:0x1B4 [Loop If]
        if(OwnerController.IsMovingToGoal())
        {
            Sleep(0.2500000);
            // [Loop Continue]
            goto J0x196;
        }
        // End:0x1F2
        if(!IsInCover())
        {
            // End:0x1F2
            if(OwnerController.TakeCover())
            {
                J0x1D4:

                // End:0x1F2 [Loop If]
                if(OwnerController.IsEnteringCover())
                {
                    Sleep(0.2500000);
                    // [Loop Continue]
                    goto J0x1D4;
                }
            }
        }
        Vertical_ApproachTimer = 0.0000000;
        Vertical_FallbackTimer = 0.0000000;
        goto 'InCover';
    }
    Sleep(0.2500000);
    // End:0x23E
    if(!IsOnMyLevel(OwnerController.CurrentEnemy))
    {
        goto 'SelectBetterCover';
    }
StandingAttack:


    OwnerController.LockFocusOn(OwnerController.CurrentEnemy);
    J0x25D:

    // End:0x2D7 [Loop If]
    if(OwnerController.BotMemory.CanSee(OwnerController.CurrentEnemy, 0.0000000, EnemySighting) && IsOnMyLevel(OwnerController.CurrentEnemy))
    {
        OwnerController.Pawn.BotFire(false);
        Sleep(0.2500000);
        // [Loop Continue]
        goto J0x25D;
    }
    OwnerController.StopAllFiring();
    Sleep(0.2500000);
    goto 'FindCover';
InCover:


    CoverHideStartingHealth = float(OwnerController.Pawn.Health);
InCoverLoop:


    // End:0x345
    if(OwnerController.IsClaimedCoverExposed(false) || !CanPrimaryWeaponFire())
    {
        goto 'BailOnCover';
    }
    // End:0x39A
    if(CheckShouldRandomSwatTurn())
    {
        OwnerController.StopAllFiring();
        OwnerController.SwatTurn();
        J0x372:

        // End:0x390 [Loop If]
        if(OwnerController.IsSwatTurning())
        {
            Sleep(0.2500000);
            // [Loop Continue]
            goto J0x372;
        }
        goto 'InCover';
    }
    // End:0x3B1
    if(CheckBetterCoverTimers())
    {
        goto 'SelectBetterCover';
    }
    // End:0x403
    if(!OwnerController.IsTargeting())
    {
        OwnerController.LookAt(GetLastKnownLocation(OwnerController.CurrentEnemy));
        OwnerController.StartTargeting();
        Sleep(0.5000000);
    }
    // End:0x484
    if(OwnerController.BotMemory.CanSee(OwnerController.CurrentEnemy, 0.0000000, EnemySighting))
    {
        OwnerController.LookAt(GetLastKnownLocation(OwnerController.CurrentEnemy));
        OwnerController.FireWeaponAt(OwnerController.CurrentEnemy);        
    }
    else
    {
        OwnerController.StopAllFiring();
    }
    // End:0x4CA
    if(float(OwnerController.Pawn.Health) < (CoverHideStartingHealth - HideInCover_DamageThreshold))
    {
        goto 'HideInCover';
    }
    Sleep(0.1000000);
    goto 'InCoverLoop';
HideInCover:


    OwnerController.StopTargeting();
    OwnerController.StopAllFiring();
    OwnerController.LookAt(GetPawnLocation() + (OwnerController.GetCoverNormal() * 5000.0000000));
    CoverHideTimeout = WorldInfo.TimeSeconds + RandRange(HideInCover_MinHidingTime, HideInCover_MaxHidingTime);
    J0x552:

    // End:0x594 [Loop If]
    if(WorldInfo.TimeSeconds < CoverHideTimeout)
    {
        // End:0x589
        if(OwnerController.IsClaimedCoverExposed(false))
        {
            goto 'BailOnCover';
        }
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x552;
    }
    goto 'InCover';
SelectBetterCover:


    // End:0x66F
    if((FindBetterNoPassingCover()) || !IsInCover() && FindCloseCover())
    {
        OwnerController.StopTargeting();
        OwnerController.StopAllFiring();
        Sleep(0.5000000);
        OwnerController.SetMoveGoal(OwnerController.GetClaimedCoverMarker());
        J0x613:

        // End:0x631 [Loop If]
        if(OwnerController.IsMovingToGoal())
        {
            Sleep(0.2500000);
            // [Loop Continue]
            goto J0x613;
        }
        // End:0x66F
        if(!IsInCover())
        {
            // End:0x66F
            if(OwnerController.TakeCover())
            {
                J0x651:

                // End:0x66F [Loop If]
                if(OwnerController.IsEnteringCover())
                {
                    Sleep(0.2500000);
                    // [Loop Continue]
                    goto J0x651;
                }
            }
        }
    }
    Vertical_ApproachTimer = 0.0000000;
    Vertical_FallbackTimer = 0.0000000;
    goto 'InCover';
BailOnCover:


    // End:0x73B
    if(!IsInVerticalSpace(OwnerController.Pawn) || IsOnMyLevel(OwnerController.CurrentEnemy))
    {
        OwnerController.StopTargeting();
        OwnerController.StopAllFiring();
        Sleep(0.5000000);
        OwnerController.ExitCover();
        J0x6FF:

        // End:0x71D [Loop If]
        if(OwnerController.IsExitingCover())
        {
            Sleep(0.2500000);
            // [Loop Continue]
            goto J0x6FF;
        }
        // End:0x738
        if(IsInCover())
        {
            Sleep(0.2500000);
            goto 'BailOnCover';
        }        
    }
    else
    {
        Sleep(0.2500000);
    }
    // End:0x795
    if(IsOnMyLevel(OwnerController.CurrentEnemy))
    {
        OwnerController.LookAt(GetLastKnownLocation(OwnerController.CurrentEnemy));
        Sleep(0.5000000);
        goto 'StandingAttack';        
    }
    else
    {
        // End:0x7BE
        if(IsInVerticalSpace(OwnerController.Pawn))
        {
            goto 'SelectBetterCover';            
        }
        else
        {
            goto 'GetMyselfVertical';
        }
    }
    stop;                
}

state EvadingDanger extends Root_Mindset
{
    function bool TryEvadeFromDanger()
    {
        // End:0x33
        if(Projectile(Evade_DangerObject) != none)
        {
            // End:0x33
            if(FRand() < Evade_UseEvadeAnimationProbability)
            {
                // End:0x33
                if(OwnerController.PlayReaction(4))
                {
                    return true;
                }
            }
        }
        return false;
        //return ReturnValue;        
    }

    function bool TryFleeFromDanger()
    {
        local NavigationPoint FleeGoal;

        // End:0x8E
        if(Projectile(Evade_DangerObject) != none)
        {
            // End:0x4A
            if(!OwnerController.InRange(Evade_DangerObject.Location, Projectile(Evade_DangerObject).DamageRadius))
            {
                return false;
            }
            OwnerController.SetFleeDistances(Projectile(Evade_DangerObject).DamageRadius, Projectile(Evade_DangerObject).DamageRadius * 1.5000000, 0.0000000);
        }
        FleeGoal = OwnerController.FindFleeFrom(Evade_DangerObject);
        // End:0xCF
        if(FleeGoal != none)
        {
            OwnerController.SetMoveGoal(FleeGoal);
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    function PostEvadeEvaluate()
    {
        local Pawn TestEnemy;

        TestEnemy = OwnerController.BotMemory.GetBiggestThreatEnemy(true, OwnerController.CurrentEnemy);
        // End:0x61
        if(TestEnemy != none)
        {
            OwnerController.CurrentEnemy = TestEnemy;
            GotoState('EvaluatingEnemy');            
        }
        else
        {
            GotoState('Agitated');
        }
        //return;        
    }
Begin:

    OwnerController.UnlockFocus();
    OwnerController.StopAllFiring();
    OwnerController.StopTargeting();
    J0x30:

    // End:0x7E [Loop If]
    if(OwnerController.IsDoingCoverManeuver() || IsInCover())
    {
        // End:0x73
        if(!OwnerController.IsDoingCoverManeuver())
        {
            OwnerController.DiveOutOfCover();
        }
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x30;
    }
    InvestigateLocation = GetPawnLocation() + (Normal(GetPawnLocation() - Evade_DangerObject.Location) * 1000.0000000);
    OwnerController.LookAt(InvestigateLocation);
    J0xC1:

    // End:0xDC [Loop If]
    if(!IsPawnFacing(InvestigateLocation))
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0xC1;
    }
    // End:0x10A
    if(TryEvadeFromDanger())
    {
        J0xE9:

        // End:0x107 [Loop If]
        if(OwnerController.IsPlayingReaction())
        {
            Sleep(0.2500000);
            // [Loop Continue]
            goto J0xE9;
        }        
    }
    else
    {
        // End:0x1A8
        if(TryFleeFromDanger())
        {
            J0x117:

            // End:0x198 [Loop If]
            if(((OwnerController.IsMovingToGoal() && Evade_DangerObject != none) && !Evade_DangerObject.bDeleteMe) && OwnerController.InRange(Evade_DangerObject.Location, Projectile(Evade_DangerObject).DamageRadius * 2.0000000))
            {
                Sleep(0.2500000);
                // [Loop Continue]
                goto J0x117;
            }
            OwnerController.RestoreDefaultFleeDistances();
        }
    }
    // End:0x1F5
    if(OwnerController.CurrentEnemy != none)
    {
        InvestigateLocation = GetLastKnownLocation(OwnerController.CurrentEnemy);
        OwnerController.LookAt(InvestigateLocation);
        Sleep(0.5000000);
    }
    PostEvadeEvaluate();
    stop;                    
}

state DodgingDamage extends Root_Mindset
{
    function bool PickAppropriateDodge()
    {
        // End:0x17
        if(OwnerController.PlayReaction(9))
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    function bool TrySideStep(Vector ToDamageDir, bool bTryLeft)
    {
        local Vector TestMoveDir;

        // End:0x27
        if(bTryLeft)
        {
            TestMoveDir = ToDamageDir >> rot(0, -16384, 0);            
        }
        else
        {
            TestMoveDir = ToDamageDir >> rot(0, 16384, 0);
        }
        TestMoveDir = Normal(TestMoveDir) * 200.0000000;
        TestMoveDir.Z = 0.0000000;
        TestMoveDir += GetPawnLocation();
        // End:0xA9
        if(OwnerController.PointReachable(TestMoveDir))
        {
            OwnerController.SetMovePoint(TestMoveDir);
            return true;
        }
        //return ReturnValue;        
    }

    function bool RunSideways()
    {
        local Vector ToDamageDir;

        ToDamageDir = OwnerController.BotMemory.GetLastDamageDirection();
        // End:0x69
        if(VSize(ToDamageDir) > 0.0000000)
        {
            // End:0x69
            if(OwnerController.CurrentEnemy != none)
            {
                ToDamageDir = GetLastKnownLocation(OwnerController.CurrentEnemy) - GetPawnLocation();
            }
        }
        // End:0xD5
        if(VSize(ToDamageDir) > 0.0000000)
        {
            // End:0xAF
            if(FRand() > 0.5000000)
            {
                return (TrySideStep(ToDamageDir, true)) || TrySideStep(ToDamageDir, false);                
            }
            else
            {
                return (TrySideStep(ToDamageDir, false)) || TrySideStep(ToDamageDir, true);
            }
        }
        return false;
        //return ReturnValue;        
    }

    function PostDodgeEvaluate()
    {
        local Pawn TestEnemy;

        TestEnemy = OwnerController.BotMemory.GetBiggestThreatEnemy(true, OwnerController.CurrentEnemy);
        // End:0x61
        if(TestEnemy != none)
        {
            OwnerController.CurrentEnemy = TestEnemy;
            GotoState('EvaluatingEnemy');            
        }
        else
        {
            GotoState('Agitated');
        }
        //return;        
    }
Begin:

    OwnerController.LockFocusOn(OwnerController.CurrentEnemy);
    // End:0x4D
    if(PickAppropriateDodge())
    {
        J0x2C:

        // End:0x4A [Loop If]
        if(OwnerController.IsPlayingReaction())
        {
            Sleep(0.2500000);
            // [Loop Continue]
            goto J0x2C;
        }        
    }
    else
    {
        // End:0x78
        if(RunSideways())
        {
            J0x5A:

            // End:0x78 [Loop If]
            if(OwnerController.IsMovingToGoal())
            {
                Sleep(0.2500000);
                // [Loop Continue]
                goto J0x5A;
            }
        }
    }
    PostDodgeEvaluate();
    stop;        
}

state PerformingAvoidance extends Root_Mindset
{
    function bool AvoidPawns()
    {
        local Pawn AvoidPawn;
        local Vector ToAvoid, AvoidanceNet;
        local float Dist, SteeringFactor;

        AvoidanceNet = vect(0.0000000, 0.0000000, 0.0000000);
        // End:0xFA
        foreach OwnerController.Pawn.VisibleCollidingActors(Class'Engine.Pawn', AvoidPawn, AvoidanceRadius)
        {
            // End:0xF9
            if((int(AvoidPawn.Physics) == int(1)) && VSizeSq(AvoidPawn.Location - GetPawnLocation()) < Square(AvoidanceRadius))
            {
                ToAvoid = GetPawnLocation() - AvoidPawn.Location;
                ToAvoid.Z = 0.0000000;
                Dist = VSize(ToAvoid);
                SteeringFactor = float(Max(int(AvoidanceRadius - Dist), 100));
                AvoidanceNet += ((ToAvoid / Dist) * SteeringFactor);
            }            
        }        
        AvoidanceNet += GetPawnLocation();
        // End:0x138
        if(OwnerController.PointReachable(AvoidanceNet))
        {
            OwnerController.SetMovePoint(AvoidanceNet);
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    function PostAvoidanceEvaluate()
    {
        local Pawn TestEnemy;

        TestEnemy = OwnerController.BotMemory.GetBiggestThreatEnemy(true, OwnerController.CurrentEnemy);
        // End:0x61
        if(TestEnemy != none)
        {
            OwnerController.CurrentEnemy = TestEnemy;
            GotoState('EvaluatingEnemy');            
        }
        else
        {
            GotoState('Passive');
        }
        //return;        
    }
    J0x00:
    // End:0x1E [Loop If]
    if(OwnerController.IsDoingCoverManeuver())
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x00;
    }
    // End:0x55
    if(IsInCover())
    {
        OwnerController.ExitCover();
        J0x37:

        // End:0x55 [Loop If]
        if(OwnerController.IsExitingCover())
        {
            Sleep(0.1000000);
            // [Loop Continue]
            goto J0x37;
        }
    }
    // End:0xC2
    if(AvoidPawns())
    {
        PostHunt_Timer = WorldInfo.TimeSeconds;
        J0x77:

        // End:0xB7 [Loop If]
        if(OwnerController.IsMovingToGoal() && WorldInfo.TimeSeconds < (PostHunt_Timer + 5.0000000))
        {
            Sleep(0.2500000);
            // [Loop Continue]
            goto J0x77;
        }
        PostHunt_Timer = -1.0000000;
    }
    PostAvoidanceEvaluate();
    stop;                
}

state FreakedOut extends Root_Mindset
{
    function EndState(name NextStateName)
    {
        // End:0x24
        if(OwnerController.IsMovingToGoal())
        {
            OwnerController.AbortMove();
        }
        ForgetDisturbance();
        super.EndState(NextStateName);
        //return;        
    }

    function bool TryFleeFromNewEnemy()
    {
        local NavigationPoint FleeGoal;
        local Pawn newEnemy;
        local SightMemory TestSighting;

        newEnemy = OwnerController.BotMemory.GetClosestEnemyBySight(GetPawnLocation(), TestSighting);
        // End:0xB9
        if((newEnemy != none) && int(TestSighting.LastStatus) == int(0))
        {
            OwnerController.UnlockFocus();
            OwnerController.CurrentEnemy = newEnemy;
            FleeGoal = OwnerController.FindFleeFrom(newEnemy);
            // End:0xB9
            if(FleeGoal != none)
            {
                OwnerController.SetMoveGoal(FleeGoal, none);
                return true;
            }
        }
        return false;
        //return ReturnValue;        
    }

    function bool TryLookForPreviousEnemy()
    {
        local Vector NewPosition;

        // End:0x5D
        if(OwnerController.CurrentEnemy != none)
        {
            // End:0x5D
            if(OwnerController.BotMemory.FindEnemyLocation(OwnerController.CurrentEnemy, NewPosition))
            {
                OwnerController.LookAt(NewPosition);
                return true;
            }
        }
        return false;
        //return ReturnValue;        
    }

    function bool LookAtNewestDisturbance()
    {
        // End:0x24
        if(FindNewDisturbance())
        {
            OwnerController.LookAt(InvestigateLocation);
            return true;
        }
        return false;
        //return ReturnValue;        
    }
Begin:

    SetMood(4);
    OwnerController.PlayReaction(2);
    J0x1A:

    // End:0x38 [Loop If]
    if(OwnerController.IsPlayingReaction())
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x1A;
    }
FleeLoop:


    // End:0x9F
    if(!OwnerController.IsMovingToGoal())
    {
        // End:0x9F
        if(!TryFleeFromNewEnemy())
        {
            // End:0x9F
            if(!TryLookForPreviousEnemy())
            {
                // End:0x95
                if(InvestigateID > -1)
                {
                    // End:0x92
                    if(IsPawnFacing(InvestigateLocation))
                    {
                        ForgetDisturbance();
                    }                    
                }
                else
                {
                    LookAtNewestDisturbance();
                }
            }
        }
    }
    // End:0xBC
    if(!ShouldFlee())
    {
        GotoState('Passive');
    }
    Sleep(0.2500000);
    goto 'FleeLoop';
    stop;        
}

state Raging extends Root_Mindset
{
    function EndState(name NextStateName)
    {
        // End:0x24
        if(OwnerController.IsMovingToGoal())
        {
            OwnerController.AbortMove();
        }
        OwnerController.StopAllFiring();
        OwnerController.UnlockFocus();
        super.EndState(NextStateName);
        //return;        
    }
Begin:

    SetMood(2);
    CurrentSightingThreshold = Shooting_EnemySighting;
    // End:0x194
    if((((!IsInCover() && OwnerController.BotMemory.CanSee(OwnerController.CurrentEnemy, 0.0000000, EnemySighting)) && !OwnerController.InRange(GetLastKnownLocation(OwnerController.CurrentEnemy), 600.0000000)) && OwnerController.FindDangerObjectNearby(2.0000000 * VSize(OwnerController.CurrentEnemy.Location - GetPawnLocation())) == none) && FRand() < 0.2500000)
    {
        // End:0x194
        if(OwnerController.DrawSecondaryWeapon(OwnerController.GetSecondaryWeaponThrowTime()))
        {
            J0xFA:

            // End:0x194 [Loop If]
            if(OwnerController.IsSecondaryWeaponDrawn())
            {
                OwnerController.LookAt(GetLastKnownLocation(OwnerController.CurrentEnemy));
                // End:0x189
                if(!OwnerController.BotMemory.CanSee(OwnerController.CurrentEnemy, 0.0000000, EnemySighting))
                {
                    OwnerController.ReleaseSecondaryWeapon(OwnerController.CurrentEnemy);
                }
                Sleep(0.1000000);
                // [Loop Continue]
                goto J0xFA;
            }
        }
    }
    J0x194:

    // End:0x2EE [Loop If]
    if(OwnerController.BotMemory.CanSee(OwnerController.CurrentEnemy, 0.0000000, EnemySighting))
    {
        OwnerController.FireWeaponAt(OwnerController.CurrentEnemy);
        OwnerController.FireWeaponAt(OwnerController.CurrentEnemy);
        // End:0x2C4
        if((!OwnerController.IsMovingToGoal() && !OwnerController.InRange(GetLastKnownLocation(OwnerController.CurrentEnemy), Raging_ChaseEnemyDistance)) && !OwnerController.Pawn.ReachedDestination(OwnerController.CurrentEnemy))
        {
            OwnerController.StartTargeting();
            OwnerController.SetMoveGoal(OwnerController.CurrentEnemy, none, Raging_ChaseEnemyDistance);            
        }
        else
        {
            OwnerController.LockFocusOn(OwnerController.CurrentEnemy);
        }
        Sleep(0.5000000);
        // [Loop Continue]
        goto J0x194;
    }
    OwnerController.UnlockFocus();
    GotoState('Hunting');
    stop;                
}

state Hunting extends Root_Mindset
{
    function BeginState(name PrevStateName)
    {
        super.BeginState(PrevStateName);
        OwnerController.UnlockFocus();
        OwnerController.StopTargeting();
        //return;        
    }

    function EndState(name NextStateName)
    {
        // End:0x24
        if(OwnerController.IsMovingToGoal())
        {
            OwnerController.AbortMove();
        }
        super.EndState(NextStateName);
        //return;        
    }

    function CurrentEnemyUpkeep()
    {
        local Pawn TestEnemy;
        local SightMemory TestSighting;

        TestEnemy = OwnerController.BotMemory.GetClosestEnemyBySight(GetPawnLocation(), TestSighting);
        // End:0xC3
        if(((TestEnemy != none) && TestSighting.SeenDuration > CurrentSightingThreshold) && int(TestSighting.LastStatus) == int(0))
        {
            OwnerController.CurrentEnemy = TestEnemy;
            // End:0xB5
            if((PostHunt_MinCombatTimeBeforeCover > 0.0000000) && PostHunt_MaxCombatTimeBeforeCover > 0.0000000)
            {
                GotoState('PostHuntCombat');                
            }
            else
            {
                GotoState('EvaluatingEnemy');
            }
        }
        //return;        
    }
Begin:

    SetMood(4);
    CurrentSightingThreshold = Shooting_EnemySighting;
    // End:0x77
    if(OwnerController.CurrentEnemy == none)
    {
        OwnerController.CurrentEnemy = OwnerController.BotMemory.GetBiggestThreatEnemy(false);
        // End:0x77
        if(OwnerController.CurrentEnemy == none)
        {
            GotoState('Agitated');
        }
    }
    J0x77:

    // End:0x100 [Loop If]
    if(OwnerController.BotMemory.FindEnemyLocation(OwnerController.CurrentEnemy, EnemySighting.LastLocation))
    {
        OwnerController.SetMovePoint(EnemySighting.LastLocation, none);
        J0xD7:

        // End:0xF5 [Loop If]
        if(OwnerController.IsMovingToGoal())
        {
            Sleep(0.2500000);
            // [Loop Continue]
            goto J0xD7;
        }
        Sleep(0.2500000);
        // [Loop Continue]
        goto J0x77;
    }
    OwnerController.SetMovePoint(GetLastKnownLocation(OwnerController.CurrentEnemy), none);
    J0x129:

    // End:0x147 [Loop If]
    if(OwnerController.IsMovingToGoal())
    {
        Sleep(0.2500000);
        // [Loop Continue]
        goto J0x129;
    }
    OwnerController.SetMovePoint(GetPawnLocation() + (GetLastKnownMoveDirection(OwnerController.CurrentEnemy) * 2.0000000), none);
    J0x17F:

    // End:0x19D [Loop If]
    if(OwnerController.IsMovingToGoal())
    {
        Sleep(0.2500000);
        // [Loop Continue]
        goto J0x17F;
    }
    OwnerController.BotMemory.PurgeMemory(GetEnemyMemoryID(OwnerController.CurrentEnemy));
    OwnerController.CurrentEnemy = none;
    goto 'Begin';
    stop;                    
}

state PostHuntCombat extends Root_Mindset
{
    function BeginState(name PrevStateName)
    {
        super.BeginState(PrevStateName);
        PostHunt_Timer = WorldInfo.TimeSeconds + RandRange(PostHunt_MinCombatTimeBeforeCover, PostHunt_MaxCombatTimeBeforeCover);
        OwnerController.LockFocusOn(OwnerController.CurrentEnemy);
        //return;        
    }

    function EndState(name NextStateName)
    {
        // End:0x24
        if(OwnerController.IsMovingToGoal())
        {
            OwnerController.AbortMove();
        }
        PostHunt_Timer = -1.0000000;
        super.EndState(NextStateName);
        //return;        
    }

    function bool StrafeAround()
    {
        local Vector TestMoveDir;

        TestMoveDir = Vector(GetPawnRotation());
        TestMoveDir.Z = 0.0000000;
        // End:0x4E
        if(FRand() < 0.5000000)
        {
            TestMoveDir = TestMoveDir >> rot(0, 16384, 0);            
        }
        else
        {
            TestMoveDir = TestMoveDir >> rot(0, -16384, 0);
        }
        TestMoveDir *= RandRange(PostHunt_MinStrafeDistance, PostHunt_MaxStrafeDistance);
        TestMoveDir += GetPawnLocation();
        // End:0xBD
        if(OwnerController.PointReachable(TestMoveDir))
        {
            OwnerController.SetMovePoint(TestMoveDir);
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    function bool HasCombatTimerElapsed()
    {
        return PostHunt_Timer < WorldInfo.TimeSeconds;
        //return ReturnValue;        
    }
Begin:

    SetMood(2);
    CurrentSightingThreshold = Shooting_EnemySighting;
    J0x13:

    // End:0x3E [Loop If]
    if(!IsPawnFacing(GetLastKnownLocation(OwnerController.CurrentEnemy)))
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x13;
    }
    StrafeAround();
    OwnerController.FireWeaponAt(OwnerController.CurrentEnemy);
    J0x6B:

    // End:0x12E [Loop If]
    if(OwnerController.BotMemory.CanSee(OwnerController.CurrentEnemy, 0.0000000, EnemySighting))
    {
        // End:0xBC
        if(HasCombatTimerElapsed())
        {
            GotoState('EvaluatingEnemy');
        }
        // End:0x123
        if(!OwnerController.IsMovingToGoal() && OwnerController.GetLastMoveCompletedTime() < (WorldInfo.TimeSeconds - 1.0000000))
        {
            OwnerController.StartTargeting();
            // End:0x123
            if(StrafeAround())
            {
                Sleep(0.2500000);
            }
        }
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x6B;
    }
    GotoState('EvaluatingEnemy');
    stop;                
}

state Agitated extends Root_Mindset
{
    function CurrentEnemyUpkeep()
    {
        local Pawn TestEnemy;
        local SightMemory TestSighting;

        TestEnemy = OwnerController.BotMemory.GetClosestEnemyBySight(GetPawnLocation(), TestSighting);
        // End:0xD4
        if(((TestEnemy != none) && TestSighting.SeenDuration > CurrentSightingThreshold) && int(TestSighting.LastStatus) == int(0))
        {
            OwnerController.CurrentEnemy = TestEnemy;
            // End:0xC6
            if(OwnerController.InRange(OwnerController.CurrentEnemy.Location, Agitated_InvestigateDistance))
            {
                GotoState('StartledByEnemy');                
            }
            else
            {
                GotoState('EvaluatingEnemy');
            }
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        // End:0x24
        if(OwnerController.IsMovingToGoal())
        {
            OwnerController.AbortMove();
        }
        ForgetDisturbance();
        super.EndState(NextStateName);
        //return;        
    }
Begin:

    SetMood(3);
    CurrentSightingThreshold = Agitated_EnemySighting;
    // End:0x36
    if(OwnerController.IsScriptedMoving())
    {
        OwnerController.AbortScriptedMove();
    }
    OwnerController.CurrentEnemy = none;
    OwnerController.StopTargeting();
    OwnerController.StopAllFiring();
    OwnerController.UnlockFocus();
NextDisturbance:


    FindNewDisturbance();
    // End:0x197
    if(InvestigateID > -1)
    {
        // End:0x122
        if(NeedMoveToDisturbance())
        {
            OwnerController.SetMovePoint(InvestigateLocation, none, Agitated_InvestigateDistance);
            J0xBA:

            // End:0x100 [Loop If]
            if(OwnerController.IsMovingToGoal())
            {
                // End:0xF5
                if(FindNewDisturbance())
                {
                    OwnerController.AbortMove();
                    goto 'NextDisturbance';
                }
                Sleep(0.2500000);
                // [Loop Continue]
                goto J0xBA;
            }
            // End:0x11F
            if(!OwnerController.HasReachedGoal())
            {
                ForgetDisturbance();
            }            
        }
        else
        {
            OwnerController.LookAt(InvestigateLocation);
            OwnerController.PlayReaction(6);
            J0x149:

            // End:0x18A [Loop If]
            if((!IsPawnFacing(InvestigateLocation) || OwnerController.IsPlayingReaction()) && !FindNewDisturbance())
            {
                Sleep(0.2500000);
                // [Loop Continue]
                goto J0x149;
            }
            ForgetDisturbance();
        }        
    }
    else
    {
        Sleep(RandRange(1.0000000, 2.0000000));
        OwnerController.PlayReaction(7);
        J0x1BC:

        // End:0x1DA [Loop If]
        if(OwnerController.IsPlayingReaction())
        {
            Sleep(0.1000000);
            // [Loop Continue]
            goto J0x1BC;
        }
        GotoState('Passive');
    }
    Sleep(0.2500000);
    goto 'NextDisturbance';
    stop;        
}
