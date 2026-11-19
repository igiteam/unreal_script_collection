/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_Pacifier_Undock extends NanoAICmd;



static final function Undock( GameAIController AI )
{
	local NanoAICmd_Pacifier_Undock Cmd;

	if( AI != None )
	{
		Cmd = new(AI) class'NanoAICmd_Pacifier_Undock';
		if( Cmd != None )
		{
			AI.PushCommand( Cmd );
		}
	}
}

function Pushed()
{
	local NanoPawn_MetaCorp_PacifierBotBase Bot;

	if( Pawn != None )
	{
		Pawn.ZeroMovementVariables();
	}
	GameAIOwner.MoveTimer = -1.f;

	SetTimer( 2.f, FALSE, nameof(CompleteUndock), self );	
	Bot = NanoPawn_MetaCorp_PacifierBotBase(GameAIOwner.Pawn);
	Bot.UndockFromChassis();
}

function CompleteUndock()
{
	PopCommand( self );
}

defaultproperties
{
}