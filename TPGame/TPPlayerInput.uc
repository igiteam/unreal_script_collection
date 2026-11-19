class TPPlayerInput
    extends PlayerInput
    within TPPlayerController;



const AngleConvert = 0.0000958738;	// 2*PI/65536

var config float LookRightAimAssist;
var float ParachuteFallSpeed;


struct LookCurvePoint
{
	var float RawPct;
	var float ActualPct;
};

var config array<LookCurvePoint> TurnCurve;
var config array<LookCurvePoint> LookCurve;



//Previous frame's raw values
var		transient	float	PrevRawJoyUp;
var		transient	float	PrevRawJoyRight;
var		transient	float	PrevRawJoyLookRight;
var		transient	float	PrevRawJoyLookUp;

//dummy values used to capture aTurn and aLookup for printing on the screen later in the frame.
var		float screen_aTurn;
var		float screen_aLookUp;


struct AimAssistData
{
    var float ConstantDegreesAssist;
    var float ConstantRampUpRate;
    var float ConstantRampDownRate;

    var float AngleDegreesMultiplier;
    var float AngleRampUpRate;
    var float AngleRampDownRate;

    var float YawPitchMaxScaleDown;
    var float YawPitchRampUpRate;
    var float YawPitchRampDownRate;

    var float ShotAssistAngle;

    var float StrafeVelocityScaleStart;

    var float DistanceScaleStart;
    var float DistanceScaleEnd;

    var	float LineCheckWidth;
    var	float MaxTargetDist;
    var bool  bShotAssist;
};


var config  AimAssistData AimAssistParams;

var Actor	lastAimAssistTarget;
var vector	lastAimAssistTargetLoc;
var float	lastAimAssistTime;
var float   firstAimAssistTime;


struct InputSpringData
{
	var() bool  bEnabled;
	var() float inputAccel;
	var() float inputDecel;
	var() float handsOffDecel;
	var   float curVal;
	var   float curDelta;
	var   float maxDelta;
};

var config InputSpringData TurnSpringData;
var config InputSpringData LookSpringData;
var const float FRAMESPERSEC;
var config float PS3JumpThreshold;




//UTGAME friction params
/** Whether TargetFriction is enabled or not **/
var() config bool bTargetFrictionEnabled;


/** Whether or not we actually applied friction.  This is used to make certain we don't then accelerate the view **/
var protected bool bAppliedTargetFriction;


/** Last friction target */
var private Pawn LastFrictionTarget;

/** Last friction target acquire time */
var private float LastFrictionTargetTime;


var config float HumanShieldTurnLookMod;

var config bool bSuperAdhesionEnabled;
var bool bSuperAdhesionMode;
var Actor LastSuperAdhesionTarget;

//Exponent for the input curve.  Higher number means bigger deadzone.
var config float CurvePow;

var float	TurnLookHandsOnTime;
var config float HandsOnLookScaleKickInTime;
var config float HandsOnInputThreshold;
var config float HandsOnLookScale;
var config float HandsOnLookScaleRampSpeed;

// Controller Look Sensitivity
// Low Look Sensitivity
var config string            LowLookSensitivity_LeftX;
var config string            LowLookSensitivity_LeftY;
var config string            LowLookSensitivity_RightX;
var config string            LowLookSensitivity_RightY;

// Medium Look Sensitivity
var config string            MedLookSensitivity_LeftX;
var config string            MedLookSensitivity_LeftY;
var config string            MedLookSensitivity_RightX;
var config string            MedLookSensitivity_RightY;

// High Look Sensitivity
var config string            HighLookSensitivity_LeftX;
var config string            HighLookSensitivity_LeftY;
var config string            HighLookSensitivity_RightX;
var config string            HighLookSensitivity_RightY;

// Constants to speed up the FOV correction factors.
var Float LastFOV;
var Float LastFOVRatio;

delegate bool OnInputKey(int ControllerID, name Key, EInputEvent Event, float AmountDepressed);

exec function Jump()
{
    if(bDisableJumpButton)
        return;
    
	if( IsMoveInputIgnored() ) //for during bluff, etc.
		return;

    if (bHittingWall && Obstacle == OB_Vaultable)
    {
        bHitWallPressedJump = true;
        TPPawn(Pawn).StopMovement ( );
    }
    else if (TPPawn(Pawn).Obstacle == OB_Hangable
        && TPPawn(Pawn).Shimmy == SH_None)
    {
            PlayerStopHangingDrop ( );
    }
    else if (Pawn.bIsCrouched)
    {
        PlayerPawn(Pawn).ChangePosture();
    }
    else if(!bCinematicMode && !IsMoveInputIgnored())
        Super.Jump();
}

exec function ThrowWeapon()
{
	// Added check for not throwing grenades
    if (Pawn.Weapon.IsInState('WeaponEquipping') || Pawn.Weapon.IsInState('WeaponPuttingDown') || Pawn.Weapon.IsA('Grenade_Persistent'))
        return;

    TPPawn(Pawn).ThrowActiveWeapon ( );
}

