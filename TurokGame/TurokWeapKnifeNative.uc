class TurokWeapKnifeNative extends TurokWeapon
    native
    config(WeapKnife)
    hidecategories(Navigation);

enum EKnifeAttackType
{
    KAT_Stab,                       // 0
    KAT_Swipe,                      // 1
    KAT_MAX                         // 2
};

var(Stealth) const @NULL mTargetExtent;
var(Stealth) const bool mTargetFriendly;
var private bool mStealthKillReady;
var(Stealth) config float mFrontMultiPlayerExecuteRadius;
var(Stealth) config float mBackMultiPlayerExecuteRadius;
var(Stealth) config float mFrontSinglePlayerExecuteRadius;
var(Stealth) config float mBackSinglePlayerExecuteRadius;
var(Stealth) config float mStealthKillDeadZoneMultiplier;
var(Stealth) float mStealthKillExecutionRadiusMultiplier;
var(Animations) @NULL mStealthKillIdleAnim;
var(Animations) @NULL mStealthKillReadyAnim;
var(Animations) @NULL mStealthKillUnReadyAnim;
var(Animations) float mStealthKillReadyTime;
var(Animations) float mStealthKillUnReadyTime;
var(Animations) array mFireAnimHitTimes;
var(Animations) array mKnifeCauseHurtDuration;
var protected const @NULL mStealthKillGraphSet;
var(Rumble) private @NULL mKnifeWaveForm;
var private @NULL mStealthKillTarget;

reliable client simulated function ClientStealthKillFailed()
{
    GotoState('Active');
    //return;    
}

protected simulated function TickStealthKillReady()
{
    local @NULL PC;

    // End:0x23
    if((Instigator == none) || !Instigator.IsLocallyControlled())
    {
        return;
    }
    PC = TurokPlayerController(Instigator.Controller);
    mStealthKillTarget = PC.GetStealthKillTarget();
    SetStealthKillIsValid(IsValidStealthKillTarget(mStealthKillTarget));
    //return;    
}

protected simulated function SetStealthKillIsValid(bool stealthKillIsValid)
{
    ShowHudIcon(stealthKillIsValid);
    // End:0x3B
    if(stealthKillIsValid && !mStealthKillReady)
    {
        TimeReadyStealthKill();
        mStealthKillReady = true;        
    }
    else
    {
        // End:0x63
        if(!stealthKillIsValid && mStealthKillReady)
        {
            TimeUnReadyStealthKill();
            mStealthKillReady = false;
        }
    }
    //return;    
}

// Export UTurokWeapKnifeNative::execHasAmmo(FFrame&, void* const)
native function bool HasAmmo(byte FireModeNum, optional int Amount);

simulated function bool HasAnyAmmo()
{
    return true;
    //return ReturnValue;    
}

// Export UTurokWeapKnifeNative::execConsumeAmmo(FFrame&, void* const)
native function ConsumeAmmo(byte FireModeNum);

simulated function bool ShouldRefire()
{
    return false;
    //return ReturnValue;    
}

simulated event float GetSpeedBonus()
{
    return mSpeedBonus;
    //return ReturnValue;    
}

simulated event bool GetIsStealthWeapon()
{
    return true;
    //return ReturnValue;    
}

simulated function KnifeHit()
{
    local byte FireMode;

    FireMode = GetFiringMode();
    SetTimer(mKnifeCauseHurtDuration[int(FireMode)] - mFireAnimHitTimes[int(FireMode)], false, 'KnifeStopHit');
    SetTimer(0.0200000, true, 'CheckForKnifeHit');
    //return;    
}

simulated function KnifeStopHit()
{
    ClearTimer('CheckForKnifeHit');
    //return;    
}

simulated function CheckForKnifeHit()
{
    local @NULL StartTrace, EndTrace;

    StartTrace = Instigator.GetWeaponStartTraceLocation();
    EndTrace = StartTrace + (Vector(GetAdjustedAim(StartTrace)) * (GetMaxFiringDistance(int(GetFiringMode()))));
    mImpactList.Length = 0;
    CalcWeaponFire(StartTrace, EndTrace, mImpactList);
    // End:0x156
    if(mImpactList[0].HitActor != none)
    {
        KnifeStopHit();
        SetFlashLocation(mImpactList[0].HitLocation);
        // End:0xFE
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0xFE
            if(TurokPlayerController(Instigator.Controller) != none)
            {
                TurokPlayerController(Instigator.Controller).RecordShotHit(self, mImpactList, none);
            }
        }
        // End:0x13D
        if(TurokPlayerController(Instigator.Controller) != none)
        {
            TurokPlayerController(Instigator.Controller).TurokPlayForceFeedbackWaveform(mKnifeWaveForm);
        }
        TurokProcessInstantHit(GetFiringMode(), mImpactList);
    }
    //return;    
}

