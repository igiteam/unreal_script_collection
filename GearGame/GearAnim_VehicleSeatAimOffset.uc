
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearAnim_VehicleSeatAimOffset extends GearAnim_AimOffset
	native(Anim);

/** Cached vehicle */
var GearVehicle MyVehicle;

/** Seat to pull from */
var() int MySeatIndex;

cpptext
{
	/** Pull aim information from Pawn */
	virtual FVector2D	GetAim() ;
}

defaultproperties
{
	AimInput=AI_VehicleAimOffset
}