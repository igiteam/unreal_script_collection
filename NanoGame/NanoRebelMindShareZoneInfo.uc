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
class NanoRebelMindShareZoneInfo extends Info
	native
	placeable;


/** The name of this NanoRebelMindShareZoneInfo (e.g. NW Zone) **/
var() name MindShareZoneName;

/** The set of ChaosZones that belong to this NanoChaosZoneInfo **/
var() array<NanoVolume_RebelMindShareZone> MindShareZones;

/** So each of the NanoChaosZoneInfo have a ChaosPacficismManager which controls chaos for the set of zones this info specifies **/
// NOTE: this is broken in MP
var transient RebelMindShareManager MindShareManager;


replication
{
	if( Role == ROLE_Authority )
        MindShareManager;
}

/** Util to draw this zone onto the map, defined by the corners passed in */
native function DrawZoneOnMap(Canvas C, Vector2D NWMapPos, Vector2D SEMapPos, Vector2D MapOrigin, float MapSize, Color ZoneColor);


/** Before play occurs we need to make certain that we have ChaosManager **/
simulated event PreBeginPlay()
{
	local NanoVolume_RebelMindShareZone Z;

	Super.PreBeginPlay();
	
	if( Role == ROLE_Authority )
	{
		MindShareManager = Spawn( class'RebelMindShareManager' );
        MindShareManager.ZoneName = MindShareZoneName;

		// For each of the ChaosZones this info owns set their parent (could do this on post edit change)
		ForEach MindShareZones( Z )
	    {
	    	Z.MyNanoRebelMindShareZoneInfo = self;	
	    }
	}
}



simulated event Destroyed()
{
	Super.Destroyed();

	MindShareManager.Destroy();
	MindShareManager = none;
}


defaultproperties
{
	TickGroup=TG_DuringAsyncWork

	Begin Object Name=Sprite
		Sprite=Texture2D'EditorResources.ChaosZoneInfo'
	End Object

}