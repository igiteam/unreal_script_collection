/**
 * GearPlayerInput
 * Gear player input post processing
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearPlayerInput extends GearPlayerInput_Base
	native
	transient;

/************************************************************************/
/* Member variables, structs, enums, etc.                               */
/************************************************************************/

var() protected config float TargetingModeViewScalePct;

/** Enable view acceleration? */
var() bool bViewAccelEnabled;
/** Acceleration multiplier */
var() float YawAccelMultiplier;
/** Threshold above when Yaw Acceleration kicks in*/
var() float YawAccelThreshold;
/** Time for Yaw Accel to ramp up */
var() float YawAccelRampUpTime;
/** Yaw acceleration percentage applied when fading in or out */
var float YawAccelPct;
var float PitchAccelPct;

/** Acceleration multiplier */
var() float YawAccelMultiplier_Targeting;
/** Threshold above when Yaw Acceleration kicks in*/
var() float YawAccelThreshold_Targeting;
/** Time for Yaw Accel to ramp up */
var() float YawAccelRampUpTime_Targeting;



/** auto pitch centering if true */
var() config bool	bAutoCenterPitch;
/** Pitch auto centering speed */
var() config float	PitchAutoCenterSpeed;
/** Pitch auto centering speed when roadie running */
var() config float	PitchAutoCenterSpeedRoadieRun;
/** Pitch auto centering speed when roadie run stabbing */
var() config float	PitchAutoCenterSpeedRoadieRunStab;
/** delay before starting auto centering when moving */
var() config float	PitchAutoCenterDelay;
/** count for delay */
var float PitchAutoCenterDelayCount;
/** Offset applied to the autocentering pitch window to enable manipulation of the "horizon", in rotator units. */
var float PitchAutoCenterHorizonOffset;

var transient bool bPlayerInterruptedRoadieRunPitchAutoCentering;

var bool bAppliedFriction;

/**
 * Defines the size of the pitch "window".	Centering will stop/not start if the pitch is in this window .
 * This is a min/max pair of angle values, in rotator units.
 */
var() vector2d PitchAutoCenterTargetPitchWindow;
var() config vector2d PitchAutoCenterTargetPitchWindow_RoadieRun;

/**
 * The value at which we should transition from walk to run and back to walk.
 * @see PreProcessInput
 **/
var() config float RunWalkTransitionThreshold;

//debug
var bool bDebugFriction, bDebugAdhesion, bDebugViewAccel;
var private float LastDistToTarget, LastDistMultiplier, LastDistFromAimZ, LastDistFromAimY, LastFrictionMultiplier, LastAdhesionAmtY, LastAdhesionAmtZ;
var private float LastTargetWidth, LastTargetHeight, LastDistFromAimYa, LastDistFromAimZa, LastAdjustY, LastAdjustZ;
var private Vector LastCamLoc;
var private Rotator LastDeltaRot;
var private float LastTargVelDotTurnDir, LastCamRotDotTargY;

/** Last time that the player gave any input */
var transient float LastInputTime;

/** True if pitch is being force-centered, false otherwise. */
var private transient bool	bForcePitchCentering;
/** How fast the camera centers when using forced pitch centering. */
var() private float			ForcePitchCenteringSpeed;
/** Horizon offset to be applied only for this particular instance of forced pitch centering */
var private transient float ForcedPitchCenteringHorizonOffset;
/** True if forced pitch centering can be cancelled by user input. */
var private transient bool	bForcePitchCenteringIsInterruptable;

/** aStrafe value from last tick. */
var float LastStrafe;
/** aForward value from last tick. */
var float LastForward;
/** Cached value of aStrafe from this frame (since the axes get cleared in the low level code) */
var float CachedStrafe;
/** Cached value of aStrafe from this frame (since the axes get cleared in the low level code) */
var float CachedForward;

/** Are we currently recording a demo? */
var bool bRecording;
/** Which recording are on? */
var int DemoCount;

var transient float LastaTurn;
var transient float LastaLookup;

var transient float LastRightAnalogTrigger;
var transient float LastLeftAnalogTrigger;

/** Bool to toggle between old (g1/g2) input code and new rift code. */
var() config bool bNewInput;

/** Apologies for the kludginess here, experimental for now, to be cleaned up later. */
var() bool bDoPitchAccelToo;
var() float LookAccelExponent;
var() float LookDecelInterpSpeed;
var() float LookDecelInterpSpeed_Targeting;
var() float LookAccelInterpSpeed;
var() float LookStickDeadZone;
var() float LookPitchSensivityRatio;

var transient byte bNumLookAxesReceived;
var transient float GamepadLookXDelta, GamepadLookYDelta;

var protected transient string DefaultLookXBindingText;
var protected transient string DefaultLookYBindingText;

cpptext
{
protected:
	void HandleLookStickDeadZone(FLOAT& X, FLOAT& Y) const;
public:
	virtual void UpdateAxisValue( FLOAT* Axis, FLOAT Delta );
};


/************************************************************************/
/* Native Script functions                                              */
/************************************************************************/

/** Will return the BindName based on the BindCommand */
native function String GetGearBindNameFromCommand( String BindCommand );

/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

/** Sets the input handlers for the button handling list - set by subclasses */
event InitializeButtonHandlingHandlers()
{
	InputButtonDataList[GB_A].ButtonHandler					= HandleButtonInput_A;
	InputButtonDataList[GB_X].ButtonHandler					= bUseAlternateControls ? HandleNonCoverMoves : HandleButtonInput_X;
	InputButtonDataList[GB_Y].ButtonHandler					= bUseAlternateControls ? HandleButtonInput_X : HandleButtonInput_Y;
	InputButtonDataList[GB_B].ButtonHandler					= HandleButtonInput_B;
	InputButtonDataList[GB_Start].ButtonHandler				= HandleButtonInput_Start;
	InputButtonDataList[GB_Back].ButtonHandler				= HandleButtonInput_Back;
	InputButtonDataList[GB_LeftTrigger].ButtonHandler		= HandleButtonInput_LeftTrigger;
	InputButtonDataList[GB_LeftBumper].ButtonHandler		= HandleButtonInput_LeftBumper;
	InputButtonDataList[GB_RightTrigger].ButtonHandler		= HandleButtonInput_RightTrigger;
	InputButtonDataList[GB_RightBumper].ButtonHandler		= HandleButtonInput_RightBumper;
	InputButtonDataList[GB_DPad_Up].ButtonHandler			= HandleButtonInput_DPad_Up;
	InputButtonDataList[GB_DPad_Left].ButtonHandler			= HandleButtonInput_DPad_Left;
	InputButtonDataList[GB_DPad_Down].ButtonHandler			= HandleButtonInput_DPad_Down;
	InputButtonDataList[GB_DPad_Right].ButtonHandler		= HandleButtonInput_DPad_Right;
	InputButtonDataList[GB_LeftStick_Push].ButtonHandler	= HandleButtonInput_LeftStickButton;
	InputButtonDataList[GB_RightStick_Push].ButtonHandler	= bUseAlternateControls ? HandleButtonInput_Y : HandleButtonInput_RightStickButton;
}

/** Called when the top most input object is popped off of the stack and now this input object will become first in line. */
function PoppedToTopOfInputStack( GearPlayerInput_Base PrevInputObject, bool bWipePrevInputState )
{
	// If the previous input object was derived from this class, we're going to copy the state of the previous input object
	if ( ClassIsChildOf(PrevInputObject.Class, Class) )
	{
		bWipePrevInputState = false;
	}

	Super.PoppedToTopOfInputStack( PrevInputObject, bWipePrevInputState );
}

/**
 * Pass TRUE to start forced pitch centering, FALSE to stop it.	 Centering will
 * occur until it is complete and then stop -- note it doesn't lock pitch to 0.
 * GoalPitch is the pitch we'll move toward.
 * If bCancelOnUserInput is TRUE, any attempts by the player to change pitch will cancel the pitch centering (to avoid fighting).
 */
simulated final function ForcePitchCentering(bool bCenter, optional bool bCancelOnUserInput, optional float GoalPitch, optional float InterpSpeed)
{
	bForcePitchCentering = bCenter;
	bForcePitchCenteringIsInterruptable = bCancelOnUserInput;
	ForcedPitchCenteringHorizonOffset = GoalPitch;
	ForcePitchCenteringSpeed = (InterpSpeed == 0.f) ? default.ForcePitchCenteringSpeed : InterpSpeed;
}

function ApplyTestTurningFunction(float val)
{
	local bool bWasNeg;
	bWasNeg = val < 0;

	val = Abs(val) ** LookAccelExponent;

	if (bWasNeg)
	{
		val = -val;
	}
}

/** Enables toggling between old G2 and new G3 input handling. */
exec function NewInput(bool bUseNewInput)
{
	local int BindingIdx;

	bNewInput = bUseNewInput;

	BindingIdx = Bindings.Find('Name', 'GBA_LookX');
	if (BindingIdx != INDEX_NONE)
	{
		if (DefaultLookXBindingText == "")
		{
			DefaultLookXBindingText = Bindings[BindingIdx].Command;
		}

		Bindings[BindingIdx].Command = bNewInput ?
			DefaultLookXBindingText
			: "Axis aTurn Speed=1.0 DeadZone=0.3";
	}

	BindingIdx = Bindings.Find('Name', 'GBA_LookY');
	if (BindingIdx != INDEX_NONE)
	{
		if (DefaultLookYBindingText == "")
		{
			DefaultLookYBindingText = Bindings[BindingIdx].Command;
		}

		Bindings[BindingIdx].Command = bNewInput ?
			DefaultLookYBindingText
			: "Axis aLookUp Speed=0.7 DeadZone=0.3";
	}

	YawAccelThreshold = bNewInput ? default.YawAccelThreshold : 0.95f;
	YawAccelThreshold_Targeting = bNewInput ? default.YawAccelThreshold_Targeting : 0.95f;

	YawAccelMultiplier_Targeting = bNewInput ? default.YawAccelMultiplier_Targeting : default.YawAccelMultiplier;
	YawAccelRampUpTime_Targeting = bNewInput ? default.YawAccelRampUpTime_Targeting: default.YawAccelRampUpTime;

	ClientMessage("bNewInput is"@bNewInput);
}


