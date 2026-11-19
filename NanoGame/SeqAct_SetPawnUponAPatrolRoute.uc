/**
 * Copyright 1998-2010 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_SetPawnUponAPatrolRoute extends SequenceAction;



/** The AI Actions to give the AI. **/
var array< class<NanoAIAction> > AIActionsToGive;

var() name PatrolRouteNameToUse;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 3;
}

event Activated()
{
	local int Idx;
	local NanoAIBase AI;
	local class<NanoAIAction> AIAction;

	
	for( Idx = 0; Idx < Targets.Length; Idx++ )
	{
		if( NanoPawnBase(Targets[Idx]) != None )
		{
			AI = NanoAIBase(NanoPawnBase(Targets[Idx]).Controller);

			if( AI != None )
			{
				// now add all of the AIActions that we were asked to add
				foreach AIActionsToGive( AIAction )
				{
					AI.ListOfAIActionsThisAICanDo.AddItem( AIAction );
					AI.DesiredPatrolPointName = PatrolRouteNameToUse;
				}
			}
		}
	}

}




defaultproperties
{
	ObjName="Set Pawn Upon A Patrol Route "
	ObjCategory="Nano"

	bCallHandler=FALSE

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="PawnsToModify",PropertyName=Targets)

	AIActionsToGive.Add(class'NanoAIAction_Idle_PatrolARoute')

}








