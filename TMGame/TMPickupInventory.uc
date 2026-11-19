/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
//=============================================================================
// TMPickupInventory:
// This class is used to redirect
// queries normally made to an inventory class to the associated TMItemPickupFactory
//=============================================================================
class TMPickupInventory extends TMInventory;


static function float BotDesireability(Actor PickupHolder, Pawn P, Controller C)
{
	local TMItemPickupFactory F;
	local TMDroppedItemPickup D;

	F = TMItemPickupFactory(PickupHolder);

	if (F != None)
	{
		return F.BotDesireability(P, C);
	}
	else
	{
		D = TMDroppedItemPickup(PickupHolder);
		if (D != None)
		{
			return D.BotDesireability(P, C);
		}
		else
		{
			return 0.0;
		}
	}
}

