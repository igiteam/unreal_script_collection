/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqEvt_TempestMouthDamage extends SeqEvent_TakeDamage;

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
	return Super.GetObjClassVersion() + 0;
}

/**
 * Block actor from accessing us
 * 
 * @param inOriginator - the actor hit by the damage
 * 
 * @param inInstigator - the actor that instigated the damage
 * 
 * @param inDamageType - the type of damage caused
 * 
 * @param inAmount - the amount of damage caused
 */
function HandleDamage(Actor inOriginator, Actor inInstigator, class<DamageType> inDamageType, int inAmount);

/**
 * Forward mouth damage to the super
 * 
 * @param inOriginator - the actor hit by the damage
 * 
 * @param inInstigator - the actor that instigated the damage
 * 
 * @param inDamageType - the type of damage caused
 * 
 * @param inAmount - the amount of damage caused
 */
function HandleMouthDamage(Actor inOriginator, Actor inInstigator, class<DamageType> inDamageType, int inAmount)
{
	Super.HandleDamage(inOriginator, inInstigator, inDamageType, inAmount);
}

defaultproperties
{
	ObjName="Tempest Take Mouth Damage"
	ObjCategory="Gear"
}