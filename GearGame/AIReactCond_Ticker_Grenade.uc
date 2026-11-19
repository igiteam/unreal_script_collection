/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
/** Grenade Reaction - listens for Projectile Warnings **/
class AIReactCond_Ticker_Grenade extends AIReactCond_Grenade
	within GearAI_NakedTicker;

event bool ShouldActivate( Actor DmgInst, AIReactChannel OrigChan )
{
	if( MyGearPawn == None ||
		MyGearPawn.IsDoingASpecialMove() ||
		MyGearPawn.Health <= 0 ||
		MyGearPawn.IsDBNO() ||
		IsFriendlyPawn(DmgInst.Instigator) ||
		!bAllowCombatTransitions )
	{
		return false;
	}

	return true;
}

event Activate( Actor EventInstigator, AIReactChannel OriginatingChannel )
{
	local float Dist;
	local GearPawn_LocustNakedTickerBase TickerPawn;
	local GearProj_Grenade Grenade;

	Grenade = GearProj_Grenade(EventInstigator);
	TickerPawn = GearPawn_LocustNakedTickerBase(MyGearPawn);

	//debug
	`AILog( GetFuncName()@Grenade@VSize2D(MyGearPawn.Location - Grenade.Location)@(Grenade.DamageRadius)@FastTrace( MyGearPawn.Location, Grenade.Location ) );

	//MyGearPawn.FlushPersistentDebugLines();
	//MyGearPawn.DrawDebugLine(MyGearPawn.Location, Grenade.Location, 0, 255, 0, TRUE);

	Dist = VSizeSq(MyGearPawn.Location - Grenade.Location);
	if( Dist < Grenade.DamageRadius * Grenade.DamageRadius * 8.f && 
		FastTrace(MyGearPawn.Location, Grenade.Location) )
	{
		if( !TickerPawn.bEatenPickup && !Outer.bSeekingPickup && CanEatGrenade(Grenade) )
		{
			class'AICmd_Ticker_PickupWeapon'.static.PickupLiveGrenade(Outer, Grenade);
		}
	}
}


defaultproperties
{
	AutoSubscribeChannels(0)=WarnProjExplode
}
