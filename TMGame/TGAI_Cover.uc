class TGAI_Cover extends TGAI
	native(TGAI)
	dependson(TGPawn)
	config(TGAI);

/** GoW global macros */

const TIMER_ADJUSTTOSLOT_LIMIT = 5.f;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

enum ECoverSearchType
{
	SearchType_Towards,
	SearchType_Away,
	SearchType_Near,
	SearchType_Ambush,
	SearchType_AlongPath,
};

/** Currently claimed cover */
var			CoverInfo		Cover;
/** Cover we are moving to */
var			CoverInfo		CoverGoal;
/** Last claimed cover */
var			CoverInfo		LastCover;
/** Time that we entered most recent cover */
var			float			EnterCoverTime;

/** Min amount of time to stay in uncompromised cover */
var	config	float			MinStayAtCoverTime;
/** Action that will be taken after transition anim is complete */
var			FireLinkItem	PendingFireLinkItem;
var			ECoverType		OldCoverType;
/** No ranged weapons so ignore fire links in cover eval */
var			bool			bIgnoreFireLinks;
/** Last time we attempted to run to cover */
var			float			LastRun2CoverTime;
/** Flag set to indicate we should start a run 2 cover */
var			bool			bShouldRun2Cover;
/** Last time we tried to fire from cover */
var			float			LastFireFromCoverTime;
/** last time we changed cover (called AICmd_MoveToCover with something different than current cover) */
var float LastChangeCoverTime;
/** Ideal/Min/Max distance to search for cover when flooding the network */
var			float			DesiredCoverMoveDist,
							MinCoverMoveDist,
							MaxCoverMoveDist;
/** Failsafe time used to prevent getting stuck in AdjustToSlot */
var			float			AdjustToSlotTime;
/** Used for cover searching via FindCover */
var transient bool			bSkipMinCoverDistCheck,
							bSkipMaxCoverDistCheck;
/** Marker AI is running to */
var transient CoverSlotMarker Run2CoverMarker;
/** Next time this AI is allowed to peek */
var			float			NextAllowPeekTime;


/** Last time we played a meat shield reaction **/
var float LastMeatShieldReactionTime;
/** Minimum amount of time in between meat shield reactions **/
var() config float MeatShield_Reaction_MinTimeInterval;
/** Chance that we will react to a given meat shield event **/
var() config float MeatShield_Reaction_Chance;
/** Time after noticing meat shield to play the reaction **/
var() config float MeatShield_Reaction_Delay;
var TGPawn MeatShield_Reaction_Target;

/** for SP only - inventory the LD has given the AI the OK to pick up (AI ignores all other pickups) */
var array< class<TGWeapon> > SPItemsToConsider;

/** default AtCover goal evaluater profiles */
var instanced Goal_AtCover AtCover_Toward;
var instanced Goal_AtCover AtCover_Away;
var instanced Goal_AtCover AtCover_Near;
var instanced Goal_AtCover AtCover_Squad;
var instanced Goal_AtCover AtCover_Ambush;
var instanced Goal_AtCover AtCover_AlongPath;
var instanced Goal_AtCover AtCover_Best;

/** list of cover links this AI is allowed to use for cover (if blank all cover is fair game) */
var array<CoverLink> AllowedCoverLinks;

/** template for instancing stopping power reaction - should not be attached itself */
var AIReactCond_StoppingPowerThreshold StoppingPowerReactionTemplate;

// next time we setcovertype, don't pushoutofcover (will be reset once we successfully leave cover)
var bool bLeaveCoverFast;

// forces log output (even in FINAL_RELEASE) use with caution!
native final function ForceLog(coerce string s);

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
	local AIReactCond_StoppingPowerThreshold ReactCond;

	Super.Possess( NewPawn, bVehicleTransition );

	//`AILog(self@MyTGPawn@MyTGPawn.bAllowStoppingPower);
	//`log(self@MyTGPawn@MyTGPawn.bAllowStoppingPower);

	if( MyTGPawn != None )
	{
		// Only let AI slide half the distance to cover
		MyTGPawn.Run2CoverMaxDist	= MyTGPawn.default.Run2CoverMaxDist * 0.5f;


		ReactCond = AIReactCond_StoppingPowerThreshold(ReactionManager.FindReactionByType(class'AIReactCond_StoppingPowerThreshold', false));

		// if our pawn supports stopping power, push on a stopping power threshold reaction so we evade when we get too much stopping power
		if(MyTGPawn.bAllowStoppingPower && ReactCond == none)
		{
			;
			ReactCond = new(self) class'AIReactCond_StoppingPowerThreshold'(StoppingPowerReactionTemplate);
			ReactCond.bAlwaysNotify = true;
			ReactCond.Initialize();
		}
		else if(ReactCond != none) // otherwise we just possessed a pawn that doesn't support it, and we still have a reaction so clean it up
		{
			ReactCond.UnsubscribeAll();
			ReactCond = none;
		}
	}
}


function PawnDied(Pawn InPawn)
{
	if( InPawn == Pawn )
	{
		// remove any cover claims
		UnClaimCover();
	}

	Super.PawnDied( InPawn );
}

function bool StepAsideFor(Pawn ChkPawn)
{
	if( HasValidCover() && IsAtCover() )
	{
		if( MyTGPawn.CurrentLink != none && MyTGPawn.CurrentLink.bDynamicCover )
		{
			;

			InvalidateCover();
			return Super.StepAsideFor( ChkPawn );
		}
		else
		{
			;
			return FALSE;
		}
	}

	return Super.StepAsideFor( ChkPawn );
}


/*
 *	Choose cover in available cover zones
 */
event bool MoveToCombatZone()
{
	SetAcquireCover( ACT_Immediate, 'MoveToCombatZone' );
	return Super.MoveToCombatZone();
}

event SetCurrentCombatZone( CombatZone NewCZ )
{
	local Actor		AmbushTarget;
	local CoverInfo	CovInfo;

	//debug
	;

	Super.SetCurrentCombatZone( NewCZ );

	if( CurrentCombatZone == None )
		return;

	//debug
	;

	if( CurrentCombatZone.ZoneType == CZT_Ambush )
	{
		if( CurrentCombatZone.AmbushTargets.Length < 0 || (MoveAction != none && !MoveAction.bInterruptable))
			return;

		AmbushTarget = CurrentCombatZone.AmbushTargets[Rand(CurrentCombatZone.AmbushTargets.Length)];
		if( EvaluateCover( SearchType_Ambush, AmbushTarget, CovInfo ) )
		{
			SetCombatMood( AICM_Ambush );
			SetCoverGoal( CovInfo, TRUE );
		}
	}
}

function FireFromCover()
{
	class'AICmd_Attack_FireFromCover'.static.FireFromCover( self );
}

function bool PeekFromCover( optional bool bLookForEnemy = TRUE, optional float PeekTime=0.f )
{
	if (WorldInfo.TimeSeconds > NextAllowPeekTime && MyTGPawn != None && !MyTGPawn.IsCarryingAHeavyWeapon())
	{
		return class'AICmd_Attack_PeekFromCover'.static.PeekFromCover( self, bLookForEnemy, PeekTime );
	}
	bFailedToFireFromCover = TRUE;
	return FALSE;
}

function bool HasAnyEnemiesRequiringCover()
{
	local Pawn P;
	if( Squad != None )
	{
		foreach Squad.AllEnemies( class'Pawn', P )
		{
			if( !P.IsA( 'TGPawn_LocustNemaslug' ) )
			{
				return TRUE;
			}
		}
	}

	return FALSE;
}

protected function FireAtForcedTarget()
{
	Focus = FireTarget;
	StartFiring();
	if (MyTGPawn != None && MyTGPawn.IsInCover())
	{
		FireFromCover();
	}
	else
	{
		FireFromOpen();
	}
}

protected function StopForceFiring()
{
	SelectTarget();
	StopFiring();
	AbortCommand(none,class'AICmd_Attack_FireFromCover');
}

protected native function bool IsLookingAtWall();

