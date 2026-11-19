/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *	Used for AI that can interact with/use cover
 */
class GearAI_Cover extends GearAI
	native(AI)
	dependson(GearPawn)
	config(AI);

/** GoW global macros */

const TIMER_ADJUSTTOSLOT_LIMIT = 5.f;

cpptext
{

	virtual void ClearCrossLevelPaths(ULevel *Level);

	DECLARE_FUNCTION(execPollAdjustToSlot);
	DECLARE_FUNCTION(execPollMoveTo);

}

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
/** whether we should consider how much a given piece of cover exposes/flanks enemy targets when doing cover evaluation */
var bool bWeightEnemyExposure;
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
/** Next time this AI is allowed to peek */
var			float			NextAllowPeekTime;
/** Next time we'll update our idle focus */
var         float           NextIdleFocusTime;


/** Last time we played a meat shield reaction **/
var float LastMeatShieldReactionTime;
/** Minimum amount of time in between meat shield reactions **/
var() config float MeatShield_Reaction_MinTimeInterval;
/** Chance that we will react to a given meat shield event **/
var() config float MeatShield_Reaction_Chance;
/** Time after noticing meat shield to play the reaction **/
var() config float MeatShield_Reaction_Delay;
var GearPawn MeatShield_Reaction_Target;

/** for SP only - inventory the LD has given the AI the OK to pick up (AI ignores all other pickups) */
var array< class<GearWeapon> > SPItemsToConsider;

/** default AtCover goal evaluater profiles */
var instanced NavMeshGoal_AtCover AtCover_Toward;
var instanced NavMeshGoal_AtCover AtCover_Away;
var instanced NavMeshGoal_AtCover AtCover_Near;
var instanced NavMeshGoal_AtCover AtCover_Squad;
var instanced NavMeshGoal_AtCover AtCover_Ambush;
var instanced NavMeshGoal_AtCover AtCover_AlongPath;

/** list of cover links this AI is allowed to use for cover (if blank all cover is fair game) */
var array<CoverLink> AllowedCoverLinks;

/** template for instancing stopping power reaction - should not be attached itself */
var AIReactCond_StoppingPowerThreshold StoppingPowerReactionTemplate;

// next time we setcovertype, don't pushoutofcover (will be reset once we successfully leave cover)
var bool bLeaveCoverFast;

// when scripted onto a turret by a designer, save a ref to the turret we've been given
var turret ScriptedTurret;

/** DEBUG var which enables insane amounts of debugging */
var(Debug) transient bool bVerboseDebugCover;


