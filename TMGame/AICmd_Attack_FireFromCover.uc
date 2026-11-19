/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_FireFromCover extends AICommand
	within TGAI_Cover;

var float StopFireRate;
var float RefireRate;
/** GoW global macros */

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool FireFromCover( TGAI_Cover AI )
{
	local AICmd_Attack_FireFromCover Cmd;

	if( AI != None )
	{
		Cmd = new(AI) class'AICmd_Attack_FireFromCover';
		if( Cmd != None )
		{
			AI.PushCommand( Cmd );
			return TRUE;
		}
	}

	return FALSE;
}

function Pushed()
{
	Super.Pushed();

	bFailedToFireFromCover = FALSE;
	LastFireFromCoverTime = WorldInfo.TimeSeconds;

	TriggerAttackGUDS();
	GameAIOwner.SetTimer( 15.f, TRUE, nameof(TGAI(GameAIOwner).TriggerAttackGUDS) );

	GotoState( 'Firing' );
}

function Popped()
{
	Super.Popped();

	bFailedToFireFromCover = (Status != 'Success');

	GameAIOwner.ClearTimer('TriggerAttackGUDS');

	// Always clear cover action
	ResetCoverAction();
}

function AdjustEnemyRating(out float out_Rating, Pawn EnemyPawn)
{
	if (AICommand(ChildCommand) != None)
	{
		AICommand(ChildCommand).AdjustEnemyRating(out_Rating, EnemyPawn);
		return;
	}

	if( out_Rating > 0 &&
		MyTGPawn != None &&
		!GetCoverAction( Cover, EnemyPawn,, TRUE, 'Enemy' ) )
	{
		//debug
		;

		out_Rating = -1.f;
	}

	Super.AdjustEnemyRating(out_Rating, EnemyPawn);
}

function bool ShouldSelectTarget()
{
	// Don't select new target when sniping
	if( !IsUsingSuppressiveWeapon() )
	{
		return FALSE;
	}
	return Super.ShouldSelectTarget();
}

/**
 * Selects the first enemy that is medium range and attackable from our
 * current cover.
 */
final function private bool SelectEnemyAndCoverAction()
{
	local int Idx;

	FireTarget = None;
	if( TargetList.Length > 0 )
	{
		// check from current position
		for( Idx = 0; Idx < TargetList.Length; Idx++)
		{
			if( GetCoverAction( Cover, TargetList[Idx], Controller(TargetList[Idx]) == None ) )
			{
				FireTarget = TargetList[Idx];
				ShotTarget = Pawn(FireTarget);
				return TRUE;
			}
		}
	}

	// try to select the closest enemy that we can shoot at from cover
	if( SelectTarget() )
	{

		//debug
		;

		if( GetCoverAction( Cover, None ) )
		{
			MyTGPawn.ShouldCrouch( PendingFireLinkItem.SrcType == CT_MidLevel );
			return TRUE;
		}
		return FALSE;
	}

	//debug
	;

	// no dice
	return FALSE;
}

final function private bool SelectEnemyAndAmbushAction()
{
	local bool bWantsToBeMirrored;
	local float DotP;
	local Vector X, Y, Z;

	if( GetCoverAction( Cover, None, FALSE ) ||
		GetCoverAction( Cover, None, TRUE  ) )
	{
		if( PendingFireLinkItem.SrcAction == CA_Default )
		{
			GetAxes( Cover.Link.GetSlotRotation(Cover.SlotIdx), X, Y, Z );
			DotP = (GetFireTargetLocation() - Cover.Link.GetSlotLocation(Cover.SlotIdx)) DOT Y;
			if( DotP < 0 )
			{
				bWantsToBeMirrored = TRUE;
			}
			MyTGPawn.SetMirroredSide( bWantsToBeMirrored );
		}

		return TRUE;
	}

	return FALSE;
}

function bool IsEnemyExposed()
{
	local Vector TestLocation;
	local Pawn	 P;
	local Rotator Rot;

	Rot = Pawn.Rotation;
	P = Pawn(FireTarget);
	if( P != None )
	{
		TestLocation = P.GetPawnViewLocation();
		Rot = Rotator(GetFireTargetLocation() - Pawn.Location);
	}
	else
	{
		TestLocation = FireTarget.Location;
		Rot = Rotator(TestLocation-Pawn.Location);
	}

	return CanSeeByPoints( Pawn.GetWeaponStartTraceLocation(), TestLocation, Rot );
}



