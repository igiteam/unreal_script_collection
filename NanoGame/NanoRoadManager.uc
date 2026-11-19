/** 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * 
 * Manager class that manages and updates the roads, dealing with road material colour, and vehicle reservations
 */

class NanoRoadManager extends Actor
	native(Vehicle);

/** List of all nano vehicle meshes in the city, so we can show / hide them all at once */
var transient array<NanoVehicleSpline>  VehicleRoadSplines;

enum ENanoRoadStatus
{
	ENRS_OnRoad,
	ENRS_OffRoad,
	ENRS_WrongWay
};

/** Current status of the road network */
var ENanoRoadStatus  CurrentRoadStatus;

/** Color the road should be for each road status */
var() LinearColor   RoadStatusColors[ENanoRoadStatus.ENRS_MAX];

/** Rate at which to blend between road colors */
var() float         RoadColorBlendRate;

/** Current color of the road */
var transient LinearColor RoadColorCurrent;
/** Desired color of the road */
var transient LinearColor RoadColorTarget;

/** How often to recalculate the distance from the spline mesh to the player, for vehicle tick throttling purposes */
var float UpdateDistanceToPlayerInterval;

cpptext
{
	virtual void TickSpecial(FLOAT DeltaSeconds);
};

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	RoadColorTarget = RoadStatusColors[CurrentRoadStatus];
}

/**
* Notification that we have a vehicle road mesh
* Server and client both.
*/
simulated function RegisterVehicleSpline( NanoVehicleSpline NVS )
{
	local NanoGRI NGRI;

	if( NVS != None )
	{
		VehicleRoadSplines[VehicleRoadSplines.Length] = NVS;

		// Register this with the appropriate population manager
		NGRI = NanoGRI(WorldInfo.GRI);
		if( NVS.bFlyingVehiclesOnly )
		{
			// Register with the air vehicle manager, spawning the manager if one hasn't been made available yet
			if( NGRI.AirVehiclePopMgr == None )
			{
				NGRI.AirVehiclePopMgr = Spawn(class'NanoVehiclePopulationManager', NGRI);
				`assert(NGRI.AirVehiclePopMgr != None);
			}

			NGRI.AirVehiclePopMgr.AddPotentialSpawnSpline(NVS);
		}
		else
		{
			// Register with the ground vehicle manager, spawning the manager if one hasn't been made available yet
			if( NGRI.GroundVehiclePopMgr == None )
			{
				NGRI.GroundVehiclePopMgr = Spawn(class'NanoVehiclePopulationManager', NGRI);
				`assert(NGRI.GroundVehiclePopMgr != None);
			}

			NGRI.GroundVehiclePopMgr.AddPotentialSpawnSpline(NVS);
		}
	}
}

simulated function UnregisterVehicleSpline( NanoVehicleSpline NVS )
{
	local NanoVehiclePopulationManager NVPM;

	if( NVS != None )
	{
		VehicleRoadSplines.RemoveItem(NVS);

		// Unregister this with the population manager
		NVPM = NVS.bFlyingVehiclesOnly ? NanoGRI(WorldInfo.GRI).AirVehiclePopMgr : NanoGRI(WorldInfo.GRI).GroundVehiclePopMgr;
		if( NVPM != None )
		{
			NVPM.RemovePotentialSpawnSpline(NVS);
		}
	}
}

simulated function SetRoadMeshVisibility( bool bShowRoads )
{
	local NanoVehicleSpline NVS;

	// Loop over our cached meshes, and set their visibility
	foreach VehicleRoadSplines(NVS)
	{
		NVS.HideRoadMesh(!bShowRoads);
	}
}

simulated function SetRoadStatus(ENanoRoadStatus NewStatus)
{
	// If this is a status change, then set the road mesh color
	if( NewStatus != CurrentRoadStatus )
	{
		RoadColorTarget = RoadStatusColors[NewStatus];
		CurrentRoadStatus = NewStatus;
	}
}

defaultproperties
{
	// Roads don't need to be ticked that often
	TickFrequency=0.5f

	CurrentRoadStatus=ENRS_OffRoad
	RoadStatusColors[ENRS_OnRoad]=(R=-0.25f,G=1.f,B=-0.25f,A=1.f)
	RoadStatusColors[ENRS_OffRoad]=(R=0.5f,G=0.5f,B=0.5f,A=1.f)
	RoadStatusColors[ENRS_WrongWay]=(R=1.f,G=-0.25f,B=-0.25f,A=1.f)
	RoadColorBlendRate=10.f

	UpdateDistanceToPlayerInterval=0.5f
}