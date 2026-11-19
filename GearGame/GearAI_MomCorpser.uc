/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAI_MomCorpser extends GearAI
	native(AI)
	config(AI);


/*****************************************************************************
	Variables dealing with making the Corpser charge
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

/** Num foot steps before reacting */
var config int NumFootSteps;

/** The location of the pawn who shot us in the eye */
var vector EnemyWhoShotEyeLocation;
/** Whether the suppress the charge telegraph or not */
var bool bSuppressNextChargeTelegraph;

/** Array of locations the corpser will run to when she goes blind */
var array<TargetPoint> ChargeLocations;

/** Last time the corpser screamed */
var float LastScreamTime;
var float LastChargeTime;
var float LastStompTime;
var float LastStabTime;


var() GearPawn_LocustMomCorpserBase Corpser;

/**
 * Overridden for additional init.
 */
event Possess(Pawn NewPawn, bool bVehicleTransition)
{
	Super.Possess(NewPawn, bVehicleTransition);
	if( Pawn != None )
	{
		Corpser = GearPawn_LocustMomCorpserBase(Pawn);
	}
}

simulated function DrawDebug( GearHUD_Base HUD, name Category, optional bool bSpecificDebug )
{
	local int Idx;
	local Vector X, Y, Z;
	local float ColSize, Width;
	local Vector P1, P2;

	Super.DrawDebug( HUD, Category, bSpecificDebug );
	
	Corpser.SetupAttackZones();
    
	// Draw attack zones
	GetAxes( Corpser.Rotation, X, Y, Z );
	Corpser.GetAttackColInfo( ColSize, Width );

	for( Idx = 0; Idx < Corpser.AttackZones.Length; Idx++ )
	{
		P1 = Corpser.Location + (Corpser.AttackZones[Idx].Min >> Corpser.Rotation);
		P2 = Corpser.Location + (Corpser.AttackZones[Idx].Max >> Corpser.Rotation);

		DrawDebugLine( P1, P1 + X * EnemyDistance_Melee, 255, 128, 255 );
		DrawDebugLine( P2, P2 + X * EnemyDistance_Melee, 255, 128, 255 );
	}
	DrawDebugLine( Corpser.Location + (Corpser.AttackZones[0].Min >> Corpser.Rotation),                           Corpser.Location + (Corpser.AttackZones[Corpser.AttackZones.Length-1].Max >> Corpser.Rotation), 255, 128, 255 );	
	DrawDebugLine( Corpser.Location + (Corpser.AttackZones[0].Min >> Corpser.Rotation) + X * EnemyDistance_Melee, Corpser.Location + (Corpser.AttackZones[Corpser.AttackZones.Length-1].Max >> Corpser.Rotation) + X * EnemyDistance_Melee, 255, 128, 255 );	
}

/** Find all the charge locations in the level */
function InitChargeLocations()
{
	local TargetPoint TargPoint;

	foreach DynamicActors(class'TargetPoint', TargPoint)
	{
		ChargeLocations.AddItem(TargPoint);
	}
}

// not sure why this was stubbed out but we should make sure bFire is turned off since corpsers can't shoot
function StopFiring()
{
	bFire = 0;
}

function DoCoverHead();

function FireFromOpen(optional int InBursts = 1, optional bool bAllowFireWhileMoving=true);

function FireFromCover();

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
	CheckInterruptCombatTransitions();
}

