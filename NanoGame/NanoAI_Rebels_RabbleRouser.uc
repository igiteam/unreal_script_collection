/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAI_Rebels_RabbleRouser extends NanoAI;


var transient vector LocationToRabbleRouse;


defaultproperties
{
	ListOfAIActionsThisAICanDo.Empty()
	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_Idle_Rebels_CauseRabble' )

}