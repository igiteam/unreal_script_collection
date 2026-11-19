/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GameplayCam_ZiplineTargeting extends GameplayCam_Zipline
	config(Camera);

defaultproperties
{
	ViewOffset={(
		OffsetHigh=(X=-40,Y=40,Z=24),
		OffsetLow=(X=-125,Y=45,Z=20),
		OffsetMid=(X=-70,Y=40,Z=6),
		)}
}