exec function Use ( )
{
	//local float DistanceToPickup;
	local Alarm A;
	local PlayerPawn lPlayerPawn;
	local TPPawn lTPPawn;
    local TPPlayerMovementVolume MovementVolume;
    local bool wasADS;
    
    if (TPPawn(Pawn).MovementVolumes.Length != 0)
        MovementVolume = TPPawn(Pawn).MovementVolumes[TPPawn(Pawn).MovementVolumes.Length-1];
	
	lPlayerPawn = PlayerPawn(Pawn);
	
	if (lPlayerPawn != None)
	{
		if (lPlayerPawn.IsInState('Dying'))
		{
			RestartLevel();
			return;
		}
	
		if(lPlayerPawn.PendingAlarm !=	none)
		{
			if(lPlayerPawn.PendingAlarm.bUsableAlarm)
			{
				if(lPlayerPawn.PendingAlarm.bOneWayAlarm && !lPlayerPawn.PendingAlarm.bAlarmOn)
				{
					foreach	AllActors(class'Alarm',	A)
					{
						A.bAlarmOn = true;
					}  
				}
				else if(!lPlayerPawn.PendingAlarm.bOneWayAlarm)
				{
					foreach	AllActors(class'Alarm',	A)
					{
						A.bAlarmOn = !A.bAlarmOn;
					}				   
				}
				if(lPlayerPawn.PendingAlarm.bAlarmOn)
				{
					Pawn.TriggerEventClass(class'SeqEvent_UseAlarm', none, 0);	   
				}
				else
				{
					Pawn.TriggerEventClass(class'SeqEvent_UseAlarm', none, 1);	   
				}
			}
		}
	}

	lTPPawn = TPPawn(Pawn);
	
    //@optimization get rid of all excessive casts
	if (lTPPawn != None && !lTPPawn.bIsCrouched && lTPPawn.IsInLadderVolume && HighlightedInteractable.InteractTrigger == None)
    {
        if ((lTPPawn.LadderAction == LA_IdleR ||
            lTPPawn.LadderAction == LA_IdleL) && lTPPawn.Ladder.bAllowSlide && WorldInfo.NetMode == NM_Standalone)
        {
            lTPPawn.LastStandingLocation.Z = -9999.9f;
            lTPPawn.LadderAction = LA_Slide;
			lTPPawn.ServerSetLadderAction(LA_Slide);
			lTPPawn.ServerSetLocationAndRotation(lTPPawn.Location, lTPPawn.Ladder.WallDir);
        }
        else if (lTPPawn.LadderAction == LA_None && Pawn.Physics == PHYS_Walking && !lPlayerPawn.ToStandInProgress())
        {
            lTPPawn.Ladder.Enter(lTPPawn);

            if (lTPPawn.LadderAction == LA_Transition)
            {
				wasADS = GetWasAimingDownSight();
                DisableAimDownSight();
				SetWasAimingDownSight( wasADS );

                lTPPawn.ClimbLadder(lTPPawn.Ladder);
            }

            return;
        }
    }
    else if (CurrentPipeVolume != None && Outer.IsInState('PlayerWalking'))
    {
        Outer.bAllowUpdateRotation = CurrentPipeVolume.bCameraCanRotate;
        CurrentPipeVolume.SnapToPipe(lTPPawn);
        Outer.GoToState('PlayerPiping');
    }
    else if (TPPawn(Pawn).Obstacle == OB_Hangable && TPPawn(Pawn).Shimmy == SH_None)
    {
        if (MovementVolume == None || !MovementVolume.ShimmyOptions.bCannotPullUp)
            PlayerStopHangingClimb ( ); 
    }
    else
    {
        PlayerController(Pawn.Controller).Use ( );
    }
}

exec function TomPetty()
{
	local vector DecentVel;
	local class<ParachuteMesh_Persistent> ParachuteClass;

	if (!IsInState('PlayerParachuting') && TPPawn(Pawn).MyParachute == none)
	{
		DecentVel.Z = ParachuteFallSpeed;
		ParachuteClass = class<ParachuteMesh_Persistent>(FindObject("TPGameContent.ParachuteMesh",class'class'));
		if (ParachuteClass != None)
		{
			TPPawn(Pawn).MyParachute = spawn(ParachuteClass,,,Pawn.Location,Pawn.Rotation);
			ParachuteMesh_Persistent(TPPawn(Pawn).MyParachute).Paratrooper = Pawn;
			ParachuteMesh_Persistent(TPPawn(Pawn).MyParachute).DecentVelocity = DecentVel;
			TPPawn(Pawn).MyParachute.SetHardAttach(true);
			ParachuteMesh_Persistent(TPPawn(Pawn).MyParachute).Paratrooper.SetBase(TPPawn(Pawn).MyParachute,,ParachuteMesh_Persistent(TPPawn(Pawn).MyParachute).SkeletalMeshComponent,'Parachute');
			PlayerController(Pawn.Controller).GotoState('PlayerParachuting');
		}
	}
}