simulated event InstantMeleeFire()
{
    IncrementFlashCount();
    PlayFiringSound();
    // End:0x44
    if(int(Role) == int(ROLE_Authority))
    {
        SetTimer(mFireAnimHitTimes[int(GetFiringMode())], false, 'KnifeHit');
    }
    //return;    
}

simulated function ShowHudIcon(bool Show)
{
    local @NULL PC, THud;

    // End:0x82
    if((Instigator != none) && Instigator.Controller != none)
    {
        PC = PlayerController(Instigator.Controller);
        // End:0x82
        if(PC != none)
        {
            THud = TurokHud(PC.myHUD);
            // End:0x82
            if(THud != none)
            {
                THud.SetKnifeKillVisible(Show);
            }
        }
    }
    //return;    
}

private final simulated function float GetStealthKillExecutionRadius(@NULL attacker, @NULL Target)
{
    local float attackAngle;

    attackAngle = Class'TurokUtil'.static.GetRelativeAngle(attacker.Rotation, Target.Rotation);
    // End:0x80
    if(Abs(attackAngle) <= 90.0000000)
    {
        // End:0x66
        if(TurokPawnDino(Target) != none)
        {
            return TurokPawnDino(Target).mBackFinishingMoveRadius;
        }
        // End:0x77
        if(!mbIsMultiPlayer)
        {
            return mBackSinglePlayerExecuteRadius;
        }
        return mBackMultiPlayerExecuteRadius;        
    }
    else
    {
        // End:0xA4
        if(TurokPawnDino(Target) != none)
        {
            return TurokPawnDino(Target).mFrontFinishingMoveRadius;
        }
        // End:0xB5
        if(!mbIsMultiPlayer)
        {
            return mFrontSinglePlayerExecuteRadius;
        }
        return Lerp(mBackMultiPlayerExecuteRadius, mFrontMultiPlayerExecuteRadius, Abs(Cos((Abs(attackAngle) * 3.1415930) / 180.0000000)));
    }
    //return ReturnValue;    
}

private final simulated function bool IsWithinStealthKillRadius(@NULL attacker, @NULL Target)
{
    local @NULL distVec;
    local float distSquared, executeRadius;

    distVec = Target.Location - attacker.Location;
    // End:0x49
    if(TurokPawnHuman(Target) != none)
    {
        distVec.Z = 0.0000000;
    }
    distSquared = VSizeSq(distVec);
    executeRadius = GetStealthKillExecutionRadius(attacker, Target);
    // End:0x85
    if(mStealthKillReady)
    {
        executeRadius *= mStealthKillDeadZoneMultiplier;
    }
    return distSquared <= (executeRadius * executeRadius);
    //return ReturnValue;    
}

private final simulated function bool IsDinoStealthKillable(@NULL Target)
{
    local class<Class> predatorControllerClass;

    // End:0x1B
    if(int(Target.Physics) == int(12))
    {
        return false;
    }
    predatorControllerClass = class<TurokAIControllerPredator>(Target.ControllerClass);
    // End:0x9C
    if(predatorControllerClass != none)
    {
        // End:0x6E
        if(Target.InGodMode() && predatorControllerClass.default.mbAllowStealthKillInGodMode == false)
        {
            return false;
        }
        // End:0x9C
        if((predatorControllerClass.default.mbMustStunToKnifeKill == true) && Target.mbIsStunned == false)
        {
            return false;
        }
    }
    return true;
    //return ReturnValue;    
}

