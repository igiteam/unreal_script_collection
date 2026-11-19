/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ModifyCityRebelMindShareLevel extends SequenceAction;

/** Amount of mind share to increase/decrease by **/
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

	if( RMSM != none )
	{
		RMSM.AddRebelMindShareLevel( Amount );
	}	
}



defaultproperties
{
	ObjName="Modify City Rebel Mind Share Level"
	ObjCategory="Nano Procedural"

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="NanoRebelMindShareZoneInfo",PropertyName=Targets,MaxVars=1)
    bCallHandler=FALSE
}