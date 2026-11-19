/**
 * AI Command that handles melee attack loop of trooper 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_Trooper_Attack_BreakOut extends NanoAICmd_Trooper_Attack_Base within NanoAI_Trooper
	config(AI);

static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Rating;

	if( IsInAttackRange( InAI ) == TRUE )
	{
		`AILog_Ext( GetFuncName() @ `showvar(InAI) @ `showvar(IsInAttackRange( InAI )) @ "Probably going to attack!",, InAI );
		Rating = 205;
	}

	return Rating;
}

function Popped()
{ 
	Super.Popped();

	// since we have been popped / attacked we want to clear off any CombatEffectors as we had our chance to to attack and failed
	//ResetCombatEffectors();
	//DegradeCombatEffectors();
}

state BreakOut `DEBUGSTATE
{
		
Begin:
	`AILog( GetStateName()@"BEGIN TAG" );

	`log( "RARARA DOING BREAKOUT!" );

	// needs to stop movement also prob
	NanoPawn(Pawn).DoSpecialMove( 'NSM_Melee_BreakOut', TRUE );

	// need to add a way for a NanoInterface_Targetable to "pass through" special moves"
	NanoPawn(Enemy).DoSpecialMove( 'NSM_Evade_Jump_Back', TRUE );

	status = 'Success';
	PopCommand( self );
}

defaultproperties
{
	StartingStateName="BreakOut"
}