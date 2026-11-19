/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoThirdPersonCamera extends GameThirdPersonCamera
	config(Camera)
	native(Camera);

/** First person camera position */
var(Camera) transient protectedwrite editinline	GameThirdPersonCameraMode	FirstPersonCamDefault;
/** First person camera position */
var(Camera) transient protectedwrite editinline	GameThirdPersonCameraMode	NanoCamStandingStill;
var(Camera) config float TimeStandingStillBeforeNanoCamStandingStillActive;
var(Camera) config float TimeFromLastMeleeAttackBeforeNanoCamStandingStillActive;

/** IRIS camera position */
var(Camera) transient protectedwrite editinline GameThirdPersonCameraMode   NanoCamIRIS;
/** Perch camera position */
var(Camera) transient protectedwrite editinline	GameThirdPersonCameraMode	NanoCamPerch;
/** Mantling/Riding on car camera position */
var(Camera) transient protectedwrite editinline	GameThirdPersonCameraMode	NanoCamCar;
/** Drop the Hammer camera position */
var(Camera) transient protectedwrite editinline	GameThirdPersonCameraMode	NanoCamDropTheHammer;
/** Skydive camera position */
var(Camera) transient protectedwrite editinline GameThirdPersonCameraMode   NanoCamSkydive;
/** Mantle camera position */
var(Camera) transient protectedwrite editinline	GameThirdPersonCameraMode	NanoCamMantle;

/** Mantle Low camera position */
var(Camera) transient protectedwrite editinline	GameThirdPersonCameraMode	NanoCamMantleLow;

/** Evade camera position */
var(Camera) transient protectedwrite editinline	GameThirdPersonCameraMode	NanoCamEvade;

/** Melee camera position */
var(Camera) transient protectedwrite editinline	GameThirdPersonCameraMode	NanoCamMelee;
/** Walking around with gun out*/
var(Camera) transient protectedwrite editinline GameThirdPersonCameraMode   NanoCamGunOut;
/** Platforming camera position */
var(Camera) transient protectedwrite editinline	GameThirdPersonCameraMode	NanoCamPlatforming;
/** Camera for when you're sucked into transporter fans */
var(Camera) transient protectedwrite editinline GameThirdPersonCameraMode   NanoCamFan;
/** Elevator camera positions */
var(Camera) transient protectedwrite editinline GameThirdPersonCameraMode   NanoCamElevator;
/** Fire escape camera positions */
var(Camera) transient protectedwrite editinline GameThirdPersonCameraMode   NanoCamFireEscape;
/** Grapple camera positions */
var(Camera) transient protectedwrite editinline GameThirdPersonCameraMode   NanoCamGrapple;
/** Grabbed camera positions */
var(Camera) transient protectedwrite editinline GameThirdPersonCameraMode   NanoCamGrab;

/** MagLev track riding position */
var(Camera) transient protectedwrite editinline GameThirdPersonCameraMode   NanoCamMagLev;
/** Mission briefing camera position */
var(Camera) transient protectedwrite editinline GameThirdPersonCameraMode   NanoCamBriefing;
/** Dash camera position */
var(Camera) transient protectedwrite editinline GameThirdPersonCameraMode   NanoCamDash;
/** Turbine camera position */
var(Camera) transient protectedwrite editinline GameThirdPersonCameraMode   NanoCamTurbine;
/** Over-the-shoulder targeting camera position */
var(Camera) transient protectedwrite editinline GameThirdPersonCameraMode   NanoCamTargeting;
/** Over-the-shoulder targeting camera position */
var(Camera) transient protectedwrite editinline GameThirdPersonCameraMode   NanoCamWireSlide;

/** */
var(Camera) transient protectedwrite editinline GameThirdPersonCameraMode   NanoCam_DBNO_Drag;
var(Camera) transient protectedwrite editinline GameThirdPersonCameraMode   NanoCam_DBNO_Drag_ThrowOffLedge;

/** */
var(Camera) transient protectedwrite editinline GameThirdPersonCameraMode   NanoCam_DBNO_Execute;

/** */
var(Camera) transient protectedwrite editinline GameThirdPersonCameraMode   NanoCam_DBNO_Harvest;

/** */
var(Camera) transient protectedwrite editinline GameThirdPersonCameraMode   NanoCam_DBNO_Interrogate;