// forces log output (even in FINAL_RELEASE) use with caution!
native final function ForceLog(coerce string s);

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
	local AIReactCond_StoppingPowerThreshold ReactCond;

	Super.Possess( NewPawn, bVehicleTransition );

	//`AILog(self@MyGearPawn@MyGearPawn.bAllowStoppingPower);
	//`log(self@MyGearPawn@MyGearPawn.bAllowStoppingPower);

	if( MyGearPawn != None )
	{
		// Only let AI slide half the distance to cover
		MyGearPawn.Run2CoverMaxDist	= MyGearPawn.default.Run2CoverMaxDist * 0.5f;


		ReactCond = AIReactCond_StoppingPowerThreshold(ReactionManager.FindReactionByType(class'AIReactCond_StoppingPowerThreshold', false));

		// if our pawn supports stopping power, push on a stopping power threshold reaction so we evade when we get too much stopping power
		if(MyGearPawn.bAllowStoppingPower && ReactCond == none)
		{
			`AILog("My pawn supports stopping power, pushing stopping power evade reaction");
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


function class<AICommand> GetDefaultCommand()
{
	if( MyGearPawn.IsCarryingCleaver() )
	{		
		return class'AICmd_Base_Cleaver';
	}

	return Super.GetDefaultCommand();
}

function bool StepAsideFor(Pawn ChkPawn)
{
	local GearPawn GP;
	GP = GearPawn(ChkPawn);
	if( HasValidCover() && IsAtCover() )
	{
		if( (MyGearPawn.CurrentLink != none && MyGearPawn.CurrentLink.bDynamicCover) ||  (GP != none && ChkPawn.IsHumanControlled() && GP.IsInCover()) )
		{
			`AILog( "- I'm in cover, but a player who is also in cover just bumped me, or I'm on a dynamic cover node.. leaving cover" );

			InvalidateCover();
			return Super.StepAsideFor( ChkPawn );
		}
		else if(GP == none || !(ChkPawn.IsHumanControlled() && GP.IsInCover()) )
		{
			`AILog("- in cover, ignoring StepAsideFor request");
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
	if( AICommand_Base_Combat(CommandList) == None )
	{
		SetAcquireCover( ACT_Immediate, 'MoveToCombatZone' );
		return Super.MoveToCombatZone();
	}

	return FALSE;
}

event SetCurrentCombatZone( CombatZone NewCZ )
{
	local Actor		AmbushTarget;
	local CoverInfo	CovInfo;

	//debug
	`AILog( GetFuncName()@NewCZ );

	Super.SetCurrentCombatZone( NewCZ );

	if( CurrentCombatZone == None )
		return;

	//debug
	`AILog( "..."@CurrentCombatZone.ZoneType@CurrentCombatZone.AmbushTargets.length );

	if( CurrentCombatZone.ZoneType == CZT_Ambush )
	{
		if( CurrentCombatZone.AmbushTargets.Length < 0 || (MoveAction != none && !MoveAction.bInterruptable))
			return;

		AmbushTarget = CurrentCombatZone.AmbushTargets[Rand(CurrentCombatZone.AmbushTargets.Length)];
		if( EvaluateCover( SearchType_Ambush, AmbushTarget, CovInfo, Cover ) )
		{
			SetCombatMood( AICM_Ambush );
			SetCoverGoal( CovInfo, TRUE );
		}
	}
}

event CombatZone FindCurrentCombatZone( Vector TestLoc )
{
	local int Idx;

	for( Idx = 0; Idx < CombatZoneList.Length; Idx++ )
	{
		if( CombatZoneList[Idx].EncompassesPoint( TestLoc ) )
		{
			return CombatZoneList[Idx];
		}
	}

	return None;
}

function FireFromCover()
{
	class'AICmd_Attack_FireFromCover'.static.FireFromCover( self );
}

function bool PeekFromCover( optional bool bLookForEnemy = TRUE, optional float PeekTime=0.f )
{
	if (WorldInfo.TimeSeconds > NextAllowPeekTime && MyGearPawn != None && !MyGearPawn.IsCarryingAHeavyWeapon())
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
			if( !P.IsA( 'GearPawn_LocustNemaslug' ) )
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
	if (MyGearPawn != None && MyGearPawn.IsInCover())
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

/** Find an Interesting Focus while idle */
function IdleDontFaceWalls()
{
	local Vector SquadLeaderLoc;
	local int NextRouteIdx;
	local bool bFoundFaceTarget;
	local GearPC Player;
	local Controller AController;
	local FLOAT CurrentDistance;
	local array<Pawn>   PawnOptions;

	// See if we can Head Track our Focus Point.
	// Some states (like playing an Idle Break animation) don't work with Focus tracking.
	// Disable on InterpActors, as turn in place is disabled there, so it looks very bad to have them just slide to face the player.
	if( !MyGearPawn.ShouldHeadTrackFocusPoint() || (MyGearPawn.Base != None && MyGearPawn.Base.IsA('InterpActor')) )
	{
		`AILog( GetFuncName() @ "ShouldHeadTrackFocusPoint == FALSE, clear Focus:" @ Focus );
		Focus = None;
		SetFocalPoint( Pawn.Location + Vector(Pawn.Rotation) * 128.f, TRUE );
		NextIdleFocusTime = WorldInfo.TimeSeconds;
		return;
	}

	// Only check for a new Focus at regular intervals
	if( `TimeSince(NextIdleFocusTime) < 0 )
	{
		`AILog( GetFuncName() @ "delaying for NextIdleFocusTime" @ `TimeSince(NextIdleFocusTime) );
		return;
	}

	// Next time we'll update our focus point.
	NextIdleFocusTime = WorldInfo.TimeSeconds + RandRange(4.f, 8.f);

	// If we are head tracking something, don't override our Focus
	if( MyGearPawn.ReplicatedHeadTrackInfo.HeadLookAtActor != None && MyGearPawn.ReplicatedHeadTrackInfo.HeadTrackPriority != EHTP_AIFocus )
	{
		`AILog( GetFuncName() @ "Already HeadTracking something" @ MyGearPawn.ReplicatedHeadTrackInfo.HeadLookAtActor @ "Don't override our Focus" @ Focus );
		return;
	}

	// if we have a squad position, face it
	if( Squad != None )
	{
		// Sometimes look at the player anyway, otherwise look at squad position
		if( FRand() < 0.5f && (Squad.Leader != self && Squad.SquadRoute != None) )
		{
			NextRouteIdx = Squad.SquadRouteIndex + 1;
			if( NextRouteIdx < Squad.SquadRoute.RouteList.Length && 
				Squad.SquadRoute.RouteList[NextRouteIdx].Actor != None )
			{
				// face NEXT squad position
				SquadLeaderLoc = Squad.SquadRoute.RouteList[NextRouteIdx].Actor.Location;
			}
			else
			{
				// face CURRENT squad position
				SquadLeaderLoc = GetSquadLeaderLocation();
			}
			// always look level
			SquadLeaderLoc.Z = Pawn.Location.Z;

			`AILog("Facing Squad Position");

			Focus = None;
			SetFocalPoint( SquadLeaderLoc, TRUE );
			bFoundFaceTarget = TRUE;
		}

		if( !bFoundFaceTarget )
		{
			// Pick a random Pawn in the Squad
			foreach Squad.AllMembers(class'Controller', AController)
			{
				if( AController.Pawn != Pawn && AController.Pawn != None )
				{
					CurrentDistance = VSizeSq(AController.Pawn.Location - Pawn.Location);
					if( CurrentDistance < 512.f*512.f || (AController.Pawn.IsHumanControlled() && CurrentDistance < 1024.f * 1024.f) )
					{
						PawnOptions[PawnOptions.Length] = AController.Pawn;
					}
				}
			}

			if( PawnOptions.Length > 0 )
			{
				Focus = PawnOptions[Rand(PawnOptions.Length)];
				bFoundFaceTarget = True;

				`AIlog("Facing APawn in squad:" @ PawnOptions.Length @ Focus);
			}
		}
	}


	// if we still didn't find anything, look for a player in the area
	if( !bFoundFaceTarget )
	{
		foreach LocalPlayerControllers(class'GearPC', Player)
		{
			`AIlog("Fallback, facing player:"@Player);
			Focus = Player.Pawn;
			bFoundFaceTarget = True;
			break;
		}
	}
}

///////////////////////////////////////////////
//////////////// ACTION STATES ////////////////
///////////////////////////////////////////////

state Action_Idle
{
	function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );	
		NextIdleFocusTime = WorldInfo.TimeSeconds + RandRange(2.f, 4.f);
	}

Begin:
	//debug
	`AILog( "BEGIN TAG"@PrintTetherInfo(), 'State' );

	// make sure we have a squad
	if (Squad == None)
	{
		SetSquadName('Alpha');
	}

	// Select our weapon
	if( SelectWeapon() )
	{
		`AILog("Selected weapon");
		Sleep( 0.25f );
	}

	CheckReviveOrExecute(1200.0); // player might get downed by scripted stuff while out of combat, or combat just recently ended

	// check for a tether
	if( Pawn != None && !IsWithinTether( Pawn.Location ) )
	{
		//debug
		`AILog( "Not within tether, moving"@MoveAction@GetTetherActor() );

		if(MoveAction != none && MoveAction.TetherDistance == 0)
		{
			OnAIMove(MoveAction);
		}
		else
		{
			// Move to tether
			SetTether( GetTetherLocation(), GetTetherActor(), DesiredTetherDistance, bDynamicTether, TetherPersistDuration );
		}
	}
	else
	{
		SetPendingCombatZone( FindCurrentCombatZone(Pawn.Location) );

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
			`AILog("I'm the squad leader! Squad.bPlayerSquad: "$Squad.bPlayerSquad@Squad.GetSquadLeaderPosition());
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
			`AILog("Moving to squad...");

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
				ClearTether();
			}
			bKeepTether = FALSE;

			// check to see if we should immediately move again
			if (!HasAnyEnemies() &&
				ShouldMoveToSquad())
			{
				//debug
				`AILog("Continuing move to squad");
				Sleep(0.1f);
				Goto('MoveToSquad');
			}
			else
			{
				`AILog("Not continuing move to squad?"@HasAnyEnemies()@ShouldMoveToSquad());
			}
			Sleep(0.25f);
		}
		else
		{
			// check to see if we should get into cover because of our squad leader
			if ( !IsTethered() && IsAlert() &&
				(!HasValidCover() || !IsAtCover()))
			{
				//debug
				`AILog("Moving to cover because of alertness or squad leader being in cover"@IsAlert()@HasValidCover()@IsAtCover());

				ClearMovementInfo();
				MoveToNearestCoverIdle();
				if (!bReachedMoveGoal)
				{
					`AILog("No nearby cover or failed to reach cover, sleeping");
					Sleep(1.f);
				}
			}
			else if (IsAlert() && IsAtCover())
			{
				if (!PeekFromCover())
				{
					Sleep(0.5f);
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
				`AILog("Shouldn't move to squad or cover, sleeping"@PrintTetherInfo()@MoveAction);

				Sleep(1.f);
			}
		}
	}
	IdleDontFaceWalls();
	Goto('Begin');
}

//////////////////////////////////////////////////
//////////////// SUBACTION STATES ////////////////
//////////////////////////////////////////////////
/**
 * Checks to see if we can run to cover, if TestMoveTarget is a slot within range basically.
 */
final event bool CanRun2Cover( CoverInfo Info )
{
	if(!IsAlert() || !IsInCombat())
	{
		return FALSE;
	}

	// If Pawn cannot do the run2cover, then don't go any further
	if (!MyGearPawn.bCanDoRun2Cover || MyGearPawn.IsAKidnapper() || MyGearPawn.IsCarryingShield() || MyGearPawn.IsCarryingAHeavyWeapon() || GearWeap_HeavyCoopMGBase(MyGearPawn.Weapon) != None)
	{
		return FALSE;
	}

	if(`TimeSince(LastRun2CoverTime) < 1.0f)
	{
		//`log(">>>>>>>>>>>>>>>>>>> time since last run2cover time is < 1second, not allowing run2cover!!!");
		return FALSE;
	}

	// if it is our covergoal or current cover, and
	// if not already in cover, and
	// it is within range, and
	// is roughly in front of us, and
	// we're roughly facing it
	if ((Info == CoverGoal || Info == Cover) &&
		!MyGearPawn.IsInCover() &&
		VSize(Pawn.Location - Info.Link.GetSlotLocation(Info.SlotIdx)) <= MyGearPawn.Run2CoverMaxDist &&
		Normal(Info.Link.GetSlotLocation(Info.SlotIdx) - Pawn.Location) dot vector(Info.Link.GetSlotRotation(Info.SlotIdx)) > 0.3f &&
		vector(Pawn.Rotation) dot vector(Info.Link.GetSlotRotation(Info.SlotIdx)) > 0.3f)
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

final function bool ShouldReactToMeatShield(GearPawn MSKidnapper)
{
	return (WorldInfo.TimeSeconds - LastMeatShieldReactionTime > MeatShield_Reaction_MinTimeInterval && FRand() < MeatShield_Reaction_Chance);
}

function NotifyEnemyUsingMeatShield(GearPawn MSKidnapper)
{
	`AILog(GetFuncName()@Enemy);
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
		Squad.NotifyReactingToMeatShield( MyGearPawn, MeatShield_Reaction_Target );
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
final function bool SetCoverGoal( CoverInfo NewCoverGoal, optional bool bIsValidCache, optional bool bInInterruptable=TRUE, optional bool bInClearmoveActionOnFailure=FALSE  )
{
	//debug
	`AILog( GetFuncName()@NewCoverGoal.Link@NewCoverGoal.SlotIdx, 'Cover' );

	if( HasValidCover() && IsAtCover() && Cover.Link == NewCoverGoal.Link )
	{
		if( class'AICmd_Move_SlotToSlot'.static.SlotToSlot( self, Cover.Link, Cover.SlotIdx, NewCoverGoal.SlotIdx ) )
		{
			return TRUE;
		}
	}

	return class'AICmd_MoveToCover'.static.MoveToCover( self, NewCoverGoal, bIsValidCache, bInInterruptable, bInClearmoveActionOnFailure );
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

function bool SetTether( Vector NewTetherLocation, Actor NewTetherActor, optional float NewTetherDistance, optional bool NewbDynamicTether, optional float NewTetherPersistDuration, optional bool bInteruptable, optional bool bIsValidCache )
{
	local CombatZone	CZ;
	local CoverInfo		Info;
	local float			OldTetherDistance;
	local CoverLink		Link;
	local int			Idx;
	local float			CurDist;
	local float			BestDist;
	local bool          bFound;

	`AILog( GetFuncName()@NewTetherLocation@NewTetherActor@NewTetherDistance@NewbDynamicTether@NewTetherPersistDuration@bInteruptable@bIsValidCache);

	// Don't allow tether to controllers, instead move to a node in the combat zone
	CZ = CombatZone(NewTetherActor);
	if( CZ != None )
	{
		NewTetherActor = None;

		// If my anchor is already in the combat zone, stay tethered to it
		if( IsTethered() && CZ.EncompassesPoint( GetTetherLocation() ) )
		{
			//debug
			`AILog( "Tether"@GetTetherActor()@GetTetherLocation()@"already in combat zone" );

			NewTetherLocation = GetTetherLocation();
			bFound = TRUE;
		}
		else
		{
			//debug
			`AILog( "Search for cover in comat zone"@CZ@CZ.GetHumanReadableName() );

			// Otherwise, search for cover closest to me and move to it
			OldTetherDistance = TetherDistance;
			TetherDistance = 4096.f;
			if( EvaluateCover( SearchType_Near, MyGearPawn, Info ) )
			{
				NewTetherLocation = Info.Link.GetSlotLocation(Info.SlotIdx);

				//debug
				`AILog( "Found cover at"@Info.Link@Info.SlotIdx@NewTetherLocation );
				bFound = TRUE;
			}

			TetherDistance = OldTetherDistance;
		}

		if( !bFound )
		{
			//debug
			`AILog( GetFuncName()@"FAILED to handle CZ"@CZ@CZ.GetHumanReadableName() );
		}
	}
	else if( MoveAction != None )
	{
		Link = CoverLink(NewTetherActor);
		if( Link != None )
		{
			// if we've been given a specific index to run to
			if( MoveAction.DestinationSlotIndex > -1 )
			{
				Info.Link = Link;
				Info.SlotIdx = MoveAction.DestinationSlotIndex;
				//`AILog("Calling MoveToCover: "@Info.Link@Info.SlotIdx);
				return SetCoverGoal( Info,, bInteruptable );
			}
			// if tether dist is 0, treat this like an order to go to that link, and use any of its coverslots
			else if( NewTetherDistance == 0 )
			{
				BestDist=-1;
				// find a valid slot to use
				for(Idx=0;Idx<Link.Slots.length;Idx++)
				{
					if(Link.IsValidClaim(Pawn,Idx))
					{
						CurDist = VSizeSq(Link.GetSlotLocation(Idx) - Pawn.Location);

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
					return SetCoverGoal( Info,, bInteruptable, TRUE );
				}
				`AILog("Could not find unclaimed slot on "$Link$" running to link instead =/");
			}
		}
	}


	return Super.SetTether( NewTetherLocation, NewTetherActor, NewTetherDistance, NewbDynamicTether, NewTetherPersistDuration, bInteruptable, bIsValidCache );
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
	`AILog( GetFuncName()@bUnclaimOnly );

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

		if( MyGearPawn != None )
		{
			// Claim
			bResult = MyGearPawn.ClaimCover( NewCover.Link, NewCover.SlotIdx );
		}

		// If claimed and this is our goal - keep link
		if( bResult )
		{
			//debug
			`AILog( GetFuncName()@NewCover.Link@NewCover.SlotIdx@bResult );

			Cover = NewCover;
		}
		else
		{
			//debug
			`AILog( "Failed to claim cover - existing claim:"@NewCover.Link.Slots[NewCover.SlotIdx].SlotOwner );
		}
	}
	else
	{
		//debug
		`AILog( "Invalid cover:"@NewCover.Link@NewCover.SlotIdx );
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
		`AILog( GetFuncName()@Cover.Link@Cover.SlotIdx );

		// save the last cover
		LastCover = Cover;
		// release the claim
		if( MyGearPawn != None )
		{
			MyGearPawn.UnClaimCover( Cover.Link, Cover.SlotIdx, TRUE );
		}
	}
	// clear the cover
	Cover.Link = None;
	Cover.SlotIdx = -1;
	bReachedCover = FALSE;
}

protected function bool EvaluateCoverInternal
(
	ECoverSearchType Type, 
	Actor GoalActor, 
	out CoverInfo out_Cover, 
	optional CoverInfo InBestCover, 
	optional int InBestCoverRatingTheshold,
	optional NavMeshGoal_AtCover GoalEvaluator, 
	optional float MaxDistFromGoal,
	optional vector OverrideGoalLoc 
)
{
	local Actor DestActor;
	local int DestItem;
	local bool bResult;
	local vector GoalLoc;
	local CovGoal_WithinAllowedCoverLinks TempCovGoal;

	// we can't use cover when we're holding a shield
	if (MyGearPawn != None && (MyGearPawn.IsAKidnapper() || MyGearPawn.IsCarryingShield() || MyGearPawn.IsCarryingCleaver() || GearWeap_HeavyCoopMGBase(MyGearPawn.Weapon) != None))
	{
		return FALSE;
	}

	if (!IsZero(OverrideGoalLoc))
	{
		GoalLoc = OverrideGoalLoc;
	}
	else if (GoalActor != None)
	{
		GoalLoc = GoalActor.Location;
	}
	else
	{
		`Warn("Call to EvaluateCover() with no GoalActor and no GoalLoc");
		ScriptTrace();
		return false;
	}

	//debug
	`AILog( GetFuncName()@Type@`showvar(GoalActor)@InBestCover.Link@InBestCover.SlotIdx@`showvar(InBestCoverRatingTheshold)@`showvar(GoalEvaluator)@`showvar(OverrideGoalLoc) );

	AddBasePathConstraints(true);

/* @FIXME: navmesh
	// if we've been given a max dist from our goal, enforce it
	if(MaxDistFromGoal > 0)
	{
		`AILog("Not traversing outside max distance: "@MaxDistFromGoal);
		class'Path_WithinDistanceEnvelope'.static.StayWithinEnvelopeToLoc(Pawn,GoalLoc,MaxDistFromGoal,0.f,FALSE,,TRUE);
	}
*/


	if( Type == SearchType_AlongPath )
	{
		//debug
		`AILog( GetFuncName()@"Searching... ALONG PATH!" );

		class'NavMeshPath_AlongLine'.static.AlongLine( NavigationHandle, Normal( GoalLoc - Pawn.Location ) );
		class'NavMeshPath_WithinTraversalDist'.static.DontExceedMaxDist(NavigationHandle, Max(VSize(GoalLoc-Pawn.Location)*0.5f,512),FALSE);
		if( GoalEvaluator == None )
		{
			GoalEvaluator = AtCover_AlongPath;
			if (CovGoal_ProtectedByLocation(GoalEvaluator.CoverGoalConstraints[0]) != None)
			{
				CovGoal_ProtectedByLocation(GoalEvaluator.CoverGoalConstraints[0]).ThreatLocation = GoalLoc;
			}
		}
	}
	else if( Type == SearchType_Towards )
	{
		//debug
		`AILog(GetFuncName()@"Searching... TOWARDS!");
		class'NavMeshPath_AlongLine'.static.AlongLine( NavigationHandle, Normal( GoalLoc - Pawn.Location ) );

		if(GoalEvaluator == none)
		{
			GoalEvaluator = AtCover_Toward;
		}
	}
	else if( Type == SearchType_Away )
	{
		//debug
		`AILog(GetFuncName()@"Searching... AWAY!");
		class'NavMeshPath_AlongLine'.static.AlongLine( NavigationHandle, -Normal( GoalLoc - Pawn.Location ) );
		if(GoalEvaluator == none)
		{
			GoalEvaluator = AtCover_Away;
		}
	}
	else if( Type == SearchType_Near )
	{
		//debug
		`AILog(GetFuncName()@"Searching... NEAR!");
		// don't try and move toward a goal actor if we have a combatzone to test.. we should be moving toward
		// the closest combat zone already
		if (!IsZero(OverrideGoalLoc))
		{
			class'NavMeshPath_Toward'.static.TowardPoint(NavigationHandle, OverrideGoalLoc);
		}
		else
		{
			class'NavMeshPath_Toward'.static.TowardGoal(NavigationHandle, GoalActor);
		}
		if(GoalEvaluator == none)
		{
			GoalEvaluator = AtCover_Near;
		}

	}
	else if( Type == SearchType_Ambush )
	{
		//debug
		`AILog(GetFuncName()@"Searching... AMBUSH!");
		if( GoalEvaluator == None )
		{
			GoalEvaluator = AtCover_Ambush;
			if (CovGoal_ProtectedByLocation(GoalEvaluator.CoverGoalConstraints[0]) != None)
			{
				CovGoal_ProtectedByLocation(GoalEvaluator.CoverGoalConstraints[0]).ThreatLocation = GoalLoc;
			}
		}
	}

	// if we have been restricted to a set of coverlinks then push the allowed coverlinks constraint
	if (AllowedCoverLinks.length > 0 && Type != SearchType_AlongPath)
	{
		`AILog("Adding withinallowedcoverlinks since we have some in our list.");
		TempCovGoal = new(self) class'CovGoal_WithinAllowedCoverLinks';
		GoalEvaluator.CoverGoalConstraints.AddItem(TempCovGoal);
	}

	GoalEvaluator.Init(self, GoalLoc);

	// rate the best so we can save off the 'best' scores for comparison against new ones
	if (InBestCover.Link != None)
	{
		//@note: initial weight here assumes slot is anchor or at least directly reachable
		GoalEvaluator.RateSlot( InBestCover, VSize(InBestCover.Link.GetSlotLocation(InBestCover.SlotIdx) - Pawn.Location) );
		GoalEvaluator.BestRatingTheshold = InBestCoverRatingTheshold;
	}

	if (NavigationHandle.FindPath(DestActor, DestItem))
	{
		out_Cover.Link	  = CoverLink(DestActor);
		out_Cover.SlotIdx = DestItem;
		`RecordAITakeCover(self, out_Cover.Link.GetSlotLocation(out_Cover.SlotIdx));
		bResult = true;
	}

	// if we added a coverlink limit, remove it now so it doesn't stick around after the fact
	if (AllowedCoverLinks.length > 0 && Type != SearchType_AlongPath)
	{
		GoalEvaluator.CoverGoalConstraints.RemoveItem(TempCovGoal);
	}

	// then we need to clear constraints because it's possible FindPathToward didn't (this does need to be here, please don't remove it! ;) )
	NavigationHandle.ClearConstraints();


	if( !bResult )
	{
		`RecordAICantFindCover(self);
	}

	return bResult;
}

/** uses pathfinding to search for and evaluate potential cover locations
 * @param Type - search type/direction/logic to use; affects path constraints and default cover evaluator
 * @param GoalActor - anchor point for search type ("towards this"/"away from this"/etc)
 * @param out_Cover (out) - the cover that was found
 * @param InBestCover (opt) - if passed in, evaluate this cover first (generally the AI's current cover)
 * 				@note: AI's current cover not evaluated normally (pass it in here if that is desired)
 * @param GoalEvaluator (opt) - allows overriding the default cover evaluator for Type
 * @param MaxDistFromGoal (opt) - if specified, won't evaluate cover beyond this many units from the goal location
 * @param OverrideGoalLoc (opt) - overrides the goal location of GoalActor.Location; must be specified if GoalActor == None
 *					use only when an Actor isn't available, as debugging "cover near Marcus"
 *					is a lot easier than "cover near (x=300,y=550,z=10)"
 * @return whether the search was successful (some cover found)
 */
function bool EvaluateCover
(
	ECoverSearchType Type,
	Actor GoalActor,
	out CoverInfo out_Cover,
	optional CoverInfo InBestCover,
	optional int InBestCoverRatingTheshold,
	optional NavMeshGoal_AtCover GoalEvaluator,
	optional float MaxDistFromGoal,
	optional vector OverrideGoalLoc
)
{
	`AILog(GetFuncName()@Type@GoalActor@InBestCover.Link@InBestCover.SlotIdx@GoalEvaluator);

	return EvaluateCoverInternal(Type, GoalActor, out_Cover, InBestCover, InBestCoverRatingTheshold, GoalEvaluator, (Type != SearchType_AlongPath) ? MaxDistFromGoal : 0.f, OverrideGoalLoc);
}

function bool IgnoreTimeTransitions()
{
	if( MyGearPawn != None &&
		MyGearPawn.Weapon != None &&
		MyGearPawn.Weapon.IsA( 'GearWeap_GrenadeBase' ) &&
		IsLeaning() )
	{
		return TRUE;
	}

	return Super.IgnoreTimeTransitions();
}

/** Figure out if AI should blind fire */
event bool ShouldBlindFire()
{
	local float	  Chance;
	local int	  Idx, Num, Tickets;

	// If pawn can't blind fire - fail
	if( MyGearPawn == None || !MyGearPawn.bCanBlindFire )
	{
		return FALSE;
	}

	// don't blind fire at stuff far away
	if( ! IsShortRange(GetFireTargetLocation(LT_Exact)) )
	{
		return FALSE;
	}

	// if our difficulty level doesn't allow it, don't blindfire
	if ( (!WorldInfo.GRI.IsMultiplayerGame() || WorldInfo.GRI.IsCoopMultiplayerGame()) &&
		MyGearPawn.GetTeamNum() == TEAM_LOCUST &&
		!class'DifficultySettings'.static.GetLowestPlayerDifficultyLevel(WorldInfo).default.bAllowLocustBlindFire )
	{
		return FALSE;
	}


	// No blind firing grenades
	if( MyGearPawn.Weapon.IsA( 'GearWeap_GrenadeBase' ) )
	{
		return FALSE;
	}

	// Figure out how many fire tickets are taken
	Num = MyGearPawn.FireTickets.Length;
	for( Idx = 0; Idx < Num; Idx++ )
	{
		if( MyGearPawn.FireTickets[Idx] != None )
		{
			Tickets++;
		}
	}

	// Chance to blind fire is base value + tickets
	Chance = MyGearPawn.BlindFirePct + (Tickets * MyGearPawn.BlindFirePct);
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
	if( MyGearPawn != None &&
		Cover.Link != None &&
		Cover.SlotIdx >= 0 &&
		Cover.SlotIdx < Cover.Link.Slots.Length )
	{
		//debug
		`AILog(GetFuncName()@Cover.Link@Cover.SlotIdx);

		if( Cover.Link.Slots.Length <= 1 )
		{
			MyGearPawn.SetCoverInfo( Cover.Link, Cover.SlotIdx, Cover.SlotIdx, Cover.SlotIdx, 0.f);
		}
		else if( Cover.SlotIdx == Cover.Link.Slots.Length - 1 )
		{
			MyGearPawn.SetCoverInfo( Cover.Link, Cover.SlotIdx, Cover.SlotIdx - 1, Cover.SlotIdx, 1.f);
		}
		else
		{
			MyGearPawn.SetCoverInfo( Cover.Link, Cover.SlotIdx, Cover.SlotIdx, Cover.SlotIdx + 1, 0.f);
		}
		MyGearPawn.AcquiredCoverInfo = MyGearPawn.CoverInfoToCovPosInfo(Cover);

		return TRUE;
	}
	else
	{
		//debug
		`AILog( "Bad SetCoverType call"@Cover.Link@Cover.SlotIdx, 'Cover' );
	}

	return FALSE;
}

/**
 * Resets our cover type.
 */
final function ResetCoverType()
{
	local Rotator Rot;
	local Vector  Loc;

	if (MyGearPawn != None)
	{
		`AILog(GetFuncname()@MyGearPawn@MyGearPawn.CurrentLink);
		if(MyGearPawn.CurrentLink != None )
		{
			if( IsLeaning() )
			{
				GetPlayerViewPoint( Loc, Rot );
			}
			else
			{
				Rot = MyGearPawn.CurrentLink.GetSlotRotation(MyGearPawn.CurrentSlotIdx);
			}

			SetDesiredRotation(Rot);
			MyGearPawn.ResetDesiredRotation(); // so AI can override DesiredRotation as soon as it finishes PushOutOfCover
			Focus = None;
			SetFocalPoint( MyGearPawn.Location + Vector(MyGearPawn.Rotation) * 512.f, TRUE );

		}

		MyGearPawn.LeaveCover();
		MyGearPawn.AcquiredCoverInfo.Link = None;
	}

}

final function bool SetCoverAction( ECoverAction Action )
{
	local bool bShouldTarget;

	//debug
	`AILog( GetFuncName()@Action );

	if( MyGearPawn != None )
	{
		bShouldTarget = (MyGearPawn.Weapon != None && (Action == CA_PopUp || MyGearPawn.Weapon.IsA('GearWeap_GrenadeBase') || MyGearPawn.IsCarryingAHeavyWeapon()));
		//@note: ordering is important here as some effects of targeting care about cover action (e.g. heavy weapon mounting)
		MyGearPawn.SetCoverAction(Action);
		MyGearPawn.SetTargetingMode(bShouldTarget);
		MyGearPawn.SetWeaponAlert(5.0);
		return TRUE;
	}

	return FALSE;
}

final function ResetCoverAction( optional bool bResetCrouch )
{
	if( MyGearPawn != None && MyGearPawn.CoverAction != CA_Default )
	{
		MyGearPawn.SetTargetingMode( FALSE );
		MyGearPawn.SetCoverAction(CA_Default);
		if( bResetCrouch )
		{
			MyGearPawn.ShouldCrouch( FALSE );
		}
	}

	// if the weapon fires on release (e.g. torque bow), finish the current burst before stopping
	// this prevents the AI from firing into the wall in front of it when it aborts a cover action while charging a shot
	if (Pawn != None && GearWeapon(Pawn.Weapon) != None && Pawn.FireOnRelease())
	{
		GearWeapon(Pawn.Weapon).RemainingBurstsToFire = 1;
	}
	else
	{
		StopFiring();
	}
	PendingFireLinkItem.SrcAction = CA_Default;
	PendingFireLinkItem.SrcType	  = CT_None;
}

final function bool IsLeaning()
{
	return MyGearPawn != None && MyGearPawn.IsLeaning();
}

final function bool IsPeeking()
{
	return MyGearPawn != None && MyGearPawn.IsPeeking(MyGearPawn.CoverAction);
}

event bool ShouldDo360Aiming( Vector TargLoc )
{
	local rotator DeltaRot;
	local vector2d NewAimOffsetPct;
	local ECoverDirection UnusedCoverDir;

	// heavy weapons can't do 360 aiming
	if (MyGearPawn.IsCarryingAHeavyWeapon())
	{
		return false;
	}
	else
	{
		// find out delta angle between pawn's rotation and crosshair direction
		DeltaRot = Normalize(rotator(TargLoc - MyGearPawn.GetAimOffsetOrigin()) - Pawn.Rotation);
		NewAimOffsetPct.X = NormalizeRotAxis(DeltaRot.Yaw) / 16384.0;
		NewAimOffsetPct.Y = NormalizeRotAxis(DeltaRot.Pitch) / 16384.0;

		return MyGearPawn.Simulate360Aiming(MyGearPawn.bDoing360Aiming, NewAimOffsetPct, MyGearPawn.CoverType, UnusedCoverDir);
	}
}

final native function bool GetCoverAction( out CoverInfo ChkCover, optional Actor ChkTarget, optional bool bAnyAction, optional bool bTest, optional Name DebugTag );

final function bool GetPeekCoverAction( optional ECoverAction Pending )
{
	local array<ECoverAction> Actions;
	local ECoverAction Action;

	// Don't peek during 360 aiming
	if( MyGearPawn == None || MyGearPawn.bDoing360Aiming )
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

	MyGearPawn.CurrentLink.GetSlotActions( MyGearPawn.CurrentSlotIdx, Actions );

	// If we have available actions
	if( Actions.Length > 0 )
	{
		// Randomly choose an action
		Action = Actions[Rand(Actions.Length)];

		//debug
		`AILog( "New peek cover action is:"@Action@MyGearPawn.CurrentLink@MyGearPawn.CurrentSlotIdx );

		PendingFireLinkItem.SrcAction = Action;
		PendingFireLinkItem.SrcType	  = CT_None;
		return TRUE;
	}

	//debug
	`AILog( "Failed to get peek cover action"@MyGearPawn.CurrentLink@MyGearPawn.CurrentSlotIdx );

	return FALSE;
}

final function bool ShouldWaitForTransition( ECoverAction Action )
{
	local bool	  bSwitch;
	local bool	  bWantsToBeMirrored;

	if( MyGearPawn != None )
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
			MyGearPawn.SetMirroredSide( bWantsToBeMirrored );
			return TRUE;
		}
	}

	return FALSE;
}

function Tick(float DeltaTime)
{
	if (Pawn != None && Pawn.IsFiring())
	{
		CheckBlindFire();
	}

	Super.Tick(DeltaTime);
}

/** Move pawn towards current slot */
native final noexport latent function AdjustToSlot( CoverInfo TargetSlot );

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
	if( MyGearPawn == None || MyGearPawn.TargetSlot.Link == None )
	{
		return;
	}

	//debug
	`AILog( "NotifyReachedCoverSlot -- Link"@MyGearPawn.CurrentLink$"/"$Cover.Link@"Reached"@MyGearPawn.CurrentSlotIdx@"Target"@MyGearPawn.TargetSlot.Link@MyGearPawn.TargetSlot.SlotIdx@"Dir"@MyGearPawn.CurrentSlotDirection@"Pct"@MyGearPawn.CurrentSlotPct, 'Cover' );

	if( SlotIdx != MyGearPawn.TargetSlot.SlotIdx &&
		Cover.Link == MyGearPawn.CurrentLink )
	{
		if( !Cover.Link.bClaimAllSlots )
		{
			// Otherwise, if we aren't supposed to have all slots claimed
			// Release the old one before recognizing the new one
			Cover.Link.UnClaim( MyGearPawn, SlotIdx, FALSE );
		}
	}
}

simulated function bool NotifyCoverClaimViolation( Controller NewClaim, CoverLink Link, int SlotIdx )
{
	local GearPC PC;
	//debug
	`AILog( GetFuncName()@NewClaim@Link@SlotIdx@`showvar(MoveAction)@`showvar(GetTetherActor()) );

	if( NewClaim == self )
	{
		return TRUE;
	}

	PC = GearPC(NewClaim);

	if(  PC != none && MoveAction != none && MoveAction != none && MoveAction.MoveTargets[0] == Link )
	{
		VacateCoverForPlayer(PC);
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
	// Otherwise, moving through this slot... give chance to recompute path
	else if (CachedAICommandList != None)
	{
		return CachedAICommandList.NotifyCoverClaimViolation( NewClaim, Link, SlotIdx );
	}

	return FALSE;
}

simulated event NotifyCoverAdjusted()
{
	if( MyGearPawn != None)
	{
		MyGearPawn.SetCurrentCoverType();
	}
}

simulated function NotifyCoverDisabled( CoverLink Link, int SlotIdx, optional bool bAdjacentIdx )
{
	`AILog(GetFuncname()@Link@SlotIdx@bAdjacentIdx@PrintTetherInfo()@MoveAction@((MoveAction != None) ? string(MoveAction.TetherDistance) : "0"));
	if( !bAdjacentIdx )
	{
		// Disabled for Heavy Weapons, as we don't have animations for those.
		if( MyGearPawn.MyGearWeapon == None || MyGearPawn.MyGearWeapon.WeaponType != WT_Heavy )
		{
			// Cover destroyed special move
			MyGearPawn.ServerDoSpecialMove(GSM_CoverDestroyed, TRUE);
		}

		InvalidateCover();

		if(MoveAction != none && MoveAction.TetherDistance == 0)
		{
			`AILog("Our cover was disabled, but we have a 0 tether.. go back to tether!");
			OnAIMove(MoveAction);
		}
		else
		{
			 `AILog("tried to run back to tether"@PrintTetherInfo()@"but claim failed.. removing tether actor!");
			 ClearTether();
		}
	}
}

function MoveToNearestCoverIdle()
{
	local CoverInfo CovToLeader;

	bReachedMoveGoal = false;
	bReachedCover = false;

	//debug
	`AILog(GetFuncName() @ Squad);

	if (Squad != None)
	{
		TetherDistance = 512.0;
		if (EvaluateCover(SearchType_Near, Pawn, CovToLeader,,, AtCover_Squad, TetherDistance, GetSquadPosition()))
		{
			SetCoverGoal(CovToLeader);
			return;
		}
	}

	//debug
	`AILog("Fallback looking for cover near current location");

	if (EvaluateCover(SearchType_Near, Pawn, CovToLeader,,, AtCover_Squad))
	{
		SetCoverGoal(CovToLeader);
		return;
	}

	//debug
	`AILog("Failed to find idle cover");
}

final function MoveToNearestCoverEnemy()
{
	local CoverInfo			CovToEnemy;
	local bool				bTowardsGoal;
	local float				NearEnemyDist;

	// we can't use cover if we have a shield
	if (MyGearPawn != None && (MyGearPawn.IsAKidnapper() || MyGearPawn.IsCarryingShield() || GearWeap_HeavyCoopMGBase(MyGearPawn.Weapon) != None))
	{
		`AILog(GetFuncName() @ "ignored because I have a shield");
		return;
	}

	//debug
	`AILog(GetFuncName()@Pawn.Anchor);

	NearEnemyDist = GetNearEnemyDistance(Pawn.Location);
	// search for cover either towards/away based on closest enemy distance
	bTowardsGoal = SearchForCoverTowardsEnemy( NearEnemyDist );
	`AILog("Searching"@(bTowardsGoal?"towards":"away from")@"enemy first");
	if (EvaluateCover(bTowardsGoal ? SearchType_Towards : SearchType_Away,Enemy,CovToEnemy))
	{
		`AILog("Found cover towards/away enemy:"@CovToEnemy.Link@CovToEnemy.SlotIdx);
		SetCoverGoal( CovToEnemy, TRUE );
		return;
	}
	else
	// try the opposite if the enemy is close enough
	if (!HasValidCover() &&
		NearEnemyDist < EnemyDistance_Long &&
		EvaluateCover(bTowardsGoal ? SearchType_Away : SearchType_Towards,Enemy,CovToEnemy))
	{
		`AILog("Found fallback cover towards/away enemy:"@CovToEnemy.Link@CovToEnemy.SlotIdx);
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
				`AILog("Failed to find cover, using existing");
				SetCoverGoal(Cover);
				return;
			}
			else
			{
				`AILog("Failed to find new cover, keeping existing");
			}
		}
		else
		{
			`AILog("Failed to find cover, don't have valid or it's exposed - dunno what to do, halp!");
			HandleFailedPathFind(none);
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
			`AILog("Firing in passive because of enemy within distance?"@HasEnemyWithinDistance(EnemyDistance_Short)@"or exposed?"@IsCoverExposedToAnEnemy(Cover));
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
	`AILog(GetFuncName()@NewMood@"old:"@CombatMood);

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
			!MyGearPawn.IsDBNO() &&
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
		DoEvade( GetBestEvadeDir( MyGearPawn.Location, Pawn(Damager) ), TRUE );
	}
}

/**
 * Handler for the Use Siegebeast kismet action
 *
 * @param Action - the Use Siegebeast kismet action
 */
final function OnAIUseSiegebeast(SeqAct_AIUseSiegebeast Action)
{
	CurrentSiegebeast = Action.Siegebeast;
	CurrentSiegebeastSeat = Action.SeatIndex;

	if( CurrentSiegebeastSeat != 0 )
	{
		BeginCombatCommand(class'AICmd_Base_SiegebeastCharge', "Use siegebeast"@`showvar(CurrentSiegebeastSeat), TRUE);
	}
	else
	{
		BeginCombatCommand(class'AICmd_Base_SiegebeastGunner', "Use siegebeast"@`showvar(CurrentSiegebeastSeat), TRUE);
	}
}

/**
 * Start the grappling special move
 *
 * @param Action - the kismet action that called this function
 */
function OnAIGrappleDynamic(SeqAct_AIGrappleDynamic Action)
{
	if (Action.InputLinks[0].bHasImpulse)
	{
		if (Gear_GrappleHookMarker(Action.GrappleTargets[0]) != None)
		{
			if (!MyGearPawn.CanUseGrapplingHook())
			{
				`Warn(Pawn @ "tried to grapple to" @ Action.GrappleTargets[0] @ "but doesn't support Grappling!!");
				return;
			}

			MyGearPawn.CurrentGrapplingMarker = Gear_GrappleHookMarker(Action.GrappleTargets[0]);

			if (Action.GrappleStartTargets.Length > 0)
			{
				MyGearPawn.CurrentGrapplingStartPoint = Action.GrappleStartTargets[0].Location;

				BeginCombatCommand(class'AICmd_Base_DynamicGrapple', "Walk over to dynamic grapple", TRUE);
			}
			else
			{
				// @hack: allow previous setups that had an "AI move to" still work
				MyGearPawn.ServerDoSpecialMove(SM_GrapplingHook_DynamicClimb, TRUE);
			}
		}
	}
}

