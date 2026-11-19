/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPhysicsVolume extends PhysicsVolume
	native;

/** if set, ZoneVelocity doesn't apply to Pawns */
var() bool bPawnsIgnoreZoneVelocity;

/** If bPainCausing is true, this team will be damaged */
var() EGearTeam TeamToDamage;

/** If true, pawns on TeamToGod will be invulnerable while in this volume */
var() bool bPawnGodMode;
/** If bPawnGodMode is true, pawns on this team will be invulnerable while in this volume */
var() EGearTeam TeamToGod;

native function vector GetZoneVelocityForActor(Actor TheActor);

simulated event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local Pawn P;

	// Check if Other should be put into God mode while inside this volume
	P = Pawn(Other);
	if( P != None && P.Controller != None &&
		bPawnGodMode && (TeamToGod == TEAM_EVERYONE || P.GetTeamNum() == TeamToGod) )
	{
		P.Controller.bGodMode = true;
	}
	Super.Touch(Other, OtherComp, HitLocation, HitNormal);
}

simulated event UnTouch( Actor Other )
{
	local Pawn P;

	// Check if Other should be taken out of God mode when exiting this volume
	P = Pawn(Other);
	if( P != None && P.Controller != None &&
		bPawnGodMode && (TeamToGod == TEAM_EVERYONE || P.GetTeamNum() == TeamToGod) )
	{
		P.Controller.bGodMode = false;
	}
	Super.UnTouch(Other);
}

/** Overridden to only cause damage to the appropriate teams */
function CausePainTo(Actor Other)
{
	if( TeamToDamage == TEAM_EVERYONE || Other.GetTeamNum() == TeamToDamage )
	{
		Super.CausePainTo(Other);
	}
}

defaultproperties
{
	bPawnsIgnoreZoneVelocity=true
	TeamToDamage=TEAM_EVERYONE
	TeamToGod=TEAM_COG
}
