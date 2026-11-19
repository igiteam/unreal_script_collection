/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAI extends NanoAIBase
	implements( NanoInterface_ActiveAttacker )
	native(AI)
	config(AI)
	abstract;



var bool bClampRotation;
var transient rotator ClampedBaseRotation;
var transient rotator ClampedRotationLimits;


var transient int LastMantleIdx;


//// DEFENSE POINTS
// need to refactor these / into the NanoDefensivePoint
var() config float MaxDistanceFromDefensePoint;
var transient array<Actor> DefensePoints;
var transient Actor CurrentDefensePoint;


var transient bool bInFormation;
var transient bool bPhalanxLeader;
var transient NanoFormation Formation;
var transient int FormationPosition;
var transient vector RVOVelocity;

struct native DistSortInfo
{
	var Actor Actor;
	var float Distance;
};


var transient float LastTimeNoticedAlertStimuli;
var actor Alert_PendingFocus;
var vector Alert_PendingFocalPoint;




//Idle
var(Query) StimulusQuery IdleQuery;

// Defensive
var(Query) StimulusQuery DefensiveQuery;

// ConfrontPossibleThreat
var(Query) StimulusQuery ConfrontPossibleThreatQuery;
var(Query) StimulusQuery ConfrontPossibleThreatQuery_Rooftop;

// EngageThreat
var(Query) StimulusQuery MeleeEngageThreatQuery;
var(Query) StimulusQuery RangedEngageThreatQuery;

// Local
var(Query) StimulusQuery LocalThreatQuery;
var(Query) StimulusQuery LocalBackupQuery;

/** This is the what possible caused this AI to spawn **/
var transient NanoProceduralMissionPartBase MissionPart;

/** If this is set, then this will be used instead of the WaitingToAttackAnimList **/
var transient Name OverrideAnimNameToPlay;



var(Query) StimulusQuery StandardPickFireTargetQuery;

/** This query is meant to allow the AI to just be completely aggressive.**/
var(Query) StimulusQuery FindThemAndDestroyThemQuery;


var config float MinInaccuracy;
var config float MaxInaccuracy;

/** These control how much we scale the Inaccuracy when the AI's Pawn is moving **/
var config float MovingMinInaccuracyModifer_Self;
var config float MovingMaxInaccuracyModifer_Self;

/** These control how much we scale the Inaccuracy when the FireTarget is moving **/
var config float MovingMinInaccuracyModifer_FireTarget;
var config float MovingMaxInaccuracyModifer_FireTarget;


/** How much of the target's velocity to use as a a "lead" of the AI's AimLoc **/
var config float LeadTargetPercentOfVelocity;

/** This is how often we should check to see if we get an bonus **/
var config float TattlerAccuracyBonus_CheckTimePeriod;
var transient float TattlerAccuracyBonus_LastCheckTime;

/** For each tattler around us this is the accuracy improvement we receive **/
var config float TattlerAccuracyBonus_AccuracyImprovement;
/** How close the tattlers need to be to get the bonus **/
var config float TattlerAccuracyBonus_Radius;

/** Welcome to the bool cloud.  Usually we want to replace / update the AIActions on an NDP.  If this is false then we have some special guy that we don't want to do that with. **/
var bool bReplaceMyAIActionsFromDefensivePoint;


cpptext
{
	virtual void UpdatePawnRotation();

	// Interface_NavigationHandle overrides
	virtual void SetupPathfindingParams( FNavMeshPathParams& out_ParamCache );
}



event UnPossess()
{
	UnregisterAsAttacker();
	UnregisterAsActiveAttacker();

	Super.UnPossess();
}



//// MISC HELPER FUNCTIONS

final function int SmallestDistanceSort(DistSortInfo A, DistSortInfo B)
{
	return (A.Distance > B.Distance ? -1 : 0);
}



//// DEFENSE POINTS  (these should move to a AICMD )

