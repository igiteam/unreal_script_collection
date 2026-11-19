/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoSkill_Dash extends NanoSkill
	native(Pawn)
	config(Pawn);

struct native DashPipInfo
{
	var config Vector2D DashSpeedScale;
	var config float TimeToHitNextLevel;
	var config float TurnRateScale;
	var config Rotator RotRate;
	var config InterpCurveFloat RotRateCurve;
	/** How much to apply post-process effect when sprinting at this speed. */
	var config float SpeedPPAmount;
	var config float BlowoutPPAmount;
	var config float DustSpeedModifier;
	var config float DenseSpeedModifier;
	/** This is the FOV that we should use for this dash pip **/
	var config float FOV;
	/** Should this pip cause a slide? */
	var config bool bShouldSlide;
	var config float MinLandingSpeedToMaintainDash;
};
var() config array<DashPipInfo> DashPips;

struct native DashSkillInfo
{
	/** Max number of pips allowed at this dash skill level */
	var config byte	 MaxDashPips;
	/** Modifies amount of time it takes to do any dash pip */
	var config float DashTimeModifier;
	/** Acceleration rate available at this dash level */
	var config float AccelRate;
};
var() config array<DashSkillInfo> DashLevels;

/** What pip of dash are we currently at (index into DashPips, -1 for no current dash) */
var transient int CurrentDashPip;
/** Last dash pip we attained, for use in trailing off velocity */
var transient int LastDashPip;
/** Should the current dash be stopped upon landing? */
var transient bool bDelayedStopDash;
/** Time since start of last dash pip, reset everytime CurrentDashPip increments */
var transient float StartNextPipTimer;
var transient float LastPipChangeTime;

var transient float DashBleedOffPct;
/** Dash speed modifier at time dash is deactivated */
var transient float DeactivateSpeedScale;
/** Amount of time to decelerate back to normal speed out of dash */
var float   DecelerationTime;

/** Audio properties */
var protected transient AudioComponent AC_RunningBreathe;
var protected SoundCue RunningBreatheCue;

var config AccelCurve ForwardBoostCurve;

/** Holder variables for slide delay update of camera rotation etc */
var NanoPawn SlidePawn;
var Vector	 SlidePawnVel;

simulated native final function float GetSpeedModifier( optional NanoPawn NP );
simulated native final function float GetMaxSpeed( optional NanoPawn NP );

simulated protected function InternalActivated()
{
	local float AnimTime;

	StartNextPipTimer = 0.f;
	PawnOwner.bIsDashing = TRUE;
	CurrentDashPip = -1;
	SetDashPips(0);

	if( VSize(PawnOwner.Velocity) <= PawnOwner.GroundSpeed )
	{
		if( PawnOwner.RunningFullBodySlot != None )
		{
			AnimTime = PawnOwner.RunningFullBodySlot.PlayCustomAnim( 'NW_Sprint_Fwd_Burst_Start', 1.0, 0.1, 0.5f, FALSE, TRUE,0.f );
			PawnOwner.SetTimer( AnimTime, FALSE, nameof(FinishedSprintStartAnim), self );
		}
	}
	else
	{
		if( PawnOwner.SprintLeanAdditiveNode != None )
		{
			PawnOwner.SprintLeanAdditiveNode.SetBlendTarget(1.f,0.25f);
		}
	}
	PawnOwner.AccelRate = DashLevels[SkillLevel].AccelRate;
	PawnOwner.StopFiring();
	PawnOwner.HolsterCurrentWeapon();

	PawnOwner.LastDashStartTime = PawnOwner.WorldInfo.TimeSeconds;
}

simulated function FinishedSprintStartAnim()
{
	if( PawnOwner.SprintLeanAdditiveNode != None )
	{
		PawnOwner.SprintLeanAdditiveNode.SetBlendTarget(1.f,0.25f);
	}
	PawnOwner.ResetRunSyncGroup();
}

/**
 *  here we need to return the values to their defaults
 **/
