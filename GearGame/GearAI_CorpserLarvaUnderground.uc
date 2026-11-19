
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearAI_CorpserLarvaUnderground extends GearAI
	config(AI)
	native(AI);

/** Last Time Corpser was Teleported */
var transient float LastTeleportTime;


var() GearPawn_LocustCorpserLarvaUndergroundBase Corpser;

cpptext
{
	/** Given a list of potential positions where the Corpser can fit, pick the best one based on nearby Enemies. */
	INT FindValidPositionForCorpser(TArray<FVector>& ValidPositions);
}

/** Time Since Last Melee attack to prevent doing them too often. */
var transient float LastMeleeAttackTime;
/** Min time between melee attacks */
var() config float MinTimeBetweenMeleeAttacks;
/** Keep track of how many times we try to find a spot for the corpser. The higher the number, the more generous we become to succeed. */
var transient INT FindSpotNumTries;

/** Find a location around our current enemy, to launch an attack from. Underground. */
native final function bool FindSpotToAttackEnemy(out Vector out_Destination);
/** Find a nearby destructible to attack */
native final function bool FindDestructibleToAttack(out Vector out_Destination, out GearDestructibleObject out_Destructible);
/** Find a nearby fortification to attack */
native final function bool FindFortificationToAttack(out Vector out_Destination, out GearFortification out_Fortification);


/**
 * Overridden for additional init.
 */
event Possess(Pawn NewPawn, bool bVehicleTransition)
{
	Super.Possess(NewPawn, bVehicleTransition);
	
	if( Pawn != None )
	{
		Corpser = GearPawn_LocustCorpserLarvaUndergroundBase(Pawn);
	}
	
	// Must have a squad before you can acquire an enemy
	if (Squad == None)
	{
		SetSquadName('Alpha');
	}

	// Kick start AI, so it doesn't just sit there.
	AutoAcquireEnemy();
}

/** Teleport Corpser to new location. Location has to be tested first as a valid spot! */
function TeleportCorpser(vector NewLocation, Rotator NewRotation)
{
	`AILog(self@GetFuncName());
	LastTeleportTime = WorldInfo.TimeSeconds;
	Pawn.SetLocation(NewLocation);
	Pawn.SetRotation(NewRotation);
}

/** 
 *  Setup Corpser to attack an enemy. 
 *  See if one can be found, with a proper location for the Corpser.
 *  Teleports Corpser there if successful. 
 **/
function bool FindDestinationFromEnemy()
{
	local vector Destination;

	if( !FindSpotToAttackEnemy(Destination) )
	{
		`AILog(self@GetFuncName() @ "Could not find a location to attack enemy.");
		return FALSE;
	}

	TeleportCorpser(Destination, Rotator(Enemy.Location-Pawn.Location));
	return TRUE;
}

function IsUndergroundChangeNotify()
{
	// Have AI reset it's movement when switching underground/above ground states
	AbortMovementCommands();
}

/** Never return to Idle, always stay in combat */
function bool ShouldReturnToIdle()
{
	return FALSE;
}

/** Ignore Banzai behavior */
function BanzaiAttack();

