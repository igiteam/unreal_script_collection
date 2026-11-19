/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_Trooper_RadioForBackup extends NanoAICmd within NanoAI_Trooper;

var float RadioForBackupDuration;

static function int InternalGetUtility( NanoAIBase InAI )
{
	return 10;
}

function PlayRadioForBackupSound()
{
	local bool bDidPlayALine;

	bDidPlayALine = NanoGRI(WorldInfo.GRI).AttemptToPlayLine( EDLine_Combat_RequestingBackup, Pawn );
	//GetALocalPlayerController().ClientMessage( "RADIO FOR BACKUP" );
	RadioForBackupDuration = 0.5f;

	if( bDidPlayALine == TRUE )
	{
		// do an action like raising hand to head for a call
	}
}

state UseRadio `DEBUGSTATE
{
Begin:
	`AILog( GetStateName()@"BEGIN TAG" );

	PlayRadioForBackupSound();

	Sleep( FMax(RadioForBackupDuration, 0.1f) );

	Goto( 'Begin' );
}


defaultproperties
{
	StartingStateName="UseRadio"
}