simulated protected function InternalDeactivated()
{
	PawnOwner.bIsDashing = FALSE;
	bDelayedStopDash = FALSE;

	PawnOwner.AccelRate = PawnOwner.default.AccelRate;
	PawnOwner.RunningFullBodySlot.StopCustomAnim( 0.25f );
	PawnOwner.AccelCurves.Length = 0;

	if( PawnOwner.MantleState == MANTLE_None && 
		PawnOwner != None &&
		PawnOwner.Health > 0 &&
		VSize2D(PawnOwner.Velocity) > PawnOwner.default.GroundSpeed && 
		(PawnOwner.Weapon == None || !PawnOwner.Weapon.IsFiring()) &&
		!PawnOwner.UnarmedSprintSlot.bIsPlayingCustomAnim &&
		PawnOwner.CurrentLadder == None && 
		!IsPushingForward() )
	{
		StartSlide(PawnOwner);
	}

	// Make tackled actor fly off when we stop
	if( PawnOwner.InteractionPawn != None && PawnOwner.InteractionType == PAWNINTER_Tackle )
	{
		if( !PawnOwner.FullBodySlot.bIsPlayingCustomAnim )
		{
			PawnOwner.ThrowTackledActor();
		}
	}

	if( ShouldPlayClientEffects() )
	{
		if (AC_RunningBreathe != None) 
		{
			AC_RunningBreathe.FadeOut( 0.100f, 1.0f );
			AC_RunningBreathe = None; // this causes the AC to be recreated each time.  Question of keeping comp around cost vs recreation cost
		}
	}

	PawnOwner.ClearTimer( nameof(PawnOwner.DisableFakeGhostEffects) );
	PawnOwner.DisableFakeGhostEffects();
	PawnOwner.RotationRate = PawnOwner.default.RotationRate;
	if( PawnOwner.SprintLeanAdditiveNode != None )
	{
		PawnOwner.SprintLeanAdditiveNode.SetBlendTarget(0.f,0.5f);
	}

	SetDashPips(-1);

	if( ShouldAthleticIdle() )
	{
		PawnOwner.DoSpecialMove( 'NSM_Dash_AthleticIdle' );
	}
}


/** Overridden to handle delaying deactivation while airborne */
simulated event DeactivateSkill()
{
	if (bActive)
	{
		// delay deactivation if still falling
		if (PawnOwner != None && ( PawnOwner.Health > 0 ) && PawnOwner.Physics == PHYS_Falling)
		{
			bDelayedStopDash = TRUE;
		}
		else
		{
			Super.DeactivateSkill();
		}
	}
}

simulated function StartSlide( NanoPawn NP, optional bool bForceLongSlide )
{
	NP.DoSpecialMove( 'NSM_Dash_Slide', bForceLongSlide );
}

simulated function bool ShouldConsumeNanoPower()
{
	// only consume power if actually on the ground
	return PawnOwner.Physics == PHYS_Walking && Super.ShouldConsumeNanoPower();
}

simulated function PreProcessInput( float DeltaTime, NanoPlayerInput_Base PlayerInput )
{
	local float TurnInterp;

	Super.PreProcessInput( DeltaTime, PlayerInput );

	if( bActive )
	{
		// scale the turn rate scale as the player reaches max vel (less turn at full speed)
		TurnInterp = Lerp(1.f, DashPips[CurrentDashPip].TurnRateScale, FClamp(VSize2D(PawnOwner.Velocity)/GetMaxSpeed(PawnOwner),0.1,1.f)); 
		PlayerInput.aTurn *= TurnInterp;
	}
}

simulated function bool IsPushingForward()
{
	local NanoPC PC;
	local Vector StickDir, CamLoc;
	local float StickDotVel;
	local Rotator CamRot;

	PC = NanoPC(PawnOwner.Controller);
	if( PC != None )
	{
		if( Abs(PC.RemappedJoyUp) > 0.3f || Abs(PC.RemappedJoyRight) > 0.3f )
		{
			PawnOwner.GetActorEyesViewPoint(CamLoc,CamRot);
			CamRot.Pitch = 0;

			StickDir.X = PC.PlayerInput.RawJoyUp;
			StickDir.Y = PC.PlayerInput.RawJoyRight;
			StickDir = Normal(StickDir) >> CamRot;
			
			StickDotVel = (StickDir DOT Normal(PawnOwner.Velocity));
			if( StickDotVel > -0.8f )
			{
				return TRUE;
			}
		}
		return FALSE;
	}

	return TRUE;
}

simulated function Rotator GetDashRotationRate()
{
	local float SpeedPct, VelSize, MaxSpeed, CurveScale;
	local Rotator RotRateDelta;

	VelSize  = VSize2D(PawnOwner.Velocity);
	MaxSpeed = GetMaxSpeed();

	SpeedPct = (VelSize - PawnOwner.GroundSpeed) / (MaxSpeed - PawnOwner.GroundSpeed);
	RotRateDelta = DashPips[CurrentDashPip].RotRate - PawnOwner.default.RotationRate;

	CurveScale = EvalInterpCurveFloat( DashPips[CurrentDashPip].RotRateCurve, SpeedPct );

	return PawnOwner.default.RotationRate + (CurveScale * RotRateDelta);
}

