/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_React_StumbleDown extends AICommand_SpecialMove
	within TGAI;

/** Stumble caused by default (0), explosion (1), close range shot (2)? */
var int DownFromType;

var() float KnockDownDuration;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool StumbleDown( TGAI AI, optional int NewDownFromType )
{
	local AICmd_React_StumbleDown Cmd;

	if( AI != None )
	{
		Cmd = new(AI) class'AICmd_React_StumbleDown';
		if( Cmd != None )
		{
			Cmd.DownFromType = NewDownFromType;
			
			AI.PushCommand( Cmd );
			return TRUE;
		}
	}

	return FALSE;
}

function Pushed()
{
	SetDesiredRotation(Pawn.Rotation);

	Super.Pushed();

	GotoState( 'Command_SpecialMove' );
}
	
state Command_SpecialMove
{
	function bool ShouldFinishRotation() { return TRUE; }

	function bool ExecuteSpecialMove()
	{
		
		if(DownFromType != 1)
		{
			//`log("AICmd_React_StumbleDown"@KnockDownDuration);
			MyTGPawn.SetTimer( KnockDownDuration, FALSE, nameof(MyTGPawn.GetBackUpFromKnockDown) );
		}
		return Super.ExecuteSpecialMove();
		
	}

	function ESpecialMove GetSpecialMove()
	{
		switch( DownFromType )
		{
			case 1:
				return SM_StumbleGoDownFromCloseRangeShot;
				break;

		}	

		//Default
		return SM_StumbleGoDown;
	}
}