state Firing 
{
Begin:
	//debug
	;

	// check for any interrupt transitions
	CheckInterruptCombatTransitions();

	// NOTE: Be on look out for bugs b/c of competing transition animations
	// Select our weapon
	if( !IsSwitchingWeapons() )
	{
		if( SelectWeapon() )
		{
			Sleep( 0.25f );
		}
	}
	while( IsSwitchingWeapons() )
	{
		//debug
		;

		Sleep(0.25f);
	}

	// Moved this up here so that AI doesn't need to get back into cover before moving
	// but we still need to allow time for them to get back in if they didn't move
	Sleep( 0.5f );

	// If turtling command given while reloading
	if( bTurtle )
	{
		;
		// Jump to end
		Goto( 'Finish' );
	}

PrepareFire:
	//debug
	;

	// if not using a suppressive weapon and can pop out from cover
	if( !IsUsingSuppressiveWeapon() &&
		SelectEnemyAndAmbushAction() )
	{
		//debug
		;

		// wait for any transitions to finish
		// before transitioning again
		LastAnimTransitionTime = WorldInfo.TimeSeconds;
		do
		{
			Sleep( 0.25f );
		} until( !IsTransitioning() );

		// If should wait for transition (this function will mirror pawn if needed)
		if( ShouldWaitForTransition( PendingFireLinkItem.SrcAction ) )
		{
			//debug
			;

			// While still transitioning, wait
			LastAnimTransitionTime = WorldInfo.TimeSeconds;
			do
			{
				Sleep( 0.25f );
			} until( !IsTransitioning() );
		}

		// If 360 aiming
		if( PendingFireLinkItem.SrcAction == CA_Default )
		{
			// Stand up in mid level cover
			if( MyTGPawn.CoverType == CT_MidLevel )
			{
				//debug
				;

				// Stand up
				MyTGPawn.ShouldCrouch( TRUE );
			}
		}
		else
		{
			// Wait for action anim
			SetCoverAction( PendingFireLinkItem.SrcAction );
		}

		// Sleep until done doing action
		LastAnimTransitionTime = WorldInfo.TimeSeconds;
		do
		{
			Sleep( 0.25f );
		} until( !IsTransitioning() );

		// Only lean out so long
		SetTimer( 1.f+FRand()*5.f, FALSE, nameof(NotifyFireLineBlocked) );

		// wait for no enemies, or an exposed enemy
		while( !bFailedToFireFromCover	&&
				HasAnyEnemies()			&&
				HasValidTarget()		&&
			   (IsLeaning() || ShouldDo360Aiming( GetFireTargetLocation() )) &&
			   !IsEnemyExposed() )
		{
			//debug
			;

			Sleep( 0.25f );
		}

		// If aborted cover action
		if( bFailedToFireFromCover )
		{
			//debug
			;

			// Hang out for a moment
			Sleep( 1.f+FRand()*5.f );
			Goto('ReturnToCover');
		}
		else
		// if we have a valid enemy
		// If could get fire ticket
		if( HasValidTarget() &&
			CanFireAt(FireTarget, Pawn.GetWeaponStartTraceLocation()) &&
			ClaimFireTicket() )
		{
 			// fire at them
			Goto('FireWeapon');
		}
		else
		{
			//debug
			;

			// sometimes give up and move
			bFailedToFireFromCover = (FRand() < 0.2);

			// otherwise return to cover and exit
			Goto('ReturnToCover');
		}
	}
	else
	// try to pop out from cover
	if( SelectEnemyAndCoverAction() )
	{
		//debug
		;

		// wait for any transitions to finish
		// before transitioning again
		LastAnimTransitionTime = WorldInfo.TimeSeconds;
		do
		{
			Sleep( 0.25f );
		} until( !IsTransitioning() );

		// If should wait for transition (this function will mirror pawn if needed)
		if( ShouldWaitForTransition( PendingFireLinkItem.SrcAction ) )
		{
			//debug
			;

			// While still transitioning, wait
			LastAnimTransitionTime = WorldInfo.TimeSeconds;
			do
			{
				Sleep( 0.25f );
			} until( !IsTransitioning() );
		}

		// If could get fire ticket
		if( ClaimFireTicket() )
		{
			// If 360 aiming...
			if( PendingFireLinkItem.SrcAction == CA_Default )
			{
				// Stand up in mid level cover
				if( MyTGPawn.CoverType == CT_MidLevel )
				{
					//debug
					;

					// Stand up
					MyTGPawn.ShouldCrouch( TRUE );
				}
			}
			else
			{
				// Set action and wait for action anim to finish
				SetCoverAction( PendingFireLinkItem.SrcAction );
			}

			// Sleep until done doing action
			LastAnimTransitionTime = WorldInfo.TimeSeconds;
			do
			{
				Sleep( 0.25f );
			} until( !IsTransitioning() );
			;
			Goto( 'FireWeapon' );
		}
		else
		{
			// Otherwise, no fire ticket available

			//debug
			;

			PeekFromCover();

			//debug
			;

			if( bFailedToFireFromCover )
			{
				Sleep( 0.5f );
			}
			else
			if( CanClaimFireTicket(HDBasePawn(Enemy)) )
			{
				Goto( 'PrepareFire' );
			}
		}
	}
	else
	{
		//debug
		;
		bFailedToFireFromCover = TRUE;

		Sleep( 0.5f );
	}
	Goto('Finish');

FireWeapon:
	//debug
	;

	// fire at the enemy
	Focus = FireTarget;
	// Clear timer in case we were using sniper rifle
	ClearTimer( 'NotifyFireLineBlocked' );

	// Sleep if weapon has aim time
	if( WeaponAimDelay > 0.f )
	{
		MyTGPawn.SetWeaponAlert(WeaponAimDelay);
		//debug
		;

		Sleep( WeaponAimDelay );
	}

StartFiring:
	StartFiring();

	RefireRate = FRand() * 0.5 + 1.f;

	StopFireRate = 1.0;

	// wait for the weapon to finish firing
	do
	{
		if (RefireRate < 1000)
		{
			if (FRand() > RefireRate)
			{
				StopFiring();
				Sleep(FRand() * 0.5f + 1.5f);
				Goto('StartFiring');
			}

			RefireRate -= 0.25f;
		}

		Sleep( 0.25f );
		//debug
		;
		if ( (MyTGPawn.MyTGWeapon == None || !MyTGPawn.MyTGWeapon.bNoAnimDelayFiring) &&
			 MyTGPawn.DoingAnimationTransition() )
		{
			//debug
			;

			StopFiring();
			RefireRate = 1000;
		}

		if (FRand() > StopFireRate)
			break;

		StopFireRate -= 0.25;
	} until((!IsFiringWeapon() && !IsMountingWeapon()) || IsReloading() || bFailedToFireFromCover);

	//StartFiring();
	//// wait for the weapon to finish firing
	//do
	//{
	//	Sleep( 0.25f );

	//	//debug
	//	`AILog( "Firing weapon..."@MyTGPawn.ShouldDelayFiring(), 'Loop' );
	//	if ( (MyTGPawn.MyTGWeapon == None || !MyTGPawn.MyTGWeapon.bNoAnimDelayFiring) &&
	//		 MyTGPawn.DoingAnimationTransition() )
	//	{
	//		//debug
	//		`AILog("Unable to transition, aborting fire");

	//		StopFiring();
	//	}
	//} until( (!IsFiringWeapon() && !IsMountingWeapon()) || IsReloading() || bFailedToFireFromCover );

	// NOTE: Be on look out for bugs b/c of competing transition animations
	// Select our weapon
	if( !IsSwitchingWeapons() )
	{
		if( SelectWeapon() )
		{
			Sleep( 0.25f );
		}
	}
	while( IsSwitchingWeapons() )
	{
		//debug
		;

		Sleep(0.25f);
	}

	// heavy weapons cancel reload when unmounting and such so leave the AI here until it's done
	while (MyTGPawn.IsCarryingAHeavyWeapon() && IsReloading())
	{
		;
		Sleep(0.25);
	}

	//debug
	;

	StopFiring();
	Sleep(0.25f);

	if( bFailedToFireFromCover )
	{
		SetAcquireCover( ACT_DesireBetter );
	}

ReturnToCover:
	//debug
	;

	// return to cover
	ReleaseFireTicket();
	ResetCoverAction();

	// Sleep until done resetting action
	LastAnimTransitionTime = WorldInfo.TimeSeconds;
	do
	{
		Sleep( 0.25f );
	} until( !IsTransitioning() );

Finish:
	//debug
	;

	Status = bFailedToFireFromCover ? 'Failure' : 'Success';
	PopCommand( self );
}