exec function TurnOn()
{
    local MP50_Persistent Mp50;

	if (WorldInfo.NetMode == NM_Standalone)
	{
		if (Pawn.Weapon != None && Pawn.Controller.IsInState('PlayerWalking') && !bCinematicMode && Pawn.Physics != PHYS_None)
		{
			if (Pawn.Weapon.IsA('MP50_Persistent'))
			{
				Mp50 = MP50_Persistent(Pawn.Weapon);
				Mp50.ToggleFlashlight(!Mp50.bFlashlightIsOn);

				TPPlayerController(Pawn.Controller).TurnOffGogglesIfEnabled();
			}
			else if (Pawn.Weapon.IsA('G47SniperVampir'))
			{
				TPPlayerController(Pawn.Controller).ToggleGoggles();
			}
		}
	}
}

// User has just started pressing the Show Scoreboard Button ( cur. <Back> )
exec function OnScoreboardPress()
{
	// If in multiplayer, with a valid hud (not dedicated server)
	if (WorldInfo.NetMode != NM_Standalone && myHud != none)
	{
		myHUD.bShowScores = !myHUD.bShowScores;
	}
}

exec function OnScoreboardRelease()
{
	// Scoreboard is currently toggled, not held.  Put !myHUD.bShowScores code here to change this behavior to "Hold to show scores" 
	if (WorldInfo.NetMode != NM_Standalone && myHud != none)
	{
		myHUD.bShowScores = !myHUD.bShowScores;
	}
}

event PlayerInput( float DeltaTime )
{
//`log( self @ "DeltaTime=" @ DeltaTime );
	local Float FOV, DefaultFOV, a, b, perc;
	local TPPlayerController TPController;

	if (Pawn != none && Pawn.Weapon != none && TPWeapon(Pawn.Weapon).IsAimDownSight() &&
        TPWeapon(Pawn.Weapon).bADSTurnLookModEnabled)
	{
		TPController = TPPlayerController(Pawn.Controller);
		FOV = TPController.DesiredFOV;
		DefaultFOV = TPController.DefaultFOV;

		// Scale the inputs when we zoom in so that the controller moves at a predictable
		// rate regardless of the field-of-view
		if ( FOV < DefaultFOV )	// If we are zoomed
		{
			// If this is the same value we used last time, then there's no need to recalculate the value
			if (abs(FOV - LastFOV) < 1.0f)
			{
				Perc = LastFOVRatio;
			}
			else
			{
				a = sin(FOV*0.01745);
				b = sin(DefaultFOV*0.01745);
				Perc = a / b;
				LastFOVRatio = Perc;
				LastFOV = FOV;
			}
			AdjustMouseSensitivity(Perc);
		}
		else
			AdjustMouseSensitivity(1.0f);
	}
	else
		AdjustMouseSensitivity(1.0f);



	PrevRawJoyUp = RawJoyUp;
	PrevRawJoyRight = RawJoyRight;
	PrevRawJoyLookRight = RawJoyLookRight;
	PrevRawJoyLookUp = RawJoyLookUp;

	super.PlayerInput(DeltaTime);
}


function ApplyInputCurve(out float rawInput, array<LookCurvePoint> Curve)
{
	local int i;
	local float absVal;
	local float mRawInput;

    if (rawInput != 0.0f)
	{
		mRawInput = rawInput;
		absVal = abs(rawInput);
		
		if (absVal < Curve[0].RawPct)
		{
			mRawInput = 0.0f;
		}
		else
		{
			for (i = 1; i < Curve.Length; i++) //this assumes that [0] will never get picked (it's rawPct is 0)
			{
				if( absVal <= Curve[i].RawPct ) 
				{
					//Interpolate between this and previous curve point
					mRawInput = Curve[i].ActualPct + ((Curve[i].RawPct - absVal) * (Curve[i].ActualPct - Curve[i-1].ActualPct)) / (Curve[i].RawPct - Curve[i-1].RawPct);
					if( rawInput < 0.0 )
						mRawInput = -mRawInput;
						
					break;
				}
			}
		}
		

		//`log("rawInput " $ rawInput $ " -> "  $ mRawInput); 
		rawInput = mRawInput;
	}

}