/** */
var(Camera) transient protectedwrite editinline GameThirdPersonCameraMode   NanoCam_DBNO_PatDown;



var Cam3p_Default Default3pCam;

/** Whether camera desires 1p/3p -- set by animation nodes */
var(Camera) ENanoCameraTransition DesiredCameraTypeByAnim;

/** Current state of camera transition */
var(Camera) ENanoCameraTransitionState TransitionState;
/** Distance from NanoPawn head center to stop rendering the head */
var(Camera) config float	DistFromHeadThresholdSq;

var(Camera) transient bool bDesiredUseThirdPersonCamera;
var(Camera) transient bool bUseThirdPersonCamera;

/** Last time a desired transition was asked for */
var transient float LastTransitionTime;
/** Minimum amount of time to stay in 1p/3p camera mode unless forced to switch */
var(Camera) config float MinTransitionTime;

var(Camera) config bool bOnlyFirstPerson;
var(Camera) config bool bOnlyThirdPerson;

var transient NanoPawn MyNP;

var(Camera) config bool bThirdPersonTraversal;

// AUTO SLIDE/PAN VARIABLES
/** Amount of pan added to camera after regular interp */
var() Rotator AutoPan;
/** Desired amount of pan to add to camera */
var() Rotator DesiredAutoPan;
/** Interpolation speed of additional camera pan */
var() config float	AutoPanRotInterpSpeed;

/** Amount of translation added to camera after regular interp */
var() Vector  AutoSlide;
/** Desired amount of slide to add to camera */
var() Vector  DesiredAutoSlide;
/** Interpolation speed of addition camera slide */
var() config float AutoSlideLocInterpSpeed;
/** Should use auto slide to slide into new camera mode while not interrupting regular interpolation */
var	  bool		bSlideOffsetOnCamModeChange;

var globalconfig bool   bUseOrbitCam;
var transient Vector	LastPostSafeZoneCameraLoc;
var transient Rotator	LastPostSafeZoneCameraRot;

/** Vars for interpolating camera to a specific rotation. */
var protected transient rotator DesiredRot;
var protected transient rotator DesiredRotInterpFrom;
var protected transient float DesiredRotInterpTime;
var protected transient float DesiredRotInterpTimeRemaining;

/** Pitch limits for camera.  Enforced in camera code, since camera is divorced from the controller. */
var() config protected const int CameraPitchMin;
var() config protected const int CameraPitchMax;

/** Cached camera rotation from last frame.  This is the at-the-pivot rotation, where the camera vector is shot out the -X. */
var protectedwrite transient rotator LastCameraRot;

/** For interpolating lookat loc */
var() protected config const float LookatOffsetInterpSpeed;
var protected transient vector LastLookatOffset;

/** For interpolating JeffCam distance */
var(JeffCam) config protected const float JeffCamDistanceInterpSpeed;
var transient protected float LastJeffCamDist;

/** 
 * When the camera is following the player's pawn with no input we are going to "auto center" to straight back plus this bias.
 * This allows us to have a nice slightly downward looking camera so you don't have to constantly up tap to see where you are going.
 **/
var() config protected rotator FollowCameraRotBias_Walking;
var() config protected rotator FollowCameraRotBias_Jogging;
var() config protected rotator FollowCameraRotBias_Running;

cpptext
{
	UBOOL HandleAnimRequestCameraTransition( BYTE CameraTrans );
	UBOOL IsMatchingCameraType( BYTE TypeA, BYTE TypeB );
	virtual void HandlePawnPenetration(FTViewTarget& OutVT);
	virtual UBOOL ShouldIgnorePenetrationHit(FCheckResult const* Hit, APawn* TargetPawn) const;
	virtual UBOOL ShouldDoPredictavePenetrationAvoidance(APawn* TargetPawn) const;

	virtual void InterpolateCameraOrigin( class APawn* TargetPawn, FLOAT DeltaTime, FVector& out_ActualCameraOrigin, FVector const& IdealCameraOrigin, FRotator& out_ActualCameraOriginRot, FRotator const& IdealCameraOriginRot );

	virtual FVector  GetPostInterpCameraOriginLocationOffset( APawn* TargetPawn ) const;
	virtual FRotator GetPostInterpCameraOriginRotationOffset( APawn* TargetPawn ) const;

	virtual UBOOL HandleCameraSafeZone( FVector& CameraOrigin, FRotator& CameraRotation, FLOAT DeltaTime );
};

