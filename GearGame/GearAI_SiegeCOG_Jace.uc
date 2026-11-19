/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAI_SiegeCOG_Jace extends GearAI_SiegeCOG;

var float LastDefiantYellTime;

function GearAINotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> DamageType, vector Momentum, const out TraceHitInfo HitInfo)
{
	Super.GearAINotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum, HitInfo);

	if (MyGearPawn != None && GetHealthPercentage() < 0.5 && WorldInfo.TimeSeconds - LastDefiantYellTime > 15.0)
	{
		GearPawn_COGGear(MyGearPawn).PlayDefiantYell();
	}
}
