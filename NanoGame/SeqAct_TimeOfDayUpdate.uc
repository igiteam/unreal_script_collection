/**
 * This lets the gameplay code know what time it is
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_TimeOfDayUpdate extends SequenceAction
	config(Game);

/** Based on the time of day we will modify what percentage of max peds are allowed **/
var config array<float> TimeOfDayPedestrianPercentage;

/** Based on the time of day we will modify what percentage of max peds are allowed **/
var config array<float> TimeOfDayVehiclePercentage;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}



/**
 * Called when this event is activated.
 */
event Activated()
{
	local NanoGRI NGRI;
	local NanoCrowd_PopulationManager PopMgr;

	NGRI = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI);


	if( InputLinks[0].bHasImpulse == TRUE )
	{
		NGRI.TimeOfDay = ETOD_Sunrise;
	}
	else if( InputLinks[1].bHasImpulse == TRUE )
	{
		NGRI.TimeOfDay = ETOD_Morning;
	}
	else if( InputLinks[2].bHasImpulse == TRUE )
	{
		NGRI.TimeOfDay = ETOD_Noon;
	}
	else if( InputLinks[3].bHasImpulse == TRUE )
	{
		NGRI.TimeOfDay = ETOD_Afternoon;
	}
	else if( InputLinks[4].bHasImpulse == TRUE )
	{
		NGRI.TimeOfDay = ETOD_Sunset;
	}
	else if( InputLinks[5].bHasImpulse == TRUE )
	{
		NGRI.TimeOfDay = ETOD_Night;
	}
	else if( InputLinks[6].bHasImpulse == TRUE )
	{
		NGRI.TimeOfDay = ETOD_Midnight;
	}
	else if( InputLinks[7].bHasImpulse == TRUE )
	{
		NGRI.TimeOfDay = ETOD_MiddleOfNight;
	}


	// now update the various managers
	NGRI.GroundVehiclePopMgr.SpawnNum = class'NanoVehiclePopulationManager'.default.SpawnNum * TimeOfDayVehiclePercentage[NGRI.TimeOfDay];
	//`log( "Setting new Vehicle SpawnNum" @ `showvar(NGRI.GroundVehiclePopMgr.SpawnNum) @ `showvar(NGRI.TimeOfDay) @ `showvar(TimeOfDayVehiclePercentage[NGRI.TimeOfDay]) );


	// turn off population manager(s)
	ForEach NGRI.DynamicActors( class'NanoCrowd_PopulationManager', PopMgr )
	{
		PopMgr.SpawnNum = class'NanoVehiclePopulationManager'.default.SpawnNum * TimeOfDayPedestrianPercentage[NGRI.TimeOfDay];
		//`log( "Setting new crowd SpawnNum" @ `showvar(PopMgr.SpawnNum) @ `showvar(NGRI.TimeOfDay) @ `showvar(TimeOfDayPedestrianPercentage[NGRI.TimeOfDay]) ); 
	}

}




defaultproperties
{
	ObjName="Time Of Day Update"
	ObjCategory="Nano Procedural"

	VariableLinks.Empty()
	bCallHandler=FALSE

	InputLinks.Empty()
	InputLinks(0)=(LinkDesc="Sunrise")
	InputLinks(1)=(LinkDesc="Morning")
	InputLinks(2)=(LinkDesc="Noon")
	InputLinks(3)=(LinkDesc="Afternoon")
	InputLinks(4)=(LinkDesc="Sunset")
	InputLinks(5)=(LinkDesc="Night")
	InputLinks(6)=(LinkDesc="Midnight")
	InputLinks(7)=(LinkDesc="MiddleOfNight")
}