native function SetDesiredAutoPan( Rotator Pan );
native function SetDesiredAutoSlide( Vector Slide );

function Init()
{
	if( NanoCamPerch == None )
	{
		FirstPersonCamDefault = CreateCameraMode(class'Cam1p_Default');
		NanoCamStandingStill = CreateCameraMode(class'Cam3p_StandingStill');
		NanoCamIRIS = CreateCameraMode(class'Cam1p_IRIS');
 		NanoCamPerch = CreateCameraMode(class'Cam3p_Perch');
		NanoCamCar = CreateCameraMode(class'Cam3p_Car');
		NanoCamDropTheHammer = CreateCameraMode(class'Cam3p_DropTheHammer');
		NanoCamSkydive = CreateCameraMode(class'Cam3p_Skydive');
		NanoCamMantle = CreateCameraMode(class'Cam3p_Mantle');
		NanoCamMantleLow = CreateCameraMode(class'Cam3p_MantleLow');
		NanoCamEvade = CreateCameraMode(class'Cam3p_Evade');
		NanoCamMelee = CreateCameraMode(class'Cam3p_Melee');
		NanoCamGunOut = CreateCameraMode(class'Cam3p_GunOut');
		NanoCamPlatforming = CreateCameraMode(class'Cam3p_Platforming');
		NanoCamFan = CreateCameraMode(class'Cam3p_Fan');
		NanoCamElevator = CreateCameraMode(class'Cam3p_Elevator');
		NanoCamFireEscape = CreateCameraMode(class'Cam3p_FireEscape');
		NanoCamGrapple = CreateCameraMode(class'Cam3p_Grapple');
		NanoCamGrab = CreateCameraMode(class'Cam3p_Grab');
		NanoCamMagLev = CreateCameraMode(class'Cam3p_MagLev');
		NanoCamBriefing = CreateCameraMode(class'Cam3p_Briefing');
		NanoCamDash = CreateCameraMode(class'Cam3p_Dash');
		NanoCamTurbine = CreateCameraMode(class'Cam3p_Turbine');
		NanoCamTargeting = CreateCameraMode(class'Cam3p_Targeting');
		NanoCamWireSlide = CreateCameraMode(class'Cam3p_WireSlide');

		NanoCam_DBNO_Drag = CreateCameraMode(class'Cam3p_DBNO_Drag');
		NanoCam_DBNO_Drag_ThrowOffLedge = CreateCameraMode(class'Cam3p_DBNO_Drag_ThrowOffLedge');
		NanoCam_DBNO_Execute = CreateCameraMode(class'Cam3p_DBNO_Execute');
		NanoCam_DBNO_Harvest = CreateCameraMode(class'Cam3p_DBNO_Harvest');
		NanoCam_DBNO_Interrogate = CreateCameraMode(class'Cam3p_DBNO_Interrogate');
		NanoCam_DBNO_PatDown = CreateCameraMode(class'Cam3p_DBNO_PatDown');
	}
	
	if (bThirdPersonTraversal || bOnlyThirdPerson)
	{
		bUseThirdPersonCamera = TRUE;
		bDesiredUseThirdPersonCamera = TRUE;
	}
	else if( bOnlyFirstPerson )
	{
		bUseThirdPersonCamera = FALSE;
		bDesiredUseThirdPersonCamera = FALSE;
	}
	LastTransitionTime = -99999.f;

	Super.Init();

	//TEMP:  if the bool is set, overwrite the default camera mode to use orbit cam
	if( bUseOrbitCam )
	{
		ThirdPersonCamDefault = CreateCameraMode(class'Cam3p_Orbit');
	}

	Default3pCam = Cam3p_Default(ThirdPersonCamDefault);
}

/**
 * Evaluates the game state and returns the proper camera mode.
 *
 * @return 	  	new camera mode to use
 */
