/**
 * NanoPlayerInput_Base
 * Nano player input post processing base
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPlayerInput_Base extends PlayerInput within NanoPC
	config(Input)
	native(PC)
	transient
	abstract;

/************************************************************************/
/* Member variables, structs, enums, etc.                               */
/************************************************************************/

var transient float LastInputTime;

/** Struct to encapsulate all data needed for a button input - indexed by EGameButtons */
struct native InputButtonData
{
	/** Name of the input */
	var Name ButtonNameMapping;
	/** Delegate to call when this input is pressed */
	var delegate<HandleButtonInput> ButtonHandler;
	/** Whether a button is pressed, after gameplay filtering */
	var byte Active;
	/** Whether a button is pressed, before gameplay filtering */
	var byte RawActive;
	/** Last time a button was pressed */
	var float LastRawActiveTime;
};

/** List of InputButtonData for mapping function handlers to input. */
var array<InputButtonData> InputButtonDataList;

/** Whether to check for kismet input events to activate or not. */
var const bool bActivateKismetInputEvents;

/** Multiplier used to scale the sensitivity of the controls. */
var float SensitivityMultiplier;

/** Multiplier used to scale the sensitivity of the turning. */
//var float TurningAccelerationMultiplier;


/** Whether to center the player's view when not in a vehicle **/
var config bool bAutoCenterPitch;

/** The time when we last were turning **/
var transient float LastTurnTime;

/** Threshold since last turn/fire to auto-center **/
var	globalconfig float AutoPitchCenterDelay;


/** Whether ViewAcceleration is enabled or not **/
var() config bool bViewAccelerationEnabled;

var config protected bool bDebugViewAcceleration;

/** Threshold above when Yaw Acceleration kicks in*/
var() config float ViewAccel_YawThreshold;
var() config float ViewAccel_DiagonalThreshold;


/** How fast to start accelerating when the stick is slammed to the edge. It goes to a max of 2.0 over time **/
var() config float ViewAccel_BaseMultiplier;
var() transient private float ViewAccel_CurrMutliplier;

/** How to handle slamming the stick to the edges **/
/** how long you need to hold at edge before the fast acceleration kicks in **/
var() config float ViewAccel_TimeToHoldBeforeFastAcceleration;
var transient private float ViewAccel_TimeHeld;

/** Whether TargetFriction is enabled or not **/
var() config bool bTargetFrictionEnabled;

var config protected bool bDebugTargetFriction;

/** Whether or not we actually applied friction.  This is used to make certain we don't then accelerate the view **/
var transient protected bool bAppliedTargetFriction;

/** How fast you ramp up to the max speed**/
var config float ViewAccel_RampSpeed;
/** Max turn speed **/
var config float ViewAccel_MaxTurnSpeed;


var config float ViewAccel_PitchThreshold;
/** How far to be considered to be looking up and down **/
var config float ViewAccel_LookingUpOrDownBoundary;

/** How far to be considered to be back to center **/
var config float ViewAccel_BackToCenterBoundary;

/** how fast to zip back to center **/
var config float ViewAccel_BackToCenterSpeed;

/** So we have this as yet another value to tweak for how much we want to utilize of the AdhesionScaleRange **/
var config float TargetAdhesionScaleRangeMaxPercentUsage;


var config float AutoPitchCenterSpeed;

var config float AutoPitchStopAdjustingValue;

var transient private bool bIsLookingUp;
var transient private bool bIsLookingDown;

/** Tracking var for current view acceleration. */
var transient protected float CurViewAccel;

/** Exponent for the look stick response.  Numbers >1 will increase sensitivity near the deadzone and reduce it near the edges. */
var() config float LookStickCurveExponent;

/** Interp speed for look turn deceleration.  Higher number will make turning stop more sharply.  Lower will make it feel smoother but more sluggish. */
var() config float LookDecelInterpSpeed;

/** Interp speed for look turn acceleration.  Higher number will make turning start more sharply.  Lower will make it feel smoother but more sluggish. */
var() config float LookAccelInterpSpeed;

/** Defines size of circular deadzone for the look stick, normalized 0..1. */
var() config float LookStickDeadZone;

/** Pitch sensitivity, relative to turn sensitivity.  */
var() config float LookPitchSensivityRatio;
var() config float ViewAccelConstantInterpSpeed;

/** Defines size of circular deadzone for the movement stick, normalized 0..1. */
var() config float MoveStickDeadZone;

var transient float LastaTurn;
var transient float LastaLookup;

var transient byte bNumLookAxesReceived;
var transient float GamepadLookXDelta, GamepadLookYDelta;

var transient byte bNumMoveAxesReceived;
var transient float GamepadMoveXDelta, GamepadMoveYDelta;

var transient array<InputBufferItem>    InputBuffer;
var transient int                       InputBufferFilter;

var bool bHoldSprint;
var bool bMustAimToShoot;


/** Acceleration multiplier */
var() config float YawAccelMultiplier;
var() config float YawAccelMultiplier_Targeting;

/** Threshold above when Yaw Acceleration kicks in*/
var() config float YawAccelThreshold;
var() config float YawAccelThreshold_Targeting;

/** Time for Yaw Accel to ramp up */
var() config float YawAccelRampUpTime;
var() config float YawAccelRampUpTime_Targeting;

/** Yaw acceleration percentage applied when fading in or out */
var transient float YawAccelPct;
var transient float PitchAccelPct;

var() config float TargetingModeViewScalePct;


cpptext
{
protected:
	void HandleDeadZone(FLOAT& X, FLOAT& Y, FLOAT DZ) const;
public:
	virtual void UpdateAxisValue( FLOAT* Axis, FLOAT Delta );
};


simulated event PostBeginPlay()
{
	ViewAccel_CurrMutliplier = ViewAccel_BaseMultiplier;
}


/**
 * Template for the handle called when button is pressed/released, used to consolidate all functionality for a button into a single function.
 * @param bDblClickMove - for function to do logic based on whether a double-tap move is being called or not
 */
delegate HandleButtonInput(bool bPressed, optional bool bDblClickMove)
{
}

/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

/** Initializes the input object */
function OnInputObjectCreate()
{
	InitializeButtonHandling();
}

/** Initializes the button handling list */
function InitializeButtonHandling()
{
	// Set the size...
	InputButtonDataList.length = GB_Max;

	// Set the button names...
	InputButtonDataList[GB_A].ButtonNameMapping					= 'A';
	InputButtonDataList[GB_X].ButtonNameMapping					= 'X';
	InputButtonDataList[GB_Y].ButtonNameMapping					= 'Y';
	InputButtonDataList[GB_B].ButtonNameMapping					= 'B';
	InputButtonDataList[GB_Start].ButtonNameMapping				= 'Start';
	InputButtonDataList[GB_Back].ButtonNameMapping				= 'Back';
	InputButtonDataList[GB_LeftTrigger].ButtonNameMapping		= 'L2';
	InputButtonDataList[GB_LeftBumper].ButtonNameMapping		= 'L1';
	InputButtonDataList[GB_RightTrigger].ButtonNameMapping		= 'R2';
	InputButtonDataList[GB_RightBumper].ButtonNameMapping		= 'R1';
	InputButtonDataList[GB_DPad_Up].ButtonNameMapping			= 'DPad_Up';
	InputButtonDataList[GB_DPad_Left].ButtonNameMapping			= 'DPad_Left';
	InputButtonDataList[GB_DPad_Down].ButtonNameMapping			= 'DPad_Down';
	InputButtonDataList[GB_DPad_Right].ButtonNameMapping		= 'DPad_Right';
	InputButtonDataList[GB_LeftStick_Push].ButtonNameMapping	= 'L3';
	InputButtonDataList[GB_RightStick_Push].ButtonNameMapping	= 'R3';

	// Set the input handlers
	InitializeButtonHandlingHandlers();
}