/**
 * Walk to the rappel point using an ai command
 *
 * @param Action - the kismet action that started the rappel
 */
function OnAIRappel(SeqAct_AIRappel Action)
{
	`AILog(GetFUncName()@Action@`showvar(Action.StartingPosition.Length));
	if (Action.InputLinks[0].bHasImpulse && Gear_GrappleHookMarker(Action.RappelStart[0]) != None)
	{
		MyGearPawn.CurrentGrapplingMarker = Gear_GrappleHookMarker(Action.RappelStart[0]);

		if (Action.StartingPosition.Length > 0)
		{
			MyGearPawn.CurrentGrapplingStartPoint = Action.StartingPosition[0].Location;
			`AILog("Beginning AICmd_Base_Rappel");
			BeginCombatCommand(class'AICmd_Base_Rappel', "Walk over to rappel point", TRUE);
		}
		else
		{
			// @hack: allow previous setups that had an "AI move to" still work
			MyGearPawn.ServerDoSpecialMove(SM_Rappel, TRUE);
		}
	}
}

/////////////////////////////////////////////////
//////////////// TURRET FUNCTIONS ///////////////
/////////////////////////////////////////////////

/**
 * Handler for scripted use of turrets.  Push into turret state.
 */
final function OnAIUseTurret( SeqAct_AIUseTurret Action )
{
	local AIReactCond_CanReturnToTroika ReturnReact;

	ScriptedTurret=Action.Turret;
	`AILog(GetFuncName()@Action@Action.Turret@ScriptedTurret@self);

	if( !UseTurret( Action.Turret, Action.bIgnoreFlank, Action.bTeleportToTurret ) )
	{
		bIgnoreFlank	= default.bIgnoreFlank;
		DefaultCommand	= default.DefaultCommand;
		ReturnReact = AIReactCond_CanReturnToTroika(ReactionManager.FindReactionByType(class'AIReactCond_CanReturnToTroika',true));
		if(ReturnReact != none)
		{
			ReturnReact.UnsubscribeAll();
		}
		ReturnReact=none;
	}
}

final event bool UseTurret( Turret inTurret, bool inbIgnoreFlank, optional bool inbTeleportToTurret )
{
	local GearPawn OldPawn;

	OldPawn = MyGearPawn;
	if( inTurret != None &&
		inTurret.ClaimTurret( self ) && 
		!class'AICmd_Base_TroikaGunner'.static.ShouldGiveTurretToAlly( self, FALSE ) )
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
		}

		BeginCombatCommand( class'AICmd_Base_TroikaGunner', "Put on turret", inbTeleportToTurret );
		return TRUE;
	}
	return FALSE;
}

