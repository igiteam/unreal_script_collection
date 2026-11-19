class TurokAIControllerHumanFriendly extends TurokAIControllerHumanNpc
    native
    hidecategories(Navigation);

const PLAYER_BUMP_TIMEOUT = 1;
const BUMPED_AGAINST_WALL_STUCK_COS_ANGLE = -0.86;

var @NULL mActivePlayer;
var protected bool mLosToActivePlayer;
var protected bool mActivePlayerReachable;
var private bool mBumpedByFriendly;
var private bool mBumpedAgainstWall;
var protected bool mUseAdaptiveMoveSpeed;
var private @NULL mBumpedByPawn;
var private @NULL mBumpedAgainstWallVect;
var private int mCurrentBumpPriority;
var private int mMyBumpingPriority;
var protected float mWaitForPlayerDist;
var protected float mTooCloseToPlayerDist;

function NotifyTooCloseToPlayer()
{
    //return;    
}

// Export UTurokAIControllerHumanFriendly::execCalculateAvoidPlayerMovement(FFrame&, void* const)
native function CalculateAvoidPlayerMovement();

// Export UTurokAIControllerHumanFriendly::execHasActivePlayer(FFrame&, void* const)
native function bool HasActivePlayer();

// Export UTurokAIControllerHumanFriendly::execHasValidActivePlayer(FFrame&, void* const)
native function bool HasValidActivePlayer();

function UpdateStatus()
{
    local float dist, DesiredSpeed, playerSpeed, distSpeedScale, playerTopSpeed;

    // End:0x1D0
    if((HasActivePlayer()) && !IsStunned())
    {
        CheckPlayerReachable();
        dist = VSize(mActivePlayer.Location - Pawn.Location);
        // End:0x6A
        if(IsTooCloseToPlayer(dist))
        {
            NotifyTooCloseToPlayer();
        }
        // End:0x1D0
        if(ShouldUseAdaptiveMoveSpeed())
        {
            playerTopSpeed = mActivePlayer.GroundSpeed / Pawn.GroundSpeed;
            playerSpeed = FMax(0.4000000 * playerTopSpeed, FMin(1.0000000, VSize2D(mActivePlayer.Acceleration) / Pawn.GroundSpeed));
            // End:0x119
            if(mMoveTarget != none)
            {
                dist = VSize2D(mMoveTarget.Location - Pawn.Location) - mMinDistToTarget;                
            }
            else
            {
                dist = VSize2D(mTargetPos - Pawn.Location) - mMinDistToTarget;
            }
            // End:0x15C
            if(dist < float(0))
            {
                distSpeedScale = 0.4000000;                
            }
            else
            {
                // End:0x185
                if(dist < float(80))
                {
                    distSpeedScale = FMin(1.0000000, dist / float(80));                    
                }
                else
                {
                    distSpeedScale = 1.0000000;
                }
            }
            DesiredSpeed = playerSpeed * distSpeedScale;
            mCurrentSteeringPreset.mMaxSpeedMult += ((DesiredSpeed - mCurrentSteeringPreset.mMaxSpeedMult) * 0.4000000);
        }
    }
    super.UpdateStatus();
    //return;    
}

function bool ShouldUseAdaptiveMoveSpeed()
{
    return mUseAdaptiveMoveSpeed;
    //return ReturnValue;    
}

function bool IsTooCloseToPlayer(float dist)
{
    // End:0x11
    if(!HasActivePlayer())
    {
        return false;
    }
    return ((dist - mActivePlayer.CylinderComponent.CollisionRadius) - Pawn.CylinderComponent.CollisionRadius) <= mTooCloseToPlayerDist;
    //return ReturnValue;    
}

function ToggleBeingUsed(int TeamIndex, @NULL followPawn)
{
    mActivePlayer = followPawn;
    mLosToActivePlayer = true;
    mTeamIndex = TeamIndex;
    UpdatePawnTeam();
    GotoActionPlanner();
    //return;    
}