/**
 * Overridden to add hooks for view acceleration and roadie run.
 */
function PreProcessInput(float DeltaTime)
{
	local GearPawn	P;
	local GearVehicle WV;
	local GearWeaponPawn WP;
	local int SeatIndex;
	local GearWeapon W;
	local bool bIsDoingASpecialMove;
//
// 	if (bNewInput)
// 	{
// 		HandleDeadZone();
// 	}

	Super.PreProcessInput(DeltaTime);

	bAppliedFriction = FALSE;

	P = GearPawn(Pawn);
	if( P != None )
	{
		bIsDoingASpecialMove = P.IsDoingASpecialMove();
		// Special Moves can affect input
		if( bIsDoingASpecialMove )
		{
			P.SpecialMoves[P.SpecialMove].PreProcessInput(Self);
		}
		// GearPawns can affect input if special moves do not
		else
		{
			P.PreProcessInput(self);
		}

		// apply view friction
		W = P.MyGearWeapon;
		if (W != None)
		{
			if (P.bIsTargeting)
			{
				ViewFriction(DeltaTime,W);
			}

			W.PreProcessInput(self);
		}

		// set run based on how much the stick is pressed
		bRun = (Square(RawJoyUp) + Square(RawJoyRight)) > Square(RunWalkTransitionThreshold) ? 1 : 0;
	}
	else
	{
		// Handle posessing a GearWeaponPawn
		WV = GearVehicle(Pawn);
		if (WV == None)
		{
			WP = GearWeaponPawn(Pawn);
			if (WP != None)
			{
				WV = WP.MyVehicle;
				SeatIndex = WP.MySeatIndex;
			}
		}

		// Got a vehicle
		if(WV != None)
		{
			W = WV.Seats[SeatIndex].Gun;
			if (W != None)
			{
				if (bIsTargeting || WV.bAlwaysViewFriction)
				{
					ViewFriction(DeltaTime, W);
				}

				W.PreProcessInput(self);
			}
		}
	}

	if (bNewInput)
	{
		ApplyTestTurningFunction(aTurn);
		if (bDoPitchAccelToo)
		{
			ApplyTestTurningFunction(aLookUp);
		}
	}

	// Accelerate Joystick turning rate
	if( bViewAccelEnabled && !bAppliedFriction )
	{
		ViewAcceleration(DeltaTime);

		if (bNewInput && bDoPitchAccelToo)
		{
			ViewPitchAcceleration(DeltaTime);
		}
	}

	if (bNewInput)
	{
		ApplyTurnDeceleration(DeltaTime);
	}

	LastaTurn = aTurn;
	LastaLookUp = aLookUp;
	LastRightAnalogTrigger = aRightAnalogTrigger;
	LastLeftAnalogTrigger = aLeftAnalogTrigger;
}

function ApplyTurnDeceleration(float DeltaTime)
{
	local float DecelSpeed;

	DecelSpeed = bIsTargeting ? LookDecelInterpSpeed : LookDecelInterpSpeed_Targeting;

	if ( (aTurn == 0) && (LastaTurn != 0) )
	{
		aTurn = FInterpTo(LastaTurn, aTurn, DeltaTime, DecelSpeed);
	}
	else if (LookAccelInterpSpeed > 0.f && abs(aTurn) > abs(LastaTurn) && bIsTargeting)
	{
		aTurn = FInterpTo(LastaTurn, aTurn, DeltaTime, LookAccelInterpSpeed);
	}

	if (bDoPitchAccelToo)
	{
		if ( (aLookUp == 0) && (LastaLookUp != 0) )
		{
			aLookUp = FInterpTo(LastaLookUp, aLookUp, DeltaTime, DecelSpeed);
		}
		else if (LookAccelInterpSpeed > 0.f && abs(aLookUp) > abs(LastaLookUp) && bIsTargeting)
		{
			aLookUp = FInterpTo(LastaLookUp, aLookUp, DeltaTime, LookAccelInterpSpeed);
		}
	}
}

/**
 * Overloaded to handle various game features.
 */
event PlayerInput( float DeltaTime )
{
	local vector CamLoc;
	local rotator CamRot;
	local GearPawn GP;

	// clear the friction flag
	bAppliedFriction = FALSE;

	if (Pawn != None && !Pawn.bCanStrafe && GearVehicle(Pawn) == None && GearWeaponPawn(Pawn) == None)
	{
		// Allow the gearpawn to override the bCanStrafe flag
		GP = GearPawn(Pawn);
		if (GP == None || !GP.CanStrafe())
		{
			aStrafe = 0.f;
		}
	}

	// save some prev values
	LastStrafe = CachedStrafe;
	LastForward = CachedForward;

	Super.PlayerInput(DeltaTime);

	// save cur values
	CachedStrafe = aStrafe;
	CachedForward = aForward;

	// this needs to happen after aForward has been updated.
	if( bAutoCenterPitch && !bAppliedFriction && Pawn != None)
	{
		AutoPitchCentering( DeltaTime );
	}
	// remap the joy inputs
	RemappedJoyRight = RawJoyRight;
	RemappedJoyUp = RawJoyUp;
	if (IsInCoverState())
	{
		GetPlayerViewPoint(CamLoc, CamRot);
		ControlsRemapRotation = CamRot;
		RemapControlsByRotation(Normalize(Pawn.Rotation - ControlsRemapRotation), RemappedJoyRight, RemappedJoyUp);
	}

	if (!IsIdle())
	{
		LastInputTime = WorldInfo.TimeSeconds;
	}

	// This will apply the sensitivity scaling to the controller inputs
	ApplySensitivityScaling();
	if (bNewInput)
	{
		aLookup *= LookPitchSensivityRatio;
	}

	// If MyGearPawn is grabbing movable cover, check if the cover object should be manipulated
	if (MyGearPawn != None && MyGearPawn.bGrabbingMovableCover)
	{
		TryManipulateCover();
	}
}

/**
 * Automatic pitch centering.
 */
final function AutoPitchCentering( float DeltaTime )
{
	local float	CurrentPitch, TargetPitch, Delta, PitchWindowOffset;
	local GearPawn GP;
	local vector2d PitchWindow;
	local vector PawnX, PawnY, PawnZ, SurfaceFwd, SurfaceRight, SurfaceUp;
	local rotator SurfaceRot;
	local bool bRoadieRunning;
	local bool bRoadieRunStabbing;

	CurrentPitch = float(NormalizeRotAxis(Rotation.Pitch));

	GP = GearPawn(Pawn);
	if ( GP != None)
	{
		if (GP.IsDoingSpecialMove(SM_RoadieRun))
		{
			bRoadieRunning = true;
		}
		else if (GP.IsDoingSpecialMove(SM_RoadieRunStab))
		{
			bRoadieRunStabbing = true;
		}
	}

	// if player tries to look around while roadie running, cancel RR-based pitch centering until
	// another roadie run begins
	if (bRoadieRunning)
	{
		if (aLookUp != 0)
		{
			bPlayerInterruptedRoadieRunPitchAutoCentering = TRUE;
		}
	}
	else
	{
		bPlayerInterruptedRoadieRunPitchAutoCentering = FALSE;
	}

	// see if pitch centering was interrupted by the user changing pitch manually
	if ( bForcePitchCenteringIsInterruptable && (aLookUp != 0.f) )
	{
		bForcePitchCentering = FALSE;
	}

	if (!bForcePitchCentering)
	{
		if (IsInCoverState())
		{
			if (aLookUp != 0 ||
				VSize(Pawn.Velocity) < 1.f ||
				bIsTargeting ||
				GP.IsWeaponPendingFire(0))
			{
				PitchAutoCenterDelayCount = 0.f;
				return;
			}
		}
		else
		if( (aLookUp != 0) ||
			(aForward == 0 && aStrafe == 0) ||
			(Pawn != None && VSize(Pawn.Velocity) < 1.f) )
		{
			PitchAutoCenterDelayCount = 0.f;
			return;
		}

		if ( (PitchAutoCenterDelayCount < PitchAutoCenterDelay) && (!bRoadieRunning || bPlayerInterruptedRoadieRunPitchAutoCentering) )
		{
			PitchAutoCenterDelayCount += DeltaTime;
			return;
		}
	}

	// maybe modify pitchwindow (eg if roadie running on slope)
	PitchWindow = bRoadieRunning  ? PitchAutoCenterTargetPitchWindow_RoadieRun : PitchAutoCenterTargetPitchWindow;
	if ((bRoadieRunning || bRoadieRunStabbing) && !bPlayerInterruptedRoadieRunPitchAutoCentering)
	{
		// construct the player's orientation "stuck" to the surface of the ground
		GetAxes(GP.Rotation, PawnX, PawnY, PawnZ);
		SurfaceUp = GP.Floor;
		SurfaceRight = SurfaceUp cross PawnX;
		SurfaceFwd = SurfaceUp cross SurfaceRight;
		SurfaceRot = OrthoRotation(SurfaceFwd, SurfaceRight, SurfaceUp);

		// adjust pitch window accordingly
		PitchWindowOffset = -SurfaceRot.Pitch;
	}

	// apply any horizon adjustments
	PitchWindowOffset += PitchAutoCenterHorizonOffset;
	if (bForcePitchCentering)
	{
		PitchWindowOffset += ForcedPitchCenteringHorizonOffset;
	}

	// calc final pitch window
	PitchWindow.X = NormalizeRotAxis(PitchWindow.X + PitchWindowOffset);
	PitchWindow.Y = NormalizeRotAxis(PitchWindow.Y + PitchWindowOffset);

	if (PitchWindow.Y < CurrentPitch)
	{
		TargetPitch = PitchWindow.Y;
	}
	else if (PitchWindow.X > CurrentPitch)
	{
		TargetPitch = PitchWindow.X;
	}
	else
	{
		// current pitch is in the acceptable window, do nothing;
		return;
	}

	// calc how much to interpolate
	if (bForcePitchCentering)
	{
		Delta = FInterpTo(CurrentPitch, TargetPitch, DeltaTime, ForcePitchCenteringSpeed) - CurrentPitch;
	}
	else if (bRoadieRunStabbing)
	{
		Delta = FInterpTo(CurrentPitch, TargetPitch, DeltaTime, PitchAutoCenterSpeedRoadieRunStab) - CurrentPitch;
	}
	else if (bRoadieRunning && !bPlayerInterruptedRoadieRunPitchAutoCentering)
	{
		Delta = FInterpTo(CurrentPitch, TargetPitch, DeltaTime, PitchAutoCenterSpeedRoadieRun) - CurrentPitch;
	}
	else
	{
		if (bIsTargeting||
			(WalkVolume(Pawn.PhysicsVolume) != None &&
			 WalkVolume(Pawn.PhysicsVolume).bActive))
		{
			Delta = FInterpTo(CurrentPitch, TargetPitch, DeltaTime, PitchAutoCenterSpeed * 0.5f) - CurrentPitch;
		}
		else
		{
			Delta = FInterpTo(CurrentPitch, TargetPitch, DeltaTime, PitchAutoCenterSpeed) - CurrentPitch;
		}
	}

	// the 5 is arbitrary, chosen because it just feels good
	if (Abs(Delta) < 5.f)
	{
		//Roadie run stabbing must always recenter for you to handle slopes.
		if (!bRoadieRunStabbing)
		{
			// finished centering!
			bForcePitchCentering = FALSE;
		}
	}

	aLookup += Delta;
}


