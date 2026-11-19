/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAI_Trooper extends NanoAI_Combat
	config(AI)
	native(AI);

var NanoAI_Trooper FireBuddy;

var NanoPawn MyTrooper;


var float TimeOfLastCombatMove;
var bool bWaitingForActiveAttack;
var bool bAttemptingToFireWeapon;

var bool bHasBaton;
/** We separate this out otherwise the AI often don't come to melee you. (also will be replaced by orb cluster bomb)**/
var config byte NumBatonsToThrowLeft;


var(Query) StimulusQuery StandardThrowTeslaCoilQuery;
var(Query) StimulusQuery StandardDeployTeslaCoilQuery;


var transient vector LastLocationPlayerStanding;
var float RadiusFromLastLocationToBeConsideredCamping;
var float RadiusFromOtherTeslasForValidTossTarget;

var transient float TimeOfLastCampingCheck;
var float TimeStandingStillToBeConsideredCamping;


/** melee attack vars */

var transient bool bDelayTargetAdherence;

// types of attacks we're capable of
struct native MeleeAttackInfo
{
	// what anim to blend to before attacking (attack tell)
	var Name	PrepareAnimName;
	var Name	PrepareHoldAnimName;
	var float	PrepareAnimRate;
	// what anim to play for the actual attack after prepare
	var Name	AttackAnimName;
	// how long to hold the prepare anim (attack tell)
	var float	PrepareTime;
	// how long does it take to recover from an attack
	var float	AttackRecoverTime;
	// how long does it take to recover from a block with this attack
	var float	BlockRecoverTime;
	// what attacks does this attack potentially block?
	var array<EDirection> PrepareBlockDirections;
	// chance to evade the attack rather than block
	var float	EvadeChance;
};
var config array<MeleeAttackInfo> MeleeAttacks;

// ways we respond to incoming attacks
struct native MeleeResponseInfo
{
	// Incoming enemy attack anim name
	var Name    EnemyAttackAnimName;
	// Anim to play when stunned by this attack
	var Name    StunAnimName;
	// Anim to play to block this attack
	var Name    BlockAnimName;
};
var config array<MeleeResponseInfo> MeleeResponses;

// how long to be stunned on damage initially
var config float Melee_BaseStunTime;
// how long to increase this value with each hit taken
var config float Melee_StunTimeIncrementPerHit;
/** Chance that AI will block an attack while idle */
var config float Melee_ChanceBlockWhileIdle;
/** Chance that attacker is knocked back from attack blocking */
var config float Melee_ChanceBreakComboOnBlock;


// current stun time
var transient float Melee_StunTime;

var config Name DefaultBlockedAnimName;

// which attack are we using (index into MeleeAttacks)
var transient int MeleeAttackIdx;
// time for the current attack/block/etc, essentially GetAnimTime(AttackAnimName)
var transient float Melee_CurrentAnimDelay;
// direction enemy is trying to attack us in
var transient EDirection Melee_EnemyAttackDir;
// name of attack animation enemy is playing
var transient name Melee_EnemyAttackAnimName;
// last time we evading in melee
var transient float LastMeleeEvadeTime;
// min time between evades in melee
var config float Melee_MinDelayBetweenEvades;

struct native MeleeAttackPatternInfo
{
	var array<int>		Attacks;
	var float			DelayBeforeNextPattern;
};
var config array<MeleeAttackPatternInfo> MeleeAttackPatterns;
var transient int Melee_AttackPatternIdx;
var transient int Melee_AttackPattern_AttackIdx;

// current sub state we are in, useful for determing if we can block an attack, etc
enum EMeleeAttackState
{
	Melee_Idle,
	Melee_Preparing,
	Melee_Prepared,
	Melee_Attacking,
	Melee_Attacked,
	Melee_Blocking,
	Melee_Blocked,
	Melee_Stunned,
};
var transient EMeleeAttackState Melee_AttackState;

/** 
 *  This is the current boid rule being followed.  Right now we just use this inside the Ranged Combat state.  But it seems you need
 *  something like this as the states turn on and off the boid rule of a specific class as it moves "through" the state.
 **/
var transient class<BoidMovementRule> Combat_RangedAttack_BoidRuleBeingFollowed;


/** last time we evaded due to be being shot at **/
var transient float LastBeingShotAtEvadeTime;
/** min time between being shot at evade  (otherwise we just look like we are dive rolling all over the place) **/
var config float BeingShotAt_MinDelayBetweenEvades;
/** Chance that the AI should evade when being shot at **/
var config float BeingShotAt_EvadePercentage;