/** Overridden so we can determine if we care about the noise and if we do, should we charge at it */
event NotifyEnemyHeard( Pawn HeardEnemy, Name NoiseType )
{
	local int EnemyIdx;

	// If the noise was someone's footstep and we are not alert yet
	if (NoiseType == 'NOISETYPE_FootStep')
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


function HandleFailedPathFind(Actor MoveToActor)
{
	Super.HandleFailedPathFind(MoveToActor);

	// Allow charge right away to try to get out of the stuck position
	LastChargeTime = -1.f;
}


/** Overloaded state so we can zero out her movement */
state Action_Idle
{
	function BeginState(Name PreviousStateName)
	{
		Pawn.ZeroMovementVariables();

		super.BeginState( PreviousStateName );
	}
}

function DoMeleeAttack(optional Pawn NewEnemy, optional Actor InTarget)
{
	if( !Corpser.IsDoingASpecialMove() )
	{
		if (NewEnemy != None)
		{
			SetEnemy(NewEnemy);
		}

		class'AICmd_React_MomCorpser_Hurt'.static.InitCommand(self);
	}
}

function NotifyLostEye( Pawn Attacker )
{
	AbortCommand(CommandList);
	
	SetEnemy( Attacker );
	FireTarget = Enemy;

	class'AICmd_React_MomCorpser_LostEye'.static.InitLostEyeCommand( self, Enemy.Location );
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
	//debug
	`AILog( GetFuncName()@Victim@VictimLocation );

	ChargeLocation = VictimLocation;
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

		// If not already in charge
		if (FindCommandOfClass(class'AICmd_Attack_MomCorpser_Charge') == None)
		{
			// Set charge info
			SetChargeLocation(A, Loc);
			// Make the transition to charge
			BeginCombatCommand(class'AICmd_Attack_MomCorpser_Charge', Reason);
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
				BeginCombatCommand(class'AICmd_Attack_MomCorpser_Charge', Reason, true);
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
	Extent.Z *= 0.5;

	// If she doesn't hit a pawn return true
	HitActor = GAI.Pawn.Trace(HitLocation, HitNormal, TestLocation, GAI.Pawn.Location, TRUE, Extent,, TRACEFLAG_SkipMovers);
	if (HitActor == None ||
		Pawn(HitActor) != None ||
		GearMeleeTarget(HitActor) != None ||
		GearDroppedPickup_Shield(HitActor) != None ||
		GearDestructibleObject(HitActor) != None)
	{
		return TRUE;
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

/** Whether the berserker can perform a special move right now or not */
function bool CanDoSpecialMove(bool bIncludeOthers)
{
	if (MyGearPawn != None)
	{
		// Whether we are including other special moves or not, we will allow a special move
		// if we are not currently doing one, or if what we are playing is the alert one
		if (!MyGearPawn.IsDoingASpecialMove())
		{
			return TRUE;
		}
	}

	// Not accepting special moves
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
	if (!MyGearPawn.IsDoingSpecialMove(SM_Corpser_Charge))
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

event vector GetAimLocation(vector StartLoc, optional bool bActuallyFiring, optional Actor AimTarget )
{
	if( AimTarget == None )
	{
		return Super.GetAimLocation( StartLoc, bActuallyFiring, AimTarget );
	}

 	return AimTarget.Location;
}

event float GetAimError(vector TargetLocation)
{
	return 0.f;
}


/** Handler for SeqAct_AISetTarget which combines both focus and fire target selection. */
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
	MinHitWall=1.0f
	ExtraPathCost=10000
	bCanExecute=false
	bCanRevive=false
	RotationRate=(Pitch=60000,Yaw=60000,Roll=2048)
	CombatMood=AICM_Aggressive

	DefaultCommand=class'AICmd_Base_MomCorpser'

	//ignore reactions
	DefaultReactConditions.Empty
	DefaultReactConditionClasses.Empty

	// have to re-init the delegates here so they get the right function object
	// melee reaction
	Begin Object Name=EnemyInMeleeRangeReaction0
		OutputFunction=BeginMeleeCommandWrapper
	End Object
	DefaultReactConditions.Add(EnemyInMeleeRangeReaction0)

	// execute enemy
	Begin Object Name=ExecutEnemyReaction0
		OutputFunction=HandleExecuteReactionAndPushExecuteCommand
	End Object
	DefaultReactConditions.Add(ExecutEnemyReaction0)

	// don't move in squads
	bIgnoreSquadPosition=true
}