final function ViewFriction( float DeltaTime, GearWeapon W )
{
	local Actor FrictionTarget;
	local Vector CamLoc, X, Y, Z, CamToTarget, AimLoc, TargetLoc, RealTargetLoc, TargetCenter;
	local Rotator CamRot;
	local float DistToTarget, DistMultiplier, DistFromAimZ, DistFromAimY;
	local float TargetWidth, TargetHeight;
	local float FrictionMultiplier;
	local bool bTargetMoving;
	local Vector TargX, TargY, TargZ;
	local Vector TurnY;
	local float TargVelDotTurnDir, CamRotDotTargY;

//	local float Time;
//	CLOCK_CYCLES(time);

	if( Pawn == None )
	{
		return;
	}

	// Setup some initial data
	GetPlayerViewPoint( CamLoc, CamRot );
	GetAxes( CamRot, X, Y, Z );

	// Look for a friction target
	FrictionTarget = GetFrictionAdhesionTarget(W.MaxFrictionDistance);

	// If we have a valid friction target
	if( FrictionTarget != None )
	{
		// Grab collision info from target
		FrictionTarget.GetAimFrictionExtent(TargetWidth, TargetHeight, TargetCenter);

		RealTargetLoc = TargetCenter + (W.FrictionTargetOffset >> CamRot);
		CamToTarget = (RealTargetLoc - CamLoc);
		DistToTarget = VSize(CamToTarget);
		AimLoc = CamLoc + (X * DistToTarget);

		// Get directions for turning and target movement
		bTargetMoving = VSize(FrictionTarget.Velocity) > 50.f && Abs(aTurn) > 0;
		GetAxes( Rotator(CamToTarget), TargX, TargY, TargZ );
		TurnY = Y;
		if( aTurn < 0 )
		{
			TurnY = -Y;
			TargY = -TargY;
		}

		//debug
		//DrawDebugLine( FrictionTarget.Location, FrictionTarget.Location + FrictionTarget.Velocity, 255, 0, 0 );
		//DrawDebugLine( Pawn.GetPawnViewLocation(), Pawn.GetPawnViewLocation() + TurnY * 128.f, 255, 0, 0 );
		//DrawDebugLine( Pawn.GetPawnViewLocation(), Pawn.GetPawnViewLocation() + TargY * 128.f, 0, 0, 255 );
		//DrawDebugCylinder(FrictionTarget.Location+vect(0,0,1)*TargetHeight, FrictionTarget.Location-vect(0,0,1)*TargetHeight, TargetWidth, 12, 255, 0, 0);

		// Calculate the aim friction multiplier
		// Y component
		TargetLoc	 = RealTargetLoc;
		TargetLoc.Z	 = AimLoc.Z;
		DistFromAimY = PointDistToLine(AimLoc,(TargetLoc - CamLoc),CamLoc);
		// Z component
		TargetLoc	 = RealTargetLoc;
		TargetLoc.X	 = AimLoc.X;
		TargetLoc.Y	 = AimLoc.Y;
		DistFromAimZ = PointDistToLine(AimLoc,(TargetLoc - CamLoc),CamLoc);

		// Calculate the distance multiplier
		DistMultiplier = 0.f;
		if( DistToTarget >= W.MinFrictionDistance &&
			DistToTarget <= W.MaxFrictionDistance )
		{
			if( DistToTarget <= W.PeakFrictionDistance )
			{
				// Ramp up to peak
				DistMultiplier = FClamp((DistToTarget - W.MinFrictionDistance)/(W.PeakFrictionDistance - W.MinFrictionDistance),0.f,1.f);
			}
			else
			{
				// Ramp down from peak
				DistMultiplier = FClamp(1.f - (DistToTarget - W.PeakFrictionDistance)/(W.MaxFrictionDistance - W.PeakFrictionDistance),0.f,1.f);
			}

			// Scale target radius by distance
			TargetWidth *= 1.f + (W.PeakFrictionRadiusScale * DistMultiplier);
			TargetHeight *= 1.f + (W.PeakFrictionHeightScale * DistMultiplier);
		}

		// If we should apply friction - must be within friction collision box
		if( DistFromAimY < TargetWidth &&
			DistFromAimZ < TargetHeight )
		{
			// Calculate the final multiplier (only based on horizontal turn)
			FrictionMultiplier = GetRangeValueByPct( W.FrictionMultiplierRange, 1.f - (DistFromAimY/TargetWidth) );

			if (GearAimAssistActor(FrictionTarget) != None)
			{
				FrictionMultiplier *= GearAimAssistActor(FrictionTarget).FrictionScale;
			}

			// If target is moving
			if( bTargetMoving )
			{
				TargVelDotTurnDir = Normal(FrictionTarget.Velocity) DOT TurnY;
				CamRotDotTargY = X DOT TargY;
				// If target is moving away from your crosshair and you are trailing him
				if( TargVelDotTurnDir > 0.5f && CamRotDotTargY < 0.f )
				{
					// No friction!
					FrictionMultiplier = 0.f;
				}

				// When aiming with the sniper, it's easy to get the friction stuck on a running enemy.
				// Reduce the friction by 50% to allow a bit more freedom.
				if (abs(aTurn) > 0.97f)
				{
					FrictionMultiplier *= 0.5f;
				}
			}

			//WorldInfo.AddOnScreenDebugMessage(0, 1.f, MakeColor(128,192,128,255), "aTurn:" @ abs(aTurn));

			if( FrictionMultiplier > 0.f )
			{
				bAppliedFriction = TRUE;

				// Apply the friction
				aTurn *= FMax((1.f - FrictionMultiplier), 0.f);

				// GAAAs apply friction vertically as well
				if (GearAimAssistActor(FrictionTarget) != None)
				{
					aLookUp *= FMax((1.f - FrictionMultiplier), 0.f);
				}

				// Keep the friction target for possible use with adhesion
				LastFrictionTargetTime	= WorldInfo.TimeSeconds;
				LastFrictionTarget		= FrictionTarget;
			}

			//WorldInfo.AddOnScreenDebugMessage(1, 1.f, MakeColor(128,192,128,255), "bAppliedFriction:" @ bAppliedFriction);
			//WorldInfo.AddOnScreenDebugMessage(2, 1.f, MakeColor(128,192,128,255), "bTargetMoving:" @ bTargetMoving);
			//WorldInfo.AddOnScreenDebugMessage(3, 1.f, MakeColor(128,192,128,255), "TargVelDotTurnDir:" @ TargVelDotTurnDir);
			//WorldInfo.AddOnScreenDebugMessage(4, 1.f, MakeColor(128,192,128,255), "CamRotDotTargY:" @ CamRotDotTargY);
		}
	}

`if(`notdefined(FINAL_RELEASE))
	// debug
	LastDistToTarget = DistToTarget;
	LastDistMultiplier = DistMultiplier;
	LastDistFromAimZ = DistFromAimZ;
	LastDistFromAimY = DistFromAimY;
	LastFrictionMultiplier = FrictionMultiplier;
	LastTargetWidth = TargetWidth;
	LastTargetHeight = TargetHeight;
	LastCamLoc = CamLoc;
	LastTargVelDotTurnDir = TargVelDotTurnDir;
	LastCamRotDotTargY = CamRotDotTargY;
`endif

	//UNCLOCK_CYCLES(Time);
	//`log("ViewFriction time"@Time);
}


