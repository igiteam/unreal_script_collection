/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class TempestFightTriggerVolume extends TriggerVolume
	placeable;


/** List of gearpawns in this volume */
var array<GearPawn> GearPawnsInVolume;

/** Overloaded to keep track of the gearpawns in this volume */
simulated event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local GearPawn GP;

	if (Role == ROLE_Authority)
	{
		GP = GearPawn(Other);
		if (GP != None && GearPawnsInVolume.Find(GP) == INDEX_NONE)
		{
			GearPawnsInVolume.AddItem(GP);
		}
	}

	Super.Touch(Other, OtherComp, HitLocation, HitNormal);
}

/** Overloaded to keep track of the gearpawns in this volume */
simulated event UnTouch( Actor Other )
{
	local GearPawn GP;

	if (Role == ROLE_Authority)
	{
		GP = GearPawn(Other);
		if (GP != None && GearPawnsInVolume.Find(GP) != INDEX_NONE)
		{
			GearPawnsInVolume.RemoveItem(GP);
		}
	}

	Super.UnTouch(Other);
}

defaultproperties
{
	BrushColor=(R=216,G=44,B=100,A=220)
}
