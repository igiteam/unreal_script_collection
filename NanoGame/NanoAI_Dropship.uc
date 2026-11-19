/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoAI_Dropship extends NanoAI_FlyerHoverBase;


var transient NanoPawn_MetaCorp_Dropship MyDropship;


event Possess(Pawn NewPawn, bool bVehicleTransition)
{
	Super.Possess( NewPawn, bVehicleTransition );
	MyDropship = NanoPawn_MetaCorp_Dropship(NewPawn);
	//MyDropship.MyAI = self;

	//NavigationHandle.bDebugConstraintsAndGoalEvals = TRUE;
	//NavigationHandle.bUltraVerbosePathDebugging = TRUE;

	//class'NanoAICmd_PoliceCar_RiseFromSmog'.static.RiseFromSmog(self);
}




defaultproperties
{

	ListOfAIActionsThisAICanDo.Empty()
	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_Idle_Dropship_PatrolARoute' )
	//ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_ConfrontPossibleThreat_PoliceCar' )

}

