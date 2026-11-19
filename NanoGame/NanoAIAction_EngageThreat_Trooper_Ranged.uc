/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_EngageThreat_Trooper_Ranged extends NanoAIAction_EngageThreat_Trooper within NanoAI_Trooper
	config(AI);


var transient bool bIsActivelyFiring;


var config float IfPlayerIsEscaping_MaxDistRangedQuery;

/** How close the target needs to be to be considered near a friendly. **/
var config float NearFriendlyDist;


var transient TargetableOctreeComponent CurrTargetable;



var config float HowLongBetweenFiring;
var transient float LongSinceWeStartedWaitingToFire;


static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;
	local array<int> StimulusIndices;
//	local bool bDefensivePointUnderAttack;
	local vector PlayerLocation;
	local TargetableOctreeComponent Targetable;

	local NanoAIBlackboard Blackboard;
	local bool bRoomInRangedList;
	local bool bRangedRingsHaveRoom;

	local StimulusQuery ModifiedRangedEngageThreatQuery;


	if( InAI.FireTarget == None )
	{
		`AILog_Ext( GetFuncName() @ "FireTarget is None!!",, InAI );
		InAI.PossiblyPickFireTarget();
		return 0;
	}

	if( InAI.FireTarget.IsTargetable() == FALSE ) // something is not clearing the firetarget correctly
	{
		`AILog_Ext( GetFuncName() @ "Invalid FireTarget!!" @ `showvar(InAI.FireTarget) @ `showvar(InAI.FireTarget.IsTargetable()),, InAI );
		return 0;
	}


	if( NanoPawn(InAI.Pawn).CurrentLadder != None )
	{
		`AILog_Ext( GetFuncName() @ "InAI.Pawn is on a ladder!!" @ `showvar(InAI.FireTarget) @ `showvar(InAI.FireTarget.IsTargetable()),, InAI );
		return 0;
	}

	Targetable = InAI.FireTarget.GetTargetableOctreeComponent();

	Blackboard = InAI.GetBlackBoard();

	if( Targetable.bHasOverridesForMeleeListRanges == TRUE )
	{
		bRangedRingsHaveRoom = ( Targetable.RangedShooterList.Length < Targetable.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumRangedShooter );
	}
	else
	{
		bRangedRingsHaveRoom = ( Targetable.RangedShooterList.Length < Blackboard.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumRangedShooter );
	}



	if( ( bRangedRingsHaveRoom == TRUE )
		|| ( Targetable.RangedShooterList.Find(InAI) != INDEX_NONE )
		)
	{
		bRoomInRangedList = TRUE;
	}


	if ( bRoomInRangedList == FALSE )
	{
		`AILog_Ext( GetFuncName() @ "No room in list" @ `showvar(Targetable.RangedShooterList.Length) @ `showvar(Blackboard.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumRangedShooter),, InAI );
		//`log( "No room in list" @ `showvar(Targetable.RangedShooterList.Length) @ `showvar(Blackboard.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumRangedShooter) );
		return 0;
	}


	// ughh we have to short circuit the AmIAllowedToAttack() call here as that as all of the timing shizzle
	if( InAI.bMAI_RangeAttackPlayer == TRUE )
	{
		`AILog_Ext( "Doing a Manual AI Ranged attack",, InAI );
		InAI.bMAI_RangeAttackPlayer = FALSE;
		InAI.bMAI_OverrideAttackPacing = FALSE;
		return 520;
	}


//	bDefensivePointUnderAttack = InAI.CurrNanoDefensivePoint != None ? InAI.CurrNanoDefensivePoint.bUnderAttack : FALSE;

	
// 	// prob need to check that the player is on a NavMesh that is classified as a bRooftop (right now we don't have that)
// 	if( ( ( NanoAI_Trooper(InAI).ConfrontationType == ECFT_RooftopSentinel ) || ( bDefensivePointUnderAttack == TRUE ) )
// 		&& ( NanoGRI(InAI.WorldInfo.GRI).WorldStateSettings.bRoofTraversalIsOutlawed == TRUE ) 
// 		)
// 	{
// 		NanoAI_Trooper(InAI).RangedEngageThreatQuery.bRequireDamaged = FALSE;
// 		NanoAI_Trooper(InAI).RangedEngageThreatQuery.bRequireCombative = QO_Allow;
// 		NanoAI_Trooper(InAI).RangedEngageThreatQuery.Visibility = QO_Require;
// 		NanoAI_Trooper(InAI).RangedEngageThreatQuery.MinDist = 512;
// 	}
// 	else
// 	{
// 	//	NanoAI_Trooper(InAI).RangedEngageThreatQuery.bRequireCombative = NanoAI_Trooper(InAI).default.RangedEngageThreatQuery.bRequireCombative;
// 	//	NanoAI_Trooper(InAI).RangedEngageThreatQuery.Visibility = NanoAI_Trooper(InAI).default.RangedEngageThreatQuery.Visibility;
// 	//	NanoAI_Trooper(InAI).RangedEngageThreatQuery.MinDist = NanoAI_Trooper(InAI).default.RangedEngageThreatQuery.MinDist;;
// 	}


	ModifiedRangedEngageThreatQuery = NanoAI_Trooper(InAI).RangedEngageThreatQuery;

	if( NanoGRI(InAI.WorldInfo.GRI).NED.IsPlayerDoing( 'Escaping' ) == TRUE )
	{
		ModifiedRangedEngageThreatQuery.MaxDist = default.IfPlayerIsEscaping_MaxDistRangedQuery;
	}


	if( ( InAI.MultipleResultStimulusQuery( ModifiedRangedEngageThreatQuery, StimulusIndices ) > 0 )
		)
	{
		//`log( "ModifiedRangedEngageThreatQuery yes!" );
		Retval += default.UtilityStartVal;
	}

	//// so here let's try to try to do the logic we need to do instead of trying to get the query system even more complicated.

	PlayerLocation = NanoGRI(InAI.WorldInfo.GRI).NPES.GetPlayerLocation();

	// check to see if they foe is "close to us" on the ground
	if( VSize2D(InAI.Pawn.Location - PlayerLocation) < ModifiedRangedEngageThreatQuery.MinDist )
	{
		// check to see if the foe is "Z height difference" such that we can't engage them?   (do we need to do a path find instead?)
		if( ( ( ( InAI.Pawn.Location.Z - PlayerLocation.Z ) < -256.0f ) || ( ( InAI.Pawn.Location.Z - PlayerLocation.Z ) > 256.0f ) )
			&& ( NanoGRI(InAI.WorldInfo.GRI).GetPlayerPawn().Base != None )
			)
		{
			//`log( "foe is standing on something" );
			Retval += 90;
		}
	}


	// here we check to make certain that there is a pawn in the Engaged Melee distance.
	// if there is no one actively engaging then we we should try to shoot but instead try to engage melee
	if ( Targetable.MeleeEngageList.Length == 0 )
	{
		Retval -= 50;
	}

	if( InAI.bTryingToTargetWithLaserSight == TRUE )
	{
		Retval += 10;
	}


	return Retval;
}


