
/**
 * GSM_Silverback_CoverExit
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Silverback_CoverExit extends GearSpecialMove;

var BodyStance	        UndeployAnimation;
var FLOAT               BlendInTime, BlendOutTime;

/** Camera shake for exiting deployment */
var GearCameraShake CoverExitCameraShake;

function bool CanChainMove(ESpecialMove NextMove)
{
	return (NextMove == GSM_Silverback_CoverDeploy);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearPawn_SilverbackBase   Silverback;
	local FLOAT                     AnimTime;

	Silverback = GearPawn_SilverbackBase(PawnOwner);

	super.SpecialMoveStarted(bForced, PrevMove);

	AnimTime = Silverback.BS_Play(UndeployAnimation, SpeedModifier, BlendInTime, BlendOutTime);
	Silverback.Driver.BS_Play(UndeployAnimation, SpeedModifier, BlendInTime, BlendOutTime);

	// End special move after animation is done
	PawnOwner.SetTimer(AnimTime, FALSE, nameof(EndSpecialMove), self);
	PawnOwner.SetTimer(FMin(AnimTime, BlendInTime), FALSE, nameof(TurnOffDeployment), self);

	if (PCOwner != None)
	{
		PCOwner.ClientPlayCameraShake(CoverExitCameraShake, 1.0f, TRUE);
	}
}

function TurnOffDeployment()
{
	local GearPawn_SilverbackArmedBase   Silverback;

	Silverback = GearPawn_SilverbackArmedBase(PawnOwner);
	if( Silverback != none )
	{
		Silverback.bAnimIsDeployed = FALSE;
		
		Silverback.SetActiveWeapon(Silverback.PrimaryWeapon);
		
		if (Silverback.Role == ROLE_Authority)
		{
			Silverback.bNetIsDeployed = FALSE;
		}

		Silverback.CleanUpDeployment();
	}
}

function EndSpecialMove()
{
	PawnOwner.EndSpecialMove();
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
	if( PawnOwner.IsTimerActive(nameof(TurnOffDeployment), self) )
	{
		TurnOffDeployment();
		PawnOwner.ClearTimer(nameof(TurnOffDeployment), self);

	}
	PawnOwner.ClearTimer(nameof(EndSpecialMove), self);

	// Trigger the silverback delegate
	PCOwner.TriggerGearEventDelegates(eGED_Silverback);

	super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'

	UndeployAnimation=(Stance=((Slot=BS_FullBody,AnimName="SB_Undeploy")))
	BlendInTime=0.33f
	BlendOutTime=0.2f

	bLockPawnRotation=TRUE
	bDisableMovement=FALSE

	Begin Object Class=GearCameraShake Name=CoverExitCameraShake0
		OscillationDuration=0.4f
		RotOscillation={(Pitch=(Amplitude=80.f,Frequency=80.f),
						Yaw=(Amplitude=60.f,Frequency=50.f),
						Roll=(Amplitude=35.f,Frequency=20.f))}
	End Object
	CoverExitCameraShake=CoverExitCameraShake0
}