event PlayerNotVisible(@NULL Player)
{
    super(TurokAIController).PlayerNotVisible(Player);
    // End:0x2D
    if((mActivePlayer == Player) && mLosToActivePlayer)
    {
        mLosToActivePlayer = false;
    }
    //return;    
}

function bool IsAvoidingFriendly()
{
    return mBumpedByFriendly;
    //return ReturnValue;    
}

function float GetBumpingPriority()
{
    return float(mMyBumpingPriority);
    //return ReturnValue;    
}

function float GetCurrentBumpingPriority()
{
    // End:0x1F
    if(IsAvoidingFriendly())
    {
        return float(Max(mCurrentBumpPriority, mMyBumpingPriority));        
    }
    else
    {
        return float(mMyBumpingPriority);
    }
    //return ReturnValue;    
}

function bool HandleBumped(@NULL Other)
{
    local bool Result;
    local float friendlyPriority;

    Result = false;
    friendlyPriority = 0.0000000;
    // End:0x31
    if(TurokPawnPlayer(Other) != none)
    {
        friendlyPriority = 100.0000000;        
    }
    else
    {
        // End:0x8D
        if((Pawn(Other) != none) && TurokAIControllerHumanFriendly(Pawn(Other).Controller) != none)
        {
            friendlyPriority = TurokAIControllerHumanFriendly(Pawn(Other).Controller).GetCurrentBumpingPriority();
        }
    }
    // End:0xF9
    if((GetCurrentBumpingPriority()) < friendlyPriority)
    {
        mCurrentBumpPriority = Max(int(friendlyPriority - float(1)), 0);
        // End:0xC6
        if(IsAvoidingFriendly())
        {            
        }
        mBumpedByFriendly = true;
        mBumpedByPawn = TurokPawn(Other);
        SetTimer(1.0000000, false, 'BumpTimeOut');
        Result = true;
    }
    return Result;
    //return ReturnValue;    
}

private final function ResetBumpState()
{
    mBumpedByFriendly = false;
    mBumpedAgainstWall = false;
    mBumpedByPawn = none;
    mCurrentBumpPriority = 0;
    ClearTimer('BumpTimeOut');
    //return;    
}

function BumpTimeOut()
{
    ResetBumpState();
    //return;    
}

function bool CanInvestigate(@NULL investigateActor, byte Priority)
{
    return false;
    //return ReturnValue;    
}

function NotifyKilled(@NULL Killer, @NULL Killed, @NULL KilledPawn)
{
    // End:0x20
    if(mActivePlayer == KilledPawn)
    {
        mActivePlayer = none;
        GotoActionPlanner();
    }
    super.NotifyKilled(Killer, Killed, KilledPawn);
    //return;    
}

event Possess(@NULL inPawn, bool bVehicleTransition)
{
    // End:0x28
    if(!Class'TurokUtil'.static.IsMultiplayerGame())
    {
        mActivePlayer = TurokPawnPlayer(FindPlayerActor());        
    }
    else
    {
        mActivePlayer = none;
    }
    super.Possess(inPawn, bVehicleTransition);
    //return;    
}

event SeeFriendlyPlayer(@NULL Player)
{
    // End:0x24
    if((mActivePlayer == Player) && !mLosToActivePlayer)
    {
        mLosToActivePlayer = true;
    }
    //return;    
}

event NotifyGoalUnreachable()
{
    local bool prevPlayerReachable;

    prevPlayerReachable = mActivePlayerReachable;
    // End:0x35
    if(!HasActivePlayer() || mActivePlayer == mMoveTarget)
    {
        mActivePlayerReachable = false;
    }
    // End:0x56
    if(prevPlayerReachable != mActivePlayerReachable)
    {
        NotifyPlayerChangedReachableStatus(mActivePlayerReachable);
    }
    super.NotifyGoalUnreachable();
    //return;    
}

