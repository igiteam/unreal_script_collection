
/**
 * GSM_Silverback_CoverDeploy
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Silverback_CoverDeploy extends GearSpecialMove;

var BodyStance DeployAnimation;
var float BlendInTime, BlendOutTime;

/** TRUE if Silverback is fully deployed */
var protectedwrite bool bIsDeployed;

/** Camera shake for the deployment */
var GearCameraShake DeployingCameraShake;

function bool CanOverrideMoveWith(ESpecialMove NewMove)
{
	return (bIsDeployed && (NewMove == GSM_Silverback_CoverExit || NewMove == GSM_Silverback_GetOut || NewMove == GSM_Silverback_GetIn));
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearPawn_SilverbackArmedBase ArmedSilverback;
	local GearPawn_SilverbackBase   Silverback;
	local FLOAT                     AnimTime;

	Silverback = GearPawn_SilverbackBase(PawnOwner);
	ArmedSilverback = GearPawn_SilverbackArmedBase(Silverback);
	if( ArmedSilverback != None )
	{
		bIsDeployed = ArmedSilverback.bAnimIsDeployed;
	}
	else
	{
		bIsDeployed = FALSE;
	}

	super.SpecialMoveStarted(bForced, PrevMove);

	// Lock Pawn Rotation
	if (PCOwner != none)
	{
		PCOwner.TargetHeavyWeaponBaseRotationYaw = PawnOwner.Rotation.Yaw;
	}

	// If not already deployed, setup deployment
	if( !bIsDeployed )
	{
		AnimTime = Silverback.BS_Play(DeployAnimation, SpeedModifier, BlendInTime, -1.f);
		Silverback.Driver.BS_Play(DeployAnimation, SpeedModifier, BlendInTime, -1.f);

		// Set up deployment after animation is done.
		PawnOwner.SetTimer(AnimTime, FALSE, nameof(SilverbackDeployed), self);
		PawnOwner.SetTimer(FMin(AnimTime, BlendInTime), FALSE, nameof(TurnOnDeployment), self);
	}
	else
	{
		// Otherwise we're already deployed
	}
}

function TurnOnDeployment()
{
	local GearPawn_SilverbackArmedBase   Silverback;

	Silverback = GearPawn_SilverbackArmedBase(PawnOwner);
	if( Silverback != none )
	{
		Silverback.bAnimIsDeployed = TRUE;

		if (Silverback.Role == ROLE_Authority)
		{
			Silverback.bNetIsDeployed = TRUE;
		}
	}

	if( PCOwner != None )
	{
		PCOwner.ClientPlayCameraShake(DeployingCameraShake, 1.0f, TRUE);
	}
}

function SilverbackDeployed()
{
	local GearPawn_SilverbackArmedBase   Silverback;

	bIsDeployed = TRUE;

	Silverback = GearPawn_SilverbackArmedBase(PawnOwner);
	if( Silverback != none )
	{
		Silverback.SetActiveWeapon(Silverback.AltWeapon);

		// Setup Cover
		Silverback.SetupCover();
		// Now that we're deployed, see if player changed his mind and wants to exit that state.
		Silverback.CheckDeployedStatus();

		// Trigger the silverback deployed delegate
		PCOwner.TriggerGearEventDelegates(eGED_SilverbackDeployed);
	}
}

function PreProcessInput(GearPlayerInput Input)
{
	// manually disable movement
	Input.aStrafe = 0.f;
	Input.aBaseY = 0.f;
}


/** Called from GearPawn to give special moves a chance to limit view rotation. */
function LimitViewRotation(out Rotator out_ViewRotation)
{
	local int BaseYaw;
	local GearPawn_SilverbackArmedBase   Silverback;

	Silverback = GearPawn_SilverbackArmedBase(PawnOwner);
	if( Silverback != none )
	{
		BaseYaw = PCOwner.TargetHeavyWeaponBaseRotationYaw;
		if( InterpActor_GearBasePlatform(PawnOwner.Base) != None )
		{
			BaseYaw += PawnOwner.Base.Rotation.Yaw;
		}

		out_ViewRotation.Yaw = ClampRotAxisFromBase(out_ViewRotation.Yaw, BaseYaw, Silverback.MaxDeployedAimAdjustYaw);
	}
}

/** Don't override aimoffset when deployed */
event bool DisableAimOffset()
{
	return FALSE;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	if( PawnOwner.IsTimerActive(nameof(TurnOnDeployment), self) )
	{
		TurnOnDeployment();
		PawnOwner.ClearTimer(nameof(TurnOnDeployment), self);
	}

	if( PawnOwner.IsTimerActive(nameof(SilverbackDeployed), self) )
	{
		SilverbackDeployed();
		PawnOwner.ClearTimer(nameof(SilverbackDeployed), self);
	}

	// A checkpoint teleport is force kiling this move
	if (NextMove == SM_None)
	{
		TurnOffDeployment();
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

/** We got teleported most likely, clean up deployment */
function TurnOffDeployment()
{
	local GearPawn_SilverbackArmedBase Silverback;

	Silverback = GearPawn_SilverbackArmedBase(PawnOwner);
	if (Silverback != None)
	{
		Silverback.bAnimIsDeployed = FALSE;

		Silverback.SetActiveWeapon(Silverback.PrimaryWeapon);

		if (Silverback.Role == ROLE_Authority)
		{
			Silverback.bNetIsDeployed = FALSE;
		}

		Silverback.CleanUpDeployment();
		Silverback.BS_Stop(DeployAnimation);
		Silverback.Driver.BS_Stop(DeployAnimation);
	}
}

defaultproperties
{
	DeployAnimation=(Stance=((Slot=BS_FullBody,AnimName="SB_Deploy")))
	BlendInTime=0.33f
	BlendOutTime=0.2f

	bLockPawnRotation=TRUE
 	bDisableMovement=FALSE

	Begin Object Class=GearCameraShake Name=DeployingCameraShake0
		OscillationDuration=0.4f
		RotOscillation={(Pitch=(Amplitude=80.f,Frequency=80.f),
						Yaw=(Amplitude=60.f,Frequency=50.f),
						Roll=(Amplitude=35.f,Frequency=20.f))}
	End Object
	DeployingCameraShake=DeployingCameraShake0

	bShowHUDActions=TRUE
}
