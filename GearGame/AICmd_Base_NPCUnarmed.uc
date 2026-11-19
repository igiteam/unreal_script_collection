/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Base_NPCUnarmed extends AICommand_Base_Combat
	within GearAI_Cover;

/** GoW global macros */

function Pushed()
{
	local bool bInitReact;
	Super.Pushed();

	// turn on flank reactions
	ReactionManager.UnSuppressReactionsByType(class'AIReactCond_Flanked',false);

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
	ReactionManager.SuppressReactionsByType(class'AIReactCond_Flanked',false);
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

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
		MoveToNearestCoverIdle();
	}

	/** used when the AI is in cover but wants to evaluate moving to different cover */
	protected function MoveToBetterCover( optional CoverInfo PrevBestCover )
	{
		local CoverInfo NewCover;

		// search for cover either towards/away based on closest enemy distance
		if( EvaluateCover( SearchType_Away, Enemy, NewCover,PrevBestCover ) )
		{
			//debug
			`AILog( "Moving to better cover"@NewCover.Link.GetDebugString(NewCover.SlotIdx) );

			// moving on up
			SetCoverGoal( NewCover, TRUE );

			if( Pawn.GetTeamNum() != 0 )
			{
				GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_TransToRetreatAI, Pawn);
			}
		}
		else
		{
			//debug
			`AILog("Unable to find mo'bettah covar!! :("@Cover.Link@Cover.SlotIdx );

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
			`TimeSince(EnterCoverTime) >= MinStayAtCoverTime) &&
			AllowedToMove())
		{
			return TRUE;
		}

		return FALSE;
	}

	/** @return if we need to change cover immediately because we are too exposed */
	protected final function bool ShouldChangeCoverDueToExposure()
	{
		local float ExposedScale;
		local bool	bResult;

		// if we are significantly exposed or we're somewhat exposed but taking damage
		bResult = IsCoverExposedToAnEnemy(Cover,, ExposedScale);

		//debug
		`AILog( GetFuncName()@bResult@ExposedScale@GetHealthPercentage() );

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
	`AILog( "BEGIN TAG"@ShouldMoveToSquad()@AcquireCover@HasValidCover()@IsAtCover()@Cover.Link@Cover.SlotIdx@PrintTetherInfo(), 'State' );

	// check to see if we should move to our squad
	if( ShouldMoveToSquad() )
	{
MoveToSquad:
		//debug
		`AILog( "MOVETOSQUAD TAG", 'State' );

		MoveToSquadPosition();
	}
CoverCheck:
	//debug
	`AILog( "COVERCHECK TAG", 'State' );

	// make sure we can acquire an enemy
	if( !SelectEnemy() )
	{
		//debug
		`AILog( "Unable to acquire an enemy", 'Combat' );

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

	//debug
	`AILog( "Move to cover?"@AcquireCover@HasValidCover()@IsAtCover()@`TimeSince(EnterCoverTime)@AllowedToMove() );

	if(!AllowedToMove() && !HasValidCover())
	{
		// if we're not allowed to move, and we don't have valid cover check to see if we have a move action trying to get us into cover.. if so reapply it
		if(MoveAction != none && MoveAction.DestinationSlotIndex > -1 && MoveAction.Targets.length > 0)
		{
			`AILog(">>> I'm not allowed to move, and I have a tethered cover node, but I'm not at it!  Re-initing move action to get back to my tether");
			OnAIMove(MoveAction);
		}
		else
		{
			Sleep( 0.25f );
			// go to the end and loop all the way back to the beginning so we'll try move to squad and such
			Goto('End');
		}
	}
	// check to see if we want/need to change cover
	else
	if( ShouldChangeCover() && AllowedToMove())
	{
		ClearMovementInfo();

		//debug
		`AILog( "ShouldChangeCover() TRUE!"@HasAnyEnemiesRequiringCover() );

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
				if( AcquireCover == ACT_DesireBetter )
				{
					MoveToBetterCover( Cover );
				}
				else
				{
					MoveToBetterCover();
				}
			}
		}

		// If we failed to find cover
		if( !IsValidCover( CoverGoal ) )
		{
			if (!HasValidCover() || !IsAtCover())
			{
				ResetCoverType();
				Sleep( 0.25f );
				// go to the end and loop all the way back to the beginning so we'll try move to squad and such
				Goto('End');
			}
			else
			{
				SetAcquireCover( ACT_None, "Clearing acquisition check in hopes that things are better" );
			}
		}
		Sleep(0.25f);
		Goto('CoverCheck');
	}
	else
	{
		if (MyGearPawn.HealthRechargePercentPerSecond > 0.0 && GetHealthPercentage() < 0.4)
		{
			`AILog("Hide in cover while health recharges");
			bFailedToFireFromCover = false;
			Sleep(0.75 + FRand());
			Goto('End');
		}
		else
		{
			//debug
			`AILog("Peeking from cover"@`TimeSince(LastFireFromCoverTime) );
			Goto('PeekFromCover');
		}

		if( HasValidCover() && IsAtCover() )
		{
			//debug
			`AILog( "Cover is currently valid... failed?"@bFailedToFireFromCover@`TimeSince(LastFireFromCoverTime)@`TimeSince(EnterCoverTime)@IsCoverWithinCombatZone( Cover )@ShouldChangeCoverDueToExposure()@AllowedToMove() );

			if(AllowedToMove())
			{
				// if this cover is exposed or cover isn't within our assigned zones
				if (!IsCoverWithinCombatZone( Cover ) || ShouldChangeCoverDueToExposure())
				{
					SetAcquireCover( ACT_Immediate, "Change cover immediately CZ:"@IsCoverWithinCombatZone(Cover)@"Exposed:"@IsCoverExposedToAnEnemy(Cover) );
				}
				// if the enemy is attempting to snipe us, try to move between cover slots each time we fire
				// to make ourselves a harder target
				else if (Enemy != None && GearWeapon(Enemy.Weapon) != None && GearWeapon(Enemy.Weapon).bSniping)
				{
					`AILog("Switch coverslots to evade sniping enemy");
					MoveToBetterCover( Cover );
				}
				else if (WorldInfo.TimeSeconds - LastChangeCoverTime > 20.0)
				{
					// acquire new cover on the next loop
					SetAcquireCover(ACT_DesireBetter, "Failed to fire from cover only a short time ago");
					Goto('PeekFromCover');
				}
				else
				{
					//debug
					`AILog( "Everything is happy"@AcquireCover );
				}
			}
		}
		else
		{
			//debug
			`AILog( "Something not happy"@bFailedToFireFromCover@`TimeSince(LastFireFromCoverTime)@AcquireCover@HasValidCover()@IsAtCover() );
		}
	}
End:
	//debug
	`AILog( "END TAG", 'State' );

	CheckCombatTransition();
	Goto('Begin');

PeekFromCover:
	//debug
	`AILog( "PEEKFROMCOVER TAG", 'State' );

	if (!PeekFromCover())
	{
		Sleep(0.0); // sanity to make sure we don't get infinite recursion
	}
	Goto( 'End' );
}

defaultproperties
{
}