function DoMeleeAttack(optional Pawn NewEnemy, optional Actor InTarget)
{
	local GearPawn_LocustCorpserLarvaUndergroundBase CorpserPawn;

	if( `TimeSince(LastMeleeAttackTime) > MinTimeBetweenMeleeAttacks
		&& !GearPawn(Pawn).IsDoingASpecialMove()
		&& (CachedAICommandList == None || CachedAICommandList.IsAllowedToFireWeapon()) )
	{
		if( NewEnemy != None && NewEnemy != Enemy )
		{
			SetEnemy(NewEnemy);
		}

		LastMeleeAttackTime = WorldInfo.TimeSeconds;
		GearPawn(Pawn).ServerDoSpecialMove(GSM_CorpserLarva_Melee);

		CorpserPawn = GearPawn_LocustCorpserLarvaUndergroundBase(Pawn);
		if( CorpserPawn != None )
		{
			CorpserPawn.WarnAttackIncoming();
		}
	}
}


/** Rates all of the enemies in the LocalEnemyList and sorts them from highest to lowest */
protected function RateAndSortLocalEnemyList()
{
	local int EnemyIdx;
	local GearPawn EnemyGP;
	local float RatingToAdjust;
	local float Distance;
	local Vector EnemyLocation;
	local bool bVisible;
	local CoverInfo EnemyCover;
	local Pawn EnemyP;
	local GearPawn_LocustCorpserLarvaUndergroundBase CorpserPawn;

	// Only override behavior when being underground. Can act normal above ground.
	CorpserPawn = GearPawn_LocustCorpserLarvaUndergroundBase(Pawn);
	if( CorpserPawn != None && !CorpserPawn.bIsUnderground )
	{
		Super.RateAndSortLocalEnemyList();
		return;
	}

	// Loop through the local enemy list and rate each enemy for sorting
	for (EnemyIdx = 0; EnemyIdx < LocalEnemyList.length; EnemyIdx++)
	{
		EnemyP = LocalEnemyList[EnemyIdx].Pawn;
		EnemyGP = GearPawn(EnemyP);
		//debug
		`AILog("Rate:"@EnemyP, 'Enemy');

		EnemyLocation = GetEnemyLocation(EnemyP);
		Distance = VSize(EnemyLocation - Pawn.Location);

		if (EnemyGP != None &&
			EnemyGP.IsDBNO())
		{
			// if we or a squadmate might execute the enemy, then ignore it
			if (Squad.IsTryingToExecute(EnemyGP))
			{
				`AILog("    >>> Ignore DBNO enemy that we want to execute", 'Enemy');
				LocalEnemyList[EnemyIdx].Rating = -1;
				continue;
			}
			// otherwise if we can't finish them from this range, then only if there's no one else
			else if (Distance > 256.0 &&
					 !GearGame(WorldInfo.Game).CanBeShotFromAfarAndKilledWhileDownButNotOut(EnemyGP, Pawn, None) )
			{
				`AILog("    >>> Enemy is DBNO and out of execution range but no other choice evaluated yet", 'Enemy');
				LocalEnemyList[EnemyIdx].Rating = 0;
				continue;
			}
		}

		// Penalty for enemies which are not in a location that is accessible by the corpser digging.
		if( !class'GearPawn_LocustCorpserLarvaUndergroundBase'.static.IsLocationBabyCorpserSafe(WorldInfo, EnemyGP.Location) )
		{
			`AILog("    >>> Enemy is not in a baby corpser safe location", 'Enemy');
			LocalEnemyList[EnemyIdx].Rating *= 0.5f;
		}

		if (EnemyP != None)
		{
			// Initial rating based on distance - longer = weaker rating
			if (Distance < EnemyDistance_Melee)
			{
				LocalEnemyList[EnemyIdx].Rating = 0.1f;
			}
			else if (Distance < EnemyDistance_Short)
			{
				LocalEnemyList[EnemyIdx].Rating = Lerp(0.1f, 0.5f, (Distance - EnemyDistance_Melee) / (EnemyDistance_Short - EnemyDistance_Melee));
			}
			else if (Distance < EnemyDistance_Medium)
			{
				LocalEnemyList[EnemyIdx].Rating = Lerp(0.5f, 2.f, (Distance - EnemyDistance_Short) / (EnemyDistance_Medium - EnemyDistance_Short));
			}
			else
			{
				LocalEnemyList[EnemyIdx].Rating = Lerp(2.f, 0.1f, (FMin(Distance, EnemyDistance_Long) - EnemyDistance_Medium) / (EnemyDistance_Long - EnemyDistance_Medium));
			}   

			// apply human-player biases
			if (EnemyP.IsHumanControlled())
			{
				if (bBerzerk)
				{
					// bias against human players if berserk
					LocalEnemyList[EnemyIdx].Rating *= 0.6f;
				}
				else if (GetDifficultyLevel() > DL_Casual)
				{
					// bias players unless casual
					LocalEnemyList[EnemyIdx].Rating *= 1.5f;
					if (EnemyGP != None &&
						EnemyGP.IsDoingSpecialMove(SM_RoadieRun))
					{
						LocalEnemyList[EnemyIdx].Rating *= 1.5f;
					}
				}
			}

			// prefer not changing targets while firing
			if (EnemyP == FireTarget &&
				IsFiringWeapon())
			{
				LocalEnemyList[EnemyIdx].Rating *= 1.5;
			}
			`AILog( "    >>> Init ="@LocalEnemyList[EnemyIdx].Rating, 'Enemy' );

			if (!IsMeleeRange(EnemyLocation))
			{
				// Bonus if this is the last guy we were hit by AND our current enemy is not shooting at us
				if (Pawn.LastHitBy == EnemyP.Controller &&
					!bBerzerk &&
					(Enemy == None ||
					 Enemy.Controller == None ||
					 Enemy.Controller.Enemy != Pawn))
				{
					LocalEnemyList[EnemyIdx].Rating *= 1.5f;
				}

				`AILog( "    >>> LastHitBy ="@LocalEnemyList[EnemyIdx].Rating, 'Enemy' );

				// Penalty if enemy is not visible
				bVisible = IsEnemyVisible(EnemyP);
				if (!bVisible)
				{
					LocalEnemyList[EnemyIdx].Rating *= 0.5f;
				}
				`AILog( "    >>> Visibility ="@LocalEnemyList[EnemyIdx].Rating, 'Enemy' );

				// avoid shooting at dudes on different path networks if possible
				// (Can only trust non human pawn anchors)
				/* @FIXME navmesh
				if (!EnemyP.IsHumanControlled() &&
					EnemyP.Anchor != None &&
					Pawn.Anchor != None &&
					Pawn.Anchor.NetworkID != EnemyP.Anchor.NetworkID)
				{
					LocalEnemyList[EnemyIdx].Rating *= 0.75f;
				}
				`AILog( "    >>> Anchor ="@LocalEnemyList[EnemyIdx].Rating, 'Enemy' );
				*/

				// Bonus if enemy is not in cover
				if (EnemyGP != None &&
					!GetPlayerCover(EnemyGP, EnemyCover, FALSE))
				{
					LocalEnemyList[EnemyIdx].Rating *= 1.5f;
				}
				`AILog( "    >>> Cover ="@LocalEnemyList[EnemyIdx].Rating, 'Enemy' );

				// bonus vs vehicles and ridables (they're more threatening)
				if (Vehicle(EnemyP) != None || GearPawnRidable_Base(EnemyGP) != None)
				{
					LocalEnemyList[EnemyIdx].Rating *= 1.5f;
				}

				// If can't get fire ticket - severely cripple this enemy
				if (EnemyGP != None &&
					!CanClaimFireTicket(EnemyGP))
				{
					LocalEnemyList[EnemyIdx].Rating *= 0.05f;
				}
				`AILog( "    >>> FireTicket ="@LocalEnemyList[EnemyIdx].Rating, 'Enemy' );

				if (IsTooLongSinceEnemySeen(LocalEnemyList[EnemyIdx].Pawn) ||
					FailedPathToEnemyRecently(LocalEnemyList[EnemyIdx].Pawn))
				{
					LocalEnemyList[EnemyIdx].Rating *= 0.1f;
				}
				`AILog( "    >>> Too Long ="@LocalEnemyList[EnemyIdx].Rating, 'Enemy' );

				// Allow the rating to get adjusted based on AI/Command logic
				RatingToAdjust = LocalEnemyList[EnemyIdx].Rating;
				AdjustEnemyRating(RatingToAdjust, EnemyP);
				LocalEnemyList[EnemyIdx].Rating = RatingToAdjust;
				`AILog( "    >>> Adjust Rating ="@LocalEnemyList[EnemyIdx].Rating, 'Enemy' );
			}

			`AILog( "    >>> Final ="@LocalEnemyList[EnemyIdx].Rating, 'Enemy' );
		}
	}

	// Sort the list
	SortLocalEnemyListByRating();
}

// if corpser can move or not. If stunned, can't move
function bool CanMove()
{
	return (Corpser.IsStunned() == FALSE);
}

defaultproperties
{
	DefaultCommand=class'AICmd_Base_CorpserLarvaUnderground'
	DefaultReactConditions.Empty
	DefaultReactConditionClasses.Empty

// 	// have to re-init the delegates here so they get the right function object
// 	// melee reaction
// 	Begin Object Name=EnemyInMeleeRangeReaction0
// 		OutputFunction=BeginMeleeCommandWrapper
// 	End Object
// 	DefaultReactConditions.Add(EnemyInMeleeRangeReaction0)

	bCanRevive=FALSE
	bPreferMelee=TRUE
}
