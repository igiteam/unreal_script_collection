/**
 *
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMConsolePlayerController extends TMPlayerController
	config(Game)
	native;

/** Whether TargetAdhesion is enabled or not **/
var() config bool bTargetAdhesionEnabled;

var config protected bool bDebugTargetAdhesion;

// @todo amitt update this to work with version 2 of the controller UI mapping system
struct native ProfileSettingToUE3BindingDatum
{
	var name ProfileSettingName;
	var name UE3BindingName;

};

var array<ProfileSettingToUE3BindingDatum> ProfileSettingToUE3BindingMapping360;
var array<ProfileSettingToUE3BindingDatum> ProfileSettingToUE3BindingMappingPS3;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


/**
 * This will find the best AdhesionFriction target based on the params passed in.
 **/
native function Pawn GetTargetAdhesionFrictionTarget( FLOAT MaxDistance, const out vector CamLoc, const out Rotator CamRot );

/**
 * We need to override this function so we can do our adhesion code.
 *
 * Would be nice to have have a function or something be able to be inserted between the set up
 * and processing.
 **/
function UpdateRotation( float DeltaTime )
{
	local Rotator	DeltaRot, NewRotation, ViewRotation;

	ViewRotation	= Rotation;
	if (Pawn!=none)
	{
		Pawn.SetDesiredRotation(ViewRotation); //save old rotation
	}

	// Calculate Delta to be applied on ViewRotation
	DeltaRot.Yaw	= PlayerInput.aTurn;
	DeltaRot.Pitch	= PlayerInput.aLookUp;


	// NOTE:  we probably only want to ApplyTargetAdhesion when we are moving as it hides the Adhesion a lot better
	if( ( bTargetAdhesionEnabled )
		&& ( Pawn != none )
		&& ( PlayerInput.aForward != 0 )
		)
	{
		TMConsolePlayerInput(PlayerInput).ApplyTargetAdhesion( DeltaTime, TMWeapon(Pawn.Weapon), DeltaRot.Yaw, DeltaRot.Pitch );
	}


	ProcessViewRotation( DeltaTime, ViewRotation, DeltaRot );

	SetRotation( ViewRotation );

	ViewShake( DeltaTime );

	NewRotation = ViewRotation;
	NewRotation.Roll = Rotation.Roll;

	if( Pawn != None )
	{
		Pawn.FaceRotation(NewRotation, DeltaTime);
	}
}

function bool AimingHelp(bool bInstantHit)
{
	// bUsingGamepad is updated every time we do an input based on what was used to make that input
	//return PlayerInput.bUsingGamepad;
	// @fixme this needs to eventually use the above line and also have some client to server communication where
	// the client tells the server if they have ever used a keyboard/mouse.  The idea being:  once they have "cheated" then
	// they never will get aiming help again.  Doing it this way reduces the amount of server messages we need to have
	return true;
}

/**
* @returns the distance from the collision box of the target to accept aiming help (for instant hit shots)
*/
function float AimHelpModifier()
{
	return (FOVAngle < DefaultFOV - 8) ? 0.75 : 1.0;
}

simulated function bool PerformedUseAction()
{
	if ( Super.PerformedUseAction() )
	{
		return true;
	}
	else if ( (Role == ROLE_Authority) && !bJustFoundVehicle )
	{
		// console smart use - bring out hoverboard if no other use possible
		ClientSmartUse();
		return true;
	}
	return false;
}

unreliable client function ClientSmartUse()
{
	ToggleTranslocator();
}

reliable client function ClientRestart(Pawn NewPawn)
{
	Super.ClientRestart(NewPawn);

	// we never want the tilt thing on when using TMPawns

	if (TMPawn(NewPawn) != None)
	{
		SetOnlyUseControllerTiltInput(false);
		SetUseTiltForwardAndBack(true);
		SetControllerTiltActive(false);
	}
}

exec function PrevWeapon()
{
	if (Pawn == None || Vehicle(Pawn) != None)
	{
		if ( TMVehicleBase(Pawn) != None )
		{
			TMVehicleBase(Pawn).AdjacentSeat(-1, self);
		}
	}
	else if (!Pawn.IsInState('FeigningDeath'))
	{
		Super.PrevWeapon();
	}
}

