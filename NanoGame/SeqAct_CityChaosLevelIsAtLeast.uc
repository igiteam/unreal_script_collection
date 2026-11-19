/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_CityChaosLevelIsAtLeast extends SequenceAction;

/** Chaos Tier to look for.**/
var() EChaosTier Tier;


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

    CM = ChaosZoneInfo != none ? ChaosZoneInfo.ChaosManager : NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetCurrentChaosManager();

	if( ( CM != none ) && ( CM.GetChaosTier() >= Tier ) )
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
	ObjName="City Chaos Level Is AtLeast"
	ObjCategory="Nano Procedural"

	bAutoActivateOutputLinks=FALSE

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="NanoChaosZoneInfo",PropertyName=Targets,MaxVars=1)
    bCallHandler=FALSE

	OutputLinks(0)=(LinkDesc="Yes")
	OutputLinks(1)=(LinkDesc="No")
}