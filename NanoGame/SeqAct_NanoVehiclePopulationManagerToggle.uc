/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_NanoVehiclePopulationManagerToggle extends SeqAct_GameCrowdPopulationManagerToggle;

/** Types of vehicle managers.  Determines which vehicle manager in NanoGame this action acts upon */
enum ENanoVehicleManagerTypes
{
	ENVMT_AirSplines,
	ENVMT_GroundSplines
};
var() ENanoVehicleManagerTypes Manager;

/** The number of spawned vehicles to keep in the population manager's pool */
var() int   SpawnNum;

/** Distance after which splines will not be considered for spawning */
var() float   MaxSplineSpawnDistance;

/** Distance within which to not spawn vehicles if in front of the player */
var() float   NoSpawningRadius;

/**
  *  Find a population manager to toggle
  *  Called from Activated().
  */
event FindPopMgrTarget()
{
	local NanoGRI NGRI;

	NGRI = NanoGRI(GetWorldInfo().GRI);

	`assert(NGRI != None);

	if( Manager == ENVMT_AirSplines )
	{
		if( NGRI.AirVehiclePopMgr == None )
		{
			NGRI.AirVehiclePopMgr = NGRI.Spawn(class'NanoVehiclePopulationManager', NGRI);
		}
		Targets[0] = NGRI.AirVehiclePopMgr;
	}
	else
	{
		if( NGRI.GroundVehiclePopMgr == None )
		{
			NGRI.GroundVehiclePopMgr = NGRI.Spawn(class'NanoVehiclePopulationManager', NGRI);
		}
		Targets[0] = NGRI.GroundVehiclePopMgr;
	}
}

defaultproperties
{
	ObjName="Nano Vehicle Manager Toggle"
	ObjCategory="Nano"

	SpawnNum=250
	MaxSplineSpawnDistance=25000.f

	NoSpawningRadius=6000.f
}