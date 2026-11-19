/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GameplayCam_Crouch extends GameplayCam_Default
	config(Camera);

defaultproperties
{
	ViewOffsetAdjustment_Evade=(Z=-20)

	ViewOffset={(
		OffsetHigh=(X=-125,Y=56,Z=0),
		OffsetMid=(X=-192,Y=48,Z=-15),
		OffsetLow=(X=-125,Y=56,Z=50),
	)}
}
