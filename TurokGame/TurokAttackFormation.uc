class TurokAttackFormation extends ActorComponent
    native
    hidecategories(Actor,Object,ActorComponent);

var() float mSpacing;
var() float mStartDistance;
var() @NULL mAngle;
var() int mRankNumbers;
var() float mUpdatePeriod;
var() float mGoalRadius;
var private transient @NULL mPosition;
var private transient int mTargetIndex;
var private transient @NULL mMoveTarget;
var private transient @NULL mFormationCenter;
var() private transient bool mDebug;

// Export UTurokAttackFormation::execUpdate(FFrame&, void* const)
native function Update(@NULL TargetActor, optional float DeltaTime);

function @NULL GetPosition()
{
    return mPosition;
    //return ReturnValue;    
}

function @NULL GetMoveTarget()
{
    return mMoveTarget;
    //return ReturnValue;    
}

function float GetGoalRadius()
{
    return mGoalRadius;
    //return ReturnValue;    
}

defaultproperties
{
    mSpacing=300.0000000
    mAngle=(Pitch=0,Yaw=16384,Roll=0)
    mRankNumbers=3
    mUpdatePeriod=1.0000000
    mGoalRadius=200.0000000
}