function PreProcessInput(float DeltaTime)
{
	local PlayerPawn myPawn;

	//Update the handson time
	if( (RawJoyLookRight >= HandsOnInputThreshold && PrevRawJoyLookRight >= HandsOnInputThreshold) ||
		(RawJoyLookRight <= -HandsOnInputThreshold && PrevRawJoyLookRight <= -HandsOnInputThreshold) )
	{
		TurnLookHandsOnTime += DeltaTime;
	}
	else
	{
		TurnLookHandsOnTime = 0.0;
	}


	//These turn curves make the controls not smooth
 	//ApplyInputCurve( aTurn, TurnCurve );
 	//ApplyInputCurve( aLookUp, LookCurve );


	//Just use a y=x^CurvePow curve instead.  Higher exponent means bigger dead zone.  
	
	//Have to do these if-check shenanigans because Xbox uses an optimized appPow that is invalid when the base number is negative.
	if( aTurn < 0.0 )
	{
		//aTurn = Pow( abs(aTurn), CurvePow );
		aTurn = abs(aTurn) **  CurvePow ;
		aTurn = aTurn * -1;
	}
	else
	{
		//aTurn = Pow( aTurn, CurvePow );
		aTurn = aTurn ** CurvePow;
	}

	if( aLookUp < 0.0 )
	{
		//aLookUp = Pow( abs(aLookUp), CurvePow );
		aLookUp = abs(aLookUp) ** CurvePow;
		aLookUp = aLookUp * -1;
	}
	else
	{
		//aLookUp = Pow( aLookUp, CurvePow );
		aLookUp = aLookUp ** CurvePow;
	}
//This no worky on xbox	
// 	aTurn =  (aTurn < 0.0 && CurvePow%2==0.0) ? -1 * Pow( aTurn, CurvePow) : Pow( aTurn, CurvePow);
// 	aLookUp =  (aLookUp < 0.0 && CurvePow%2==0.0) ? -1 * Pow( aLookUp, CurvePow) : Pow( aLookUp, CurvePow);

	

	if (Pawn != none && Pawn.Weapon != none && TPWeapon(Pawn.Weapon).IsAimDownSight() &&
        TPWeapon(Pawn.Weapon).bADSTurnLookModEnabled)
	{
		aTurn *= TPWeapon(Pawn.Weapon).AimDownSightTurnMod;
		aLookUp *= TPWeapon(Pawn.Weapon).AimDownSightLookMod;
	}


	myPawn = PlayerPawn(Pawn);
	if (myPawn != None)
	{
		if( myPawn.IsUsingHumanShield() )
		{
			aTurn *= HumanShieldTurnLookMod;
			aLookUp *= HumanShieldTurnLookMod;
		}
	}


	//UTGame target friction
	if( bTargetFrictionEnabled && WorldInfo.NetMode == NM_Standalone)
	{
		if( Pawn != None && TPWeapon(Pawn.Weapon) != none )
		{
			bAppliedTargetFriction = FALSE; // clear the friction flag (we do it here so applyViewAcceleration has a chance to use it from the time before)
			ApplyTargetFriction( DeltaTime, TPWeapon(Pawn.Weapon) );
		}
	}




	if (WorldInfo.IsPS3Build())
	{
		if (aPS3AccelY > PS3JumpThreshold)
		{
			//`log("Jumping aPS3AccelX="$aPS3AccelX@"aPS3AccelY="$aPS3AccelY@"aPS3AccelZ="$aPS3AccelZ@"aPS3Gyro="$aPS3Gyro);
			Jump();
		}
	}
}


//modify the player movement speed if they're carrying a weapon
function PostProcessInput(float DeltaTime)
{
	local float SpeedMod;
	if (Pawn != none && Pawn.Weapon != none)
	{
		SpeedMod = TPWeapon(Pawn.Weapon).PlayerSpeedMod;
		aBaseY *= SpeedMod;
		aStrafe *= SpeedMod;
		//`log("PlayerSpeedMod is"@TPWeapon(Pawn.Weapon).PlayerSpeedMod);
	}
	
	//Scale by handson time 
	if( Pawn != none && (Pawn.Weapon == none || TPWeapon(Pawn.Weapon).IsAimDownSight() == false) && TurnLookHandsOnTime > HandsOnLookScaleKickInTime )
	{
		if( aTurn > 0.0 )
		{
			aTurn += LookRightScale * FClamp((TurnLookHandsOnTime-HandsOnLookScaleKickInTime)*HandsOnLookScaleRampSpeed, 0.0, HandsOnLookScale);
			//aLookUp += LookUpScale * FClamp((TurnLookHandsOnTime-HandsOnLookScaleKickInTime)*HandsOnLookScaleRampSpeed, 0.0, HandsOnLookScale);
		}
		else
		{
			aTurn += -LookRightScale * FClamp((TurnLookHandsOnTime-HandsOnLookScaleKickInTime)*HandsOnLookScaleRampSpeed, 0.0, HandsOnLookScale);
			//aLookUp += -LookUpScale * FClamp((TurnLookHandsOnTime-HandsOnLookScaleKickInTime)*HandsOnLookScaleRampSpeed, 0.0, HandsOnLookScale);
		}
	}
	
	SpringDamp(deltaTime, aTurn, RawJoyLookRight, PrevRawJoyLookRight, TurnSpringData);
	SpringDamp(deltaTime, aLookup, RawJoyLookUp, PrevRawJoyLookUp, LookSpringData);
	
	screen_aTurn = aTurn;
	screen_aLookUp = aLookUp;
}


