/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_Drudge_Execute extends AICmd_Execute
	within GearAI_LambentDrudge;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool Execute( GearAI AI, GearPawn NewExecuteTarget )
{
	local AICmd_Execute OtherCmd, Cmd;
	local GearAI_LambentDrudge DrudgeAI;

	DrudgeAI = GearAI_LambentDrudge(AI);
	if( DrudgeAI != None &&
		NewExecuteTarget != None &&
		DrudgeAI.CanExecutePawn( NewExecuteTarget ) )
	{
		OtherCmd = DrudgeAI.FindCommandOfClass(class'AICmd_Execute');
		if( OtherCmd == None || OtherCmd.ExecuteTarget != NewExecuteTarget )
		{
			Cmd = new(DrudgeAI) class'AICmd_Drudge_Execute';
			if( Cmd != None )
			{
			    Cmd.ExecuteTarget = NewExecuteTarget;
			    DrudgeAI.PushCommand(Cmd);
			    return TRUE;
			}
		}
	}

	return FALSE;
}

function Pushed()
{
	MyGearPawn.InteractionPawn = ExecuteTarget;
	Super.Pushed();
	Outer.PauseAttack();
	ReactionManager.SuppressAll();
}

function Popped()
{
	Super.Popped();
	Outer.ResumeAttack();
	ReactionManager.UnSuppressAll();
}

state Command_SpecialMove
{
	function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );

		StopFiring();

		// Face the target if legs are not mutated
		if( !bMutatedLegs )
		{
			SetDesiredRotation(Rotator(ExecuteTarget.Location-Pawn.Location));
		}
		Focus = ExecuteTarget;
	}

	// Turn to face the target before doing the special move
	function bool ShouldFinishRotation() 
	{ 
		return !Outer.bMutatedLegs; 
	}

	function ESpecialMove GetSpecialMove()
	{
		// for now prefer arms
		if( Outer.bMutatedArms )
		{	
			return GSM_Drudge_ExecutionArms;
		}
		else if( Outer.bMutatedHead )
		{
			return GSM_Drudge_ExecutionHead;
		}

		return GSM_Drudge_ExecutionArms;
	}
}