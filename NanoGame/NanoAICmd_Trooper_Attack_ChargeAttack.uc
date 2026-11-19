/**
 * AI Command that will charge the player and then attack them 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_Trooper_Attack_ChargeAttack extends NanoAICmd_Trooper_Attack_ChargeBase within NanoAI_Trooper
	config(AI);


var transient float StartOfChargeAttackTime;

var private string MyUtilityStringOverride;

state ChargeAttack `DEBUGSTATE
{
	function BeginState( Name PrevStateName )
	{
		Super.BeginState( PrevStateName );

		NanoPawn(Pawn).TopHalfSlot.PlayCustomAnim( 'Baton_Attack_B_Start', 1.f, 0.2f, 0.2f );		
	}

	 

Begin:

	`AILog( GetFuncName() @ "BEGIN" );
	// blahhh this needs to be pushed out to a shared state in the base class


	//`log( "AAAIIEEE GONING TO CHARGE ATTACK" );
	// scream a charge sound here?
	Sleep( 1.0f );

	NanoPawn(Pawn).TopHalfSlot.PlayCustomAnim( 'Baton_Attack_B_Loop', 1.f, 0.2f, 0.2f );

	// turn on boids as we are chasing the target
	HandleBoidAlteringEvent( 'WaitingForAttackToFinish', TRUE );


  	// Setting this bool makes the ModifyPawnVelocity if( bAvoidTeammates ) check not pass so 
	// that this pawn will barrel through.  His teammates should then move out of the way as 
	// they will be bAvoidTeammates from the melee boid rule.
	ModifyActiveBoidMovement_AvoidTeammates( FALSE );

	StartOfChargeAttackTime = WorldInfo.TimeSeconds;

	while( ( IsInAttackRange( Outer ) == FALSE )
		&& ( `TimeSince( StartOfChargeAttackTime < 5.0f ) )
		)
	{
		`AILog( "ChargeAttack running to the target!" @ `showvar(VSize(Pawn.Location - FireTarget.GetTargetedLocation())) @ `showvar(Outer.ConfrontationType));
		Sleep( 0.1f );
	}

	// turn off boids as we are about to attack
	HandleBoidAlteringEvent( 'WaitingForAttackToFinish', FALSE );

	NanoPawn(Pawn).TopHalfSlot.StopCustomAnim( 0.2f );


	//`log( "ATTACKING!!" );

	if( IsInAttackRange( Outer ) == TRUE )
	{
		// we probably want to change this to just use the specialized   Baton_Attack_B_Strike  so it is faster
		class'NanoAICmd_Trooper_Attack_Melee'.static.Activate( Outer, MyUtilityStringOverride );
	}
	else
	{
		`AILog( "ChargeAttack Failed to get close enough to the enemy" @ `showvar(VSize(Pawn.Location - FireTarget.GetTargetedLocation())) );
	}


	// restore the boids movement
	HandleBoidAlteringEvent( 'WaitingForAttackToFinish', TRUE );
	ModifyActiveBoidMovement_AvoidTeammates( TRUE );

	// return back to our AIAction
	Status = 'Success';
	PopCommand( self );
}


defaultproperties
{
	StartingStateName="ChargeAttack"

	MyUtilityStringOverride="Continuation of charge attack.  We do a Melee attack at the end"
}