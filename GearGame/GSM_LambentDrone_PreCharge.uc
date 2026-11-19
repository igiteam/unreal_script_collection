
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_LambentDrone_PreCharge extends GSM_BasePlaySingleAnim;

var array<GearPawn.BodyStance> BS_Anims;

function float PlayMyAnim()
{
	local int BSIdx;

	BSIdx = Rand(BS_Anims.length);
	BS_Animation = BS_Anims[BSIdx];
	return PawnOwner.BS_Play(BS_Animation, SpeedModifier, BlendInTime/SpeedModifier, BlendOutTime/SpeedModifier, FALSE);
}
defaultproperties
{
	BS_Anims(0)=(Stance=((Slot=BS_FullBody,AnimName="Idle2Charge")))
	BS_Anims(1)=(Stance=((Slot=BS_FullBody,AnimName="idle2_charge_short")))
	bLockPawnRotation=TRUE
}
