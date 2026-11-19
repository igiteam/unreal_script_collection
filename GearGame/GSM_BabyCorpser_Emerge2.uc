
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_BabyCorpser_Emerge2 extends GSM_Emerge;


/** Overloaded to get the materials working */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearPawn_LocustBabyCorpserBase BabyCorpser;

	BabyCorpser = GearPawn_LocustBabyCorpserBase(PawnOwner);
	if (BabyCorpser != None)
	{
		BabyCorpser.InitEmergeMaterials();
	}

	Super.SpecialMoveStarted(bForced,PrevMove);
}

defaultproperties
{
	StanceArray(0)=(Stance=((Slot=BS_FullBody,AnimName="emerge_from_egg")))
	StanceArray(1)=(Stance=((Slot=BS_FullBody,AnimName="emerge_from_egg_b")))
}
