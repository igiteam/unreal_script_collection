/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Base_MomCorpser extends AICommand
	within GearAI_MomCorpser;

function Pushed()
{
	Super.Pushed();

	Corpser.ResetEncroachers();

	// Do melee attack immediately
	GotoState('ChooseAction');
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	Corpser.ResetEncroachers();
}


function AdjustEnemyRating(out float out_Rating, Pawn EnemyPawn)
{
	if( CachedGearChildCommand != None )
	{
		CachedGearChildCommand.AdjustEnemyRating(out_Rating, EnemyPawn);
		return;
	}

	if( out_Rating > 0 && MyGearPawn != None )
	{
		if( EnemyPawn == Enemy )
		{
			out_Rating *= FRand();
		}
	}

	if( !IsPawnVisibleViaTrace( EnemyPawn ) )
	{
		out_Rating *= 0.1f;
	}

	Super.AdjustEnemyRating(out_Rating, EnemyPawn);
}

state ChooseAction
{
	function Name PickAttackType()
	{
		local float Dist;
		local array<Name> Actions;
		local Name Action;
		local int Idx;

		Corpser.ResetEncroachers();

		// If all the eyes are shot out
		if( !Corpser.IsAlive() )
		{
			return 'Mad';
		}

		Dist = VSize(Pawn.Location - Enemy.Location);
		if( Dist < 450.f && `TimeSince(LastScreamTime) > 3.f )
		{
			Actions[Actions.Length] = 'Scream';
		}
		else
		{
			if( IsPawnVisibleViaTrace( Enemy ) )
			{
				if( Dist <= EnemyDistance_Melee )
				{
					if( `TimeSince( LastStabTime ) > 0.f )
					{
						Actions[Actions.Length] = 'Melee_Stab';
					}
				}
				else
				{
					if( `TimeSince(LastChargeTime) > 10.f )
					{
						Actions[Actions.Length] = 'Charge';
					}
				}
			}

			if( `TimeSince( LastStompTime ) > 4.f )
			{
				// Chance to drop rocks
				Actions[Actions.Length] = 'Melee_Stomp';
			}

			if( Dist >= EnemyDistance_Melee )
			{
				// Close distance on enemy
				Actions[Actions.Length] = 'RunToEnemy';
			}
		}

		if( Actions.Length > 0 )
		{
			Action = Actions[Rand(Actions.Length)];

			//debug
			`AILog( `location@`showvar(Action)@Actions.Length@`showvar(Enemy) );
			`AILog( "Stab"@`TimeSince( LastStabTime )@"Charge"@`TimeSince(LastChargeTime)@"Stomp"@`TimeSince( LastStompTime ) );
			for( Idx = 0; Idx < Actions.Length; Idx++ )
			{
				`AILog( "   >>"@ Actions[Idx] );
			}

			return Action;
		}

		//debug
		`AILog( "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" );
		`AILog( `location@"No actions"@`showvar(Enemy)@`showvar(Dist)@IsPawnVisibleViaTrace( Enemy ) );
		`AILog( "Stab"@`TimeSince( LastStabTime )@"Charge"@`TimeSince(LastChargeTime)@"Stomp"@`TimeSince( LastStompTime ) );

		return 'Finished';
	}

Begin:
	//debug
	`AILog( "BEGIN TAG", 'State' );

	// If we couldn't select an enemy go to the failure state
	if (!SelectTarget())
	{
		//debug
		`AILog("Failed to select an enemy -- sleep and retry");

		Goto('Finished');		
	}

	while( Corpser.IsTurningInPlace() )
	{
		//debug
		`AILog( "Waiting for turn in place to complete", 'Loop' );

		Sleep( 0.1f );
	}

	// Chose which action to take
	Goto(PickAttackType());

// Close the gap
RunToEnemy:
	Corpser.SetAvoidanceCylActive( FALSE );
	SetEnemyMoveGoal( TRUE, EnemyDistance_Melee * 0.9f );
	Goto('Finished');

// Ground stomp attack
Melee_Stomp:
	Focus = Enemy;
	
	Corpser.SetAvoidanceCylActive( TRUE );
	class'AICmd_Attack_MomCorpser_Stomp'.static.InitCommand(AIOwner);
	LastStompTime = WorldInfo.TimeSeconds;

	Goto('Finished');

// Finger stab attack
Melee_Stab:
	Focus = Enemy;

	Corpser.SetAvoidanceCylActive( TRUE );
	Corpser.SetOpenWalkAnim( FALSE );
	class'AICmd_Attack_MomCorpser_Stab'.static.InitCommand(AIOwner);
	LastStabTime = WorldInfo.TimeSeconds;
	Corpser.SetOpenWalkAnim( FALSE );
	Goto('Finished');

// Charge attack
Charge:
	Corpser.SetAvoidanceCylActive( FALSE );
	Corpser.SetOpenWalkAnim( FALSE );
	class'AICmd_Attack_MomCorpser_Charge'.static.InitCommand(AIOwner);
	LastChargeTime = WorldInfo.TimeSeconds;
	Corpser.SetOpenWalkAnim( FALSE );
	Goto('Finished');

Scream:
	Focus = Enemy;

	Corpser.SetAvoidanceCylActive( TRUE );
	class'AICmd_React_MomCorpser_Hurt'.static.InitCommand(AIOwner);
	LastScreamTime = WorldInfo.TimeSeconds;
	Goto('Finished');

Mad:
	Corpser.SetAvoidanceCylActive( FALSE );
	class'AICmd_React_MomCorpser_LostAllEyes'.static.InitCommand(AIOwner);
	Goto('Finished');

Finished:
	FireTarget = None;
	Focus = None;

	Sleep( 0.1f );
	CheckInterruptCombatTransitions();
	Goto( 'Begin' );
}


defaultproperties
{
}
