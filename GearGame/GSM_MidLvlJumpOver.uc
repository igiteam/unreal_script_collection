
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_MidLvlJumpOver extends GSM_MantleOverCoverBase
	native(SpecialMoves);

/**
 * Allow special moves to delay DBNO until they are complete
 *
 * @return true if DBNO should be delayed
 */
function bool CanDelayDBNO()
{
	return TRUE;
}

protected function bool InternalCanDoSpecialMove()
{
	if( PawnOwner.FindCoverType() != CT_MidLevel )
	{
		return FALSE;
	}

	return Super.InternalCanDoSpecialMove();
}

// Base function to handle mantle over variations.
function INT PackSpecialMoveFlags()
{
	return 0;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced, PrevMove);

	if (PCOwner != None)
	{
		PCOwner.TriggerGearEventDelegates( eGED_Mantle );

		if (PCOwner.Role == ROLE_Authority && LocalPlayer(PCOwner.Player) == None)
		{
			//@hack: force the client to be doing the special move as well to make sure it doesn't pull any tricks on us
			//@FIXME: real issue is that somehow with chaining you can get a super-high mantle that allows falling back on top of the cover
			PCOwner.ServerToClientDoSpecialMove(PawnOwner.FillSMStructFromParams(PawnOwner.SpecialMove, PawnOwner.InteractionPawn, PackSpecialMoveFlags()), true);
		}
	}
}

defaultproperties
{
	bUseUnsynchedServerMove=true
	bCancelIfFailedOnServer=true
}
