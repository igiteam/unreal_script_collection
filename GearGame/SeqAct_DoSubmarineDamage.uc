/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class SeqAct_DoSubmarineDamage extends SequenceAction;


/** The actor who did the damage to the submarine or pod */
var Actor Instigator;

/** Amount of damage to do to the submarine or pod */
var() float Damage;

/** The pod index to apply the damage to (if set to 0, will do damage to all pods) */
var() int PodIndex;

/** The kind of damage to give to the submarine */
var() class<GearDamageType> DamageType;

/** Resets health for a pod or all pods, depending on PodIndex (This is counter-intuitive since the name of this action is DoSubmarineDamage, but it's better than making a new action :) ) */
var() bool bResetHealth;

/** Enum of the input actions that can be fired for this action */
enum GearSubmarineActions
{
	GSA_TurretHealth,
	GSA_WeaponOn,
	GSA_WeaponOff,
	GSA_SpotlightOn,
	GSA_SpotlightOff,
};

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

defaultproperties
{
	ObjName="Manage Submarine"
	ObjCategory="Gear"

	InputLinks(GSA_TurretHealth)=(LinkDesc="Turret Health")
	InputLinks(GSA_WeaponOn)=(LinkDesc="Weapon On")
	InputLinks(GSA_WeaponOff)=(LinkDesc="Weapon Off")
	InputLinks(GSA_SpotlightOn)=(LinkDesc="Spotlight On")
	InputLinks(GSA_SpotlightOff)=(LinkDesc="Spotlight Off")

	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Instigator",PropertyName=Instigator)
}
