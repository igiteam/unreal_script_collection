/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
/** will trigger when we notice an enemy who is within range, and visible **/
class AIReactCond_LambentHuman_ShouldProwl extends AIReactCond_GenericPushCommand within GearAI_LambentHuman;

/** Minimum range from enemy for a pounce */
var() float DistanceThreshold;
/** Next time we should check activation */
var float NextCheckActivateTime;
/** Range of timer interval to use for checking activation */
var() Vector2d TimerCheckActivateIntervalRange;

event Initialize()
{
	Super.Initialize();
	NextCheckActivateTime = WorldInfo.TimeSeconds + RandRange(TimerCheckActivateIntervalRange.X, TimerCheckActivateIntervalRange.Y);
}

event bool ShouldActivate( Actor EventInstigator, AIReactChannel OrigChan )
{
	if( NextCheckActivateTime < WorldInfo.TimeSeconds )
	{
		NextCheckActivateTime = WorldInfo.TimeSeconds + RandRange(TimerCheckActivateIntervalRange.X, TimerCheckActivateIntervalRange.Y);
		return ( Enemy != None &&
				!MyGearPawn.IsDoingASpecialMove() &&
				 MyGearPawn.CanDoSpecialMove(GSM_Former_Prowl, TRUE) &&
				 Super.ShouldActivate(EventInstigator, OrigChan) && 
				 VSizeSq(Enemy.Location - Pawn.Location) > DistanceThreshold * DistanceThreshold);
	}
	return false;
}

defaultproperties
{
	TimerInterval=2.0f
	TimerCheckActivateIntervalRange=(X=2.f,Y=12.f)
	DistanceThreshold=400.0f
	AutoSubscribeChannels(0)=Timer
}
