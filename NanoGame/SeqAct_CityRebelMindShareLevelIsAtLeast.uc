/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_CityRebelMindShareLevelIsAtLeast extends SequenceAction;

/** Chaos Amount to look for.**/
var() int Amount;



static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}


/**
* Called when this event is activated.
*/
event Activated()
{
	local SeqVar_Object ObjVar;
	local NanoRebelMindShareZoneInfo MindShareZoneInfo;
	local RebelMindShareManager RMSM;

	// find the possibly linked ChaosZoneInfo 
	foreach LinkedVariables( class'SeqVar_Object', ObjVar, "NanoRebelMindShareZoneInfo" )
	{
		MindShareZoneInfo = NanoRebelMindShareZoneInfo(ObjVar.GetObjectValue());
	}	

	RMSM = MindShareZoneInfo != none ? MindShareZoneInfo.MindShareManager : NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetCurrentRebelMindShareManager();

	if( ( RMSM != none ) && ( RMSM.GetRebelMindShareLevel() >= Amount ) )
	{
		ActivateOutputLink( 0 ); // Yes, enough chaos
	}
	else
	{
		ActivateOutputLink( 1 ); // No, not enough chaos
	}	
}



defaultproperties
{
	ObjName="City Rebel Mind Share Level Is AtLeast"
	ObjCategory="Nano Procedural"

	bAutoActivateOutputLinks=FALSE

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="NanoRebelMindShareZoneInfo",PropertyName=Targets,MaxVars=1)
    bCallHandler=FALSE

	OutputLinks(0)=(LinkDesc="Yes")
	OutputLinks(1)=(LinkDesc="No")
}