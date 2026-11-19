/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Gear_RappelRopeBase extends SplineLoftActorMovable
	abstract;

/** Whether we're doing an XY plane revolution */
var bool bXYRevolving;

/** The point to do an XY revolution around */
var vector XYRevolutionCenter;

/** The X plane radius that we should use while revolving */
var float XYRevolutionRadiusX;

/** The Y plane radius that we should use while revolving */
var float XYRevolutionRadiusY;

/** The speed to revolve at */
var float XYRevolutionSpeed;

/**
 * Kick off an XY plane revolution
 * 
 * @param CenterPoint - the point to do an XY revolution around
 * 
 * @param RadiusX - X plane radius that we should use while revolving
 * 
 * @param RadiusY - Y plane radius that we should use while revolving
 * 
 * @param Speed - speed to revolve at
 */
function StartXYRevolution(vector CenterPoint, float RadiusX, float RadiusY, float Speed)
{
	bXYRevolving = TRUE;

	XYRevolutionRadiusX = RadiusX;
	XYRevolutionRadiusY = RadiusY;

	XYRevolutionSpeed = Speed;

	XYRevolutionCenter = CenterPoint;
}

/**
 * Revolve the rope in the XY plane if enabled
 * 
 * @param DeltaTime - the length of the last frame
 */
function Tick(float DeltaTime)
{	
	local vector NewLocation;

	Super.Tick(DeltaTime);

	if (bXYRevolving)
	{
		NewLocation = XYRevolutionCenter;
		NewLocation.X += XYRevolutionRadiusX * sin(WorldInfo.TimeSeconds * XYRevolutionSpeed);
		NewLocation.Y += XYRevolutionRadiusY * cos(WorldInfo.TimeSeconds * XYRevolutionSpeed);
		SetRelativeLocation(NewLocation);
	}
}

defaultproperties
{
	RemoteRole=ROLE_None
}