final function LookForNearbyDefensePoints(optional float MaxDistance = 2048.f)
{
	local NanoDefensivePoint Pt;
	if (MaxDistance <= 0.f)
	{
		MaxDistance = 2048.f;
	}
	foreach AllActors(class'NanoDefensivePoint',Pt)
	{
		if (VSize(Pt.Location - Pawn.Location) <= MaxDistance)
		{
			`AILog(`location@`showvar(Pt));
			DefensePoints.AddItem(Pt);
		}
	}
}

function OnAIAssignDefensePoint(SeqAct_AIAssignDefensePoint Action)
{
	local Actor A;
	DefensePoints.Length = 0;
	foreach Action.DefensePoints(A)
	{
		`AILog(`location@A);
		DefensePoints.AddItem(A);
	}
}



final function bool PickDefensePoint(optional Actor Tether)
{
	if (Tether == None)
	{
		// assume we are the tether if none specified
		Tether = Pawn;
	}
	else
	{
		// tether isn't our pawn and we have a defense point that is valid
		if (CurrentDefensePoint != None && VSize(CurrentDefensePoint.Location - Tether.Location) < MaxDistanceFromDefensePoint)
		{
			// don't pick a new one
			return TRUE;
		}
	}
	// pick the closest point to the tether
	CurrentDefensePoint = GetClosestDefensePoint(Tether);
	return (CurrentDefensePoint != None && VSize(CurrentDefensePoint.Location - Tether.Location) < MaxDistanceFromDefensePoint);
}


final function Actor GetClosestDefensePoint(optional Actor Tether)
{
	local array<DistSortInfo> SortedPts;
	local int Idx, SortedIdx;
	local NanoGame NG;
	if (DefensePoints.Length > 0)
	{
		NG = NanoGame(WorldInfo.Game);
		if (Tether == None)
		{
			Tether = Pawn;
		}
		for (Idx = 0; Idx < DefensePoints.Length; Idx++)
		{
			if (NG.ClaimPoint(DefensePoints[Idx],self))
			{
				SortedIdx = SortedPts.Add(1);
				SortedPts[SortedIdx].Actor = DefensePoints[Idx];
				SortedPts[SortedIdx].Distance = VSize(DefensePoints[Idx].Location - Tether.Location);
			}
		}
		return SortedPts.Sort(SmallestDistanceSort).Actor;
	}
	return None;
}

function bool WillGiveUpClaim(Actor Point, NanoAIBase Claimer)
{
	return Pawn == None || Pawn.Health == 0 || Point != CurrentDefensePoint;
}





//// KISMET handlers

function OnAIStateTransition(SeqAct_AIStateTransition Action);

function OnAIMoveToActor(SeqAct_AIMoveToActor Action)
{
	class'NanoAICmd_Move'.static.KismetMoveTo(self,Action);
}

function OnMoveAlongRoute(SeqAct_MoveAlongRoute Action)
{
	class'NanoAICmd_MoveToRoute'.static.MoveUsingRouteAction(self,Action);
}




//// NOTIFIES

/** If an AI registers with an tesla coil it can receive a notification that the tesla was destroyed **/
function TeslaCoilWeCareAboutWasDestroyed( const TeslaCoil InTesla, Controller InstigatedBy );




//// MANTLES

native final function CheckForMantleEdge();

event HandleMantleEdge( int MantleIdx, vector MantleDir )
{
	local NanoPawn NP;

	NP = NanoPawn(Pawn);
	if( NP != None && MantleIdx >= 0 )
	{
		LastMantleIdx = MantleIdx;
		`AILog(`location@`showvar(MantleIdx));
		NP.Velocity = vect(0,0,0);
		NP.SetRotation(rotator(MantleDir));
		NP.MantleDir = MantleDir;
		NP.DoSpecialMove( NP.Mantles[MantleIdx] );
	}
}



event HandleJumpEdgeUp( vector StartLoc, vector DestLoc )
{
	local vector JumpUpVel;

	// we need to add some to the jump destination otherwise it is right at the "edge" of the rooftop
	// and the pawn will just run into the wall each time.  With it being pushed up some the pawn will either
	// land nicely or will hit the lip of the rootftop and then mantle climb up which looks pretty cool
	DestLoc += vect(0,0,256);

	//`log( "ohhh yes!  my guy is jumping!" @ `showvar(StartLoc) @ `showvar(DestLoc) );
//	DrawDebugCoordinateSystem(StartLoc,rot(0,0,0),25.f,TRUE);
//	DrawDebugStar(DestLoc,25.f,255,0,0,TRUE);
//	DrawDebugLine( StartLoc, DestLoc, 255, 0, 0, TRUE );

	//if( Pawn.SuggestJumpVelocity( JumpUpVel, DestLoc, StartLoc ) == TRUE ) // this is bounded by GroundSpeed and other things

	// use tricky "toss our self!" method
	// 5000 here seems to mostly work.  we will need to refine it
	if( Pawn.SuggestTossVelocity( JumpUpVel, DestLoc, Pawn.Location, 5000, Pawn.Velocity.Z, Pawn.GetGravityZ()*0.5f, ,, 1.0f, FALSE ) == TRUE )
	{
		//`log( "FOUND A JumpUpVel!!" );
	}
	else
	{
		//`log( "DIDN'T Find JumpUpVel!");
	}

	//`log( `showvar(JumpUpVel) );

	//HandleJumpEdge( JumpUpVel );

	Pawn.ZeroMovementVariables();
	Pawn.SetLocation( DestLoc );

}


event HandleJumpEdge( Vector JumpVel )
{
	local NanoPawn NP;
	local Rotator R;

	NP = NanoPawn(Pawn);
	if( NP != None )
	{
		NP.DoSpecialMove( 'NSM_AIJumpHolder' );
		NP.Velocity = JumpVel;
		R.Yaw = Rotator(JumpVel).Yaw;
		NP.SetRotation( R );
		NP.SetPhysics( PHYS_Falling );
	}
}


event StartLadderClimb(NanoLadderBase LadderToClimb, bool bClimbingUp)
{
	local NanoPawn NP;
	NP = NanoPawn(Pawn);
	if (NP != None)
	{
		NP.StartLadderClimb(LadderToClimb,bClimbingUp);
	}
}



event SpecialMoveRedirect(vector NewIntermediatePoint)
{
	local NanoAICmd_Move_Mesh Cmd;
	`AILog(`location@`showvar(CommandList));
	Cmd = FindCommandOfClass(class'NanoAICmd_Move_Mesh');
	if (Cmd != None)
	{
		Cmd.SpecialMoveRedirect(NewIntermediatePoint);
	}
}




//// STUNS

final function StunAI( optional float Duration, optional Name StunType, optional Name AnimName, optional bool bForceStopFire = TRUE )
{
	class'NanoAICmd_Stunned'.static.StunAI( self, Duration, StunType, AnimName,, bForceStopFire );
}

final function UnstunAI( optional Name StunType )
{
	class'NanoAICmd_Stunned'.static.UnstunAI( self, StunType );
}

final function bool IsStunnedBy( Name StunType )
{
	return class'NanoAICmd_Stunned'.static.IsStunnedBy( self, StunType );
}



//// MELEE SYSTEM

function bool AllowedToActivelyAttackTarget();
function bool NotifyActiveAttackAvailable(NanoPawnBase AvailableTarget);
function int GetActiveAttackSlots()
{
	local NanoAIAction Action;

	Action = NanoAIAction(CommandList);
	if( Action != None )
	{
		return Action.GetActiveAttackSlots();
	}

	return 1;
}
function RegisterAsAttacker();
function UnregisterAsAttacker();
function RegisterAsActiveAttacker();
function UnregisterAsActiveAttacker();
function float RateAttacker( NanoPawnBase Targ, optional bool bSkipRandom );
function bool IsPushingForward();
event Actor GetAttackActor()
{
	return Pawn;
}

function EngageMeleeWith(NanoPawn InstigatedBy);
function EndMelee();
function bool CanBlockAttack(NanoPawn InstigatedBy, EDirection AttackDirection, Name AttackAnimName, out float out_ChanceBreakComboOnBlock );
function BlockIncomingAttack( optional bool bComboBreaker );


function NotifyShieldDropped();


function PrepareForFlight();
function PrepareForLanding();

/** 
 *  So the idea here is if you concentrate fire on a single enemy for an amount of time he will consider himself "being focus fired".
 *  When that happens his friends will rush to his aid!! (right now they switch to Melee boid rules which bring the ai close to you )
 *  
 **/
function bool IsBeingFocusFired();

/**
 * Allows the AI to suggest the toss velocity for a grenade
 *
 * @param Tesla - The grenade weapon itself that is being tossed
 * @param TossVelocity - The returned velocity calculated
 * @param Start - The starting location of the toss
 * @return Whether we were successful in finding a velocity to throw the grenade
 */
function bool SuggestTeslaTossVelocity( NanoWeap_Baton Tesla, out vector TossVelocity, vector Start, const float InGravityZ )
{
	return FALSE;
/*	
	local vector TargetLoc;

	`log( "FireTarget:" @ FireTarget. @ FireTarget..Location );
	if( FireTarget. != None )
	{
	    TargetLoc = FireTarget..Location;
        TargetLoc += Normal(Start - TargetLoc) * 256.f;
		TargetLoc.Z -= FireTarget..GetCollisionHeight();
	}

	return SuggestTossVelocity( TossVelocity, TargetLoc, Start, Tesla.TeslaVelRange.y, Tesla.Instigator.Velocity.Z, 0.45f, ,, InGravityZ, FALSE );
*/
}


/** This biases the firetarget by distance **/
function float RateStimulusForFireTarget(int Index)
{
	local float Rating;

	Rating = -1.f;

	if( NanoInterface_Targetable(Stimuli[Index].Actor) != None )
	{
		Rating = Stimuli[Index].Priority;
		Rating *= StandardPickFireTargetQuery.MaxDist/VSize2D(Stimuli[Index].Location - Pawn.Location);

		if (Stimuli[Index].bVisible)
		{
			Rating *= 2.0f;
		}
	}		

	`AILog(GetFuncName()@`showvar(Index)@`showvar(Rating));

	return Rating;
}


function bool PossiblyPickFireTarget()
{
	local Actor OldFT;

	OldFT = FireTarget;

	if (FireTarget == None || `TimeSince(TimeOfLastPickTarget) > 3.f)
	{
		PickFireTarget();
	}

	if( OldFT != FireTarget )
	{
		NotifyFireTargetChanged();
	}

	`AILog( GetFuncName() @ `showvar(FireTarget) );

	return FireTarget != None;
}


