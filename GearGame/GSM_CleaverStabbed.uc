/**
 * Animation played when stuck with a cleaver from the front before going DBNO.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_CleaverStabbed extends GearSpecialMove
	config(Pawn);


/** Don't get cleaver stabbed while DBNO */
protected function bool InternalCanDoSpecialMove()
{
	return (!PawnOwner.IsAHostage() && !PawnOwner.IsDBNO() && Super.InternalCanDoSpecialMove());
}

/**
 * Allow special moves to delay DBNO until they are complete
 * 
 * @return true if DBNO should be delayed
 */
function bool CanDelayDBNO()
{
	return TRUE;
}

/**
 * Event called when Special Move is started.
 */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	PawnOwner.EndSpecialMove();
	Super.SpecialMoveStarted( bForced, PrevMove );
}
