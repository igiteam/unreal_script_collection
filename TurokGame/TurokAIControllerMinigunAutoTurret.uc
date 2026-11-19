class TurokAIControllerMinigunAutoTurret extends TurokAIControllerHumanNpc
    native
    hidecategories(Navigation);

// Export UTurokAIControllerMinigunAutoTurret::execGetPlayerViewPoint(FFrame&, void* const)
native simulated function GetPlayerViewPoint(out @NULL out_Location, out @NULL out_Rotation);

event bool IsInCombat()
{
    local bool InCombat;

    InCombat = false;
    // End:0x63
    if(TurokPawnHuman(Pawn) != none)
    {
        // End:0x63
        if(TurokPawnHuman(Pawn).GetPrimaryWeapon() != none)
        {
            InCombat = TurokPawnHuman(Pawn).GetPrimaryWeapon().HasAnyAmmo();
        }
    }
    return InCombat;
    //return ReturnValue;    
}

event TargetChanged()
{
    TurokPawnHumanNpcNative(Pawn).mAimRate = TurokPawnHumanNpcNative(Pawn).mAttackAimRate;
    super.TargetChanged();
    //return;    
}

event EnemyNotVisible()
{
    // End:0xA4
    if(TurokPawn(Pawn).mTargetingSystem.GetTarget(self) != none)
    {
        TurokPawnHumanNpcNative(Pawn).mAimRate = TurokPawnHumanNpcNative(Pawn).mIdleAimRate;
        StopFireTimer();
        TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = false;
        TurokPawn(Pawn).mTargetingSystem.ClearTarget();
        GotoActionPlanner();
    }
    //return;    
}

function bool ReadyToFire()
{
    local editinline @NULL targSys, enemyTarg;

    // End:0x15
    if(IsTimerActive('StopFireTimer'))
    {
        return false;
    }
    // End:0x2F
    if(mShootDelay >= WorldInfo.TimeSeconds)
    {
        return false;
    }
    targSys = TurokPawn(Pawn).mTargetingSystem;
    enemyTarg = targSys.GetTarget(Pawn.Controller);
    // End:0x7C
    if(enemyTarg == none)
    {
        return false;
    }
    // End:0x92
    if(Pawn.Weapon == none)
    {
        return false;
    }
    // End:0xAD
    if(TurokPawnHumanNpcNative(Pawn).mCanAttackOverride < 1)
    {
        return false;
    }
    // End:0xCC
    if(!WeaponPointedAt(enemyTarg.Location))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function NotifyKilled(@NULL Killer, @NULL Killed, @NULL KilledPawn)
{
    super.NotifyKilled(Killer, Killed, KilledPawn);
    // End:0x5A
    if(Pawn != none)
    {
        TurokPawnHumanNpcNative(Pawn).mAimRate = TurokPawnHumanNpcNative(Pawn).mIdleAimRate;
        Pawn.StopFiring();
    }
    //return;    
}

function UpdateStatus()
{
    local @NULL thePawn;

    super.UpdateStatus();
    thePawn = TurokPawnMiniGunAutoTurretNative(Pawn);
    // End:0xF5
    if((thePawn != none) && thePawn.GetPrimaryWeapon() != none)
    {
        // End:0xD6
        if(thePawn.GetPrimaryWeapon().HasAnyAmmo())
        {
            // End:0x9B
            if(int(thePawn.mTurretType) == int(2))
            {
                TurokPawn(Pawn).mTargetingSystem.mTargetType = 3;                
            }
            else
            {
                // End:0xD3
                if(int(thePawn.mTurretType) == int(1))
                {
                    TurokPawn(Pawn).mTargetingSystem.mTargetType = 2;
                }
            }            
        }
        else
        {
            TurokPawn(Pawn).mTargetingSystem.mTargetType = 19;
        }
    }
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

// Export UTurokAIControllerMinigunAutoTurret::execCanAssist(FFrame&, void* const)
native function bool CanAssist(@NULL assistActor, @NULL assistTarget);

state PatrolIdle
{
    simulated function BeginState(name PreviousStateName)
    {
        mIdleHeadTrackingEnabled = true;
        TurokPawnHumanNpcNative(Pawn).mAimRate = TurokPawnHumanNpcNative(Pawn).mIdleAimRate;
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        mIdleHeadTrackingEnabled = false;
        TurokPawnHumanNpcNative(Pawn).mAimRate = TurokPawnHumanNpcNative(Pawn).mAttackAimRate;
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

defaultproperties
{
    mbClearTargetIfNotFacing=true
    // Reference: SpriteComponent'Default__TurokAIControllerMinigunAutoTurret.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}