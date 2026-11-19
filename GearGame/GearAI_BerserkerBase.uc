/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAI_BerserkerBase extends GearAI
	config(AI)
	native(AI);


/*****************************************************************************
	Variables dealing with making the Berserker charge
*****************************************************************************/

/** Pawn is preparing the charge - rotating towards target **/
var bool bPreparingCharge;

/** Should charge directly at target -- set when only bustable objects in the way */
var bool bDirectCharge;

/** Start charge again after finishing current special move */
var bool bChargeAgain;

/** Actor we are charging at */
var Actor ChargeActor;

/** Location we are charging at */
var Vector ChargeLocation;

/** Location of charge actor when info was gathered */
var Vector ChargePivot;

/** Last time charge actor/location was updated */
var float ChargeUpdateTime;

/** FOV angle needed to readjust to target while charging */
var config float ChargeAdjustFOV;

/** Max distance to readjust to target while charging */
var config float ChargeAdjustDist;

/*****************************************************************************
	Other misc variables
 *****************************************************************************/

/** Max amount of time to search before sniffing and charging a target */
var config float MaxSearchTime;

/** Time buffer added to hear a sound after a slide attack starts */
var config float NextHearTime;

/** Min/Max time for sniffing before charging */
var config Vector2D SniffTime;

/** Num foot steps before reacting */
var config int NumFootSteps;

/** Whether or not this berserker is lambent or not */
var bool bIsLambent;

/** Force jump move on next move choice */
var bool bForceJumpAttack;

var Pawn LastKamikazeTarget;


/**
 * AdjustPathCacheForCharge
 * this will take the berzerker's path and walk backward from the end point until
 * an edge is found which does not have clear line-of-charge to the charge point
 * used to determien how much the berzerker needs to walk before charging
 * @param ChargePoint - goal charge location
 * @return void (alters the pathcache)
 */
native function AdjustPathCacheForCharge(vector ChargePoint);

/** She has no weapons to fire */
function StopFiring();

/** She ignore projectiles landing near her */
function NotifyProjLanded( Projectile Proj );

/** She ignore HOD threat, even though it's her weakness */
function NotifyHODThreat( Pawn Shooter, Vector TargetingLocation );

/** Overridden to draw lines for where she is going */
simulated function DrawDebug( GearHUD_Base HUD, name Category, optional bool bSpecificDebug )
{
	super.DrawDebug(HUD, Category, bSpecificDebug);

	if (bDrawAIDebug && Category=='Default')
	{
		if (ChargeLocation != vect(0,0,0))
		{
			// REDish
			DrawDebugLine(Pawn.Location, ChargeLocation, 150, 0, 0);
			// BLUEish
			DrawDebugLine(Pawn.Location, GetDestinationPosition(), 0, 0, 150);
		}
	}
}

/** Overridden so we can display whether she is alert or not */
simulated function DrawIconOverhead(GearHUD_Base HUD, Texture2D Icon)
{
	local Canvas	Canvas;

	super.DrawIconOverhead(HUD, Icon);

	Canvas = HUD.Canvas;
	Canvas.SetDrawColor(255,255,255);

	if (IsAlert())
	{
		Canvas.DrawText("Alert",TRUE);
	}
	else
	{
		Canvas.DrawText("Normal",TRUE);
	}
}

/** Don't allow AI to select a target, we will handle this in SelectEnemy only */
function bool SelectTarget()
{
	ClearTimer('SelectTarget');
	return FALSE;
}

