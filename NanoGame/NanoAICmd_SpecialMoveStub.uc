/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_SpecialMoveStub extends NanoAICmd;

var() transient Name SpecialMove;
var() transient NanoPawn MyNP;

function bool AllowPushOfDefaultCommandForSpecialMove( Name SM )
{
	return TRUE;
}
		
static function NanoAICmd_SpecialMoveStub PushSpecialMoveCommand( NanoAI AI )
{
	local NanoAICmd_SpecialMoveStub Cmd;

	if( AI != None && AI.Pawn != None )
	{
		Cmd = new(AI) default.class;
		if( Cmd != None )
		{
			Cmd.SpecialMove = NanoPawn(AI.Pawn).ActiveSpecialMoveName;
			AI.PushCommand(Cmd);
			return Cmd;
		}
	}

	return None;
}

/** Build debug string */
event String GetDumpString()
{
	return Super.GetDumpString();
}

event String GetDebugVerboseText()
{
	return Super.GetDebugVerboseText()@String(SpecialMove);
}


function Pushed()
{
	Super.Pushed();

	MyNP = NanoPawn(Pawn);
	bPreparingMove = TRUE;

	GotoState('WaitForMove');
}

function Popped()
{
//	ClearTimer( 'SpecialMoveTimeout', self );
	Super.Popped();

	bPreparingMove = FALSE;
}

state WaitForMove `DEBUGSTATE
{
	function bool IsSpecialMoveComplete()
	{
		if( !bPreparingMove || MyNP == None || MyNP.ActiveSpecialMoveName != SpecialMove )
		{
			return TRUE;
		}
		return FALSE;
	}
	
Begin:
//	SetTimer( TimeOutDelaySeconds, FALSE, nameof(self.SpecialMoveTimeOut), self );
	do
	{
		Sleep(0.1f);
	} until( IsSpecialMoveComplete() );
	
	`AILog("bPreparingMove:" @ bPreparingMove @ "MyNP:" @ MyNP @ "SpecialMove:" @ MyNP.ActiveSpecialMoveName @ SpecialMove);
	Status = 'Success';
	PopCommand( self );
}

defaultproperties
{
	bAllowNewSameClassInstance=TRUE
	bReplaceActiveSameClassInstance=TRUE
	bIgnoreNotifies=TRUE
}