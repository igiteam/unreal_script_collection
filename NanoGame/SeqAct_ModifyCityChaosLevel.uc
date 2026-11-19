/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ModifyCityChaosLevel extends SequenceAction;

/** Amount of chaos to increase/decrease by **/
var() NanoCausingChaosValueDatum Chaos;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 50;
}


/**
 * Called when this event is activated.
 */
event Activated()
{
	//local SeqVar_Object ObjVar;
	//local NanoChaosZoneInfo ChaosZoneInfo;
	local ChaosPacifismManager CM;

	// for now just don't use the Attached ChaosZoneInfo as we want a global chaos level anyways
	// find the possibly linked ChaosZoneInfo 
	//foreach LinkedVariables( class'SeqVar_Object', ObjVar, "NanoChaosZoneInfo" )
	//{
	//	ChaosZoneInfo = NanoChaosZoneInfo(ObjVar.GetObjectValue());
	//}	

    //CM = ChaosZoneInfo != none ? ChaosZoneInfo.ChaosManager : NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetCurrentChaosManager();

	CM = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetCurrentChaosManager();;

	if( CM != none )
	{
		CM.ModifyChaosLevel( GetWorldInfo(), Chaos );
	}	
}



defaultproperties
{
	ObjName="Modify City Chaos Level"
	ObjCategory="Nano Procedural"

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="NanoChaosZoneInfo",PropertyName=Targets,MaxVars=1)
    bCallHandler=FALSE
}