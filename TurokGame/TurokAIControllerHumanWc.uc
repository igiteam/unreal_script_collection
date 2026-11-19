class TurokAIControllerHumanWc extends TurokAIControllerHumanFriendly
    native
    hidecategories(Navigation);

const MAX_DIST_FROM_ATTACK_LOCATION_TO_PLAYER = 720;
const MAX_DIST_FROM_WAIT_TO_ATTACK_LOCATION_TO_PLAYER = 720;
const MAX_STUN_DIST_FROM_PLAYER = 2000;
const REQUIRED_ENEMY_DIST_TO_WAKEUP = 1500;

var private @NULL mStrategicPathnode;
var private bool mAllowedToAttack;
var private bool mReachedStrategicNode;
var private bool mPlayerIsOutOfMaxRange;
var private bool mIsInActiveCombatGoal;
var private bool mIsInCombatWaitingGoal;
var private bool mShouldUpdateStrategicNode;
var private bool mStrategicNodeNeedsToUpdateSteering;
var private float mTimeOfLastCoverNodeUpdate;
var private float mEnableCombatTime;

// Export UTurokAIControllerHumanWc::execGetFlankBBTargetName(FFrame&, void* const)
native function name GetFlankBBTargetName();

// Export UTurokAIControllerHumanWc::execAdvanceViaCover(FFrame&, void* const)
native function bool AdvanceViaCover();

// Export UTurokAIControllerHumanWc::execEnemyTooFarFromCover(FFrame&, void* const)
native function bool EnemyTooFarFromCover(@NULL CoverNode, @NULL enemyTarg);

// Export UTurokAIControllerHumanWc::execIsInActiveCombat(FFrame&, void* const)
native function bool IsInActiveCombat();

// Export UTurokAIControllerHumanWc::execIsWaitingForCombat(FFrame&, void* const)
native function bool IsWaitingForCombat();

// Export UTurokAIControllerHumanWc::execCanReachEnemy(FFrame&, void* const)
native function bool CanReachEnemy(@NULL enemyLocation);

// Export UTurokAIControllerHumanWc::execIsCombatEnabled(FFrame&, void* const)
native function bool IsCombatEnabled();

// Export UTurokAIControllerHumanWc::execGetClosestAllowedAttackLocation(FFrame&, void* const)
native function bool GetClosestAllowedAttackLocation(@NULL TargetLocation, float desiredDistanceFromTarget, float maxDistanceFromTarget, out @NULL bestAllowedLocation);

// Export UTurokAIControllerHumanWc::execIsPositionBehindPlayerCombat(FFrame&, void* const)
native function bool IsPositionBehindPlayerCombat(@NULL Position, @NULL enemyLocation);

// Export UTurokAIControllerHumanWc::execIsCurrentlyBehindPlayerCombat(FFrame&, void* const)
native function bool IsCurrentlyBehindPlayerCombat(@NULL enemyTarget);

// Export UTurokAIControllerHumanWc::execGetEstimatedAttackLocation(FFrame&, void* const)
native function @NULL GetEstimatedAttackLocation(@NULL TargetLocation, float requiredDistanceToTarget);

// Export UTurokAIControllerHumanWc::execGetSpacingDistanceFromStrategicNode(FFrame&, void* const)
native function float GetSpacingDistanceFromStrategicNode(@NULL testNode);

// Export UTurokAIControllerHumanWc::execSetStrategicPathNode(FFrame&, void* const)
native function SetStrategicPathNode(@NULL bestNode, float currentWeight, bool forcedOffNode, bool notifyNodeChange);

// Export UTurokAIControllerHumanWc::execUpdateCompanionStatus(FFrame&, void* const)
native function UpdateCompanionStatus();

// Export UTurokAIControllerHumanWc::execUpdateStrategicNode(FFrame&, void* const)
native function UpdateStrategicNode(bool notifyNodeChange);

// Export UTurokAIControllerHumanWc::execCheckForImminentCombat(FFrame&, void* const)
native function CheckForImminentCombat();

// Export UTurokAIControllerHumanWc::execCheckIfPlayerIsOutOfRange(FFrame&, void* const)
native function CheckIfPlayerIsOutOfRange();

// Export UTurokAIControllerHumanWc::execCheckShouldWaitForCombat(FFrame&, void* const)
native function CheckShouldWaitForCombat();

// Export UTurokAIControllerHumanWc::execCheckForPendingCombat(FFrame&, void* const)
native function CheckForPendingCombat();

// Export UTurokAIControllerHumanWc::execClearCoverNode(FFrame&, void* const)
native function ClearCoverNode();

// Export UTurokAIControllerHumanWc::execGetPotentialCoverNodes(FFrame&, void* const)
native function GetPotentialCoverNodes(out array potentialCoverNodes, bool isForInvestigate);

// Export UTurokAIControllerHumanWc::execEnableCombat(FFrame&, void* const)
native function EnableCombat();

event bool CanPlayHitReaction()
{
    return (!mPlayerIsOutOfMaxRange || !HasValidActivePlayer()) && super(TurokAIController).CanPlayHitReaction();
    //return ReturnValue;    
}

event NotifyCausedDamage(@NULL damagedPawn, @NULL HitLocation)
{
    local @NULL Controller;
    local bool wasAllowedToAttack;

    // End:0xB0
    if(TurokPawn(Pawn).mTargetingSystem.ConsiderTarget(Pawn, damagedPawn))
    {
        wasAllowedToAttack = IsCombatEnabled();
        EnableCombat();
        // End:0x8B
        foreach WorldInfo.AllControllers(Class'TurokAIControllerHumanWc', Controller)
        {
            // End:0x8A
            if(Controller != self)
            {
                Controller.NotifyTeammateCausedDamage(self, damagedPawn);
            }            
        }        
        // End:0xB0
        if(!wasAllowedToAttack && IsCombatEnabled())
        {
            GotoActionPlanner();
        }
    }
    //return;    
}

event TargetChanged()
{
    local @NULL Controller;

    super(TurokAIControllerHumanNpc).TargetChanged();
    // End:0x64
    foreach WorldInfo.AllControllers(Class'TurokAIControllerHumanWc', Controller)
    {
        // End:0x63
        if(Controller != self)
        {
            Controller.NotifyTeammateTargetChanged(self, TurokPawn(Pawn).mTargetingSystem.GetTarget(self));
        }        
    }    
    //return;    
}

