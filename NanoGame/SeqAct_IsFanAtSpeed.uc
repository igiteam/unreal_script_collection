/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_IsFanAtSpeed extends SequenceAction
	dependson(NanoFanBase);


var() EFanSpeed FanSpeed;


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
	local bool bAllFansAtRequiredSpeed;
	local NanoFanBase NFB;

	// find the possibly linked NanoFanBase 
	foreach LinkedVariables( class'SeqVar_Object', ObjVar, "NanoFanBase" )
	{
		NFB = NanoFanBase(ObjVar.GetObjectValue());

		if( NFB.FanSpeed_Curr == FanSpeed )
		{
			bAllFansAtRequiredSpeed = TRUE;
		}
		// if any in our list are not at the correct speed then break out
		else
		{
			bAllFansAtRequiredSpeed = FALSE;
			break;
		}
	}	


	if( bAllFansAtRequiredSpeed == TRUE )
	{
		ActivateOutputLink( 0 ); // Yes
	}
	else
	{
		ActivateOutputLink( 1 ); // No
	}	
}



defaultproperties
{
	ObjName="Is Fan Speed At"
	ObjCategory="Nano"

	OutputLinks(0)=(LinkDesc="Yes")
	OutputLinks(1)=(LinkDesc="No")

	bAutoActivateOutputLinks=FALSE

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="NanoFanBase",PropertyName=Targets)
    bCallHandler=FALSE

}
