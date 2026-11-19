/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_HolsterWeapon extends SequenceAction;

/** Set to true to put away weapon, false to re-equip weapon */
var() bool bPutAway;

defaultproperties
{
	ObjName="Put Away Weapons"
	ObjCategory="Pawn"

	bPutAway=true
}