/** If the target is less than distance the AI will switch to melee and attempt to melee the target.  **/
var config float DistanceForAutoSwitchToMelee;


/** The amount damage taken during this I am being focused on window" **/
var transient float BeingFocusFired_DamageTaken;
/** We don't want to say we are being focus fired if it is only a few pts of damage.  **/
var config float BeingFocusFired_PercentageOfTotalHealth;

/** The last time we took damage in our current "I am being focused on window" **/
var transient float BeingFocusFired_LastDamageTime;
/**  This is the window we care about.  Anything outside of this window doesn't count. **/
var config float BeingFocusFired_DamageWindow;


var transient float CombatPacingEndTime;
var transient float CombatPacingStartTime;
var transient float SavedCurrPacingValue;
var transient float SavedCurrAttackValue;
/** If the attack value is higher than this then we will not wait the pacing time. **/
var config int CombatPacingAttackImmediatelyThreshold;
/** If the melee attack anim playing is longer than this value we will not attack. **/
var config float DurationOfMeleeAttackAnimToForceNotAttacking;
/** An extra buffer of "do not attack" that is added onto the time we are not allowed to attack. **/
var config float ExtraWaitOnLongMeleeAnimations;



event Possess(Pawn NewPawn, bool bVehicleTransition)
{
	Super.Possess(NewPawn,bVehicleTransition);
	MyTrooper = NanoPawn(NewPawn); //NanoPawn_MetaCorp_RiotCop(NewPawn);

	class'BoidRule_TrooperRanged'.static.AddRule( self, FALSE );
	class'BoidRule_TrooperMelee'.static.AddRule( self, FALSE );

	//NavigationHandle.bDebugConstraintsAndGoalEvals = TRUE;
	//NavigationHandle.bUltraVerbosePathDebugging = TRUE;
}


function bool CanBeFireBuddy()
{
    return TRUE;
}

function bool FindFireBuddy()
{
    local NanoAI_Trooper AI;
    if (FireBuddy != None && FireBuddy.FireBuddy == self)
    {
        return TRUE;
    }
    foreach WorldInfo.AllControllers(class'NanoAI_Trooper',AI)
    {
        if (AI != self && AI.CanBeFireBuddy())
        {
            SetFireBuddy(AI);
            AI.SetFireBuddy(self);
            return TRUE;
        }
    }
    return FALSE;
}