// try to face something that's not the wall
function IdleDontFaceWalls()
{
	local Actor SquadLeaderPos;
	local bool bFoundFaceTarget;
	local TGPC Player;

	if( Focus != None && NavigationPoint(Focus) == None )
	{
		;
		return;
	}

	// early out if we're not looking at a wall
	if((Pawn.Base != None && ClassIsChildOf( Pawn.Base.Class, class'InterpActor_GearBasePlatform' )) || !IsLookingAtWall())
	{
		;
		return;
	}

	// if we have a squad position, face it
	if(Squad != none)
	{
		// sometiems look at the player anyway, otherwise look at squad position
		if(FRand() < 0.5f && Squad.Leader != self || Squad.SquadRoute != none)
		{
			// face squad position
			SquadLeaderPos = GetSquadLeaderPosition();
			if(SquadLeaderPos != none)
			{
				;
				Focus=SquadLeaderPos;
				bFoundFaceTarget=true;
			}
		}
		// if we're in a player's squad, face the player
		else if(Squad.bPlayerSquad)
		{
			foreach Squad.AllMembers(class'TGPC',Player)
			{
				if(VSizeSq(Player.Pawn.Location - Pawn.Location) < 1024.f*1024.f)
				{
					;
					Focus = Player.Pawn;
					bFoundFaceTarget=true;
					break;
				}
			}
		}
	}


	// if we still didn't find anything, look for a player in the area
	if(!bFoundFaceTarget)
	{
		foreach LocalPlayerControllers(class'TGPC', Player)
		{
			;
			Focus=Player.Pawn;
			bFoundFaceTarget=true;
			break;
		}

	}
}

///////////////////////////////////////////////
//////////////// ACTION STATES ////////////////
///////////////////////////////////////////////

state Action_Idle
{
Begin:
	//MyTGPawn.hod.goto_state('cover');
	Sleep(1);
	goto ('Begin');
	// If we have enemies
	if( HasAnyEnemies() )
	{
		// Try to notice one which will put us into combat
		CheckNoticedEnemy();
		Sleep(1.f);
	}

	MyTGPawn.hod.DoScript('stop');
	sleep (0.25f);

	goto ('Begin');
	//debug
	;


	// Select our weapon
	if( SelectWeapon() )
	{
		;
		Sleep( 0.25f );
	}

	CheckReviveOrExecute(1200.0); // player might get downed by scripted stuff while out of combat, or combat just recently ended

	// check for a tether
	if( (Pawn != None) && !IsWithinTether( Pawn.Location ) )
	{
		//debug
		;

		if(MoveAction != none && MoveAction.TetherDistance == 0)
		{
			OnAIMove(MoveAction);
		}
		else
		{
			// Move to tether
			SetTether( TetherActor, DesiredTetherDistance, bDynamicTether, TetherPersistDuration );
		}
	}
	else
	// If we have enemies
	if( HasAnyEnemies() )
	{
		// Try to notice one which will put us into combat
		CheckNoticedEnemy();
		Sleep(1.f);
	}
	else
	if( IsSquadLeader() && Squad.SquadRoute != None )
	{
		// if this isn't the player squad, just run straight to the end of the route
		;
		if(!Squad.bPlayerSquad)
		{
			SetRouteMoveGoal( Squad.SquadRoute );
		}
		else if(ShouldMoveToSquad()) // otherwise we need to move up with the player, so call getsquadleaderposition
		{
			SetMoveGoal(Squad.GetSquadLeaderPosition());
			if(bReachedMoveGoal)
			{
				LastSquadLeaderPosition = MoveGoal.Location;
			}
		}
		else
		{
			sleep(2.f);
		}
	}
	else
	// otherwise if we have no enemies but do have a squad
	if ( ShouldMoveToSquad() )
	{
MoveToSquad:
		//debug
		;

		// then move to the squad
		MoveToSquadPosition();

		// If no tether actor to clear
		if( bFailedToMoveToEnemy )
		{
			// Sleep to prevent recursive craziness
			Sleep( 0.25f );
		}

		// If we shouldn't keep the tether
		if( !bKeepTether )
		{
			// Clear the tether so that we always update to a new one
			TetherActor = None;
		}
		bKeepTether = FALSE;

		// check to see if we should immediately move again
		if (!HasAnyEnemies() &&
			ShouldMoveToSquad())
		{
			//debug
			;
			Sleep(0.1f);
			Goto('MoveToSquad');
		}
		else
		{
			;
		}
		Sleep(0.25f);
	}
	else
	{
		// check to see if we should get into cover because of our squad leader
		if (TetherActor == none && IsAlert() &&
			(!HasValidCover() || !IsAtCover()))
		{
			//debug
			;

			ClearMovementInfo();
			MoveToNearestCoverIdle();
			if (!bReachedMoveGoal)
			{
				;
				Sleep(1.f);
			}
		}
		else
		if( IsAlert() &&
			IsAtCover() )
		{
			PeekFromCover();
			if( bFailedToFireFromCover )
			{
				Sleep( 0.5f );
			}
		}
		else if (bIdleMoveToNearestEnemy)
		{
			MoveToNearestEnemy();
			Sleep(1.0);
		}
		else
		{
			//debug
			;

			Sleep(1.f);
		}
	}
	IdleDontFaceWalls();
	Goto('Begin');
}

////////////////////////////////////////////////
////////////// SUBACTION STATES ////////////////
////////////////////////////////////////////////
/**
 * Checks to see if we can run to cover, if TestMoveTarget is a slot marker within range basically.
 */
final event bool CanRun2Cover()
{
	local CoverSlotMarker	Marker;

	Marker = CoverSlotMarker(MoveTarget);

	return FALSE;

	if(!IsAlert() && !IsInCombat())
	{
		return FALSE;
	}

	// If Pawn cannot do the run2cover, then don't go any further
	if (!MyTGPawn.bCanDoRun2Cover || Marker == None || MyTGPawn.IsAKidnapper() || MyTGPawn.IsCarryingShield() || MyTGPawn.IsCarryingAHeavyWeapon())
	{
		return FALSE;
	}

	// if it is our covergoal or current cover, and
	// if not already in cover, and
	// it is within range, and
	// is roughly in front of us, and
	// we're roughly facing it
	if ((Marker.OwningSlot == CoverGoal || Marker.OwningSlot == Cover) &&
		!MyTGPawn.IsInCover() &&
		VSize(Pawn.Location - Marker.Location) <= MyTGPawn.Run2CoverMaxDist &&
		Normal(Marker.Location - Pawn.Location) dot vector(Marker.GetSlotRotation()) > 0.3f &&
		vector(Pawn.Rotation) dot vector(Marker.GetSlotRotation()) > 0.3f)
	{
		return TRUE;
	}
	return FALSE;
}

function NotifyFlankedByEnemy( ESpecialMove SM )
{
	class'AICmd_React_Flanked'.static.Flanked( self, SM );
}

function HandleFlankReaction()
{
}

final function bool ShouldReactToMeatShield(TGPawn MSKidnapper)
{
	return (WorldInfo.TimeSeconds - LastMeatShieldReactionTime > MeatShield_Reaction_MinTimeInterval && FRand() < MeatShield_Reaction_Chance);
}

function NotifyEnemyUsingMeatShield(TGPawn MSKidnapper)
{
	;
	if( ShouldReactToMeatShield(MSKidnapper) )
	{
		MeatShield_Reaction_Target = MSKidnapper;
		SetTimer( MeatShield_Reaction_Delay, false, nameof(PlayMeatShieldReaction) );
	}
}

final function PlayMeatShieldReaction()
{
	// make sure we should still react
	if(WorldInfo.TimeSeconds - LastMeatShieldReactionTime < MeatShield_Reaction_MinTimeInterval ||
	   !MeatShield_Reaction_Target.IsAKidnapper() ||
	   !IsPawnVisibleViaTrace(MeatShield_Reaction_Target)
	   )
	{
		return;
	}

	// tell our squad we're reacting to this MS
	if(Squad != none)
	{
		Squad.NotifyReactingToMeatShield( MyTGPawn, MeatShield_Reaction_Target );
	}
	else
	{
		LastMeatShieldReactionTime = WorldInfo.TimeSeconds;
	}

	class'AICmd_ReactMeatshield'.static.React(self, MeatShield_Reaction_Target);
}

function NotifyKnockDownStart()
{
	class'AICmd_React_KnockDown'.static.InitCommand(self);
}

/////////////////////////////////////////////////
//////////////// COVER FUNCTIONS ////////////////
/////////////////////////////////////////////////

function ClearMovementInfo( optional bool bSkipCombatZones = TRUE)
{
	Super.ClearMovementInfo( bSkipCombatZones );

	ClearCoverGoal();
}

function ClearCoverGoal()
{
	CoverGoal.Link		= None;
	CoverGoal.SlotIdx	= -1;
}

/**
 * Sets a cover goal, pathing to it if necessary.
 */
function SetCoverGoal( CoverInfo NewCoverGoal, optional bool bIsValidCache )
{
	if (MyTGPawn != none && MyTGPawn.IsLongDying())
		return;

	//debug
	;

	class'AICmd_MoveToCover'.static.MoveToCover( self, NewCoverGoal, bIsValidCache, MoveIsInterruptable() );
}

/**
* Handle scripted AI movement, figures out what the right thing to do is
* based on the move targets.
*/
function OnAIMove(SeqAct_AIMove Action)
{
	// always clear cover link restrictions on a new set tether
	AllowedCoverLinks.length=0;

	Super.OnAIMove(Action);
}

