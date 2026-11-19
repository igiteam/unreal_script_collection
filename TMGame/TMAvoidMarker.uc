/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
//=============================================================================
// TMAvoidMarker.
// Bots avoid these spots when moving - used for very short term stationary hazards like bio goo or sticky grenades
//=============================================================================
class TMAvoidMarker extends Actor
	native
	notPlaceable;

var byte TeamNum;
var CylinderComponent CollisionCylinder;

simulated native function byte GetTeamNum();

event Touch( actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	if ( (Pawn(Other) != None) && (TMBot(Pawn(Other).Controller) != None) && !WorldInfo.GRI.OnSameTeam(self,Other) )
		TMBot(Pawn(Other).Controller).FearThisSpot(self);
}

function StartleBots()
{
	local Pawn P;

	ForEach TouchingActors(class'Pawn', P)
		if ( (TMBot(P.Controller) != None) && !WorldInfo.GRI.OnSameTeam(self,P.Controller) )
			TMBot(P.Controller).Startle(self);
}