simulated function UpdateStatus()
{
    super.UpdateStatus();
    UpdateCompanionStatus();
    //return;    
}

simulated function bool ForceEarlyMaulEscape()
{
    return ((HasValidActivePlayer()) && mPlayerIsOutOfMaxRange) || super(TurokAIController).ForceEarlyMaulEscape();
    //return ReturnValue;    
}

simulated function GotoMoveToEnemyLastKnownState()
{
    GotoState('CompanionMoveToEnemyLastKnown');
    //return;    
}

simulated function GotoMoveToAssistRangeState()
{
    GotoActionPlanner();
    //return;    
}

simulated function GotoMoveToAssistFlankState()
{
    GotoActionPlanner();
    //return;    
}

function bool ShouldBroadCastShareTarget()
{
    return false;
    //return ReturnValue;    
}

// Export UTurokAIControllerHumanWc::execIsActivelyAssisting(FFrame&, void* const)
native function bool IsActivelyAssisting();

function bool ShouldUseAdaptiveMoveSpeed()
{
    return super.ShouldUseAdaptiveMoveSpeed() && !mPlayerIsOutOfMaxRange;
    //return ReturnValue;    
}

function bool IsLocationWithinAttackRangeFromPlayer(@NULL TestLocation)
{
    local bool Result;
    local @NULL attackLocation;

    Result = !HasActivePlayer();
    // End:0x6A
    if(!Result)
    {
        attackLocation = GetEstimatedAttackLocation(TestLocation, GetMaxOptimalAttackRange());
        Result = VSize2D(mActivePlayer.Location - attackLocation) <= float(720);
    }
    return Result;
    //return ReturnValue;    
}

function HandleTakeHitCombatChanges(@NULL InstigatedBy)
{
    local @NULL Controller;
    local bool wasAllowedToAttack;

    // End:0xC6
    if((InstigatedBy == none) || TurokPawn(Pawn).mTargetingSystem.ConsiderTarget(Pawn, InstigatedBy.Pawn))
    {
        // End:0x86
        foreach WorldInfo.AllControllers(Class'TurokAIControllerHumanWc', Controller)
        {
            // End:0x85
            if(Controller != self)
            {
                Controller.NotifyTeammateHit(self, InstigatedBy);
            }            
        }        
        wasAllowedToAttack = IsCombatEnabled();
        EnableCombat();
        // End:0xC6
        if(!wasAllowedToAttack && IsCombatEnabled())
        {
            GotoActionPlanner();
        }
    }
    // End:0x117
    if((float(Pawn.Health) < (float(TurokPawn(Pawn).mDefaultHealth) * 0.1000000)) && !IsInVehicle())
    {
        StartStunned(InstigatedBy);
    }
    //return;    
}

function NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
{
    super(TurokAIControllerHumanNpc).NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
    HandleTakeHitCombatChanges(InstigatedBy);
    //return;    
}

function NotifyVehicleTakeHit(@NULL InstigatedBy)
{
    super(TurokAIController).NotifyVehicleTakeHit(InstigatedBy);
    HandleTakeHitCombatChanges(InstigatedBy);
    //return;    
}

function NotifyBeingShotAtByAI(@NULL Shooter)
{
    local @NULL Controller;
    local bool wasAllowedToAttack;

    // End:0x41
    foreach WorldInfo.AllControllers(Class'TurokAIControllerHumanWc', Controller)
    {
        // End:0x40
        if(Controller != self)
        {
            Controller.NotifyTeammateShotAt(self, Shooter);
        }        
    }    
    wasAllowedToAttack = IsCombatEnabled();
    EnableCombat();
    // End:0x81
    if(!wasAllowedToAttack && IsCombatEnabled())
    {
        GotoActionPlanner();
    }
    //return;    
}

function NotifyTeammateShotAt(@NULL teammate, @NULL Shooter)
{
    local bool wasAllowedToAttack;

    // End:0xFC
    if((Shooter == none) || (Shooter.Pawn.Health > 0) && TurokPawn(Pawn).mTargetingSystem.ConsiderTarget(Pawn, Shooter.Pawn))
    {
        wasAllowedToAttack = IsCombatEnabled();
        EnableCombat();
        // End:0xFC
        if(IsCombatEnabled())
        {
            // End:0xE7
            if((Shooter != none) && SetAssistInfo(mAssistDuration[2], 2, teammate.Pawn, Shooter.Pawn, false, Shooter.Pawn.Location))
            {                
            }
            else
            {
                // End:0xFC
                if(!wasAllowedToAttack)
                {
                    GotoActionPlanner();
                }
            }
        }
    }
    //return;    
}

function NotifyTeammateHit(@NULL damagedTeammate, @NULL InstigatedBy)
{
    local bool wasAllowedToAttack;

    // End:0xFC
    if((InstigatedBy == none) || (InstigatedBy.Pawn.Health > 0) && TurokPawn(Pawn).mTargetingSystem.ConsiderTarget(Pawn, InstigatedBy.Pawn))
    {
        wasAllowedToAttack = IsCombatEnabled();
        EnableCombat();
        // End:0xFC
        if(IsCombatEnabled())
        {
            // End:0xE7
            if((InstigatedBy != none) && SetAssistInfo(mAssistDuration[2], 2, damagedTeammate.Pawn, InstigatedBy.Pawn, false, InstigatedBy.Pawn.Location))
            {                
            }
            else
            {
                // End:0xFC
                if(!wasAllowedToAttack)
                {
                    GotoActionPlanner();
                }
            }
        }
    }
    //return;    
}

function NotifyTeammateCausedDamage(@NULL teammateHitting, @NULL pawnHit)
{
    local bool wasAllowedToAttack;
    local @NULL teammateWeapon;

    // End:0x143
    if((pawnHit.Health > 0) && TurokPawn(Pawn).mTargetingSystem.ConsiderTarget(Pawn, pawnHit))
    {
        // End:0x143
        if((teammateHitting.Pawn != none) && TurokPawnHuman(teammateHitting.Pawn) != none)
        {
            teammateWeapon = TurokPawnHuman(teammateHitting.Pawn).GetPrimaryWeapon();
            // End:0x143
            if((teammateWeapon != none) && (TurokWeapBowNative(teammateWeapon) == none) && TurokWeapKnifeNative(teammateWeapon) == none)
            {
                wasAllowedToAttack = IsCombatEnabled();
                EnableCombat();
                // End:0x143
                if(IsCombatEnabled())
                {
                    // End:0x12E
                    if(SetAssistInfo(mAssistDuration[2], 2, teammateHitting.Pawn, pawnHit, false, pawnHit.Location))
                    {                        
                    }
                    else
                    {
                        // End:0x143
                        if(!wasAllowedToAttack)
                        {
                            GotoActionPlanner();
                        }
                    }
                }
            }
        }
    }
    //return;    
}