function bool SetTether( Actor NewTetherActor, optional float NewTetherDistance, optional bool NewbDynamicTether, optional float NewTetherPersistDuration, optional bool bInteruptable, optional bool bIsValidCache, optional bool IgnoreSlot )
{
	local CombatZone	CZ;
	local CoverInfo		Info;
	local int			Count;
	local float			OldTetherDistance;
	local CoverLink		Link;
	local int			Idx;
	//local TGPawn_RockwormBase RW;
	local float			CurDist;
	local float			BestDist;

	if (MyTGPawn != none && MyTGPawn.IsLongDying())
		return false;

	;

	// Don't allow tether to controllers, instead move to a node in the combat zone
	CZ = CombatZone(NewTetherActor);
	if( CZ != None )
	{
		NewTetherActor = None;

		// If my anchor is already in the combat zone, stay tethered to it
		if( MyTGPawn.Anchor != None &&
			MyTGPawn.GetCombatZoneForNav( MyTGPawn.Anchor ) == CZ )
		{
			//debug
			;

			NewTetherActor = MyTGPawn.Anchor;
		}
		else
		{
			//debug
			;

			// Otherwise, search for cover closest to me and move to it
			OldTetherDistance = TetherDistance;
			TetherDistance = 4096.f;
			if( EvaluateCover( SearchType_Near, MyTGPawn, Info ) )
			{
				NewTetherActor = Info.Link.GetSlotMarker( Info.SlotIdx );

				//debug
				;
			}
			else
			{
				// Randomly select a navigation point inside the combat zone
				while( NewTetherActor == None && Count++ < 100 )
				{
					NewTetherActor = CZ.MyNavRefs[Rand(CZ.MyNavRefs.Length)].Actor;
				}

				//debug
				;
			}
			TetherDistance = OldTetherDistance;
		}

		if( NewTetherActor == None )
		{
			//debug
			;
		}
	}
	else if(MoveAction != none)
	{
		Link = CoverLink(NewTetherActor);

		if(Link == none)
		{
			//RW = TGPawn_RockwormBase(NewTetherActor);
			//// if we've just been told to run to a rockworm, do some funny business and swap out the link for one of the worm's links
			//if(RW != none)
			//{
			//	if(VSizeSq(RW.LeftCover.Location - MyTGPawn.Location) < VSizeSq(RW.RightCover.Location - MyTGPawn.Location))
			//	{
			//		Link = RW.LeftCover;
			//	}
			//	else
			//	{
			//		Link = RW.RightCover;
			//	}
			//}
		}
		if(Link != none)
		{
			// if we've been given a specific index to run to
			if(!IgnoreSlot && MoveAction.DestinationSlotIndex > -1)
			{
				Info.Link = Link;
				Info.SlotIdx = MoveAction.DestinationSlotIndex;
				//`AILog("Calling MoveToCover: "@Info.Link@Info.SlotIdx);
				return class'AICmd_MoveToCover'.static.MoveToCover(self,Info,,bInteruptable);
			}
			// if tether dist is 0, treat this like an order to go to that link, and use any of its coverslots
			else if(NewTetherDistance==0)
			{
				BestDist=-1;
				// find a valid slot to use
				for(Idx=0;Idx<Link.Slots.length;Idx++)
				{
					if(Link.IsValidClaim(Pawn,Idx))
					{
						//// find the closest spot to the rockworm's head so it'll last longest
						//if(RW != none)
						//{
						//	CurDist = VSizeSq(Link.GetSlotLocation(Idx) - RW.Location);
						//}
						//else
						//{
							CurDist = VSizeSq(Link.GetSlotLocation(Idx) - Pawn.Location);
						//}


						if(CurDist < BestDist || BestDist < 0)
						{
							Info.Link = Link;
							Info.SlotIdx = Idx;
							BestDist = CurDist;
						}
					}
				}
				if(Info.Link != none)
				{
					return class'AICmd_MoveToCover'.static.MoveToCover(self,Info,,bInteruptable,TRUE);
				}
				;
			}
		}
	}

	return Super.SetTether( NewTetherActor, NewTetherDistance, NewbDynamicTether, NewTetherPersistDuration, bInteruptable, bIsValidCache );
}

/**
 * Returns TRUE if there is an enemy closer than our current cover.
 */
final function bool HasEnemyCloserThanCover()
{
	local float EnemyDist;
	if (HasValidCover() && !IsAtCover())
	{
		EnemyDist = GetNearEnemyDistance(Pawn.Location);
		return (EnemyDist * EnemyDist < VSizeSq(Pawn.Location - Cover.Link.GetSlotLocation(Cover.SlotIdx)));
	}
	return FALSE;
}

/** will return TRUE if we are already in a cover slot from one of our restricted cover links */
function bool AtSlotFromRestrictedLink()
{
	local int i;
	if(IsAtCover()  && AllowedCoverLinks.length > 0)
	{
		for(i=0;i<AllowedCoverLinks.length;i++)
		{
			if(Cover.Link == AllowedCoverLinks[i])
			{
				return TRUE;
			}
		}
	}

	return FALSE;
}

function bool HasRestrictedCoverLinks()
{
	return (AllowedCoverLinks.length > 0);
}


/**
 * Returns TRUE if the specified cover is valid.
 */
final native function bool IsValidCover(const out CoverInfo TestCover);

/**
 * Invalidates our current cover.
 */
function InvalidateCover( optional bool bUnclaimOnly, optional bool bFast )
{
	//debug
	;

	UnClaimCover();
	if( !bUnclaimOnly )
	{
		bLeaveCoverFast=bFast;
		ResetCoverType();
		ClearCoverGoal();
	}
	else
	{
		// Otherwise, just reset our cover action
		ResetCoverAction( TRUE );
	}

}

/**
 * Returns TRUE if we have a valid cover claim.
 */
final native function bool HasValidCover();

/**
 * Returns TRUE if we are currently at our claimed cover.
 */
event bool IsAtCover()
{
	return bReachedCover;
}

/**
 * Claims the specified cover, unclaiming previous if it was valid.
 */
final function bool ClaimCover( CoverInfo NewCover )
{
	local bool bResult;

	if( IsValidCover( NewCover ) )
	{
		bReachedCover = FALSE;
		// If we have cover to unclaim and we're not repeating a claim
		if( Cover.Link != None &&
			(Cover.Link != NewCover.Link || Cover.SlotIdx != NewCover.SlotIdx))
		{
			// Clear the last cover
			UnClaimCover();
		}

		if( MyTGPawn != None )
		{
			// Claim
			bResult = MyTGPawn.ClaimCover( NewCover.Link, NewCover.SlotIdx );
		}

		// If claimed and this is our goal - keep link
		if( bResult )
		{
			//debug
			;

			Cover = NewCover;
		}
		else
		{
			//debug
			;
		}
	}
	else
	{
		//debug
		;
	}

	return bResult;
}

/**
 * Revokes current cover claim.
 */
final function UnClaimCover()
{
	if( Cover.Link != None )
	{
		//debug
		;

		// save the last cover
		LastCover = Cover;
		// release the claim
		if( MyTGPawn != None )
		{
			MyTGPawn.UnClaimCover( Cover.Link, Cover.SlotIdx, TRUE );
		}
	}
	// clear the cover
	Cover.Link = None;
	Cover.SlotIdx = -1;
	bReachedCover = FALSE;
}

final function CoverSlotMarker GetCoverSlotMarker()
{
	if( Cover.Link != None )
	{
		return Cover.Link.GetSlotMarker( Cover.SlotIdx );
	}
	return None;
}