// @see GearPC.ApplyAdhesion
// NOTE: this was reworked to work for GearAimAttractors for the Hydra level.  Prolly needs a little
// love to work in general gamewide cases.
final function ViewAdhesion( float DeltaTime, GearWeapon W, out int out_YawRot, out int out_PitchRot )
{
	local Vector	RealTargetLoc, TargetCenter, CamLoc ;
	local Vector	X, Y, Z;
	local Rotator	CamRot, DeltaRot;
	local float		TargetRadius, TargetHeight;
	local GearPawn	P;
	local GearAimAssistActor GAAA;
	local Actor		AdhesionTarget;

	local vector ClosestPt;
	local float DistFromAim, AdhScale;
	local rotator NewRotation;

	P = GearPawn(Pawn);
	if( W == None ||
		(P != None && P.IsDoingASpecialMove()) ||
		((aTurn == 0.f) && (aLookUp == 0.f)) )
	{
		return;
	}

	// Setup some initial data
	GetPlayerViewPoint( CamLoc, CamRot );
	GetAxes( CamRot, X, Y, Z );

	// attempt to use the friction target if available
	AdhesionTarget = LastFrictionTarget;
	if (AdhesionTarget == None || `TimeSince(LastFrictionTargetTime) > W.MaxAdhesionTime)
	{
		// otherwise look for a new target
		AdhesionTarget = GetFrictionAdhesionTarget(W.MaxAdhesionDistance, TRUE);
	}

	// If still within adhesion time constraints, and the target is still alive
	if (AdhesionTarget != None)
	{
		GAAA = GearAimAssistActor(AdhesionTarget);

		// Grab collision info from target
		AdhesionTarget.GetAimAdhesionExtent( TargetRadius, TargetHeight, TargetCenter );
		RealTargetLoc = TargetCenter;	// + (W.FrictionTargetOffset >> CamRot);

		if( ((RealTargetLoc - CamLoc) DOT Vector(CamRot) > 0.f) )
		{
			DistFromAim = PointDistToLine(RealTargetLoc, vector(Rotation), CamLoc, ClosestPt);

			if (DistFromAim < TargetRadius)
			{
				AdhScale = (1.f - (DistFromAim / TargetRadius)) * GAAA.AdhesionScale;
				AdhScale = FMax(AdhScale, 0.5f);
				if (AdhScale > 0.f)
				{
					NewRotation = Rotator(RealTargetLoc - CamLoc);
					NewRotation = RInterpTo(Normalize(Rotation), Normalize(NewRotation), DeltaTime, AdhScale);
					DeltaRot		= Normalize(NewRotation - Rotation);

					//`log("scale"@AdhScale@"turn"@aTurn@DeltaRot.Yaw@"up"@aLookUp@DeltaRot.Pitch);
					//`log("... "@DistFromAim@TargetRadius@1.f - DistFromAim/TargetRadius);

					//// allow pulling away
					//if ( ((aTurn > 0.f) && (DeltaRot.Yaw < 0.f)) || ((aTurn < 0.f) && (DeltaRot.Yaw > 0.f)) )
					//{
					//	`LOG(".. neutered yaw");
					//	DeltaRot.Yaw = 0;
					//}
					//if ( ((aLookUp > 0.f) && (DeltaRot.Pitch < 0.f)) || ((aLookUp < 0.f) && (DeltaRot.Pitch > 0.f)) )
					//{
					//	`LOG(".. neutered pitch");
					//	DeltaRot.Pitch = 0;
					//}
					out_YawRot		+= DeltaRot.Yaw;
					out_PitchRot	+= DeltaRot.Pitch;
				}
			}
		}
	}

	//debug
//	LastAdhesionAmtY = AdhesionAmtY;
//	LastAdhesionAmtZ = AdhesionAmtZ;
//	LastDistFromAimZa = DistFromAimZ;
//	LastDistFromAimYa = DistFromAimY;
	LastDeltaRot = DeltaRot;
//	LastAdjustY = AdjustY;
//	LastAdjustZ = AdjustZ;
}

/**
 * Accelerate Joystick turning rate. (Player control helper).
 *
 * @param	DeltaTime	delta time seconds since last update.
 */
final function ViewAcceleration( float DeltaTime )
{
	local float Threshold, RampupTime, Multiplier;

	if (bIsTargeting)
	{
		Threshold = YawAccelThreshold_Targeting;
		RampupTime = YawAccelRampUpTime_Targeting;
		Multiplier = YawAccelMultiplier_Targeting;
	}
	else
	{
		Threshold = YawAccelThreshold;
		RampupTime = YawAccelRampUpTime;
		Multiplier = YawAccelMultiplier;
	}


	// Skip if no point in doing it
	if (!IsLookInputIgnored())
	{
		// If above threshold, accelerate Yaw turning rate
		if( Abs(aTurn) > Threshold	)
		{
			if( YawAccelPct < 1.f )
			{
				YawAccelPct += DeltaTime / RampUpTime;
				YawAccelPct = FMin(YawAccelPct, 1.f);
			}
		}
		else
		{
			// Otherwise ramp down to normal rate
			if( YawAccelPct > 0.f )
			{
				YawAccelPct -= (4.f * DeltaTime) / RampUpTime;
				YawAccelPct = FMax(0.f, YawAccelPct);
			}
		}

		aTurn *= (1.f + Multiplier*YawAccelPct);
	}

	if( bIsTargeting )
	{
		aTurn *= TargetingModeViewScalePct;
	}
}

final function ViewPitchAcceleration( float DeltaTime )
{
	local float Threshold, RampupTime, Multiplier;

	if (bIsTargeting)
	{
		Threshold = YawAccelThreshold_Targeting;
		RampupTime = YawAccelRampUpTime_Targeting;
		Multiplier = YawAccelMultiplier_Targeting;
	}
	else
	{
		Threshold = YawAccelThreshold;
		RampupTime = YawAccelRampUpTime;
		Multiplier = YawAccelMultiplier;
	}

	// Skip if no point in doing it
	if (!IsLookInputIgnored())
	{
		// If above threshold, accelerate Yaw turning rate
		if( Abs(aLookUp) > Threshold )
		{
			if( PitchAccelPct < 1.f )
			{
				PitchAccelPct += DeltaTime / RampUpTime;
				PitchAccelPct = FMin(PitchAccelPct, 1.f);
			}
		}
		else
		{
			// Otherwise ramp down to normal rate
			if( PitchAccelPct > 0.f )
			{
				PitchAccelPct -= (4.f * DeltaTime) / RampUpTime;
				PitchAccelPct = FMax(0.f, PitchAccelPct);
			}
		}

		aLookUp *= (1.f + Multiplier*PitchAccelPct);
	}

	if( bIsTargeting )
	{
		aLookUp *= TargetingModeViewScalePct;
	}
}
/**
 * Remap movement controls. Rotates them by DeltaRot rotation.
 *
 * @param	DeltaRot	Delta Rotation used to remap controls.
 * @param	NewRight	new Left/Right raw movement
 * @param	NewUp		new Up/Down raw movement
 */

function RemapControlsByRotation( Rotator DeltaRot, out float NewRight, out float NewUp )
{
	local Vector	Controls, NewControls;

	Controls.X	= RawJoyRight;
	Controls.Y	= RawJoyUp;

	// don't do anything if controls are blank
	if( IsZero(Controls) )
	{
		NewRight	= 0.f;
		NewUp		= 0.f;
		return;
	}

	// rotate by DeltaRot
	DeltaRot.Pitch = 0;
	//@note we can't normalize here since that will delete any -1.f < x < 0 < x < 1.f values
	//NewControls = Normal(Controls >> DeltaRot);
	NewControls = Controls >> DeltaRot;

	NewRight	= NewControls.X;
	NewUp		= NewControls.Y;
	//`log( "Controls:" $ Controls @ "NewControls:" $ NewControls );
}

// DEBUG FUNCTIONS

/** Draw FOV for debugging */
function DebugDrawFOV( vector2D FOV, vector POVLoc, Rotator POVRot, Color FOVColor, float FOVMaxDist )
{
	local vector	FOVAzimDotLoc, FOVAzimOffset, FOVElevDotLoc, FOVElevOffset;
	local vector	DrawOrigin, ViewDirX, ViewDirY, ViewDirZ;
	local float		DistToAzimDotLoc, DistToElevDotLoc;

	GetAxes( POVRot, ViewDirX, ViewDirY, ViewDirZ );

	if( Pawn == None )
	{
		DrawOrigin = POVLoc + ViewDirX*16;;
	}
	else
	{
		DrawOrigin = Pawn.Location;
	}

	// Draw adhesion FOV bounding box
	DistToAzimDotLoc	= FOVMaxDist * Cos(FOV.X*Pi/180.f);
	FOVAzimDotLoc		= POVLoc + ViewDirX * DistToAzimDotLoc;
	FOVAzimOffset		= ViewDirY * Sqrt(FOVMaxDist**2 - DistToAzimDotLoc**2);

	// FOV Left edge
	DrawDebugLine(DrawOrigin, FOVAzimDotLoc - FOVAzimOffset, FOVColor.R, FOVColor.G, FOVColor.B );

	// FOV right edge
	DrawDebugLine(DrawOrigin, FOVAzimDotLoc + FOVAzimOffset, FOVColor.R, FOVColor.G, FOVColor.B );

	DistToElevDotLoc = FOVMaxDist * Cos(FOV.Y*Pi/180.f);
	FOVElevDotLoc	 = POVLoc + ViewDirX * DistToElevDotLoc;
	FOVElevOffset	 = ViewDirZ * Sqrt(FOVMaxDist**2 - DistToElevDotLoc**2);

	// FOV top edge
	DrawDebugLine(DrawOrigin, FOVElevDotLoc + FOVElevOffset, FOVColor.R, FOVColor.G, FOVColor.B );

	// FOV bottom edge
	DrawDebugLine(DrawOrigin, FOVElevDotLoc - FOVElevOffset, FOVColor.R, FOVColor.G, FOVColor.B );

	// Link em
	DrawDebugLine(FOVAzimDotLoc - FOVAzimOffset, FOVElevDotLoc + FOVElevOffset, FOVColor.R, FOVColor.G, FOVColor.B );
	DrawDebugLine(FOVElevDotLoc + FOVElevOffset, FOVAzimDotLoc + FOVAzimOffset, FOVColor.R, FOVColor.G, FOVColor.B );
	DrawDebugLine(FOVAzimDotLoc + FOVAzimOffset, FOVElevDotLoc - FOVElevOffset, FOVColor.R, FOVColor.G, FOVColor.B );
	DrawDebugLine(FOVElevDotLoc - FOVElevOffset, FOVAzimDotLoc - FOVAzimOffset, FOVColor.R, FOVColor.G, FOVColor.B );
}

