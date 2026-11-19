/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPRI_Siege_Gunner extends GearPRI_Siege;

function int ModifyScore(int Amt, EExperienceBuckets Bucket)
{
	local Pawn P, BaseP;

	// redirect to base vehicle/ridable, if possible
	P = Controller(Owner).Pawn;
	if (P != None)
	{
		BaseP = P.GetVehicleBase();
		if (BaseP == None)
		{
			BaseP = Pawn(P.Base);
		}
		if (BaseP != None && GearPRI(BaseP.PlayerReplicationInfo) != None)
		{
			Amt = GearPRI(BaseP.PlayerReplicationInfo).ModifyScore(Amt, Bucket);
			if (GearPC(BaseP.Controller) != None)
			{
				GearPC(BaseP.Controller).ClientAddKillPoints(Amt);
			}
			Amt = 0;
		}
	}

	return Super.ModifyScore(Amt, Bucket);
}
