
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_PushOutOfCover extends GearSpecialMove;

var transient BodyStance PlayedStance;

/** Body Stances to play */
var const BodyStance	BS_Cov_Mid_CoverBreak;
var const BodyStance	BS_Cov_Mid_CoverBreakMirrored;
var const BodyStance	BS_Cov_Std_CoverBreak;
var const BodyStance	BS_Cov_Std_CoverBreakMirrored;

function bool CanChainMove(ESpecialMove NextMove)
{
	// all special moves can chain from a pushout (except mantles! :P)
	return (NextMove != SM_MidLvlJumpOver && NextMove != SM_MantleKick);
}

protected function bool InternalCanDoSpecialMove()
{
	if( PawnOwner.IsDoingASpecialMove() && !PawnOwner.IsDoingMove2IdleTransition() )
	{
		return FALSE;
	}

	// don't bother if doing a melee attack
	if( PawnOwner.bDoingMeleeAttack )
	{
		return FALSE;
	}

	// Don't push out of cover if we are grabbing movable cover
	if( PawnOwner.bGrabbingMovableCover )
	{
		return FALSE;
	}

	return TRUE;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	// For Heavy Weapons playing a mirror transition, we need the IK bones to be turned off...
	if( PawnOwner.bWantsToBeMirrored && PawnOwner.MirrorNode != None && PawnOwner.MyGearWeapon != None && PawnOwner.MyGearWeapon.WeaponType == WT_Heavy )
	{
		PawnOwner.MirrorNode.ForceDrivenNodesOff();
	}

	Super.SpecialMoveStarted(bForced,PrevMove);
}

/**
 * See if we could play a mirror transition right now.
 * Make sure it won't collide with one playing currently and produce something ugly.
 */