function SpringDamp( float deltaTime, out float endVal, float rawVal, float oldRawVal,
					out InputSpringData springData)
{
	local float delta;
	local float actualDeltaTime;
	local int numIter;
	local int i;
	local float	TimeScale;			// This is a magical constant multiple created in PlayerInput
									// in order to have a consistend input endVal, we need to de-deltatime scale it first.


	if (springData.bEnabled != true)
	{
		return;
	}
	TimeScale = 100.f*deltaTime;
	endVal = endVal / TimeScale;	// divide out the delta time effect

	actualDeltaTime = deltaTime;

	if (actualDeltaTime < FRAMESPERSEC)
	{
		actualDeltaTime = FRAMESPERSEC;
	}

	numIter = actualDeltaTime / FRAMESPERSEC;
	for (i=0; i < numIter; i++)
	{
		//only handsoff if both old and new inputs are 0
		//if (Abs(rawVal) == 0.0f)
		if (Abs(rawVal) == 0.0f && Abs(oldRawVal) == 0.0f)
		{
			springData.curVal *= springData.handsOffDecel;
			springData.curDelta = 0.0f;
		}
		else
		{
			delta = endVal - springData.curVal;
			springData.curDelta =	(delta * springData.inputAccel) +
									(springData.curDelta * springData.inputDecel);

			if (springData.curDelta > springData.maxDelta)
			{
				springData.curDelta = springData.maxDelta;
			}
			else if (springData.curDelta < -springData.maxDelta)
			{
				springData.curDelta = -springData.maxDelta;
			}

			springData.curVal += springData.curDelta;
		}

		endVal = springData.curVal;
	}
	endVal = endVal * TimeScale;	// factor back in the delta time effect
	
}

function Controller GetController(Pawn Target)
{
	if (Target == None)
		return None;
	if (Target.Controller != None)
		return Target.Controller;
	else if (Target.DrivenVehicle != None)
		return Target.DrivenVehicle.Controller;
	else
		return None;
}


function Actor GetPlayerTarget(out Vector HitLocation, out Vector TargetLocation, out Vector CamLoc, out Rotator CamRot)
{
// 	local vector					EndPt, HitNormal, LookAt;
	local Actor						hitActor;
// 	local vector					LineCheckExtent;
// 	local float						LineCheckWidth;
	local Pawn						HitPawn;
	local Controller				HitController;
    local TPAIController            HitTPAIController;

	// If we don't have a pawn or a controller, then there's no point in getting a target (happens during init)
	if (Pawn == None || Pawn.Controller == None)
		return None;
		
// 	GetPlayerViewPoint(CamLoc, CamRot);
// 	LookAt = Normal(Vector(CamRot));
// 
// 	EndPt = CamLoc + (LookAt * AimAssistParams.MaxTargetDist);
// 	LineCheckWidth = AimAssistParams.LineCheckWidth;
// 	LineCheckExtent.x = LineCheckWidth;
// 	LineCheckExtent.y = LineCheckWidth;
// 	LineCheckExtent.z = LineCheckWidth;
	
	//hitActor = Trace(HitLocation, HitNormal, EndPt, CamLoc, true,LineCheckExtent);
	hitActor = TPPlayerController(Pawn.Controller).GetCrosshairTarget();

	HitPawn	= Pawn(HitActor);
	if (HitPawn != none)
	{
        if (SVehicle(HitPawn) != None)
            return None;   // Don't aim assist for vehicles

		HitController = GetController(HitPawn);
		HitTPAIController = TPAIController(HitController);
		if (HitTPAIController == none || !HitTPAIController.IsFriendly(Pawn.Controller))
		{
            return HitActor;
        }
	}

    return None;
}













































































































































































exec function bool InvertMouse()
{
	bInvertMouse = !bInvertMouse;
	ProfileSettings.SetInvertMouseOption(bInvertMouse);
	WriteProfile(true);
	SaveConfig();
	return bInvertMouse;
}

exec function TurnSpringDamp(float inputAccel, float inputDecel, float handsOffDecel)
{
	;

	TurnSpringData.inputAccel = inputAccel;
	TurnSpringData.inputDecel = inputDecel;
	TurnSpringData.handsOffDecel = handsOffDecel;
}

exec function LookSpringDamp(float inputAccel, float inputDecel, float handsOffDecel)
{
	;

	LookSpringData.inputAccel = inputAccel;
	LookSpringData.inputDecel = inputDecel;
	LookSpringData.handsOffDecel = handsOffDecel;
}

exec function TurnScale(float scale)
{
	LookRightScale = scale;
}

