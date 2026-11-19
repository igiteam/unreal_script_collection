/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPawn_MetaCorp_SentryBotSuper extends NanoPawn_MetaCorp_SentryBot;


defaultproperties
{


	Begin Object Name=NanoPawnMesh
	    Scale3D=(X=2,Y=2,Z=2)
	End Object


	GroundSpeed=400
	PeripheralVision=0.1f

	TickFrequencyDecreaseDistanceStart=5000
	TickFrequencyDecreaseDistanceEnd=10000
	TickFrequencyAtEndDistance=0.19
}
