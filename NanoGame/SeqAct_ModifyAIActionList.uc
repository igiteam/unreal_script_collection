/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ModifyAIActionList extends SequenceAction;


/** Whether or not we should empty out the AI action list before we we give this new action to the AI. **/
var() bool bEmptyAIActionListBeforeGiving;

/** The AI Actions to give the AI. **/
var() array< class<NanoAIAction> > AIActionsToGive;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
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
				// if we should empty the list out then do so
				if( bEmptyAIActionListBeforeGiving == TRUE )
				{
					AI.ListOfAIActionsThisAICanDo.Length = 0;
				}

				// now add all of the AIActions that we were asked to add
				foreach AIActionsToGive( AIAction )
				{
					AI.ListOfAIActionsThisAICanDo.AddItem( AIAction );
				}
			}
		}
	}

}




defaultproperties
{
	ObjName="Modify AI ActionList"
	ObjCategory="Nano"

	bCallHandler=FALSE

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="PawnsToModify",PropertyName=Targets)


	bEmptyAIActionListBeforeGiving=TRUE
}