function SetFireBuddy(NanoAI_Trooper NewBuddy)
{
	if (NewBuddy != FireBuddy)
	{
		`AILog("New fire buddy!"@NewBuddy);
		FireBuddy = NewBuddy;
	}
}

function bool CanProvideCover(NanoAI_Trooper TestBuddy)
{
    return FALSE;
}

function ProvideCover(NanoAI_Trooper TestBuddy)
{
    SetFireBuddy(TestBuddy);
}

function bool IsMoving()
{
	return NanoAICmd_Move(CommandList) != None;
}

/** trooper functions */

function OnAIStateTransition(SeqAct_AIStateTransition Action)
{   
	bShouldAttackPlayersWithoutWeaponsVisible = Action.bShouldAttackPlayersWithoutWeaponsVisible;

	switch (Action.DesiredState)
	{
	case TS_AIControlled:
		bIsScripted = FALSE;
		TransitionTo('Idle',TRUE);
		break;
	case TS_Idle:
		ScriptedTransitionTo('Idle');
		break;
	case TS_Alert:
		ScriptedTransitionTo('Alert');
		break;
	case TS_Combat_Ranged:
		ScriptedTransitionTo('Combat_RangedAttack');
		break;
	case TS_Combat_Melee:
		ScriptedTransitionTo('Combat_MeleeAttack');
		break;
	case TS_Patrol:
		ScriptedTransitionTo('Idle_Patrol');
		break;
	}
}





function StimulusAdded()
{
	if (Stimuli[0].bVisible && !Stimuli[0].bIsFriendly && NanoPawn(Stimuli[0].Actor) != None && NanoPawn(Stimuli[0].Actor).CurrNanoState != ENS_Normal)
	{
		NanoGRI(WorldInfo.GRI).AttemptToPlayLine(EDLine_NanoPowerWitness,Pawn);
	}
}


function bool IsFiringWeapon()
{
    return MyTrooper != None && MyTrooper.Weapon != None && MyTrooper.Weapon.IsFiring();
}

function StartFiring()
{
	PossiblyPickFireTarget();
	`AILog(GetFuncName()@`showvar(FireTarget));
	if (FireTarget != None)
	{
		NanoGRI(WorldInfo.GRI).AttemptToPlayLine(EDLine_OpenFire,Pawn);
		bAttemptingToFireWeapon = TRUE;
		RegisterAsActiveAttacker();
		TryToFireWeapon();
	}
}


native function bool IsFireLineBlocked(); 

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



function TryToFireWeapon()
{
	if (FireTarget != None)
	{
		Focus = FireTarget;
		if( NanoWeap_Melee(Pawn.Weapon) != None || (LineOfSightTo(FireTarget, FireTarget.GetTargetedLocation()) && !IsFireLineBlocked()) )
		{
			`AILog("firing at target");
			Pawn.StartFire(GetFireMode());
		    bAttemptingToFireWeapon = FALSE;
			NanoPawn(Pawn).SpawnWeaponCrowdPanicRepulsor( class'NanoCrowd_PanicRepulsor_GunFired' );
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

function StopFiring()
{
    `AILog(GetFuncName()@`showvar(FireTarget));
    UnregisterAsActiveAttacker();
    ClearTimer(nameof(StopFiring));
    ClearTimer(nameof(TryToFireWeapon));
    Pawn.StopFire(0);
}

function Rotator GetAdjustedAimFor( Weapon W, vector StartFireLoc )
{
	local vector AimErrorDir, AimLoc;
	local float AdjustedMaxInaccuracy, AdjustedMinInaccuracy;
	local vector TargetedLocation;
	local vector BulletMagnetLoc;


	if (FireTarget != None)
	{
		AdjustedMaxInaccuracy = GetMaxInaccuracy();
		AdjustedMinInaccuracy = MinInaccuracy;

		// TODO:  maybe check to see if we are NanoPawn(Pawn).bLockedOnTarget   and then don't do any inaccuracy?

		// if the AI's pawn is moving
		if( VSize(Pawn.Velocity) > Pawn.GroundSpeed * 0.35 )
		{
			 AdjustedMinInaccuracy *= MovingMinInaccuracyModifer_Self;
			 AdjustedMaxInaccuracy *= MovingMaxInaccuracyModifer_Self;
		}

		// if the FireTarget is moving
		if( NanoPawnBase(FireTarget) != None )
		{
			if( VSize(FireTarget.GetVelocity()) > class'NanoPawn'.default.GroundSpeed * 0.35 )
			{
				AdjustedMinInaccuracy *= MovingMinInaccuracyModifer_FireTarget;
				AdjustedMaxInaccuracy *= MovingMaxInaccuracyModifer_FireTarget;
			}
		}


		TargetedLocation = FireTarget.GetTargetedLocation();

		// we check to see if there are any objects that are attracting our bullets
		// if there are then aim directly at them
		if( GetPossibleBulletMagnetLocation( TargetedLocation, BulletMagnetLoc ) == TRUE )
		{
			//`log( "using the BulletMagnet Location" );
			AimLoc = BulletMagnetLoc;
		}
		else
		{
			//`log( "using the Normal  TargetedLocation" );
			AimLoc = TargetedLocation + (FireTarget.GetVelocity() * LeadTargetPercentOfVelocity);
			AimLoc.Z -= 32.f;	
			AimErrorDir = Normal((AimLoc - StartFireLoc) cross vect(0,0,1));
			AimLoc += AimErrorDir * (FRand() > 0.5 ? 1 : -1) * RandRange(AdjustedMinInaccuracy,AdjustedMaxInaccuracy);
			AimLoc.Z += (FRand() > 0.5 ? 1 : -1) * RandRange(AdjustedMinInaccuracy,AdjustedMaxInaccuracy);
		}

		return rotator(AimLoc - StartFireLoc);
	}

	return Super.GetAdjustedAimFor(W,StartFireLoc);
}




function NotifyKilled(Controller Killer, Controller Killed, pawn KilledPawn, class<DamageType> damageType)
{
	if (KilledPawn == Pawn)
	{
		if (Formation != None)
		{
			Formation.RemoveMember(self);
		}
		SetMood(AIMood_Killed);
	
		UnregisterAsAttacker();
	}
	else if (NanoPawn_MetaCorp_NanoInfantry(KilledPawn) != None)
	{
		NanoGRI(WorldInfo.GRI).AttemptToPlayLine(EDLine_TrooperKilled,KilledPawn);
	}
	Super.NotifyKilled(Killer,Killed,KilledPawn,damageType);
}

function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
{
/*
	if (!MyTrooper.bShieldPose && !IsFriendlyActor(InstigatedBy) && ClassIsChildOf(damageType,class'NDT_Ballistic') && !MyTrooper.bStunned && MyTrooper.CurrNanoState == ENS_Normal)
	{
		if( Pawn.Physics != PHYS_Flying )
		{
			//if (HitLocation.Z < Pawn.Location.Z 
			//	&& FRand() > 0.85 
			//	&& Pawn.Health < (NanoPawn(Pawn).DefaultHealth * 0.5f)
			//	)
			//{
			//	NanoPawn(Pawn).Knockdown(3.f);
			//}
			//else 
            if( ( `TimeSince(LastBeingShotAtEvadeTime) > BeingShotAt_MinDelayBetweenEvades )
				&& ( FRand() > BeingShotAt_EvadePercentage )
				&& ( MyTrooper.bHasShield == FALSE ) // only evade if the ai does NOT have a shield
				)
			{
				Focus = InstigatedBy.Pawn;
				if (Normal(Focus.Location - Pawn.Location) dot vector(Pawn.Rotation) > -0.1)
				{
					LastBeingShotAtEvadeTime = WorldInfo.TimeSeconds;
					class'NanoAICmd_Evade'.static.Evade(self);
				}
			}
		}
	}
*/
	Super.NotifyTakeHit(InstigatedBy,HitLocation,Damage,damageType,Momentum);

	BeingFocusFired_DamageTaken += Damage;
	BeingFocusFired_LastDamageTime = WorldInfo.TimeSeconds;
}


function bool CanActivelyAttackTarget( optional out Name ErrorCode )
{
	local bool bResult;
	local NanoPawn FT;
	local Vector VectToTarget;
	local float DotP;

	bResult = Super.CanActivelyAttackTarget( ErrorCode );
	if( bResult )
	{
		// If fire target is a grab victim, make sure we are in front of him
		FT = NanoPawn(FireTarget);
		if( FT != None && FT.InteractionPawn != None )
		{
			VectToTarget = Normal(MyTrooper.Location-FT.Location);
			DotP = VectToTarget DOT Vector(FT.Rotation);
			if( DotP < 0.3f )
			{
				bResult = FALSE;
			}
		}
	}

	return bResult;
}


function float RateAttacker( NanoPawnBase Targ, optional bool bSkipRandom )
{
	local float Rating, TargetDotRot;
	local Vector VectTargToAttacker;

	if( Targ != FireTarget )
	{
		return -1.f;
	}

	Rating = 10.f;

	// If attacker is behind the target - penalize
	VectTargToAttacker = Normal( Pawn.Location - Targ.Location );
	TargetDotRot = VectTargToAttacker DOT Vector(Targ.Rotation);
	if( TargetDotRot < 0.3f )
	{
		Rating *= FMax( FPctByRange( TargetDotRot, -1.f, 0.3f ), 0.1f );
	}

	// Introduce some randomness, so the guy directly in front isn't always chosen
	if( !bSkipRandom )
	{
		Rating *= RandRange( 0.25f, 1.f );
	}

	return Rating;
}






// should be moved to NanoAICmds
state Combat_DeployTesla `DEBUGSTATE
{
	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
	}

Begin:
	`AILog( GetStateName()@"Begin TAG" );
	MyTrooper.DeployTesla();
	do
	{
		Sleep(1.f);
	} until (!MyTrooper.bDeployingTesla);
	bHasBaton = FALSE;
	//GotoState('Combat');
}


// should be moved to NanoAICmds
state Combat_ThrowTesla `DEBUGSTATE
{
	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
	}

Begin:
	`AILog( GetStateName()@"Begin TAG" );
	MyTrooper.ThrowTesla();
	do
	{
		Sleep(1.f);
	} until (!MyTrooper.bThrowingTesla);
	NumBatonsToThrowLeft--;
	//GotoState('Combat');
}



