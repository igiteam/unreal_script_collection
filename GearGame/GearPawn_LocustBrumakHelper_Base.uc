/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
**/
class GearPawn_LocustBrumakHelper_Base extends GearPawn
	abstract
	native(Pawn);

cpptext
{
	virtual UBOOL IsAliveAndWell() const
	{
		return (!bDeleteMe);
	}
};

simulated function BuildScriptAnimSetList()
{
	Super(Pawn).BuildScriptAnimSetList();
}

simulated function PlayWeaponSwitch(Weapon OldWeapon, Weapon NewWeapon)
{
	MyGearWeapon = GearWeapon(Weapon);
	AttachWeapon();
}

simulated event bool RestoreAnimSetsToDefault()
{
	return TRUE;
}

simulated native event Vector GetPawnViewLocation();

defaultproperties
{
	bTranslateMeshByCollisionHeight=FALSE
	bNotSpottable=TRUE
}
