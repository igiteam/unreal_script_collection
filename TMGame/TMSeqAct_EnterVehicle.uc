/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMSeqAct_EnterVehicle extends SequenceAction;

/** index of the seat of the vehicle the bot should use, or -1 for auto-select */
var() int SeatIndex;

event Activated()
{
	local SeqVar_Object ObjVar;
	local Pawn Target;
	local TMVehicle TheVehicle;
	local TMVehicleFactory Factory;

	foreach LinkedVariables(class'SeqVar_Object', ObjVar, "Vehicle/Vehicle Factory")
	{
		TheVehicle = TMVehicle(ObjVar.GetObjectValue());
		if (TheVehicle == None)
		{
			Factory = TMVehicleFactory(ObjVar.GetObjectValue());
			if (Factory != None)
			{
				TheVehicle = TMVehicle(Factory.ChildVehicle);
			}
		}
		if (TheVehicle != None)
		{
			break;
		}
	}
	if (TheVehicle == None)
	{
		ScriptLog("WARNING: Vehicle variable for" @ self @ "is empty");
	}
	else
	{
		// get the pawn(s) that should enter the vehicle
		foreach LinkedVariables(class'SeqVar_Object', ObjVar, "Target")
		{
			Target = GetPawn(Actor(ObjVar.GetObjectValue()));
			if (Target != None)
			{
				// use selected seat if valid and empty, otherwise use main driver if empty, and finally use the first available seat
				if ((SeatIndex <= 0 || SeatIndex >= TheVehicle.Seats.length) && TheVehicle.Driver == None)
				{
					TheVehicle.DriverEnter(Target);
				}
				else if (SeatIndex > 0 && SeatIndex < TheVehicle.Seats.length && TheVehicle.SeatAvailable(SeatIndex))
				{
					TheVehicle.PassengerEnter(Target, SeatIndex);
				}
				else if (TheVehicle.Driver == None)
				{
					TheVehicle.DriverEnter(Target);
				}
				else
				{
					TheVehicle.PassengerEnter(Target, TheVehicle.GetFirstAvailableSeat());
				}
			}
		}
	}
}