simulated function Tick(float DeltaTime)
{
	local float	 VelSize;
	local Vector Vel;
	local bool bWantsToDash;

	Super.Tick(DeltaTime);

	if( PawnOwner.Health <= 0 )
	{
		return;
	}

	if( PawnOwner.ForceSprintTimer > 0.f )
	{
		PawnOwner.ForceSprintTimer -= DeltaTime;
	}

	if( bActive && PawnOwner != None )
	{
		PawnOwner.LastDashingTime = PawnOwner.WorldInfo.TimeSeconds;
		DashBleedOffPct = 1.f - FClamp( VSize(PawnOwner.AngularVelocity) / 3.f, 0.f, 1.f );

		//`log( `showvar(PawnOwner.LastDashingTime) );

		if( PawnOwner.Physics == PHYS_Walking )
		{
			PawnOwner.RotationRate = GetDashRotationRate();
			if( bDelayedStopDash )
			{
				DeactivateSkill();
				return;
			}

			if( IsPushingForward() )
			{
				VelSize = VSize2D(PawnOwner.Velocity);
				if( VelSize < PawnOwner.GroundSpeed )
				{
					Vel	  = Normal(PawnOwner.Velocity) * PawnOwner.GroundSpeed;
					Vel.Z = PawnOwner.Velocity.Z;
					PawnOwner.Velocity = Vel;
				}
			}
		}
		else
		{
			PawnOwner.RotationRate = PawnOwner.default.RotationRate;
		}
	}

	bWantsToDash = WantsToDash();
	if( bWantsToDash && !bActive )
	{
		PawnOwner.ActivateSkill( class'NanoSkill_Dash' );
	}
	else if( !bWantsToDash && bActive )
	{
		PawnOwner.DeactivateSkill( class'NanoSkill_Dash' );
	}
	else if( ShouldAthleticIdle() )
	{
		PawnOwner.DoSpecialMove( 'NSM_Dash_AthleticIdle' );
	}
}

