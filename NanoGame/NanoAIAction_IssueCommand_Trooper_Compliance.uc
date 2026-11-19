/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_IssueCommand_Trooper_Compliance extends NanoAIAction_IssueCommand_Base within NanoAI_Trooper;

static function int InternalGetUtility( NanoAIBase InAI )
{
	local NanoPawn EnemyNP;
	local int RetVal;

	if( `TimeSinceEx(InAI, InAI.GetBlackBoard().LastComplianceCommandIssuedToPlayerTime) < 5.f )
	{
		return 0;
	}

	EnemyNP = NanoPawn(InAI.Enemy);
	if( EnemyNP != None && `TimeSinceEx( InAI, EnemyNP.LastWeaponFireTime ) > 5.f )
	{
		RetVal = default.UtilityStartVal + 60;
	}

	return RetVal;
}

function Pushed()
{
	Super.Pushed();

	GetBlackBoard().LastComplianceCommandIssuedToPlayerTime = WorldInfo.TimeSeconds;
}


function PlayIssueCommand()
{
	local bool bDidPlayALine;

	if( Pawn(FireTarget) != None && Pawn(FireTarget).Weapon != None && FRand() < 0.5f )
	{
		bDidPlayALine = NanoGRI(WorldInfo.GRI).AttemptToPlayLine( EDLine_ChallengePlayer_DropYourWeapon, Pawn );
		//GetALocalPlayerController().ClientMessage( "DROP YOUR WEAPON!" ); 
	}
	else
	{
		bDidPlayALine = NanoGRI(WorldInfo.GRI).AttemptToPlayLine( EDLine_ChallengePlayer, Pawn );
		//GetALocalPlayerController().ClientMessage( "BACK OFF CITIZEN!" );  
	}

	// only issue a command if we actually said something
	if( bDidPlayALine == TRUE )
	{
		MyTrooper.DoSpecialMove( 'NSM_Trooper_IssueCommand' );
	}
}


state IssueCommand `DEBUGSTATE
{
Begin:
	`AILog( GetStateName()@"BEGIN TAG" );

	PlayIssueCommand();

	Sleep( 0.1f );

	Goto( 'Begin' );
}



defaultproperties
{
	StartingStateName="IssueCommand"
}