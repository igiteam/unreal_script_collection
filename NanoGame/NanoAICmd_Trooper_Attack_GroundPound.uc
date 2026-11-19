/**
 * AI Command that handles ground pound attack 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_Trooper_Attack_GroundPound extends NanoAICmd_Trooper_Attack_Base within NanoAI_Trooper
	config(AI);


/** This is the name of the animation to use to "pound the ground" **/
var name GroundPoundAnimName;

var transient GroundPoundEffect GPE;

/** AI will stand around this long after the ground pound fires. **/
var config float PostGroundPoundPause;



static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Rating;
	local NanoPawn_MetaCorp_NanoInfantry NP;
	local class<NanoAICmd> TheCmd;


	NP = NanoPawn_MetaCorp_NanoInfantry(InAI.Pawn);
	TheCmd = NP.GetSpecialMeleeMove();
	if( ( NP != None )  
		&& ( TheCmd != None )
		&& ( NP.AbleToDoSpecialMeleeMove() == TRUE ) // this will ask the pawn's timers if we are allowed to do this attack

		// we need to do distance check here to make the ground pound not just always happen
		&& ( VSize( InAI.FireTarget.GetTargetedLocation() - InAI.Pawn.Location) < TheCmd.static.GetAttackRange() )

		)
	{
		Rating = 200;
	}

	return Rating;
}


function Popped()
{ 
	Super.Popped();

	// since we have been popped / attacked we want to clear off any CombatEffectors as we had our chance to to attack and failed
	//ResetCombatEffectors();
	DegradeCombatEffectors();

	NanoPawn_Infantry(Pawn).bDoNoHitReaction = FALSE;

	NanoPawn(Pawn).FullBodySlot.StopCustomAnim( 0.3f );
	SetUseBoidMovement( TRUE );
}



static function float GetAttackRange()
{
	return class'GroundPoundEffect'.default.GroundPoundDamageRadius;
}



state SwingYourWeapon `DEBUGSTATE
{
		
Begin:
	`AILog( GetStateName()@"BEGIN TAG" );



	// NOTE: need to convert this to a special move

	// stop the pawn
	SetUseBoidMovement( FALSE );
	Pawn.ZeroMovementVariables();

	NanoPawn_Infantry(Pawn).bDoNoHitReaction = TRUE;

	// play an anim
	NanoPawn(Pawn).FullBodySlot.PlayCustomAnim( GroundPoundAnimName, 1.0f, 0.1f, 0.1f, TRUE );

	Sleep( 2.0f );

	// play damage effect
	GPE = Spawn( class'GroundPoundEffect', Outer,, Pawn.Location,,, TRUE );
	GPE.DoGroundPoundEffects( Pawn );
	Sleep( 0.250f );  // to help match up the effects and the damage / impulses
	GPE.DoGroundPoundDamage( Pawn );

	NanoPawn(Pawn).FullBodySlot.StopCustomAnim( 0.3f );

	Sleep( PostGroundPoundPause );

	SetUseBoidMovement( TRUE );

	NanoPawn_MetaCorp_NanoInfantry(Pawn).DidSpecialMeleeMove();

	status = 'Success';
	PopCommand( self );
}


defaultproperties
{
	StartingStateName="SwingYourWeapon"

	GroundPoundAnimName="Baton_Attack_Turtle_Break_Swing"
}