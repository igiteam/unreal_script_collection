/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_Trooper_ReactToGunBeingAimedAt extends NanoAIAction_IssueCommand_Base within NanoAI_Trooper
	config(AI);


var config float HowOftenWeShouldHaveReaction;

var array<name> MovesToPossiblyDo;


/** 
 * So we just keep track of the time we were aimed at on our Pawn.  So we have some duration from that last occurring to determine
 * if we are actually being aimed at.
 **/
var float TimeSinceLastAimedAtToCountAsBeingAimedAt;


static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;


	// need to add a min distance to this also otherwise guys that are close are "always being" aimed at an reactin
	// and never get to do their attacks

	return 0;

	if( `TimeSinceEx(InAI, InAI.GetBlackBoard().LastReactToGunBeingAimedAt) < default.HowOftenWeShouldHaveReaction )
	{
		return 0;
	}


	// check to see if we are being aimed at
	if( `TimeSinceEx(InAI, NanoPawn_MetaCorpBase(InAI.Pawn).LastTimeBeingAimedAt) < default.TimeSinceLastAimedAtToCountAsBeingAimedAt )
	{
		`log( "Being aimed at:" @ InAI.Pawn @ NanoPawn_MetaCorpBase(InAI.Pawn).LastTimeBeingAimedAt );
		Retval += 200;
	}


	if( Retval > 0 )
	{
		Retval += default.UtilityStartVal;
	}

	
	return Retval;
}

function Pushed()
{
	local Name NSMToDo;

	Super.Pushed();

	GetBlackBoard().LastReactToGunBeingAimedAt = WorldInfo.TimeSeconds;

	
	NSMToDo = MovesToPossiblyDo[ Rand( MovesToPossiblyDo.Length) ];

	NanoPawn(Pawn).DoSpecialMove( NSMToDo, TRUE );

	//`log( "Being aimed At" @ Pawn @ `showvar(NSMToDo) );
}



defaultproperties
{
	TimeSinceLastAimedAtToCountAsBeingAimedAt=0.100f;


	MovesToPossiblyDo.Add( "NSM_BeingAimedAt_Cower" )
	MovesToPossiblyDo.Add( "NSM_Evade_Fwd" )
	MovesToPossiblyDo.Add( "NSM_BeingAimedAt_JumpBack" )
	MovesToPossiblyDo.Add( "NSM_BeingAimedAt_Panic" )
	MovesToPossiblyDo.Add( "NSM_BeingAimedAt_Taunt" )
	MovesToPossiblyDo.Add( "NSM_BeingAimedAt_ThrowGunThrowHandsUp" )


}