/** Overridden so that we can make her charge at the noise of projectiles  */
function HearNoise(float Loudness, Actor NoiseMaker, optional Name NoiseType)
{
	local Projectile Proj;

	//debug
	`AILog( GetFuncName()@Loudness@NoiseMaker@NoiseType@CanDoSpecialMove( FALSE ) );

	// See if we can cast the noise makeer into a projectile
	Proj = Projectile(NoiseMaker);
	if (Proj != None)
	{
		// It was a projectile, so charge at the projectile location if possible
		if (CanDoSpecialMove(FALSE))
		{
			ChargeAt(Proj, Proj.Location, "Heard enemy w/ LOS");
		}
	}
	// Not a projectile so carry on as normal
	else
	{
		super.HearNoise(Loudness, NoiseMaker, NoiseType);
	}
}

/** Overridden to make the berserker alert and to see if we can enter combat */
event NotifyEnemySeen( Pawn SeenEnemy )
{
	BecomeAlert();
	CheckInterruptCombatTransitions();
}

/** Overridden so we can determine if we care about the noise and if we do, should we charge at it */
event NotifyEnemyHeard( Pawn HeardEnemy, Name NoiseType )
{
	local int EnemyIdx;
	local Vector EnemyLocation;

	// If the noise was someone's footstep and we are not alert yet
	if (NoiseType == 'NOISETYPE_FootStep' &&
		!IsAlert())
	{
		// See if the enemy footstep is in our local enemy list
		EnemyIdx = LocalEnemyList.Find('Pawn', HeardEnemy);
		if (EnemyIdx >= 0)
		{
			// If the footstep timer is expired reset the counter
			if (`TimeSince(LocalEnemyList[EnemyIdx].LastFootStepTime) > 5.f)
			{
				//debug
				`AILog( "Reset footstep counter for"@LocalEnemyList[EnemyIdx].Pawn );
				LocalEnemyList[EnemyIdx].FootStepCount = 0;
			}

			// Increment the counter and reset the timer
			LocalEnemyList[EnemyIdx].FootStepCount++;
			LocalEnemyList[EnemyIdx].LastFootStepTime = WorldInfo.TimeSeconds;

			// If we haven't passed the footstep threshold, just return out
			if( LocalEnemyList[EnemyIdx].FootStepCount < NumFootSteps )
			{
				//debug
				`AILog( GetFuncName()@"Ignore footstep" );
				return;
			}
		}
	}

	`AILog( GetFuncName()@HeardEnemy@MyGearPawn.SpecialMove@CanDoSpecialMove( TRUE ) );

	// If not already doing an action
	if (CanDoSpecialMove(TRUE))
	{
		// Make her alert
		BecomeAlert();

		if (MyGearPawn.IsDoingSpecialMove(SM_Berserker_Alert))
		{
			EnemyLocation = GetEnemyLocation(HeardEnemy);
			if (ChargeLocationReachable(self, EnemyLocation))
			{
				AbortCommand(None, class'AICmd_Berserker_AlertSearch');
			}
		}
	}
}

/** Whether the berserker can perform a special move right now or not */
function bool CanDoSpecialMove(bool bIncludeOthers)
{
	if (MyGearPawn != None)
	{
		// Whether we are including other special moves or not, we will allow a special move
		// if we are not currently doing one, or if what we are playing is the alert one
		if (!MyGearPawn.IsDoingASpecialMove() ||
			 MyGearPawn.IsDoingSpecialMove(SM_Berserker_Alert))
		{
			return TRUE;
		}

		// At this point we will only accept a special move if we are including other special moves
		// and that move is only the slide
		if (bIncludeOthers && MyGearPawn.IsDoingSpecialMove(SM_Berserker_Slide))
		{
			return TRUE;
		}
	}

	// Not accepting special moves
	return FALSE;
}

/** Make the berserker alert */
function BecomeAlert()
{
	//debug
	`AILog( GetFuncName() );

	SetPerceptionMood( AIPM_Alert );
	SetTimer( 20.f, FALSE, nameof(NoLongerAlert) );
}

