class TurokAIControllerSpiderTank extends TurokAIControllerHumanNpc
    native
    hidecategories(Navigation);

var @NULL mTargetLocation;
var bool mIsTargetLocationSet;
var @NULL mIncomingRocket;
var int mNumFlares;

// Export UTurokAIControllerSpiderTank::execCalculateTargetThreatValue(FFrame&, void* const)
native function float CalculateTargetThreatValue(@NULL TargetPawn, bool bCanSee, optional float noiseLevel);

// Export UTurokAIControllerSpiderTank::execOncePerTickUpdate(FFrame&, void* const)
native function bool OncePerTickUpdate();

event TargetChanged()
{
    TurokPawnHumanNpcNative(Pawn).mAimRate = TurokPawnHumanNpcNative(Pawn).mAttackAimRate;
    super.TargetChanged();
    //return;    
}

event EnemyNotVisible()
{
    //return;    
}

function bool CanSpeak()
{
    return false;
    //return ReturnValue;    
}

function bool CanInvestigate(@NULL investigateActor, byte Priority)
{
    return false;
    //return ReturnValue;    
}

// Export UTurokAIControllerSpiderTank::execCanAssist(FFrame&, void* const)
native function bool CanAssist(@NULL assistActor, @NULL assistTarget);

function NotifyIncomingRocket(@NULL rocketProj)
{
    mIncomingRocket = rocketProj;
    StartFlareTimer();
    //return;    
}

function StartFlareTimer()
{
    local @NULL flareProj;

    // End:0xB7
    if(mNumFlares < TurokPawnSpiderTankNative(Pawn).mMaxFlares)
    {
        mShootDelay = CalcFireDelay();
        flareProj = TurokPawnSpiderTankNative(Pawn).StartFlare();
        // End:0x9A
        if(mIncomingRocket.GetLockOnTarget() == none)
        {
            mIncomingRocket.SetLockOnTarget(flareProj, false);
            mIncomingRocket.Velocity = flareProj.Velocity;
        }
        SetTimer(0.2500000, false, 'StartFlareTimer');
        ++mNumFlares;        
    }
    else
    {
        mNumFlares = 0;
    }
    //return;    
}

function float CalcFireDelay()
{
    return WorldInfo.TimeSeconds + TurokPawnSpiderTankNative(Pawn).mWeaponDelayTime;
    //return ReturnValue;    
}

function bool ReadyToFire()
{
    local editinline @NULL targSys, enemyTarg;

    targSys = TurokPawn(Pawn).mTargetingSystem;
    enemyTarg = targSys.GetTarget(Pawn.Controller);
    // End:0x4D
    if(enemyTarg == none)
    {
        return false;
    }
    // End:0x73
    if(Pawn.NeedToTurn(enemyTarg.Location))
    {
        return false;
    }
    // End:0x8D
    if(mShootDelay >= WorldInfo.TimeSeconds)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function NotifyReadyToFire()
{
    GotoActionPlanner();
    //return;    
}

state ScriptedShootingState
{
    ignores PlayerAimingAt, EnemyNotVisibleTimer, NotifyGoalUnreachable, NotifyWeaponFinishedReloading, PlayStandingTurnAnim, SeeFlare, 
	    SeeFlareExploded;

    function StartFireTimer()
    {
        // End:0xB6
        if((Pawn != none) && Focus != none)
        {
            // End:0x8D
            if(!Pawn.NeedToTurn(Focus.Location))
            {
                Pawn.StartFire(0);
                // End:0x8A
                if(int(mScriptedShooting.mCountingType) == int(1))
                {
                    SetTimer(mScriptedShooting.mBurstLength, false, 'StopFireTimer');
                }                
            }
            else
            {
                Pawn.StopFiring();
                SetTimer(0.3000000, false, 'StartFireTimer');
            }            
        }
        else
        {
            FinishScriptedShooting();
        }
        //return;        
    }
    stop;    
}

state ShootEnemy
{
    simulated function BeginState(name PreviousStateName)
    {
        // End:0x49
        if(CheckPreconditions())
        {
            TurokPawnSpiderTankNative(Pawn).StartPrefire();
            SetTimer(TurokPawnSpiderTankNative(Pawn).mWeaponChargeTime, false, 'StartFireTimer');            
        }
        else
        {
            GotoState(PreviousStateName);
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    mbClearTargetIfNotFacing=true
    mPlannerDebug="AIControllerSpiderTank"
    // Reference: SpriteComponent'Default__TurokAIControllerSpiderTank.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}