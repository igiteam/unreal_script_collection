/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_AIStateTransition extends SequenceAction;

enum ETransitionStates
{
	TS_AIControlled,
	TS_Idle,
	TS_Alert,
	TS_Combat_Ranged,
	TS_Combat_Melee,
	TS_Patrol,
};
var() ETransitionStates DesiredState;


/** Whether or not this AI should attack players without weapons visible **/
var bool bShouldAttackPlayersWithoutWeaponsVisible;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}



defaultproperties
{
	ObjName="AI State Transition"
	ObjCategory="AI"
}
