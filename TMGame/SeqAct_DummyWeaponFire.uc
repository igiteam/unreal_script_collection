/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_DummyWeaponFire extends SeqAct_DummyWeaponFireBase
	native(TGSequence);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

/** Which type of weapon to shoot */
var() class<TGWeapon>	WeaponClass;

/** internal, the temporary weapon we spawn to do the effects */
var	TGWeapon			SpawnedWeapon;

/** internal, time in seconds until next shot fires */
var private float		RemainingFireTime;

/** if TRUE, do not show weapon impact effects */
var() bool				bSuppressImpactFX;

/** if TRUE, does not do damage */
var() bool				bSuppressDamage;

/** If set, will try and find a socket with this name on the Origin Actor and fire from there. */
var() name				OriginSocketName;

/** our replication handler */
var DummyWeaponFireActor ReplicatedActor;

/** Spawns a temporary weapon to do the firing. */
native final function SpawnDummyWeapon(Actor OriginActor, Actor TargetActor);

/** Aligns the dummy weapon such that it's muzzle point is on AlignTo, and is pointing at AimAt. */
native final function AlignWeaponMuzzleToActor(Actor AlignTo, Actor AimAt);

/**
 * Return the version number for this class.  Child classes should increment this method by calling Super then adding
 * a individual class version to the result.  When a class is first created, the number should be 0; each time one of the
 * link arrays is modified (VariableLinks, OutputLinks, InputLinks, etc.), the number that is added to the result of
 * Super.GetObjClassVersion() should be incremented by 1.
 *
 * @return	the version number for this specific class.
 */
static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