`if(`notdefined(FINAL_RELEASE))
function DrawHUD( HUD H )
{
	local Vector XAxis, YAxis, ZAxis, /*Dir, */TargLoc, CamLoc;
	local Rotator CamRot;
	local int X, Y;
	local float UnusedW, UnusedH;

	super.DrawHUD( H );

	X = 15;
	Y = 150;

	if( bDebugFriction )
	{
		H.Canvas.SetPos(X,Y);
		H.Canvas.DrawText("Target:"@LastFrictionTarget@"["$LastDistToTarget$"] ["$LastDistMultiplier$"]");
		Y += 15;

		H.Canvas.SetPos(X,Y);
		H.Canvas.DrawText("Aim distance (Y/Z): ["$LastDistFromAimY$"] ["$LastDistFromAimZ$"]");
		Y += 15;

		H.Canvas.SetPos(X,Y);
		H.Canvas.DrawText("Target collision (R/H): ["$LastTargetWidth$"] ["$LastTargetHeight$"]");
		Y += 15;

		H.Canvas.SetPos(X,Y);
		H.Canvas.DrawText("Friction multiplier: ["$LastFrictionMultiplier$"]");
		Y += 15;

		H.Canvas.SetPos(X,Y);
		H.Canvas.DrawText("TargVelDotTurnDir: ["$LastTargVelDotTurnDir$"] CamRotDotTargY ["$LastCamRotDotTargY$"]");
		Y += 15;

		if( LastFrictionTarget != None )
		{
			LastFrictionTarget.GetAimFrictionExtent(UnusedW, UnusedH, TargLoc);

			// Draw line to our friction target (GREEN)
			DrawDebugLine(Pawn.GetPawnViewLocation(),TargLoc,0,255,0);

			GetPlayerViewPoint( CamLoc, CamRot );
			GetAxes( CamRot, XAxis, YAxis, ZAxis );

			// Draw the friction radius around target (BLUE)
			DrawDebugLine( TargLoc + (YAxis * LastTargetWidth) + (ZAxis * LastTargetHeight),
						   TargLoc + (YAxis * LastTargetWidth) - (ZAxis * LastTargetHeight),
						   0,0,255 );
			DrawDebugLine( TargLoc - (YAxis * LastTargetWidth) + (ZAxis * LastTargetHeight),
						   TargLoc - (YAxis * LastTargetWidth) - (ZAxis * LastTargetHeight),
						   0,0,255 );
			DrawDebugLine( TargLoc + (YAxis * LastTargetWidth) + (ZAxis * LastTargetHeight),
						   TargLoc - (YAxis * LastTargetWidth) + (ZAxis * LastTargetHeight),
						   0,0,255 );
			DrawDebugLine( TargLoc + (YAxis * LastTargetWidth) - (ZAxis * LastTargetHeight),
						   TargLoc - (YAxis * LastTargetWidth) - (ZAxis * LastTargetHeight),
						   0,0,255 );
		}
	}

	X = 15;
	Y += 50;

	if( bDebugAdhesion )
	{
		H.Canvas.DrawColor = MakeColor(255, 255, 0, 255);

		H.Canvas.SetPos(X,Y);
		H.Canvas.DrawText("Target:"@LastFrictionTarget@"["$LastDistToTarget$"]");
		Y += 15;

		H.Canvas.SetPos(X,Y);
		H.Canvas.DrawText("Aim distance (Y/Z): ["$LastDistFromAimYa$"] ["$LastDistFromAimZa$"]");
		Y += 15;

		H.Canvas.SetPos(X,Y);
		H.Canvas.DrawText("DeltaRot:"@LastDeltaRot);
		Y += 15;

		H.Canvas.SetPos(X,Y);
		H.Canvas.DrawText("Adhesion Amt (Y/Z): ["$LastAdhesionAmtY$"] ["$LastAdhesionAmtZ$"]");
		Y += 15;

		H.Canvas.SetPos(X,Y);
		H.Canvas.DrawText("Adhesion Adjust (Y/Z): ["$LastAdjustY$"] ["$LastAdjustZ$"]");
		Y += 15;
	}

	if (bDebugViewAccel)
	{
		H.Canvas.DrawDebugGraph("Turn", RawJoyLookRight, abs(LastaTurn), 50, 50, 200, 400, vect2d(-1.f, 1.f), vect2d(2.f, 0.f));

		if (bDoPitchAccelToo)
		{
			H.Canvas.DrawDebugGraph("LookUp", RawJoyLookUp, abs(LastaLookUp), 300, 50, 200, 400, vect2d(-1.f, 1.f), vect2d(2.f, 0.f));
		}

		H.Canvas.DrawDebugGraph("Raw X,Y", RawJoyLookRight, RawJoyLookUp, 550, 50, 200, 200, vect2d(-1,1), vect2d(-1,1));
		H.Canvas.DrawDebugGraph("aTurn/aLookUp", LastaTurn, LastaLookUp, 800, 50, 200, 200, vect2d(-1,1), vect2d(-1,1));
	}
}

`endif


/** Return if no detected input this tick, false otherwise */
simulated function bool IsIdle()
{
	if ( (aBaseX != 0) ||
		 (aBaseY != 0) ||
		 (aBaseZ != 0) ||
		 (aMouseX != 0) ||
		 (aMouseY != 0) ||
		 (aForward != 0) ||
		 (aTurn != 0) ||
		 (aStrafe != 0) ||
		 (aUp != 0) ||
		 (aLookUp != 0) )
	{

		return FALSE;
	}

	return TRUE;
}

/** Whether the button name is the POI button */
function bool IsPOIButtonName(Name ButtonName)
{
	if (bUseAlternateControls)
	{
		return (ButtonName == 'R3');
	}
	else
	{
		return (ButtonName == 'Y');
	}
}


/** GAMEPLAY BUTTON INPUT HANDLING */

/**
 * Checks all the cases for button input fitering, called solely by ButtonPress()/ButtonRelease().
 *
 * @return TRUE if the input should be filtered (ignored)
 */
function bool FilterButtonInput(Name ButtonName,bool bPressed,int ButtonIdx)
{
	local SeqEvt_Input InputEvt;
	local bool bTrappedInput;
	local GearWeapon Weap;
	local GearPawn GP;

	if ( IsPOIButtonName(ButtonName) && !bPressed && bLookingAtPointOfInterest )
	{
		//@fixme - explicitly don't filter this button.  hacky, yes.
		return FALSE;
	}
	// Never filter the start button so we can always pause
	// never filter back so we can always skip
	else if ( ButtonName == 'Start' || ButtonName == 'Back' )
	{
		return FALSE;
	}

	// check to see if global input has been disabled (UI scene, etc)
	if (InputIsDisabledCount != 0)
	{
		//`log("input disabled, ignoring:"@ButtonName@bPressed);
		return TRUE;
	}

	GP = GetGearPawn();

	if (GP != None)
	{
		if (bPressed)
		{
			// no button input during a conversation except X (skip) or Y (poi) or L2 (zoom)
			if ( GP.bIsConversing && (ButtonName != 'L2') && (ButtonName != 'Back') && !IsPOIButtonName(ButtonName) &&
				 (bUseAlternateControls || ButtonName != 'A') && (!bUseAlternateControls || ButtonName != 'X') )
			{
			//`log("conversing, ignoring:"@ButtonName@bPressed);
				return TRUE;
			}

			// check to see if the current weapon would trap the input
			if( GP.MyGearWeapon != None && GP.MyGearWeapon.HandleButtonPress(ButtonName))
			{
				//`log("weapon trap, ignoring:"@ButtonName@bPressed);
				return TRUE;
			}
			// check to see if the current special move would trap the input
			if (GP.SpecialMove != SM_None &&
				GP.SpecialMoves[GP.SpecialMove] != None &&
				GP.SpecialMoves[GP.SpecialMove].ButtonPress(ButtonName))
			{
				//`log("sm trap, ignoring:"@ButtonName@bPressed);
				return TRUE;
			}
		}
		else
		{
			// check to see if the current weapon would trap the input
			if( GP.MyGearWeapon != None && GP.MyGearWeapon.HandleButtonRelease(ButtonName))
			{
				//`log("weapon trap, ignoring:"@ButtonName@bPressed);
				return TRUE;
			}
		}
	}
	else // then GP was none.. try to see if we have a gear vehicle
	{
		if (GearVehicleBase(Pawn) != None || GearTurret(Pawn) != None)
		{
			Weap = GearWeapon(Pawn.Weapon);
			if (Weap != None)
			{
				if ( (bPressed && Weap.HandleButtonPress(ButtonName)) ||
					 (!bPressed && Weap.HandleButtonRelease(ButtonName)) )
				{
					return TRUE;
				}
			}
		}
	}

`if(`notdefined(FINAL_RELEASE))
	if ( (bDebugGUDBrowser || bDebugEffortBrowser) && bPressed )
	{
		if (GearGame(WorldInfo.Game).UnscriptedDialogueManager.HandleButtonPress(ButtonName))
		{
			return TRUE;
		}
	}
`endif

	// check to see if there are any Kismet events trapping this input
	foreach InputEvents(InputEvt)
	{
		if (InputEvt.CheckInputActivate(EGameButtons(ButtonIdx),bPressed) && InputEvt.bTrapInput)
		{
			bTrappedInput = TRUE;
		}
	}

	// input was trapped by one or more events so filter out for gameplay
	if (bTrappedInput)
	{
		//`log("kismet trap, ignoring:"@ButtonName@bPressed);
		return TRUE;
	}

	// all clear, don't filter
	return FALSE;
}


/**
 * Entry point for button press handling.
 */
exec function ButtonPress(coerce Name ButtonName)
{
	LastInputTime = WorldInfo.TimeSeconds;

	Super.ButtonPress( ButtonName );
}

/**
 * Entry point for button release handling.
 */
exec function ButtonRelease(coerce Name ButtonName)
{
	LastInputTime = WorldInfo.TimeSeconds;

	Super.ButtonRelease( ButtonName );
}

