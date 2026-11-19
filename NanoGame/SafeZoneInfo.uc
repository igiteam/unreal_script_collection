/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SafeZoneInfo extends Object
	native(Camera);

/** Name of the safe zone */
var()	Name	 ZoneName;	
/** Whether this zone is active or not */
var()	bool	 bActive;
/** Whether this zone has been updated at least once */
var()	bool	 bUpdatedOnce;
/** Amount of time active */
var()	float	 TotalTimeActive;

/** Screen-space safe zone defined by camera mode */
var()	InterpCurveVector2D Bounds_U, Bounds_V, Bounds_W;

/** Target offset for safe zone violations */
var() transient Vector DesiredOffset_U, DesiredOffset_V, DesiredOffset_W;
/** Current offset for safe zone violations */
var() transient Vector Offset_U, Offset_V, Offset_W;
/** Interp speed for blending for U/V/W components */
var() Vector  ViolationOffsetInterpSpeed;

/** Min distance camera can be from the pawn due to check location width/height vs safezone width/height */
var() float	MinCameraDistByBoundsRatio, DesiredMinCameraDistByBoundsRatio;

/** Contains active violation flags using ESafeZoneViolation */
var() byte	 PreviousViolationFlags, ViolationFlags, RecentViolationFlags;
/** Whether these components were used at least once */
var() bool	 bGoodAtLeastOnce_U, bGoodAtLeastOnce_V, bGoodAtLeastOnce_W;
/** Whether to lock into the safe zone once good once */
var() bool	 bLockAfterGoodOnce;
/** Whether we found a thrashing between previous/last frame */
var() bool	 bThrash_U, bThrash_V, bThrash_W;

/** Whether to use pitch bounds or not */
var() bool bUsePitchBounds;
/** Pitch bounds for this safe zone */
var() int	 Bounds_PitchHigh, Bounds_PitchLow;
/** Pitch interp speed */
var() Vector2D PitchInterpSpeed;

var() Vector WorldSpaceSafeZoneCenter, OriginToSafeZoneCenter;
var() Vector WorldSpaceScreenCenter, OriginToScreenCenter;

var(Debug) bool	bDebug;

cpptext
{
	
}

native function GetSafeZoneMinMax( out Vector2D out_U, out Vector2D out_V, out Vector2D out_W );

simulated event SetActive( bool bSet, optional SafeZoneInfo PrevSafeZone )
{
	local Vector2D pU, pV, pW;

	if( bActive != bSet )
	{
		if( bSet )
		{
			TotalTimeActive = 0.f;
			bGoodAtLeastOnce_U = FALSE;
			bGoodAtLeastOnce_V = FALSE;
			bGoodAtLeastOnce_W = FALSE;

			Bounds_U = default.Bounds_U;
			Bounds_V = default.Bounds_V;
			Bounds_W = default.Bounds_W;
			if( PrevSafeZone != None )
			{
				PrevSafeZone.GetSafeZoneMinMax( pU, pV, pW );

				if( Bounds_U.Points.Length == 0 )
				{
					Bounds_U.Points.Length = 1;
					Bounds_U.Points[0].OutVal = pU;
				}
				if( Bounds_V.Points.Length == 0 )
				{
					Bounds_V.Points.Length = 1;
					Bounds_V.Points[0].OutVal = pV;
				}
				if( Bounds_W.Points.Length == 0 )
				{
					Bounds_W.Points.Length = 1;
					Bounds_W.Points[0].OutVal = pW;
				}
			}
		}
		bActive = bSet;
		bUpdatedOnce = FALSE;
		MinCameraDistByBoundsRatio = 0.f;
	}
}

simulated event Tick( float DeltaTime )
{
	if( bActive )
	{
		TotalTimeActive += DeltaTime;

		MinCameraDistByBoundsRatio = FInterpConstantTo( MinCameraDistByBoundsRatio, DesiredMinCameraDistByBoundsRatio, DeltaTime, 100.f );
	}
}

simulated event GetCheckLocations( NanoPawn NP, FLOAT DeltaTime, Vector CameraOrigin, Rotator CameraRotation, out array<Vector> out_List )
{
	local int i;
	local Vector X, Y, Z;
	local Vector Extent;

	if( NP.Mesh != None && NP.CheckCameraBoneNames.Length > 0 )
	{
		// If bone names are specified for the pawn, and use their locations for the checks if so
		for( i = 0; i < NP.CheckCameraBoneNames.Length; i++ )
		{
			out_List[out_List.Length] = NP.Mesh.GetBoneLocation(NP.CheckCameraBoneNames[i]);
		}
	}
	else
	{
		// If no bone names are specified, use the cylinder extents
		GetAxes( CameraRotation, X, Y, Z );
		Extent = NP.GetCollisionExtent() * vect(0.25f, 0.25f, 0.75f);

		out_List[out_List.Length] = NP.Location;
		out_List[out_List.Length] = NP.Location + Y * Extent.Y;
		out_List[out_List.Length] = NP.Location - Y * Extent.Y;
		out_List[out_List.Length] = NP.Location + Z * Extent.Z;
	}

	// Include velocity in the check locations to avoid thrashing the boundaries
	for( i = 0; i < out_List.Length; i++ )
	{
		out_List[i] += NP.Velocity * DeltaTime;
	}
}

defaultproperties
{
	//bActive=TRUE
	PitchInterpSpeed=(X=2.f,Y=2.f)
	Bounds_PitchHigh=16384
	Bounds_PitchLow=-16384

	bLockAfterGoodOnce=TRUE
	ViolationOffsetInterpSpeed=(X=8.f,Y=8.f,Z=10.f)
}