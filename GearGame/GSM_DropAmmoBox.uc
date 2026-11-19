
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_DropAmmoBox extends GSM_BasePlaySingleAnim;

/** Notification forwarded by GearAnimNotify_SpecialMove */
function AnimNotify(AnimNodeSequence SeqNode, GearAnimNotify_SpecialMove NotifyObject)
{
	local GearAI GAI;
	
	GAI = GearAI(PawnOwner.Controller);
	if (GAI != none)
	{
		GAI.SelectWeapon(TRUE);
	}

	// client won't have AI, so will pass this along
	// client also doesn't have weapon
	PawnOwner.PlaySound(class'GearWeap_BoxBase'.default.SeeEnemySound);
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="AmmoBox_Drop")))
	BlendInTime=0.1
	BlendOutTime=0.1
}
