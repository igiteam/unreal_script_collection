/**
 * Special move to throw the cleaver
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_CleaverThrow extends GearSpecialMove;

/** The throw animation to play */
var()	GearPawn.BodyStance	BS_Animation;

var     SoundCue            ThrowSound;

var transient GearWeap_CleaverBase  Cleaver;

/**
 * Start the body animation when the special move starts.
 *
 * @param bForced - was the special move forced
 *
 * @param PrevMove - the previous special move to run
 *
 */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{	
	Super.SpecialMoveStarted(bForced,PrevMove);

	// this only works on server
	Cleaver = GearWeap_CleaverBase(PawnOwner.MyGearWeapon);

	// Play body stance animation.
	PawnOwner.BS_Play(BS_Animation, SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier, FALSE, TRUE);
	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, TRUE);

	PawnOwner.PlaySound(ThrowSound);
}

/**
 * Remove the end of animation notification that was set in SpecialMoveStarted.
 *
 * @param PrevMove - the previous special move to run
 *
 * @param NextMove - the next special move to run
 *
 */
function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	// Disable end of animation notification. 
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, FALSE);

	// time to switch weapon
	if (Cleaver!=none)
	{
		PawnOwner.InvManager.RemoveFromInventory(Cleaver);
		GearInventoryManager(PawnOwner.InvManager).AutoSwitchWeapon();
	}
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="Cleaver_Throw")))

	ThrowSound=SoundCue'Weapon_Cleaver.Cleaver.Cleaver_Throw_Cue'

	bCanFireWeapon=FALSE
	bLockPawnRotation=TRUE
	bDisableMovement=TRUE
	bDisableLook=TRUE
	bDisablePhysics=TRUE
}