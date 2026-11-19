/**
 * NanoMissiontReward
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoMissionRewardBase extends Object
	config(Weapon)
	editinlinenew
	hidecategories(Object)	
	abstract;


/** This will do the reward for this QuestReward**/
simulated function DoReward( NanoPawn NP );


defaultproperties
{

}