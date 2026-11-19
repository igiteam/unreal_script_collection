/**
 * -multiple ChaosManagers
 *   -NanoChaosZoneInfo which holds NanoVolume_ChaosZones
 *   -NanoChaosZoneInfo is an actor that is placed in the map to represent a section of the world (e.g. NW Precinct)
 *       -ChaosZones are volumes that are placed in the map "volume in" areas
 *   -each Actor which can Affect Chaos has a NanoVolume_ChaosZone they are in (which from that it can be determined which ChaosManager is handling the chaos)
 *   -all kismet actions which affect Chaos now can point to a zone OR they will affect the zone the player is currently in
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoChaosZoneInfo extends Info
	native
	placeable;


/** The name of this NanoChaosZoneInfo (e.g. NW Zone) **/
var() name ChaosZoneName;

/** The set of ChaosZones that belong to this NanoChaosZoneInfo **/
var() array<NanoVolume_ChaosZone> ChaosZones;

/** So each of the NanoChaosZoneInfo have a ChaosPacficismManager which controls chaos for the set of zones this info specifies **/
// NOTE: this is broken in MP
var transient ChaosPacifismManager ChaosManager;


replication
{
	if( Role == ROLE_Authority )
        ChaosManager;

}

/** Util to draw this zone onto the map, defined by the corners passed in */
native function DrawZoneOnMap(Canvas C, Vector2D NWMapPos, Vector2D SEMapPos, Vector2D MapOrigin, float MapSize, Color ZoneColor);


/** Before play occurs we need to make certain that we have ChaosManager **/
simulated event PostBeginPlay()
{
	Super.PreBeginPlay();

	SetTimer( 3.0f, FALSE, nameof(OhHandleRaceCondition) );

}


function OhHandleRaceCondition()
{
	local NanoVolume_ChaosZone C;

	if( Role == ROLE_Authority )
	{
		ChaosManager = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetCurrentChaosManager(); //Spawn( class'ChaosPacifismManager' );
		ChaosManager.ChaosZoneName = ChaosZoneName;

		// For each of the ChaosZones this info owns set their parent (could do this on post edit change)
		ForEach ChaosZones( C )
		{
			C.MyNanoChaosZoneInfo = self;	
		}
	}
}


simulated event Destroyed()
{
	Super.Destroyed();

	//ChaosManager.Destroy();
	//ChaosManager = none;
}


defaultproperties
{
	TickGroup=TG_DuringAsyncWork

	Begin Object Name=Sprite
		Sprite=Texture2D'EditorResources.ChaosZoneInfo'
	End Object

}