function Actor PickFireTarget()
{
	local array<int> StimulusIndices;
	local int Index, BestIndex;
	local float StimulusRating, BestStimulusRating;
	local NanoGRI NGRI;

	NGRI = NanoGRI(WorldInfo.GRI);
	MultipleResultStimulusQuery(StandardPickFireTargetQuery,StimulusIndices);
	BestIndex = -1;
	BestStimulusRating = -1.f;

	foreach StimulusIndices(Index)
	{
		StimulusRating = RateStimulusForFireTarget(Index);
		`AILog(GetFuncName()@Stimuli[Index].Actor@`showvar(StimulusRating));
		if( StimulusRating >= 0.f && (BestIndex == -1 || StimulusRating > BestStimulusRating) )
		{
			BestIndex = Index;
			BestStimulusRating = StimulusRating;
		}
	}

	if( StimulusIndices.Length == 0 )
	{
		`AILog( GetFuncName() @ "NO StimulusIndices!!" );
	}

	// we found someone within our StandardPrickFireTargetQuery
	if( BestIndex != -1 )
	{
		SetFireTarget( Stimuli[BestIndex].Actor );
	}
	else
	{
		SetFireTarget( None );  // if we don't set this to none when we don't have a "best" index then the AI probably will just stay with its current FireTarget.  Even if it is dead / should not really have one. 

		// so because our Defensive Points are so large now (WAY larger than 2700) AI that spawn on the opposite side
		// have no chance to ever "see" the Attacker.
		//
		// So here we are going to check for NDPs that are under attack and then see if the player is inside the Defend portion of it

		SetFireTarget( CheckForUnderAttackNDPsAndSeeIfWeAndThePlayerAreThere() );

		// if the FireTarget is still None (then we are not in an NDP)
		if( FireTarget == None )
		{
			// if there is a chaos event "active" then set the hotzone location as the last possible place
			if( NGRI.GetCurrentChaosLevel() > 0 )
			{
				// so we have chaos.
				// check to see if the player is within the hotzone
				if( NGRI.IsWithinHotZone( NGRI.GetNanoPC().Pawn.Location ) == TRUE )
				{
					SetFireTarget( NGRI.GetNanoPC().Pawn );
					`AILog( GetFuncName() @ "Player was inside Hotzone and chaose is up!  Setting FireTarget to Player" );
				}
				//else set them to the center
				else
				{
					SetFireTarget( NGRI.NPES.TheHotZoneCenter );
					`AILog( GetFuncName() @ "Setting FireTarget to TheHotZoneCenter" );
				}

				// so now check to see if the Retval is on our team.  If it is then don't actually choose it
				if( Pawn.IsSameTeam( Pawn(FireTarget) ) == TRUE )
				{
					`AILog( "Same Team!" @ `showvar(Pawn.GetTeamNum()) @ `showvar(Pawn(FireTarget).GetTeamNum()) );
					//`log( "Same Team!" @ `showvar(Pawn.GetTeamNum()) @ `showvar(Pawn(FireTarget).GetTeamNum()) );
					SetFireTarget( None );
				}

			}
		}
	}

	// needed???
	if( ( FireTarget != None ) && ( FireTarget.IsTargetable() == FALSE ) )
	{
		SetFireTarget( None );
	}


	return FireTarget;
}