final function StopUsingTurret(GearTurret Turr)
{
	local AIReactCond_CanReturnToTroika ReactCond;

	`AILog(GetFuncName()@Turr);
	ScriptedTurret=none;

	// abort turret ai
	AbortCommand(none,class'AICmd_Base_TroikaGunner');

	// if we're being told to stop using a turret entirely, kill the re-engage reaction
	ReactCond = AIReactCond_CanReturnToTroika(ReactionManager.FindReactionByType(class'AIReactCond_CanReturnToTroika', false));
	if(ReactCond != none)
	{
		ReactCond.UnsubscribeAll();
	}
}

final function bool CanTurretFireAt(Actor TestActor, optional Turret TestTurret, optional bool bSkipCoverCheck)
{
	local GearPawn TargetWP;

	if (TestTurret == None)
	{
		TestTurret = CurrentTurret;
	}

	if (TestTurret != None && TestActor != None)
	{
		// check to see if it's a target protected by cover
		TargetWP = GearPawn(TestActor);
		if ( !bSkipCoverCheck && TargetWP != None &&
			TargetWP.IsProtectedByCover(Normal(TargetWP.Location - TestTurret.GetPhysicalFireStartLoc(vect(0,0,0))), true) )
		{
			return FALSE;
		}

		// check to see if the target is outside our rotation clamps
		if (!GearTurret(TestTurret).IsWithinRotationClamps(TestActor.Location))
		{
			return FALSE;
		}

		// check to see if we have los
		return ( CanFireAt(TestActor, TestTurret.GetPhysicalFireStartLoc(vect(0,25,0))) ||
				 CanFireAt(TestActor, TestTurret.GetPhysicalFireStartLoc(vect(0,-25,0))) );
	}

	return FALSE;
}

final function TargetInsideFireArc()
{
	//debug
	`AILog(GetFuncName());

	if (AllowedToMove())
	{
		BeginMeleeCommand(Enemy, "Enemy too close to turret");
	}
}