function EngageMeleeWith(NanoPawn InstigatedBy)
{
	`AILog(`location@`showvar(InstigatedBy));

	if( !bTargetDummy )
	{
		MyTrooper.SpawnNanoBaton();
		MyTrooper.bHasBaton = TRUE;
		SetFireTarget( InstigatedBy );
		Focus = None;
		SetFocalPoint(Pawn.Location + vector(Pawn.Rotation) * 512);

		bDelayTargetAdherence = Normal(InstigatedBy.Location - Pawn.Location) dot vector(Pawn.Rotation) < 0.1f;
		`AILog(`showvar(bDelayTargetAdherence));
		TransitionTo('Combat_MeleeAttack');
		// claim a ticket
		if( NanoPawnBase(FireTarget) != None )
		{
			NanoPawnBase(FireTarget).RegisterActiveAttacker(self);
		}
	}
}

function bool IsPushingForward()
{
	return Combat_RangedAttack_BoidRuleBeingFollowed == class'BoidRule_TrooperRangedCloser';
}


/** 
 *  So the idea here is if you concentrate fire on a single enemy for an amount of time he will consider himself "being focus fired".
 *  When that happens his friends will rush to his aid!! (right now they switch to Melee boid rules which bring the ai close to you )
 *  
 **/
function bool IsBeingFocusFired()
{
	if( `TimeSince(BeingFocusFired_LastDamageTime) < BeingFocusFired_DamageWindow )
	{
		if( BeingFocusFired_DamageTaken > (BeingFocusFired_PercentageOfTotalHealth * MyTrooper.DefaultHealth) )
		{
			//`log( "OH NOES!!! I am being focus fired!!!" @ self );
			BeingFocusFired_DamageTaken = 0; // this is semi tricky as it will make it so only one guy will charge to help us and force the player to do more damage to this guy to get another "focus fire help"
			return TRUE;
		}
	}

	return FALSE;
}