event PlayerInput( float DeltaTime )
{
	Super.PlayerInput(DeltaTime);

	if( IsInputIdle() == FALSE )
	{
		LastInputTime = WorldInfo.TimeSeconds;
	}

	// rawjoylook is used by the camera system, so add in mouse values if we're not using a joystick
	RawJoyLookRight += aMouseX;
	RawJoyLookUp += aMouseY;
}


/** Sets the input handler for a particular button */
final function SetInputButtonHandle( EGameButtons GBType, delegate<HandleButtonInput> Handler )
{
	InputButtonDataList[GBType].ButtonHandler = Handler;
}

/** Sets the input handlers for the button handling list - set by subclasses */
event InitializeButtonHandlingHandlers();

/** Copies the raw values from one input object to this one, and will either wipe or clear the active values and PressedKey array */
function InitializeActiveButtonsFromInputObject( NanoPlayerInput_Base InputObject, bool bWipeInputState )
{
	local int Idx;

	// Clears the pressed keys array for this input object
	ResetInput();

	// If there was a valid previous input object
	if ( InputObject != None )
	{
		for ( Idx = 0; Idx < InputButtonDataList.length; Idx++ )
		{
			// Copy the raw
			InputButtonDataList[Idx].RawActive = InputObject.InputButtonDataList[Idx].RawActive;

			// Wipe the active buttons
			if ( bWipeInputState )
			{
				InputButtonDataList[Idx].Active = 0;
			}
			// Copy the active values
			else
			{
				InputButtonDataList[Idx].Active = InputObject.InputButtonDataList[Idx].Active;
			}
		}

		// Copy the PressedKeys array
		if ( !bWipeInputState )
		{
			for ( Idx = 0; Idx < InputObject.PressedKeys.length; Idx++ )
			{
				PressedKeys.AddItem( InputObject.PressedKeys[Idx] );
			}
		}
	}
	// No input object
	else
	{
		for ( Idx = 0; Idx < InputButtonDataList.length; Idx++ )
		{
			// Wipe the raw values
			InputButtonDataList[Idx].RawActive = 0;

			// Wipe the active values
			InputButtonDataList[Idx].Active = 0;
		}
	}
}

/**
* Called when this input object is pushed onto the input stack and will now be the first in line.
*		@param bWipePrevInputState - determines whether this input object will copy the previous input object's state or wipe it
*/
function PushedOnTopOfInputStack( NanoPlayerInput_Base PrevInputObject, bool bWipePrevInputState )
{
	InitializeActiveButtonsFromInputObject( PrevInputObject, bWipePrevInputState );
}

/** Called when another input object is pushed on top of this one and will now become second in line. */
function PushedBackOnInputStack();

/** Called when the top most input object is popped off of the stack and now this input object will become first in line. */
function PoppedToTopOfInputStack( NanoPlayerInput_Base PrevInputObject, bool bWipePrevInputState )
{
	// If the previous input object was derived from this class, we're going to copy the state of the previous input object
	if ( ClassIsChildOf(PrevInputObject.Class, Class) )
	{
		bWipePrevInputState = false;
	}

	InitializeActiveButtonsFromInputObject( PrevInputObject, bWipePrevInputState );
}

/**
* Called when this input object is popped off of the stack.
*		@param bWipePrevInputState - determines whether this input object will copy the previous input object's state or wipe it
*/
function PoppedOffOfInputStack();

/**
 * Disable the input buttons
 * @param bIsPOI - if the POI system is having us disable the input, do not disable the button responsible for POI
 */
final function DisableButtonInput( optional bool bIsPOI )
{
	local int Idx;
	for (Idx = 0; Idx < InputButtonDataList.length; Idx++)
	{
		// always allow start button to be used we disable input as that is our "pause" button
		if( Idx == GB_Start )
		{
			continue;
		}

		if ( bIsPOI && (Idx == GB_Y) )
		{
			continue;
		}

		if ( IsButtonActive(EGameButtons(Idx)) )
		{
			ForceButtonRelease( EGameButtons(Idx) );
		}
		else if ( IsButtonActive(EGameButtons(Idx), TRUE) )
		{
			InputButtonDataList[Idx].RawActive = 0;
		}
	}
}

/** Enable the input buttons */
final function EnableButtonInput()
{
	local int Idx;

	// set the active set to the raw set
	for (Idx = 0; Idx < InputButtonDataList.length; Idx++)
	{
		InputButtonDataList[Idx].Active = InputButtonDataList[Idx].RawActive;
	}
	//@todo - call the handlers for all the newly active buttons?
}

