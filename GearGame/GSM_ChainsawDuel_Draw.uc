
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_ChainsawDuel_Draw extends GSM_BasePlaySingleAnim;

var CameraAnim	DrawCameraAnim;

protected function bool InternalCanDoSpecialMove()
{
	return TRUE;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// Clear AdhesionTarget at the end of the chainsaw dueling.
	if( PawnOwner != None && PawnOwner.Controller != None )
	{
		if (PCOwner != None)
		{
			PCOwner.StopMeleeAdhesion();
		}
		GearWeap_AssaultRifle(PawnOwner.Weapon).EndOfMeleeAttack();
		PawnOwner.PlaySound( SoundCue'Weapon_AssaultRifle.Melee.ChainsawRevMediumCue' );
	}

	PlayCameraAnim(PawnOwner, DrawCameraAnim);

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_Std_Up,AnimName="COG_ChainsawDuel_Draw"),(Slot=BS_Std_Idle_Lower,AnimName="COG_ChainsawDuel_Draw")))

	DrawCameraAnim=CameraAnim'COG_MarcusFenix.Camera_Anims.Duel_Draw_Cam01'

	bShouldAbortWeaponReload=TRUE
	bCanFireWeapon=FALSE
	bDisableMovement=TRUE
	bDisableLook=TRUE
	bLockPawnRotation=TRUE
	bDisablePOIs=TRUE
}