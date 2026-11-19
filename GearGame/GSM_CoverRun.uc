
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_CoverRun extends GearSpecialMove;

function bool CanChainMove(ESpecialMove NextMove)
{
	return NextMove == SM_StdLvlSwatTurn;
}

protected function bool InternalCanDoSpecialMove()
{
	// Make sure weapon allows to roadie run
	if (!PawnOwner.MyGearWeapon.bAllowsRoadieRunning)
	{
		return false;
	}

	// don't allow if not in cover or is leaning or is reloading
	if ( PawnOwner.CoverType == CT_None ||
		PawnOwner.CurrentLink.Slots.Length == 1 ||
		PawnOwner.IsReloadingWeapon() )
	{
		return false;
	}

	return true;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local GearPC PC;
	PC = GearPC(PawnOwner.Controller);
	if (PC != None)
	{
		// silently release the 'A' button to prevent popping out of cover unintentionally
		PC.ForceButtonRelease(PC.bUseAlternateControls ? GB_X : GB_A, true);
		PC.DoubleClickDir = DCLICK_None;
	}
	Super.SpecialMoveEnded(PrevMove, NextMove);
}


defaultproperties
{
	bCanFireWeapon=false
	bDisableMovement=true
	bDeferWeaponSwitch=true
}
