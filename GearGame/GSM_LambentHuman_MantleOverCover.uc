
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_LambentHuman_MantleOverCover extends GSM_NonCoverUserMantleOverCover;

/** Overridden to always push other lambent humans out of the way and allow the mantle */
protected function bool HandleHitActor(Actor HitActor, bool bIsAI, vector HitLocation, optional vector StartDownTrace, out optional INT bHitSomethingHoriz)
{
	local GearPawn_LambentHumanBase OtherLambentHuman;

	OtherLambentHuman = GearPawn_LambentHumanBase(HitActor);

	// Ignore other lambent humans
	if( HitActor.Role == ROLE_Authority && 
		OtherLambentHuman != None &&
		OtherLambentHuman.Health > 0 && 
		HitActor.bBlockActors && 
		!HitActor.bTearOff )
	{
		AIsToPushOutOfDestination.AddItem(OtherLambentHuman);
		return true;
	}
	return Super.HandleHitActor(HitActor, bIsAI, HitLocation, StartDownTrace, bHitSomethingHoriz);
}

defaultproperties
{
	bCheckForMirrorTransition=false
	DefaultMantleDistance=140.f
	FallForwardVelocity=300.f
	GravityScale=2.f

	BSList_Jump(0)=(Stance=((Slot=BS_FullBody,AnimName="Mantle_Start")))
	BSList_Fall(0)=(Stance=((Slot=BS_FullBody,AnimName="Mantle_Mid")))
	BSList_Land(0)=(Stance=((Slot=BS_FullBody,AnimName="Mantle_End")))
}