function GameThirdPersonCameraMode FindBestCameraMode(Pawn P)
{
 	local GameThirdPersonCameraMode NewCamMode;

	MyNP = NanoPawn(P);
	NewCamMode = ThirdPersonCamDefault;

	if( MyNP != None )
	{
		if( bUseThirdPersonCamera != bDesiredUseThirdPersonCamera && `TimeSinceEx(MyNP, LastTransitionTime) > MinTransitionTime )
		{
			bUseThirdPersonCamera = bDesiredUseThirdPersonCamera;
		}

		if( MyNP.ShouldUseThirdPersonCamera() )
		{
			NewCamMode = ThirdPersonCamDefault;
		}
		else
		{
			NewCamMode = FirstPersonCamDefault;
		}


		if( MyNP.bIsAttachedToWall )
		{
			NewCamMode = FirstPersonCamDefault;
		}
		else if( NanoPC(MyNP.Controller).bIRISActive )
		{
			NewCamMode = NanoCamIRIS;
		}
// 		else if( MyNP.IsPlatformJumping() )
// 		{
// 			NewCamMode = NanoCamPlatforming;
// 		}
		else if( NSM_FireEscape(MyNP.ActiveSpecialMove) != None )
		{
			//NewCamMode = NanoCamFireEscape;
			NewCamMode = NanoCamPerch;
		}
		else if ( NSM_WireSlide(MyNP.ActiveSpecialMove) != None )
		{
			NewCamMode = NanoCamWireSlide;
		}
		else if( NSM_Grapple(MyNP.ActiveSpecialMove) != None )
		{
			if (NanoWireBase(NSM_Grapple(MyNP.ActiveSpecialMove).GrappleTarget) != None)
			{
				NewCamMode = NanoCamWireSlide;
			}
			else
			{
				NewCamMode = NanoCamGrapple;
			}
		}
		else if( ( NSM_Melee_GrabVictim(MyNP.ActiveSpecialMove) != None )
			|| ( NSM_Melee_GrabEnemy(MyNP.ActiveSpecialMove) != None )
			|| ( NSM_Melee_GrabAndBeatVictim(MyNP.ActiveSpecialMove) != None )
			|| ( NSM_Melee_GrabAndBeatEnemy(MyNP.ActiveSpecialMove) != None )
			)
		{
			NewCamMode = NanoCamGrab;
		}
		else if (NSM_Turbine(MyNP.ActiveSpecialMove) != None)
		{
			NewCamMode = NanoCamTurbine;
		}
		else if (NanoPerchPoint(MyNP.Base) != None)
		{
			NewCamMode = NanoCamPerch;
		}
		else if( MyNP.IsInDuctFan() )
		{
			NewCamMode = NanoCamFan;
		}
		else if( MyNP.IsInState('MissionBriefing') )
		{
			NewCamMode = NanoCamBriefing;
		}
		else if( MyNP.CurrentMagLevAttractor != None )
		{
			NewCamMode = NanoCamMagLev;
		}
		else if (MyNP.bIsTargeting)
		{
			NewCamMode = NanoCamTargeting;
		}
		else if( MyNP.IsAttachedToPerch() || MyNP.IsElevatorEjectionTarget() || MyNP.bStabMantling || MyNP.bIsDoingStabMantle )
		{
			// Currently, ejection cam is only supported for elevators
			if( (NanoVehicle_ElevatorBase(MyNP.Base) != None) || MyNP.IsElevatorEjectionTarget() )
			{
				NewCamMode = NanoCamElevator;
			}
			else
			{
				NewCamMode = NanoCamCar;
			}
		}
		else if( MyNP.bUseHammerAnim )
		{
			// do not use the hammer camera drop until we can get an animator to fix it up
			//NewCamMode = NanoCamDropTheHammer;
		}
 		else if( MyNP.IsSkydiving() )
 		{
 			NewCamMode = NanoCamSkydive;
 		}
		else if( MyNP.IsInFan() )
		{
			NewCamMode = ThirdPersonCamDefault;
		}
		else if( ( MyNP.MantleState == MANTLE_Waist ) || ( MyNP.MantleState == MANTLE_WaistRoll ) || ( MyNP.MantleState == MANTLE_BigStep ) )
		{
			NewCamMode = NanoCamMantleLow;
		}
		else if( MyNP.MantleState != MANTLE_None )
		{
			NewCamMode = NanoCamMantle;
		}
		else if (MyNP.bDodging)
		{
			NewCamMode = NanoCamEvade;
		}

		// needs to come after all of the "states" that you are dashing when doing (e.g. mantling)
		else if (MyNP.bIsDashing)
		{
			NewCamMode = NanoCamDash;
		}

		else if( NSM_DBNO_InteractionEnemyBase(MyNP.ActiveSpecialMove) != None )
		{
			if( NSM_DBNO_DragEnemy(MyNP.ActiveSpecialMove) != None )
			{
				NewCamMode = NanoCam_DBNO_Drag;
			}
			else if( NSM_DBNO_Drag_ThrowFromLedge_Enemy(MyNP.ActiveSpecialMove) != None )
			{
				NewCamMode = NanoCam_DBNO_Drag_ThrowOffLedge;
			}
			else if( NSM_DBNO_ExecuteEnemy(MyNP.ActiveSpecialMove) != None )
			{
				NewCamMode = NanoCam_DBNO_Execute;
			}
			else if( NSM_DBNO_HarvestEnemy(MyNP.ActiveSpecialMove) != None )
			{
				NewCamMode = NanoCam_DBNO_Harvest;
			}
			else if( NSM_DBNO_InterrogateEnemy(MyNP.ActiveSpecialMove) != None )
			{
				NewCamMode = NanoCam_DBNO_Interrogate;
			}
			else if( NSM_DBNO_PatDownEnemy(MyNP.ActiveSpecialMove) != None )
			{
				NewCamMode = NanoCam_DBNO_PatDown;
			}
		}


		//// so here now we check for guns out and various other velocity type state events

		else if( NanoWeap_MP7(MyNP.Weapon) != None )
		{
			NewCamMode = NanoCamGunOut;
		}
		else if( MyNP.bIsSwordActive || (!MyNP.bIsTargeting && !MyNP.bEmptyHanded) )
 		{
 			NewCamMode = NanoCamMelee;
 		}
		// if we are currently still and have been for a some time
		else if( ( MyNP.ActiveSpecialMove == None )
			&& ( MyNP.bStandingStill == TRUE ) 
			&& ( `TimeSinceEx(MyNP, MyNP.LastStandingStillTime) > TimeStandingStillBeforeNanoCamStandingStillActive )
			&& ( `TimeSinceEx(MyNP, MyNP.LastMeleeAttackTime) > TimeFromLastMeleeAttackBeforeNanoCamStandingStillActive )
			)
		{
			NewCamMode = NanoCamStandingStill;
		}

		
		//// should these be ifs????
		if( bOnlyFirstPerson && NanoThirdPersonCameraMode(NewCamMode).CameraType == ENCT_ThirdPerson )
		{
			NewCamMode = CurrentCamMode;
		}
		else if( bOnlyThirdPerson && NanoThirdPersonCameraMode(NewCamMode).CameraType == ENCT_FirstPerson )
		{
			NewCamMode = CurrentCamMode;
		}
	}
	 
 	return NewCamMode;
}

event bool SetThirdPersonCamera( optional bool bForce )
{
	if (bDesiredUseThirdPersonCamera)
	{
		// no transition needed, already in third
		return FALSE;
	}

	if( bOnlyFirstPerson )
		return FALSE;

	if( MyNP != None )
	{
		if( bForce || !bDesiredUseThirdPersonCamera )
		{
			bDesiredUseThirdPersonCamera = TRUE;
			if( bForce || `TimeSinceEx(MyNP, LastTransitionTime) > MinTransitionTime )
			{
				bUseThirdPersonCamera = TRUE;
				LastTransitionTime = MyNP.WorldInfo.TimeSeconds;
				return TRUE;
			}
		}
		else if( !bUseThirdPersonCamera && bDesiredUseThirdPersonCamera )
		{
			LastTransitionTime = MyNP.WorldInfo.TimeSeconds;
		}
	}

	return FALSE;
}