function NotifyTeammateTargetChanged(@NULL teammateChanged, @NULL NewTarget)
{
    // End:0xAA
    if((((NewTarget != none) && Pawn(NewTarget) != none) && Pawn(NewTarget).Health > 0) && TurokPawn(Pawn).mTargetingSystem.ConsiderTarget(Pawn, Pawn(NewTarget)))
    {
        // End:0xAA
        if(SetAssistInfo(mAssistDuration[2], 2, teammateChanged.Pawn, NewTarget, false, NewTarget.Location))
        {            
        }
    }
    //return;    
}

// Export UTurokAIControllerHumanWc::execCanAssist(FFrame&, void* const)
native function bool CanAssist(@NULL assistActor, @NULL assistTarget);

simulated function bool CanMoveAndShoot()
{
    // End:0x1F
    if((Pawn == none) || TurokPawnHuman(Pawn) == none)
    {
        return false;
    }
    // End:0x3F
    if(TurokPawnHuman(Pawn).GetRightHandWeapon() == none)
    {
        return false;
    }
    return int(TurokPawnHuman(Pawn).GetRightHandWeapon().mWeaponType) != int(12);
    //return ReturnValue;    
}

function CleanUp(@NULL inPawn)
{
    // End:0x28
    if(!mbCleanedUp)
    {
        SetStrategicPathNode(none, 0.0000000, false, false);
        super(TurokAIController).CleanUp(inPawn);
    }
    //return;    
}

simulated function DisplayDebug(@NULL HUD, out float out_YL, out float out_YPos)
{
    super(TurokAIControllerHumanNpc).DisplayDebug(HUD, out_YL, out_YPos);
    // End:0x34E
    if(HUD.ShouldDisplayDebug('AI'))
    {
        // End:0xB1
        if(mStrategicPathnode != none)
        {
            Pawn.DrawDebugLine(Location, mStrategicPathnode.Location, 50, 200, 50);
            Pawn.DrawDebugSphere(mStrategicPathnode.Location, 10.0000000 - (Sin(WorldInfo.TimeSeconds % float(90)) * float(5)), 8, 50, 200, 50);
        }
        HUD.Canvas.__NFUN_465__("Strategic Node: " $ string(mStrategicPathnode), false);
        HUD.Canvas.SetPos(4.0000000, out_YPos += out_YL);
        HUD.Canvas.__NFUN_465__("Reached Strategic Node: " $ string(mReachedStrategicNode), false);
        HUD.Canvas.SetPos(4.0000000, out_YPos += out_YL);
        HUD.Canvas.__NFUN_465__("In Combat Goal: " $ string(mIsInActiveCombatGoal), false);
        HUD.Canvas.SetPos(4.0000000, out_YPos += out_YL);
        HUD.Canvas.__NFUN_465__("Allowed To Attack: " $ string(IsCombatEnabled()), false);
        HUD.Canvas.SetPos(4.0000000, out_YPos += out_YL);
        HUD.Canvas.__NFUN_465__("Player Out of Range: " $ string(mPlayerIsOutOfMaxRange), false);
        HUD.Canvas.SetPos(4.0000000, out_YPos += out_YL);
        HUD.Canvas.__NFUN_465__("Player Reachable: " $ string(mActivePlayerReachable), false);
        HUD.Canvas.SetPos(4.0000000, out_YPos += out_YL);
        HUD.Canvas.__NFUN_465__("Using Adaptive Move Speed: " $ string(mUseAdaptiveMoveSpeed), false);
        HUD.Canvas.SetPos(4.0000000, out_YPos += out_YL);
    }
    //return;    
}

function HandleKilledSpeech(@NULL Killer, @NULL Killed, @NULL KilledPawn)
{
    // End:0xDA
    if(Killed != self)
    {
        // End:0x5A
        if(Killer == self)
        {
            WorldInfo.ClearBBRecords(mSpeechBBEnemyKilled, Pawn, none);
            UpdateSpeechData(mSpeechBBEnemyKilled, Pawn, none, WorldInfo.TimeSeconds);            
        }
        else
        {
            // End:0xDA
            if(TurokPawnHumanNpcNative(KilledPawn) != none)
            {
                // End:0xDA
                if(int(TurokPawnHumanNpcNative(KilledPawn).mNPCType) == int(TurokPawnHumanNpcNative(Pawn).mNPCType))
                {
                    WorldInfo.ClearBBRecords(mSpeechBBFriendKilled, Pawn, none);
                    UpdateSpeechData(mSpeechBBFriendKilled, Pawn, none, WorldInfo.TimeSeconds);
                }
            }
        }
    }
    //return;    
}

function AcquireTargetSpeech()
{
    // End:0x88
    if(!mAssistInfo.mActive || mAssistInfo.mAssistTarget != TurokPawn(Pawn).mTargetingSystem.GetTarget(self))
    {
        // End:0x82
        if(!IsCombatEnabled())
        {
            UpdateSpeechData(mSpeechBBEnemySpottedStealth, Pawn, none, WorldInfo.TimeSeconds);            
        }
        else
        {
            super(TurokAIControllerHumanNpc).AcquireTargetSpeech();
        }
    }
    //return;    
}

function UpdateIdleSpeech()
{
    //return;    
}

// Export UTurokAIControllerHumanWc::execShouldStopUsingCover(FFrame&, void* const)
native function bool ShouldStopUsingCover(@NULL CoverNode, optional @NULL enemyTarg);

// Export UTurokAIControllerHumanWc::execCanEnterCover(FFrame&, void* const)
native function bool CanEnterCover(@NULL CoverNode, out int bestCoverDistance, optional @NULL enemyTarg);

function OnToggleGodMode(@NULL inAction)
{
    PlayerMessage(string(self.Pawn) $ " is a companion and does not support god mode");
    //return;    
}

function OnAIEnterVehicle(@NULL Action)
{
    ForceEndStunned();
    super(TurokAIController).OnAIEnterVehicle(Action);
    //return;    
}

function OnAIExitVehicle(@NULL Action)
{
    ForceEndStunned();
    super(TurokAIController).OnAIExitVehicle(Action);
    //return;    
}

