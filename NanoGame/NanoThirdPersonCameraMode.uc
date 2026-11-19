/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoThirdPersonCameraMode extends GameThirdPersonCameraMode
	config(Camera)
	native(Camera);

var() transient NanoThirdPersonCamera NanoCamera;

/** Whether to interpolate camera by time instead of speed */
var() bool  bInterpLocByTime;
/** Amount of time to interp to new camera location */
var() float InterpLocTime;
var() float InterpLocTimeRemaining;
/** Whether we should stop interpolating once we reach our ideal spot */
var() bool	bInterpToIdealLocThenLock;
/** Location we are interpolating from */
var	  Vector InterpLocationBase;
/** Distance from ideal location that the camera with tolerate before interpolating */
var() bool	 bUsePerAxisBuffer;
var() vector InterpLocPerAxisBuffer;
/** If using InterpLocPerAxisBuffer, then wait this time before interpolating the camera to it's ideal location */
var() float	TimeBeforeInterpolatingToIdeal;
var transient float CurrentTimeWithinBuffer;

/** Whether to interpolate camera by time instead of speed */
var() bool  bInterpRotByTime;
/** Amount of time to interp to new camera location */
var() float InterpRotTime;
var() float InterpRotTimeRemaining;
/** Whether we should stop interpolating once we reach our ideal spot */
var() bool	bInterpToIdealRotThenLock;
/** Rotation we are interpolating from */
var	  Rotator InterpRotationBase;


/** Name of the camera bone to use for this camera mode */
var() Name	CameraBoneName;
/** Name of the camera transition bone */
var() Name TransitionBoneName;

/** If we should actually use the camera bone for the location! **/
var() bool bActuallyUseCameraBone;

/** Grab camera rotation from the camera bone */
var() bool	bUseCameraBoneRotation;

var() bool	bSlideOffsetOnCamModeChange;

/** Whether this camera is 1p/3p */
var() ENanoCameraTransition CameraType;

/** List of safe zone bounds */
var() array<SafeZoneItem>		SafeZoneList;
var() editinline SafeZoneInfo	ActiveSafeZone;


/** Whether target was in camera safe zone last frame */
var		bool	 bWasInCameraSafeZone;
/** Last time the camera was in safezone */
var		float	 LastInCameraSafeZoneTime;

var Name	LastCameraBoneName;
var Vector	LastCameraBoneLocation;
var Rotator LastCameraBoneRotation;

var(Debug) bool bZeroCameraRotation;
var(Debug) bool bDisableDynamicSafeZoneUpdates;

var() config protected const vector LookatOffset;
var() protected const vector FinalCamOffset;
var() protected const float FinalCamOffsetInterpSpeed;
var protected transient vector LastFinalCamOffset;

/** 
 * Whether or not the camera code is going to use the framing code to make certain that that some point is in seen by the camera.
 * (e.g. the purple box needs to be seen by the camera frustum when first switching to this mode)
 **/
var() config protected bool bUseFraming;

/**  If we don't want to use the purple box for framing but instead want to use the Green lil box (the LookatOffset point) **/
var() config protected bool bUseLookatOffsetForFraming;

/** 
 * By default the framing location is the Pawn's Location.  We provide an offset to that location so we can push that box around 
 * (shows up as purple box)
 **/
var() config protected const vector FramingLookatOffset;



/** How far from the pivot should the cam be */
var(JeffCam) config protected const float JeffCamDistance;

/** 0.f for no following behavior, 1.f for full following behavior */
var(JeffCam) config protected const float JeffCamFollowStrength_Yaw;
var(JeffCam) config protected const float JeffCamFollowStrength_Pitch;
var(JeffCam) config protected const float JeffCamResumeFollowingAfterInputTime;

var(JeffCam) bool bUseJeffCam;




cpptext
{
	/**
	 * Returns location and rotation, in world space, of the camera's basis point.  The camera will rotate
	 * around this point, offsets are applied from here, etc.
	 */
	virtual void GetCameraOrigin(class APawn* TargetPawn, FVector& OriginLoc, FRotator& OriginRot);
	virtual FVector GetLookatOffset() { return LookatOffset; };

	virtual FVector InterpolateCameraOriginLoc(APawn* TargetPawn, FRotator const& CameraTargetRot, FVector const& LastLoc, FVector const& IdealLoc, FLOAT DeltaTime);
	virtual FRotator InterpolateCameraOriginRot(APawn* TargetPawn, FRotator const& LastRot, FRotator const& IdealRot, FLOAT DeltaTime);

	virtual UBOOL HandleCameraSafeZoneViolations( FVector& CameraOrigin, FRotator& CameraRotation, FLOAT DeltaTime, FSceneView* SceneView, TArray<FSafeZoneViolationInfo>& Violations, class USafeZoneInfo* SZ, UBOOL bClearInterp = FALSE );

	virtual FLOAT GetJeffCamDistance() { return JeffCamDistance; };
};