final function NotifyTurretRotationClamped()
{
	//debug
	`AILog(GetFuncName() @ CommandList);
	ReactionManager.NudgeChannel(None, 'TurretRotationClamped');

}

/** called when we're in a turret, but not doing anything because there are no valid targets */
function TurretIdle(int IdleTime)
{
	CurrentTurret.AIIdleNotification(self);
}


/////////////////////////////////////////////////
//////////////// SILVERBACK FUNCTIONS ///////////////
/////////////////////////////////////////////////

/**
 * Handler for scripted use of Silverbacks.  Push into Silverback state.
 */
function OnAIUseSilverback(SeqAct_AIUseSilverback Action)
{
	`AILog(GetFuncName()@Action@Action.Silverback);
	if( Action.InputLinks[0].bHasImpulse )
	{
		if( !UseSilverback( Action.Silverback, Action.bTeleportToSilverback ) )
		{
			DefaultCommand = default.DefaultCommand;
		}
	}
	else if( Action.InputLinks[1].bHasImpulse )
	{
		StopUsingSilverback(Action.Silverback);
	}
}

final function bool UseSilverback(GearPawn_SilverbackBase InSilverback, optional bool bTeleportToSilverback )
{
	if( InSilverback != None )
	{
		CurrentSilverback = InSilverback;
		if( bTeleportToSilverback )
		{
			Pawn.SetLocation(InSilverback.GetEntryPoint());
			Pawn.SetRotation(InSilverback.Rotation);
		}
		if( InSilverback.IsA('GearPawn_SilverbackLoaderBase') )
		{
			BeginCombatCommand(class'AICmd_Base_SilverbackLoader', "Put on Silverback", bTeleportToSilverback);
		}
		else
		{
			BeginCombatCommand(class'AICmd_Base_Silverback', "Put on Silverback", bTeleportToSilverback);
		}
		return TRUE;
	}
	return FALSE;
}