simulated function bool ForceMaulEscapeWhenKilled()
{
    return true;
    //return ReturnValue;    
}

simulated function float ForcedMaulTimeBeforeEscapeScalar()
{
    return 3.0000000;
    //return ReturnValue;    
}

function bool CanSpeak()
{
    return !IsStunned() && super(TurokAIControllerHumanNpc).CanSpeak();
    //return ReturnValue;    
}

simulated function StartStunned(@NULL whoStunnedMe)
{
    local @NULL GI;

    GI = TurokGameInfo(WorldInfo.Game);
    // End:0x42
    if(GI != none)
    {
        GI.NotifyKilled(whoStunnedMe, self, Pawn);
    }
    GotoState('CompanionStunned');
    //return;    
}

simulated function ForceEndStunned()
{
    //return;    
}

private final simulated function FinishStunned()
{
    // End:0x5E
    if(IsStunned())
    {
        Pawn.Health = TurokPawn(Pawn).mDefaultHealth;
        TurokPawn(Pawn).mValidTarget = true;
        Pawn.bBlockActors = true;
        mbIsStunned = false;
    }
    //return;    
}

function bool FindCoverNode(optional bool isForInvestigate = false, optional bool notifyNodeChange = true)
{
    mTimeOfLastCoverNodeUpdate = WorldInfo.TimeSeconds;
    return super(TurokAIControllerHumanNpc).FindCoverNode(isForInvestigate, notifyNodeChange);
    //return ReturnValue;    
}

function bool FindCoverNodeLazy(optional bool isForInvestigate = false, optional bool notifyNodeChange = true)
{
    // End:0x42
    if((mTimeOfLastCoverNodeUpdate - float(3)) < WorldInfo.TimeSeconds)
    {
        return FindCoverNode(isForInvestigate, notifyNodeChange);        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function EnemyNotVisibleSpeech(@NULL enemyTarg)
{
    // End:0x18
    if(IsCombatEnabled())
    {
        super(TurokAIControllerHumanNpc).EnemyNotVisibleSpeech(enemyTarg);
    }
    //return;    
}

simulated event bool IsProjectileCloseEnoughToReactTo(@NULL Projectile)
{
    return ((HasActivePlayer()) && VSize(mActivePlayer.Location - Projectile.Location) < float(800)) && VSize(Pawn.Location - mActivePlayer.Location) < float(1600);
    //return ReturnValue;    
}

state CompanionStunned
{
    simulated function BeginState(name PreviousStateName)
    {
        local @NULL tg;

        Focus = none;
        FocalPoint = Vector(Pawn.Rotation);
        StopMovement();
        SetIdlePosture();
        tg = TurokPawnHumanNpcNative(Pawn).mStunnedGraphSet.FindGraph('stunnedFall');
        TurokPawn(Pawn).PlayGraphReplicated(tg, self, 0);
        ClearTargeters();
        TurokPawn(Pawn).mValidTarget = false;
        // End:0xBA
        if(!mReachedStrategicNode)
        {
            SetStrategicPathNode(none, 0.0000000, false, false);
        }
        Pawn.bBlockActors = false;
        mbIsStunned = true;
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x19
        if(NextStateName != 'CompanionStunnedFinished')
        {
            FinishStunned();
        }
        //return;        
    }

    simulated function GotoScriptedState(name ScriptedStateName)
    {
        mQueuedNextState = ScriptedStateName;
        ForceEndStunned();
        //return;        
    }

    simulated function ForceEndStunned()
    {
        GotoState('CompanionStunnedFinished');
        //return;        
    }

    simulated function UpdateStatus()
    {
        local bool okToWakeUp, forceWakeUp;
        local @NULL testController;

        super(TurokAIControllerHumanWc).UpdateStatus();
        okToWakeUp = true;
        forceWakeUp = false;
        // End:0x62
        if(HasActivePlayer())
        {
            // End:0x62
            if(VSizeSq(mActivePlayer.Location - Pawn.Location) > float(2000 * 2000))
            {
                forceWakeUp = true;
            }
        }
        // End:0x170
        if(okToWakeUp && !forceWakeUp)
        {
            // End:0x123
            foreach WorldInfo.AllControllers(Class'TurokAIController', testController)
            {
                // End:0x122
                if(TurokPawn(Pawn).mTargetingSystem.ConsiderTarget(Pawn, testController.Pawn))
                {
                    // End:0x122
                    if(VSize(testController.Pawn.Location - Pawn.Location) < float(1500))
                    {
                        // End:0x122
                        if(testController.IsInCombat())
                        {
                            okToWakeUp = false;
                            // End:0x123
                            break;
                        }
                    }
                }                
            }            
            // End:0x170
            if(okToWakeUp)
            {
                Pawn.bBlockActors = true;
                okToWakeUp = !TurokPawn(Pawn).CheckIfBeingEncroachedOn();
                Pawn.bBlockActors = false;
            }
        }
        // End:0x18E
        if(okToWakeUp || forceWakeUp)
        {
            ForceEndStunned();
        }
        //return;        
    }

    event bool CanPlayHitReaction()
    {
        return false;
        //return ReturnValue;        
    }
    stop;    
}

state CompanionStunnedFinished
{
    simulated function BeginState(name PreviousStateName)
    {
        local @NULL tg;

        tg = TurokPawnHumanNpcNative(Pawn).mStunnedGraphSet.FindGraph('stunnedGetUp');
        TurokPawn(Pawn).PlayGraphReplicated(tg, self, 0);
        //return;        
    }

    simulated function GotoScriptedState(name ScriptedStateName)
    {
        mQueuedNextState = ScriptedStateName;
        //return;        
    }

    event bool CanPlayHitReaction()
    {
        return false;
        //return ReturnValue;        
    }

    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        // End:0x2F
        if(mQueuedNextState != 'None')
        {
            GotoState(mQueuedNextState);
            mQueuedNextState = 'None';            
        }
        else
        {
            global.GotoActionPlanner();
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        FinishStunned();
        //return;        
    }
    stop;    
}

state CannedAnimation
{
    function NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
    {
        global.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
        //return;        
    }
    stop;    
}

state FinishHitReaction
{
    function NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
    {
        global.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
        //return;        
    }
    stop;    
}

state PlayTransitionGraphState
{
    function NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
    {
        global.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
        //return;        
    }
    stop;    
}

state TrackPlayerState
{
    function NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
    {
        global.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
        //return;        
    }
    stop;    
}

state HumanNPCMelee
{
    function NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
    {
        global.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
        //return;        
    }
    stop;    
}

state DefenderMaulAnimation
{
    simulated function BeginState(name PreviousStateName)
    {
        local @NULL Controller;

        super.BeginState(PreviousStateName);
        // End:0x63
        foreach WorldInfo.AllControllers(Class'TurokAIControllerHumanWc', Controller)
        {
            // End:0x62
            if(Controller != self)
            {
                Controller.NotifyTeammateHit(self, TurokPawnHuman(Pawn).mMaulWatcher.mAttackerController);
            }            
        }        
        //return;        
    }
    stop;    
}

state GoalCompanionAssist extends GoalAssist
{
    simulated function bool CheckPreconditions()
    {
        return ((IsCombatEnabled()) && super.CheckPreconditions()) && CheckAssist();
        //return ReturnValue;        
    }

    simulated function SetupGoal()
    {
        super.SetupGoal();
        mIsInActiveCombatGoal = true;
        mIsInCombatWaitingGoal = false;
        //return;        
    }
    stop;    
}

state GoalCompanionAttackEnemy extends GoalAttackEnemy
{
    simulated function bool CheckPreconditions()
    {
        return (IsCombatEnabled()) && super.CheckPreconditions();
        //return ReturnValue;        
    }

    simulated function SetupGoal()
    {
        super.SetupGoal();
        mIsInActiveCombatGoal = true;
        mIsInCombatWaitingGoal = false;
        //return;        
    }
    stop;    
}

state GoalCompanionAttackHuman extends GoalCompanionAttackEnemy
{
    simulated function bool CheckPreconditions()
    {
        return super.CheckPreconditions() && TurokPawnHuman(TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller)) != none;
        //return ReturnValue;        
    }
    stop;    
}

state GoalCompanionAttackCreature extends GoalCompanionAttackEnemy
{
    simulated function bool CheckPreconditions()
    {
        return super.CheckPreconditions() && TurokPawnHuman(TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller)) == none;
        //return ReturnValue;        
    }
    stop;    
}

