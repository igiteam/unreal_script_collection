
/**
 * CQC Move (Close Quarter Combat) 'B' Quick Melee
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class GSM_CQCMove_B extends GSM_CQC_Killer_Base;

protected function bool InternalCanDoSpecialMove()
{
	// grenade cannot do small executions, they do grenade tags!
	if( PawnOwner.Weapon == None ||
		PawnOwner.Weapon.CurrentFireMode == class'TGWeapon'.const.FIREMODE_FAILEDACTIVERELOAD ||
		TGWeap_GrenadeBase(PawnOwner.Weapon) != None )
	{
		return FALSE;
	}

	return Super.InternalCanDoSpecialMove();
}

// Don't position players
function PlaceOnMarkers();

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	BS_KillerAnim.AnimName.Length = 0;
	BS_VictimAnim.AnimName.Length = 0;

	if( PawnOwner.MyTGWeapon != None )
	{
		// Set animation to play.
		BS_KillerAnim.AnimName[BS_Std_Up]			= PawnOwner.MyTGWeapon.CQC_Quick_KillerAnim;
		BS_KillerAnim.AnimName[BS_Std_Idle_Lower]	= PawnOwner.MyTGWeapon.CQC_Quick_KillerAnim;

		//PawnOwner.SoundGroup.PlayEffort(PawnOwner, PawnOwner.MyTGWeapon.CQC_Quick_EffortID, true);
	}

	// Set up victim death time.
	VictimDeathTime = PawnOwner.MyTGWeapon.CQC_Quick_VictimDeathTime;

	Super.SpecialMoveStarted(bForced, PrevMove);
}

function StartInteraction()
{
	// Set execution damage type.
	ExecutionDamageType = PawnOwner.MyTGWeapon.CQC_Quick_DamageType;

	Super.StartInteraction();
}

