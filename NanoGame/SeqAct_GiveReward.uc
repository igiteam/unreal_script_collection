/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_GiveReward extends SequenceAction;


/** This is the reward that we give out for this InteractableComponent **/
var() RewardDatum Reward;



static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}


defaultproperties
{
	ObjName="Give Reward"
	ObjCategory="Nano"
}