protected function bool EvaluateCoverInternal
(
 ECoverSearchType Type,
 CombatZone TestWithinCombatZone,
 Actor GoalActor,
 out CoverInfo out_Cover,
 optional CoverSlotMarker InBestMarker,
 optional Goal_AtCover GoalEvaluator,
 optional float MaxDistFromGoal
 )
{
	local CoverSlotMarker Marker;
	local bool bResult;


	//local float Time;
	//Clock(Time);

	// we can't use cover when we're holding a shield
	if (MyTGPawn != None && (MyTGPawn.IsAKidnapper() || MyTGPawn.IsCarryingShield() || MyTGPawn.CarriedCrate != None))
	{
		return false;
	}

	//debug
	;

	// don't do this if we're searching along a path because we don't necessarily want a node in our combat zone
	if(TestWithinCombatZone != none && Type != SearchType_AlongPath)
	{
		// if we're trying to reacha  specific combat zone, once we're in it don't leave!
		class'Path_WithinCombatZone'.static.WithinCombatZone( Pawn, 10000000, TestWithinCombatZone);
		class'Path_TowardPoint'.static.TowardPoint(Pawn, TestWithinCombatZone.ZoneCenter);
	}
	else
	{
		// otherwise just add a penalty for leaving a combat zone
		class'Path_WithinCombatZone'.static.WithinCombatZone( Pawn,256 );
	}

	AddBasePathConstraints();

	// if we've been given a max dist from our goal, enforce it
	if(MaxDistFromGoal > 0)
	{
		;
		class'Path_WithinDistanceEnvelope'.static.StayWithinEnvelopeToLoc(Pawn,GoalActor.Location,MaxDistFromGoal,0.f,FALSE,,TRUE);
	}



	if( Type == SearchType_AlongPath )
	{
		//debug
		;

		class'Path_AlongLine'.static.AlongLine( Pawn, Normal( GoalActor.Location - Pawn.Location ) );
		class'Path_WithinTraversalDist'.static.DontExceedMaxDist(Pawn, Max(VSize(GoalActor.location-Pawn.Location)*0.5f,256),FALSE);
		if( GoalEvaluator == None )
		{
			GoalEvaluator = AtCover_AlongPath;
			if (CovGoal_ProtectedByLocation(GoalEvaluator.CoverGoalConstraints[0]) != None)
			{
				CovGoal_ProtectedByLocation(GoalEvaluator.CoverGoalConstraints[0]).ThreatLocation = GoalActor.Location;
			}
		}
	}
	else
	if( Type == SearchType_Towards )
	{
		//debug
		;
		class'Path_AlongLine'.static.AlongLine( Pawn, Normal( GoalActor.Location - Pawn.Location ) );

		if(GoalEvaluator == none)
		{
			GoalEvaluator = AtCover_Toward;
		}
	}
	else
	if( Type == SearchType_Away )
	{
		//debug
		;
		class'Path_AlongLine'.static.AlongLine( Pawn, -Normal( GoalActor.Location - Pawn.Location ) );
		if(GoalEvaluator == none)
		{
			GoalEvaluator = AtCover_Away;
		}
	}
	else
	if( Type == SearchType_Near )
	{
		//debug
		;
		// don't try and move toward a goal actor if we have a combatzone to test.. we should be moving toward
		// the closest combat zone already
		if(TestWithinCombatZone == none)
		{
			class'Path_TowardGoal'.static.TowardGoal( Pawn, GoalActor );
		}
		if(GoalEvaluator == none)
		{
			GoalEvaluator = AtCover_Near;
		}

	}
	else
	if( Type == SearchType_Ambush )
	{
		//debug
		;
		if( GoalEvaluator == None )
		{
			GoalEvaluator = AtCover_Ambush;
			if (CovGoal_ProtectedByLocation(GoalEvaluator.CoverGoalConstraints[0]) != None)
			{
				CovGoal_ProtectedByLocation(GoalEvaluator.CoverGoalConstraints[0]).ThreatLocation = GoalActor.Location;
			}
		}
	}

	// if we have been restricted to a set of coverlinks then push the allowed coverlinks constraint
	if(AllowedCoverLinks.length > 0 && Type != SearchType_AlongPath)
	{
		;
		GoalEvaluator.CoverGoalConstraints[GoalEvaluator.CoverGoalConstraints.length] = new(self) class'CovGoal_WithinAllowedCoverLinks';
	}

	GoalEvaluator.Init(self,GoalActor);

	// rate the best so we can save off the 'best' scores for comparison against new ones
	if(InBestMarker != none)
	{
		//@note: initial weight here assumes marker is anchor or at least directly reachable
		GoalEvaluator.RateSlotMarker( InBestMarker, Pawn, 0);/*VSize(InBestMarker.Location - Pawn.Location) +
			InBestMarker.FearCost + InBestMarker.TransientCost + InBestMarker.ExtraCost );*/
	}

	//UnClock(Time);
	//ForceLog(GetFuncName()@" BEFORE findpath toward took "$Time);
	if( FindPathToward( GoalActor ) != None )
	{
		Marker = CoverSlotMarker(RouteCache[RouteCache.Length-1]);
		out_Cover = Marker.OwningSlot;
		bResult = TRUE;
	}

	// if we added a coverlink limit, remove it now so it doesn't stick around after the fact
	if(AllowedCoverLinks.length > 0 && Type != SearchType_AlongPath)
	{
		GoalEvaluator.CoverGoalConstraints.Remove(GoalEvaluator.CoverGoalConstraints.length-1,1);
	}

	// then we need to clear constraints because it's possible FindPathToward didn't (this does need to be here, please don't remove it! ;) )
	Pawn.ClearConstraints();


	return bResult;
}

function bool EvaluateCover
(
	ECoverSearchType Type,
	Actor GoalActor,
	out CoverInfo out_Cover,
	optional CoverSlotMarker InBestMarker,
	optional Goal_AtCover GoalEvaluator,
	optional float MaxDistFromGoal
)
{
	local int i;
	local CombatZone TestingZone;
	local CombatZone ClosestZoneToGoal;
	local float CurDistSq;
	local float BestDistSq;
	;
	if(Type == SearchType_Near)
	{
		// find out if our goal is inside a combat zone
		if(GoalActor != none && CombatZonelist.length > 0)
		{
			BestDistSq=-1.f;
			for(i=0;i<CombatZonelist.length;i++)
			{
				if(CombatZoneList[i].Encompasses(GoalActor))
				{
					TestingZone = CombatZoneList[i];
					break;
				}
				else
				{
					// if we haven't found a zone that encompasses the goal, then keep track of the closest one so
					// we to got he combat zone closest to our goal
					CurDistSq = VSizeSq(CombatZonelist[i].ZoneCenter - GoalActor.Location);
					if(CurDistSq < BestDistSq || BestDistSq < 0)
					{
						ClosestZoneToGoal = CombatZonelist[i];
						BestDistSq=CurDistSq;
					}
				}
			}

			// if we didnt' find a zone that encompasses the goal, use the closest one
			TestingZone = ClosestZoneToGoal;
		}
		return EvaluateCoverInternal(Type,TestingZone,GoalActor,out_Cover,InBestMarker,GoalEvaluator,MaxDistFromGoal);
	}
	else if(Type == SearchType_AlongPath)
	{
		// if we're testing along a path then don't do combat zone magic, cuz we want one near our path!
		return EvaluateCoverInternal(Type,none,GoalActor,out_Cover,InBestMarker,GoalEvaluator);
	}
	else
	{
		// otherwise we need to try pathing to each combat zone one at a time, so loop through them all
		if(CombatZoneList.length > 0)
		{
			for(i=0;i<CombatZoneList.length;i++)
			{
				// if we found one in this node, bail!
				if(EvaluateCoverInternal(Type,CombatZoneList[i],GoalActor,out_Cover,InBestMarker,GoalEvaluator,MaxDistFromGoal))
				{
					return true;
				}
			}
		}
		else
		{
			return EvaluateCoverInternal(Type,none,GoalActor,out_Cover,InBestMarker,GoalEvaluator,MaxDistFromGoal);
		}

	}

	return false;
}

function bool IgnoreTimeTransitions()
{
	if( MyTGPawn != None &&
		MyTGPawn.Weapon != None &&
		MyTGPawn.Weapon.IsA( 'TGWeap_GrenadeBase' ) &&
		IsLeaning() )
	{
		return TRUE;
	}

	return Super.IgnoreTimeTransitions();
}

/**
 *	Figure out if AI should blind fire
 */
event bool ShouldBlindFire()
{
	local float	  Chance;
	local int	  Idx, Num, Tickets;

	// If pawn can't blind fire - fail
	if( MyTGPawn == None || !MyTGPawn.bCanBlindFire )
	{
		return FALSE;
	}

	// if our difficulty level doesn't allow it, don't blindfire
	if ( (!WorldInfo.GRI.IsMultiplayerGame() || WorldInfo.GRI.IsCoopMultiplayerGame()) &&
		MyTGPawn.GetTeamNum() == TEAM_LOCUST &&
		!class'DifficultySettings'.static.GetLowestPlayerDifficultyLevel(WorldInfo).default.bAllowLocustBlindFire )
	{
		return FALSE;
	}


	// No blind firing grenades
	if( MyTGPawn.Weapon.IsA( 'TGWeap_GrenadeBase' ) )
	{
		return FALSE;
	}

	// Figure out how many fire tickets are taken
	Num = MyTGPawn.FireTickets.Length;
	for( Idx = 0; Idx < Num; Idx++ )
	{
		if( MyTGPawn.FireTickets[Idx] != None )
		{
			Tickets++;
		}
	}

	// Chance to blind fire is base value + tickets
	Chance = MyTGPawn.BlindFirePct + (Tickets * MyTGPawn.BlindFirePct);
	if( FRand() > Chance )
	{
		return FALSE;
	}

	return TRUE;
}

/**
 * Updates our pawn's covertype to match current cover.
 */