event bool SetFirstPersonCamera( optional bool bForce )
{
	if (!bDesiredUseThirdPersonCamera)
	{
		// no transition needed, already in first
		return FALSE;
	}

	if( bOnlyThirdPerson )
		return FALSE;

	if (!bForce && bThirdPersonTraversal && ShouldUseThirdPersonCamera())
	{
		return FALSE;
	}

	if( MyNP != None )
	{
		if( bForce || bDesiredUseThirdPersonCamera )
		{
			bDesiredUseThirdPersonCamera = FALSE;
			if( bForce || `TimeSinceEx(MyNP, LastTransitionTime) > MinTransitionTime )
			{
				bUseThirdPersonCamera = FALSE;
				LastTransitionTime = MyNP.WorldInfo.TimeSeconds;
				return TRUE;
			}
		}
	}

	return FALSE;
}

simulated event bool ShouldUseThirdPersonCamera()
{
	if( MyNP == None )
	{
		return FALSE;
	}

	if (bThirdPersonTraversal && NanoWeap_MP7(MyNP.Weapon) == None)
	{
		return TRUE;
	}

	if( Pacifier_LimbBase(MyNP.Base) != None )
	{
		return TRUE;
	}

	if( MyNP.bIsSwordDashing || MyNP.bBRINGDAHAMMER )
	{
		return TRUE;
	}

	if( MyNP.IsAttachedToPerch() || MyNP.bStabMantling || NanoPerchPoint(MyNP.Base) != None )
	{
		return TRUE;
	}

	if( !MyNP.bIsAttachedToWall && !NanoPC(MyNP.Controller).bIRISActive )
	{
		if( bUseThirdPersonCamera )
		{
			return TRUE;
		}
	}
	return FALSE;
}

/** Overridden to handle POIs */
protected function vector GetActualFocusLocation()
{
 	local NanoPointOfInterest POI;
 
 	if (FocusPoint.FocusActor != None)
 	{
  		POI = NanoPointOfInterest(FocusPoint.FocusActor);
  		if (POI != None)
  		{
  			// looking at an actual POI, let it tell us where to look
  			return POI.GetActualLookatLocation();
  		}
 	}

	return super.GetActualFocusLocation();
}

/**
 * Per-tick focus point processing, for polling gamestate and adjusting as desired.
 */
protected event UpdateFocusPoint( Pawn P )
{
	local NanoPCBase	NPC;

	NPC = NanoPCBase(P.Controller);

	if (bDoingACameraTurn)
	{
		// no POIs during camera turns
		ClearFocusPoint();
	}
 	else if( NPC != None && NPC.bLookingAtPointOfInterest )
 	{
 		// NanoPCBase is driving things, so don't override it with the below checks
 		// still need this here, since this function polls the gamestate for focus points.
 		// nothing to really do here, though.
 	}
 	// give the camera mode a crack at it
	else
	{
		// Clear the focus if there's no camera mode
		if( CurrentCamMode == None )
		{
			ClearFocusPoint();
		}
		// Allow the camera to override the focus, but do NOT clear the point if it decides it doesn't want to set a new point
		else
		{
			CurrentCamMode.SetFocusPoint(P);
		}
	}

	if (bFocusPointSet)
	{
		// store old focus loc
		LastFocusPointLoc = ActualFocusPointWorldLoc;
		ActualFocusPointWorldLoc = GetActualFocusLocation();
	}
}

function SetAutoSlideAndPanInterpSpeeds( float NewSlideInterpSpeed, float NewRotInterpSpeed )
{
	AutoSlideLocInterpSpeed = NewSlideInterpSpeed;
	AutoPanRotInterpSpeed = NewRotInterpSpeed;
}

function ResetAutoSlideAndPanInterpSpeeds()
{
	AutoSlideLocInterpSpeed = default.AutoSlideLocInterpSpeed;
	AutoPanRotInterpSpeed = default.AutoPanRotInterpSpeed;
}

/** Internal camera updating code */
native protected function PlayerUpdateCamera(Pawn P, GamePlayerCamera CameraActor, float DeltaTime, out TViewTarget OutVT);

/** Interps camera to given rot over given time period. */
function InterpToRot(rotator NewDesiredRot, float InterpTime)
{
	local rotator DeltaRot;

	DesiredRotInterpFrom = Normalize(PlayerCamera.CameraCache.POV.Rotation);

	// normalize the delta to ensure we get the shortest path
	DesiredRot = PlayerCamera.PCOwner.LimitViewRotation(NewDesiredRot, CameraPitchMin, CameraPitchMax);
	DeltaRot = Normalize(DesiredRot - DesiredRotInterpFrom);
	DesiredRot = DesiredRotInterpFrom + DeltaRot;

	DesiredRotInterpTimeRemaining = InterpTime;
	DesiredRotInterpTime = InterpTime;
}

defaultproperties
{
	ThirdPersonCamDefaultClass=class'Cam3p_Default'

	bDrawDebug=FALSE
}