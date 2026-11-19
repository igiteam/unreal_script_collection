/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoVehicleSpline_ParkingSpot extends NanoVehicleSpline
	native(Inherit);

cpptext
{
	/** Prevent this from connecting to any other splines.  Parking spots should be on their own! */
	void AddConnectionTo(ASplineActor* NextActor);
};

simulated function bool CanAcceptNewSpawnedVehicles()
{
	return (VehiclesOnSpline.Length == 0);
}

/** Only allow one vehicle per parking space */
simulated event bool IsValidSplineForVehicle(NanoVehicleAgent Vehicle)
{
  	if( VehiclesOnSpline.Length > 0 )
  	{
  		return FALSE;
  	}
  	else
  	{
		return Super.IsValidSplineForVehicle(Vehicle);
	}
}

defaultproperties
{
	DeformMesh=None
	BoundaryMesh=None

	bFlyingVehiclesOnly=TRUE

	LaneWidth=342.f
}