state GoalCompanionAttackInVehicle extends GoalAttackInVehicle
{
    simulated function bool CheckPreconditions()
    {
        return (IsCombatEnabled()) && super.CheckPreconditions();
        //return ReturnValue;        
    }

    simulated function SetupGoal()
    {
        super(GoalAttackEnemy).SetupGoal();
        mIsInActiveCombatGoal = true;
        mIsInCombatWaitingGoal = false;
        //return;        
    }
    stop;    
}

state GoalCompanionAssistInVehicle extends GoalAssistInVehicle
{
    simulated function bool CheckPreconditions()
    {
        return (IsCombatEnabled()) && super.CheckPreconditions();
        //return ReturnValue;        
    }

    simulated function SetupGoal()
    {
        super(GoalAssist).SetupGoal();
        mIsInActiveCombatGoal = true;
        mIsInCombatWaitingGoal = false;
        //return;        
    }
    stop;    
}

state GoalWaitToAttack extends GoalAttackEnemy
{
    simulated function bool CheckPreconditions()
    {
        local bool Result;

        Result = !mPlayerIsOutOfMaxRange && super.CheckPreconditions() || CheckAssist();
        // End:0x71
        if(Result && HasValidActivePlayer())
        {
            Result = VSize(Pawn.Location - mActivePlayer.Location) < float(720);
        }
        return Result;
        //return ReturnValue;        
    }

    simulated function SetupGoal()
    {
        super.SetupGoal();
        mIsInActiveCombatGoal = false;
        mIsInCombatWaitingGoal = true;
        //return;        
    }
    stop;    
}

state GoalWaitToAttackInVehicle extends GoalWaitToAttack
{
    simulated function bool CheckPreconditions()
    {
        return super.CheckPreconditions() && IsInVehicle();
        //return ReturnValue;        
    }
    stop;    
}

state GoalCompanionFollowPlayer extends GoalFollowPlayer
{
    simulated function SetupGoal()
    {
        super.SetupGoal();
        mIsInActiveCombatGoal = false;
        mIsInCombatWaitingGoal = false;
        //return;        
    }
    stop;    
}

state GoalCompanionWait extends GoalWait
{
    simulated function SetupGoal()
    {
        super.SetupGoal();
        mIsInActiveCombatGoal = false;
        mIsInCombatWaitingGoal = false;
        //return;        
    }
    stop;    
}

state GoalCompanionAvoidPlayer extends GoalAvoidPlayer
{
    simulated function SetupGoal()
    {
        super.SetupGoal();
        mIsInActiveCombatGoal = false;
        mIsInCombatWaitingGoal = false;
        //return;        
    }
    stop;    
}

state GoalCompanionRideInVehicle extends GoalRideInVehicle
{
    simulated function SetupGoal()
    {
        super.SetupGoal();
        mIsInActiveCombatGoal = false;
        mIsInCombatWaitingGoal = false;
        //return;        
    }
    stop;    
}

state GoalCompanionInvestigateInVehicle extends GoalInvestigateInVehicle
{
    simulated function SetupGoal()
    {
        super(GoalInvestigate).SetupGoal();
        mIsInActiveCombatGoal = false;
        mIsInCombatWaitingGoal = false;
        //return;        
    }
    stop;    
}

state GoalCompanionGrenadeReaction extends GoalGrenadeReaction
{
    simulated function SetupGoal()
    {
        super.SetupGoal();
        mIsInActiveCombatGoal = true;
        mIsInCombatWaitingGoal = false;
        //return;        
    }
    stop;    
}

state MoveToPlayerRangeFiring extends MoveToPlayerRange
{
    simulated function SetupState()
    {
        super(BaseFriendlyFollowPlayer).SetupState();
        // End:0x2A
        if(CanMoveAndShoot())
        {
            SetAttackPosture(GetTargetLOS());            
        }
        else
        {
            SetAttackPosture(false);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        StopFireTimer();
        super(MoveToTargetRange).EndState(NextStateName);
        //return;        
    }

    function NotifyReadyToFire()
    {
        // End:0x26
        if((CanMoveAndShoot()) && IsCombatEnabled())
        {
            StartFireTimer();
        }
        //return;        
    }

    event SeeMonster(@NULL Seen)
    {
        // End:0x73
        if(TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller) == Seen)
        {
            // End:0x70
            if(CanMoveAndShoot())
            {
                SetAttackPosture(true);
                TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = true;
            }            
        }
        else
        {
            super(TurokAIController).SeeMonster(Seen);
        }
        //return;        
    }

    event EnemyNotVisible()
    {
        // End:0x18
        if(GetTargetLOS())
        {
            SetAttackPosture(false);
        }
        super(TurokAIControllerHumanNpc).EnemyNotVisible();
        //return;        
    }
Begin:

    MoveWithSteering(mMoveTarget, mMinDistToTarget, mTargetPos, rot(0, 0, 0), 'CompanionAttackSteer', true);
    stop;        
}

