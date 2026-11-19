/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ToggleProceduralSpawning extends SequenceAction;



static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 3;
}


/**
 * Called when this event is activated.
 */
event Activated()
{
	local NanoProceduralEnemySpawner NPES;
	local NanoEncounterDirector NED;
	local NanoProceduralMissionManager NPMM;


	NPES = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).NPES;
	NED = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).NED;
	NPMM = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).NPMM;

    if( NPES != none )
	{
		if( InputLinks[0].bHasImpulse == TRUE )
		{
			NPES.bActive = TRUE;
			NED.bActive = TRUE;
			NPMM.bActive = TRUE;
		}
		else if( InputLinks[1].bHasImpulse == TRUE )
		{
			NPES.bActive = FALSE;
			NED.bActive = FALSE;
			NPMM.bActive = FALSE;
		}
		else if( InputLinks[2].bHasImpulse == TRUE )
		{
			NPES.bActive = !NPES.bActive;
			NED.bActive = !NED.bActive;
			NPMM.bActive = !NPMM.bActive;
		}
	}
}



defaultproperties
{
	ObjName="Toggle Procedural Spawning"
	ObjCategory="Nano Procedural"

	VariableLinks.Empty();
    bCallHandler=FALSE

	InputLinks(0)=(LinkDesc="Enable")
	InputLinks(1)=(LinkDesc="Disable")
	InputLinks(2)=(LinkDesc="Toggle")
}