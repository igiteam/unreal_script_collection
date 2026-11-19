
/**
 * CQC Move (Close Quarter Combat) 'B' Quick Melee
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_CQCMove_B extends GSM_CQC_Killer_Base 
	// we're not using Quick execution anymore, so deprecating
	deprecated;

protected function bool InternalCanDoSpecialMove()
{
	return FALSE;
	// grenade cannot do small executions, they do grenade tags!
// 	if( PawnOwner.Weapon == None ||
// 		PawnOwner.Weapon.CurrentFireMode == class'GearWeapon'.const.FIREMODE_FAILEDACTIVERELOAD ||
// 		GearWeap_GrenadeBase(PawnOwner.Weapon) != None )
// 	{
// 		return FALSE;
// 	}
// 
// 	return Super.InternalCanDoSpecialMove();
}

// Don't position players
function PlaceOnMarkers();

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	BS_KillerAnim.Stance.Length = 0;
	BS_VictimAnim.Stance.Length = 0;

	if( PawnOwner.MyGearWeapon != None )
	{
		BS_KillerAnim.Stance.Length = 2; // Array of struct needs to be pre-sized.

		// Set animation to play.
// 		BS_KillerAnim.Stance[0].Slot = BS_Std_Up;
// 		BS_KillerAnim.Stance[0].AnimName = PawnOwner.MyGearWeapon.CQC_Quick_KillerAnim;
// 
// 		BS_KillerAnim.Stance[1].Slot = BS_Std_Idle_Lower;
// 		BS_KillerAnim.Stance[1].AnimName = PawnOwner.MyGearWeapon.CQC_Quick_KillerAnim;

//		PawnOwner.SoundGroup.PlayEffort(PawnOwner, PawnOwner.MyGearWeapon.CQC_Quick_EffortID, true);
	}

	// Set up victim death time.
//	VictimDeathTime = PawnOwner.MyGearWeapon.CQC_Quick_VictimDeathTime;

	Super.SpecialMoveStarted(bForced, PrevMove);
}

function StartInteraction()
{
	// Set execution damage type.
//	ExecutionDamageType = PawnOwner.MyGearWeapon.CQC_Quick_DamageType;

	Super.StartInteraction();
}

defaultproperties
{
	// Let player retain freedom of movement
	bDisableMovement=FALSE
	bLockPawnRotation=FALSE
	bDisableLook=FALSE

	ExecutionDamageType=class'GDT_QuickExecution'

	Action={(
			ActionName=QuickExecution,
			ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.HUD.HUD_ActionIcons2',U=83,V=0,UL=45,VL=32))), // B Button
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=284,V=346,UL=104,VL=91)))	),
	)}
}