/** Stop the berserker from being alert */
function NoLongerAlert()
{
	//debug
	`AILog( GetFuncName() );

	SetPerceptionMood( AIPM_Normal );
}

/** Overridden to give the berserker a keener sense of hearing and to see if we want to redirect her charging */
function bool CanHearPawn(Pawn Heard, float Loudness, Name NoiseType)
{
	local float HearRadius;
	local float Dist;

	// Make sure she has a pawn
	// Make her only hear enemies controlled by humans
	// Don't respond to weapon switches
	if (MyGearPawn == None ||
		!Heard.IsHumanControlled() ||
		NoiseType == 'ChangedWeapon')
	{
		return FALSE;
	}

	// If is charging ...
	if (MyGearPawn.IsDoingSpecialMove(SM_Berserker_Charge))
	{
		// If sound is not from our victim - Ignore
		if (Heard != ChargeActor)
		{
			return FALSE;
		}

		// If already charging AND sound is too far to the side to adjust OR sound is too close to adjust
		if (!bPreparingCharge &&
			((Normal(Heard.Location-MyGearPawn.Location) DOT Normal(MyGearPawn.Velocity) < ChargeAdjustFOV) ||
			 (VSizeSq(Heard.Location-Pawn.Location) < ChargeAdjustDist*ChargeAdjustDist)))
		{
			return FALSE;
		}

		// CHANGE TO TRACE!
		// Make sure the location is still reachable while charging
		if (!class'GearAI_BerserkerBase'.static.ChargeLocationReachable(self, Heard.Location))
		{
			return FALSE;
		}
	}
	// Otherwise not sliding OR enough time has passed since slide started
	else if(!CanDoSpecialMove(TRUE) ||
			WorldInfo.TimeSeconds < NextHearTime)
	{
		// Wait until we go back to search state
		return FALSE;
	}

	// If the noise was someone's footstep
	if (NoiseType == 'NOISETYPE_FootStep')
	{
		// Hear footsteps at max volume at 512 units
		HearRadius = Pawn.HearingThreshold * Loudness;
		Dist = VSize(Heard.Location-Pawn.Location);
		//debug
		`AILog( "Heard footstep"@(Dist <= HearRadius)@Loudness@Pawn.HearingThreshold@HearRadius@Dist );
		return (Dist <= HearRadius);
	}

	return TRUE;
}

/** Overloaded (and not calling Super) so we don't interrupt transition into stunned/collide states if enemy is close */
function NotifyEndOfSpecialMove( GearPawn.ESpecialMove LastMove )
{
	`AILog( class@GetFuncName()@LastMove );
}

/** Takes longer for her to time out her move */
function float GetMoveTimeOutDuration(vector dest, bool bDontCare)
{
	return 10.f;
}

/** Ignore this since Berserker can't fire */
function FireFromOpen(optional int InBursts = 1, optional bool bAllowFireWhileMoving=true);

/** Overloaded state so we can zero out her movement */
state Action_Idle
{
	function BeginState(Name PreviousStateName)
	{
		Pawn.ZeroMovementVariables();

		super.BeginState( PreviousStateName );
	}
}

/** Overloaded to use the berserker's special move melee */
function DoMeleeAttack(optional Pawn NewEnemy, optional Actor InTarget)
{
	// Switch her enemy to this one
	if (NewEnemy != None)
	{
		SetEnemy(NewEnemy);
	}

	// Call the special move for her melee
	class'AICmd_Berserker_SmashAttack'.static.InitCommand(self);
}

/** Notification from animation that Berserker started charging. This is because animation transitions delay this. It's not instantaneous. */
function ChargeStartedNotify()
{
	bPreciseDestination = TRUE;

	// Pawn is aligned towards target, we can charge now
	bPreparingCharge = FALSE;
	bDirectCharge = FALSE;
}

/** Set the data necessary to give the berserker a destination for her charge attack */
function SetChargeLocation(Actor Victim, Vector VictimLocation)
{
	local float Dist, TravelTime;

	//debug
	`AILog( GetFuncName()@Victim@VictimLocation );

	Dist = VSize(VictimLocation-Pawn.Location);
	// MAGIC NUMBER: Charge speed roughly 600
	TravelTime = Dist / 600.f;

	ChargeLocation = VictimLocation;
	// Lead charge target a little bit (assume half velocity b/c they are likely to change direction)
	if (Victim != None)
	{
		ChargeLocation += TravelTime * Victim.Velocity * 0.5f;
	}
	ChargeLocation.Z = Pawn.Location.Z;
	ChargePivot	= ChargeLocation;
	ChargeActor	= Victim;
	ChargeUpdateTime = WorldInfo.TimeSeconds;
}

