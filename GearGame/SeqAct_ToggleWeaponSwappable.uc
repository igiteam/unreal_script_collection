/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */


class SeqAct_ToggleWeaponSwappable extends SequenceAction;

var() array<class<GearWeapon> > WeaponTypes;

defaultproperties
{
	ObjName="Toggle Weapon Swappable"
	ObjCategory="Toggle"
	
	InputLinks(0)=(LinkDesc="Allow Swap")
	InputLinks(1)=(LinkDesc="Disallow Swap")
}