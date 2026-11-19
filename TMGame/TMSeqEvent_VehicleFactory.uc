/**
 *
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */


class TMSeqEvent_VehicleFactory extends SequenceEvent;

/** reference to the vehicle spawned by the factory */
var HDVehicleBase SpawnedVehicle;

event Activated()
{
	if (TMVehicleFactory(Originator) != None)
	{
		SpawnedVehicle = TMVehicleFactory(Originator).ChildVehicle;
	}
}

