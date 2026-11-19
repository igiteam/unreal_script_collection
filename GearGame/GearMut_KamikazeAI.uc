/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearMut_KamikazeAI extends GearMutator;

/** replaces the AI's melee reaction with one that will always trigger on the impulse */
final function ReplaceMeleeReaction(GearAI AI)
{
	local int i;
	local bool bWasSubscribed;
	local AIReactCond_EnemyCanBeMeleed_Kamikaze NewReact;

	for (i = 0; i < AI.DefaultReactConditions.length; i++)
	{
		if (AIReactCond_EnemyCanBeMeleed(AI.DefaultReactConditions[i]) != None)
		{
			bWasSubscribed = AI.DefaultReactConditions[i].SubscribedChannels.length > 0;
			if (bWasSubscribed)
			{
				AI.DefaultReactConditions[i].UnSubscribeAll();
			}
			NewReact = new(AI) class'AIReactCond_EnemyCanBeMeleed_Kamikaze';
			NewReact.OutputFunction = AIReactCond_Conduit_Base(AI.DefaultReactConditions[i]).OutputFunction;
			AI.DefaultReactConditions[i] = NewReact;
			if (bWasSubscribed)
			{
				AI.DefaultReactConditions[i].Initialize();
			}
		}
	}
}

function bool CheckReplacement(Actor Other)
{
	local GearAI AI;

	AI = GearAI(Other);
	if (AI != None)
	{
		ReplaceMeleeReaction(AI);
	}

	return true;
}

function PostBeginPlay()
{
	local GearAI AI;

	Super.PostBeginPlay();

	// check for any AI that were already in the world
	foreach WorldInfo.AllControllers(class'GearAI', AI)
	{
		ReplaceMeleeReaction(AI);
	}
}

function ModifyAIEnemyDistances(GearAI AI)
{
	Super.ModifyAIEnemyDistances(AI);

	// make the AI send the melee charge impulse for any reasonable melee opportunity
	AI.EnemyDistance_MeleeCharge = 2500;
}