function Actor CheckForUnderAttackNDPsAndSeeIfWeAndThePlayerAreThere()
{
	local Actor Retval;
	local NanoDefensivePoint NDP;


	foreach WorldInfo.AllActors(class'NanoDefensivePoint', NDP)
	{
		// if it is not under attack
		if( NDP.bUnderAttack == FALSE )
		{
			continue;
		}

		// if we are not inside the defend radius
		if( VSize(Pawn.Location - NDP.Location) > NDP.RadiusToDefend )
		{
			continue;
		}

		// if the player is not within the defend radius
		if( NDP.IsPlayerWithinUnderDefendRadius() == FALSE )
		{
			continue;
		}


		// we passed and have a valid NDP that is under attack and AI and the player are both inside the defend radius
		Retval = NanoGRI(WorldInfo.GRI).GetNanoPC().Pawn;

		// so now check to see if the Retval is on our team.  If it is then don't actually choose it
		if( Pawn.IsSameTeam( Pawn(Retval) ) == TRUE )
		{
			`AILog( "Same Team!!" @ `showvar(Pawn.GetTeamNum()) @ `showvar(Pawn(FireTarget).GetTeamNum()) );
			Retval = None;
			continue;
		}

		`AILog( GetFuncName() @ "Player and AI were both inside an UnderAttack NDP Setting FireTarget to Player" );
		break;
	}


	return Retval;
}


function NotifyFireTargetChanged();

function int GetFiremode()
{
	return 0;
}

function MoveToFormationPosition()
{
    `AILog(`location@`showvar(FormationPosition));
	MoveToLocation( Formation.GetPositionLocation(FormationPosition), 1.0f, TRUE );


	//class'NanoAICmd_Move_Mesh'.static.MoveToPoint(self,Formation.GetPositionLocation(FormationPosition),FALSE,TRUE, 2.0f );
}

function OpenFire()
{
	Pawn.StartFire(GetFireMode());
}

function SetFormationPosition(NanoFormation NewFormation, int NewPosition)
{
	`AILog(`location@`showvar(NewPosition)@`showvar(NewFormation));
	Formation = NewFormation;
	FormationPosition = NewPosition;
}


/** 
 * So in our start from scratch (again) we are making guys not attack you unless you hit them first.
 * So now if you were at a NanoDefensivePoint, we go ahead and remove the bRequireDamaged from this AI's Queries
 *
 **/
function SetAllQueriesbRequireDamaged( bool bNewVal )
{
	ConfrontPossibleThreatQuery.bRequireDamaged = bNewVal;
	ConfrontPossibleThreatQuery_Rooftop.bRequireDamaged = bNewVal;
	MeleeEngageThreatQuery.bRequireDamaged = bNewVal;
	RangedEngageThreatQuery.bRequireDamaged = bNewVal;
}


/** Used to check to see if the AI is actively pursuing a rebel! **/
function bool IsActivePursuingARebel()
{
	//`log( FindCommandOfClass( class'NanoAIAction_ConfrontPossibleThreatBase' ) @ FindCommandOfClass( class'NanoAIAction_EngageThreatBase' ) @ CommandList  );

	if( ( CommandList != None )
		//&& ( ClassIsChildOf( class'NanoAIAction_ConfrontPossibleThreatBase', CommandList.Class ) == TRUE )
		//&& ( ClassIsChildOf( class'NanoAIAction_EngageThreatBase', CommandList.Class ) == TRUE )
		&& ( ( FindCommandOfClass( class'NanoAIAction_ConfrontPossibleThreatBase' ) != None )
		|| ( FindCommandOfClass( class'NanoAIAction_EngageThreatBase' ) != None ) )
		)
	{
		return TRUE;
	}
	
	return FALSE;
}

function PickNewAction()
{
}

function bool ConsidersSelfOutNumbered()
{
	local int LocalThreats, LocalFriends;
	local array<int> ThreatStimulusIndices, FriendStimulusIndices;

	LocalThreats = MultipleResultStimulusQuery( LocalThreatQuery, ThreatStimulusIndices );
	LocalFriends = MultipleResultStimulusQuery( LocalBackupQuery, FriendStimulusIndices );

	if( LocalThreats > LocalFriends )
	{
		return TRUE;
	}
	return FALSE;
}


/** 
 *  This function will determine if the AI gets any extra help to help improve his accuracy 
 *  
 *  Currently, we will be giving an accuracy bonus if there are any Tattler bots near the target.
 *  
 **/
function float GetMaxInaccuracy()
{
	local float AdjustedMaxInaccuracy;
	local float AmountToImproveInaccuracyBy;
	local array<Vector> TattlerLocations;


	AdjustedMaxInaccuracy = MaxInaccuracy;

	if( `TimeSince(TattlerAccuracyBonus_LastCheckTime) > TattlerAccuracyBonus_CheckTimePeriod )
	{
		TattlerAccuracyBonus_LastCheckTime = WorldInfo.TimeSeconds;

        TattlerLocations = NanoGRI(WorldInfo.GRI).GetAllClassTypesAroundLocation( class'NanoPawn_MetaCorp_SentryBotBase', FireTarget.GetTargetedLocation(), TattlerAccuracyBonus_Radius );

		AmountToImproveInaccuracyBy = TattlerLocations.Length * TattlerAccuracyBonus_AccuracyImprovement;

		// here we are improving the INaccuracy so we we need to subtract our bonus from it to make it more accurate
        AdjustedMaxInaccuracy -= AmountToImproveInaccuracyBy;

		//`log( "GetMaxInaccuracy:" @ `showvar(AmountToImproveInaccuracyBy) @ `showvar(AdjustedMaxInaccuracy) );
	}

	// no matter how much of a bonus we get we can only be as accurate as our MinInaccuracy
	return Max( MinInaccuracy, AdjustedMaxInaccuracy );
}


/**
 *
 * @return if there was a bullet magnet near the firing start or target location
 **/
function bool GetPossibleBulletMagnetLocation( const out Vector TargetLocation, out vector out_BulletMagnetLocation )
{
	local BulletMagnet BulletMagnetActor;

	foreach CollidingActors( class'BulletMagnet', BulletMagnetActor, class'BulletMagnet'.default.RadiusToAttractBullets, TargetLocation )
	{
		//`log( "first" @ `showvar(BulletMagnetActor) );
		break;
	}

	// if we found one near where we are shooting use that location to shoot at
	if( BulletMagnetActor != None )
	{
		out_BulletMagnetLocation = BulletMagnetActor.Location;
		return TRUE;
	}


	// else check to see if there is one near where we are shooting from
	foreach CollidingActors( class'BulletMagnet', BulletMagnetActor, class'BulletMagnet'.default.RadiusToAttractBullets, Pawn.Location )
	{
		//`log( "second" @ `showvar(BulletMagnetActor) );
		break;
	}

	// if we found one near where we are shooting from use that location to shoot at
	if( BulletMagnetActor != None )
	{
		out_BulletMagnetLocation = BulletMagnetActor.Location;
		return TRUE;
	}



	return FALSE;

}






// Playable - Cop accuracy model.  Cops should have an accuracy model that ties into your acrobatic/combat moves.  
//  
// Effectively, if I keep standing still/fighting, I should get SHOT
// if i dodge around, I should avoid shots. Kapow!
//   
// Stuff that increases enemy accuracy: 
// -       player stands still 
// -       player performs a long combo 
// -       player walks 
// -       player SUSTAINS sprint (e.g. 5 secs uninterrupted) 
//   
// Stuff that decreases their accuracy 
// -       player jumps 
// -       player starts sprinting (first 3 secs) 
// -       player performs a mantle 
// -       player crunches a soldier underfoot 
// -       player ghosts/dashes 
// -       player diverolls 
// -       player falls






defaultproperties
{
	bReplaceMyAIActionsFromDefensivePoint=TRUE

	FormationPosition=INDEX_NONE

	IdleQuery=( QueryLabel="Idle",bAllowFriendly=FALSE,bAllowNonFriendly=TRUE,bRequireCombative=QO_Disallow,MinFOV=-1.f,MaxFOV=-1.f,MinDist=0.f,MaxDist=4096.f,DistanceAboveUsToIgnoreStimuli=1024 )

	ConfrontPossibleThreatQuery=( QueryLabel="ConfrontPossibleThreat",bAllowFriendly=FALSE,bAllowNonFriendly=TRUE,bRequireCombative=QO_Require,bRequireDamaged=FALSE,MinFOV=-1.f,MaxFOV=-1.f,MinDist=0.f,MaxDist=2700.0f,DistanceAboveUsToIgnoreStimuli=512,Visibility=QO_Require )

	ConfrontPossibleThreatQuery_Rooftop=( QueryLabel="ConfrontPossibleThreatQuery_Rooftop",bAllowFriendly=FALSE,bAllowNonFriendly=TRUE,bRequireCombative=QO_Allow,bRequireDamaged=FALSE,MinFOV=-1.f,MaxFOV=-1.f,MinDist=0.f,MaxDist=5048.f,DistanceAboveUsToIgnoreStimuli=128 )

	DefensiveQuery=( QueryLabel="DefensiveQuery",bAllowFriendly=FALSE,bAllowNonFriendly=TRUE,bRequireCombative=QO_Allow,bRequireDamaged=FALSE,MinFOV=-1.f,MaxFOV=-1.f,MinDist=0.f,MaxDist=2048.f,DistanceAboveUsToIgnoreStimuli=1024 )
	//,StimulusPassed=NanoAI_Trooper.IdleQueryTripped,AIPlansThisIncreases=((AIPlan=class'AIPlan_ConfrontPossibleThreat',Amount=10.0f)) )

	// MaxDist=,class'BoidRule_TrooperRangedCloser'.default.MaxDistanceToStandFromFoe
	MeleeEngageThreatQuery=( QueryLabel="Melee EngageThreat",bAllowFriendly=FALSE,bAllowNonFriendly=TRUE,bRequireCombative=QO_Require,bRequireDamaged=FALSE,MinFOV=-1.f,MaxFOV=-1.f,MinDist=0.f,MaxDist=1000.0f)


	// this guy needs to change to be a height difference in addition to distance for just general far away
	RangedEngageThreatQuery=( QueryLabel="Ranged EngageThreat",Visibility=QO_Require,bAllowFriendly=FALSE,bAllowNonFriendly=TRUE,bRequireCombative=QO_Require,bRequireDamaged=FALSE,MinFOV=-1.f,MaxFOV=-1.f,MinDist=256.0f,MaxDist=2700.0f,Visibility=QO_Require )

	LocalThreatQuery=( QueryLabel="Local Threats",Visibility=QO_Allow,bAllowFriendly=FALSE,bAllowNonFriendly=TRUE,bRequireCombative=QO_Require,MaxDist=2700 )
	LocalBackupQuery=( QueryLabel="Local Backup",Visibility=QO_Require,bAllowFriendly=TRUE,bAllowNonFriendly=FALSE,bRequireCombative=QO_Allow,MaxDist=2700 )


	StandardPickFireTargetQuery=(QueryLabel="Standard Pick FireTarget",bAllowFriendly=FALSE,bAllowNonFriendly=TRUE,MinFOV=-1.f,MaxFOV=-1.f,MinDist=0,MaxDist=2700.0f)

	FindThemAndDestroyThemQuery=( QueryLabel="FindThemAndDestroyThem",bAllowFriendly=FALSE,bAllowNonFriendly=TRUE,bRequireCombative=QO_Allow,MinFOV=-1.f,MaxFOV=-1.f,MinDist=0.f,MaxDist=50000.f )

}	