state MoveToPlayerLosFiring extends MoveToPlayerLos
{
    simulated function SetupState()
    {
        super(BaseFriendlyFollowPlayer).SetupState();
        // End:0x2A
        if(CanMoveAndShoot())
        {
            SetAttackPosture(GetTargetLOS());            
        }
        else
        {
            SetAttackPosture(false);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        StopFireTimer();
        super(MoveToTargetRange).EndState(NextStateName);
        //return;        
    }

    function NotifyReadyToFire()
    {
        // End:0x26
        if((CanMoveAndShoot()) && IsCombatEnabled())
        {
            StartFireTimer();
        }
        //return;        
    }

    event SeeMonster(@NULL Seen)
    {
        // End:0x73
        if(TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller) == Seen)
        {
            // End:0x70
            if(CanMoveAndShoot())
            {
                SetAttackPosture(true);
                TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = true;
            }            
        }
        else
        {
            super(TurokAIController).SeeMonster(Seen);
        }
        //return;        
    }

    event EnemyNotVisible()
    {
        // End:0x18
        if(GetTargetLOS())
        {
            SetAttackPosture(false);
        }
        super(TurokAIControllerHumanNpc).EnemyNotVisible();
        //return;        
    }
Begin:

    MoveWithSteering(mMoveTarget, mMinDistToTarget, mTargetPos, rot(0, 0, 0), 'CompanionAttackSteer', true);
    stop;        
}

state MoveToStrategicRange extends BaseFriendlyMoveToTargetRange
{
    simulated function SetupPreconditions()
    {
        super(MoveToTargetRange).SetupPreconditions();
        // End:0x52
        if((mStrategicPathnode != none) && !mReachedStrategicNode)
        {
            mMoveTarget = mStrategicPathnode;
            mTargetPos = mStrategicPathnode.Location;
            mMinDistToTarget = GetSpacingDistanceFromStrategicNode(mStrategicPathnode);
        }
        //return;        
    }

    simulated function bool CheckPreconditions()
    {
        return (!mReachedStrategicNode && mStrategicPathnode != none) && super(MoveToTargetRange).CheckPreconditions();
        //return ReturnValue;        
    }

    simulated function FailedPreconditions(name PreviousStateName)
    {
        super(MoveToTargetRange).FailedPreconditions(PreviousStateName);
        // End:0x1E
        if(mStrategicPathnode != none)
        {
            mReachedStrategicNode = true;
        }
        //return;        
    }

    simulated function SetupState()
    {
        super.SetupState();
        mStrategicNodeNeedsToUpdateSteering = true;
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super(MoveToTargetRange).EndState(NextStateName);
        mStrategicNodeNeedsToUpdateSteering = false;
        //return;        
    }

    event SteeringTargetInRange()
    {
        mReachedStrategicNode = true;
        super.SteeringTargetInRange();
        //return;        
    }

    event bool NotifyBump(@NULL Other, @NULL HitNormal)
    {
        // End:0x23
        if(!IsInActiveCombat())
        {
            return super.NotifyBump(Other, HitNormal);            
        }
        else
        {
            return false;
        }
        //return ReturnValue;        
    }

    function NotifyTooCloseToPlayer()
    {
        // End:0x15
        if(!IsInActiveCombat())
        {
            super.NotifyTooCloseToPlayer();
        }
        //return;        
    }
    stop;    
}