private final simulated function @NULL GetBestStealthKillGraph(@NULL attacker, @NULL Target)
{
    local @NULL Input, graphSet;
    local array validGraphs;
    local @NULL bestGraph;

    Input.mContactPoint = TurokNetCompressVector(Target.Location - (Target.GetCollisionHeight() * vect(0.0000000, 0.0000000, 1.0000000)));
    Input.mDistanceTolerance = GetStealthKillExecutionRadius(attacker, Target) * mStealthKillExecutionRadiusMultiplier;
    attacker.bJumpCapable = false;
    attacker.bCanClimbLadders = false;
    // End:0x10F
    if(TurokPawnHuman(Target) != none)
    {
        Input.mRelAngleTolerance = 70.0000000;
        graphSet = mStealthKillGraphSet;
        validGraphs = graphSet.FindMatchingActionGraphs(Input, 1, attacker, Target, 2);
        bestGraph = graphSet.FindGraphByRandomType(validGraphs, 2);        
    }
    else
    {
        // End:0x178
        if(TurokPawnDino(Target) != none)
        {
            Input.mRelAngleTolerance = 360.0000000;
            graphSet = TurokPawnDino(Target).mFinishingMovesGraphSet;
            bestGraph = graphSet.FindBestFitActionGraph(Input, 0, attacker, Target, 2);
        }
    }
    attacker.bJumpCapable = true;
    attacker.bCanClimbLadders = true;
    return bestGraph;
    //return ReturnValue;    
}

