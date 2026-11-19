/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Berserker_Alert extends GearSpecialMove;

/**
 * Can the special move be chained after the current one finishes?
 */
function bool CanChainMove(ESpecialMove NextMove)
{
	return (NextMove == SM_MidLvlJumpOver);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearPawn_LocustBerserkerLambentBase BerserkerPawn;

	Super.SpecialMoveStarted(bForced,PrevMove);

	// Make SURE the chest has closed (if certain anims are aborted the chest could remain open)
	BerserkerPawn = GearPawn_LocustBerserkerLambentBase(PawnOwner);
	if (BerserkerPawn != None)
	{
		BerserkerPawn.ForceChestClose();
	}
}

defaultproperties
{
	bRestoreMovementAfterMove=FALSE
}