event bool IsMirrorTransitionSafe()
{
	`LogSMExt(PawnOwner, "IsIKReady:" @ IsIKReady());

	if( IsIKReady() )
	{
		return Super.IsMirrorTransitionSafe();
	}

	return FALSE;
}


/** Called when ready to break from cover. Might be delayed because doing a mirror transition. */
function OnMirrorTransitionSafeNotify()
{
	StartPushOut();
}

/**
 * Make sure that IKs are turned off. Only matters for Heavy Weapons.
 * Work around for Heavy Weapons having a different IK chain setup, causing issues when blending with mirrored animations.
 */
function bool IsIKReady()
{
	`LogSMExt(PawnOwner, "bWantsToBeMirrored:" @ PawnOwner.bWantsToBeMirrored );
	if( PawnOwner.bWantsToBeMirrored && PawnOwner.MirrorNode != None && PawnOwner.MyGearWeapon != None && PawnOwner.MyGearWeapon.WeaponType == WT_Heavy )
	{
		`LogSMExt(PawnOwner, "AreDrivenNodesTurnedOff:" @ PawnOwner.MirrorNode.AreDrivenNodesTurnedOff() );
		return PawnOwner.MirrorNode.AreDrivenNodesTurnedOff();
	}

	return TRUE;
}

/** Trigger animations, physics, etc. */
function StartPushOut()
{
	local ECoverAction ReplicatedCA;

	// If human controller, unlock Pawn Rotation so he interpolate back to camera rot.
	if ( PawnOwner.IsHumanControlled() )
	{
		// Unlock Pawn Rotation so he interpolate back to camera rot.
		SetLockPawnRotation(FALSE);
		// Override
		// Rot time has to match blend in
		// Need special interp. Not always want shortpath to match anim blend.
		PawnOwner.InterpolatePawnRotation(0.15f/SpeedModifier, TRUE);
	}

	// If leaving cover from PopUp or Leans, (while Targeting), then don't play transition animation.
	ReplicatedCA = ECoverAction(PawnOwner.SpecialMoveFlags);
	if( ReplicatedCA == CA_PopUp || ReplicatedCA == CA_LeanLeft || ReplicatedCA == CA_LeanRight )
	{
		// Allow player to move
		SetMovementLock(FALSE);

		// In case of Leans, move player a little bit, to compensate for animation sticking out of the collision cylinder
		// So player doesn't end up shooting in the wall - but where he was before, with the lean animation sticking out of the cylinder.
		if( ReplicatedCA == CA_LeanLeft )
		{
			PawnOwner.Velocity += (vect(0,-600,0) >> PawnOwner.Rotation);
		}
		else  if( ReplicatedCA == CA_LeanRight )
		{
			PawnOwner.Velocity += (vect(0,+600,0) >> PawnOwner.Rotation);
		}

		// Don't play animation.
		PawnOwner.SetTimer(0.2f, FALSE, 'EndSpecialMove');
		if( PCOwner != None )
		{
			PCOwner.LeaveCover();
		}
		return;
	}

	DoPushOutSpecifics();

	// Play transition animation.
	if( PawnOwner.bIsMirrored )
	{
		// If we're popping up, then play standing exit animation.
		PlayedStance = (PawnOwner.CoverType == CT_MidLevel && PawnOwner.CoverAction != CA_PopUp) ? BS_Cov_Mid_CoverBreakMirrored : BS_Cov_Std_CoverBreakMirrored;
		// Play body stance animation.
		PawnOwner.BS_Play(PlayedStance, SpeedModifier, 0.15f/SpeedModifier, 0.25f/SpeedModifier, FALSE, TRUE);

		// Play animation mirrored
		PawnOwner.BS_SetMirrorOptions(PlayedStance, FALSE, TRUE, TRUE);

		// Don't trigger the notification early, as we want the IK to be switched back on after the transition animation has disapeared.
		// Heavy Weapons use a different IK setup, and we can't have them on during the transition animation.
		if( PawnOwner.MyGearWeapon != None && PawnOwner.MyGearWeapon.WeaponType == WT_Heavy )
		{
			PawnOwner.BS_SetEarlyAnimEndNotify(PlayedStance, FALSE);
		}
	}
	else
	{
		PlayedStance = (PawnOwner.CoverType == CT_MidLevel && PawnOwner.CoverAction != CA_PopUp) ? BS_Cov_Mid_CoverBreak : BS_Cov_Std_CoverBreak;
		// Play body stance animation.
		PawnOwner.BS_Play(PlayedStance, SpeedModifier, 0.15f/SpeedModifier, 0.25f/SpeedModifier, FALSE, TRUE);
	}

	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(PlayedStance, TRUE);

	if( PCOwner != None )
	{
		PCOwner.LeaveCover();
	}
}

/** We do here things specific to the PushOut, so we can exclude it in GSM_CoverDestroyed. */
function DoPushOutSpecifics()
{
	// check to see if we are going into standing or midlevel cover
	if( PawnOwner.CoverType == CT_MidLevel )
	{
		PawnOwner.SoundGroup.PlayFoleySound( PawnOwner, GearFoley_ExitCoverLowFX );
	}
	else if( PawnOwner.CoverType == CT_Standing )
	{
		PawnOwner.SoundGroup.PlayFoleySound( PawnOwner, GearFoley_ExitCoverHighFX );
	}

	// Push Pawns only on locally owned clients or server.
	// This equals to the Pawn having a controller set
	if( PawnOwner.Controller != None )
	{
		//`Log("TEST");
		// Give a velocity push away from cover
		PawnOwner.Velocity		= -PawnOwner.GroundSpeed * Vector(PawnOwner.Rotation) * SpeedModifier;
		PawnOwner.Acceleration	= Normal(PawnOwner.Velocity) * PawnOwner.AccelRate * SpeedModifier;

		// Force Pawn to keep moving
		PawnOwner.bForceMaxAccel = TRUE;

		`LogSMExt(PawnOwner,"Push out:"@PawnOwner.Velocity@PawnOwner.Acceleration);
	}
}


function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// Disable forced movement
	PawnOwner.bForceMaxAccel = FALSE;

	// Turn off mirroring
	PawnOwner.BS_SetMirrorOptions(PlayedStance, FALSE, FALSE, FALSE);

	// Turn off AnimEnd notification
	PawnOwner.BS_SetAnimEndNotify(PlayedStance, FALSE);

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	bCoverExitMirrorTransition=TRUE
	bMirrorTransitionSafeNotify=TRUE
	bLockPawnRotation=TRUE
	bBreakFromCover=TRUE
	bDisableMovement=TRUE

	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'
	bDisableAI=TRUE
	AITimeout=10.0

	BS_Cov_Mid_CoverBreak=(Stance=((Slot=BS_FullBody,AnimName="AR_Cov_Mid_Idle2Idle_Ready_Aim")))
	BS_Cov_Mid_CoverBreakMirrored=(Stance=((Slot=BS_FullBody,AnimName="AR_Cov_Mid_Idle_Mirrored2Idle_Ready_Aim")))
	BS_Cov_Std_CoverBreak=(Stance=((Slot=BS_FullBody,AnimName="AR_Cov_Std_Idle2Idle_Ready_Aim")))
	BS_Cov_Std_CoverBreakMirrored=(Stance=((Slot=BS_FullBody,AnimName="AR_Cov_Std_Idle_Mirrored2Idle_Ready_Aim")))
}