simulated function bool IsValidStealthKillTarget(@NULL Target)
{
    local @NULL dinoTarget, Player;

    Player = TurokPawnPlayer(Instigator);
    // End:0x38
    if((Player == none) || Player.IsInState('CannedAnimation'))
    {
        return false;
    }
    // End:0xDA
    if(((((((Target == none) || !Target.mCanBeStealthKilled) || Target.IsMauling()) || Target.Health <= 0) || int(Target.Physics) == int(10)) || Target.IsInState('CinematicState')) || Target.IsInState('MeleeAttackAnimation'))
    {
        return false;
    }
    // End:0x11B
    if((int(Player.Physics) != int(1)) && !Player.Controller.IsInState('PlayerImpulse'))
    {
        return false;
    }
    // End:0x148
    if(!Player.CanHurt(Target) && !mTargetFriendly)
    {
        return false;
    }
    // End:0x15F
    if(!IsWithinStealthKillRadius(Player, Target))
    {
        return false;
    }
    dinoTarget = TurokPawnDino(Target);
    // End:0x18E
    if((dinoTarget != none) && !IsDinoStealthKillable(dinoTarget))
    {
        return false;
    }
    // End:0x1BD
    if((Target.mbStealthKillTriggersEventOnly == false) && GetBestStealthKillGraph(Player, Target) == none)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated function SendStealthKillEvents(@NULL Target, @NULL attacker)
{
    local @NULL tAICtrl, tPlayerCtrl;

    // End:0x1A
    if((Target == none) || attacker == none)
    {
        return;
    }
    Target.TriggerEventClass(Class'TurokSeqEvent_StealthKill', attacker);
    tAICtrl = TurokAIController(Target.Controller);
    // End:0x70
    if(tAICtrl != none)
    {
        tAICtrl.NotifyStealthKill();
    }
    tPlayerCtrl = TurokPlayerController(attacker.Controller);
    // End:0xA4
    if(tPlayerCtrl != none)
    {
        tPlayerCtrl.mForcedStealthKillTarget = none;
    }
    //return;    
}

simulated function bool AttemptStealthKill()
{
    // End:0x16
    if(!IsValidStealthKillTarget(mStealthKillTarget))
    {
        return false;
    }
    ServerPerformStealthKill(mStealthKillTarget);
    ClearPendingFire(0);
    return true;
    //return ReturnValue;    
}

reliable server function ServerPerformStealthKill(@NULL Target)
{
    local @NULL attacker, tph, graph;

    attacker = TurokPawnPlayer(Instigator);
    // End:0x46
    if((Target.Health <= 0) || attacker.Health <= 0)
    {
        ClientStealthKillFailed();
        return;
    }
    // End:0x6B
    if(Target.IsInState('MeleeAttackAnimation'))
    {
        ClientStealthKillFailed();
        return;
    }
    SendStealthKillEvents(Target, attacker);
    // End:0x9D
    if(Target.mbStealthKillTriggersEventOnly)
    {
        ClientStealthKillFailed();
        return;
    }
    graph = GetBestStealthKillGraph(attacker, Target);
    // End:0xCA
    if(graph == none)
    {
        ClientStealthKillFailed();
        return;
    }
    attacker.SetActionActor(Target);
    attacker.PlayGraphReplicated(graph, attacker.Controller, 0);
    tph = TurokPawnHuman(Target);
    // End:0x175
    if((tph != none) && tph.DrivenVehicle != none)
    {
        tph.mSeatInOut = 9;
        tph.StopDriving(tph.DrivenVehicle);
        tph.DrivenVehicle = none;
    }
    // End:0x1B1
    if(TurokAIController(Target.Controller) != none)
    {
        TurokAIController(Target.Controller).SetSequenceAction(none, false);
    }
    attacker.mbIsStealthKilling = true;
    Target.mStealthKiller = attacker.Controller;
    Target.PlayGraphReplicated(graph, Target.Controller, 3);
    GotoState('StealthKilling');
    //return;    
}

simulated function PlayAmbientStealthKillAnim()
{
    PlayPOVAnimation(mStealthKillIdleAnim, mAmbientIdleTime, 0.0000000, 0.0000000, false, true);
    //return;    
}

simulated function TimeReadyStealthKill()
{
    PlayPOVAnimation(mStealthKillReadyAnim, mStealthKillReadyTime, 0.2000000, 0.0000000, true, false);
    SetTimer(((mStealthKillReadyTime > float(0)) ? mStealthKillReadyTime : 0.0100000), false, 'PlayAmbientStealthKillAnim');
    //return;    
}

simulated function TimeUnReadyStealthKill()
{
    PlayPOVAnimation(mStealthKillUnReadyAnim, mStealthKillUnReadyTime, 0.2000000, 0.0000000, true, false);
    SetTimer(((mStealthKillUnReadyTime > float(0)) ? mStealthKillUnReadyTime : 0.0100000), false, 'PlayAmbientIdleAnim');
    //return;    
}

simulated state Active
{
    simulated function BeginState(name PreviousStateName)
    {
        mStealthKillReady = false;
        PlayAmbientIdleAnim();
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated event StartFire(byte FireModeNum)
    {
        local @NULL tpp;

        tpp = TurokPawnPlayer(Instigator);
        // End:0x88
        if((tpp != none) && !tpp.IsInState('CannedAnimation'))
        {
            // End:0x79
            if((int(FireModeNum) == int(0)) && tpp.IsLocallyControlled())
            {
                // End:0x79
                if(AttemptStealthKill())
                {
                    GotoState('StealthKilling');
                    return;
                }
            }
            global.StartFire(FireModeNum);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super(Object).EndState(NextStateName);
        ClearTimer('PlayAmbientIdleAnim');
        ClearTimer('PlayAmbientStealthKillAnim');
        //return;        
    }

    simulated event Tick(float DeltaTime)
    {
        super(Actor).Tick(DeltaTime);
        TickStealthKillReady();
        //return;        
    }
    stop;    
}

simulated state WeaponFiring
{
    simulated function BeginState(name prevState)
    {
        super.BeginState(prevState);
        //return;        
    }

    simulated function EndState(name NextState)
    {
        super.EndState(NextState);
        //return;        
    }

    protected simulated function SetStealthKillIsValid(bool stealthKillIsValid)
    {
        ShowHudIcon(stealthKillIsValid);
        //return;        
    }

    simulated event Tick(float DeltaTime)
    {
        super(Actor).Tick(DeltaTime);
        TickStealthKillReady();
        //return;        
    }
    stop;    
}

simulated state StealthKilling
{
    simulated function BeginState(name prevState)
    {
        //return;        
    }

    simulated function EndState(name NextState)
    {
        //return;        
    }

    simulated function bool DoOverrideNextWeapon()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function bool DoOverridePrevWeapon()
    {
        return true;
        //return ReturnValue;        
    }
    stop;    
}

simulated state WeaponPuttingDown
{
    simulated function BeginState(name PreviousStateName)
    {
        mStealthKillReady = false;
        mStealthKillTarget = none;
        ShowHudIcon(false);
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}

state Deactivated
{
    simulated function BeginState(name PreviousStateName)
    {
        mStealthKillReady = false;
        mStealthKillTarget = none;
        ShowHudIcon(false);
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}

auto state Inactive
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        mStealthKillReady = false;
        mStealthKillTarget = none;
        ShowHudIcon(false);
        ClearTimer('CheckForKnifeHit');
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: TurokZoomComponent'Default__TurokWeapKnifeNative.Zoom'
    begin object name=Zoom
    end object
    mZoomValues=Zoom
}