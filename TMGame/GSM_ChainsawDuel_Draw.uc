
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
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
		PawnOwner.SetAdhesionTarget(None);
		TGWeap_AssaultRifle(PawnOwner.Weapon).EndOfMeleeAttack();
	}

	PlayCameraAnim(PawnOwner, DrawCameraAnim);

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

