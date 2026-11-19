
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class GSM_UsingCommLink extends TGSpecialMove;

/** Animation to play */
var()	TGPawn.BodyStance	BS_Animation;


/** See if Player can get in CommLink mode. */
protected function bool InternalCanDoSpecialMove()
{
	// Simple pre-conditions to meet
	if( PawnOwner.bPlayedDeath || PawnOwner.bDeleteMe || PawnOwner.Health <= 0 ||
		PawnOwner.Weapon == None || PawnOwner.bSwitchingWeapons ||
		PawnOwner.bDoingMirrorTransition )
	{
		return FALSE;
	}

	// Special Moves that can be aborted
	if( PawnOwner.SpecialMove != SM_None &&
		PawnOwner.SpecialMove != SM_RoadieRun &&
		PawnOwner.SpecialMove != SM_CoverRun &&
		!PawnOwner.IsDoingMove2IdleTransition() &&
		!PawnOwner.IsDoingMeleeHoldSpecialMove() )
	{
		return FALSE;
	}

	return TRUE;
}

function bool CanChainMove(ESpecialMove NextMove)
{
	return TRUE;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	// Pawn is using CommLink
	PawnOwner.bUsingCommLink = TRUE;

	if (PawnOwner.IsCarryingAHeavyWeapon())
	{
		// short-circuit holstering stuff, don't bother with finger-to-ear
		NotifyInCommLinkStance();
	}
	else
	{
		PawnOwner.MyTGWeapon.HolsterWeaponTemporarily(TRUE);
	}
}


/** Notification called when weapon has been temporarily holstered. */
simulated function WeaponTemporarilyHolstered()
{
	// Stop weapon holster animation.
	PawnOwner.MyTGWeapon.StopHolsterAnims();

	// Weapon is holstered, now go to commlink pose
	PawnOwner.BS_Play(BS_Animation, 1.f, 0.2f,, TRUE);

	PawnOwner.SetTimer( 0.2f, FALSE, nameof(self.NotifyInCommLinkStance), self );
}

/** Called once the pawn is fully in commlink stance */
simulated function NotifyInCommLinkStance()
{
	PawnOwner.bInCommLinkStance = TRUE;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local TGAI AI;

	Super.SpecialMoveEnded(PrevMove, NextMove);

	// Stop CommLink animation
	PawnOwner.BS_Stop(BS_Animation, 0.2f);

	// UnHolster weapon
	if( PawnOwner.MyTGWeapon != None )
	{
		PawnOwner.MyTGWeapon.HolsterWeaponTemporarily(FALSE);
	}

	// Stop using CommLink
	PawnOwner.bUsingCommLink	= FALSE;
	PawnOwner.bInCommLinkStance = FALSE;

	AI = TGAI(PawnOwner.Controller);
	if (AI != None)
	{
		PawnOwner.bWantToUseCommLink = FALSE;
		PawnOwner.bWantToConverse = FALSE;
	}
}

