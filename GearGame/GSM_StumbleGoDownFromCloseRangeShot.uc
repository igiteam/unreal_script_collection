
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_StumbleGoDownFromCloseRangeShot extends GSM_StumbleGoDownFromExplosion
	config(Pawn);

defaultproperties
{
	BS_DropAnimation=(Stance=((Slot=BS_FullBody,AnimName="AR_Injured_Drop")))
	BS_Idle=(Stance=((Slot=BS_FullBody,AnimName="AR_Injured_Idle")))
}