/** Returns TRUE if the button is currently held. */
simulated final function bool IsButtonActive( EGameButtons Button, optional bool bRaw, optional out float HoldTime )
{
	if ((bRaw ? InputButtonDataList[Button].RawActive == 1 : InputButtonDataList[Button].Active == 1))
	{
		HoldTime = `TimeSince(InputButtonDataList[Button].LastRawActiveTime);
		return TRUE;
	}
	return FALSE;
}

/** Forces a button to release, optionally skipping the handler */
final function ForceButtonRelease( EGameButtons Button, optional bool bSilent )
{
	if (!bSilent)
	{
		ButtonRelease( InputButtonDataList[Button].ButtonNameMapping );
	}
	else
	{
		InputButtonDataList[Button].RawActive = 0;
		InputButtonDataList[Button].Active = 0;
	}
}

/**
 * Updates the button values for all joystick inputs, triggering registered input events as well
 */
function UpdateJoystickInput(float DeltaTime)
{
	local SeqEvt_Input InputEvt;
	local bool bShouldTrapInput;
	local byte Idx;

	// grab the current values of the sticks
	//@fixme - find some way to avoid hard-coded values, instead read from the ini setting?
	InputButtonDataList[GB_LeftStick_Up].RawActive = (aBaseY >= 0.3f ? 1 : 0);
	InputButtonDataList[GB_LeftStick_Down].RawActive = (aBaseY <= -0.3f ? 1 : 0);
	InputButtonDataList[GB_LeftStick_Left].RawActive = (aStrafe <= -0.3f ? 1 : 0);
	InputButtonDataList[GB_LeftStick_Right].RawActive = (aStrafe >= 0.3f ? 1 : 0);
	InputButtonDataList[GB_RightStick_Up].RawActive = (aLookUp >= 0.3f ? 1 : 0);
	InputButtonDataList[GB_RightStick_Down].RawActive = (aLookUp <= -0.3f ? 1 : 0);
	InputButtonDataList[GB_RightStick_Left].RawActive = (aTurn <= -0.3f ? 1 : 0);
	InputButtonDataList[GB_RightStick_Right].RawActive = (aTurn >= 0.3f ? 1 : 0);

	// check for joystick kismet events
	for ( Idx = GB_LeftStick_Up; Idx <= GB_RightStick_Right; Idx++ )
	{
		// if it doesn't match the current value
		if (InputButtonDataList[Idx].RawActive != InputButtonDataList[Idx].Active)
		{
			bShouldTrapInput = FALSE;

			// check for a kismet input event activation
			foreach InputEvents(InputEvt)
			{
				// send to kismet input event, and record whether the input should be trapped
				bShouldTrapInput = ( InputEvt.CheckInputActivate(EGameButtons(Idx),(InputButtonDataList[Idx].RawActive == 1)) && InputEvt.bTrapInput ) || bShouldTrapInput ;
			}

			// and store the new value.  If we trapped the input, set to 0 (just as we do for buttons in ButtonPress()
			InputButtonDataList[Idx].Active = bShouldTrapInput ? 0 : InputButtonDataList[Idx].RawActive;
		}
	}
}

protected function ApplyTurningFunction(float Val)
{
	local bool bWasNeg;
	bWasNeg = Val < 0;

	Val = Abs(Val) ** LookStickCurveExponent;

	if (bWasNeg)
	{
		Val = -Val;
	}
}


function ApplyTurnDeceleration(float DeltaTime)
{
	if ( (aTurn == 0) && (aLookUp == 0) )
	{
		CurViewAccel = LookAccelInterpSpeed;
	}
	else
	{
		CurViewAccel = FInterpConstantTo(CurViewAccel, 10000.f, DeltaTime, ViewAccelConstantInterpSpeed);
	}

	// turn
	if ( (aTurn == 0) && (LastaTurn != 0) )
	{
		aTurn = FInterpTo(LastaTurn, aTurn, DeltaTime, LookDecelInterpSpeed);
	}
	else if (LookAccelInterpSpeed > 0.f && abs(aTurn) > abs(LastaTurn) && MyNP != None && MyNP.bIsTargeting)
	{
		aTurn = FInterpTo(LastaTurn, aTurn, DeltaTime, LookAccelInterpSpeed);
	}

	// pitch
	if ( (aLookUp == 0) && (LastaLookUp != 0) )
	{
		aLookUp = FInterpTo(LastaLookUp, aLookUp, DeltaTime, LookDecelInterpSpeed);
	}
	else if (LookAccelInterpSpeed > 0.f && abs(aLookUp) > abs(LastaLookUp) && MyNP != None && MyNP.bIsTargeting)
	{
		aLookUp = FInterpTo(LastaLookUp, aLookUp, DeltaTime, LookAccelInterpSpeed);
	}
}


/**
 * Overridden to update the joystick input.
 */
function PreProcessInput(float DeltaTime)
{
	local NanoWeapon NW;
	local float ActiveJuggleTime;
//	local float UpDelta, RightDelta;
	local float RightThumbStickScalar;
	local int SkillIdx;

	// HACK: Zero input when menu is up to stop you walking around
// 	if(MyNanoHUD.CurrentInGameMenu != IGM_None)
// 	{
// 		//ZeroAllStickInput();
// 	}

//	UpDelta	= Abs((RawJoyUp + 1.f) - (OriginalJoyUp + 1.f));
//	RightDelta = Abs((RawJoyRight + 1.f) - (OriginalJoyRight + 1.f));

	if( bRemapControls && !bCinematicMode && (Abs(RawJoyUp) > 0.1f || Abs(RawJoyRight) > 0.1f) )
	{
		RemapControlsByRotation( Normalize(PlayerCamera.GetCameraRotation() - ControlsRemapRotation), RemappedJoyRight, RemappedJoyUp );
		aBaseY  = RemappedJoyUp;
		aStrafe = RemappedJoyRight;
	}
	else
	{	
		bRemapControls   = FALSE;
		RemappedJoyUp	 = RawJoyUp;
		RemappedJoyRight = RawJoyRight;
	}

	// if we're mid-dash
	if( MyNP != None)
	{
		if( MyNP.InteractionPawn != None && MyNP.InteractionType == PAWNINTER_Tackle ) 
		{
			// If picking them up or slamming them into a wall, force forward motion
			if( MyNP.ForceSprintTimer > 0.f || MyNP.bSlammingTackledActor )
			{
				aForward = 1.0f;
				aBaseY = 1.0f;
			}

			// If slamming them into a wall, stop turning/strafing
			if( MyNP.bSlammingTackledActor )
			{
				aBaseX = 0.0f;
				aBaseZ = 0.0f;
				aTurn = 0.0f;
				aStrafe = 0.0f;
				aUp = 0.0f;
			}
		}

		for( SkillIdx = 0; SkillIdx < MyNP.ActiveSkills.Length; SkillIdx++ )
		{
			MyNP.ActiveSkills[SkillIdx].PreProcessInput( DeltaTime, self );
		}

		ActiveJuggleTime = `TimeSince( MyNP.LastCausedJuggleTime ) - ActiveJuggleDuration;
		if( ActiveJuggleTime > 0.f && ActiveJuggleTime < ActiveJuggleRecoveryDuration )
		{
			aTurn *= ActiveJuggleTime / ActiveJuggleRecoveryDuration;
		}

		if( WorldInfo.TimeSeconds < MyNP.GreyGooGrabby_TimeUntilGrabbySurfaceEnds )
		{
			aBaseX = 0.0f;
			aBaseY = 0.0f;
			aBaseZ = 0.0f;
			aForward = 0.0f;
			aTurn = 0.0f;
			aStrafe = 0.0f;
			aUp = 0.0f;
		}

		// this should come last as dropping the hammer should override all other movement bonuses
		// so if we have the Post "Drop The Hammer" flag set we can not move nor look around or do anything
		if( MyNP.bStuckAfterDroppingTheHammer )
		{
			RawJoyLookRight = 0.0f;
			RawJoyLookUp = 0.0f;

			ZeroAllStickInput();
		}

		// Update slide-throttle when stuck in wall
		if(MyNP.bIsAttachedToWall)
		{
			MyNP.WallStabThrottle = FClamp(RawJoyUp, 0.0, 1.0);
			MyNP.WallStabStrafe = RawJoyRight;
		}
	}

	Super.PreProcessInput(DeltaTime);

	// nonlinear stick response
	ApplyTurningFunction(aTurn);
	ApplyTurningFunction(aLookUp);

	if( bViewAccelerationEnabled && (MyNP == None || !MyNP.bIsDashing) )
	{
		ApplyViewAcceleration( DeltaTime );
	}

	NW = (Pawn != none) ? NanoWeapon(Pawn.Weapon) : none;

	if( (MyNP != None) && MyNP.bIsTargeting && bTargetFrictionEnabled )
	{
		if( NW != none )
		{
			bAppliedTargetFriction = FALSE; // clear the friction flag (we do it here so applyViewAcceleration has a chance to use it from the time before)
			ApplyTargetFriction( DeltaTime, NW );
		}
	}


	// these needs to happen after aForward has been updated.
	// might be out of place here
	if (bAutoCenterPitch && !bAppliedTargetFriction && (NW == None || NW.GetZoomedState() != ZST_Zoomed))
	{
		ApplyViewAutoPitchCentering( DeltaTime );
	}

	// See if we should apply the zoomed turn speed scale pct
	if( ( NW != None ) && ( NW.GetZoomedState() == ZST_Zoomed ) )
	{
		aTurn *= NW.ZoomedTurnSpeedScalePct;
		aLookUp *= NW.ZoomedTurnSpeedScalePct;
	}

//	aTurn *= TurningAccelerationMultiplier;

	// This will apply the sensitivity scaling to the controller inputs
	// NOTE:  once we have this we may not want to apply if we bAppliedTargetFriction
	aTurn *= SensitivityMultiplier;
	aLookUp *= SensitivityMultiplier * LookPitchSensivityRatio;

	// now do the GoreManager's scalar which makes it so the view is not all jerky fast when gore slomo is active
	RightThumbStickScalar = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).RightThumbStickScalar;
	aTurn *= RightThumbStickScalar;
	aLookUp *= RightThumbStickScalar;
	//`log( "aTurn: " $ aTurn $ " aLookUp: " $ aLookUp $ " DeltaTime: " $ DeltaTime );
	
	ApplyTurnDeceleration(DeltaTime);

	UpdateJoystickInput(DeltaTime);

	LastaTurn = aTurn;
	LastaLookUp = aLookUp;
}