simulated function CheckPlayerReachable()
{
    local bool prevPlayerReachable;

    prevPlayerReachable = mActivePlayerReachable;
    // End:0x33
    if(HasActivePlayer())
    {
        mActivePlayerReachable = CheckReachable(mActivePlayer);        
    }
    else
    {
        mActivePlayerReachable = false;
    }
    // End:0x5C
    if(prevPlayerReachable != mActivePlayerReachable)
    {
        NotifyPlayerChangedReachableStatus(mActivePlayerReachable);
    }
    //return;    
}

simulated function NotifyPlayerChangedReachableStatus(bool reachable)
{
    //return;    
}

state GoalWatchPlayer
{
    simulated function bool CheckPreconditions()
    {
        return HasActivePlayer();
        //return ReturnValue;        
    }
Begin:

    // End:0x51
    if(CheckPreconditions())
    {
        ClearSteeringWeights();
        SetSteeringValues('None');
        // End:0x44
        if(TurokPawn(Pawn) != none)
        {
            SetIdlePosture();
        }
        GoalPassedPreconditions();        
    }
    else
    {
        GoalFailedPreconditions();
    }
    stop;                    
}

state GoalFollowPlayer
{
    simulated function bool CheckPreconditions()
    {
        return HasActivePlayer();
        //return ReturnValue;        
    }

    simulated function SetupGoal()
    {
        ClearSteeringWeights();
        SetSteeringValues('None');
        // End:0x37
        if(TurokPawn(Pawn) != none)
        {
            SetIdlePosture();
        }
        //return;        
    }
Begin:

    // End:0x24
    if(CheckPreconditions())
    {
        SetupGoal();
        GoalPassedPreconditions();        
    }
    else
    {
        GoalFailedPreconditions();
    }
    stop;        
}

state GoalWait
{
    simulated function bool CheckPreconditions()
    {
        return !HasActivePlayer();
        //return ReturnValue;        
    }

    simulated function SetupGoal()
    {
        ClearSteeringWeights();
        SetSteeringValues('None');
        // End:0x37
        if(TurokPawn(Pawn) != none)
        {
            SetIdlePosture();
        }
        //return;        
    }
Begin:

    // End:0x24
    if(CheckPreconditions())
    {
        SetupGoal();
        GoalPassedPreconditions();        
    }
    else
    {
        GoalFailedPreconditions();
    }
    stop;        
}

state GoalAvoidPlayer
{
    simulated function bool CheckPreconditions()
    {
        return IsAvoidingFriendly();
        //return ReturnValue;        
    }

    simulated function SetupGoal()
    {
        ClearSteeringWeights();
        SetSteeringValues('None');
        //return;        
    }
Begin:

    // End:0x24
    if(CheckPreconditions())
    {
        SetupGoal();
        GoalPassedPreconditions();        
    }
    else
    {
        GoalFailedPreconditions();
    }
    stop;        
}

