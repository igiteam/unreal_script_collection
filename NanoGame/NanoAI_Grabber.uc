/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAI_Grabber extends NanoAI_Trooper
	config(AI);



// need to change this to be grab only

defaultproperties
{
	ListOfAIActionsThisAICanDo.Empty()

	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_Idle_PatrolARoute' )
	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_Idle_StandAround' )
	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_Idle_WaitingForCinematicModeToEnd' )
	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_Idle_WaitingForReinforcementWave' )
	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_Idle_WaitingToDieDueToDismemberment' )

	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_ConfrontPossibleThreat_MoveDirectlyToward' )

	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_EngageThreat_Grabber_Melee' )

	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_RunAway_Flee' )

}