/**
* Perform all of the encompassing actions associated with pressing the action button
*	@param bRunActions - only perform roadie run and evades (for alternate input config)
*/
function HandleActionButton(bool bPressed, optional bool bDblClickMove, optional bool bRunActions)
{
	local CovPosInfo    CoverCanRunTo;
	local int           NoCameraAutoAlign;
	local GearPawn_SilverbackLoaderBase	SilverbackLoader;
	local GearPawn_SilverbackArmedBase	SilverbackArmed;

	if (bPressed)
	{
		if (Outer.IsSpectating() || (Outer.IsDead() && !Outer.bFrozen))
		{
			if (bUseAlternateControls && bRunActions && Outer.WantsSpectatorUI())
			{
				// See if we need to transition to the Ghost Camera
				if (!Outer.IsInState('PlayerWaiting') && Outer.GetStateName() != 'GhostSpectating')
				{
					Outer.TransitionToSpectate('GhostSpectating');
				}
			}
		}
		else if (Outer.MyGearPawn != None && Outer.MyGearPawn.bIsConversing)
		{
			Outer.SetTimer(RoadieRunTimer, false, nameof(TryToRoadieJog), Outer);
		}
		// if in reviving then allow button mashing for speed boost
		else if (Outer.IsInState('Reviving') && !Outer.IsMoveInputIgnored() )
		{
			if ( !bRunActions || !bUseAlternateControls  )
			{
				PressedActionButton_Reviving();
			}
		}
		else if( Outer.IsInState('PlayerBrumakGunner') )
		{
			if( !bRunActions || !bUseAlternateControls )
			{
			}
		}
		else if (Outer.IsInState('PlayerDrivingSilverback') )
		{
			SilverbackArmed = GearPawn_SilverbackArmedBase(Pawn);
			SilverbackLoader = GearPawn_SilverbackLoaderBase(Pawn);
			if (SilverbackArmed != None)
			{
				// Make silverback use A button for deploying cover in alternate controls
				if (bUseAlternateControls && !bRunActions)
				{
					SilverbackArmed = GearPawn_SilverbackArmedBase(Pawn);
					if (SilverbackArmed != None)
					{
						if (SilverbackArmed.IsDoingSpecialMove(GSM_Silverback_CoverDeploy))
						{
							SilverbackArmed.Undeploy();
						}
						else
						{
							SilverbackArmed.Deploy();
						}
					}
				}
				else if (!bUseAlternateControls && SilverbackArmed.IsDoingSpecialMove(GSM_Silverback_CoverDeploy))
				{
					SilverbackArmed.Undeploy();
				}
				else
				{
					TryASpecialMove(bRunActions);
				}
			}
			else if (SilverbackLoader != None)
			{
				if ((!bUseAlternateControls || !bRunActions) && SilverbackLoader.CanLiftCrate())
				{
					SilverbackLoader.ServerAttemptCratePickup();
				}
				else
				{
					TryASpecialMove(bRunActions);
				}
			}
		}
		else if ( Outer.IsInState('PlayerDriving') )
		{
			// Vehicle code handles 'A' button

			// Crank the wheel if on a siegebeast
			if (GearWeaponPawn(Pawn) != None)
			{
				if (Vehicle_Siegebeast_Base(GearWeaponPawn(Pawn).MyVehicle) != None)
				{
					Pawn.StartFire( 2 );  /*MELEE_ATTACK_FIREMODE*/
				}
			}
		}
		else if ( Outer.IsInState('Engaging') )
		{
			if ( !bRunActions || !bUseAlternateControls )
			{
				Outer.ServerHandleButtonPress( 'A' );
			}
		}
		else if (IsTimerActive('PickingUpAWeapon'))
		{
			// do nothing while picking up a weapon
		}
		// door kick
		else if (MyGearPawn != None && !IsDoingASpecialMove() && !IsInCoverState() && MyGearPawn.bInsideDoorTrigger)
		{
			if ( !bRunActions || !bUseAlternateControls )
			{
				DoDoorOpen();
			}
		}
		else if ( DoubleClickDir == DCLICK_Active )
		{
			if ( !bRunActions || !bUseAlternateControls )
			{
				if ( !TryToRunToCover(true) && !bUseAlternateControls )
				{
					TryToEvade();
				}
			}
			else if ( bUseAlternateControls && bRunActions )
			{
				TryToEvade();
			}
		}
		else if (MyGearHud.ActiveAction.ActionType == AT_Player && bCanUseCoopInteractionMenu && CanDoSpecialMove(SM_TradeWeaponsSecondaryAI, TRUE))
		{
			ServerTradeSecondaryWeaponsWithBot(TargetedPawn);
		}
		else if (!bRunActions && MyGearPawn != None && MyGearPawn.IsCarryingShield() && MyGearPawn.IsDoingSpecialMove(SM_DeployShield) && MyGearPawn.EquippedShield.CanDeployShield())
		{
			DoSpecialMove(SM_PlantShield, TRUE);
		}
		// default special move
		else
		{
			if ( !TryASpecialMove(bRunActions) )
			{
				if ( !bRunActions && bUseAlternateControls && !IsInCoverState() && CanTryToRunToCover() )
				{
					if ( CanRunToCover(CoverCanRunTo, NoCameraAutoAlign) )
					{
						if ( IsDoingSpecialMove(SM_RoadieRun) )
						{
							EndSpecialMove();
						}

						TryToRunToCover();
					}
				}
			}
		}
	}
	else
	{
		if (IsSpectating())
		{
		}
		// abort cover/roadie run on button release
		else if ( (bRunActions || !bUseAlternateControls) && (IsDoingSpecialMove(SM_CoverRun) || IsDoingSpecialMove(SM_RoadieRun) || IsDoingSpecialMove(SM_Berserker_Charge)) && !bForcedRoadieRun )
		{
			EndSpecialMove();
		}
		else if (IsInCoverState())
		{
			if ( IsTimerActive('TryToRoadieRun') && TryToEvade())
			{
				// do nothing else in this case
			}
			else
			// we only want to push out of cover when we release the button as it feels better release and your guy releases from cover
			// check for a break from cover
			if( bPressAToBreakFromCover && !bBreakFromCover && Abs(RemappedJoyRight) < DeadZoneThreshold && Abs(RemappedJoyUp) < DeadZoneThreshold )
			{
				if ( !bRunActions || !bUseAlternateControls )
				{
					if (CanDoSpecialMove(SM_PushOutOfCover) && `TimeSince(MyGearPawn.LastCoverTime) > TimeBeforeAButtonPressLeavesCover)
					{
						DoSpecialMove(SM_PushOutOfCover);
					}
				}
			}
		}
		else
		{
			if( IsTimerActive('TryToRoadieRun') || bForcedRoadieRun )
			{
				ClearTimer('TryToRoadieRun');

				if (Outer.IsInState('PlayerDrivingSilverback'))
				{
					// Don't deploy if using alternate controls (A button will do that)
					if (!bUseAlternateControls)
					{
						SilverbackArmed = GearPawn_SilverbackArmedBase(Pawn);
						if (SilverbackArmed != None)
						{
							SilverbackArmed.Deploy();
						}
					}
				}
				// Evade has to be included in the CanTryToRunToCover() check, otherwise it leads to some retard rolls.
				else if ( CanTryToRunToCover() )
				{
					// if not already doing a special move
					if( (!bUseAlternateControls || !bRunActions) && !IsInCoverState() && TryToRunToCover() )
					{
						// run2cover move
					}
					else if ( !bUseAlternateControls || bRunActions )
					{
						// Otherwise, try to do an evade move
						TryToEvade( bDblClickMove ? CurrentDoubleClickDir : DCLICK_None );
					}
				}
				else if (MyGearPawn != None && !MyGearPawn.bCanUseCover && (!bUseAlternateControls || bRunActions))
				{
					TryToEvade(bDblClickMove ? CurrentDoubleClickDir : DCLICK_None);
				}
			}
		}

		// Clear the roadie jogging flag
		if (bRunActions || !bUseAlternateControls)
		{
			if (MyGearPawn != None && MyGearPawn.bIsRoadieJogging)
			{
				ServerSetRoadieJog(false);
			}
			ClearTimer(nameof(TryToRoadieJog));
		}

		// Reset timer and mark move as done
		FinishDoubleClick( FALSE );
	}
}

function DelayedEnterScreenshotMode()
{
	ConsoleCommand("ScreenshotMode");
}

/**
 * Handle roadie running and evading
 * (used by alternate controls to pull the above functionality out of the HandleButtonInput_A() function.
 */
function HandleNonCoverMoves(bool bPressed, optional bool bDblClickMove)
{
	if (bPressed && bUseAlternateControls)
	{
		if (MyGearHud.ActiveAction.ActionType == AT_Player && bCanUseCoopInteractionMenu && CanDoSpecialMove(SM_TradeWeapons))
		{
			if (TargetedPawn.PlayerReplicationInfo.bBot)
			{
				ServerTradeWeaponsWithBot(TargetedPawn);
			}
			else
			{
				DoSpecialMove(SM_TradeWeapons);
			}
		}
	}

	HandleActionButton(bPressed, bDblClickMove, TRUE);
}

/**
 * Button A Handler
 */
function HandleButtonInput_A(bool bPressed, optional bool bDblClickMove)
{
	if (Outer.WantsSpectatorUI())
	{
		// redirect to showing or hiding player names
		if (bPressed)
		{
			MyGearHud.bShowNamesWhenSpectating = !MyGearHud.bShowNamesWhenSpectating;
		}
	}
	else
	{
		HandleActionButton(bPressed, bDblClickMove, false);
	}
}

function SkipConversation()
{
	local int PlayerIndex;
	if (Role == ROLE_Authority && (!IsSplitscreenPlayer(PlayerIndex) || PlayerIndex == 0))
	{
		ServerAbortConversation();

		//`log("skipping cinematic");
		ConsoleCommand("CANCELCINE 2.0");
	}
}

/**
 * Button X Handler
 */
function HandleButtonInput_X(bool bPressed, optional bool bDblClickMove)
{
	if (bPressed)
	{
	// TODO: Determine if we need this functionality in Gears3 and fix this, else remove
// 		if( Outer.IsInState('PlayerBrumakDriver') ||
// 			Outer.IsInState('PlayerBrumakGunner') )
// 		{
// 			// do nothing
// 		}
		if( GearWeaponPawn(Pawn) != None && Vehicle_Submarine_Base(Pawn.Base) != None )
		{
			Vehicle_Submarine_Base(Pawn.Base).ServerUpdateSonarFor( Outer, TRUE );
		}
		else
		if (Outer.IsInState('PlayerDriving'))
		{
			if (GearVehicleBase(Pawn) != None)
			{
				GearVehicleBase(Pawn).ServerPressedX();
			}
		}
		else if (!bUseAlternateControls && (Outer.IsSpectating() || (Outer.IsDead() && !Outer.bFrozen)) && Outer.WantsSpectatorUI())
		{
			// See if we need to transition to the Ghost Camera
			if (!Outer.IsInState('PlayerWaiting') && Outer.GetStateName() != 'GhostSpectating')
			{
				Outer.TransitionToSpectate('GhostSpectating');
			}
		}
		else if (Outer.IsInState('Engaging'))
		{
			Outer.ServerHandleButtonPress('X');
		}
		// if we're already pushing an object
		else if (MyGearPawn != None && MyGearPawn.IsDoingSpecialMove(SM_PushObject))
		{
			// then keep pushing
			GSM_PushObject(MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove]).ButtonPressed();
			// tell server to do the same
			ServerKeepPushing();
		}
		else if (bUseAlternateControls && MyGearHud.ActiveAction.ActionType == AT_Player && bCanUseCoopInteractionMenu && CanDoSpecialMove(SM_ShareAmmo))
		{
			DoSpecialMove(SM_ShareAmmo);
		}
		else if (!bUseAlternateControls && MyGearHud.ActiveAction.ActionType == AT_Player && bCanUseCoopInteractionMenu && CanDoSpecialMove(SM_TradeWeapons, TRUE))
		{
			if (TargetedPawn.PlayerReplicationInfo.bBot)
			{
				ServerTradeWeaponsWithBot(TargetedPawn);
			}
			else
			{
				DoSpecialMove(SM_TradeWeapons);
			}
		}
		// attempt to interact with an object
		else
		{
			if ( !ClientUse() )
			{
				ServerUse();
			}
		}
	}
	else
	{
		if (MyGearPawn != None)
		{
			MyGearPawn.ServerGrabMovableCover(FALSE);
			MyGearPawn.bGrabbingMovableCover = FALSE;
		}
	}
}

/**
 * Button Y Handler
 */
function HandleButtonInput_Y(bool bPressed, optional bool bDblClickMove)
{
	local GearFortificationMarker GFMarker;
	local float RepairPct;
	local int UpgradeLevel;

	if( bPressed )
	{
		//@FIXME: hacky temp handling for prototype
		if (IsSpectating() && ClassIsChildOf(WorldInfo.GRI.GameClass, class'GearGameHorde_Base'))
		{
			GearPC_MP(Outer).ServerBuyRespawn();
		}

		if (!bUseAlternateControls && MyGearHud != None && MyGearHud.ActiveAction.ActionType == AT_Player && bCanUseCoopInteractionMenu && CanDoSpecialMove(SM_ShareAmmo))
		{
			DoSpecialMove(SM_ShareAmmo);
		}
		// Check if we have a DBNO player around us, and we can do a finishing move!
		else if(!bChangeExecutionControls && CanDoSpecialMove(SM_CQCMove_PunchFace) )
		{
			ServerDoCQCMove(SM_CQCMove_PunchFace, class'GSM_CQCMove_PunchFace'.static.DetermineExecutionVariant(MyGearPawn, Outer));
			return;
		}
		else if (bChangeExecutionControls && CanDoSpecialMove(SM_CQCMove_CurbStomp) )
		{
			SetTimer(ExecuteHeldTimer, FALSE, nameof(TryToDoLongExecution));
			// Try and start an execution
		}
		else if (TryToPickupAWeapon(true))
		{
			// nothing more to do here
		}
		else
		{
			if ( GearPawnRidable_Base(MyGearPawn) == None && GearGRI_Horde(WorldInfo.GRI) != None &&
				GearGRI_Horde(WorldInfo.GRI).bCanPlaceFortifications )
			{
				// check if we can place a fortification
				foreach MyGearPawn.TouchingActors(class'GearFortificationMarker', GFMarker)
				{
					if ( NoZDot(vector(MyGearPawn.Rotation), Normal(GFMarker.Location - MyGearPawn.Location)) > 0.0 &&
						GetFortificationUpgradeLevel(GFMarker.FortificationType) >= 0 )
					{
						ServerPlaceFortificationFromMarker(GFMarker);
						return;
					}
				}
				// or if we can disassemble a fortification
				if (ModifyFortification != None)
				{
					UpgradeLevel = Outer.GetFortificationUpgradeLevel(ModifyFortification.Class, RepairPct);
					// the appropriate upgrade is required to repair fortifications that have been completely eliminated
					if (ModifyFortification.Health <= 0 && UpgradeLevel >= ModifyFortification.UpgradeLevel)
					{
						ServerRepairFortification(ModifyFortification, RepairPct);
					}
					else if (ModifyFortification.GetConditionPct() < 1.0)
					{
						ServerRepairFortification(ModifyFortification, RepairPct);
					}
					else if (UpgradeLevel > ModifyFortification.UpgradeLevel)
					{
						ServerUpgradeFortification(ModifyFortification);
					}
					return;
				}
			}

			// don't allow a force look while door kicking 1) you shouldn't be able to 2) it can break the door kick
			// also not while chainsawing.	also not while on a turret
			if ( (MyGearPawn == None) || (MyGearPawn.SpecialMove == SM_None || !MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove].bDisablePOIs) &&
				 (MeleeAdhesionTarget == None) )
			{
				TryPOILookAt();
			}
		}
	}
	else
	{
		if (IsTimerActive('TryToDoLongExecution'))
		{
			if( CanDoSpecialMove(SM_CQCMove_CurbStomp) )
			{
				ServerDoCQCMove(SM_CQCMove_CurbStomp);
			}
			ClearTimer('TryToDoLongExecution');
			return;
		}
		TryPOILookAway();
	}
}

/** Button B Handler */
function HandleButtonInput_B(bool bPressed, optional bool bDblClickMove)
{
	local Trigger_ChainsawInteraction TCI;
	local GearPawn_SilverbackBase Silverback;

	if (bPressed)
	{
		if (GearHUDMP_Base(MyGearHud) != None && !MyGearHud.bDrawOverheadMPMap && (MyGearHud.bShowScores || GearHUDMP_Base(MyGearHud).ShouldShowScoreboardBasedOnGameStatus()))
		{
			SetOverheadMapActive(true);
		}
		else if (MyGearHud != None && MyGearHud.bDrawOverheadMPMap)
		{
			SetOverheadMapActive(false);
		}
		else if (Outer.IsInState('PlayerDrivingSilverback'))
		{
			Silverback = GearPawn_SilverbackBase(Pawn);
			if (Silverback != None)
			{
				if (!IsDoingASpecialMove() && MyGearPawn.bInsideDoorTrigger)
				{
					DoDoorOpen();
				}
				else if (Silverback.CanDoMeleeAttack())
				{
					Silverback.ServerAttemptMeleeAttack();
				}
			}
		}
		else if ( MyGearHud != None && MyGearHud.ActiveAction.ActionType == AT_Player &&
				bCanUseCoopInteractionMenu && MyGearPawn.CanGiveMoney() )
		{
			MyGearPawn.ServerGiveMoney(Outer.TargetedPawn);
		}
		else if (AttemptCoopInteraction())
		{
		}
		else if (MyGearPawn != None && MyGearPawn.bInDuelingMiniGame)
		{
			// Play a feedback sound
			MyGearPawn.MyGearWeapon.PlaySound(MyGearPawn.MyGearWeapon.FireNoAmmoSound, FALSE, TRUE,, MyGearPawn.Location);
			// Replicate button press to server.
			MyGearPawn.ReportDuelingMiniGameButtonPress();
		}
		else if (Outer.IsInState('PlayerBrumakDriver'))
		{
			foreach MyGearPawn.TouchingActors(class'Trigger_ChainsawInteraction', TCI )
			{
				break;
			}

			if (TCI != None)
			{
				DoSpecialMove(GSM_Brumak_OverlayLftArmSwing);
			}
			else
			{
				DoSpecialMove(GSM_Brumak_OverlayRtArmSwing);
			}
		}
		else if (Outer.IsInState('PlayerDriving'))
		{
			if (!bAssessMode)
			{
				if (GearWeaponPawn(Pawn) != None)
				{
					if (Vehicle_KingRaven_Base(GearWeaponPawn(Pawn).MyVehicle) != None)
					{
						//Play fake chainsaw
						Pawn.StartFire(2);  /*MELEE_ATTACK_FIREMODE*/
					}
				}
				else if (GearVehicle(Pawn) != None)
				{
					GearVehicle(Pawn).StartMeleeAttack();
				}
			}
		}
		else if (Outer.IsInState('PlayerBrumakGunner'))
		{

		}
		else if (Outer.IsInState('PlayerRidingVehicle'))
		{

		}
		else if (Outer.IsInState('Reviving'))
		{

		}
		else if ( Outer.IsInState('Engaging') )
		{
			Outer.ServerHandleButtonPress( 'B' );
		}
		else if (ModifyFortification != None && ModifyFortification.Owner == Outer && class'GearGameHorde_Base'.default.bCanSellFortifications)
		{
			ServerTearDownFortification(ModifyFortification);
		}
		else
		{
			// Start melee if not in taccom
			if (!bAssessMode && MyGearPawn != None)
			{
				MyGearPawn.StartMeleeAttack();
			}
		}
	}
	else if (Outer.IsInState('PlayerDriving'))
	{
		if (GearWeaponPawn(Pawn) != None)
		{
			if (Vehicle_KingRaven_Base(GearWeaponPawn(Pawn).MyVehicle) != None || Vehicle_Siegebeast_Base(GearWeaponPawn(Pawn).MyVehicle) != None)
			{
				//End fake chainsaw
				bFire = 0;
				StopFire( 2 );   /*MELEE_ATTACK_FIREMODE*/
				SetLastWeaponInfoTime(WorldInfo.TimeSeconds);
			}
		}
	}
	else if (MyGearPawn != None)
	{
		// abort out of any melee attacks
		MyGearPawn.StopMeleeAttack();
	}
}

/**
 * Button Start Handler
 */
function HandleButtonInput_Start(bool bPressed, optional bool bDblClickMove)
{
	if (!bPressed)
	{
		ConditionalPauseGame();
	}
}

/**
 * Button Back Handler
 */
function HandleButtonInput_Back(bool bPressed, optional bool bDblClickMove)
{
	local GearGameMP_Base Game;

	if (bPressed)
	{
		// if playing training grounds, redirect server's Back button to toggle bot AI
		Game = GearGameMP_Base(Outer.WorldInfo.Game);
		if (Game != None && Game.bIsTrainingGrounds)
		{
			Game.SetTrainingGroundBotsActive(!Game.AreBotsActive());
			return;
		}
	}

	if (MyGearHud != None)
	{
		MyGearHud.ToggleScoreboard(bPressed);
	}

	if (bPressed)
	{
		if (MyGearHud != None && MyGearHud.bDrawOverheadMPMap)
		{
			SetOverheadMapActive(false);
		}

		SkipConversation();
	}
}

/**
 * Button LeftTrigger Handler
 */
function HandleButtonInput_LeftTrigger(bool bPressed, optional bool bDblClickMove)
{
	if (bPressed)
	{
		if( MyGearPawn != None && MyGearPawn.bInTriggerMiniGame )
		{
			MyGearPawn.ReportTriggerPressMiniGame(false);
		}
		else if ((IsSpectating() || (Outer.IsDead() && !Outer.bFrozen)) && Outer.WantsSpectatorUI())
		{
			if (bPressed)
			{
				// See if we need to transition to the Battle Camera
				if (!Outer.IsInState('PlayerWaiting') && Outer.GetStateName() != 'CustomSpectating')
				{
					Outer.TransitionToSpectate('CustomSpectating');
				}
				else
				{
					// Move to the previous target
					Outer.PickPrevViewTarget();
				}
			}
		}
		else if (Outer.IsInState('Dead'))
		{
			StartFire();
		}
		else if (Outer.IsInState('PlayerDriving'))
		{
			VehicleReversePressedAmount = 1.f;
		}

		// Start alt fire if not in taccom
		if (!bAssessMode)
		{
			bAltFire = 1;
		}

		// Remove the targeting prevention
		if (MyGearPawn != None && MyGearPawn.bPreventTargetingDueToShieldDrop)
		{
			MyGearPawn.bPreventTargetingDueToShieldDrop = FALSE;
		}
	}
	else
	{
		SetLastWeaponInfoTime(WorldInfo.TimeSeconds);

		// OMG this is so horrible. don't centralize everything here.
		if( Outer.IsInState('PlayerDriving') )
		{
			VehicleReversePressedAmount = 0.f;
		}

		bAltFire = 0;
	}
}

function DelayedToggleDemoRecording()
{
	if (!WorldInfo.GRI.IsMultiplayerGame())
	{
		if (bRecording)
		{
			ConsoleCommand("DEMOSTOP");
			bRecording = FALSE;
			ClientMessage("Stopped recording demo");
		}
		else
		{
			ConsoleCommand("DEMOREC"@GetURLMap()$"_"$DemoCount);
			DemoCount++;
			bRecording = TRUE;
			ClientMessage("Started recording demo");
		}
	}
}

/**
 * Button LeftBumper Handler
 */
function HandleButtonInput_LeftBumper(bool bPressed, optional bool bDblClickMove)
{
	if (Outer.IsSpectating() || (Outer.IsDead() && !Outer.bFrozen))
	{
		if (bPressed && Outer.CanSpectateTeammate())
		{
			// See if we need to transition to the Player Camera
			if (!Outer.IsInState('PlayerWaiting') && Outer.GetStateName() != 'PlayerSpectating')
			{
				Outer.TransitionToSpectate('PlayerSpectating');
			}
			else
			{
				// Move to the previous target
				Outer.PickPrevViewTarget();
			}
		}
	}
	else
	{
		if (bPressed)
		{
			EnableAssessMode();
			// if driving then release the gas
			if (Outer.IsInState('PlayerDriving'))
			{
				VehicleGasPressedAmount = 0.f;
				VehicleReversePressedAmount = 0.f;
			}
		}
		else
		{
			DisableAssessMode();
			if ( IsButtonActive(GB_RightTrigger, true) )
			{
				HandleButtonInput_RightTrigger( true );
			}
		}
	}
}

/**
 * Button RightTrigger Handler
 */
function HandleButtonInput_RightTrigger(bool bPressed, optional bool bDblClickMove)
{
	if (bPressed)
	{
		if( MyGearPawn != None && MyGearPawn.bInTriggerMiniGame )
		{
			MyGearPawn.ReportTriggerPressMiniGame(TRUE);
		}
		else if (Outer.IsInState('PlayerWaiting') && IsCoop())
		{
			ServerRestartPlayer();
		}
		else if (Outer.IsInState('Reviving') && Outer.MyGearPawn.IsDBNO())
		{
			if (MyGearPawn.MyGearWeapon != None && MyGearPawn.MyGearWeapon.DoMartyrFire())
			{
				if (MyGearHUD != None)
				{
					MyGearHUD.ClearActionInfoByType(AT_SuicideBomb);
					SetReviveIcon();
					SetReviveIconAnimationSpeed();
				}
			}
		}
		else if ((IsSpectating() || (Outer.IsDead() && !Outer.bFrozen)) && Outer.WantsSpectatorUI())
		{
			if (bPressed)
			{
				// See if we need to transition to the Battle Camera
				if (!Outer.IsInState('PlayerWaiting') && Outer.GetStateName() != 'CustomSpectating')
				{
					Outer.TransitionToSpectate('CustomSpectating');
				}
				else
				{
					// Move to the next target
					Outer.PickNextViewTarget();
				}
			}
		}
		else if (Outer.IsInState('Dead'))
		{
			StartFire();
		}
		else if (Outer.IsInState('PlayerDriving'))
		{
			if (!bAssessMode)
			{
				Pawn.StartFire(0);
			}
		}
		else
		{
			// Start firing if not in taccom
			if (!bAssessMode)
			{
				bFire = 1;
			}
		}
	}
	else
	{
		bFire = 0;
		StopFire(0);
		SetLastWeaponInfoTime(WorldInfo.TimeSeconds);
	}
}

/**
 * Button RightBumper Handler
 */
function HandleButtonInput_RightBumper(bool bPressed, optional bool bDblClickMove)
{
	if (Outer.IsSpectating() || (Outer.IsDead() && !Outer.bFrozen))
	{
		if (bPressed && Outer.CanSpectateTeammate())
		{
			// See if we need to transition to the Player Camera
			if (!Outer.IsInState('PlayerWaiting') && Outer.GetStateName() != 'PlayerSpectating')
			{
				Outer.TransitionToSpectate('PlayerSpectating');
			}
			else
			{
				// Move to the next target
				Outer.PickNextViewTarget();
			}
		}
	}
	else if (bPressed)
	{
		PressedRightBumper();
	}
	else
	{
		ReleasedRightBumper();
	}
}

/**
 * Button DPad Handler
 */
function HandleButtonInput_DPad(EGameButtons Button, bool bPressed, optional bool bDblClickMove)
{
	// all DPad buttons do the same behavior, sorted out in these 2 functions
	if (bPressed)
	{
		PressedDPad(Button);
	}
	else
	{
		ReleasedDPad(Button);
	}
}

/** These handlers exist so that we can pass along the button that was pressed for better response. */
function HandleButtonInput_DPad_Up(bool bPressed, optional bool bDblClickMove) { HandleButtonInput_DPad(GB_DPad_Up,bPressed,bDblClickMove); }
function HandleButtonInput_DPad_Left(bool bPressed, optional bool bDblClickMove) { HandleButtonInput_DPad(GB_DPad_Left,bPressed,bDblClickMove); }
function HandleButtonInput_DPad_Down(bool bPressed, optional bool bDblClickMove) { HandleButtonInput_DPad(GB_DPad_Down,bPressed,bDblClickMove); }
function HandleButtonInput_DPad_Right(bool bPressed, optional bool bDblClickMove) { HandleButtonInput_DPad(GB_DPad_Right,bPressed,bDblClickMove); }

/**
 * Button LeftStickButton Handler
 */
function HandleButtonInput_LeftStickButton(bool bPressed, optional bool bDblClickMove)
{
	local GearPawn SpottedPawnCandidate;
	local Actor SpottedPickupCandidate;

	if (bPressed)
	{
		if (bIsTargeting || (GearGRI_Horde(WorldInfo.GRI) != None && Outer.IsInState('GhostSpectating')))
		{
			if (CanSpotAPawn(SpottedPawnCandidate))
			{
				ServerMarkPawnSpotted(SpottedPawnCandidate);
			}
			else if (CanSpotAPickup(SpottedPickupCandidate))
			{
				ServerMarkPickupSpotted(SpottedPickupCandidate);
			}
		}
		else if (IsInCoverState())
		{
			// crouching -> standing
			MyGearPawn.ShouldCrouch(!MyGearPawn.bWantsToCrouch);
		}
		else
		if( Outer.IsInState('PlayerBrumakGunner') )
		{
		}
		else
		if (GearVehicle(Pawn) != None)
		{
		   PlayVehicleHorn();
		}
	}
}

/**
 * Button RightStickButton Handler
 */
function HandleButtonInput_RightStickButton(bool bPressed, optional bool bDblClickMove)
{
	if( bPressed )
	{
		if( Outer.IsInState('PlayerBrumakDriver') )
		{
			ServerPlayBrumakRoar();
		}
	}
}

defaultproperties
{
	bEnableFOVScaling=TRUE

	bViewAccelEnabled=TRUE
	YawAccelThreshold=0.5f
	YawAccelMultiplier=2.5f
	YawAccelRampUpTime=1.3f
	YawAccelThreshold_Targeting=0.5f
	YawAccelMultiplier_Targeting=3.f
	YawAccelRampUpTime_Targeting=0.6f

	PitchAutoCenterTargetPitchWindow=(X=0,Y=0)

	ForcePitchCenteringSpeed=3.f

	// This PlayerInput will send kismet events if needed.
	bActivateKismetInputEvents=true

	//debug
	//bDebugFriction=TRUE
	//bDebugViewAccel=1
	bDoPitchAccelToo=1
	LookAccelExponent=1.5
	LookDecelInterpSpeed=17.5
	LookDecelInterpSpeed_Targeting=25.f
	LookAccelInterpSpeed=15
	LookStickDeadZone=0.3f
	LookPitchSensivityRatio=0.75
}