simulated function bool WantsToDash()
{
	local NanoPC PC;
	local bool bCanDash;

	// Don't update sprinting if in the process of throwing a victim
	if( PawnOwner.IsTimerActive(nameof(PawnOwner.CleanupTackledActor)) || PawnOwner.bIsBamfing )
	{
		return bActive;
	}

	bCanDash = PawnOwner.CanDash();

	PC = NanoPC(PawnOwner.Controller);
	if( PC != None )
	{
		if( PawnOwner.bWantsToShoot || PawnOwner.bIsDoingMeleeAttack )
		{
			return FALSE;
		}
		if( PC.MainPlayerInput.bHoldSprint )
		{
			if( `TimeSinceEx( PC, PC.MainPlayerInput.InputButtonDataList[GB_RightBumper].LastRawActiveTime ) < 0.25f )
			{
				return FALSE;
			}

			if( !PawnOwner.bWantsToDash || !bCanDash )
			{
				return FALSE;
			}
		}

		if( !PC.MainPlayerInput.bHoldSprint&& !bActive )
		{
			return FALSE;
		}
	}

	return bCanDash && (PawnOwner.ForceSprintTimer > 0.f || IsPushingForward());
}

simulated function bool ShouldAthleticIdle()
{
	local NanoPC PC;

	// for now never do the AthleticIdle
	return FALSE;



	if( PawnOwner.bSliding || PawnOwner.bWantsToShoot || PawnOwner.bIsDoingMeleeAttack || PawnOwner.bEndingSpecialMove || PawnOwner.ActiveSpecialMoveName != '' )
	{
		return FALSE;
	}

	PC = NanoPC(PawnOwner.Controller);
	if( PC != None )
	{
		if( PC.MainPlayerInput.bHoldSprint )
		{
			if( PawnOwner.bWantsToDash && !IsPushingForward() && NSM_Dash_AthleticIdle(PawnOwner.ActiveSpecialMove) == None )
			{
				return TRUE;
			}
			return FALSE;
		}

		if( !PC.MainPlayerInput.bHoldSprint )
		{
			if( (PawnOwner.WorldInfo.TimeSeconds - LastActivateTime) < 0.1f )
			{
				return TRUE;
			}
		}

	}


	return FALSE;
}

simulated function SetDashPips(int DashPip)
{
	local float VelSize;
	local Vector Vel, VelDir;
	local Vector X, Y, Z;
	local Vector CamLoc;
	local Rotator CamRot;
	local NanoPC PC;

	if( DashPip != CurrentDashPip )
	{
		`loginfo( 'Nano_Locomotion', "Setting new dash pip:"@`showvar(DashPip)@`showvar(CurrentDashPip));

		// If was not previously dashing - get up to at least top jog speed instantly
		if( CurrentDashPip < 0 )
		{
			PC = NanoPC(PawnOwner.Controller);
			if( PC != None )
			{
				PC.GetActorEyesViewPoint( CamLoc, CamRot );
				CamRot.Pitch = 0;
				GetAxes( CamRot, X, Y, Z );
				VelDir = Normal((X * PC.PlayerInput.RawJoyUp) + (Y * PC.PlayerInput.RawJoyRight));
			}
			else
			{
				VelDir = Vector(PawnOwner.DesiredRotation);
			}

			// If just starting 
			if( IsPushingForward() )
			{
				VelSize = VSize2D(PawnOwner.Velocity);
				if( VelSize < PawnOwner.GroundSpeed || (VelDir DOT PawnOwner.Velocity) < 0 )
				{
					Vel	  = VelDir * PawnOwner.GroundSpeed;
					Vel.Z = PawnOwner.Velocity.Z;
					PawnOwner.Velocity = Vel;

					CamRot = Rotator(Vel);
					CamRot.Pitch = 0;
					CamRot.Roll = 0;
					PawnOwner.SetRotation( CamRot );
				}
			}
		}

		CurrentDashPip = DashPip;
		ActiveSkillLevel = DashPip;
		LastPipChangeTime = PawnOwner.WorldInfo.TimeSeconds;

		if (DashPip != -1)
		{
			LastDashPip = DashPip;
		}

		// do breathing AudioComponent set up
		if (CurrentDashPip >= 1 && AC_RunningBreathe == None)
		{
			AC_RunningBreathe = new(self) class'AudioComponent';
			AC_RunningBreathe.SoundCue = RunningBreatheCue;
			PawnOwner.AttachComponent( AC_RunningBreathe );
			AC_RunningBreathe.FadeIn( 0.100f, 1.0f );
		}
	}
}


/** Gets the current skill pip in use */
simulated function int GetCurrentSkillLevelInUse()
{
	return CurrentDashPip;
}

/** This is used to set the curve values for the Dash PPE MITVs **/
simulated function SetUpMITV( out MaterialInstanceTimeVarying out_MITV, name InParamName, float StartValue, float EndValue, float Duration )
{
	local InterpCurveFloat Points;
	local InterpCurvePointFloat Point;

	//`log( "Setting MITV params" @ out_MITV @ InParamName @ StartValue @ EndValue @ Duration );

	Points.Points.length = 2;

	Point.InVal = 0.0f;
	Point.OutVal = StartValue;
	Points.Points[0] = Point; // start

	Point.InVal = Duration;
	Point.OutVal = EndValue;
	Points.Points[1] = Point; // end

	out_MITV.SetScalarCurveParameterValue( InParamName, Points );
	out_MITV.SetScalarStartTime( InParamName, 0.0f ); // start now
}


/** This will make a curve which will do the "burst" of light fading up and then down to the level of the current Dash level **/
simulated function DoDashBurst( out MaterialInstanceTimeVarying out_MITV, name InParamName, float StartValue, float EndValue, float Duration, float PostBurstStartValue, float PostBurstEndValue, float PostBurstDuration )
{
	local InterpCurveFloat Points;
	local InterpCurvePointFloat Point;

	//`log( "Setting MITV params" @ out_MITV @ InParamName @ StartValue @ EndValue @ Duration );

	Points.Points.length = 4;

	Point.InVal = 0.0f;
	Point.OutVal = StartValue;
	Points.Points[0] = Point; // start

	Point.InVal = Duration/2;
	Point.OutVal = EndValue;
	Points.Points[1] = Point; // middle

	Point.InVal = Duration;
	Point.OutVal = StartValue;
	Points.Points[2] = Point; // end burst

	Point.InVal = PostBurstDuration;
	Point.OutVal = PostBurstEndValue;
	Points.Points[3] = Point; // end

	out_MITV.SetScalarCurveParameterValue( InParamName, Points );
	out_MITV.SetScalarStartTime( InParamName, 0.0f ); // start now
}


simulated function NotifyLanded(NanoPawn NP)
{
}



defaultproperties
{
	SkillType=NS_Dash
	bSkipReplication=TRUE

	RunningBreatheCue=SoundCue'Character_Lyrik_Efforts.Lyrik_Efforts_Breathing_Cue'
	
	SkillIconOrigin=(X=192)
	SkillIconSize=(X=64,Y=64)

	bHideFromSkillUI=TRUE
	DashBleedOffPct=1.f
	DecelerationTime=1.f
}
