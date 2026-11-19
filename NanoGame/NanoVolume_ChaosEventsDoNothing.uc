/**
 * Copyright 1998-2010 Epic Games, Inc. All Rights Reserved.
 */
class NanoVolume_ChaosEventsDoNothing extends Volume
	placeable;

event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	local NanoPawn NP;

	Super.Touch(Other, OtherComp, HitLocation, HitNormal);

	NP = NanoPawn(Other);
	if(NP != None)
	{
		//`log( "NanoVolume_ChaosEventsDoNothingNanoVolume_ChaosEventsDoNothingNanoVolume_ChaosEventsDoNothing TOUCH TOUCH TOUCH" );
		NanoGRI(WorldInfo.GRI).GetCurrentChaosManager().UpdateChaosEventsDoNothing();
	}
}

event UnTouch(Actor Other)
{
	local NanoPawn NP;

	Super.UnTouch(Other);

	NP = NanoPawn(Other);
	if(NP != None)
	{
		//`log( "NanoVolume_ChaosEventsDoNothingNanoVolume_ChaosEventsDoNothingNanoVolume_ChaosEventsDoNothing UNTOUCH UNTOUCH UNTOUCH" );
		NanoGRI(WorldInfo.GRI).GetCurrentChaosManager().UpdateChaosEventsDoNothing();
	}
}

defaultproperties
{
	//bWorldGeometry=FALSE

	bColored=TRUE
	BrushColor=(R=255,G=128,B=128,A=255)
};