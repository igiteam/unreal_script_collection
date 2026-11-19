/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPRI_SP extends GearPRI;

function int ModifyScore(int Amt, EExperienceBuckets Bucket)
{
	local GearGRI_SP_Arcade GRI;
	local int FinalAmount;

	if (PlayerController(Owner) != None && Bucket != eEXP_Revives)
	{
		// in Arcade mode, handle multiplier
		GRI = GearGRI_SP_Arcade(WorldInfo.GRI);
		if (GRI != None)
		{
			FinalAmount = Amt * GRI.TeamMultiplier;
			if (GearPC(Owner) != None)
			{
				GearPC(Owner).ModifyStat('HighestOneKillScoreArcade', FinalAmount, GEARSTATMODTYPE_Maximum);
			}

			GRI.NotifyPointsAwarded(Amt);
		}
	}
	else
	{
		FinalAmount = Amt;
	}

	return Super.ModifyScore(FinalAmount, Bucket);
}

defaultproperties
{
	SessionName="Game"
}
