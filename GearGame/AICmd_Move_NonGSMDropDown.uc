/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Move_NonGSMDropDown extends AICommand
	within GearAI;

var vector DropDownMoveDest;
/** Simple constructor that pushes a new instance of the command for the AI */
static function bool FallOffDropDown( GearAI AI, vector InMoveDest )
{
	local AICmd_Move_NonGSMDropDown Cmd;

	if( AI != None )
	{
		Cmd = new(AI) class'AICmd_Move_NonGSMDropDown';
		if( Cmd != None )
		{
			Cmd.DropDownMoveDest = InMoveDest;
			AI.PushCommand( Cmd );
			return TRUE;
		}
	}

	return FALSE;
}

function Pushed()
{
	Super.Pushed();

	SetDesiredRotation(Pawn.Rotation);

	GotoState( 'WalkOffLedge' );

}

function Popped()
{
	Super.Popped();
}

state WalkOffLedge
{
	function vector GetMoveLocation()
	{
		return DropDownMoveDest;
	}
Begin:
	MoveTo(GetMoveLocation(),none,0.f,false);
	GotoState('DelaySuccess');
}


defaultproperties
{
}
