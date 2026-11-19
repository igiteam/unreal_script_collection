/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Cam3p_Orbit extends NanoThirdPersonCameraMode
	native(Camera)
	config(Camera);
	
cpptext
{
	virtual void GetCameraOrigin(class APawn* TargetPawn, FVector& OriginLoc, FRotator& OriginRot);
	virtual void InterpolateCameraOrigin( APawn* TargetPawn, FLOAT DeltaTime, FVector& out_ActualCameraOrigin, FVector const& IdealCameraOrigin, FRotator& out_ActualCameraOriginRot, FRotator const& IdealCameraOriginRot );
	virtual FRotator GetViewOffsetRotBase( class APawn* ViewedPawn, const FTViewTarget& VT );

	virtual FVector GetViewOffset(class APawn* ViewedPawn, FLOAT DeltaTime, const FVector& ViewOrigin, const FRotator& ViewRotation);
	virtual FLOAT GetViewPitch(APawn* TargetPawn, FRotator const& ViewRotation) const;
	virtual FVector	ApplyViewOffset( class APawn* ViewedPawn, const FVector& CameraOrigin, const FVector& ActualViewOffset, const FVector& DeltaViewOffset, const FTViewTarget& OutVT );

	UBOOL HandleCameraSafeZoneViolations( FVector& CameraOrigin, FRotator& CameraRotation, FLOAT DeltaTime, FSceneView* SceneView, TArray<FSafeZoneViolationInfo>& Violations, USafeZoneInfo* SZ, UBOOL bClearInterp = FALSE );
};

event bool UpdateActiveSafeZones( NanoPawn NP )
{
	local Vector X, Y, Z, CamLoc;
	local Rotator CamRot;
	local float VelDotY;

	NP.GetActorEyesViewPoint( CamLoc, CamRot );
	GetAxes( CamRot, X, Y, Z );

//	if( TRUE )
//	{
//		SetSafeZoneActiveByName( 'RunCenter' );
//		return TRUE;
//	}

	if( NP.Physics == PHYS_Falling )
	{
		if( NP.Velocity.Z > 0.f )
		{	
			SetSafeZoneActiveByName( 'Jump_Up' );
		}
		else
		{
			SetSafeZoneActiveByName( 'Jump_Down' );
		}
	}
	else
	{
		if( NP.bIsDashing && NP.Physics == PHYS_Walking )
		{
			SetSafeZoneActiveByName( 'DashCenter' );
		}
		else
		{
			VelDotY = Normal(NP.Velocity) DOT Y;
			if( VelDotY > 0.8f )
			{
				SetSafeZoneActiveByName( 'RunRight' );
			}
			else if( VelDotY < -0.8f )
			{
				SetSafeZoneActiveByName( 'RunLeft' );
			}
//			else
//			{
//				SetSafeZoneActiveByName( 'RunCenter' );
//			}
		}
	}

	return TRUE;
}

event bool GetPitchBounds( NanoPawn NP, out int out_Low, out int out_High, out Vector2D out_InterpSpeed )
{
	if( ActiveSafeZone != None && ActiveSafeZone.bUsePitchBounds )
	{
		out_Low  = ActiveSafeZone.Bounds_PitchLow;
		out_High = ActiveSafeZone.Bounds_PitchHigh;
		out_InterpSpeed = ActiveSafeZone.PitchInterpSpeed;

		return TRUE;
	}

	return FALSE;
}

simulated function ProcessViewRotation( float DeltaTime, Actor ViewTarget, out Rotator out_ViewRotation, out Rotator out_DeltaRot )
{
	local int Bounds_High, Bounds_Low;
	local Vector2D BoundsInterpSpeed;
	local float InterpSpeed;
	local int CamPitch, NormPitch;
	local bool bClampedPitch;
	local NanoPawn NP;

	NP = NanoPawn(ViewTarget);
	if( NP != None )
	{
		if( GetPitchBounds( NP, Bounds_Low, Bounds_High, BoundsInterpSpeed ) )
		{
			NormPitch = NormalizeRotAxis( out_ViewRotation.Pitch );
			CamPitch = NormPitch;
			if( CamPitch < Bounds_Low )
			{
				InterpSpeed = BoundsInterpSpeed.X;
				CamPitch = Bounds_Low;
				bClampedPitch = TRUE;
			}
			if( CamPitch > Bounds_High )
			{
				InterpSpeed = BoundsInterpSpeed.Y;
				CamPitch = Bounds_High;
				bClampedPitch = TRUE;
			}
		}

		if( bClampedPitch )
		{
			CamPitch = FInterpTo( NormPitch, CamPitch, DeltaTime, InterpSpeed );
			out_DeltaRot.Pitch += (CamPitch - NormPitch);
		}
	}
	Super.ProcessViewRotation(DeltaTime,ViewTarget,out_ViewRotation,out_DeltaRot);
}

defaultproperties
{
	ViewOffset={(
		OffsetHigh=(X=180,Y=0,Z=100),
		OffsetLow=(X=75,Y=0,Z=-200),
		OffsetMid=(X=0,Y=0,Z=0),
	)}

	SafeZoneList(0)=(ZoneName=RunCenter,ZoneClass=class'SZI_Run_Center')
	SafeZoneList(1)=(ZoneName=RunLeft,ZoneClass=class'SZI_Run_Left')
	SafeZoneList(2)=(ZoneName=RunRight,ZoneClass=class'SZI_Run_Right')
	SafeZoneList(3)=(ZoneName=Jump_Up,ZoneClass=class'SZI_Jump_Up')
	SafeZoneList(4)=(ZoneName=Jump_Down,ZoneClass=class'SZI_Jump_Down')
	SafeZoneList(5)=(ZoneName=DashCenter,ZoneClass=class'SZI_Dash_Center')

	WorstLocOffset=(X=0,Y=0,Z=0)

	bZeroCameraRotation=FALSE
	bValidateWorstLoc=FALSE
	bSkipCameraCollision=FALSE
	bApplyDeltaViewOffset=TRUE

	//bInterpRotation=TRUE
	OriginRotInterpSpeed=2.f
}

