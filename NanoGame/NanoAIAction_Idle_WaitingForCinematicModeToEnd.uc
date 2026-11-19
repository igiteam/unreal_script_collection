/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_Idle_WaitingForCinematicModeToEnd extends NanoAIAction_IdleBase within NanoAI_Trooper;



static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;
	local NanoGRI NGRI;

	NGRI = NanoGRI(InAI.WorldInfo.GRI);

	// if the worldstate has been told that ai should be waiting for the cinematic to finish
	if( NGRI.WorldStateSettings.bCinematicAndAIShouldBeIdle == TRUE )
	{
		Retval = class'NanoAIAction_RunAwayBase'.default.UtilityStartVal + 1000;
	}

	return Retval;
}



state Idle
{

Begin:
	`AILog( GetStateName()@"Begin TAG" );

	Sleep(1.f);
	Goto('Begin');
}



defaultproperties
{
	StartingStateName="Idle"
}