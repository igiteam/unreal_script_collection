/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoVolume_ChaosCooldown extends Volume
	placeable;

event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	local NanoPawn NP;

	Super.Touch(Other, OtherComp, HitLocation, HitNormal);

	NP = NanoPawn(Other);
	if(NP != None)
	{
		// Make sure people are not running away from us any more
		NP.ClearCrowdPanic();
		// And tell 
		NanoGRI(WorldInfo.GRI).GetCurrentChaosManager().UpdateChaosCooldownStatus();
	}
}

event UnTouch(Actor Other)
{
	local NanoPawn NP;

	Super.UnTouch(Other);

	NP = NanoPawn(Other);
	if(NP != None)
	{
		NanoGRI(WorldInfo.GRI).GetCurrentChaosManager().UpdateChaosCooldownStatus();
	}
}

defaultproperties
{
	//bWorldGeometry=FALSE

	bColored=TRUE
	BrushColor=(R=255,G=128,B=128,A=255)
};