exec function LookScale(float scale)
{
	LookUpScale = scale;
}

exec function SetCurvePow(float pow)
{
	CurvePow = pow;
}

exec function FrictionMinMax(float min, float max)
{
	TPWeapon(Pawn.Weapon).TargetFrictionMultiplierRange.X = min;
	TPWeapon(Pawn.Weapon).TargetFrictionMultiplierRange.Y = max;
}

exec function AdhesionMinMax(float min, float max)
{
	TPWeapon(Pawn.Weapon).TargetAdhesionScaleRange.X = min;
	TPWeapon(Pawn.Weapon).TargetAdhesionScaleRange.Y = max;
}

function NotifyNewLastHitPawn(Pawn theHitPawn)
{
	LastSuperAdhesionTarget = theHitPawn;
}


//ApplyTargetAdhesion, adapted from UTGame
/**
 * This will attempt to keep the player aiming at the target.  It will forcibly aim the player at the target.
 *
 * TODO:  move this to c++
 **/
function ApplyTargetAdhesion( float DeltaTime, TPWeapon W, out int out_YawRot, out int out_PitchRot )
{
	local Vector	RealTargetLoc, TargetLoc, CamToTarget, AimLoc, CamLoc, ClosestY, ClosestZ;
	local Vector	X, Y, Z;
	local Rotator	CamRot, DeltaRot;
	local float		DistToTarget, DistFromAimZ, DistFromAimY, AdhesionAmtY, AdhesionAmtZ, TargetRadius, TargetHeight, Pct;
	local int		AdjustY, AdjustZ;
	local Pawn	AdhesionTarget;

//TP
	local vector HitLocation, TargetLocation;
	local bool bAdhering;
	

	//`log("");

	if( W == None
		|| !W.bTargetAdhesionEnabled
		)
	{
		return;
	}

	// `log(self @ "target adhesion 2");



	//Clear the super sticky target if we are turning
	//if( aTurn != 0 || aLookUp != 0 )
	if( RawJoyLookRight != 0 || RawJoyLookUp != 0 )
	{
		LastSuperAdhesionTarget = None;
	}


	//No adhesion if we aren't moving, and no super adhesion target
	if( (aForward == 0 && aStrafe == 0) && LastSuperAdhesionTarget==None )
		return;

	


	// Setup some initial data
	GetPlayerViewPoint( CamLoc, CamRot );
	GetAxes( CamRot, X, Y, Z );

	// attempt to use the friction target if available
	AdhesionTarget = LastFrictionTarget;
	
	
	if (AdhesionTarget == None || TimeSince(LastFrictionTargetTime) > W.TargetAdhesionTimeMax)
	{
		// otherwise look for a new target
//TP	AdhesionTarget = GetTargetAdhesionFrictionTarget( W.TargetAdhesionDistanceMax, CamLoc, CamRot );
		AdhesionTarget = Pawn(GetPlayerTarget(HitLocation, TargetLocation, CamLoc, CamRot));

	}

	// Added to not be enabled in MP Games.  RBaker
	if (WorldInfo.NetMode == NM_Standalone)
		bSuperAdhesionMode = bSuperAdhesionEnabled && (LastSuperAdhesionTarget != None);
	else
		// Dont apply adhesion in MP Games.
		AdhesionTarget = none;



	// If still within adhesion time constraints, and the target is still alive
	if( AdhesionTarget != None )
	{

		//`log(self @ "target adhesion 3" @ AdhesionTarget);
	
		// Grab collision info from target
		AdhesionTarget.GetBoundingCylinder( TargetRadius, TargetHeight );
		// reduce the size a bit to allow adhesion to move the crosshair onto the character
		
//TP - made these params		
// 		TargetRadius *= 0.65f;
// 		TargetHeight *= 0.65f;
		TargetRadius *= W.TargetAdhesionCylinderRadiusScale;
		TargetHeight *= W.TargetAdhesionCylinderHeightScale;

 
 		
		RealTargetLoc = AdhesionTarget.Location + (W.TargetFrictionOffset >> CamRot);

		// Make sure the target has some velocity
		if( (W.TargetAdhesionTargetVelocityMin == 0.f || VSize(AdhesionTarget.Velocity) > W.TargetAdhesionTargetVelocityMin)
			&& (W.TargetAdhesionPlayerVelocityMin == 0.f || VSize(Pawn.Velocity) > W.TargetAdhesionPlayerVelocityMin)
			&& ((RealTargetLoc - CamLoc) DOT Vector(CamRot) > 0.f) )
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
			
			
			if( ( DistToTarget <= W.TargetAdhesionDistanceMax )
				//TP - try always adhering if aiming inside the cyl
				//&& (DistFromAimY > TargetRadius || DistFromAimZ > TargetHeight)
				&& (DistFromAimY < TargetRadius || DistFromAimZ < TargetHeight)
				&& LineOfSightTo( AdhesionTarget, CamLoc ) // find a way no do this line check
				)
			{
				// Lateral adhesion
				//TP - try always adhering if aiming inside the cyl
				//if(	DistFromAimY > TargetRadius )
				if(	DistFromAimY < TargetRadius )
				{
				
					Pct = 1.f - (DistFromAimY-TargetRadius)/W.TargetAdhesionAimDistY;
					if (Pct > 0.f)
					{
					
						// boost based on other gameplay things (distance or something)
						// boost slightly when targeting
						Pct = FMin(Pct, 0.8f);

						if( bSuperAdhesionMode )
							AdhesionAmtY = GetRangeValueByPct(W.TargetSuperAdhesionScaleRange, Pct);
						else
							AdhesionAmtY = GetRangeValueByPct(W.TargetAdhesionScaleRange, Pct);

						//`log( "AdhesionAmtY: " $ AdhesionAmtY );
						// Apply the adhesion
						AdjustY = DeltaRot.Yaw * (AdhesionAmtY * DeltaTime);
						
						out_YawRot += AdjustY;
						
						
						//tp
						bAdhering=true;
					}
				}

				// Vertical adhesion
				//TP - try always adhering if aiming inside the cyl
				//if( DistFromAimZ > TargetHeight )
				if( DistFromAimZ < TargetHeight )
				{
				
					Pct = 1.f - (DistFromAimZ-TargetHeight)/W.TargetAdhesionAimDistZ;
					if (Pct > 0.f)
					{
					
						// boost based on other gameplay things (distance or something)
						// boost slightly when targeting
						Pct = FMin(Pct, 0.8f);

						if( bSuperAdhesionMode )
							AdhesionAmtZ = GetRangeValueByPct(W.TargetSuperAdhesionScaleRange, Pct);
						else
							AdhesionAmtZ = GetRangeValueByPct(W.TargetAdhesionScaleRange, Pct);

						//`log( "AdhesionAmtZ: " $ AdhesionAmtZ );

						// Apply the adhesion
						AdjustZ = DeltaRot.Pitch * (AdhesionAmtZ * DeltaTime);
						out_PitchRot += AdjustZ;
						
						//tp
						bAdhering=true;
						
					}
				}
			}
		}
	}
	else
	{
		//No adhesion target.  Clear the LastSuperAdhesionTarget
		LastSuperAdhesionTarget = None;
	}


