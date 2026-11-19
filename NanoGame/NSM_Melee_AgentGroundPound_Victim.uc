
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
 class NSM_Melee_AgentGroundPound_Victim extends NSM_Melee_DropTheHammer_Victim;

var config protected float GroundPoundThrowForceImparted;
var config protected float GroundPoundThrowForceImpartedVertical;

var config protected float GroundPoundThrowForceImpartedPlayer;
var config protected float GroundPoundThrowForceImpartedVerticalPlayer;

function InitThrowVars( out float out_ThrowSpeed, out float out_ThrowZ )
{
	// check for player or ai
	if( MyNP.IsHumanControlled() )
	{
		out_ThrowSpeed  = GroundPoundThrowForceImpartedPlayer;
		out_ThrowZ      = GroundPoundThrowForceImpartedVerticalPlayer;
	}
	else
	{
		out_ThrowSpeed  = GroundPoundThrowForceImparted;
		out_ThrowZ      = GroundPoundThrowForceImpartedVertical;
	}
}

defaultproperties
{
}