function PostProcessInput( float DeltaTime )
{
	local int SkillIdx;

	Super.PostProcessInput(DeltaTime);

	DeltaJoyUp      = RawJoyUp - LastJoyUp;
	DeltaJoyRight   = RawJoyRight - LastJoyRight;
	LastJoyUp       = RawJoyUp;   
	LastJoyRight    = RawJoyRight;

	if( MyNP != None )
	{
		for( SkillIdx = 0; SkillIdx < MyNP.ActiveSkills.Length; SkillIdx++ )
		{
			MyNP.ActiveSkills[SkillIdx].PostProcessInput( DeltaTime, self );
		}
	}
}


`if(`notdefined(FINAL_RELEASE))
function DrawHUD( HUD H )
{
//	local Vector XAxis, YAxis, ZAxis, /*Dir, */TargLoc, CamLoc;
//	local Rotator CamRot;
//	local int X, Y;
//	local float UnusedW, UnusedH;

	super.DrawHUD( H );

//	X = 15;
//	Y = 150;

// 	if( bDebugFriction )
// 	{
// 		H.Canvas.SetPos(X,Y);
// 		H.Canvas.DrawText("Target:"@LastFrictionTarget@"["$LastDistToTarget$"] ["$LastDistMultiplier$"]");
// 		Y += 15;
// 
// 		H.Canvas.SetPos(X,Y);
// 		H.Canvas.DrawText("Aim distance (Y/Z): ["$LastDistFromAimY$"] ["$LastDistFromAimZ$"]");
// 		Y += 15;
// 
// 		H.Canvas.SetPos(X,Y);
// 		H.Canvas.DrawText("Target collision (R/H): ["$LastTargetWidth$"] ["$LastTargetHeight$"]");
// 		Y += 15;
// 
// 		H.Canvas.SetPos(X,Y);
// 		H.Canvas.DrawText("Friction multiplier: ["$LastFrictionMultiplier$"]");
// 		Y += 15;
// 
// 		H.Canvas.SetPos(X,Y);
// 		H.Canvas.DrawText("TargVelDotTurnDir: ["$LastTargVelDotTurnDir$"] CamRotDotTargY ["$LastCamRotDotTargY$"]");
// 		Y += 15;
// 
// 		if( LastFrictionTarget != None )
// 		{
// 			LastFrictionTarget.GetAimFrictionExtent(UnusedW, UnusedH, TargLoc);
// 
// 			// Draw line to our friction target (GREEN)
// 			DrawDebugLine(Pawn.GetPawnViewLocation(),TargLoc,0,255,0);
// 
// 			GetPlayerViewPoint( CamLoc, CamRot );
// 			GetAxes( CamRot, XAxis, YAxis, ZAxis );
// 
// 			// Draw the friction radius around target (BLUE)
// 			DrawDebugLine( TargLoc + (YAxis * LastTargetWidth) + (ZAxis * LastTargetHeight),
// 				TargLoc + (YAxis * LastTargetWidth) - (ZAxis * LastTargetHeight),
// 				0,0,255 );
// 			DrawDebugLine( TargLoc - (YAxis * LastTargetWidth) + (ZAxis * LastTargetHeight),
// 				TargLoc - (YAxis * LastTargetWidth) - (ZAxis * LastTargetHeight),
// 				0,0,255 );
// 			DrawDebugLine( TargLoc + (YAxis * LastTargetWidth) + (ZAxis * LastTargetHeight),
// 				TargLoc - (YAxis * LastTargetWidth) + (ZAxis * LastTargetHeight),
// 				0,0,255 );
// 			DrawDebugLine( TargLoc + (YAxis * LastTargetWidth) - (ZAxis * LastTargetHeight),
// 				TargLoc - (YAxis * LastTargetWidth) - (ZAxis * LastTargetHeight),
// 				0,0,255 );
// 		}
// 	}

//	X = 15;
//	Y += 50;

// 	if( bDebugAdhesion )
// 	{
// 		H.Canvas.DrawColor = MakeColor(255, 255, 0, 255);
// 
// 		H.Canvas.SetPos(X,Y);
// 		H.Canvas.DrawText("Target:"@LastFrictionTarget@"["$LastDistToTarget$"]");
// 		Y += 15;
// 
// 		H.Canvas.SetPos(X,Y);
// 		H.Canvas.DrawText("Aim distance (Y/Z): ["$LastDistFromAimYa$"] ["$LastDistFromAimZa$"]");
// 		Y += 15;
// 
// 		H.Canvas.SetPos(X,Y);
// 		H.Canvas.DrawText("DeltaRot:"@LastDeltaRot);
// 		Y += 15;
// 
// 		H.Canvas.SetPos(X,Y);
// 		H.Canvas.DrawText("Adhesion Amt (Y/Z): ["$LastAdhesionAmtY$"] ["$LastAdhesionAmtZ$"]");
// 		Y += 15;
// 
// 		H.Canvas.SetPos(X,Y);
// 		H.Canvas.DrawText("Adhesion Adjust (Y/Z): ["$LastAdjustY$"] ["$LastAdjustZ$"]");
// 		Y += 15;
// 	}

	if (bDebugViewAcceleration)
	{
		H.Canvas.DrawDebugGraph("Turn", RawJoyLookRight, abs(LastaTurn), 50, 50, 200, 400, vect2d(-1.f, 1.f), vect2d(2.f, 0.f));

		//if (bDoPitchAccelToo)
		//{
			H.Canvas.DrawDebugGraph("LookUp", RawJoyLookUp, abs(LastaLookUp), 300, 50, 200, 400, vect2d(-1.f, 1.f), vect2d(2.f, 0.f));
		//}

		H.Canvas.DrawDebugGraph("Raw X,Y", RawJoyLookRight, RawJoyLookUp, 550, 50, 200, 200, vect2d(-1,1), vect2d(-1,1));
		H.Canvas.DrawDebugGraph("aTurn/aLookUp", LastaTurn, LastaLookUp, 800, 50, 200, 200, vect2d(-1,1), vect2d(-1,1));
	}
}

`endif




/**
* Jump is disabled
*/
exec function Jump();

/**
 * Checks all the cases for button input filtering, called solely by ButtonPress()/ButtonRelease().
 *
 * @return TRUE if the input should be filtered (ignored)
 */
function bool FilterButtonInput(Name ButtonName,bool bPressed,int ButtonIdx)
{
	local NanoPawn NP;
	local SeqEvt_Input InputEvt;
	local bool bTrappedInput;

	// check to see if global input has been disabled
	if (InputIsDisabledCount != 0)
	{
		// Disregard filtering for POI button
		//todo - do something less hacky.  blame gears.
		if( ButtonName == 'Y' && !bPressed && bLookingAtPointOfInterest )
		{
			return FALSE;
		}

		return TRUE;
	}

	NP = NanoPawn(Pawn);
	if( NP != None )
	{
		if( DebugCam != None )
		{
			// Only allow start, back, and X to be passed on to the input handlers
			if( ButtonName != 'Start' && ButtonName != 'Back' && ButtonName != 'X' )
			{
				return TRUE;
			}
		}
		else if( NP.IsInState('NearMissionBriefing') )
		{
			// Only allow speaking and menu actions when in the mission briefing state
			if( ButtonName != 'B' && ButtonName != 'Start' && ButtonName != 'Back' )
			{
				// Handle canceling of dialog if the player holds B down for more than a second
				if( ButtonName == 'B' )
				{
					if( bPressed )
					{
						SetTimer(1.f, false, nameof(NP.CancelMissionBriefing),NP);
					}
					else
					{
						ClearTimer(nameof(NP.CancelMissionBriefing),NP);
					}
				}

				return TRUE;
			}
		}

		// Give special moves a chance to act on button input
		if( MyNP != None && MyNP.ActiveSpecialMove != None && MyNP.ActiveSpecialMove.FilterButtonInput(ButtonName, bPressed, ButtonIdx) )
		{
			return TRUE;
		}

		if( ( MyNanoHUD != None ) && ( MyNanoHUD.HUDFilterButtonInput(ButtonName, bPressed, ButtonIdx) ) )
		{
			return TRUE;
		}

		if( NanoInventoryManager(NP.InvManager).bShowUpgradesScreen == TRUE )
		{
			return NanoInventoryManager(NP.InvManager).FilterButtonInput( ButtonName, bPressed, ButtonIdx );
		}

		// Allow the pawn to steal input for cradle surfing
		if( NP.CradleSurfingFilterButtonInput( ButtonName, bPressed, ButtonIdx ) )
		{
			return TRUE;
		}

		// Allow the pawn to steal input for scanning the city for audio signals
		if( NP.CityScanningFilterButtonInput(ButtonName, bPressed, ButtonIdx) )
		{
			return TRUE;
		}
	}

	// check to see if there are any Kismet events trapping this input
	foreach InputEvents(InputEvt)
	{
		if (InputEvt.CheckInputActivate(EGameButtons(ButtonIdx),bPressed) && InputEvt.bTrapInput)
		{
			bTrappedInput = TRUE;
		}
	}

	if (bTrappedInput)
	{
		//`log("kismet trap, ignoring:"@ButtonName@bPressed);
		return TRUE;
	}

	return FALSE;
}