//TP			
		if (TPGameReplicationInfo(WorldInfo.GRI).DebugInfo.GetDebugFlag(TPD_SHOWSTICKY) )
		{
			if( AdhesionTarget != None )
			{
				if( bAdhering)
					DrawDebugCylinder(RealTargetLoc+vect(0,0,1)*TargetHeight, RealTargetLoc-vect(0,0,1)*TargetHeight, TargetRadius, 12, 255, 255, 0);
				else					
					DrawDebugCylinder(RealTargetLoc+vect(0,0,1)*TargetHeight, RealTargetLoc-vect(0,0,1)*TargetHeight, TargetRadius, 12, 255, 0, 255);
			}
		}
			

//TP
// `if(`notdefined(FINAL_RELEASE))
// 	//debug
// 	LastAdhesionAmtY = AdhesionAmtY;
// 	LastAdhesionAmtZ = AdhesionAmtZ;
// 	LastDistFromAimZa = DistFromAimZ;
// 	LastDistFromAimYa = DistFromAimY;
// 	LastDeltaRot = DeltaRot;
// 	LastAdjustY = AdjustY;
// 	LastAdjustZ = AdjustZ;
// `endif

}




//ApplyTargetFriction, adapted from UTGame
/**
 * This will slow down the player's aiming when they are on "top" of a valid Target.  So when you whip around
 * there will be a slight slow down when you are directly aiming at a target.
 *
 * TODO:  move this to c++
 **/
