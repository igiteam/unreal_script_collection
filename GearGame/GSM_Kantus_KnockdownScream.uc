
/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class GSM_Kantus_KnockdownScream extends GearSpecialMove
	config(Pawn);

/** animation to play **/
var()	GearPawn.BodyStance	BS_Scream;

/** Camera shake parameters */
var() protected const CameraShake	ExploShake;
/** Radius to within which to play full-powered screenshake (will be scaled within radius) */
var() float				ExploShakeInnerRadius;
/** Between inner and outer radii, scale shake from full to zero */
var() float				ExploShakeOuterRadius;
/** Exponent for intensity falloff between inner and outer radii. */
var() float				ExploShakeFalloff;

protected function bool InternalCanDoSpecialMove()
{
	if( PawnOwner.IsDBNO())
	{
		return FALSE;
	}

	return true;
}

/**
 * Can a new special move override this one before it is finished?
 *
 * @param NewMove - the move in question
 * @return TRUE if we can override this with NewMove
 */
function bool CanOverrideMoveWith(ESpecialMove NewMove)
{
	return NewMove == SM_StumbleGoDown;
}

function DoKnockDownCamShake()
{
	local PlayerController PC;
	local float ShakeScale;

	if (ExploShake != None)
	{
		foreach PawnOwner.LocalPlayerControllers(class'PlayerController', PC)
		{
			if (PC.PlayerCamera != None && (PC.Pawn == PawnOwner || !PC.WorldInfo.GRI.OnSameTeam(PC, PawnOwner)))
			{
				ShakeScale = class'GearPlayerCamera'.static.CalcRadialShakeScale(PC.PlayerCamera, PawnOwner.Location, ExploShakeInnerRadius, ExploShakeOuterRadius, ExploShakeFalloff);
				ShakeScale *= GearPawn_LocustKantusBase(PawnOwner).ScreamShakeScale;
				PC.ClientPlayCameraShake(ExploShake, ShakeScale, true);
			}
		}
	}
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearPawn_LocustKantusBase Kantus;

	Super.SpecialMoveStarted(bForced,PrevMove);

	//`log(self@GetFuncName()@"PawnsToKnockDown:"@PawnsToKnockDown.length);

	Kantus = GearPawn_LocustKantusBase(PawnOwner);
	PawnOwner.SetTimer(Kantus.KnockdownDelay * 0.8, false, nameof(DoKnockDownCamShake), self);
	if (PawnOwner.Role == ROLE_Authority)
	{
		PawnOwner.SetTimer(Kantus.KnockdownDelay, false, nameof(Kantus.DoKnockDown));
	}

	// quit playing grenade anims
	PawnOwner.BS_StopAll(0.1f);
	// Play body stance animation.
	PawnOwner.BS_Play(BS_Scream, SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier, FALSE, TRUE );

	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(BS_Scream, TRUE);

}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	PawnOwner.BS_SetAnimEndNotify(BS_Scream, FALSE);
}


defaultproperties
{
	bShouldAbortWeaponReload=TRUE
	bCanFireWeapon=FALSE
	bDisableMovement=TRUE

	BS_Scream=(Stance=((Slot=BS_FullBody,AnimName="kantus_yell")))

	Begin Object Class=CameraShake Name=ExploShake0
		OscillationDuration=1.f
		RotOscillation={(Pitch=(Amplitude=1000.f,Frequency=80.f),
						Yaw=(Amplitude=400.f,Frequency=40.f),
						Roll=(Amplitude=600.f,Frequency=50.f))}
	End Object
	ExploShake=ExploShake0
	ExploShakeInnerRadius=800
	ExploShakeOuterRadius=2048
}

