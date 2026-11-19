
/**
 * Silverback version of the Roadie Run
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Silverback_RoadieRun extends GSM_RoadieRun;

/**
 * Don't allow running while overheated
 * 
 * @return TRUE if the special move can be executed
 */
protected function bool InternalCanDoSpecialMove()
{
	local GearPawn_SilverbackArmedBase ArmedSB;

	ArmedSB = GearPawn_SilverbackArmedBase(PawnOwner);
	if( ArmedSB != None && ArmedSB.IsOverheated() )
	{
		return FALSE;
	}

	return Super.InternalCanDoSpecialMove();
}