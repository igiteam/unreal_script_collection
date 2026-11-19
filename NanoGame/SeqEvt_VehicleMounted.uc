/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqEvt_VehicleMounted extends SequenceEvent;

/** The vehicle the pawn mounted / dismounted.  Because of the varying times when the event is activated, this has to be set manually, since it is not always the Instigator's base */
var transient editconst NanoVehicleAgent Vehicle;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

defaultproperties
{
	ObjName="Vehicle Mounted"
	ObjCategory="Nano"
	
	OutputLinks(0)=(LinkDesc="Car Mounted")
	OutputLinks(1)=(LinkDesc="Car Unmounted")
	OutputLinks(2)=(LinkDesc="Elevator Mounted")
	OutputLinks(3)=(LinkDesc="Elevator Unmounted")
	
	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Vehicle",PropertyName=Vehicle,bWriteable=true)

	bPlayerOnly=FALSE
	
	MaxTriggerCount=0
}