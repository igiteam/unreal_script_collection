/**
 * AI Command that handles melee attack loop of trooper 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_Trooper_Attack_Melee extends NanoAICmd_Trooper_Attack_Base within NanoAI_Trooper
	config(AI);

static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Rating;
	local FiringTargetableDatum FTD;

	InAI.FireTarget.GetFiringTargetableDatum( FTD );

	// don't attack if the target is stunned
	if( FTD.bIsTeslaShockStunned == TRUE )
	{
		//`log( "Don't attack! bIsTeslaShockStunned" );
		return 0;
	}

	// ughh we have to short circuit the AmIAllowedToAttack() call here as that as all of the timing shizzle
	if( InAI.bMAI_ClosestPawn == TRUE )
	{
		`AILog_Ext( "Doing a Manual AI Melee attack",, InAI );
		InAI.bMAI_ClosestPawn = FALSE;
		InAI.bMAI_OverrideAttackPacing = FALSE;
		return 200;
	}


	if( NanoAI_Trooper(InAI).AmIAllowedToAttack() == FALSE )
	{
		return 0;
	}

	// we always want to attack
	// when we enter attacks state we also get ECFT_Melee_Attacking which will then move us closer 
	// to where we can get in range to actually swing
	Rating += 5;

	if( IsInAttackRange( InAI ) == TRUE )
	{
		`AILog_Ext( GetFuncName() @ `showvar(InAI) @ `showvar(IsInAttackRange( InAI )) @ "Probably going to attack!",, InAI );
		Rating += 105;
	}

	return Rating;
}


function Popped()
{ 
	Super.Popped();

	// since we have been popped / attacked we want to clear off any CombatEffectors as we had our chance to to attack and failed
	//ResetCombatEffectors();
	DegradeCombatEffectors();
}


function BoidMovementToAttackEnemyTimedOut()
{
	status = 'Aborted';
	AbortCommand( self );
}



function DetermineAttackChoice()
{
	// so this need to look at the blackboard and any other data we have avail

	// so here we will subclass this function with our specific NanoAICmds or other nice logic from the AIBlackBoard


	NanoWeap_Baton(Pawn.Weapon).CurrAttackChoice = HAC_SuperKick;

	//NanoWeap_Baton(Pawn.Weapon).CurrAttackChoice = EHACK_AttackChoice(Rand(4)); //HAC_SuperKick;
	//`log( `showvar(NanoWeap_Baton(Pawn.Weapon).CurrAttackChoice) );
}



state SwingYourWeapon `DEBUGSTATE
{
		
Begin:
	`AILog( GetStateName()@"BEGIN TAG" );

	SetTimer( 4.0f, FALSE, nameof(self.BoidMovementToAttackEnemyTimedOut), self);
	// so keep doing boids movement until we can actually hit our target
	while( IsInAttackRange( Outer) == FALSE )
	{
		`AILog( GetStateName() @ "Moving so IsInAttackRange is TRUE" );
		Sleep( 0.1f );
	}
	ClearTimer( nameof(self.BoidMovementToAttackEnemyTimedOut), self);


	// choose which Melee Attack we want to do
	if( NanoWeap_Baton(Pawn.Weapon) != None )
	{
		DetermineAttackChoice();
	}


	// FIRE if we can
	TryToFireWeapon();

WaitingForAttackToFinish:
	`AILog( GetStateName()@"WaitingForAttackToFinish TAG" );

	// wait for attack to finish
	do
	{
		`AILog( "Waiting for attack to finish Melee", 'Loop' );
		Sleep( 0.1f );
	} until( !Pawn.Weapon.IsFiring() );

	status = 'Success';
	PopCommand( self );
}


defaultproperties
{
	StartingStateName="SwingYourWeapon"
}