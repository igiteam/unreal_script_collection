/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Base_Melee extends AICommand_Base_Combat
	within TGAI;

/** GoW global macros */

function Pushed()
{
	Super.Pushed();

	InvalidateCover();

	GotoState( 'InCombat' );
}

function Popped()
{
	Super.Popped();

	// this is here so that if we were pre-meleeing (like from a lancer) it gets shut off
	bAllowedToFireWeapon = FALSE;
	StopMeleeAttack();
	ClearTimer(nameof(MeleeTimeout),self);
	ClearTimer(nameof(EnableLancerEarly),self);
}

function StartMeleeTimeout()
{
	local float time;
	local float routecachedist;
	routecachedist = GetRouteCacheDistance();
	if(routecachedist <= 0.f)
	{
		routecachedist = VSize(Pawn.Location - Enemy.Location)*1.25f;
	}

	time = (routecachedist/MyTGPawn.DefaultGroundSpeed)+3.0f;
	//messageplayer(getfuncname()@time);

	SetTimer(time,FALSE,nameof(MeleeTimeout),self);
}

function MeleeTimeout()
{
	local float Thresh;
	Thresh = EnemyDistance_Melee*2.0f;
	//messageplayer(getfuncname()@Thresh);

	if(Enemy != none && VSizeSq(Enemy.Location - Pawn.Location) >  Thresh * Thresh )
	{
		//MessagePlayer("MELEE TIMEOUT!");
		BeginCombatCommand(GetDefaultCommand(), "Melee timed out, and we're still fairly far away");
	}
	else
	{
		StartMeleeTimeout();
	}
}

function DoMeleeAttack( optional Pawn NewEnemy )
{
	ClearTimer(nameof(MeleeTimeout));
	Outer.DoMeleeAttack(NewEnemy);
}

// sets a timer to check to see if we can enable our lancer
function EnableLancerEarly()
{
	// dont' want to start the lancer unless we're running directly to the dude (so we can still mantle, etc..)
	if(RouteCache.length < 2 && HasEnemyWithinDistance(EnemyDistance_Short))
	{
		;
		bAllowedToFireWeapon = TRUE;
		StopFiring();
		StartMeleeAttack();
	}
	else
	{
		SetTimer(0.1f,FALSE,nameof(EnableLancerEarly),self);
	}
}

state InCombat
{
	/** called right before actually doing the melee attack, i.e. after successfully reaching melee range */
	function AboutToExecuteMeleeAttack();

Begin:
	//debug
	;

	// check for any interrupt transitions
	CheckInterruptCombatTransitions();

	if (!IsValidMeleeTarget(TGPawn(Enemy)))
	{
		// select the nearest enemy
		SelectEnemy();
	}
	FireTarget = Enemy;

	//debug
	;

	if( IsValidMeleeTarget(TGPawn(Enemy)) )
	{

		// if we have a lancer, start the saw early
		if ( MyTGPawn != none && MyTGPawn.Weapon != none && MyTGPawn.Weapon.IsA('TGWeap_AssaultRifle'))
		{
			SetTimer(0.1f,FALSE,nameof(EnableLancerEarly),self);
		}

		// check if too far away
		if ( (MyTGPawn != None && VSize(MyTGPawn.Location - Enemy.Location) > MyTGPawn.GetAIMeleeAttackRange())
			|| (TGPawn(Enemy) != None && TGPawn(Enemy).IsProtectedByCover(Normal(Enemy.Location - Pawn.Location))) )
		{
			;
			//TGGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_TransToKamikazeAI, Pawn);
			StartMeleeTimeout();
			SetEnemyMoveGoal(TRUE);
			// check that there's not still cover between AI and enemy
			if (TGPawn(Enemy) != None && TGPawn(Enemy).IsProtectedByCover(Normal(Enemy.Location - Pawn.Location)))
			{
				;
				BeginCombatCommand(GetDefaultCommand(), "Failed melee due to cover in the way");
			}
		}
		// If no LOS to enemy
		else if( !CanSeeByPoints( Pawn.GetPawnViewLocation(), Enemy.Location, Rotator(Enemy.Location - Pawn.GetPawnViewLocation()) ) )
		{
			//debug
			;

			// Move to him first
			SetEnemyMoveGoal(TRUE);
		}
		else
		{
			//// Assume we make it to the enemy
			//if ( (WorldInfo.TimeSeconds - Pawn.LastRenderTime) > 1.f )
			//{
			//	// call the "offscreen" version, which has a higher chance to play in order to alert player to
			//	// impending danger of a beatdown
			//	TGGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_TransToMeleeAIOffscreen, Pawn);
			//}
			//else
			//{
			//	TGGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_TransToMeleeAI, Pawn);
			//}
			bFailedToMoveToEnemy = FALSE;
		}

		if( !bFailedToMoveToEnemy )
		{
			// we need to check validity again as some time may have passed and the target may have died or whatever
			if (IsValidMeleeTarget(TGPawn(Enemy)))
			{
				AboutToExecuteMeleeAttack();

				// Claim all fire tickets so no one shoots while I'm in melee
				ClaimFireTicket( TRUE );

				// Attempt to melee them
				if( CanEngageMelee() )
				{
					DoMeleeAttack();
				}
				else
				{
					Sleep(0.1f);
				}

				// Release tickets
				ReleaseFireTicket();

				BeginCombatCommand( GetDefaultCommand(), "Successfully completed melee attack" );
			}
			else
			{
				;
				BeginCombatCommand( GetDefaultCommand(), "Invalid melee target" );
			}
		}
		else
		{
			//debug
			;

			SetFailedPathToEnemy( Enemy, 7.f );

			FireFromOpen();

			Sleep( 0.25f );

			BeginCombatCommand( GetDefaultCommand(), "Failed to hit melee target" );
		}
	}
	else
	{
		//debug
		;

		Sleep( 0.25f );

		BeginCombatCommand( GetDefaultCommand(), "Invalid melee target" );
	}

	// Check to see if we have a tether we need to resume
	if( !MoveIsInterruptable() )
	{
		SetTether( TetherActor, DesiredTetherDistance );
	}

	// Check combat transitions
	CheckCombatTransition();
	Goto('Begin');
}