final function bool SetCoverType()
{
	if( MyTGPawn != None &&
		Cover.Link != None &&
		Cover.SlotIdx >= 0 &&
		Cover.SlotIdx < Cover.Link.Slots.Length )
	{
		//debug
		;

		if( Cover.Link.Slots.Length <= 1 )
		{
			MyTGPawn.SetCoverInfo( Cover.Link, Cover.SlotIdx, Cover.SlotIdx, Cover.SlotIdx, 0.f, TRUE );
		}
		else if( Cover.SlotIdx == Cover.Link.Slots.Length - 1 )
		{
			MyTGPawn.SetCoverInfo( Cover.Link, Cover.SlotIdx, Cover.SlotIdx - 1, Cover.SlotIdx, 1.f, TRUE );
		}
		else
		{
			MyTGPawn.SetCoverInfo( Cover.Link, Cover.SlotIdx, Cover.SlotIdx, Cover.SlotIdx + 1, 0.f, TRUE );
		}
		return TRUE;
	}
	else
	{
		//debug
		;
	}

	return FALSE;
}

/**
 * Resets our cover type.
 */
final function ResetCoverType()
{
//	local Rotator Rot;
//	local Vector  Loc;

	;
	if( MyTGPawn != None )
	{
		if(MyTGPawn.CurrentLink != None )
		{
		//	Rot = MyTGPawn.CurrentLink.GetSlotRotation(MyTGPawn.CurrentSlotIdx);
//			GetPlayerViewPoint( Loc, Rot );
//			Loc = TransformVector(MyTGPawn.Mesh.LocalToWorld, MyTGPawn.Mesh.GetBoneLocation('Hips', 1));
//			Loc.Z = MyTGPawn.Location.Z;

			//if( IsLeaning() )
			//{
			//	GetPlayerViewPoint( Loc, Rot );
			//}
			//else
			//{
			//	Rot = MyTGPawn.CurrentLink.GetSlotRotation(MyTGPawn.CurrentSlotIdx);
			//}

			//MyTGPawn.SetRotation( Rot );
			//MyTGPawn.SetLocation(Loc);

			//Focus = None;
			//SetFocalPoint( MyTGPawn.Location + Vector(MyTGPawn.Rotation) * 512.f, TRUE );

		}

		MyTGPawn.LeaveCover();
	}

}

final function bool SetCoverAction( ECoverAction Action )
{
	local bool bShouldTarget;

	//debug
	;

	if( MyTGPawn != None )
	{
		bShouldTarget = (Action == CA_PopUp || MyTGPawn.Weapon.IsA('TGWeap_GrenadeBase') || MyTGPawn.IsCarryingAHeavyWeapon());
		MyTGPawn.SetTargetingMode( bShouldTarget );
		MyTGPawn.SetCoverAction( Action );
		MyTGPawn.SetWeaponAlert( 5.f );
		return TRUE;
	}

	return FALSE;
}

final function ResetCoverAction( optional bool bResetCrouch )
{
	if( MyTGPawn != None && MyTGPawn.CoverAction != CA_Default )
	{
		MyTGPawn.SetTargetingMode( FALSE );
		MyTGPawn.SetCoverAction(CA_Default);
		if( bResetCrouch )
		{
			MyTGPawn.ShouldCrouch( FALSE );
		}
	}

	StopFiring();
	PendingFireLinkItem.SrcAction = CA_Default;
	PendingFireLinkItem.SrcType	  = CT_None;
}

final function bool IsLeaning()
{
	return MyTGPawn != None && MyTGPawn.IsLeaning();
}

final function bool IsPeeking()
{
	return MyTGPawn != None && MyTGPawn.IsPeeking(MyTGPawn.CoverAction);
}

event bool ShouldDo360Aiming( Vector TargLoc )
{
	local Rotator	DeltaRot;
	local vector2d  NewAimOffsetPct;

	// heavy weapons can't do 360 aiming
	if (MyTGPawn != None && MyTGPawn.IsCarryingAHeavyWeapon())
	{
		return false;
	}

	// find out delta angle between pawn's rotation and crosshair direction
	DeltaRot			= Normalize(Rotator(TargLoc - Pawn.Location) - Pawn.Rotation);
	NewAimOffsetPct.X	= NormalizeRotAxis(DeltaRot.Yaw)	/ 16384.f;
	NewAimOffsetPct.Y	= NormalizeRotAxis(DeltaRot.Pitch)	/ 16384.f;

	// Target is not in front of cover
	//@fixme - this doesn't work in all cases, only if the player is off the edge of the current
	// slot, or entirely behind us.  need to improve this a bit more, as right now the AI will
	// think they can't fire from cover when they could more than likely pop up and still shoot
	if( Abs(NewAimOffsetPct.X) > 0.6f )
	{
		return TRUE;
	}

	return FALSE;
}

final native function bool GetCoverAction( out CoverInfo ChkCover, optional Actor ChkTarget, optional bool bAnyAction, optional bool bTest, optional Name DebugTag );

final function bool GetPeekCoverAction( optional ECoverAction Pending )
{
	local array<ECoverAction> Actions;
	local ECoverAction Action;

	// Don't peek during 360 aiming
	if( MyTGPawn == None || MyTGPawn.bDoing360Aiming )
	{
		return FALSE;
	}

	if( CombatMood == AICM_Ambush )
	{
		return FALSE;
	}

	if( Pending != CA_Default )
	{
		switch( Pending )
		{
			case CA_LeanLeft:	PendingFireLinkItem.SrcAction = CA_PeekLeft;	break;
			case CA_LeanRight:	PendingFireLinkItem.SrcAction = CA_PeekRight;	break;
			case CA_PopUp:		PendingFireLinkItem.SrcAction = CA_PeekUp;		break;
		}
		PendingFireLinkItem.SrcType = CT_None;

		return TRUE;
	}

	MyTGPawn.CurrentLink.GetSlotActions( MyTGPawn.CurrentSlotIdx, Actions );

	// If we have available actions
	if( Actions.Length > 0 )
	{
		// Randomly choose an action
		Action = Actions[Rand(Actions.Length)];

		//debug
		;

		PendingFireLinkItem.SrcAction = Action;
		PendingFireLinkItem.SrcType	  = CT_None;
		return TRUE;
	}

	//debug
	;

	return FALSE;
}

final function bool ShouldWaitForTransition( ECoverAction Action )
{
	local bool	  bSwitch;
	local bool	  bWantsToBeMirrored;

	if( MyTGPawn != None )
	{
		// If not mirrored and should be - switch
		if( Action == CA_LeanLeft	||
			Action == CA_BlindLeft	||
			Action == CA_PeekLeft	)
		{
			bSwitch = TRUE;
			bWantsToBeMirrored = TRUE;
		}
		else
		// Otherwise, if mirrored and should not be - switch
		if( Action == CA_LeanRight	||
			Action == CA_BlindRight ||
			Action == CA_PeekRight  )
		{
			bSwitch = TRUE;
			bWantsToBeMirrored = FALSE;
		}

		// If should switch
		if( bSwitch )
		{
			// Switch mirrored side and return TRUE to wait for transition
			MyTGPawn.SetMirroredSide( bWantsToBeMirrored );
			return TRUE;
		}
	}

	return FALSE;
}

/** Move pawn towards current slot */
native final noexport latent function AdjustToSlot( CoverSlotMarker TargetMarker );

/**
* Called when cover is reached, save the information for later use.
*/
function NotifyReachedCover()
{
	bReachedCover = TRUE;
	bFailedToFireFromCover = false;
}

/**
 * Called when AI reaches a slot while transitioning between them
 */
final function NotifyReachedCoverSlot( int SlotIdx )
{
	if( MyTGPawn == None || MyTGPawn.TargetSlotMarker == None )
	{
		return;
	}

	//debug
	;

	if( SlotIdx != MyTGPawn.TargetSlotMarker.OwningSlot.SlotIdx &&
		Cover.Link == MyTGPawn.CurrentLink )
	{
		if( !Cover.Link.bClaimAllSlots )
		{
			// Otherwise, if we aren't supposed to have all slots claimed
			// Release the old one before recognizing the new one
			Cover.Link.UnClaim( MyTGPawn, SlotIdx, FALSE );
		}
	}
}

simulated function bool NotifyCoverClaimViolation( Controller NewClaim, CoverLink Link, int SlotIdx )
{
	//debug
	;

	if( NewClaim == self )
	{
		return TRUE;
	}

	// If claim violation is our cover destination
	if( Cover.Link == Link &&
		(Cover.Link.bClaimAllSlots ||
			Cover.SlotIdx == SlotIdx) )
	{
		// Force release of cover, even if we don't claim new
		InvalidateCover();

		ClearMovementInfo();

		// Try to find cover nearby until we can reevaluate
		if( HasAnyEnemies() )
		{
			MoveToNearestCoverEnemy();
		}
		else
		{
			MoveToNearestCoverIdle();
		}
	}
	else
	// Otherwise, moving through this slot... give chance to recompute path
	if( AICommand(CommandList) != None )
	{
		return AICommand(CommandList).NotifyCoverClaimViolation( NewClaim, Link, SlotIdx );
	}

	return FALSE;
}