function Init()
{
	local int i;

	Super.Init();

	if( SafeZoneList.Length > 0 )
	{
		for( i = 0; i < SafeZoneList.Length; i++ )
		{
			if( SafeZoneList[i].ZoneClass != None )
			{
				SafeZoneList[i].Zone = new(Outer) SafeZoneList[i].ZoneClass;
			}		
		}
		SetSafeZoneActiveByIndex( 0 );
	}
}

/** Called when Camera mode becomes active */
function OnBecomeActive( Pawn TargetPawn, GameThirdPersonCameraMode PrevMode )
{
	local NanoThirdPersonCameraMode Prev;
	local bool bUseSlideOffset;

	Super.OnBecomeActive( TargetPawn, PrevMode );

	NanoCamera = NanoThirdPersonCamera(ThirdPersonCam);
	NanoCamera.DesiredAutoPan = rot(0,0,0);
	NanoCamera.DesiredAutoSlide = vect(0,0,0);

	//`log(`location@TargetPawn.WorldInfo.TimeSeconds);

	Prev = NanoThirdPersonCameraMode(PrevMode);
	bUseSlideOffset = ( Prev == None || Prev.CameraType == CameraType ) && ShouldSlideOffsetOnCamModeChange(TargetPawn,PrevMode);
	if (!bUseSlideOffset)
	{
		NanoCamera.bSlideOffsetOnCamModeChange = FALSE;
		NanoCamera.AutoPan = rot(0,0,0);
		NanoCamera.AutoSlide = vect(0,0,0);
	}
	else
	{
		NanoCamera.bSlideOffsetOnCamModeChange = TRUE;
	}
	//`log("changing camera, auto pan/slide now set to"@NanoCamera.bSlideOffsetOnCamModeChange@`showvar(NanoCamera.DesiredAutoPan));

	bInterpLocation = default.bInterpLocation;
	SetInterpLocationByTime( default.bInterpLocByTime, default.InterpLocTime, ThirdPersonCam.PlayerCamera.Location );
	bInterpToIdealLocThenLock = default.bInterpToIdealLocThenLock;

	bInterpRotation = default.bInterpRotation;
	SetInterpRotationByTime( default.bInterpRotByTime, default.InterpRotTime, ThirdPersonCam.PlayerCamera.Rotation );
	bInterpToIdealRotThenLock = default.bInterpToIdealRotThenLock;
}

function bool ShouldSlideOffsetOnCamModeChange( Pawn TargetPawn, GameThirdPersonCameraMode PrevMode )
{
	return bSlideOffsetOnCamModeChange;
}

native function ResetPlayerView();

/** Called when interp by time is complete */
event OnInterpLocByTimeComplete();
event OnInterpRotByTimeComplete();

event OnTargetLeftSafeZone( Pawn TargetPawn )
{
/*
	`log( `location@`showvar(TargetPawn)@`showvar(CameraSafeZoneViolationFlags) );
	if( (CameraSafeZoneViolationFlags & (1 << SZV_Left)) != 0 )
	{
		`log( "... Left" );
	}
	if( (CameraSafeZoneViolationFlags & (1 << SZV_Right)) != 0 )
	{
		`log( "... Right" );
	}
	if( (CameraSafeZoneViolationFlags & (1 << SZV_Up)) != 0 )
	{
		`log( "... Up" );
	}
	if( (CameraSafeZoneViolationFlags & (1 << SZV_Down)) != 0 )
	{
		`log( "... Down" );
	}
	if( (CameraSafeZoneViolationFlags & (1 << SZV_Rear)) != 0 )
	{
		`log( "... Behind" );
	}
	if( (CameraSafeZoneViolationFlags & (1 << SZV_Front)) != 0 )
	{
		`log( "... Front" );
	}
*/
}
event OnTargetEnteredSafeZone( Pawn TargetPawn )
{
//	`log( `location@`showvar(TargetPawn) );
}

native function SetInterpLocationByTime( bool bInterp, float InterpTime, Vector  BaseLoc );
native function SetInterpRotationByTime( bool bInterp, float InterpTime, Rotator BaseRot );



