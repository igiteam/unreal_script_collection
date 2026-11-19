///////////////////////////////////////////////////////////////////////////////
// IdleAimAroundGoal.uc - IdleAimAroundGoal class
// this low priority goal is a permanent goal that causes the AI to look in a different
// location every once in a while

class IdleAimAroundGoal extends AimAroundGoal;
///////////////////////////////////////////////////////////////////////////////

// @NOTE: The idle aim around goal should not procedurally use the upper body!

///////////////////////////////////////////////////////////////////////////////

















// Decompiled with UE Explorer.
defaultproperties
{
    ExtraDoorWeight=0.3330000
    bUseUpperBodyProcedurally=false
    bAimOnlyIfCharacterResourcesAvailable=true
    UpperBodyAnimBehaviorClientId=3
    bInitialDelay=true
    MinInitialDelayTime=2.0000000
    DefaultInnerFovDegrees=120.0000000
    DefaultOuterFovDegrees=360.0000000
    DefaultMinAimAtPointTime=5.0000000
    DefaultMaxAimAtPointTime=10.0000000
    DefaultMinWaitForNewPointTime=1.0000000
    DefaultMaxWaitForNewPointTime=3.0000000
    Priority=30
    goalName="IdleAimAround"
    bPermanent=true
}