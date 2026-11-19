/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_React_StumbleBack extends AICommand_SpecialMove
	within GearAI;


function Pushed()
{
	Super.Pushed();

	GotoState( 'Command_SpecialMove' );
}
	
state Command_SpecialMove
{
	function ESpecialMove GetSpecialMove()
	{
		return SM_StumbleBackOutOfCover;
	}
}