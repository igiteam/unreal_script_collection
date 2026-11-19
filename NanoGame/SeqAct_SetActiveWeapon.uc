/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_SetActiveWeapon extends SequenceAction;

/** Weapon to summon / activate on the targeted player */
var() class<NanoWeapon> WeaponClass;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 0;
}

defaultproperties
{
	ObjName="Set Active Weapon"
	ObjCategory="Nano"
	bCallHandler=TRUE
}