final function StopUsingSilverback(GearPawn_SilverbackBase InSilverback)
{
	InSilverback.DriverLeave(false);
	DefaultCommand = default.DefaultCommand;
	AbortCombatCommands();
	BeginCombatCommand(DefaultCommand, "Left Silverback", true);
}

/**
 * Handler for Silverback Loaders picking up and dropping crates
 */
function OnAISilverbackGetCrate(SeqAct_AISilverbackGetCrate Action)
{
	`AILog(GetFuncName()@Action@"Crate:"@Action.Crate);
	if( Pawn.IsA('GearPawn_SilverbackLoaderBase') )
	{
		SilverbackCrateAction = Action;
		if( Action.InputLinks[0].bHasImpulse )
		{
			Action.bShouldDropCrate = false;
			AbortMovementCommands();
			SetFocalPoint(Action.Crate.Location);
			SetMoveGoal(Action.Crate, Action.Crate, false,,,,false);
		}
		else if( Action.InputLinks[1].bHasImpulse )
		{
			Action.bShouldDropCrate = true;
			AbortMovementCommands();
			SetFocalPoint(Action.DropLocation.Location);
			SetMoveGoal(Action.DropLocation, Action.DropLocation, false,,,,false);
		}
	}
}

/////////////////////////////////////////////////
//////////////// DEBUG FUNCTIONS ////////////////
/////////////////////////////////////////////////

simulated function DrawDebug( GearHUD_Base HUD, name Category, optional bool bSpecificDebug )
{
	local int i;
	local int j;

	Super.DrawDebug( HUD, Category, bSpecificDebug );

	if( bDrawAIDebug )
	{
		if(Category == 'Default')
		{
			if( HasValidCover() )
			{
				// PINK
				DrawDebugLine( Pawn.Location, Cover.Link.GetSlotLocation(Cover.SlotIdx) + vect(0,0,15), 255, 128, 255 );
			}

			if( MyGearPawn != None )
			{
				if( MyGearPawn.IsInCover() )
				{
					// TEAL
					DrawDebugLine( MyGearPawn.Location, MyGearPawn.CurrentLink.GetSlotLocation(MyGearPawn.CurrentSlotIdx) - vect(0,0,15), 0, 255, 255 );
				}
			}
			if( CurrentTurret != None )
			{
				DrawDebugLine(CurrentTurret.GetPhysicalFireStartLoc( vect(0,0,0) ) + vector(CurrentTurret.AimDir) * 16384, CurrentTurret.GetPhysicalFireStartLoc( vect(0,0,0) ), 255, 128, 0);
			}
		}

		if(Category == 'allowedcoverlinks')
		{
			for(i=0;i<AllowedCoverLinks.length;i++)
			{
				DrawDebugLine(MyGearPawn.Location,AllowedCoverLinks[i].Location,255,255,0);
				for(j=0;j<AllowedCoverLinks[i].Slots.length;j++)
				{
					DrawDebugLine(AllowedCoverLinks[i].Location,AllowedCoverLinks[i].GetSlotLocation(j),255,255,0);
					DrawDebugCoordinateSystem(AllowedCoverLinks[i].GetSlotLocation(j),AllowedCoverLinks[i].GetSlotRotation(j),50.f);
				}
			}
		}

		if(Category == 'cover' && MyGearPawn.CurrentLink != none && MyGearPawn.CurrentSlotIdx != -1)
		{
			DrawDebugLine(MyGearPawn.Location,MyGearPawn.CurrentLink.GetSlotLocation(MyGearPawn.CurrentSlotIdx),255,255,0);
			DrawDebugCoordinateSystem(MyGearPawn.CurrentLink.GetSlotLocation(MyGearPawn.CurrentSlotIdx),MyGearPawn.CurrentLink.GetSlotRotation(MyGearPawn.CurrentSlotIdx),10.f);
			//MessagePlayer("Left:"@MyGearPawn.LeftSlotIdx@"Cur:"@MyGearPawn.CurrentSlotIdx@"Right:"@MyGearPawn.RightSlotIdx@"Pct:"@MyGearPawn.CurrentSlotPct);
		}
	}

}

simulated function DrawIconOverhead(GearHUD_Base HUD, Texture2D Icon)
{
	local Canvas	Canvas;
	local String	Str;

	Super.DrawIconOverhead( HUD, Icon );

	Canvas = HUD.Canvas;

	if( MyGearPawn != None )
	{
		if( HasValidCover() )
		{
			Canvas.SetDrawColor(255, 128, 255);
			Str = "("$GetRightMost(Cover.Link)$"/"$Cover.SlotIdx$")";
			Canvas.DrawText( Str, TRUE );
		}

		if( MyGearPawn.IsInCover() )
		{
			Canvas.SetDrawColor(0,255,255);
			Str = "("$GetRightMost(MyGearPawn.CurrentLink)$"/"$MyGearPawn.CurrentSlotIdx$")";
			Canvas.DrawText( Str, TRUE );
		}
	}
	Canvas.SetDrawColor(255,255,255);
}

function OnAIConsiderPickups(SeqAct_AIConsiderPickups Action)
{
	local class<GearWeapon> ItemClass;
	local int Index;

	if (Action.InputLinks[0].bHasImpulse)
	{
		// add to list
		foreach Action.ConsiderList(ItemClass)
		{
			//@note: we allow duplicates so that executing the "Start" and then "Stop" in sequence will always
			//	return the list to the exact state it was in prior to the action being used
			SPItemsToConsider.AddItem(ItemClass);
		}
	}
	if (Action.InputLinks[1].bHasImpulse)
	{
		// remove from list
		foreach Action.ConsiderList(ItemClass)
		{
			Index = SPItemsToConsider.Find(ItemClass);
			if (Index != INDEX_NONE)
			{
				SPItemsToConsider.Remove(Index, 1);
			}
		}
	}
}

function BanzaiAttack()
{
	if(MyGearPawn != none && (MyGearPawn.bCanBeForcedToRoadieRun || MyGearPawn.bCanRoadieRun))
	{
		MyGearPawn.bCanRoadieRun=true;
	}

	Super.BanzaiAttack();
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
	Super.CreateCheckpointRecord(Record);

	Record.DrivenTurretPathName = PathName(CurrentTurret);
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
	local Turret FoundTurret;

	Super.ApplyCheckpointRecord(Record);

	if (MyGearPawn != None && Record.DrivenTurretPathName != "")
	{
		FoundTurret = Turret(FindObject(Record.DrivenTurretPathName, class'Turret'));
		if (FoundTurret != None)
		{
			UseTurret(FoundTurret, true, false);
		}
	}
}

function AddBasePathConstraints(bool bIsCoverSearch)
{
	Super.AddBasePathConstraints(bIsCoverSearch);
	class'NavMeshPath_AvoidMantles'.static.AvoidMantlesWhenOutOfCombat(NavigationHandle,self);
}

/**
 *  called when this AI is in the way of a cover slot the player is trying to enter
 *  @param Player - the player that we are currently blocking
 */
function VacateCoverForPlayer(GearPC Player)
{
	// if we're tethered to the cover we just got booted from, we need to find another cover slot nearby
	if (IsAtCover() && IsWithinTether(Pawn.Location) && MoveAction != none && MoveAction.DestinationSlotIndex > -1)
	{
		// then treat this like an 'any slot in link' situation
		`AILog("Vacating cover for"@Player@" but I'm tethered to this slot.. so I will now use any slot on"@Cover.Link@"instead!");
		Cover.Link.SetInvalidUntil(MoveAction.DestinationSlotIndex,WorldInfo.TimeSeconds+0.75);
		MoveAction.DestinationSlotIndex=-1;
		MoveACtion.TetherDistance=0;
		OnAIMove(MoveAction);
	}
	else
	{
		`AILog("Vacating cover for player, but I'm not at cover yet");
		InvalidateCover(,true);
		AbortMovementCommands();
		StepAsideFor(Player.Pawn);
		if (MoveAction != None)
		{
			MoveAction.DestinationSlotIndex = -1;
			MoveACtion.TetherDistance = 0;
			OnAIMove(MoveAction);
		}
	}
}


defaultproperties
{
	DefaultCommand=class'AICmd_Base_CoverAI'

	DefaultReactConditionClasses.Add(class'AIReactCond_DmgLeaveCover')

	Begin Object Class=AIReactCond_StoppingPowerThreshold Name=StoppingPowerTemplate
	End Object
	StoppingPowerReactionTemplate=StoppingPowerTemplate

	// defaultcover goal evaluation profiles
	// ---->Enemies constraint
	Begin Object Class=CovGoal_Enemies Name=CovGoal_Enemies0
	End Object
	// ---->Enemies too close
	Begin object Class=CovGoal_EnemyProximity Name=CovGoal_EnemyProx0
	End object
	// ---->Weapon range constraint
	Begin object Class=CovGoal_WithinWeaponRange Name=CovGoal_WeaponRange0
	End Object
	// ---->Movement distance
	Begin Object Class=CovGoal_MovementDistance Name=CovGoal_MovDist0
		BestCoverDist=768.0f
		MinCoverDist=256.0f
		MaxCoverDist=1024.0f
	End object
	// ---->Squad leader proximity
	Begin Object Class=CovGoal_SquadLeaderProximity name=CovGoal_SquadLeadProx0
	End Object
	// ---->Teammate Proximity
	Begin Object Class=CovGoal_TeammateProximity name=CovGoal_TeammateProx0
	End Object
	// ---->within combat zones
	Begin Object Class=CovGoal_WithinCombatZones name=CovGoal_WithinCombatZones0
	End Object

	// ** TOWARDS
	Begin Object Class=NavMeshGoal_AtCover name=AtCov_Towards0
		CoverGoalConstraints.Add(CovGoal_Enemies0)
		CoverGoalConstraints.Add(CovGoal_EnemyProx0)
		CoverGoalConstraints.Add(CovGoal_WeaponRange0)
		CoverGoalConstraints.Add(CovGoal_MovDist0)
		CoverGoalConstraints.Add(CovGoal_SquadLeadProx0)
		CoverGoalConstraints.Add(CovGoal_TeammateProx0)
		CoverGoalConstraints.Add(CovGoal_WithinCombatZones0)
	End object
	AtCover_Toward=AtCov_Towards0

	// ** AWAY
	// ---->Goal proximity constraint
	Begin object Class=CovGoal_GoalProximity Name=CovGoal_Proximity1
		BestGoalDist=1024.0f
		MinGoalDist=400.0f
		MaxGoalDist=2048.0f
	End Object
	Begin Object Class=NavMeshGoal_AtCover name=AtCov_Away0
		CoverGoalConstraints.Add(CovGoal_Enemies0)
		CoverGoalConstraints.Add(CovGoal_EnemyProx0)
		CoverGoalConstraints.Add(CovGoal_Proximity1)
		CoverGoalConstraints.Add(CovGoal_MovDist0)
		CoverGoalConstraints.Add(CovGoal_SquadLeadProx0)
		CoverGoalConstraints.Add(CovGoal_TeammateProx0)
		CoverGoalConstraints.Add(CovGoal_WithinCombatZones0)
	End object
	AtCover_Away=AtCov_Away0

	// ** NEAR
	// ---->Goal proximity constraint
	Begin Object Class=CovGoal_GoalProximity Name=CovGoal_Proximity2
		BestGoalDist=256.0f
		MinGoalDist=16.0f
		MaxGoalDist=768.0f
	End Object
	Begin Object Class=NavMeshGoal_AtCover Name=AtCov_Near0
		CoverGoalConstraints.Add(CovGoal_Enemies0)
		CoverGoalConstraints.Add(CovGoal_EnemyProx0)
		CoverGoalConstraints.Add(CovGoal_Proximity2)
		CoverGoalConstraints.Add(CovGoal_MovDist0)
		CoverGoalConstraints.Add(CovGoal_SquadLeadProx0)
		CoverGoalConstraints.Add(CovGoal_TeammateProx0)
		CoverGoalConstraints.Add(CovGoal_WithinCombatZones0)
	End Object
	AtCover_Near=AtCov_Near0

	Begin object Class=CovGoal_GoalProximity Name=CovGoal_Proximity3
		BestGoalDist=0.f
		MinGoalDist=0.f
		MaxGoalDist=512.f
		bHardLimits=TRUE
	End Object

	Begin Object Class=NavMeshGoal_AtCover Name=AtCov_Squad0
		CoverGoalConstraints.Add(CovGoal_Enemies0)
		CoverGoalConstraints.Add(CovGoal_SquadLeadProx0)
		CoverGoalConstraints.Add(CovGoal_TeammateProx0)
		CoverGoalConstraints.Add(CovGoal_Proximity3)
	End Object
	AtCover_Squad=AtCov_Squad0

	Begin Object Class=CovGoal_ProtectedByLocation Name=CovGoal_ProtectedByLocation0
		bOnlySlotsWithFireLinks=TRUE
	End Object

	Begin Object Class=CovGoal_GoalProximity Name=CovGoal_Proximity4
		BestGoalDist=256.0f
		MinGoalDist=16.0f
		MaxGoalDist=768.0f
	End Object

	Begin Object Class=NavMeshGoal_AtCover Name=AtCov_Ambush0
		CoverGoalConstraints.Add(CovGoal_ProtectedByLocation0)
		CoverGoalConstraints.Add(CovGoal_Proximity4)
		CoverGoalConstraints.Add(CovGoal_TeammateProx0)
		CoverGoalConstraints.Add(CovGoal_SquadLeadProx0)
		CoverGoalConstraints.Add(CovGoal_WithinCombatZones0)
	End Object
	AtCover_Ambush=AtCov_Ambush0

	Begin Object Class=CovGoal_MovementDistance Name=CovGoal_MovDist1
		BestCoverDist=384.0f
		MinCoverDist=256.0f
		MaxCoverDist=512.0f
		bMoveTowardGoal=TRUE
		MinDistTowardGoal=256.f
	End object

	Begin Object Class=CovGoal_ProtectedByLocation Name=CovGoal_ProtectedByLocation1
		bForceMoveTowardGoal=TRUE
		bOnlySlotsWithFireLinks=TRUE
	End Object

	Begin Object Class=NavMeshGoal_AtCover Name=AtCover_AlongPath0
		CoverGoalConstraints.Add(CovGoal_ProtectedByLocation1)
		CoverGoalConstraints.Add(CovGoal_MovDist1)
	End Object
	AtCover_AlongPath=AtCover_AlongPath0

	MaxPathLaneValue=4.f
	ExtraPathCost=60
}