exec function NextWeapon()
{
	if (Pawn == None || Vehicle(Pawn) != None)
	{
		if ( TMVehicleBase(Pawn) != None )
		{
			TMVehicleBase(Pawn).AdjacentSeat(1, self);
		}
	}
	else if (!Pawn.IsInState('FeigningDeath'))
	{
		Super.NextWeapon();
	}
}

function ResetPlayerMovementInput()
{
	local TMConsolePlayerInput ConsoleInput;

	Super.ResetPlayerMovementInput();

	ConsoleInput = TMConsolePlayerInput(PlayerInput);
	if (ConsoleInput != None)
	{
		ConsoleInput.ForcedDoubleClick = DCLICK_None;
	}
}

/** Gathers player settings from the client's profile. */
function LoadSettingsFromProfile(bool bLoadCharacter)
{
	local int OutIntValue;
	local TMProfileSettings Profile;
	local TMConsolePlayerInput ConsolePlayerInput;
	local int BindingIdx;

	// If we are NOT epic internal, then do not set any settings.
	if(IsEpicInternal()==false)
	{
		;
		return;
	}

	Profile = TMProfileSettings(OnlinePlayerData.ProfileProvider.Profile);
	ConsolePlayerInput = TMConsolePlayerInput(PlayerInput);

	// AutoCenterPitch
	if(Profile.GetProfileSettingValueIdByName('AutoCenterPitch', OutIntValue))
	{
		ConsolePlayerInput.bAutoCenterPitch = (OutIntValue == TMPID_VALUE_YES);
	}

	// AutoCenterVehiclePitch
	if(Profile.GetProfileSettingValueIdByName('AutoCenterVehiclePitch', OutIntValue))
	{
		ConsolePlayerInput.bAutoCenterVehiclePitch = (OutIntValue == TMPID_VALUE_YES);
	}

	// TiltSensing
	if(Profile.GetProfileSettingValueIdByName('TiltSensing', OutIntValue))
	{
		SetControllerTiltDesiredIfAvailable(OutIntValue == TMPID_VALUE_YES);
	}


	// ControllerSensitivityMultiplier
	if(Profile.GetProfileSettingValueIntByName('ControllerSensitivityMultiplier', OutIntValue))
	{
		ConsolePlayerInput.SensitivityMultiplier = float(OutIntValue) / 10.0f;
	}

	// TurningAccelerationFactor
	if(Profile.GetProfileSettingValueIntByName('TurningAccelerationFactor', OutIntValue))
	{
		// 1 is .25  ....
		// 2 is .5  ????
		// 4 is our default value for speed so we want it to be a 1.0 multiplier
		// 8 is 2.0
		// 10 is 2.5!!!
		//`log( "OutIntValue: " $ OutIntValue );
		ConsolePlayerInput.TurningAccelerationMultiplier = float(OutIntValue) / 5.333f;    // .75
		//`log( "ConsolePlayerInput.TurningAccelerationMultiplier: " $ ConsolePlayerInput.TurningAccelerationMultiplier );
	}

	if ( class'WorldInfo'.static.IsConsoleBuild(CONSOLE_PS3) )
	{
		// @todo amitt update this to work with version 2 of the controller UI mapping system
		for( BindingIdx = ProfileSettingToUE3BindingMappingPS3.length-1; BindingIdx >= 0; BindingIdx-- )
		{
			//`log( "RetrieveSettingsFromProfile: " $ ProfileSettingToUE3BindingMappingPS3[BindingIdx].ProfileSettingName );

			if( Profile.GetProfileSettingValueIdByName( ProfileSettingToUE3BindingMappingPS3[BindingIdx].ProfileSettingName, OutIntValue) )
			{
				//`log( "  RetrieveSettingsFromProfile: FOUND: " $ ProfileSettingToUE3BindingMappingPS3[BindingIdx].ProfileSettingName );
				UpdateControllerSettings_Worker( ProfileSettingToUE3BindingMappingPS3[BindingIdx].UE3BindingName, class'TMProfileSettings'.default.DigitalButtonActionsToCommandMapping[OutIntValue] );
			}
		}
	}
	// default to 360
	else
	{
		// @todo amitt update this to work with version 2 of the controller UI mapping system
		for( BindingIdx = ProfileSettingToUE3BindingMapping360.length-1; BindingIdx >= 0; BindingIdx-- )
		{
			//`log( "RetrieveSettingsFromProfile: " $ ProfileSettingToUE3BindingMapping360[BindingIdx].ProfileSettingName );

			if( Profile.GetProfileSettingValueIdByName( ProfileSettingToUE3BindingMapping360[BindingIdx].ProfileSettingName, OutIntValue) )
			{
				//`log( "  RetrieveSettingsFromProfile: FOUND: " $ ProfileSettingToUE3BindingMapping360[BindingIdx].ProfileSettingName );
				UpdateControllerSettings_Worker( ProfileSettingToUE3BindingMapping360[BindingIdx].UE3BindingName, class'TMProfileSettings'.default.DigitalButtonActionsToCommandMapping[OutIntValue] );
			}
		}
	}



	// Handle stick mappings.
	if(Profile.GetProfileSettingValueId(class'TMProfileSettings'.const.TMPID_GamepadBinding_AnalogStickPreset, OutIntValue))
	{
		;

		switch(EAnalogStickActions(OutIntValue))
		{
		case ESA_Legacy:

			UpdateControllerSettings_Worker( 'GBA_TurnLeft_Gamepad', "Axis aTurn Speed=1.0 DeadZone=0.2" );
			UpdateControllerSettings_Worker( 'GBA_MoveForward_Gamepad', "Axis aBaseY Speed=1.0 DeadZone=0.2" );
			UpdateControllerSettings_Worker( 'GBA_StrafeLeft_Gamepad', "Axis aStrafe Speed=1.0 DeadZone=0.2" );
			UpdateControllerSettings_Worker( 'GBA_Look_Gamepad', "Axis aLookup Speed=0.65 DeadZone=0.2" );

			UpdateControllerSettings_Worker( 'XboxTypeS_LeftX', "GBA_TurnLeft_Gamepad" );
			UpdateControllerSettings_Worker( 'XboxTypeS_LeftY', "GBA_MoveForward_Gamepad" );
			UpdateControllerSettings_Worker( 'XboxTypeS_RightX', "GBA_StrafeLeft_Gamepad" );
			UpdateControllerSettings_Worker( 'XboxTypeS_RightY', "GBA_Look_Gamepad" );
			break;
		case ESA_SouthPaw:
			UpdateControllerSettings_Worker( 'GBA_TurnLeft_Gamepad', "Axis aTurn Speed=1.0 DeadZone=0.2" );
			UpdateControllerSettings_Worker( 'GBA_Look_Gamepad', "Axis aLookup Speed=-0.65 DeadZone=0.2" );
			UpdateControllerSettings_Worker( 'GBA_StrafeLeft_Gamepad', "Axis aStrafe Speed=1.0 DeadZone=0.2" );
			UpdateControllerSettings_Worker( 'GBA_MoveForward_Gamepad', "Axis aBaseY Speed=-1.0 DeadZone=0.2" );

			UpdateControllerSettings_Worker( 'XboxTypeS_LeftX', "GBA_TurnLeft_Gamepad" );
			UpdateControllerSettings_Worker( 'XboxTypeS_LeftY', "GBA_Look_Gamepad" );
			UpdateControllerSettings_Worker( 'XboxTypeS_RightX', "GBA_StrafeLeft_Gamepad" );
			UpdateControllerSettings_Worker( 'XboxTypeS_RightY', "GBA_MoveForward_Gamepad" );
			break;
		case ESA_LegacySouthPaw:
			UpdateControllerSettings_Worker( 'GBA_StrafeLeft_Gamepad', "Axis aStrafe Speed=1.0 DeadZone=0.2" );
			UpdateControllerSettings_Worker( 'GBA_Look_Gamepad', "Axis aLookup Speed=-0.65 DeadZone=0.2" );
			UpdateControllerSettings_Worker( 'GBA_TurnLeft_Gamepad', "Axis aTurn Speed=1.0 DeadZone=0.2" );
			UpdateControllerSettings_Worker( 'GBA_MoveForward_Gamepad', "Axis aBaseY Speed=-1.0 DeadZone=0.2" );

			UpdateControllerSettings_Worker( 'XboxTypeS_LeftX', "GBA_StrafeLeft_Gamepad" );
			UpdateControllerSettings_Worker( 'XboxTypeS_LeftY', "GBA_Look_Gamepad" );
			UpdateControllerSettings_Worker( 'XboxTypeS_RightX', "GBA_TurnLeft_Gamepad" );
			UpdateControllerSettings_Worker( 'XboxTypeS_RightY', "GBA_MoveForward_Gamepad" );
			break;
		case ESA_Normal: default:
			UpdateControllerSettings_Worker( 'GBA_StrafeLeft_Gamepad', "Axis aStrafe Speed=1.0 DeadZone=0.2" );
			UpdateControllerSettings_Worker( 'GBA_MoveForward_Gamepad', "Axis aBaseY Speed=1.0 DeadZone=0.2" );
			UpdateControllerSettings_Worker( 'GBA_TurnLeft_Gamepad', "Axis aTurn Speed=1.0 DeadZone=0.2" );
			UpdateControllerSettings_Worker( 'GBA_Look_Gamepad', "Axis aLookup Speed=0.65 DeadZone=0.2" );

			UpdateControllerSettings_Worker( 'XboxTypeS_LeftX', "GBA_StrafeLeft_Gamepad" ); // Axis aStrafe Speed=1.0 DeadZone=0.2
			UpdateControllerSettings_Worker( 'XboxTypeS_LeftY', "GBA_MoveForward_Gamepad" ); //  Axis aBaseY Speed=1.0 DeadZone=0.2
			UpdateControllerSettings_Worker( 'XboxTypeS_RightX', "GBA_TurnLeft_Gamepad" ); // Axis aTurn Speed=1.0 DeadZone=0.2
			UpdateControllerSettings_Worker( 'XboxTypeS_RightY', "GBA_Look_Gamepad" ); //  Axis aLookup Speed=0.65 DeadZone=0.2
			break;
		}
	}

	// make sure to call the super version after, since it updates the current pawn as well.
	Super.LoadSettingsFromProfile(bLoadCharacter);

	// Bind menu button
	UpdateControllerSettings_Worker( 'XboxTypeS_Start', class'TMProfileSettings'.default.DigitalButtonActionsToCommandMapping[DBA_ShowMenu] );
}


