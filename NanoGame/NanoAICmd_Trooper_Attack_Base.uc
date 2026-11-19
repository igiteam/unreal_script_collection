/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_Trooper_Attack_Base extends NanoAICmd within NanoAI_Trooper
	abstract
	config(AI);


simulated function Texture2D GetDebugIcon() { return Texture2D'UI_HUD.AI.T_UI_Debug_Icons_CombatMelee'; }

function Pushed()
{
	Super.Pushed();

	SetConfrontationType( ECFT_Melee_Attacking );

	//`log( "Set GlobalPacing_NextAttack" );
	// this needs to be the time of the attack really.  So we will be tricky for now
	// and set this to be no attacks for 10 seconds.   And then when the AttackFinishes
	// we will set it to the real value.
	// NOTE: this might get pwned if you kill the guy that is attacking
	GetBlackBoard().GlobalPacing_NextAttack = WorldInfo.TimeSeconds + 10.0f;
	LastMeleeAttackTime = WorldInfo.TimeSeconds;

	// turn off boids as we are about to attack
	//HandleBoidAlteringEvent( 'WaitingForAttackToFinish', FALSE );

	FireTarget.GetTargetableOctreeComponent().NumCurrentlyMeleeing++;
}

function Popped()
{
	local NanoPawnBase NP;

	NP = NanoPawnBase(Pawn);
	if( NP != None )
	{
		NP.NextAllowedAttackTime = WorldInfo.TimeSeconds + RandRange( NP.AbleToExecuteAnAttackRange.X, NP.AbleToExecuteAnAttackRange.Y );
	}
	
	//HandleBoidAlteringEvent( 'WaitingForAttackToFinish', TRUE );
	
	FireTarget.GetTargetableOctreeComponent().NumCurrentlyMeleeing--;

	GetBlackBoard().GlobalPacing_NextAttack = WorldInfo.TimeSeconds + GetCombatPacingValue();
	`AILog( Outer @ "setting" @ `showvar(GetBlackBoard().GlobalPacing_NextAttack) );

	Super.Popped();
}

defaultproperties
{

}
