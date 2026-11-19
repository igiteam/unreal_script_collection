/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_AISetTarget extends SequenceAction;

/** List of targets to choose from. */
var() array<Actor> FocusTargets;

/** Replace the existing targets? */
var() bool bOverwriteExisting;

/** Force the AI to shoot at the target? */
var() bool bForceFireAtTarget;

/** Force the AI to fire at the target even when we have no LOS? (doesn't mean anythying unless bForceFireAtTarget is also on) */
var() bool bForceFireEvenWhenNoLOS;

/** This Command is for all current squad members */
var() bool bAllSquadMembers;

/** All current (target) squad members are Targets*/
var() bool bTargetSquad;

/** Squad we don't shoot*/
var() array<name> ProhibitedSquadName;

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