state AvoidPlayer extends MoveToTargetRange
{
    simulated function SetupPreconditions()
    {
        // End:0x2D
        if((mBumpedByFriendly && mBumpedByPawn != none) && !mBumpedAgainstWall)
        {
            CalculateAvoidPlayerMovement();
        }
        //return;        
    }

    simulated function bool CheckPreconditions()
    {
        return ((mBumpedByFriendly && mBumpedByPawn != none) && !mBumpedAgainstWall) && super.CheckPreconditions();
        //return ReturnValue;        
    }

    simulated function SetupState()
    {
        super.SetupState();
        mUseAdaptiveMoveSpeed = false;
        Pawn.bWantsToCrouch = false;
        // End:0x52
        if(TurokPawn(Pawn).mTargetingSystem.GetTarget(self) == none)
        {
            Focus = mBumpedByPawn;
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        mMoveToPosition = Pawn.Location;
        Focus = none;
        //return;        
    }

    simulated function BumpTimeOut()
    {
        ResetBumpState();
        GotoActionPlanner();
        //return;        
    }

    event SteeringTargetInRange()
    {
        ResetBumpState();
        GotoState('ActionPlanner');
        //return;        
    }

    event bool NotifyBump(@NULL Other, @NULL HitNormal)
    {
        // End:0x2C
        if(!mBumpedAgainstWall && HandleBumped(Other))
        {
            CalculateAvoidPlayerMovement();            
        }
        return super(TurokAIController).NotifyBump(Other, HitNormal);
        //return ReturnValue;        
    }

    function NotifyTooCloseToPlayer()
    {
        // End:0x2C
        if(!mBumpedAgainstWall && HandleBumped(mActivePlayer))
        {
            CalculateAvoidPlayerMovement();            
        }
        //return;        
    }

    event bool NotifyHitWall(@NULL HitNormal, @NULL Wall)
    {
        local @NULL steeringVect;

        steeringVect = Normal(GetSteer().mSteeringVector);
        mBumpedAgainstWallVect = Normal(HitNormal);
        mBumpedAgainstWall = (steeringVect Dot mBumpedAgainstWallVect) < -0.8600000;
        // End:0x55
        if(mBumpedAgainstWall)
        {
            GotoActionPlanner();
        }
        return false;
        //return ReturnValue;        
    }
    stop;    
}

state AvoidPlayerStuck extends StandFaceTarget
{
    function bool IsPushedToWall()
    {
        local @NULL bumpVect;
        local bool Result;

        Result = false;
        // End:0x7A
        if(mBumpedAgainstWall)
        {
            bumpVect = Pawn.Location;
            bumpVect -= mBumpedByPawn.Location;
            bumpVect.Z = 0.0000000;
            bumpVect = Normal(bumpVect);
            // End:0x7A
            if((bumpVect Dot mBumpedAgainstWallVect) < -0.8600000)
            {
                Result = true;
            }
        }
        return Result;
        //return ReturnValue;        
    }

    event PlayerNotVisible(@NULL Player)
    {
        global.PlayerNotVisible(Player);
        GotoActionPlanner();
        //return;        
    }

    event bool NotifyBump(@NULL Other, @NULL HitNormal)
    {
        // End:0x40
        if((mBumpedAgainstWall && HandleBumped(Other)) && !IsPushedToWall())
        {
            mBumpedAgainstWall = false;
            GotoActionPlanner();
        }
        return super(TurokAIController).NotifyBump(Other, HitNormal);
        //return ReturnValue;        
    }

    function NotifyTooCloseToPlayer()
    {
        // End:0x40
        if((mBumpedAgainstWall && HandleBumped(mActivePlayer)) && !IsPushedToWall())
        {
            mBumpedAgainstWall = false;
            GotoActionPlanner();
        }
        //return;        
    }

    event bool NotifyHitWall(@NULL HitNormal, @NULL Wall)
    {
        local @NULL steeringVect;

        steeringVect = Normal(GetSteer().mSteeringVector);
        mBumpedAgainstWallVect = Normal(HitNormal);
        mBumpedAgainstWall = (steeringVect Dot mBumpedAgainstWallVect) < -0.8600000;
        return false;
        //return ReturnValue;        
    }

    function UpdateStatus()
    {
        local float dist;
        local bool ShouldReset;

        ShouldReset = false;
        // End:0x85
        if(mBumpedByPawn != none)
        {
            dist = VSize(mBumpedByPawn.Location - Pawn.Location);
            // End:0x82
            if(dist >= ((mBumpedByPawn.CylinderComponent.CollisionRadius + Pawn.CylinderComponent.CollisionRadius) + mTooCloseToPlayerDist))
            {
                ShouldReset = true;
            }            
        }
        else
        {
            ShouldReset = true;
        }
        // End:0xA9
        if(ShouldReset)
        {
            ResetBumpState();
            GotoActionPlanner();            
        }
        super(TurokAIControllerHumanNpc).UpdateStatus();
        //return;        
    }

    simulated function SetupPreconditions()
    {
        super.SetupPreconditions();
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        mMoveTarget = mBumpedByPawn;
        ClearTimer('BumpTimeOut');
        //return;        
    }
    stop;    
}

state ReloadWeapon
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

state StandIdle
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

state BaseFriendlyMoveToTargetRange extends MoveToTargetRange
{
    simulated function SetupState()
    {
        super.SetupState();
        mUseAdaptiveMoveSpeed = false;
        Pawn.bWantsToCrouch = false;
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

    event SteeringTargetInRange()
    {
        GotoActionPlanner();
        //return;        
    }
    stop;    
}

state BaseFriendlyFollowPlayer extends BaseFriendlyMoveToTargetRange
{
    simulated function bool CheckPreconditions()
    {
        return super(MoveToTargetRange).CheckPreconditions() && HasValidActivePlayer();
        //return ReturnValue;        
    }

    simulated function SetupPreconditions()
    {
        super(MoveToTargetRange).SetupPreconditions();
        mMoveTarget = mActivePlayer;
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        //return;        
    }

    simulated function SetupState()
    {
        super.SetupState();
        mUseAdaptiveMoveSpeed = true;
        //return;        
    }
    stop;    
}

state MoveToPlayerRange extends BaseFriendlyFollowPlayer
{
    simulated function SetupPreconditions()
    {
        super.SetupPreconditions();
        mMinDistToTarget = mWaitForPlayerDist;
        //return;        
    }
    stop;    
}

state MoveToPlayerLos extends BaseFriendlyFollowPlayer
{
    simulated function SetupPreconditions()
    {
        super.SetupPreconditions();
        mMinDistToTarget = mWaitForPlayerDist;
        //return;        
    }

    simulated function bool CheckPreconditions()
    {
        return !mLosToActivePlayer && super.CheckPreconditions();
        //return ReturnValue;        
    }

    event SeeFriendlyPlayer(@NULL Player)
    {
        global.SeeFriendlyPlayer(Player);
        // End:0x22
        if(mLosToActivePlayer)
        {
            GotoActionPlanner();
        }
        //return;        
    }
    stop;    
}

state MoveToSpawnPoint extends MoveToTargetRange
{
    simulated function SetupState()
    {
        super.SetupState();
        Pawn.bWantsToCrouch = false;
        //return;        
    }

    simulated function SetupPreconditions()
    {
        super.SetupPreconditions();
        mMoveTarget = none;
        mTargetPos = mSpawnLocation;
        mMinDistToTarget = mMoveToMinDist;
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
    mActivePlayerReachable=true
    mWaitForPlayerDist=240.0000000
    mTooCloseToPlayerDist=48.0000000
    mSpeechBBSpeaking="None"
    mSpeechBBAttackHuman="None"
    mSpeechBBAttackDino="None"
    mSpeechBBAttackBug="None"
    mSpeechBBGrenadeThrow="None"
    mSpeechBBNeedAssistance="None"
    mSpeechBBCover="None"
    mSpeechBBHit="None"
    mSpeechBBFriendKilled="None"
    mSpeechBBEnemyKilled="None"
    mSpeechBBInvestigateGunFireShort="None"
    mSpeechBBInvestigateGunFireLong="None"
    mSpeechBBInvestigateFootsteps="None"
    mSpeechBBInvestigateCorpse="None"
    mSpeechBBRequestAssistance="None"
    mSpeechBBAreaSecure="None"
    mSpeechBBIdleChatter="None"
    mSpeechBBEnemyNotVisible="None"
    mSpeechBBEnemySpottedShort="None"
    mSpeechBBEnemySpottedLong="None"
    mPlannerDebug="AIPlannerFriendly"
    // Reference: SpriteComponent'Default__TurokAIControllerHumanFriendly.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}