function Pushed()
{ 
	Super.Pushed();	

	if( ( LastConfrontationType == ECFT_Melee_Engaged ) || ( LastConfrontationType == ECFT_Melee_Standby ) || ( LastConfrontationType == ECFT_Melee_Spectator ) )
	{
		NanoGRI(WorldInfo.GRI).AttemptToPlayLine(EDLine_Combat_SwitchToFireArms,Pawn);
	}

	if( ConfrontationType != ECFT_RooftopSentinel )
	{
		SetConfrontationType( ECFT_Ranged );
	}

	FireTarget.GetTargetableOctreeComponent().RangedShooterList.AddItem( Outer );
}


function Popped()
{ 
	Super.Popped();
	SetActiveBoidMovementByClass( class'BoidRule_TrooperRanged', FALSE );
	SetActiveBoidMovementByClass( class'BoidRule_TrooperRangedCloser', FALSE );
	//HandleBoidAlteringEvent( 'WaitingForAttackToFinish', TRUE );

	if( ConfrontationType != ECFT_RooftopSentinel )
	{
		SetConfrontationType( ECFT_None );
	}

	FireTarget.GetTargetableOctreeComponent().RangedShooterList.RemoveItem( Outer );


	// we could have forcibly gotten popped so let's clean up the firing state
	CleanUpStartFiringVars();

	bTryingToTargetWithLaserSight = FALSE;
}


function CleanUpStartFiringVars()
{
	// if we were firing and were interrupted
	if( bIsActivelyFiring == TRUE ) FireTarget.GetTargetableOctreeComponent().NumCurrentlyShooting--;
	bIsActivelyFiring = FALSE;

	StopFiring();
	bWaitingForActiveAttack = TRUE;
	MyTrooper.bAimAnim = FALSE;
}


