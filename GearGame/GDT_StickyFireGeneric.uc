/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * 
 * Damage type for generic sticky fires (i.e. not incendiary grenades).
 */
class GDT_StickyFireGeneric extends GDT_Fire;

/**
 * Called when a Pawn is hurt with this damage type, after the damage has been applied.  Server side only.
 */
static function HandleDamagedPawn(Pawn DamagedPawn, Pawn Instigator, int DamageAmt, vector Momentum)
{
	local GearPawn DamagedGP;
	DamagedGP = GearPawn(DamagedPawn);
	
	// fire damage drops meatbag
	if (DamagedGP != None && DamagedGP.IsAKidnapper())
	{
		DamagedGP.ServerEndSpecialMove(DamagedGP.SpecialMove);
	}

	super.HandleDamagedPawn(DamagedPawn, Instigator, DamageAmt, Momentum);
}


defaultproperties
{
}

