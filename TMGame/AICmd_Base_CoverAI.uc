/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Base_CoverAI extends AICommand_Base_Combat
	within TGAI_Cover;

/** GoW global macros */

function Pushed()
{
	local bool bInitReact;
	Super.Pushed();

	MyTGPawn.hod.DoScript('combat');

	// turn on flank reactions
	Reactionmanager.UnSuppressReactionsByType(class'AIReactCond_Flanked',false);

	// Check if we should play initial reaction for combat first
	bInitReact = (FRand() < PlayIntialCombatReactionChance);
	PlayIntialCombatReactionChance = 0.f;	// Clear immediately
	if( bInitReact && FALSE) // FIXME: anims for inital combat reaction don' exist any more?
	{
		class'AICmd_React_InitialCombat'.static.InitialCombatReact( CoverOwner );
	}
	else
	{
		GotoState( 'InCombat' );
	}
}

function Popped()
{
	Super.Popped();

	// turn off flank reactions
	Reactionmanager.SuppressReactionsByType(class'AIReactCond_Flanked',false);
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	MyTGPawn.hod.DoScript('combat');

	if( OldCommandName == 'AICmd_React_InitialCombat' )
	{
		GotoState( 'InCombat' );
	}
}

state InCombat
{
	/** used when the AI wants to move to cover and it is not already in cover */
	protected function MoveToInitialCover()
	{
		local CoverSlotMarker sm;
		sm = CoverSlotMarker(Pawn.Anchor);
		if (sm == none)
			MoveToNearestCoverEnemy();
		else
			SetCoverGoal(sm.OwningSlot, FALSE);
	}

	/** used when the AI is in cover but wants to evaluate moving to different cover */
	protected function MoveToBetterCover( CoverSlotMarker PrevBestMarker )
	{
		local CoverInfo NewCover;
		local bool		bTowardsGoal;
		local float		NearEnemyDist;

		NearEnemyDist = GetNearEnemyDistance(Pawn.Location);

		// search for cover either towards/away based on closest enemy distance
		bTowardsGoal = (CombatMood == AICM_Aggressive || (CombatMood != AICM_Passive && NearEnemyDist > EnemyDistance_Short));
		if( EvaluateCover( bTowardsGoal ? SearchType_Towards : SearchType_Away, Enemy, NewCover,PrevBestMarker ) )
		{
			//debug
			;

			// moving on up
			SetCoverGoal( NewCover, TRUE );

			if( Pawn.GetTeamNum() != 0 )
			{
				// @fixme test for flanking here too?
				if( bTowardsGoal )
				{
					//GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_TransToAdvanceAI, Pawn);
				}
				else
				{
					//GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_TransToRetreatAI, Pawn);
				}
			}
		}
		else
		{
			//debug
			;

			// set cover goal to current so that we don't treat it as a failure
			SetCoverGoal( Cover );
		}
	}

	/** @return whether we should look for better cover */
	function bool ShouldChangeCover()
	{
		if( (!HasValidCover() || !IsAtCover()) && AllowedToMove())
		{
			return TRUE;
		}

		if(  AcquireCover == ACT_Immediate ||
			(AcquireCover == ACT_DesireBetter &&
				TimeSince(EnterCoverTime) >= MinStayAtCoverTime) &&
				AllowedToMove())
		{
			return TRUE;
		}

		return FALSE;
	}

	/** if the LD specified any pickups the AI should consider, check if we should get one here */
	final function CheckScriptedPickups()
	{
		//local Actor A;
		//local TGWeaponPickupFactory Factory;
		//local TGDroppedPickup Pickup;
		//local class<TGWeapon> WeaponClass;

		//if (SPItemsToConsider.length > 0 && FRand() < 0.35)
		//{
		//	// first check if we are touching one
		//	foreach Pawn.TouchingActors(class'Actor', A)
		//	{
		//		Factory = TGWeaponPickupFactory(A);
		//		if (Factory != None)
		//		{
		//			if ( SPItemsToConsider.Find(Factory.WeaponPickupClass) != INDEX_NONE &&
		//				Factory.CanBePickedUpBy(Pawn) )
		//			{
		//				class'AICmd_PickupWeapon'.static.PickupWeaponFromFactory(Outer, Factory);
		//				return;
		//			}
		//		}
		//		else
		//		{
		//			Pickup = TGDroppedPickup(A);
		//			if ( Pickup != None)
		//			{
		//				WeaponClass = class<TGWeapon>(Pickup.InventoryClass);
		//				if ( WeaponClass != None && SPItemsToConsider.Find(WeaponClass) != INDEX_NONE &&
		//					Pickup.CanBePickedUpBy(Pawn) )
		//				{
		//					class'AICmd_PickupWeapon'.static.PickupWeaponFromPickup(Outer, Pickup);
		//					return;
		//				}
		//			}
		//		}
		//	}
		//	// now check if there's one nearby we should move to
		//	foreach WorldInfo.RadiusNavigationPoints(class'TGWeaponPickupFactory', Factory, Pawn.Location, 1024.0)
		//	{
		//		if ( SPItemsToConsider.Find(Factory.WeaponPickupClass) != INDEX_NONE &&
		//				Factory.CanBePickedUpBy(Pawn) )
		//		{
		//			class'AICmd_PickupWeapon'.static.PickupWeaponFromFactory(Outer, Factory);
		//			return;
		//		}
		//	}
		//	foreach WorldInfo.CollidingActors(class'TGDroppedPickup', Pickup, 1024.0, Pawn.Location, false)
		//	{
		//		WeaponClass = class<TGWeapon>(Pickup.InventoryClass);
		//		if ( WeaponClass != None && SPItemsToConsider.Find(WeaponClass) != INDEX_NONE &&
		//			Pickup.CanBePickedUpBy(Pawn) )
		//		{
		//			class'AICmd_PickupWeapon'.static.PickupWeaponFromPickup(Outer, Pickup);
		//			return;
		//		}
		//	}
		//}
	}

	/** @return if we need to change cover immediately because we are too exposed */
	protected final function bool ShouldChangeCoverDueToExposure()
	{
		local float ExposedScale;
		local bool	bResult;

		// if we are significantly exposed or we're somewhat exposed but taking damage
		bResult = IsCoverExposedToAnEnemy(Cover,, ExposedScale);

		//debug
		;

		if( bResult )
		{
			if( ExposedScale > 0.5 || GetHealthPercentage() < 0.75 )
			{
				return TRUE;
			}
		}

		return FALSE;
	}

Begin:
	//debug
	;

	CheckScriptedPickups();
CheckDBNO:
	CheckReviveOrExecute(1200.0);

	// check to see if we should move to our squad
	if( ShouldMoveToSquad() )
	{
MoveToSquad:
		//debug
		;

		MoveToSquadPosition();
	}
CoverCheck:
	//debug
	;

	CheckInterruptCombatTransitions();
	// make sure we can acquire an enemy
	if( !SelectEnemy() )
	{
		//debug
		;

		if (HasAnyEnemies() && AllowedToMove())
		{
			ClearMovementInfo();
			// move to nearest cover if we don't have cover already
			if (!HasValidCover() || !IsAtCover())
			{
				// try to move to cover
				MoveToNearestCoverIdle();
			}
		}

		Sleep(0.5f);
		Goto('End');
	}
	FireTarget = Enemy;

	Sleep(0.5);
	Goto('End');

	//debug
	;

	// if we're not allowed to move, then just fire
	if(!AllowedToMove() && !HasValidCover())
	{
		// if we're not allowed to move, and we don't have valid cover check to see if we have a move action trying to get us into cover.. if so reapply it
		if(MoveAction != none && MoveAction.DestinationSlotIndex > -1 && MoveAction.Targets.length > 0)
		{
			;
			OnAIMove(MoveAction);
		}
		else
		{
			FireFromOpen();

			if( bFailedToFireFromOpen )
			{
				//debug
				;

				Sleep( 0.25f );
				// go to the end and loop all the way back to the beginning so we'll try move to squad and such
				Goto('End');
			}

		}
	}
	// check to see if we want/need to change cover
	else
	if( ShouldChangeCover() && AllowedToMove())
	{
		ClearMovementInfo();

		//debug
		;

		if( HasAnyEnemiesRequiringCover() )
		{
			// move to nearest cover if we don't have cover already
			if( !HasValidCover() || !IsAtCover() )
			{
				// try to move to cover
				MoveToInitialCover();
			}
			else
			{
				// look for some better cover
				MoveToBetterCover( (AcquireCover == ACT_DesireBetter) ? GetCoverSlotMarker() : None );
			}
		}

		// If we failed to find cover
		if( !IsValidCover( CoverGoal ) )
		{
			// then move to the nearest enemy for a couple seconds, then try again
			if( !IsUsingSuppressiveWeapon() &&
				!FailedPathToEnemyRecently( Enemy ) &&
				 VSize(Enemy.Location - Pawn.Location) > EnemyDistance_Short &&
				 IsEnemyWithinCombatZone(Enemy)
			  )
			{
				SetTimer( 3.f,FALSE,nameof(TimedAbortMove) );
				SetTether(Enemy,EnemyDistance_Short,TRUE,2.f);
				TetherActor = None;
				if (!bReachedMoveGoal && ChildStatus != 'Aborted')
				{
					//debug
					;

					// this only happens in my horrible test map, but figured might as
					// well have yet another fallback
					FireFromOpen();

					if( bFailedToFireFromOpen )
					{
						//debug
						;

						Sleep( 0.25f );
						// go to the end and loop all the way back to the beginning so we'll try move to squad and such
						Goto('End');
					}
				}
			}
			else if (!HasValidCover() || !IsAtCover())
			{
				ResetCoverType();

				//debug
				;

				FireFromOpen();

				if( bFailedToFireFromOpen )
				{
					//debug
					;

					Sleep( 0.25f );
					// go to the end and loop all the way back to the beginning so we'll try move to squad and such
					Goto('End');
				}
			}
			else
			{
				SetAcquireCover( ACT_None, "Clearing acquisition check in hopes that things are better" );
			}
		}
		Sleep(0.25f);
		if (MyTGPawn != None && !MyTGPawn.IsAKidnapper() && !MyTGPawn.IsCarryingShield())
		{
			Goto('CoverCheck');
		}
	}
	else
	{
FireFromCover:
		if (MyTGPawn.HealthRechargePercentPerSecond > 0.0 && GetHealthPercentage() < 0.4 && GetDifficultyLevel() > DL_Normal)
		{
			;
			bFailedToFireFromCover = false;
			Sleep(0.75 + FRand());
			Goto('End');
		}
		else if( ShouldFireFromCover() )
		{
			//debug
			;

			FireFromCover();

			//debug
			;
		}
		else
		{
			//debug
			;

			Goto('PeekFromCover');
		}


		if( HasValidCover() && IsAtCover() )
		{
			//debug
			;

			if(AllowedToMove())
			{
				// if this cover is exposed or cover isn't within our assigned zones
				if (!IsCoverWithinCombatZone( Cover ) || ShouldChangeCoverDueToExposure())
				{
					SetAcquireCover( ACT_Immediate, "Change cover immediately CZ:"@IsCoverWithinCombatZone(Cover)@"Exposed:"@IsCoverExposedToAnEnemy(Cover) );
				}
				// if not able to fire
				else if (bFailedToFireFromCover && (WorldInfo.TimeSeconds - LastFireFromCoverTime < 3.f || ShouldFireFromCover()))
				{
					if (WorldInfo.TimeSeconds - LastChangeCoverTime > 20.0)
					{
						SetAcquireCover(ACT_Immediate, "Failed to fire from cover and have been here a long time");
					}
					else
					{
						// acquire new cover on the next loop
						SetAcquireCover(ACT_DesireBetter, "Failed to fire from cover only a short time ago");
						Goto('PeekFromCover');
					}
				}
				// the enemy isn't within our desired ranges
				else if( GetNearEnemyDistance(Pawn.Location) < EnemyDistance_Short ||
					GetNearEnemyDistance(Pawn.Location) > EnemyDistance_Medium )
				{
					// then try to find new cover right away
					SetAcquireCover( ACT_DesireBetter, "Not in optimal range" );
				}
				// if the enemy is attempting to snipe us, try to move between cover slots each time we fire
				// to make ourselves a harder target
				else if (Enemy != None && TGWeapon(Enemy.Weapon) != None && TGWeapon(Enemy.Weapon).bSniping)
				{
					;
					class'Path_CoverSlotsOnly'.static.CoverSlotsOnly(Pawn);
					MoveToBetterCover(GetCoverSlotMarker());
				}
				else
				{
					//debug
					;
				}
			}
		}
		else
		{
			//debug
			;
		}
	}
End:
	//debug
	;

	CheckCombatTransition();
	Goto('Begin');

PeekFromCover:
	//debug
	;

	PeekFromCover();
	if( bFailedToFireFromCover )
	{
		Sleep( 0.5f );
	}
	Goto( 'End' );
}