function ApplyTargetFriction( float DeltaTime, TPWeapon W )
{
	local Pawn FrictionTarget;
	local Vector CamLoc, X, Y, Z, CamToTarget, AimLoc, TargetLoc, RealTargetLoc;
	local Rotator CamRot;
	local float DistToTarget, DistMultiplier, DistFromAimZ, DistFromAimY;
	local float TargetRadius, TargetHeight;
	local float FrictionMultiplier;
	
	//TP
	local vector HitLocation, TargetLocation;

	//	local float Time;
	//	clock(time);

	if( Pawn == None || !W.bTargetFrictionEnabled )
	{
		//`log( "ApplyTargetFriction returning: W.bTargetFrictionEnabled: " $ W.bTargetFrictionEnabled $ " Pawn: " $ Pawn $ " W: " $ W );
		return;
	}

	// Setup some initial data
	GetPlayerViewPoint( CamLoc, CamRot );
	GetAxes( CamRot, X, Y, Z );

	// Look for a friction target
	//TP FrictionTarget = GetTargetAdhesionFrictionTarget( W.TargetFrictionDistanceMax, CamLoc, CamRot );
	FrictionTarget = Pawn( GetPlayerTarget( HitLocation, TargetLocation, CamLoc, CamRot) );

	// If we have a valid friction target
	if( FrictionTarget != None )
	{
		//`log( "Friction Target: " $ FrictionTarget );
		RealTargetLoc = FrictionTarget.Location + ( W.TargetFrictionOffset >> CamRot );
		CamToTarget = ( RealTargetLoc - CamLoc );
		DistToTarget = VSize(CamToTarget);
		AimLoc = CamLoc + ( X * DistToTarget );

		// Grab collision info from target
		FrictionTarget.GetBoundingCylinder( TargetRadius, TargetHeight );
		


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
		//`log( " TargetFrictionDistanceMin: " $ W.TargetFrictionDistanceMin  $ " TargetFrictionDistanceMax: " $ W.TargetFrictionDistanceMax $ " DistToTarget: " $ DistToTarget );


		//TP - added Min radius scale, regardless of distance
		TargetRadius *= W.TargetFrictionMinRadiusScale;
		TargetHeight *= W.TargetFrictionMinHeightScale;

		if( DistToTarget >= W.TargetFrictionDistanceMin
			&& DistToTarget <= W.TargetFrictionDistanceMax
			)
		{
			if( DistToTarget <= W.TargetFrictionDistancePeak )
			{
				// Ramp up to peak
				DistMultiplier = FClamp((DistToTarget - W.TargetFrictionDistanceMin)/(W.TargetFrictionDistancePeak - W.TargetFrictionDistanceMin),0.f,1.f);
			}
			else
			{
				// Ramp down from peak
				DistMultiplier = FClamp(1.f - (DistToTarget - W.TargetFrictionDistancePeak)/(W.TargetFrictionDistanceMax - W.TargetFrictionDistancePeak),0.f,1.f);
			}

			//`log( "DistMultiplier: " $ DistMultiplier );

			// Scale target radius by distance
			TargetRadius *= 1.f + (W.TargetFrictionPeakRadiusScale * DistMultiplier);
			TargetHeight *= 1.f + (W.TargetFrictionPeakHeightScale * DistMultiplier);
		}


		if (TPGameReplicationInfo(WorldInfo.GRI).DebugInfo.GetDebugFlag(TPD_SHOWSTICKY))
		{
			DrawDebugCylinder(FrictionTarget.Location+vect(0,0,1)*TargetHeight, FrictionTarget.Location-vect(0,0,1)*TargetHeight, TargetRadius, 12, 255, 0, 0);
		}

		// this is used to reduce the target radius so that moving pawns have a smaller radius so that when we are tracking
		// them the reticle doesn't stop outside of their body mass making it either impossible to hit them or making it look bad when
		// shots do actually hit them

//TP- do we want this?		
// 		if( ( VSize(FrictionTarget.Velocity) > 200 )
// 			&& ( W.GetZoomedState() == ZST_Zoomed )
// 			)
// 		{
// 			TargetRadius *= 0.05f;
// 		}


		//`log( " DistFromAimY: " $ DistFromAimY $ " TargetRadius: " $ TargetRadius $ " DistFromAimZ: " $ DistFromAimZ $ " TargetHeight: " $ TargetHeight );

		//`log("friction mult range for" @ W @ "=" @ W.TargetFrictionMultiplierRange.X @ W.TargetFrictionMultiplierRange.Y);

		// If we should apply friction - must be within friction collision box
		if( DistFromAimY < TargetRadius
			&& DistFromAimZ < TargetHeight
			)
		{
			// Calculate the final multiplier (only based on horizontal turn)
			FrictionMultiplier = GetRangeValueByPct( W.TargetFrictionMultiplierRange, 1.f - (DistFromAimY/TargetRadius) );

			//`log( "FrictionMultiplier: " $ FrictionMultiplier );

			if( FrictionMultiplier > 0.0f )
			{
				bAppliedTargetFriction = TRUE;

				// Apply the friction
				aTurn *= (1.f - FrictionMultiplier);

				// Keep the friction target for possible use with adhesion
				LastFrictionTargetTime	= WorldInfo.TimeSeconds;
				LastFrictionTarget		= FrictionTarget;
			}
		}
	}

//TP
// `if(`notdefined(FINAL_RELEASE))
// 	// debug
// 	LastDistToTarget = DistToTarget;
// 	LastDistMultiplier = DistMultiplier;
// 	LastDistFromAimZ = DistFromAimZ;
// 	LastDistFromAimY = DistFromAimY;
// 	LastFrictionMultiplier = FrictionMultiplier;
// 	LastTargetRadius = TargetRadius;
// 	LastTargetHeight = TargetHeight;
// 	LastCamLoc = CamLoc;
// `endif

	//unclock(Time);
	//`log("ViewFriction time"@Time);
}




