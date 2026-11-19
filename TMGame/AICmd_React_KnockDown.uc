/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_React_KnockDown extends AICommand;

/** GoW global macros */


function Pushed()
{
	Super.Pushed();

	ReactionManager.SuppressAll();
	GotoState( 'WaitForRecovery' );	
}

function Popped()
{
	local float Dist;
	local NavigationPoint FoundAnchor;
	Super.Popped();
	ReactionManager.UnSuppressAll();

	// check to see if we have a valid anchor after recovery.. if not kill ourselllllllllllves!
	if(!Pawn.ValidAnchor())
	{
		FoundAnchor = Pawn.GetBestAnchor(Pawn,Pawn.Location,FALSE,FALSE,Dist);
		Pawn.SetAnchor(FoundAnchor);

		if(FoundAnchor == none)
		{
			;
			Pawn.Died(outer,class'GDT_ScriptedRagdoll',Pawn.Location);
		}
	}
}

function bool AllowTransitionTo( class<GameAICommand> AttemptCommand )
{
	return false;
}

state WaitForRecovery
{
Begin:
	// wait for the ragdoll to settle
	do
	{
		Sleep(0.1f);
		
	} until (!Pawn.IsInState('KnockedDown'));

	;
	PopCommand(Self);
}
	