/** Attempt to make the berserker charge at an actor or direct location */
function ChargeAt( Actor A, Vector Loc, coerce String Reason, optional bool bDirect )
{
	//debug
	`AILog(GetFuncName()@Reason@"---"@A@Loc@bDirect@CanDoSpecialMove(FALSE));

	// check for a smash first
	CheckInterruptCombatTransitions();

	bDirectCharge = bDirect;

	// If not doing sliding OR colliding special move
	if (CanDoSpecialMove(FALSE))
	{
		//debug
		`AILog( GetFuncName()@"How to respond?"@(FindCommandOfClass(class'AICmd_Berserker_Kamikaze') != None)@A@ChargeActor );

		// If not already in Kamikaze
		if (FindCommandOfClass(class'AICmd_Berserker_Kamikaze') == None)
		{
			// Set charge info
			SetChargeLocation(A, Loc);
			// Make the transition to charge
			BeginCombatCommand(class'AICmd_Berserker_Kamikaze', Reason);
		}
		// Otherwise, we are pathing toward some enemy
		else
		{
			// Check to see if new enemy is closer than old enemy
			if (A == ChargeActor ||
				VSizeSq(Pawn.Location-Loc) < VSizeSq(Pawn.Location-ChargeLocation))
			{
				//debug
				`AILog("New noise maker is closer than old one");
				// Set charge info
				SetChargeLocation(A, Loc);
				// Reset state
				BeginCombatCommand(class'AICmd_Berserker_Kamikaze', Reason, true);
			}
			// Otherwise, ignore noise
			else
			{
				//debug
				`AILog("Ignore noise");
			}
		}
	}
	else
	{
		// Store charge info for later
		bChargeAgain = TRUE;
		ChargeActor = A;
		ChargeLocation = Loc;

		//debug
		`AILog( "Will charge again... set flag and store info" );
	}
}

/** Returns whether a location is reachable by the berserker or not */
static function bool ChargeLocationReachable(GearAI GAI, Vector TestLocation)
{
	local Vector HitLocation, HitNormal, Extent, VectToLoc, VectToHit;
	local Actor HitActor;
	local float DotP;

	// Build the extent to use and shrink it since she'll be hunched a bit
	Extent = GAI.Pawn.GetCollisionExtent();
	Extent.Z *= 0.75;

	// If she doesn't hit a pawn return true
	HitActor = GAI.Pawn.Trace(HitLocation, HitNormal, TestLocation, GAI.Pawn.Location, TRUE, Extent,, TRACEFLAG_SkipMovers);
	if (HitActor == None ||
		(Pawn(HitActor) != None && HitActor.bCanBeDamaged) ||
		GearMeleeTarget(HitActor) != None ||
		GearDroppedPickup_Shield(HitActor) != None ||
		GearDestructibleObject(HitActor) != None)
	{
		//superville: commented out because it was causing no charge when player in cover subdivides navmesh and generates obstacle mesh
		// reduced the Z scaling of the extent instead... may cause issues with charging up slopes?
//		if ( class'NavigationHandle'.static.ObstacleLineCheck(GAI.Pawn.Location,TestLocation,Extent,HitLocation) )
//		{
			return TRUE;
//		}
	}
	

	VectToLoc = Normal(TestLocation - GAI.Pawn.Location);
	VectToHit = Normal(HitLocation - TestLocation);
	DotP = VectToHit DOT VectToLoc;

	// She hit something, so return true if what she hit was past the TestLocation
	if (DotP > 0.f)
	{
		return TRUE;
	}

	//debug
	//DrawDebugBox( HitLocation, Extent, 255, 0, 0, TRUE );

	return FALSE;
}

/** Override bumping into another actor notification so we can handle it in the pawn */
function bool NotifyBump(Actor Other, Vector HitNormal)
{
	local GearPawn OtherWP;

	// If she collided with a KActor don't do anything
	if (KActor(Other) != None)
	{
		return false;
	}

	// Not already charging or sliding
	if ( !MyGearPawn.IsDoingSpecialMove(SM_Berserker_Charge) && !MyGearPawn.IsDoingSpecialMove(SM_Berserker_Slide) &&
		!WorldInfo.GRI.OnSameTeam(Other, self) )
	{
		if(CanDoSpecialMove(FALSE))
		{
			// If she bumped into a DBNO enemy, charge over them
			OtherWP = GearPawn(Other);
			if (OtherWP != None &&
				OtherWP.IsDBNO())
			{
				ChargeAt(OtherWP, OtherWP.Location, "Bumped into down enemy", TRUE);
			}
			// If she bumped into fortification
			else if (GearMeleeTarget(Other) != None)
			{
				ChargeAt(Other, OtherWP.Location, "Bumped into fortification", TRUE);
			}
			// Do melee swing
			else if (OtherWP != None)
			{
				DoMeleeAttack();
			}
		}
	}

	return false;
}

// Override to fix aimoffset when charging.
event vector GetAimLocation(vector StartLoc, optional bool bActuallyFiring, optional Actor AimTarget )
{
	// Always look ahead of us...
	if( !bActuallyFiring && AimTarget == None )
	{
		// If we're looking at something, point the aim offset in that direction as well.
		if( MyGearPawn.HeadTrackSkelControl.ControlStrength > 0.f )
		{
			return MyGearPawn.HeadTrackSkelControl.TargetLocation;
		}

		// Default to looking straight ahead.
		return MyGearPawn.Location + Vector(MyGearPawn.Rotation) * MyGearPawn.CylinderComponent.CollisionRadius;
	}

	// Don't mess up firing... (This pawn doesn't fire right now, but just in case).
	return Super.GetAimLocation(StartLoc, bActuallyFiring, AimTarget);
}

/**
 * Handler for SeqAct_AISetTarget which combines both focus and fire target selection.
 */
function OnAISetTarget(SeqAct_AISetTarget InAction)
{
	local int Idx;
	local Controller CurrController;

	for (Idx = 0; Idx < InAction.FocusTargets.length; Idx++)
	{
		CurrController = Controller(InAction.FocusTargets[Idx]);
		if (CurrController != None && CurrController.Pawn != None)
		{
			Squad.AddEnemy(self, CurrController.Pawn);
			LocalEnemyList.length = LocalEnemyList.length + 1;
			LocalEnemyList[LocalEnemyList.length-1].Pawn = CurrController.Pawn;
			Enemy = CurrController.Pawn;
			NotifyEnemyHeard(CurrController.Pawn, 'None');
		}
	}
}


defaultproperties
{
	bAlwaysHear=TRUE
	MinHitWall=-0.5f
	RotationRate=(Pitch=20000,Yaw=20000,Roll=20000)
	ExtraPathCost=10000
	DefaultCommand=class'AICmd_Base_Berserker'
	bCanRevive=FALSE
	bPreferMelee=TRUE

	// don't want reactions for this guy
	DefaultReactConditions.Empty
	DefaultReactConditionClasses.Empty

	// have to re-init the delegates here so they get the right function object
	// melee reaction
	Begin Object Name=EnemyInMeleeRangeReaction0
		OutputFunction=BeginMeleeCommandWrapper
	End Object
	DefaultReactConditions.Add(EnemyInMeleeRangeReaction0)
}
