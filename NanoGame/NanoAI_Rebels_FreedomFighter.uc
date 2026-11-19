/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAI_Rebels_FreedomFighter extends NanoAI_Trooper;





defaultproperties
{
	ListOfAIActionsThisAICanDo.Empty()

	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_Idle_WaitingToDieDueToDismemberment' )
	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_ConfrontPossibleThreat_MoveDirectlyToward' )

	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_EngageThreat_Trooper_Melee' )
	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_EngageThreat_Trooper_Ranged' )

}

