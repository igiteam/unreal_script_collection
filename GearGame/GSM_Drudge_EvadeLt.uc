
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_Drudge_EvadeLt extends GSM_EvadeLt;

simulated function bool HasEndingAnim()
{
	return FALSE;
}   

defaultproperties
{
	BS_EvadeStart_NonMirrored=(Stance=((Slot=BS_FullBody,AnimName="evade_left")))
}