function RangedAttackTimeOut()
{
	`AILog( GetFuncName() @ `location );

	CleanUpStartFiringVars();

	Status = 'Failure';
	AbortCommand( self );
}


/** Looks at the FireTarget and compares how close it is to friendlies **/
function bool IsNearFriendlies( float InNearFriendlyDist )
{
	local NanoPawnBase NP;

	foreach WorldInfo.AllPawns( class'NanoPawnBase', NP )
	{
		// not ourselves and not the firetarget
		if( ( NP != Pawn ) && ( NP != FireTarget ) )
		{
			if( VSize( NP.Location - FireTarget.GetTargetedLocation() ) < InNearFriendlyDist )
			{
				`AILog( "FireTarget is near friendly" @ `showvar(NP) @ `showvar(VSize( NP.Location - FireTarget.GetTargetedLocation() ) ) );
				return TRUE;
			}
		}
	}

	return FALSE;
}


/** We override this so we can check NearFriendlyDist **/
function TryToFireWeapon()
{
	if (FireTarget != None)
	{
		Focus = FireTarget;
		if( NanoWeap_Melee(Pawn.Weapon) != None || (LineOfSightTo(FireTarget) && !IsFireLineBlocked() && ( IsNearFriendlies(NearFriendlyDist) == FALSE )) )
		{
			`AILog("firing at target");
			Pawn.StartFire(GetFireMode());
			bAttemptingToFireWeapon = FALSE;
		}
		else
		{
			`AILog(GetFuncName()@"no LOS to target");
			SetTimer(0.25f,FALSE,nameof(TryToFireWeapon));
		}
	}
	else
	{
		`AILog("Lost fire target, aborting fire attempt");
		StopFiring();
	}
}



state Combat_RangedAttack extends Combat
{
	simulated function Texture2D GetDebugIcon() { return Texture2D'UI_HUD.AI.T_UI_Debug_Icons_CombatRanged'; }


	function BeginState(Name PrevStateName)
	{
		local NanoWeapon RangedWeap;

		Super.BeginState(PrevStateName);

		// See if the trooper already has a gun
		RangedWeap = NanoWeapon(MyTrooper.InvManager.FindInventoryType(MyTrooper.PreferredRangedWeaponClass));
		if( RangedWeap != None )
		{
			// We have one, switch to it
			MyTrooper.InvManager.SetCurrentWeapon(RangedWeap);
			//`log( "setting" @ `showvar(RangedWeap));
		}
		else
		{
			//`log( "spawning a new weapon!" );
			// No weapon, spawn a new one
			MyTrooper.SpawnMyPreferredWeapon();
		}
		
		InitBoidRulesForState();

		NanoGRI(WorldInfo.GRI).GetMusicManager().HandleMusicEvent( EME_CombatStarts );

		//SetTimer( 15.0f, FALSE, nameof(self.RangedAttackTimeOut), self);
	}

	function EndState( Name NextStateName )
	{
		// Make sure they don't stay in the aim animation
		MyTrooper.bAimAnim = FALSE;

		Super.EndState( NextStateName );
		HandleBoidAlteringEvent( 'WaitingForAttackToFinish', TRUE );
		SetActiveBoidMovementByClass( Combat_RangedAttack_BoidRuleBeingFollowed, FALSE );
		ClearTimer( nameof(self.RangedAttackTimeOut), self);
	}


	function InitBoidRulesForState()
	{
		Combat_RangedAttack_BoidRuleBeingFollowed = class'BoidRule_TrooperRanged';
		SetActiveBoidMovementByClass( Combat_RangedAttack_BoidRuleBeingFollowed, TRUE );
	}




// 	function bool ShouldTransitionToMelee()
// 	{
// 		local array<int> StimulusIndices;
// 		local int StimIdx;
// 
// 		if( (`TimeSince(TimeOfTransition) > 2.f) || TRUE ) // the issue with the TimeSince is that we are doing a lot of transitioning so we don't ever get to pull this off.  We probably want something here so we don't just ping pong back and forth but I think it might need to be something like TimeOfTransition<TYPE> to not care if the AI transitioned from A A1 A2   but do care if transition to B
// 		{
// 
// 			// we use this as we want the guys that are "pushing" up to go into melee more than other guys.  Also this range is a range which 
// 			// is considered "scary omg the ai is coming to get me"  So the player should be trying to kill this guy or bad things 
// 			// (e.g. melee mode!! will occur)
// 		//	Query.MaxDist = class'BoidRule_TrooperRangedCloser'.default.MaxDistanceToStandFromFoe; 
// 			if (MultipleResultStimulusQuery(MeleeEngageThreatQuery,StimulusIndices) > 0)
// 			{
// 				if (StimulusIndices.Length > 3)
// 				{
// 					return TRUE;
// 				}
// 				else
// 				{
// 					// okie so now we didn't hit the magic number above.  BUT we may still have stimulus that is close to us
// 					// we need to check to see if it is real close and then switch to melee as we are being rushed more than likely
// 					foreach StimulusIndices( StimIdx )
// 					{
// 						//`log( "stim" @ VSize( Stimuli[StimIdx].Location - Pawn.Location ) );
// 						if( ( Stimuli[StimIdx].bIsFriendly == FALSE )
// 							&& ( VSize( Stimuli[StimIdx].Location - Pawn.Location ) < DistanceForAutoSwitchToMelee
// 							&& Stimuli[StimIdx].bVisible )
// 							)
// 						{
// 							`AILog( "someone is trying to rush me!" @ Stimuli[StimIdx].Actor );
// 							return TRUE;
// 						}
// 					}
// 
// 					return FRand() < (StimulusIndices.Length/3.f);
// 				}
// 			}
// 		}
// 
// 		return FALSE;
// 	}


	/** This will check a number of things to see if we should throw the tesla at the player **/
	function bool ShouldTransitionToThrowingTesla()
	{
		local int Idx;
		local bool bPlayerIsTurtling;
		local array<Vector> TeslaLocations;
		local Vector CurrTargetLocation;
		local bool bTeslaCoilNearTarget;

		if( ( NumBatonsToThrowLeft > 0 )
			&& ( IsAnyoneElseThrowingATeslaCoil() == FALSE )
			)
		{
			for( Idx = 0; Idx < Stimuli.Length; ++Idx )
			{
				// if we have a valid throw query
				// and enough time has passed for us to look again
				if( ( StimulusPassesQuery(Idx,StandardThrowTeslaCoilQuery) == TRUE )
					&& ( `TimeSince(TimeOfLastCampingCheck) > TimeStandingStillToBeConsideredCamping )
					)
				{
					CurrTargetLocation = Stimuli[Idx].Location;
					//`log( "query is valid!" @ Idx @ VSize( Stimuli[Idx].Location - LastLocationPlayerStanding) @ WorldInfo.TimeSeconds );
					// check to see if the player has moved out of the camping radius
					if( VSize(CurrTargetLocation - LastLocationPlayerStanding) < RadiusFromLastLocationToBeConsideredCamping )
					{
						`AILog( "we have a turtler!!" );
						bPlayerIsTurtling = TRUE;

						// so now that we have a turtler we need to check and see if there is already a tesla coil there
						TeslaLocations = NanoGRI(WorldInfo.GRI).GetAllClassTypesAroundLocation( class'TeslaCoil', CurrTargetLocation, RadiusFromOtherTeslasForValidTossTarget );

						// so now if there are no teslas near our target we can throw (otherwise it becomes silly as there are just a ton of teslas all in one area)
						if( TeslaLocations.Length > 0 )
						{
							bTeslaCoilNearTarget = TRUE;
						}
					}

					LastLocationPlayerStanding = CurrTargetLocation;
					TimeOfLastCampingCheck = WorldInfo.TimeSeconds;
				}
			}


			// now check all our bools to see if we should toss the tesla coil
			if( ( bPlayerIsTurtling == TRUE )
				&& ( bTeslaCoilNearTarget == FALSE )
				)
			{
				return TRUE;
			}
		}

		return FALSE;
	}


	/** This checks to see if anyone else is tossing a tesla coil.  We don't want to end up with N ai all tossing into the same location at once. **/
	function bool IsAnyoneElseThrowingATeslaCoil()
	{
		local NanoAI AI;

		foreach WorldInfo.AllControllers( class'NanoAI', AI )
		{
			//`log( self @ "IsAnyoneElseThrowingATeslaCoil: " @ AI.GetStateName() );
			if( AI.IsInState( 'Combat_ThrowTesla' ) == TRUE )
			{
				//`log( "Found an AI in Combat_ThrowTesla" );
				return TRUE;
			}
		}

		return FALSE;
	}


	function PossiblyMoveToFireLocation()
	{
		local vector NewLocation, FireLineCross;
		`AILog(`location);
		if (PickDefensePoint(FireTarget) && !IsCloseEnoughToDefensePoint())
		{
			`AILog("Moving towards defense point");
			MoveToActor( CurrentDefensePoint );
		}
		else if (FireTarget != None)
		{
			NewLocation = Pawn.Location;
			if ((bAttemptingToFireWeapon && FRand() > 0.85) || (!bAttemptingToFireWeapon && FRand() > 0.5f))
			{
				// strafe left/right
				FireLineCross = Normal((FireTarget.GetTargetedLocation() - NewLocation) cross vect(0,0,1));
				if (FRand() > 0.5)
				{
					NewLocation += FireLineCross * RandRange(256.f,384.f);
				}
				else
				{
					NewLocation -= FireLineCross * RandRange(256.f,384.f);
				}
				// close distance a bit if not at a defense point
				if (CurrentDefensePoint == None && VSize2D(FireTarget.GetTargetedLocation() - NewLocation) < 512.f)
				{
					NewLocation += Normal(NewLocation - FireTarget.GetTargetedLocation()) * 256.f;
				}
			}
			if (NewLocation != Pawn.Location)
			{
				MoveToLocation( NewLocation, 3.f, TRUE );
			}
		}
	}



	function bool IsPointWithinRange( Vector Pt )
	{
		return VSize2D(Pt - Pawn.Location) < 1024.f;
	}


	/** This will check to see if this AI should push forward to help motivate the player to move. **/
	function PossiblyChangeBoidRuleToMoveCloser()
	{
		local int AttackerIdx;
		local bool bSomeOneIsAlreadyPushingForward;
		local NanoPawnBase FireTargetNP;

		FireTargetNP = NanoPawnBase(FireTarget);


		// so now we want to see if we should change our boid rules class
		if( FireTargetNP != none )
		{
			// if we have 3 or more people attacking our target then we have an advantage 
			// and one of us should try and close the distance
			if( FireTargetNP.AttackerList.Length >= 3 )
			{
				// let's make certain only 1 attacker pushes forward at once
				for( AttackerIdx = 0; AttackerIdx < FireTargetNP.AttackerList.Length; ++AttackerIdx )
				{
					if( ( FireTargetNP.AttackerList[AttackerIdx] != None )
					 && ( FireTargetNP.AttackerList[AttackerIdx].IsPushingForward() == TRUE )
					 )
					{
						bSomeOneIsAlreadyPushingForward = TRUE;
						break;
					}
				}

				// no one is pushing forward so we can!
				if( bSomeOneIsAlreadyPushingForward == FALSE )
				{
					`AILog( "Pushing forward!" );
					ClearBoidMovementByClass( Combat_RangedAttack_BoidRuleBeingFollowed );
					SetConfrontationType( ECFT_RangedCloser );
					Combat_RangedAttack_BoidRuleBeingFollowed = class'BoidRule_TrooperRangedCloser';
				}
			}
		}
	}

Begin:
	`AILog( GetStateName()@"Begin TAG" );
	SetActiveBoidMovementByClass( Combat_RangedAttack_BoidRuleBeingFollowed, FALSE );
	bWaitingForActiveAttack = FALSE;

	CurrTargetable = FireTarget.GetTargetableOctreeComponent();


	if( CurrTargetable.NumCurrentlyShooting >= GetAIBlackboard().GetNumShootingAtOnce() )
	{
		//`log( " too many " @ `showvar(GetAIBlackboard().NumCurrentlyShooting) @ `showvar(GetAIBlackboard().MeleeListRanges[GetAIBlackboard().CachedCurrChaosTier].NumShootingAtOnce) );
		//`AILog( GetStateName() @ "Too many people all shooting at once: " @ `showvar(GetAIBlackboard().NumCurrentlyShooting) @ `showvar(GetAIBlackboard().MeleeListRanges[GetAIBlackboard().CachedCurrChaosTier].NumShootingAtOnce) );
		Sleep( 0.1f );
		Goto( 'Begin' );
	}

	// if we failed to roll to actually shoot
	if( FRand() > GetAIBlackboard().ChanceToShootPerTier[GetAIBlackboard().CachedCurrChaosTier] )
	{
		//`log( "frand "  @ `showvar(GetAIBlackboard().ChanceToShootPerTier[GetAIBlackboard().CachedCurrChaosTier]) );
		//`AILog( GetStateName() @ "Failed to FRand under: " @ `showvar(GetAIBlackboard().ChanceToShootPerTier[GetAIBlackboard().CachedCurrChaosTier]) );
		Sleep( 1.0f );
		Goto( 'Begin' );
	}


	//PossiblyTransitionTo('Combat_ThrowTesla',ShouldTransitionToThrowingTesla);
	//PossiblyTransitionTo('Combat_RangedAttack_Shield',ShouldTransitionToRangedShield);
	//PossiblyTransitionTo('Alert',ShouldTransitionToAlert);
	//PossiblyTransitionTo('Combat_MeleeAttack',ShouldTransitionToMelee);
	PossiblyPickFireTarget();
	PossiblyChangeBoidRuleToMoveCloser();

	if( ( CanActivelyAttackTarget( LastErrorCode ) ) // checks fire tickets, checks that if target is held it is on front
		&& ( IsNearFriendlies( NearFriendlyDist ) == FALSE ) // checks to see that the target is not near other friendlies
		)
	{

		LongSinceWeStartedWaitingToFire = 0.0f;
		do
		{
			bTryingToTargetWithLaserSight = TRUE;
			SetRotation(rotator(FireTarget.GetTargetedLocation() - Pawn.Location));
			NanoWeap_MP7(Pawn.Weapon).GetAimRotation(rotator(FireTarget.GetTargetedLocation() - Pawn.Location));
			Sleep(0.1f);
			LongSinceWeStartedWaitingToFire += 0.1f;
		} until ( LongSinceWeStartedWaitingToFire >= HowLongBetweenFiring );


		bIsActivelyFiring = TRUE;
		CurrTargetable.NumCurrentlyShooting++;
		StartFiring();
		MyTrooper.bAimAnim = TRUE;
	}
	else
	{
		CleanUpStartFiringVars();
	}

	if( LastErrorCode == 'AttackFail_NoLOS' )
	{
		// oh !  need to have more constraints on what this guy should be doing :(
		class'NanoAICmd_Move_UntilInRange'.static.MoveToVisibleActor(Outer,FireTarget,FALSE);
	}
	else
	{
		SetActiveBoidMovementByClass( Combat_RangedAttack_BoidRuleBeingFollowed, TRUE );
	}

	// always set this.
	SetActiveBoidMovementByClass( Combat_RangedAttack_BoidRuleBeingFollowed, TRUE );

	if (bWaitingForActiveAttack)
	{
		PossiblyMoveToFireLocation();
		Goto('WaitingForAnActiveAttack');
	}

WaitingForAttackToFinish:
	`AILog( GetStateName()@"WaitingForAttackToFinish TAG" );

	SetTimer( 5.f, FALSE, nameof(self.RangedAttackTimeOut), self);

	HandleBoidAlteringEvent( 'WaitingForAttackToFinish', FALSE );
	MyTrooper.ZeroMovementVariables();
	// wait for attack to finish
	do
	{
		`AILog( "Waiting for Attack to finish Ranged" @ `showvar(bAttemptingToFireWeapon) @ `showvar(IsFiringWeapon()), 'Loop' );
		Sleep(0.5f);
	} until (!bAttemptingToFireWeapon && !IsFiringWeapon());
	ClearTimer( nameof(self.RangedAttackTimeOut), self);

	`AILog("Finished firing"@`showvar(bAttemptingToFireWeapon)@IsFiringWeapon());
	Sleep(MyTrooper.FullBodySlot.PlayCustomAnim('SMG_Reload_4th',2.f,0.2f,0.2f));
	HandleBoidAlteringEvent( 'WaitingForAttackToFinish', TRUE );

AttackFinished:
	`AILog( GetStateName()@"AttackFinished TAG" );
	if( bIsActivelyFiring == TRUE ) CurrTargetable.NumCurrentlyShooting--;
	bIsActivelyFiring = FALSE;
	Goto('Begin');

WaitingForAnActiveAttack:
	`AILog( GetStateName()@"WaitingForAnActiveAttack TAG" );
	if( bIsActivelyFiring == TRUE ) CurrTargetable.NumCurrentlyShooting--;
	bIsActivelyFiring = FALSE;
	do
	{
		`AILog( "Waiting for an active attack" @ `showvar(LastErrorCode) @ `showvar(bWaitingForActiveAttack) , 'Loop' );
		Sleep(0.5f);
		PossiblyPickFireTarget();
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
	StartingStateName="Combat_RangedAttack"
}