/** Returns FOV that this camera mode desires. */
function float GetDesiredFOV( Pawn ViewedPawn )
{
	return FOVAngle;
}

 
 /**
  * Notification from NanoInventoryManager when my player's weapon changes
  */
 function WeaponChanged(Controller C, Weapon OldWeapon, Weapon NewWeapon);

 /**
 * Returns the "worst case" camera location for this camera mode.
 * This is the position that the camera penetration avoidance is based off of,
 * so it should be a guaranteed safe place to put the camera.
 */
simulated event vector GetCameraWorstCaseLoc(Pawn TargetPawn, TViewTarget CurrentViewTarget)
{
 	local NanoPawn NP;
	local vector WorstLocation;
 
 	NP = NanoPawn(TargetPawn);
  	if( NP != None )
 	{
 		WorstLocation = NP.Location + (WorstLocOffset >> NP.Rotation);
 	}
 	else
 	{
		`log("Warning, using default WorstLocation in "@GetFuncName());
		WorstLocation = TargetPawn.Location;
 	}
 
 	return WorstLocation;
}

simulated event NotifyBoundsRatioViolation( NanoPawn NP, Vector WorldSpaceBoundsMidpoint )
{
	WorstLocOffset.Z = WorldSpaceBoundsMidpoint.Z - NP.Location.Z;
}

simulated protected function vector GetDOFFocusLoc(Actor TraceOwner, vector StartTrace, vector EndTrace)
{
/*
	local NanoPawn	NP;
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
*/
 	
	return DOFTrace(TraceOwner, StartTrace, EndTrace);
}



/** Gives mode a chance to adjust/override postprocess as desired. */
simulated function UpdatePostProcess(const out TViewTarget VT, float DeltaTime)
{
/*
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
*/
}

simulated function AdhereToCameraBone(bool bEnable)
{
	local ViewOffsetData NewViewOffset;
	//`log(`location@`showvar(bEnable));
	if (bEnable)
	{
		bUsePerAxisBuffer = FALSE;
		NewViewOffset.OffsetHigh = vect(0,0,0);
		NewViewOffset.OffsetLow = vect(0,0,0);
		NewViewOffset.OffsetMid = vect(0,0,0);
		SetViewOffset(NewViewOffset);
		OriginRotInterpSpeed = default.OriginRotInterpSpeed * 5.f;
		PerAxisOriginLocInterpSpeed = default.PerAxisOriginLocInterpSpeed * 5.f;
	}
	else
	{
		bInterpLocation = TRUE;
		bInterpLocByTime = FALSE;
		bInterpToIdealLocThenLock = FALSE;
		bUsePerAxisBuffer = TRUE;
		SetViewOffset(default.ViewOffset);
		ViewOffsetInterp = 1.f;
		OriginRotInterpSpeed = default.OriginRotInterpSpeed;
		PerAxisOriginLocInterpSpeed = default.PerAxisOriginLocInterpSpeed;
	}
}

event bool UpdateActiveSafeZones( NanoPawn NP );

simulated function SetSafeZoneActiveByName( Name ZoneName )
{
	local int Idx;
	Idx = SafeZoneList.Find( 'ZoneName', ZoneName );
	if( Idx >= 0 && SafeZoneList[Idx].Zone != None )
	{
		SetSafeZoneActiveByIndex( Idx );
	}
}

simulated function SetSafeZoneActiveByIndex( int ZoneIdx )
{
	if( ZoneIdx >= 0 && ZoneIdx < SafeZoneList.Length )
	{
		if( ActiveSafeZone != SafeZoneList[ZoneIdx].Zone )
		{
			if( ActiveSafeZone != None )
			{
				ActiveSafeZone.SetActive( FALSE );
			}
			SafeZoneList[ZoneIdx].Zone.SetActive( TRUE, ActiveSafeZone );
			ActiveSafeZone = SafeZoneList[ZoneIdx].Zone;
		}
	}
}

event bool GetPitchBounds( NanoPawn NP, out int out_Low, out int out_High, out Vector2D out_InterpSpeed );


defaultproperties
{
	CameraType=ENCT_ThirdPerson

	OriginRotInterpSpeed=8
	CameraBoneName="b_Camera_3rdP"
	TransitionBoneName="b_Camera_Trans_1st_to_3rd"
	bActuallyUseCameraBone=FALSE

	OriginLocInterpSpeed=10

	bSlideOffsetOnCamModeChange=FALSE

	FinalCamOffsetInterpSpeed=8

	bUseJeffCam=TRUE
	
	//bDisableDynamicSafeZoneUpdates=TRUE
	TargetRelativeCameraOriginOffset=(Z=-5)
}
