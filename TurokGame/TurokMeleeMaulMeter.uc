class TurokMeleeMaulMeter extends ActorComponent
    native
    hidecategories(Actor,Object,ActorComponent);

var(MaulMeter) const float mTimeToFill;
var(MaulMeter) const float mMinDistanceAway;
var(MaulMeter) const float mMinTimeBetweenAttacks;
var(MaulMeter) transient float mElapsedTime;
var(MaulMeter) float mTimeSinceLastAttack;

// Export UTurokMeleeMaulMeter::execTickMeter(FFrame&, void* const)
native function TickMeter(float DeltaTime, @NULL primaryPawn, @NULL secondaryPawn);

event bool IsMeterFull(@NULL attacker)
{
    return (mElapsedTime >= (mTimeToFill * attacker.mMaulTimeToFillScalar)) && mTimeSinceLastAttack > (mMinTimeBetweenAttacks * attacker.mMaulTimeBetweenAttacksScalar);
    //return ReturnValue;    
}

event ResetMeter()
{
    mTimeSinceLastAttack = 0.0000000;
    mElapsedTime = 0.0000000;
    //return;    
}

defaultproperties
{
    mTimeToFill=2.5000000
    mMinDistanceAway=650.0000000
    mMinTimeBetweenAttacks=10.0000000
    TickGroup=3
}