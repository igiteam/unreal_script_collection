/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ToggleWorldEventsAffectingChaos extends SequenceAction;



static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}


/**
 * Called when this event is activated.
 */
event Activated()
{
	local SeqVar_Object ObjVar;
	local NanoChaosZoneInfo ChaosZoneInfo;
	local ChaosPacifismManager CM;

	// find the possibly linked ChaosZoneInfo 
	foreach LinkedVariables( class'SeqVar_Object', ObjVar, "NanoChaosZoneInfo" )
	{
		ChaosZoneInfo = NanoChaosZoneInfo(ObjVar.GetObjectValue());
	}	

    CM = ChaosZoneInfo != None ? ChaosZoneInfo.ChaosManager : NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetCurrentChaosManager();

	if( CM != None )
	{
		if( InputLinks[0].bHasImpulse == TRUE )
		{
			CM.bWorldEventsAffectChaos = TRUE;
		}
		else if( InputLinks[1].bHasImpulse == TRUE )
		{
			CM.bWorldEventsAffectChaos = FALSE;
		}
		else if( InputLinks[2].bHasImpulse == TRUE )
		{
			CM.bWorldEventsAffectChaos = !CM.bWorldEventsAffectChaos;
		}
	}
}



defaultproperties
{
	ObjName="Toggle World Events Affecting Chaos"
	ObjCategory="Nano Procedural"

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="NanoChaosZoneInfo",PropertyName=Targets,MaxVars=1)
    bCallHandler=FALSE

	InputLinks(0)=(LinkDesc="Enable")
	InputLinks(1)=(LinkDesc="Disable")
	InputLinks(2)=(LinkDesc="Toggle")
}