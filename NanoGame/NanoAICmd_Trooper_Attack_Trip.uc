/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_Trooper_Attack_Trip extends NanoAICmd_Trooper_Attack_Base within NanoAI_Trooper
	config(AI);


var config float MinTripDistance;

var config float MinTimeBetweenTripAttacks;

var config float SpeedRquiredToTrip;

static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Rating;
	local NanoPawn_MetaCorp_NanoInfantry NP;

	//`log( `showvar(VSize( InAI.FireTarget.GetTargetedLocation() - InAI.Pawn.Location)) @ `showvar(GetAttackRange()) );

	NP = NanoPawn_MetaCorp_NanoInfantry(InAI.Pawn);
	if( ( NP != None )  
		// we need to do distance check here to make the ground pound not just always happen
		&& ( VSize( InAI.FireTarget.GetTargetedLocation() - InAI.Pawn.Location) < GetAttackRange() )
		&& ( ( NanoGRI(InAI.WorldInfo.GRI).NED.IsPlayerDoing( 'Moving' ) == TRUE ) || ( NanoGRI(InAI.WorldInfo.GRI).NED.IsPlayerDoing( 'Escaping' ) == TRUE ) )
		&& ( `TimeSinceEx(InAI, NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).AIBlackboard.LastTripAttackTime) > default.MinTimeBetweenTripAttacks)
		&& ( VSize( InAI.FireTarget.GetVelocity()) > default.SpeedRquiredToTrip ) // only if we are actually running
		)
	{
		//`log( "TRIPPPING" );
		Rating = 210;
	}

	return Rating;
}

static function float GetAttackRange()
{
	return default.MinTripDistance;
}



state TripAttack `DEBUGSTATE
{

Begin:
	`AILog( GetStateName()@"BEGIN TAG" );

	//`log( "TRIP ATTACK!" );

	// need to add a way for a NanoInterface_Targetable to "pass through" special moves"
	NanoPawn(Enemy).DoSpecialMove( 'NSM_Tripped', TRUE );
	GetAIBlackboard().LastTripAttackTime = WorldInfo.TimeSeconds;


	status = 'Success';
	PopCommand( self );

}








DefaultProperties
{
	StartingStateName="TripAttack"
}
