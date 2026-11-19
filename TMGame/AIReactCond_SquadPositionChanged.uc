/**
* Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
*/
class AIReactCond_SquadPositionChanged extends AIReactCondition_base
	within TGAI;

var Actor	CurrentSquadPosition;


static function AIReactCond_SquadPositionChanged AbortMoveWhenSquadPositionChanges(TGAI AI, Actor InCurrentSquadPosition)
{
	local AIReactCond_SquadPositionChanged Reaction;

	Reaction = new(AI) class'AIReactCond_SquadPositionChanged';
	if(Reaction != none)
	{
		Reaction.CurrentSquadPosition = InCurrentSquadPosition;
		;
		Reaction.Initialize();
	}
	else
	{
		;
	}

	return Reaction;
}



event bool ShouldActivate( Actor EventInstigator, AIReactChannel OrigChan )
{
	local Actor NewSquadPosition;

	if (!Super.ShouldActivate(EventInstigator,OrigChan) || (MyTGPawn != None && MyTGPawn.IsDoingSpecialMove(SM_MidLvlJumpOver)))
	{
		return false;
	}

	NewSquadPosition = GetSquadPosition();
	if( bMovingToSquadLeader && NewSquadPosition != CurrentSquadPosition &&
		NewSquadPosition != none)
	{
		;
		return true;
	}


	return false;
}

event Activate( Actor EventInstigator, AIReactChannel OriginatingChannel )
{
	Super.Activate(EventInstigator,OriginatingChannel);
	;
	AbortCommand(none,class'AICmd_MoveToSquadLeader');
	class'AICmd_MoveToSquadLeader'.static.MoveToSquadLeader(outer);
}