private function UpdateControllerSettings_Worker( name TheName, string TheCommand )
{
	PlayerInput.SetBind(TheName, TheCommand);
}


/** @returns whether the controller is active **/
native simulated function bool IsControllerTiltActive() const;

native simulated function SetControllerTiltDesiredIfAvailable( bool bActive );

native simulated function SetControllerTiltActive( bool bActive );

native simulated function SetOnlyUseControllerTiltInput( bool bActive );

native simulated function SetUseTiltForwardAndBack( bool bActive );

// Player movement.
// Player Standing, walking, running, falling.
state PlayerWalking
{
	ignores SeePlayer, HearNoise, Bump;

	/**
	  * needs to support switching from wall dodge attempt to double jump with air control
	  */
	function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
	{
		if ( (DoubleClickMove == DCLICK_Active) && (Pawn.Physics == PHYS_Falling) )
			DoubleClickDir = DCLICK_Active;
		else if ( (DoubleClickMove != DCLICK_None) && (DoubleClickMove < DCLICK_Active) )
		{
			if ( TMPawn(Pawn).Dodge(DoubleClickMove) )
			{
				DoubleClickDir = DCLICK_Active;
			}
			else if ( Pawn.Physics == PHYS_Falling )
			{
				// allow double jump while air controlling
				bPressedJump = true;
			}
		}

		Super.ProcessMove(DeltaTime,NewAccel,DoubleClickMove,DeltaRot);
	}
}