/** We override this here to use a query which will find the player and allow the confront Action to chase them down! **/
function ScriptedTransitionToCombat()
{
	//TransitionTo('Combat');
	ConfrontPossibleThreatQuery = FindThemAndDestroyThemQuery;
}



function bool AmIAllowedToAttack()
{
	local bool Retval;
	local NanoAIBlackboard BlackBoard;
	//local int CurrChaosTier;

	local bool bAttackImmediateInterrupt;

	local bool bGlobalPacing;
	local bool bPlayerAllowedToBeAttacked;
	local bool bMeleeCircleAllowedToAttack;
	local bool bEnemyNotDoingLongAnim;


	local bool bTimeBasedAttack;


	//CurrChaosTier = NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel();


	bAttackImmediateInterrupt = CombatPacingAttackImmediately();

	BlackBoard = GetBlackBoard();

	// so here we need to look up and see if any of the other time based vars are stopping us from attacking
	bGlobalPacing = BlackBoard.GlobalPacing_NextAttack < WorldInfo.TimeSeconds;

	bPlayerAllowedToBeAttacked = BlackBoard.PlayerAllowdToBeAttackedWithMeleeAndRangeTime < WorldInfo.TimeSeconds;

	bMeleeCircleAllowedToAttack = MeleeCircleAllowedToAttackTime < WorldInfo.TimeSeconds;


	bTimeBasedAttack = bGlobalPacing && bPlayerAllowedToBeAttacked && bMeleeCircleAllowedToAttack;


	bEnemyNotDoingLongAnim = TRUE;
	if( NanoPawn(FireTarget) != None )
	{
		bEnemyNotDoingLongAnim = NanoPawn(FireTarget).MeleeAttackAnimDuration < DurationOfMeleeAttackAnimToForceNotAttacking;
	}

	//if( bEnemyNotDoingLongAnim == FALSE )
	//{
	//	`log( "OH!!!" @ NanoPawn(Enemy).MeleeAttackAnimDuration @ ">" @ DurationOfMeleeAttackAnimToForceNotAttacking );
	//}


	Retval = (bAttackImmediateInterrupt || bTimeBasedAttack) && bEnemyNotDoingLongAnim;

	`AILog( Outer @ "     AmIAllowedToAttack" @ `showvar(Retval) );
	`AILog( Outer @ "        " @  `showvar(WorldInfo.TimeSeconds) @ `showvar(bAttackImmediateInterrupt) @ `showvar(bTimeBasedAttack) @ `showvar(bGlobalPacing) @ `showvar(bPlayerAllowedToBeAttacked) @ `showvar(bMeleeCircleAllowedToAttack) @ `showvar(BlackBoard.GlobalPacing_NextAttack) @ `showvar(BlackBoard.PlayerAllowdToBeAttackedWithMeleeAndRangeTime) @ `showvar(MeleeCircleAllowedToAttackTime) );


	return Retval;
}



