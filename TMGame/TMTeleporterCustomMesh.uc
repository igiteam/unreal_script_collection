/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

/** version of Teleporter that has a custom mesh/material */
class TMTeleporterCustomMesh extends Teleporter;

var() StaticMeshComponent Mesh;

/** Sound to be played when someone teleports in*/
var SoundCue TeleportingSound;

var TMPawn LastPawn;
var float LastTime;

simulated event bool Accept( actor Incoming, Actor Source )
{
	local TMPlayerReplicationInfo PRI;

	PRI = (Pawn(Incoming) != None) ? TMPlayerReplicationInfo(Pawn(Incoming).PlayerReplicationInfo) : None;
	if ( (PRI != None) && (PRI.GetFlag() != None) )
	{
		PRI.GetFlag().Drop();
	}

	if (Super.Accept(Incoming,Source))
	{
		PlaySound(TeleportingSound);
		if ( TMPawn(Incoming) != None )
		{
			LastPawn = TMPawn(Incoming);
			LastTime = WorldInfo.TimeSeconds;
		}
		return true;
	}
	else
	{
		return false;
	}
}

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	if ( (Other == LastPawn) && (WorldInfo.TimeSeconds - LastTime < 0.2) )
	{
		return;
	}
	super.Touch(Other, OtherComp, HitLocation, HitNormal);
}