/**
* Find the index in the InputButtonDataList using the button name as the key.
*
* @returns the index in the InputButtonDataList of where the ButtonName was found.
*/
final function int FindInputButtonDataIndex( Name ButtonName )
{
	local int Idx;

	for ( Idx = 0; Idx < InputButtonDataList.length; Idx++ )
	{
		if ( InputButtonDataList[Idx].ButtonNameMapping == ButtonName )
		{
			return Idx;
		}
	}

	return INDEX_NONE;
}

/**
* Entry point for button press handling.
*/
exec function ButtonPress(coerce Name ButtonName)
{
	local int ButtonIdx;
	local delegate<HandleButtonInput> ButtonHandler;

	LastInputTime = WorldInfo.TimeSeconds;

	// get the id first
	ButtonIdx = FindInputButtonDataIndex( ButtonName );

`if(`notdefined(FINAL_RELEASE))
	// assert it's a valid button name
	if ( ButtonIdx == INDEX_NONE )
	{
		`Warn("Invalid button"@ButtonName@"in"@GetFuncName());
		return;
	}
`endif

	if ( InputButtonDataList[ButtonIdx].RawActive == 0 )
	{
		// mark the raw status
		InputButtonDataList[ButtonIdx].RawActive = 1;
		InputButtonDataList[ButtonIdx].LastRawActiveTime = WorldInfo.TimeSeconds;

		// if the input shouldn't be filtered
		if ( !FilterButtonInput(ButtonName,TRUE,ButtonIdx) )
		{
			CatchInputBuffer( EGameButtons(ButtonIdx) );

			//`log("unfiltered button press:"@ButtonName);
			// mark the status
			InputButtonDataList[ButtonIdx].Active = 1;
			// and call the corresponding function
			ButtonHandler = InputButtonDataList[ButtonIdx].ButtonHandler;
			if ( ButtonHandler != None )
			{
				ButtonHandler(TRUE);
			}
		}
	}
}

/**
* Entry point for button release handling.
*/
exec function ButtonRelease(coerce Name ButtonName)
{
	local int ButtonIdx;
	local delegate<HandleButtonInput> ButtonHandler;

	LastInputTime = WorldInfo.TimeSeconds;

	// get the id first
	ButtonIdx = FindInputButtonDataIndex( ButtonName );

	`if(`notdefined(FINAL_RELEASE))
		// assert it's a valid button name
		if ( ButtonIdx == INDEX_NONE )
		{
			`Warn("Invalid button"@ButtonName@"in"@GetFuncName());
			return;
		}
		`endif

			if ( InputButtonDataList[ButtonIdx].RawActive == 1 )
			{
				// mark the raw status
				InputButtonDataList[ButtonIdx].RawActive = 0;

				// if the input shouldn't be filtered
				if ( !FilterButtonInput(ButtonName,FALSE,ButtonIdx) )
				{
					//`log("unfiltered button release:"@ButtonName);
					// mark the status
					InputButtonDataList[ButtonIdx].Active = 0;
					// and call the corresponding function
					ButtonHandler = InputButtonDataList[ButtonIdx].ButtonHandler;
					if ( ButtonHandler != None )
					{
						ButtonHandler(FALSE);
					}
				}
			}
}

// check for double click move
function Actor.EDoubleClickDir CheckForDoubleClickMove( float DeltaTime )
{
	return DCLICK_None;
}

/** Toggle debug display for target adhesion **/
exec function DebugTargetAdhesion()
{
	if ( WorldInfo.NetMode == NM_StandAlone )
	{
		bDebugTargetAdhesion = !bDebugTargetAdhesion;
		ClientMessage( "bDebugTargetAdhesion is now: " $ bDebugTargetAdhesion );
	}
}

/** Toggle debug display for target friction **/
exec function DebugTargetFriction()
{
	if ( WorldInfo.NetMode == NM_StandAlone )
	{
		bDebugTargetFriction = !bDebugTargetFriction;
		ClientMessage( "bDebugTargetFriction is now: " $ bDebugTargetFriction );
	}
}


/**
 * This will attempt to keep the player aiming at the target.  It will forcibly aim the player at the target.
 *
 * TODO:  move this to c++
 **/