/** How long to wait between attacks. **/
function float GetCombatPacingValue()
{
	local float CurrPacingValue;
	local NanoAIBlackboard AIBlackboard;
	local int CurrChaosTier;
	local vector2d Pacing;

	AIBlackboard = GetBlackboard();
	CurrChaosTier = NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel();
	Pacing = AIBlackboard.GlobalCombatPacingPerChaosTier[CurrChaosTier].CombatPacingRange;


	CurrPacingValue = RandRange( Pacing.X, Pacing.Y );
		//RandRange( CombatPacingRange.X, CombatPacingRange.Y );
	//`log( " " @ `showvar(CurrPacingValue) );


	//CurrPacingValue += CombatResponse[ERT_Idle] / 100.0f;
	//`log( " " @ `showvar(CurrPacingValue) );

	//CurrPacingValue += GetAIBlackboard().GlobalCombatResponse[ERT_Idle] / 100.0f;
	//`log( " " @ `showvar(CurrPacingValue) );

	CurrPacingValue = FMin( CurrPacingValue, Pacing.Y );

	// used for updating the hud
	SavedCurrPacingValue = CurrPacingValue;

	`AILog( " " @ `showvar(CurrPacingValue) );

	return CurrPacingValue;
}

/** If we would should attack immediately **/
function bool CombatPacingAttackImmediately()
{
	local int CurrAttackValue;

	CurrAttackValue += CombatResponse[ERT_Attack];
	//`log( " " @ `showvar(CurrAttackValue) );

	CurrAttackValue += GetBlackboard().GlobalCombatResponse[ERT_Attack];

	//`log( " " @ `showvar(CurrAttackValue) );

	SavedCurrAttackValue = CurrAttackValue;

	if( ( CurrAttackValue > CombatPacingAttackImmediatelyThreshold )
		|| ( bMAI_OverrideAttackPacing == TRUE )
		)
	{
		//`log( " =>" @ `showvar(CurrAttackValue) );
		return TRUE;
	}

	return FALSE;
}


defaultproperties
{
	bHasBaton=TRUE

	StandardThrowTeslaCoilQuery=(QueryLabel="Standard Throw Teslas Coil",bAllowFriendly=FALSE,bAllowNonFriendly=TRUE,bRequireCombative=QO_Require,Visibility=QO_Require,MinFOV=-1.f,MaxFOV=-1.f,MaxDist=8192.f)
	StandardDeployTeslaCoilQuery=(QueryLabel="Standard Throw Teslas Coil",bAllowFriendly=FALSE,bAllowNonFriendly=TRUE,bRequireCombative=QO_Require,Visibility=QO_Require,MinFOV=-1.f,MaxFOV=-1.f,MaxDist=1024.f,RetryDelay=3.0f)

	RadiusFromLastLocationToBeConsideredCamping=256.0f
	RadiusFromOtherTeslasForValidTossTarget=650.0f // c.f. TeslaCoil LinkDistance  we need this to be around the LinkDistance but not too close together
    TimeStandingStillToBeConsideredCamping=2.0f

	
	AITree=AITree'TestAITree.AITree'

	//// AI Actions

	//ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_Idle_MoveToUnseenLocationAndDespawn' )
	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_Idle_PatrolARoute' )
	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_Idle_StandAround' )
	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_Idle_WaitingForCinematicModeToEnd' )
	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_Idle_WaitingForReinforcementWave' )
	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_Idle_WaitingToDieDueToDismemberment' )


	//ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_Defensive_GuardLocation' )
	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_Defensive_GuardDefensePoint' )
	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_Defensive_MemberOfAFormation' )

	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_Trooper_ReactToGunBeingAimedAt' )

	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_ConfrontPossibleThreat_MoveDirectlyToward' )
	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_ConfrontPossibleThreat_MoveToRoofTopInFrontOfPlayer' )


	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_EngageThreat_FormAPhalanx' )
	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_EngageThreat_Trooper_Melee' )
	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_EngageThreat_Trooper_Ranged' )


	//ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_EngageThreat_Trooper_ProvidingCover' )
	//ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_EngageThreat_Trooper_Ranged_Shield' )
	//ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_EngageThreat_Trooper_WithFireBuddy' )


	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_RunAway_Flee' )

}
