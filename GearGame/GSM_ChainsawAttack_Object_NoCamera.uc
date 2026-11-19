/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_ChainsawAttack_Object_NoCamera extends GSM_ChainsawAttack_Object;

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="AR_Melee_Saw_A")))
	BlendInTime=0.25
	BlendOutTime=0.25

	SpecialMoveCameraBoneAnims.Empty

	bShouldAbortWeaponReload=TRUE
	bCanFireWeapon=FALSE
	bDisableMovement=TRUE
	bDisableLook=TRUE
	bLockPawnRotation=TRUE
}
