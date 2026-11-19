/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_EngageThreat_Trooper_Ranged_Shield extends NanoAIAction_EngageThreat_Trooper_Ranged within NanoAI_Trooper;


static function int InternalGetUtility( NanoAIBase InAI )
{
	// (MyTrooper != None && MyTrooper.bHasShield);
	return 0;
}



state Combat_RangedAttack_Shield extends Combat_RangedAttack
{
	function EndState( Name NextStateName )
	{
		Super.EndState( NextStateName );
		MyTrooper.bShieldPose = FALSE;
	}

	function NotifyShieldDropped()
	{
		StopFiring();
		//GotoState('Combat_RangedAttack');
	}

Begin:
	`AILog( GetStateName()@"Begin TAG" );
	SetActiveBoidMovementByClass( class'BoidRule_TrooperRanged', FALSE );
	bWaitingForActiveAttack = FALSE;
	//PossiblyTransitionTo('Alert',ShouldTransitionToAlert);
	//PossiblyTransitionTo('Combat_MeleeAttack',ShouldTransitionToMelee);
	PossiblyPickFireTarget();

	if (CanActivelyAttackTarget( LastErrorCode ))
	{
		StartFiring();
	}
	else
	{
		bWaitingForActiveAttack = TRUE;
	}

	if( LastErrorCode == 'AttackFail_NoLOS' )
	{
		MyTrooper.bShieldPose = FALSE;
		class'NanoAICmd_Move_UntilInRange'.static.MoveToVisibleActor(Outer,FireTarget,FALSE);
	}
	else
	{
		MyTrooper.bShieldPose = TRUE;
	}

	if (bWaitingForActiveAttack)
	{
		Goto('WaitingForAnActiveAttack');
	}

WaitingForAttackToFinish:
	`AILog( GetStateName()@"WaitingForAttackToFinish TAG" );
	// wait for attack to finish
	do
	{
		`AILog( "Waiting for Attack to finish Ranged Shield", 'Loop' );
		Sleep(0.5f);
	} until (!bAttemptingToFireWeapon);

AttackFinished:
	`AILog( GetStateName()@"AttackFinished TAG" );
	Goto('Begin');

WaitingForAnActiveAttack:
	`AILog( GetStateName()@"WaitingForAnActiveAttack TAG" );
	do
	{
		`AILog( "Waiting for an active attack", 'Loop' );
		Sleep(0.5f);
	} until ( CanActivelyAttackTarget( LastErrorCode ) || LastErrorCode == 'AttackFail_NoLOS' || !bWaitingForActiveAttack );

	if( LastErrorCode == 'AttackFail_NoLOS' )
	{
		`AILog("No LOS");
		Goto( 'Begin' );
	}
	else
	{
		Goto('WaitingForAttackToFinish');
	}
}


defaultproperties
{
	StartingStateName="Combat_RangedAttack_Shield"
}