/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
 
class SeqAct_SetVehicleDestination extends SequenceAction;

/** Destination spline node that vehicle should move toward */
var NanoVehicleSpline   Destination;

defaultproperties
{
	ObjName="Set Vehicle Destination"
	ObjCategory="Nano"
	
	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Destination",PropertyName=Destination,MaxVars=1)
}