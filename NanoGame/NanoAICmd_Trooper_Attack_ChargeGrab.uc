/**
 * AI Command that will charge the player and then grab them 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_Trooper_Attack_ChargeGrab extends NanoAICmd_Trooper_Attack_ChargeBase within NanoAI_Trooper
	config(AI);

function Popped()
{
	Super.Popped();
}

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

	while( ( IsInAttackRange( Outer ) == FALSE )
		)
	{
		`AILog( "ChargeGrab running to the target!" @ `showvar(VSize(Pawn.Location - FireTarget.GetTargetedLocation())) @ `showvar(Outer.ConfrontationType));
		//`log( "ChargeAttack running to the target!" );
		Sleep( 0.1f );
	}

	// turn off boids as we are about to attack
	HandleBoidAlteringEvent( 'WaitingForAttackToFinish', FALSE );

	NanoPawn(Pawn).TopHalfSlot.StopCustomAnim( 0.2f );


	//`log( "ATTACKING!!" );

	// we probably want to change this to just use the specialized   Baton_Attack_B_Strike  so it is faster
	class'NanoAICmd_Trooper_Attack_Grab'.static.Grab( Outer, TRUE );

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
}