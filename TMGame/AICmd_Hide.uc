/**
* Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
*/
class AICmd_Hide extends AICommand
	within TGAI_Cover;

var Actor ActorToHideFrom;
var CoverInfo HideCover;
/** GoW global macros */

static function bool InitCommandUserActor( GameAIController AI, Actor UserActor )
{
	local AICmd_Hide Cmd;

	if( AI != None && UserActor != none)
	{
		Cmd = new(TGAI_Cover(AI)) default.class;
		Cmd.ActorToHideFrom = UserActor;
		AI.PushCommand(Cmd);
		return TRUE;
	}

	return FALSE;
}

function Resumed( Name OldCommandName )
{
	Super.Resumed(OldCommandName);

	if( ChildStatus == 'Success' )
	{
		GotoState('RotateTowardHideTarget');
	}
	else
	{
		Status= 'Failure';
		AbortCommand(Self);
	}
}

auto state FindHidePoint
{
Begin:
	// delay slightly before hiding to spread out work
	// as sometimes this is called from an already expensive event like being shot at
	Sleep(0.0);
	if (EvaluateCover(SearchType_Away, ActorToHideFrom, HideCover))
	{
		Focus = None;
		SetMovePoint(HideCover.Link.GetSlotLocation(HideCover.SlotIdx), HideCover.Link);
	}
	else
	{
		GotoState('DelayFailure');
	}
}

state RotateTowardHideTarget
{
Begin:
	//DesiredRotation = Rotator(ActorToHideFrom.Location - Pawn.Location);
	//Pawn.DesiredRotation = DesiredRotation;
	Pawn.SetDesiredRotation( Rotator(ActorToHideFrom.Location - Pawn.Location) );
	FinishRotation();
	Status = 'Success';
	PopCommand(Self);
}