function ApplyTargetAdhesion( float DeltaTime, NanoWeapon W, out int out_YawRot, out int out_PitchRot )
{
	local Vector	RealTargetLoc, TargetLoc, CamToTarget, AimLoc, CamLoc, ClosestY, ClosestZ;
	local Vector	X, Y, Z;
	local Rotator	CamRot, DeltaRot;
	local float		DistToTarget, DistFromAimZ, DistFromAimY, AdhesionAmtY, AdhesionAmtZ, TargetRadius, TargetHeight, Pct;
	local int		AdjustY, AdjustZ;
	local Actor		AdhesionTarget;
	local bool		bTargetMoving, bPlayerMoving;

	if( W == None || !W.bTargetAdhesionEnabled || (abs(aTurn) < 0.1 && abs(aLookUp) < 0.1))
	{
		return;
	}

	// Setup some initial data
	CamLoc = ViewTarget.Location; // CalcViewLocation;
	CamRot = PlayerCamera.GetCameraRotation();
	GetAxes( CamRot, X, Y, Z );

	// attempt to use the friction target if available
	AdhesionTarget = LastFrictionTarget;

	if (AdhesionTarget == None || `TimeSince(LastFrictionTargetTime) > W.TargetAdhesionTimeMax)
	{
		// otherwise look for a new target
		AdhesionTarget = TargetedActor;
	}

	// If still within adhesion time constraints, and the target is still alive
	if( AdhesionTarget != None )
	{
		// Grab collision info from target
		AdhesionTarget.GetBoundingCylinder( TargetRadius, TargetHeight );
		// reduce the size a bit to allow adhesion to move the crosshair onto the character
		TargetRadius *= 0.65f;
		TargetHeight *= 0.65f;
		RealTargetLoc = AdhesionTarget.Location + (W.TargetFrictionOffset >> CamRot);

		bTargetMoving = VSize(AdhesionTarget.Velocity) > W.TargetAdhesionTargetVelocityMin;
		bPlayerMoving = VSize(Pawn.Velocity) > W.TargetAdhesionPlayerVelocityMin;

		// if either the target or player is moving, and the target is in front
		if(	(bTargetMoving || bPlayerMoving) && ((RealTargetLoc - CamLoc) dot vector(CamRot) > 0.f) )
		{
			// Figure out the distance from aim to target
			CamToTarget = (RealTargetLoc - CamLoc);
			DistToTarget = VSize(CamToTarget);
			AimLoc = CamLoc + (X * DistToTarget);

			// Calculate the aim friction multiplier
			// Y component
			TargetLoc	 = RealTargetLoc;
			TargetLoc.Z  = AimLoc.Z;
			DistFromAimY = PointDistToLine(AimLoc,(TargetLoc - CamLoc),CamLoc, ClosestY );
			ClosestY = TargetLoc + Normal(ClosestY - TargetLoc) * TargetRadius;

			// Z component
			TargetLoc	 = RealTargetLoc;
			TargetLoc.X  = AimLoc.X;
			TargetLoc.Y  = AimLoc.Y;
			DistFromAimZ = PointDistToLine(AimLoc,(TargetLoc - CamLoc),CamLoc, ClosestZ);
			ClosestZ	 = TargetLoc + Normal(ClosestZ - TargetLoc) * TargetRadius;

			DeltaRot.Yaw	= Rotator(ClosestY - CamLoc).Yaw	- CamRot.Yaw;
			DeltaRot.Pitch	= Rotator(ClosestZ - CamLoc).Pitch	- CamRot.Pitch;
			DeltaRot = Normalize( DeltaRot );

			// Make sure it is still within valid distance AND
			// outside the cylinder in at least one direction AND
			// target can be seen
			if( DistToTarget <= W.TargetAdhesionDistanceMax && (DistFromAimY > TargetRadius || DistFromAimZ > TargetHeight)	)
			{
				// Lateral adhesion
				if (DistFromAimY > TargetRadius)
				{
					Pct = 1.f - (DistFromAimY-TargetRadius)/W.TargetAdhesionAimDistY;
					if (Pct > 0.f)
					{
						// boost based on other gameplay things (distance or something)
						// boost slightly when targeting
						Pct = FMin(Pct, TargetAdhesionScaleRangeMaxPercentUsage);
						AdhesionAmtY = GetRangeValueByPct(W.TargetAdhesionScaleRange, Pct);
						// Apply the adhesion
						AdjustY = DeltaRot.Yaw * (AdhesionAmtY * DeltaTime);
						//`log( `showvar(AdhesionAmtY)@`showvar(Pct)@`showvar(DistFromAimY-TargetRadius) );
						out_YawRot += AdjustY;
					}
				}

				// Vertical adhesion
				if (DistFromAimZ > TargetHeight)
				{
					Pct = 1.f - (DistFromAimZ-TargetHeight)/W.TargetAdhesionAimDistZ;
					if (Pct > 0.f)
					{
						// boost based on other gameplay things (distance or something)
						// boost slightly when targeting
						Pct = FMin(Pct, TargetAdhesionScaleRangeMaxPercentUsage);
						AdhesionAmtZ = GetRangeValueByPct(W.TargetAdhesionScaleRange, Pct);
						// Apply the adhesion
						AdjustZ = DeltaRot.Pitch * (AdhesionAmtZ * DeltaTime);
						//`log( `showvar(AdhesionAmtZ)@`showvar(Pct)@`showvar(DistFromAimZ-TargetHeight) );
						out_PitchRot += AdjustZ;
					}
				}
			}
		}
	}
}


/**
 * This will scale the player's rotation speed depending on the location of their thumbstick and how
 * long they have held it there.
 **/
// function ApplyViewAcceleration( float DeltaTime )
// {
// 	local float CurrentPitch;
// 	local NanoWeapon NW;
// 
// 	NW = (Pawn != none) ? NanoWeapon(Pawn.Weapon) : none;
// 	CurrentPitch = NormalizeRotAxis(PlayerCamera.GetCameraRotation().Pitch);
// 	
// 	//`log( "ahh: " $ square(Abs(RawJoyLookRight)) + square(Abs(RawJoyLookUp/LookPitchSensivityRatio)) $ " RawJoyLookRight: " $ RawJoyLookRight $ " RawJoyLookUp: " $ RawJoyLookUp );
// 
// 	if( CurrentPitch < -1*ViewAccel_LookingUpOrDownBoundary )
// 	{
// 		//`log( "looking down: " $ CurrentPitch $ " aLookUp: " $ aLookUp );
// 		bIsLookingDown = TRUE;
// 	}
// 	else if( CurrentPitch > ViewAccel_LookingUpOrDownBoundary )
// 	{
// 		//`log( "looking up: " $ CurrentPitch $ " aLookUp: " $ aLookUp );
// 		bIsLookingUp = TRUE;
// 	}
// 
// 	// need to check for sniper here
// 	// check to see if we are trying to get back to center from looking up or down
// 	if( ( ( bIsLookingDown == TRUE ) && ( RawJoyLookUp < -1*ViewAccel_PitchThreshold ) )
// 		|| ( ( bIsLookingUp == TRUE ) && ( RawJoyLookUp > ViewAccel_PitchThreshold ) )
// 		)
// 	{
// 		aLookUp *= ViewAccel_BackToCenterSpeed;
// 		//`log( "shizzle: " $ abs(RawJoyLookUp) $ " CurrentPitch: " $ CurrentPitch $ " aLookUp: " $ aLookUp $ " RawJoyLookUp: " $ RawJoyLookUp );
// 		//`log( "CurrentPitch: " $ CurrentPitch $ " RawJoyLookUp: " $ RawJoyLookUp $ " aLookUp: " $ aLookUp );
// 	}
// 	// non-linear scale for turn magnitude
// 	// If above threshold, accelerate Yaw turning rate (e.g. when you slam the thumbstick to the farthest position)
// 	else if( ( Abs(aTurn) > ViewAccel_YawThreshold ) ||  ( (square(RawJoyLookRight) + square(RawJoyLookUp/LookPitchSensivityRatio)) > ViewAccel_DiagonalThreshold )
// 		)
// 	{
// 		// if we are not targeting someone.  (i.e. in the heat of battle of circle straffing you want to be JAMMED to the edge as you are spazzing out.  but are targeting and fighting so you don't want to flip around all speedy )
// 		if( ( ViewAccel_TimeHeld > ViewAccel_TimeToHoldBeforeFastAcceleration )
// 			&& ( !bAppliedTargetFriction )
// 			&& ( Pawn != none )
// 			&& ( ( !Pawn.IsFiring() ) || ( ( NW != None ) && ( NW.CanViewAccelerationWhenFiring() ) ) ) // if we are shooting then don't do super speed up (e.g. we are prob circle straffing))
// 			)
// 		{
// 			ViewAccel_CurrMutliplier += ( ViewAccel_RampSpeed ) ;
// 			aTurn *= FMin( FMax(ViewAccel_CurrMutliplier, ViewAccel_BaseMultiplier), ViewAccel_MaxTurnSpeed );  // we need to always be at least a 1.0f here or we will go slower and hitch
// 			//`log( "RawJoyLookRight: " $ RawJoyLookRight $ " RawJoyLookUp: " $ RawJoyLookUp $ " " $ (RawJoyLookUp/LookPitchSensivityRatio) $ " aTurn: " $ aTurn );
// 		}
// 		else
// 		{
// 			ViewAccel_CurrMutliplier = aTurn;
// 			ViewAccel_TimeHeld += DeltaTime;
// 		}
// 	}
// 	// we are doing a non slam to the edge movement
// 	else
// 	{
// 		// reset
// 		ViewAccel_CurrMutliplier = ViewAccel_BaseMultiplier;
// 		ViewAccel_TimeHeld = 0;
// 	}
// 
// 	// check to write out these vars if they were true before and if we are in the middle section of being "centered"
// 	if( ( bIsLookingDown || bIsLookingUp )
// 		&& ( CurrentPitch < ViewAccel_BackToCenterBoundary )
// 		&& ( CurrentPitch > -1*ViewAccel_BackToCenterBoundary )
// 		)
// 	{
// 		//`log( "resetting look up down" );
// 		bIsLookingDown = FALSE;
// 		bIsLookingUp = FALSE;
// 	}
// }

/**
 * Accelerate Joystick turning rate. (Player control helper).
 *
 * @param	DeltaTime	delta time seconds since last update.
 */
function ApplyViewAcceleration( float DeltaTime )
{
	local float Threshold, RampupTime, Multiplier;

	local bool bIsTargeting;

	// @todo, hook this flag up in nanoPC
	bIsTargeting = false;

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

		// now do pitch
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
		aTurn *= TargetingModeViewScalePct;
		aLookUp *= TargetingModeViewScalePct;
	}
}


function ResetViewAccelerationTimer(optional float NewValue)
{
	ViewAccel_TimeHeld = NewValue;
}


/**
 * This will slow down the player's aiming when they are on "top" of a valid Target.  So when you whip around
 * there will be a slight slow down when you are directly aiming at a target.
 *
 * TODO:  move this to c++
 **/
function ApplyTargetFriction( float DeltaTime, NanoWeapon W )
{
	local Actor FrictionTarget;
	local Vector CamLoc, X, Y, Z, CamToTarget, AimLoc, TargetLoc, RealTargetLoc;
	local Rotator CamRot;
	local float DistToTarget, DistMultiplier, DistFromAimZ, DistFromAimY;
	local float TargetRadius, TargetHeight;
	local float FrictionMultiplier;
	local bool bAimingTowardsTarget;

	if( Pawn == None || !W.bTargetFrictionEnabled || (abs(aTurn) < 0.1 && abs(aLookUp) < 0.1) )
	{
		return;
	}

	// Setup some initial data
	CamLoc = ViewTarget.Location; // CalcViewLocation;
	CamRot = PlayerCamera.GetCameraRotation();
	GetAxes( CamRot, X, Y, Z );

	FrictionTarget = TargetedActor;

	// If we have a valid friction target
	if( FrictionTarget != None )
	{
		RealTargetLoc = FrictionTarget.Location + ( W.TargetFrictionOffset >> CamRot );
		CamToTarget = ( RealTargetLoc - CamLoc );
		DistToTarget = VSize(CamToTarget);
		AimLoc = CamLoc + ( X * DistToTarget );

		// Grab collision info from target
		FrictionTarget.GetBoundingCylinder( TargetRadius, TargetHeight );
		if( bDebugTargetFriction )
		{
			DrawDebugCylinder(FrictionTarget.Location+vect(0,0,1)*TargetHeight, FrictionTarget.Location-vect(0,0,1)*TargetHeight, TargetRadius, 12, 255, 0, 0);
		}

		// Calculate the aim friction multiplier
		// Y component
		TargetLoc	 = RealTargetLoc;
		TargetLoc.Z  = AimLoc.Z;
		DistFromAimY = PointDistToLine(AimLoc,(TargetLoc - CamLoc),CamLoc);

		// Z component
		TargetLoc	 = RealTargetLoc;
		TargetLoc.X  = AimLoc.X;
		TargetLoc.Y  = AimLoc.Y;
		DistFromAimZ = PointDistToLine(AimLoc,(TargetLoc - CamLoc),CamLoc);

		// Calculate the distance multiplier
		DistMultiplier = 0.f;

		// Scale target radius by distance
		DistMultiplier = GetValueFromRange( W.TargetFrictionDistanceCurve, DistToTarget );
		TargetRadius *= 1.f + (W.TargetFrictionPeakRadiusScale * DistMultiplier);
		TargetHeight *= 1.f + (W.TargetFrictionPeakHeightScale * DistMultiplier);

		// this is used to reduce the target radius so that moving pawns have a smaller radius so that when we are tracking
		// them the reticle doesn't stop outside of their body mass making it either impossible to hit them or making it look bad when
		// shots do actually hit them
		if (VSize(FrictionTarget.Velocity) > 200)
		{
			TargetRadius *= 0.2;
		}

		//`log("friction"@`showvar(DistFromAimY)@`showvar(DistFromAimZ)@`showvar(DistMultiplier)@`showvar(DistToTarget));

		// If we should apply friction - must be within friction collision box
		if (DistFromAimY < TargetRadius && DistFromAimZ < TargetHeight)
		{
			// Calculate the final multiplier (only based on horizontal turn)
			FrictionMultiplier = GetRangeValueByPct( W.TargetFrictionMultiplierRange, 1.f - (DistFromAimY/TargetRadius) );

			// if not aiming at the target and still strong on the input
			bAimingTowardsTarget = (aTurn > 0.f && (CamToTarget dot Y) > 0.f) || (aTurn < 0.f && (CamToTarget dot Y) < 0.f);
			if (!bAimingTowardsTarget && abs(aTurn) > 0.8)
			{
				// reduce the friction effect
				FrictionMultiplier *= 0.5f;
			}

			if( FrictionMultiplier > 0.0f )
			{
				bAppliedTargetFriction = TRUE;
				//`log("*"@`showvar(FrictionMultiplier)@`showvar(aTurn)@`showvar(aLookUp));

				// Apply the friction
				aTurn *= (1.f - FrictionMultiplier);
				aLookUp *= (1.f - FrictionMultiplier);

				// Keep the friction target for possible use with adhesion
				LastFrictionTargetTime	= WorldInfo.TimeSeconds;
				LastFrictionTarget		= FrictionTarget;
			}
		}
	}
}


/**
* This will auto center the player's view when they are moving along and not firing
**/
function ApplyViewAutoPitchCentering( float DeltaTime )
{
	//local float AmountToAdjustPitch, CurrentPitch, TargetedPitch, PitchSpeed, VelScale;
	local NanoPawn NP;
	//local NanoSkill_Jump JumpSkill;

	// so if we are not doing any looking or firing
	if( aTurn != 0 || abs(RawJoyLookUp) > 0.2f || abs(RawJoyLookRight) > 0.2f || Pawn == None || Pawn.IsFiring() )
	{
		// don't auto-align camera if player is currently moving it
		LastTurnTime = WorldInfo.TimeSeconds;
		return;
	}

	NP = NanoPawn(Pawn);

	// Don't level when sliding/attached
	if ( (NP != None) && (NP.bEmptyHanded || NP.bIsAttachedToWall || NP.bSlidingDown) )
	{
		return;
	}
// 
// 	// force pitch down on sequential jumps (or car jumps)
// 	JumpSkill = MyNP.GetSkill(class'NanoSkill_Jump');
// 	if (`TimeSince(LastTurnTime) > 1.f 
// 		&& NP != None 
// 		&& NP.Physics == PHYS_Falling 
// 		&& (NP.TargetedAttractionActor != None || NP.CurrNanoState == ENS_Normal) 
// 		&& (NP.TargetedAttractionActor != None || (JumpSkill != None && JumpSkill.LastJumpLevel > 0))
// 		)
// 	{
// 		CurrentPitch = float(NormalizeRotAxis(Rotation.Pitch));
// 		VelScale = FClamp(VSize2D(NP.Velocity)/NP.GroundSpeed,0.5,1.f);
// 		if (NP.TargetedAttractionActor != None)
// 		{
// 			// look at the attraction actor at the max speed
// 			TargetedPitch = rotator(NP.TargetedAttractionActor.Location - NP.Location).Pitch * VelScale;
// 			PitchSpeed = JumpSkill.JumpLevels[JumpSkill.JumpLevels.Length-1].AutoTargetPitchSpeed * VelScale;
// 		}
// 		else
// 		{
// 			// otherwise use the config values based on jump level
// 			TargetedPitch = JumpSkill.JumpLevels[JumpSkill.LastJumpLevel].AutoTargetPitch * VelScale;
// 			PitchSpeed = JumpSkill.JumpLevels[JumpSkill.LastJumpLevel].AutoTargetPitchSpeed * VelScale;
// 			if (Velocity.Z > 0)
// 			{
// 				TargetedPitch *= 0.35;
// 				PitchSpeed *= 0.35;
// 			}
// 		}
// 		AmountToAdjustPitch = FInterpTo( CurrentPitch, TargetedPitch, DeltaTime, PitchSpeed ) - CurrentPitch;
// 		//`log(`showvar(CurrentPitch)@`showvar(AmountToAdjustPitch));
// 		if( abs(AmountToAdjustPitch) > AutoPitchStopAdjustingValue )
// 		{
// 			aLookup += (AmountToAdjustPitch < 0 ? PitchSpeed : -PitchSpeed) * (bInvertMouse ? -1 : 1);
// 		}
// 	}
// 	// if we are in a fan volume and ghosting then do not do any other pitch centering
// 	else if( 
// 		 ( NP.CurrNanoState == ENS_Dust) 
// 		&& ( NP.PreviousFanVolume != none ) )
// 	{
// 		/*
// 		// if we have not touched the stick in 500ms
// 		if( `TimeSince(LastTurnTime) > 0.5f )
// 		{
// 			CurrentPitch = float(NormalizeRotAxis(Rotation.Pitch));
// 			//VelScale = FClamp(VSize2D(NP.Velocity)/NP.GroundSpeed,0.5,1.f);
// 
// 			TargetedPitch = 7500.0f;
// 			PitchSpeed = 2.0f;
// 
// 			// if we are not already looking WAY up high move to a "nice" upwards looking view
// 			if( CurrentPitch < TargetedPitch )
// 			{
// 				AmountToAdjustPitch = FInterpTo( CurrentPitch, TargetedPitch, DeltaTime, PitchSpeed ) - CurrentPitch;
// 				//`log(`showvar(CurrentPitch)@`showvar(AmountToAdjustPitch));
// 				if( abs(AmountToAdjustPitch) > AutoPitchStopAdjustingValue )
// 				{
// 					aLookup += (AmountToAdjustPitch < 0 ? PitchSpeed : -PitchSpeed) * (bInvertMouse ? -1 : 1);
// 				}
// 			}
// 		}
// 		*/
// 	}
// 	// auto-level pitch when walking around or landing
// 	else if (`TimeSince(LastTurnTime) > AutoPitchCenterDelay 
// 		&& NP.Physics == PHYS_Walking 
// 		&& (`TimeSince(NP.LastLandingTime) < 2.f || VSize(Pawn.Velocity) > 10.0f)
// 		)
// 	{
// 		CurrentPitch = float(NormalizeRotAxis(Rotation.Pitch));
// 		AmountToAdjustPitch = FInterpTo( CurrentPitch, MyNP.bIsDashing ? 1024 : 0, DeltaTime, AutoPitchCenterSpeed ) - CurrentPitch;
// 		if( abs(AmountToAdjustPitch) > AutoPitchStopAdjustingValue )
// 		{
// 			aLookup += (AmountToAdjustPitch < 0 ? AutoPitchCenterSpeed : -AutoPitchCenterSpeed) * (bInvertMouse ? -1 : 1);
// 		}
// 	}
}

final function ZeroAllStickInput()
{
	aBaseX = 0.0f;
	aBaseY = 0.0f;
	aBaseZ = 0.0f;
	aMouseX = 0.0f;
	aMouseY = 0.0f;
	aForward = 0.0f;
	aTurn = 0.0f;
	aStrafe = 0.0f;
	aUp = 0.0f;
	aLookUp = 0.0f;
}

/** Return if no detected input this tick, false otherwise */
final simulated function bool IsInputIdle()
{
	if ( (aBaseX != 0)
		|| (aBaseY != 0)
		|| (aBaseZ != 0)
		|| (aMouseX != 0)
		|| (aMouseY != 0)
		|| (aForward != 0)
		|| (aTurn != 0)
		|| (aStrafe != 0)
		|| (aUp != 0)
		|| (aLookUp != 0)
		)
	{
		return FALSE;
	}

	return TRUE;
}


final function ClearInputBuffer( optional EGameButtons Button = GB_Max )
{
	local int Idx;
	if( Button == GB_Max )
	{
		for( Idx = 0; Idx < InputBuffer.Length; Idx++ )
		{
			InputBuffer[Idx].Time = -1.f;
		}
	}
	else
	{
		if( Idx < InputBuffer.Length )
		{
			InputBuffer[Button].Time = -1.f;
		}		
	}
}

final function float PollInputBuffer( EGameButtons Button, optional float MinTime, optional bool bClearInput )
{
	local float Time;

	if( Button != GB_Max && Button < InputBuffer.Length && InputBuffer[Button].Time >= 0.f )
	{
		Time = `TimeSince(InputBuffer[Button].Time);
		if( MinTime <= 0.f || Time <= MinTime )
		{
			if( bClearInput )
			{
				ClearInputBuffer( Button );
			}
			return Time;
		}
	}
	return -1.f;
}

final function CatchInputBuffer( EGameButtons Button )
{
	if( IsInputFiltered(Button) || Button == GB_Max )
	{
		return;
	}

	if( Button >= InputBuffer.Length )
	{
		InputBuffer.Length = Button + 1;
		InputBuffer[Button].Button = Button;
	}
	InputBuffer[Button].Time = WorldInfo.TimeSeconds;
}

final function FilterInputBuffer( EGameButtons Button, bool bAllowInput, optional bool bClearInput )
{
	if( Button == GB_Max )
	{
		InputBufferFilter = bAllowInput ? 0 : MaxInt;
	}
	else
	{
		InputBufferFilter = bAllowInput ? (InputBufferFilter & ~(1<<Button)) : (InputBufferFilter | (1<<Button));
	}

	if( bClearInput )
	{
		ClearInputBuffer( Button );
	}
}

final function bool IsInputFiltered( EGameButtons Button )
{
	return ((InputBufferFilter & (1<<Button)) != 0);
}


/**
 * Pass TRUE to start forced pitch centering, FALSE to stop it.	 Centering will
 * occur until it is complete and then stop -- note it doesn't lock pitch to 0.
 * GoalPitch is the pitch we'll move toward.
 * If bCancelOnUserInput is TRUE, any attempts by the player to change pitch will cancel the pitch centering (to avoid fighting).
 */
simulated final function ForcePitchCentering(bool bCenter, optional bool bCancelOnUserInput, optional float GoalPitch, optional float InterpSpeed)
{
// 	bForcePitchCentering = bCenter;
// 	bForcePitchCenteringIsInterruptable = bCancelOnUserInput;
// 	ForcedPitchCenteringHorizonOffset = GoalPitch;
// 	ForcePitchCenteringSpeed = (InterpSpeed == 0.f) ? default.ForcePitchCenteringSpeed : InterpSpeed;
}


defaultproperties
{
	SensitivityMultiplier=1.0f
//	TurningAccelerationMultiplier=1.0f

}