simulated event NotifyCoverAdjusted()
{
	if( MyTGPawn != None)
	{
		MyTGPawn.SetCurrentCoverType();
	}
}

simulated function NotifyCoverDisabled( CoverLink Link, int SlotIdx, optional bool bAdjacentIdx )
{
	;
	if( !bAdjacentIdx )
	{
		InvalidateCover();

		if(MoveAction != none && MoveAction.TetherDistance == 0)
		{
			;
			OnAIMove(MoveAction);
		}
		else
		{
			 ;
			 TetherActor=none;
		}
	}
}

final function MoveToNearestCoverIdle()
{
	local CoverSlotMarker Marker;
	local CoverInfo CovToLeader;

	bReachedMoveGoal = FALSE;
	bReachedCover = FALSE;

	// use the cover we're standing on if possible
	Marker = CoverSlotMarker(Pawn.Anchor);
	if (Marker != None &&
		Marker.OwningSlot.Link.IsValidClaim(MyTGPawn,Marker.OwningSlot.SlotIdx) &&
		IsCoverWithinCombatZone(Marker.OwningSlot) )
	{
		;
		SetCoverGoal(Marker.OwningSlot);
		return;
	}

	//debug
	;

	bReachedMoveGoal = FALSE;
	if( Squad != None )
	{
		TetherDistance = 512.f;
		if( EvaluateCover( SearchType_Near, GetSquadPosition(), CovToLeader,, AtCover_Squad, TetherDistance ) )
		{
			SetCoverGoal( CovToLeader );
			return;
		}
	}

	//debug
	;

	if( EvaluateCover( SearchType_Near, Pawn, CovToLeader,, AtCover_Squad ) )
	{
		SetCoverGoal( CovToLeader );
		return;
	}

	//debug
	;
}

final function MoveToNearestCoverEnemy()
{
	local CoverInfo			CovToEnemy;
	local bool				bTowardsGoal;
	local float				NearEnemyDist;
	local CoverSlotMarker	Marker;

	// we can't use cover if we have a shield
	if (MyTGPawn != None && (MyTGPawn.IsAKidnapper() || MyTGPawn.IsCarryingShield()))
	{
		;
		return;
	}

	//debug
	;

	if( !HasValidCover() && (!HasValidEnemy() || LineOfSightTo(Enemy)) )
	{
		//debug
		;

		// use the cover we're standing on if possible
		Marker = CoverSlotMarker(Pawn.Anchor);
		if (Marker != None &&
			Marker.OwningSlot.Link.IsValidClaim(MyTGPawn,Marker.OwningSlot.SlotIdx) &&
			!IsCoverExposedToAnEnemy(Marker.OwningSlot) &&
			 IsCoverWithinCombatZone(Marker.OwningSlot))
		{
			//debug
			;

			SetCoverGoal(Marker.OwningSlot);
			return;
		}
	}
	NearEnemyDist = GetNearEnemyDistance(Pawn.Location);
	// search for cover either towards/away based on closest enemy distance
	bTowardsGoal = SearchForCoverTowardsEnemy( NearEnemyDist );
	;
	if (EvaluateCover(bTowardsGoal ? SearchType_Towards : SearchType_Away,Enemy,CovToEnemy))
	{
		;
		SetCoverGoal( CovToEnemy, TRUE );
		return;
	}
	else
	// try the opposite if the enemy is close enough
	if (!HasValidCover() &&
		NearEnemyDist < EnemyDistance_Long &&
		EvaluateCover(bTowardsGoal ? SearchType_Away : SearchType_Towards,Enemy,CovToEnemy))
	{
		;
		SetCoverGoal( CovToEnemy, TRUE );
		return;
	}
	else
	{
		if (HasValidCover() && !IsCoverExposedToAnEnemy(Cover))
		{
			SetAcquireCover( ACT_None );
			if (!IsAtCover())
			{
				;
				SetCoverGoal(Cover);
				return;
			}
			else
			{
				;
			}
		}
		else
		{
			;
		}
	}
	return;
}

final function bool SearchForCoverTowardsEnemy( float NearEnemyDist )
{
	return (CombatMood == AICM_Aggressive || (CombatMood != AICM_Passive && NearEnemyDist > EnemyDistance_Short));
}

final function bool ShouldFireFromCover()
{
	if( CombatMood == AICM_Passive ||
		CombatMood == AICM_Ambush )
	{
		if( HasEnemyWithinDistance(EnemyDistance_Short) || IsCoverExposedToAnEnemy(Cover) )
		{
			//TGGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_DamagedEnemyHeavy,Pawn);
			;
			return TRUE;
		}
		return FALSE;
	}
	else
	{
		return TRUE;
	}
}

event bool SetCombatMood(ECombatMood NewMood,optional Pawn MoodInstigator)
{
	//debug
	;

	CombatMood = NewMood;
	SetupEnemyDistances();
	// if now passive
	if( CombatMood == AICM_Passive )
	{
		if( ShouldFireFromCover() )
		{
			return FALSE;
		}
		else
		{
			// then go ahead and stop immediately
			StopFiring();

			AbortCommand( None, class'AICmd_Attack_FireFromOpen'  );
			AbortCommand( None, class'AICmd_Attack_FireFromCover' );

			return TRUE;
		}
	}
	else
	if (CombatMood == AICM_Aggressive)
	{
		if (GetHealthPercentage() > 0.5f)
		{
			// reset any cover properties so that the AI re-evaluates soon
			if (HasAnyEnemies())
			{
				SetAcquireCover( ACT_DesireBetter );
			}
			return TRUE;
		}
		// not attacking, crazy mofo!
		return FALSE;
	}
	else
	if (CombatMood == AICM_Normal)
	{
		// try to make the AI move now
		if (MoveAction == None &&
			(!HasAnyEnemies() || CombatZoneList.Length == 0) &&
			!MyTGPawn.IsDBNO() &&
			!IsDead() &&
			!IsInState('WaitingForEvent'))
		{
			if (GetSquadLeader() != self && ShouldMoveToSquad())
			{
				MoveToSquadPosition();
			}
			return TRUE;
		}
		else
		{
			// can't move right now
			return FALSE;
		}
	}
	else if(CombatMood == AICM_Ambush)
	{
		AbortCombatCommands();
	}
	// unknown order?
	return FALSE;
}

/** called by AIReactCond_DmgLeaveCover when we've taken enough damage that we should leave cover */
function InvalidateCoverFromDamage(Actor Damager)
{
	Cover.Link.SetInvalidUntil(Cover.SlotIdx, WorldInfo.TimeSeconds + 2.0f);
	if(CanEvade(true,0.125f))
	{
		DoEvade( GetBestEvadeDir( MyTGPawn.Location, Pawn(Damager) ), TRUE );
	}
}

/////////////////////////////////////////////////
//////////////// TURRET FUNCTIONS ///////////////
/////////////////////////////////////////////////

///**
// * Handler for scripted use of turrets.  Push into turret state.
// */
final function OnAIUseTurret( SeqAct_AIUseTurret Action )
{
	//local AIReactCond_CanReturnToTroika ReturnReact;
	;

	if( !UseTurret( Action.Turret, Action.bIgnoreFlank, Action.bTeleportToTurret ) )
	{
		bIgnoreFlank	= default.bIgnoreFlank;
		DefaultCommand	= default.DefaultCommand;
//		ReturnReact = AIReactCond_CanReturnToTroika(ReactionManager.FindReactionByType(class'AIReactCond_CanReturnToTroika',true));
//		if(ReturnReact != none)
//		{
//			ReturnReact.UnsubscribeAll();
//		}
//		ReturnReact=none;
	}
}

