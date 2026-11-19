/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_React_JackRecoil extends AICommand
	within GearAI_Jack;
	
static function bool Recoil( GearAI_Jack AI )
{
	local AICmd_React_JackRecoil Cmd;

	if( AI != None )
	{
		Cmd = new(AI) class'AICmd_React_JackRecoil';
		if( Cmd != None )
		{
			AI.PushCommand( Cmd );
			return TRUE;
		}
	}
	return FALSE;
}

function Pushed()
{
	Super.Pushed();

	Pawn.ZeroMovementVariables();
	
	GotoState( 'Recoiling' );
}

function Popped()
{
	Super.Popped();

	ReachedMoveGoal();
}

state Recoiling `DEBUGSTATE
{
Begin:
	//debug
	`AILog( "BEGIN TAG"@Jack.bRecoil );

	do
	{
		Sleep( 0.1f );
	}	until( !Jack.bRecoil );

	Status = 'Success';
	PopCommand( self );
}

defaultproperties
{

}

