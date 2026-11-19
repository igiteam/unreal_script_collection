/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGameplayCameraMode extends GameThirdPersonCameraMode
	config(Camera)
	native(Camera);


/** Ref to the camera object that owns this mode object. An alias of ThirdPersonCam, basically, meant to maintain consistency with existing Gears code. */
var transient GearGameplayCamera GameplayCam;

/** interp speed for Camera rotational interpolation that is used while spectating in network games */
var() protected float		SpectatorCameraRotInterpSpeed;


/** 
 * For minor per-pawn-per-mode offset tweaks, to avoid explosion of camera modes 
 * Try to stick to leaf classes, searching code is trivial and won't necessarily handle inheritance properly.
 */
struct native PerPawnViewOffsetAdjustment
{
	var() class<GearPawn> PawnClass<AllowAbstract>;
	var() vector Offset;
};
var() array<PerPawnViewOffsetAdjustment> PerPawnViewOffsetAdjustments;

/** 
 * For minor per-pawn-per-mode worst location offset tweaks, to avoid explosion of camera modes 
 * Try to stick to leaf classes, searching code is trivial and won't necessarily handle inheritance properly.
 */
var() array<PerPawnViewOffsetAdjustment> PerPawnWorstLocOffsetAdjustments;

/** FOV adjustments for each possible viewport type */
var() const protected float FOVAngle_ViewportAdjustments[ECameraViewportTypes.EnumCount];

cpptext
{
	/** Returns View relative offsets */
	virtual void GetBaseViewOffsets(class APawn* ViewedPawn, BYTE ViewportConfig, FLOAT DeltaTime, FVector& out_Low, FVector& out_Mid, FVector& out_High);

	/**
	 * Returns location and rotation, in world space, of the camera's basis point.  The camera will rotate
	 * around this point, offsets are applied from here, etc.
	 */
	virtual void GetCameraOrigin(class APawn* TargetPawn, FVector& OriginLoc, FRotator& OriginRot);
	
	/**
	 *   Interpolates a camera's origin from the last location to a new ideal location
	 *
	 *   @CameraTargetRot - Rotation of the camera target, used to create a reference frame for interpolation
	 *
	 *   @LastLoc - Last location of the camera
	 *
	 *   @IdealLoc - Ideal location for the camera this frame
	 *
	 *   @DeltaTime - time step
	 *
	 *   @return the interpolated camera origin
	 */
	virtual FVector InterpolateCameraOriginLoc(APawn* TargetPawn, FRotator const& CameraTargetRot, FVector const& LastLoc, FVector const& IdealLoc, FLOAT DeltaTime);

	virtual FRotator InterpolateCameraOriginRot(class APawn* TargetPawn, FRotator const& LastRot, FRotator const& IdealRot, FLOAT DeltaTime);

protected:
	virtual FLOAT GetViewPitch(APawn* TargetPawn, FRotator const& ViewRotation) const;
public:
};


/** Returns FOV that this camera mode desires. */
function float GetDesiredFOV( Pawn ViewedPawn )
{
 	local GearWeapon GW;

 	GW = GearWeapon(ViewedPawn.Weapon);
 
 	if (GW != None)
 	{
 		return GW.GetAdjustedFOV(FOVAngle) + FOVAngle_ViewportAdjustments[CurrentViewportType];
 	}
 	else
 	{
 		return FOVAngle + FOVAngle_ViewportAdjustments[CurrentViewportType];
 	}
}

 
/**
 * Notification from GearInventoryManager when my player's weapon changes
 */
function WeaponChanged(Controller C, Weapon OldWeapon, Weapon NewWeapon);


/** 
 * Allows mode to make any final situational adjustments to the base view offset.
 */
native event vector AdjustViewOffset( Pawn P, vector Offset );

 /**
 * Returns the "worst case" camera location for this camera mode.
 * This is the position that the camera penetration avoidance is based off of,
 * so it should be a guaranteed safe place to put the camera.
 */
simulated event vector GetCameraWorstCaseLoc(Pawn TargetPawn, TViewTarget CurrentViewTarget)
{
 	local GearPawn GP;
 	local GearTurret WT;
 	local GearVehicle GV;
 	local vector WorstLocation;
	local vector PerPawnWorstLocOffset;
	local PerPawnViewOffsetAdjustment PerPawnWorstLocOffsetAdjustment;
	local vector LocalWorstLocOffset;
 
 	GP = GearPawn(TargetPawn);
 
 	if (GP != None)
 	{
		foreach PerPawnWorstLocOffsetAdjustments(PerPawnWorstLocOffsetAdjustment)
		{
			if (ClassIsChildOf(GP.Class, PerPawnWorstLocOffsetAdjustment.PawnClass))
			{
				PerPawnWorstLocOffset = PerPawnWorstLocOffsetAdjustment.Offset;
				break;
			}
		}

		LocalWorstLocOffset = WorstLocOffset + PerPawnWorstLocOffset;
		if( GP.bIsMirrored )
		{
			LocalWorstLocOffset.Y = -LocalWorstLocOffset.Y;
		}
 		WorstLocation = GP.Location + (LocalWorstLocOffset >> GP.Rotation);
 	}
 	else
 	{
 		WT = GearTurret(TargetPawn);
		GV = GearVehicle(TargetPawn);
 		if (WT != None)
 		{
 			WorstLocation = WT.GetCameraWorstCaseLoc();
 		}
		else if (GV != None)
		{
			WorstLocation = GV.GetCameraWorstCaseLoc(0);
		}
 		else
 		{
 			`log("Warning, using default WorstLocation in "@GetFuncName());
 			WorstLocation = TargetPawn.Location;
 		}
 	}
 
 	return WorstLocation;
}

simulated protected function vector GetDOFFocusLoc(Actor TraceOwner, vector StartTrace, vector EndTrace)
{
	local GearPawn	GP;
	local vector FocusLoc;

 	// see if weapon wants to define focus loc
 	GP = GearPawn(TraceOwner);
 	if ( (GP != None) && (GP.MyGearWeapon != None) )
 	{
 		if (GP.MyGearWeapon.GetCameraDOFFocusLocation(FocusLoc))
 		{
 			return FocusLoc;
 		}
 	}

	return DOFTrace(TraceOwner, StartTrace, EndTrace);
}



/** Gives mode a chance to adjust/override postprocess as desired. */
simulated function UpdatePostProcess(const out TViewTarget VT, float DeltaTime)
{
	local GearPC GPC;

	bDOFUpdated = FALSE;

	if (bAdjustDOF)
	{
		GPC = GearPC(GameplayCam.PlayerCamera.PCOwner);
		if ( (GPC == None) || (!GPC.bDisableCameraTargetingDOF) )
		{
			super.UpdatePostProcess(VT, DeltaTime);
		}
	}
}

simulated function GearPC GetGearPC()
{
	return GearPC(GameplayCam.PlayerCamera.PCOwner);
}

defaultproperties
{
	SpectatorCameraRotInterpSpeed=14.f
	DOF_MaxFarBlurAmount=0.7f
}