//final function OnPossessTurret( SetAct_PossessTurret inAction )
//{
//	local AIReactCond_CanReturnToTroika ReturnReact;
//	`AILog(GetFuncName()@inAction@inAction.Turret);
//
//	if( !UseTurret( inAction.Turret, TRUE, TRUE ) )
//	{
//		bIgnoreFlank	= default.bIgnoreFlank;
//		DefaultCommand	= default.DefaultCommand;
//		ReturnReact = AIReactCond_CanReturnToTroika(ReactionManager.FindReactionByType(class'AIReactCond_CanReturnToTroika',true));
//		if(ReturnReact != none)
//		{
//			ReturnReact.UnsubscribeAll();
//		}
//		ReturnReact=none;
//	}
//}
//
final event bool UseTurret( Turret inTurret, bool inbIgnoreFlank, optional bool inbTeleportToTurret )
{
	local TGPawn OldPawn;

	OldPawn = MyTGPawn;
	if( inTurret != none &&
		inTurret.ClaimTurret( self ) )
	{
		bIgnoreFlank	 = inbIgnoreFlank;
		LastTurret		 = CurrentTurret;

		if( inbTeleportToTurret &&
			Pawn.SetLocation( CurrentTurret.GetEntryLocation() ) &&
			Pawn.SetRotation( CurrentTurret.Rotation ) &&
			CurrentTurret.TryToDrive(Pawn) )
		{
			OldPawn.bCanDBNO = FALSE;
			OldPawn.SetBase( CurrentTurret.Base );
			bReachedTurret = TRUE;
			//CurrentTurret.Driver.SetRotation(CurrentTurret.Rotation);
		}
		else
		{
			bReachedTurret = FALSE;
		}

		BeginCombatCommand( class'AICmd_Base_TroikaGunner', "Put on turret", inbTeleportToTurret );
		return TRUE;
	}
	return FALSE;
}

//final function StopUsingTurret(GearTurret Turr)
//{
//	local AIReactCond_CanReturnToTroika ReactCond;
//
//	`AILog(GetFuncName()@Turr);
//	// abort turret ai
//	AbortCommand(none,class'AICmd_Base_TroikaGunner');
//
//	// if we're being told to stop using a turret entirely, kill the re-engage reaction
//	ReactCond = AIReactCond_CanReturnToTroika(ReactionManager.FindReactionByType(class'AIReactCond_CanReturnToTroika', false));
//	if(ReactCond != none)
//	{
//		ReactCond.UnsubscribeAll();
//	}
//}
//
final function bool CanTurretFireAt( Actor TestActor, optional Turret TestTurret )
{
	local TGPawn TargetWP;

	if(TestTurret == none)
	{
		TestTurret = CurrentTurret;
	}

	if( TestActor != None )
	{
		// check to see if it's a target protected by cover
		TargetWP = TGPawn(TestActor);
		if (TargetWP != None &&
			TargetWP.IsProtectedByCover(Normal(TargetWP.Location - TestTurret.GetPhysicalFireStartLoc(vect(0,0,0))),TRUE))
		{
			return FALSE;
		}

		// check to see if the target is outside our rotation clamps
		if(!TGTurret(TestTurret).IsWithinRotationClamps(TestActor.Location))
		{
			return FALSE;
		}

		// check to see if we have los
		return	(CanFireAt( TestActor, TestTurret.GetPhysicalFireStartLoc( vect(0,25,0)  ) ) ||
				 CanFireAt( TestActor, TestTurret.GetPhysicalFireStartLoc( vect(0,-25,0) ) ));
	}

	return FALSE;
}

//final function TargetInsideFireArc()
//{
//	//debug
//	`AILog( GetFuncName() );
//
//	BeginCombatCommand( class'AICmd_Melee_Forced', "Target got inside turret arc" );
//}
//
//final function NotifyTurretRotationClamped()
//{
//	//debug
//	`AILog( GetFuncName()@CommandList );
//	ReactionManager.NudgeChannel(none,'TurretRotationClamped');
//
//}
//
//
///////////////////////////////////////////////////
////////////////// DEBUG FUNCTIONS ////////////////
///////////////////////////////////////////////////
//
//simulated function DrawDebug(GearHUD_Base HUD, Name Category)
//{
//	local int i;
//	local int j;
//
//	Super.DrawDebug( HUD, Category );
//
//	if( bDrawAIDebug )
//	{
//		if(Category == 'Default')
//		{
//			if( HasValidCover() )
//			{
//				// PINK
//				DrawDebugLine( Pawn.Location, Cover.Link.GetSlotLocation(Cover.SlotIdx) + vect(0,0,15), 255, 128, 255 );
//			}
//
//			if( MyTGPawn != None )
//			{
//				if( MyTGPawn.IsInCover() )
//				{
//					// TEAL
//					DrawDebugLine( MyTGPawn.Location, MyTGPawn.CurrentLink.GetSlotLocation(MyTGPawn.CurrentSlotIdx) - vect(0,0,15), 0, 255, 255 );
//				}
//			}
//			if( CurrentTurret != None )
//			{
//				DrawDebugLine(CurrentTurret.GetPhysicalFireStartLoc( vect(0,0,0) ) + vector(CurrentTurret.GetTurretAimDir()) * 16384, CurrentTurret.GetPhysicalFireStartLoc( vect(0,0,0) ), 255, 128, 0);
//			}
//		}
//
//		if(Category == 'allowedcoverlinks')
//		{
//			for(i=0;i<AllowedCoverLinks.length;i++)
//			{
//				DrawDebugLine(MyTGPawn.Location,AllowedCoverLinks[i].Location,255,255,0);
//				for(j=0;j<AllowedCoverLinks[i].Slots.length;j++)
//				{
//					DrawDebugLine(AllowedCoverLinks[i].Location,AllowedCoverLinks[i].GetSlotLocation(j),255,255,0);
//					DrawDebugCoordinateSystem(AllowedCoverLinks[i].GetSlotLocation(j),AllowedCoverLinks[i].GetSlotRotation(j),50.f);
//				}
//			}
//		}
//
//		if(Category == 'cover' && MyTGPawn.CurrentLink != none && MyTGPawn.CurrentSlotIdx != -1)
//		{
//			DrawDebugLine(MyTGPawn.Location,MyTGPawn.CurrentLink.GetSlotLocation(MyTGPawn.CurrentSlotIdx),255,255,0);
//			DrawDebugCoordinateSystem(MyTGPawn.CurrentLink.GetSlotLocation(MyTGPawn.CurrentSlotIdx),MyTGPawn.CurrentLink.GetSlotRotation(MyTGPawn.CurrentSlotIdx),10.f);
//			//MessagePlayer("Left:"@MyTGPawn.LeftSlotIdx@"Cur:"@MyTGPawn.CurrentSlotIdx@"Right:"@MyTGPawn.RightSlotIdx@"Pct:"@MyTGPawn.CurrentSlotPct);
//		}
//	}
//
//}
//
//simulated function DrawIconOverhead(GearHUD_Base HUD, Texture2D Icon)
//{
//	local Canvas	Canvas;
//	local String	Str;
//
//	Super.DrawIconOverhead( HUD, Icon );
//
//	Canvas = HUD.Canvas;
//
//	if( MyTGPawn != None )
//	{
//		if( HasValidCover() )
//		{
//			Canvas.SetDrawColor(255, 128, 255);
//			Str = "("$GetRightMost(Cover.Link)$"/"$Cover.SlotIdx$"/"$GetRightMost(Cover.Link.Slots[Cover.SlotIdx].SlotMarker)$")";
//			Canvas.DrawText( Str, TRUE );
//		}
//
//		if( MyTGPawn.IsInCover() )
//		{
//			Canvas.SetDrawColor(0,255,255);
//			Str = "("$GetRightMost(MyTGPawn.CurrentLink)$"/"$MyTGPawn.CurrentSlotIdx$"/"$GetRightMost(MyTGPawn.CurrentLink.Slots[MyTGPawn.CurrentSlotIdx].SlotMarker)$")";
//			Canvas.DrawText( Str, TRUE );
//		}
//	}
//	Canvas.SetDrawColor(255,255,255);
//}
//
//function OnAIConsiderPickups(SeqAct_AIConsiderPickups Action)
//{
//	local class<TGWeapon> ItemClass;
//	local int Index;
//
//	if (Action.InputLinks[0].bHasImpulse)
//	{
//		// add to list
//		foreach Action.ConsiderList(ItemClass)
//		{
//			//@note: we allow duplicates so that executing the "Start" and then "Stop" in sequence will always
//			//	return the list to the exact state it was in prior to the action being used
//			SPItemsToConsider.AddItem(ItemClass);
//		}
//	}
//	if (Action.InputLinks[1].bHasImpulse)
//	{
//		// remove from list
//		foreach Action.ConsiderList(ItemClass)
//		{
//			Index = SPItemsToConsider.Find(ItemClass);
//			if (Index != INDEX_NONE)
//			{
//				SPItemsToConsider.Remove(Index, 1);
//			}
//		}
//	}
//}
//
function BanzaiAttack()
{
	if(MyTGPawn != none && (MyTGPawn.bCanBeForcedToRoadieRun || MyTGPawn.bCanRoadieRun))
	{
		MyTGPawn.bCanRoadieRun=true;
	}

	Super.BanzaiAttack();
}