state MoveToStrategicRangeFiring extends MoveToStrategicRange
{
    simulated function SetupState()
    {
        super.SetupState();
        // End:0x2A
        if(CanMoveAndShoot())
        {
            SetAttackPosture(GetTargetLOS());            
        }
        else
        {
            SetAttackPosture(false);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        StopFireTimer();
        super.EndState(NextStateName);
        //return;        
    }

    function NotifyReadyToFire()
    {
        // End:0x26
        if((CanMoveAndShoot()) && IsCombatEnabled())
        {
            StartFireTimer();
        }
        //return;        
    }

    event SeeMonster(@NULL Seen)
    {
        // End:0x66
        if(TurokPawn(Pawn).mTargetingSystem.GetTarget(self) == Seen)
        {
            TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = true;
            // End:0x63
            if(CanMoveAndShoot())
            {
                SetAttackPosture(true);
            }            
        }
        else
        {
            super(TurokAIController).SeeMonster(Seen);
        }
        //return;        
    }

    event EnemyNotVisible()
    {
        // End:0x18
        if(GetTargetLOS())
        {
            SetAttackPosture(false);
        }
        super(TurokAIControllerHumanNpc).EnemyNotVisible();
        //return;        
    }

    function StopFireTimer()
    {
        global.StopFireTimer();
        FindCoverNode();
        //return;        
    }

    event SteeringTargetInRange()
    {
        super.SteeringTargetInRange();
        FindCoverNode();
        //return;        
    }

    event NotifyCoverNodeChanged(@NULL oldCoverNode)
    {
        // End:0x17
        if(HasCoverNode())
        {
            GotoActionPlanner();
        }
        super(TurokAIControllerHumanNpc).NotifyCoverNodeChanged(oldCoverNode);
        //return;        
    }
Begin:

    MoveWithSteering(mMoveTarget, mMinDistToTarget, mTargetPos, rot(0, 0, 0), 'CompanionAttackSteer', true);
    stop;        
}

state BaseCompanionFacePlayer extends StandFaceTarget
{
    simulated function bool CheckPreconditions()
    {
        return super.CheckPreconditions() && HasActivePlayer();
        //return ReturnValue;        
    }

    simulated function SetupState()
    {
        mMoveTarget = mActivePlayer;
        super.SetupState();
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        mMinDistToTarget = mWaitForPlayerDist;
        SetAttackPosture(false);
        //return;        
    }

    event bool NotifyBump(@NULL Other, @NULL HitNormal)
    {
        // End:0x1C
        if(HandleBumped(Other))
        {
            GotoActionPlanner();
        }
        return super(TurokAIController).NotifyBump(Other, HitNormal);
        //return ReturnValue;        
    }

    function NotifyTooCloseToPlayer()
    {
        // End:0x1C
        if(HandleBumped(mActivePlayer))
        {
            GotoActionPlanner();
        }
        //return;        
    }
    stop;    
}

state StandFaceUnreachablePlayer extends BaseCompanionFacePlayer
{
    simulated function bool CheckPreconditions()
    {
        return super.CheckPreconditions() && !mActivePlayerReachable;
        //return ReturnValue;        
    }

    simulated function NotifyPlayerChangedReachableStatus(bool playerReachable)
    {
        global.NotifyPlayerChangedReachableStatus(playerReachable);
        // End:0x23
        if(playerReachable)
        {
            GotoActionPlanner();
        }
        //return;        
    }
    stop;    
}

state WaitAtStrategicLocation extends BaseCompanionFacePlayer
{
    simulated function bool CheckPreconditions()
    {
        return (super.CheckPreconditions() && mReachedStrategicNode) && mLosToActivePlayer;
        //return ReturnValue;        
    }

    event PlayerNotVisible(@NULL Player)
    {
        global.PlayerNotVisible(Player);
        GotoActionPlanner();
        //return;        
    }
    stop;    
}

state StandFacePlayer extends BaseCompanionFacePlayer
{
    simulated function bool CheckPreconditions()
    {
        return (HasValidActivePlayer()) && super.CheckPreconditions();
        //return ReturnValue;        
    }

    event PlayerNotVisible(@NULL Player)
    {
        global.PlayerNotVisible(Player);
        GotoActionPlanner();
        //return;        
    }

    simulated function UpdateStatus()
    {
        global.UpdateStatus();
        // End:0x3E
        if(VSize(mActivePlayer.Location - Pawn.Location) > mWaitForPlayerDist)
        {
            GotoActionPlanner();
        }
        //return;        
    }
    stop;    
}

state CompanionFaceEnemyLastKnownWait
{
    simulated function bool CheckPreconditions()
    {
        return (TurokPawn(Pawn).mTargetingSystem.GetTarget(self) != none) && !GetTargetLOS();
        //return ReturnValue;        
    }

    simulated function SetupState()
    {
        Focus = none;
        FocalPoint = TurokPawn(Pawn).mTargetingSystem.GetTargetLastKnown() - Pawn.GetPawnViewLocation();
        SetAttackPosture(false);
        Pawn.bWantsToCrouch = !mAllowedToAttack && !IsInVehicle();
        StopMovement();
        //return;        
    }

    simulated function FailedPreconditions(name PreviousStateName)
    {
        GotoState(PreviousStateName);
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        SetupPreconditions();
        // End:0x24
        if(CheckPreconditions())
        {
            SetupState();            
        }
        else
        {
            FailedPreconditions(PreviousStateName);
        }
        //return;        
    }

    event bool NotifyBump(@NULL Other, @NULL HitNormal)
    {
        // End:0x1C
        if(HandleBumped(Other))
        {
            GotoActionPlanner();
        }
        return super(TurokAIController).NotifyBump(Other, HitNormal);
        //return ReturnValue;        
    }

    function NotifyTooCloseToPlayer()
    {
        // End:0x1C
        if(HandleBumped(mActivePlayer))
        {
            GotoActionPlanner();
        }
        //return;        
    }
    stop;    
}

state CompanionFaceAssistWait extends CompanionFaceEnemyLastKnownWait
{
    simulated function bool CheckPreconditions()
    {
        return CheckAssist();
        //return ReturnValue;        
    }

    simulated function SetupState()
    {
        super.SetupState();
        Focus = mAssistInfo.mActor;
        // End:0x4D
        if(!IsCombatEnabled())
        {
            UpdateSpeechData(mSpeechBBEnemySpottedStealth, Pawn, none, WorldInfo.TimeSeconds);
        }
        //return;        
    }

    event AssistStarted(@NULL PawnAssisting, @NULL assistTarget, bool assistingOnNewTarget)
    {
        // End:0x1F
        if(assistingOnNewTarget)
        {
            super(TurokAIControllerHumanNpc).AssistStarted(PawnAssisting, assistTarget, assistingOnNewTarget);
        }
        //return;        
    }
    stop;    
}

state CompanionMoveToEnemyLastKnown extends MoveToEnemyLastKnown
{
    simulated function SetupState()
    {
        super.SetupState();
        mUseAdaptiveMoveSpeed = false;
        //return;        
    }

    simulated function SetupPreconditions()
    {
        local @NULL attackLocation;
        local float dist;

        super.SetupPreconditions();
        // End:0x5F
        if(GetClosestAllowedAttackLocation(mTargetPos, mMinDistToTarget, GetMaxAttackRange(), attackLocation))
        {
            dist = VSize(mTargetPos - attackLocation);
            // End:0x5C
            if(dist > mMinDistToTarget)
            {
                mMinDistToTarget = dist;
            }            
        }
        else
        {
            mMoveTarget = none;
            mTargetPos = Pawn.Location;
            mMinDistToTarget = 1000000.0000000;
        }
        //return;        
    }
    stop;    
}

state CompanionMoveToEnemyAttackRange extends MoveToEnemyAttackRange
{
    simulated function SetupPreconditions()
    {
        local @NULL attackLocation;
        local float dist;

        super.SetupPreconditions();
        // End:0x7E
        if((mMoveTarget != none) && GetClosestAllowedAttackLocation(mMoveTarget.Location, mMinDistToTarget, GetMaxAttackRange(), attackLocation))
        {
            dist = VSize(mMoveTarget.Location - attackLocation);
            // End:0x7B
            if(dist > mMinDistToTarget)
            {
                mMinDistToTarget = dist;
            }            
        }
        else
        {
            mMoveTarget = none;
            mTargetPos = Pawn.Location;
            mMinDistToTarget = 1000000.0000000;
        }
        //return;        
    }

    simulated function SetupState()
    {
        super.SetupState();
        mUseAdaptiveMoveSpeed = false;
        //return;        
    }
    stop;    
}

state CompanionMoveToAssistRange extends MoveToAssistRange
{
    simulated function SetupPreconditions()
    {
        local @NULL attackLocation;
        local float dist;

        super.SetupPreconditions();
        // End:0x5F
        if(GetClosestAllowedAttackLocation(mTargetPos, mMinDistToTarget, GetMaxAttackRange(), attackLocation))
        {
            dist = VSize(mTargetPos - attackLocation);
            // End:0x5C
            if(dist > mMinDistToTarget)
            {
                mMinDistToTarget = dist;
            }            
        }
        else
        {
            mMoveTarget = none;
            mTargetPos = Pawn.Location;
            mMinDistToTarget = 1000000.0000000;
        }
        //return;        
    }

    simulated function SetupState()
    {
        super.SetupState();
        mUseAdaptiveMoveSpeed = false;
        //return;        
    }

    event NotifyGoalUnreachable()
    {
        ClearAssistInfo();
        GotoActionPlanner();
        //return;        
    }
    stop;    
}

state ScanAssist
{
    event bool NotifyBump(@NULL Other, @NULL HitNormal)
    {
        // End:0x1C
        if(HandleBumped(Other))
        {
            GotoActionPlanner();
        }
        return super(TurokAIController).NotifyBump(Other, HitNormal);
        //return ReturnValue;        
    }

    function NotifyTooCloseToPlayer()
    {
        // End:0x1C
        if(HandleBumped(mActivePlayer))
        {
            GotoActionPlanner();
        }
        //return;        
    }
    stop;    
}

state CompanionAcquireTarget extends AcquireTarget
{
    simulated function SetupState()
    {
        super.SetupState();
        mShouldUpdateStrategicNode = false;
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        mShouldUpdateStrategicNode = true;
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

state CompanionShootEnemy extends ShootEnemy
{
    simulated function bool CheckPreconditions()
    {
        return super.CheckPreconditions() && GetTargetLOS();
        //return ReturnValue;        
    }
    stop;    
}

state RetreatShootEnemy
{
    function bool ValidForRetreat(@NULL navPoint)
    {
        // End:0x16
        if(navPoint.AnchoredPawn != none)
        {
            return false;
        }
        // End:0x48
        if(VSize2D(mActivePlayer.Location - navPoint.Location) > float(720))
        {
            return false;
        }
        return true;
        //return ReturnValue;        
    }
    stop;    
}

state CompanionMoveToCoverRangeFiring extends MoveToCoverRangeFiring
{
    simulated function SetupPreconditions()
    {
        // End:0x1B
        if(!HasCoverNode())
        {
            FindCoverNodeLazy(false, false);
        }
        super(MoveToCoverRange).SetupPreconditions();
        //return;        
    }

    function NotifyReadyToFire()
    {
        // End:0x26
        if((CanMoveAndShoot()) && IsCombatEnabled())
        {
            StartFireTimer();
        }
        //return;        
    }
    stop;    
}

state CompanionFaceEnemyWait extends StandFaceTarget
{
    simulated function bool CheckPreconditions()
    {
        return ((TurokPawn(Pawn).mTargetingSystem.GetTarget(self) != none) && GetTargetLOS()) && super.CheckPreconditions();
        //return ReturnValue;        
    }

    simulated function SetupState()
    {
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        mMoveTarget = TurokPawn(Pawn).mTargetingSystem.GetTarget(self);
        super.SetupState();
        SetAttackPosture(true);
        Pawn.bWantsToCrouch = !mAllowedToAttack && !IsInVehicle();
        //return;        
    }

    event bool NotifyBump(@NULL Other, @NULL HitNormal)
    {
        // End:0x1C
        if(HandleBumped(Other))
        {
            GotoActionPlanner();
        }
        return super(TurokAIController).NotifyBump(Other, HitNormal);
        //return ReturnValue;        
    }

    function NotifyTooCloseToPlayer()
    {
        // End:0x1C
        if(HandleBumped(mActivePlayer))
        {
            GotoActionPlanner();
        }
        //return;        
    }
    stop;    
}

state CompanionGrenadeLandedReaction
{
    simulated function bool CheckPreconditions()
    {
        return (mHeardGrenade != none) && !mHeardGrenade.GetExploded();
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x80
        if(CheckPreconditions())
        {
            Pawn.bWantsToCrouch = false;
            mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
            mMoveTarget = mHeardGrenade;
            SetAttackPosture(true);
            UpdateSpeechData(mSpeechBBGrenadeLand, Pawn, none, WorldInfo.TimeSeconds);
            SetTimer(1.5000000, false, 'FinishedGrenadeWait');            
        }
        else
        {
            GotoState(PreviousStateName);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        mHeardGrenade = none;
        ClearTimer('FinishedGrenadeWait');
        //return;        
    }

    function FinishedGrenadeWait()
    {
        GotoActionPlanner();
        //return;        
    }

    event bool NotifyBump(@NULL Other, @NULL HitNormal)
    {
        // End:0x1C
        if(HandleBumped(Other))
        {
            GotoActionPlanner();
        }
        return super(TurokAIController).NotifyBump(Other, HitNormal);
        //return ReturnValue;        
    }

    function NotifyTooCloseToPlayer()
    {
        // End:0x1C
        if(HandleBumped(mActivePlayer))
        {
            GotoActionPlanner();
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    mShouldUpdateStrategicNode=true
    mTimeOfLastCoverNodeUpdate=-100.0000000
    mUseAdaptiveDifficulty=false
    mMoveToInvestigateDist=64.0000000
    mSpeechBBSpeaking="AICH_WcSpeech"
    mSpeechBBAttackHuman="AICH_WcSpeechAttackHuman"
    mSpeechBBAttackDino="AICH_WcSpeechAttackDino"
    mSpeechBBAttackBug="AICH_WcSpeechAttackBug"
    mSpeechBBGrenadeLand="AICH_WcGrenadeLand"
    mSpeechBBCover="AICH_WcSpeechCover"
    mSpeechBBFlanking="None"
    mSpeechBBFriendKilled="AICH_WcSpeechFriendKilled"
    mSpeechBBEnemyKilled="AICH_WcSpeechEnemyKilled"
    mSpeechBBEnemyNotVisible="AICH_WcEnemyNotVisible"
    mSpeechBBEnemySpottedShort="AICH_WcEnemySpottedShort"
    mSpeechBBEnemySpottedLong="AICH_WcEnemySpottedLong"
    mSpeechBBEnemySpottedStealth="AICH_WcEnemySpottedStealth"
    mPlannerDebug="AIPlannerCompanion"
    bGodMode=true
    // Reference: SpriteComponent'Default__TurokAIControllerHumanWc.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}