event ForcePauseAndRepath(Actor InInstigator)
{
	if(MoveGoal != none && MoveGoal.IsA('CoverSlotMarker_Rockworm') &&
		InInstigator.IsA('Rockworm_TailSegment') &&
		VSizeSq(MoveGoal.Location - InInstigator.Location) < 150.f * 150.f
		)
	{
		;
	}
	else
	{
		Super.ForcePauseAndRepath(InInstigator);
	}
}

//function CreateCheckpointRecord(out CheckpointRecord Record)
//{
//	Super.CreateCheckpointRecord(Record);
//
//	Record.DrivenTurretPathName = PathName(CurrentTurret);
//}
//
//function ApplyCheckpointRecord(const out CheckpointRecord Record)
//{
//	local Turret FoundTurret;
//
//	Super.ApplyCheckpointRecord(Record);
//
//	if (MyTGPawn != None && Record.DrivenTurretPathName != "")
//	{
//		FoundTurret = Turret(FindObject(Record.DrivenTurretPathName, class'Turret'));
//		if (FoundTurret != None)
//		{
//			UseTurret(FoundTurret, true, false);
//		}
//	}
//}

final function OnAISetAllowedCover(HDSeqAct_AISetAllowedCover Action)
{
   local CoverLink  CL;
   local Actor      CoverActor;

   if(Action.bClearOld)
   {
       AllowedCoverLinks.Length = 0;
   }

   foreach Action.CoverLink(CoverActor)
   {
       CL =  CoverLink(CoverActor);
       if(CL != none)
       {
           AllowedCoverLinks[AllowedCoverLinks.Length] = CL;
       }
   }
}

final function CoverSlotMarker GetNearestCover()
{
	local CoverSlotMarker Marker;
	local CoverInfo CovToLeader;

	bReachedMoveGoal = FALSE;
	bReachedCover = FALSE;

	// use the cover we're standing on if possible
	Marker = CoverSlotMarker(Pawn.Anchor);
	if (Marker != None &&
		Marker.OwningSlot.Link.IsValidClaim(MyTGPawn,Marker.OwningSlot.SlotIdx) &&
		IsCoverWithinCombatZone(Marker.OwningSlot) )
	{
		return Marker;
	}

	//debug
	;

	bReachedMoveGoal = FALSE;
	//if( Squad != None )
	//{
	//	TetherDistance = 512.f;
	//	if( EvaluateCover( SearchType_Near, GetSquadPosition(), CovToLeader,, AtCover_Best, TetherDistance ) )
	//	{
	//		return CovToLeader.Link.GetSlotMarker(CovToLeader.SlotIdx);
	//	}
	//}

	//debug
	;

	if( EvaluateCover( SearchType_Near, Pawn, CovToLeader,, AtCover_Best ) )
	{
		return CovToLeader.Link.GetSlotMarker(CovToLeader.SlotIdx);
	}

	return none;
}

final function CoverSlotMarker GetNearestCoverEnemy()
{
	local CoverInfo			CovToEnemy;
	local bool				bTowardsGoal;
	local float				NearEnemyDist;
	local CoverSlotMarker	Marker;

	// we can't use cover if we have a shield
	if (MyTGPawn != None && (MyTGPawn.IsAKidnapper() || MyTGPawn.IsCarryingShield()))
	{
		;
		return none;
	}

	//debug
	;

	if( !HasValidCover() && (!HasValidEnemy() || LineOfSightTo(Enemy)) )
	{
		//debug
		;

		// use the cover we're standing on if possible
		Marker = CoverSlotMarker(Pawn.Anchor);
		if (Marker != None &&
			Marker.OwningSlot.Link.IsValidClaim(MyTGPawn,Marker.OwningSlot.SlotIdx) &&
			!IsCoverExposedToAnEnemy(Marker.OwningSlot) &&
			 IsCoverWithinCombatZone(Marker.OwningSlot))
		{
			//debug
			;

			return Marker;
		}
	}
	NearEnemyDist = GetNearEnemyDistance(Pawn.Location);
	// search for cover either towards/away based on closest enemy distance
	bTowardsGoal = SearchForCoverTowardsEnemy( NearEnemyDist );
	;
	if (EvaluateCover(bTowardsGoal ? SearchType_Towards : SearchType_Away,Enemy,CovToEnemy))
	{
		return CovToEnemy.Link.GetSlotMarker(CovToEnemy.SlotIdx);
	}
	else
	// try the opposite if the enemy is close enough
	if (!HasValidCover() &&
		NearEnemyDist < EnemyDistance_Long &&
		EvaluateCover(bTowardsGoal ? SearchType_Away : SearchType_Towards,Enemy,CovToEnemy))
	{
		return CovToEnemy.Link.GetSlotMarker(CovToEnemy.SlotIdx);
	}
	else
	{
		if (HasValidCover() && !IsCoverExposedToAnEnemy(Cover))
		{
			SetAcquireCover( ACT_None );
			if (!IsAtCover())
			{
				return Cover.Link.GetSlotMarker(Cover.SlotIdx);
			}
			else
			{
				;
			}
		}
		else
		{
			;
		}
	}
	return none;
}

function CoverSlotMarker GetInitialCover()
{
	local CoverSlotMarker sm;
	sm = CoverSlotMarker(Pawn.Anchor);
	if (sm != none)
		return sm;

	return GetNearestCover();
}

protected function CoverSlotMarker GetBetterCover( CoverSlotMarker PrevBestMarker )
{
	local CoverInfo NewCover;
	local bool		bTowardsGoal;
	local float		NearEnemyDist;

	NearEnemyDist = GetNearEnemyDistance(Pawn.Location);

	// search for cover either towards/away based on closest enemy distance
	bTowardsGoal = (CombatMood == AICM_Aggressive || (CombatMood != AICM_Passive && NearEnemyDist > EnemyDistance_Short));
	EvaluateCover(bTowardsGoal ? SearchType_Towards : SearchType_Away, Enemy, NewCover,PrevBestMarker);
		//NewCover = Cover;

	if (NewCover.Link != none)
		return NewCover.Link.GetSlotMarker(NewCover.SlotIdx);
	// set cover goal to current so that we don't treat it as a failure
	return none;
}


/** used when the AI is in cover but wants to evaluate moving to different cover */
function CoverSlotMarker GetBestCoverNode()
{
//	local CoverInfo NewCover;
//	local CoverSlotMarker PrevBestMarker;
//	local bool		bTowardsGoal;
//	local float		NearEnemyDist;
//	local float		TempEnemyDistance_Short;
	if ((Pawn != None) && !(TetherActor == None || (bReachedTether && TetherActor.IsA('NavigationPoint'))))
	{
		//debug
		;
		if (MoveAction != none && MoveAction.TetherDistance == 0)
		{
			return none;
		}
		else if (TetherActor != none && !IsTetherOccupied(TetherActor))
		{
			return none;
		}
	}

	if( HasAnyEnemiesRequiringCover() )
	{
		// need fix
		if (CombatZoneList.length > 0)
		{
			// move to nearest cover if we don't have cover already
			if( !HasValidCover() || !IsAtCover() )
			{
				if (CoverSlotMarker(Pawn.Anchor) == none)
					// try to move to cover
					return GetInitialCover();
				else
					return GetBetterCover(CoverSlotMarker(Pawn.Anchor));

			}
			else
			{
				// look for some better cover
				return GetBetterCover((AcquireCover == ACT_DesireBetter) ? GetCoverSlotMarker() : None);
			}
		}
		else
			return GetInitialCover();
	}

	return none;
	//NearEnemyDist = GetNearEnemyDistance(Pawn.Location);

	//TempEnemyDistance_Short = 700;
	//// search for cover either towards/away based on closest enemy distance
	//bTowardsGoal = (CombatMood == AICM_Aggressive || (CombatMood != AICM_Passive && NearEnemyDist > TempEnemyDistance_Short));
	//if( EvaluateCover( bTowardsGoal ? SearchType_Towards : SearchType_Away, Enemy, NewCover,none, AtCover_Best ) )
	//{
	//	//debug
	//	`AILog( "Moving to better cover"@NewCover.Link.GetDebugString(NewCover.SlotIdx) );

	//	return NewCover.Link.GetSlotMarker(NewCover.SlotIdx);
	//}

	//// set cover goal to current so that we don't treat it as a failure
	////if (Cover.Link
	//return GetCoverSlotMarker();
}

event SeePlayer( Pawn Seen )  //Override TGAI::SeePlayer
{
	if (Pawn.Health <= 0)
		return;

    if( Seen != none && Seen != Pawn )
	{
		if( !IsFriendlyPawn( Seen ) )
		{
			ProcessStimulus( Seen, PT_Sight, 'SeePlayer' );

            //for LD
			if( Seen.Controller != none && Seen.Controller.IsLocalPlayerController() )
			    Pawn.TriggerEventClass(class'HDSeqEvent_SeePlayer', Seen);
		}
	}
}

