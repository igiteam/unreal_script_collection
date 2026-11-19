/*
	Movement and sensory information is inherited from TPAIController.
	
	This controller will contain combat behaviors.
*/
class TPSoldierAIController extends TPAIController
	native;

//***********************************************************************
// Macros
//***********************************************************************












 







































#linenumber 12








#linenumber 13





// Used to prevent redundant findcover calls for current enemy

// Used to ensure findcover is recalculated after we move a significant distance


// When we first spawn into a level, we have to wait a bit before we start killing people.
// Otherwise, it looks and sounds strange.





//***********************************************************************
// enum Declarations
//***********************************************************************


//***********************************************************************
// struct Declarations
//***********************************************************************

/**
 * Contains all the relevant information pertaining to being a TERMINATOR
 */
struct native TerminatorInfo
{
	var float m_Accuracy;
	var int m_RateOfFirePerMin;

	var bool m_UseAgainstCurrentEnemy;


	var float m_MinTimeToTerminate;
	var float m_MaxTimeToTerminate;
	var float m_ActualTimeToTerminate;
	var float m_TimeStartedTerminating;

	var float m_MinTimeToStandAndShoot;
	var float m_MaxTimeToStandAndShoot;
	var float m_ActualTimeToStandAndShoot;

	var float m_TimeStartedStandingAndShootingThisTurn;

	var float m_DistanceToLookForCoverSlot;

	var float m_MinDistanceToBeFromEnemy;
	var float m_MaxDistanceToBeFromEnemy;
	var float m_IdealDistanceToBeFromEnemy;

	var float m_MaxDistanceToMoveFromStartLoc;

	var float m_SuppressionCheckDistance;

	var Pawn	m_AssignedThingToKill;
	var Pawn	m_CurrentThingToKill;

	var Actor	m_StartLoc;

	var bool	m_bContinueToTerminate;

	var CoverInfo		m_CurrentCoverToTerminateFrom;
	var Actor			m_LocToTerminateFrom;

};


//***********************************************************************
// Variable Declarations
//***********************************************************************


var DangerousPoint Danger;


//Combat management...
var(AI) bool bStandAndAttackOnly;
var(AI) bool bNoAttack;

// Multi purpose timer vars...
var float m_accumulatedTime;
var float m_timeToWait;
var float m_sleepTime; //for random sleep times...

//var bool m_bDoIdle;
//var bool m_bInvalidFireState;
var NavigationPoint m_oldDefendAreaDestination;

var bool m_bPauseFire;

var float MinForcedStandDist;
var float MaxForcedStandDist;
var bool bForcedStand;

var int BurstCount; // current count of bullets fired in this burst

// Accuracy stuff
var(AI) Float BaseWeaponAccuracy; // How accurate is this pawn with weapons? (1.0 = standard)
var		Float TargetWeaponAccuracy; // How accurate is this pawn against a specific target?
									// (Reverts to BaseWeaponAccuracy when the target changes.)
var		Bool  bUseTargetAccuracy;

var		Float CurrentInaccuracy;
var		Float CurrentInaccuracyAngle;	

// Grapple stuff
var     eGrappleAction    eGrappleAction;
var     name              GrappleAnimName;

var TerminatorInfo m_TerminatorInfo;

var 	Inventory HeldGrenade;

// We dont' want to start firing immediatley when we come into the world.
// This variable just lets
var		bool	JustSpawned;

//***********************************************************************
// CPP Text
//***********************************************************************
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


//***********************************************************************
// Function Declarations
//***********************************************************************

/** Returns the world location of the requested slot. */
native function bool CanFireFromCoverToCover( CoverInfo CoverFrom, CoverInfo CoverTo );
native function RandomlyPlayGrenadeScream();

//***********************************************************************
// Functions/States
//***********************************************************************

function GrabbedBy(TPPlayerController tppController);
function StartGrappleAction(eGrappleAction action, name AnimName, optional float FailTimer = 5.0f, optional int NumTimes = 1, optional bool bNoRagDollDeath = false, optional bool bNoRagDollBlending = false);
function DoMeleeAttackFinished();

event PostBeginPlay()
{
	JustSpawned = true;

	Super.PostBeginPlay();
}

//************************ - BEGIN SECTION - ****************************
// TOO CLOSE TO CROUCH FUNCTIONS
//***********************************************************************


native final function bool ChanceOfCrouching();
// {
// 	return Rand(100) > 25;
// }

native final function bool IsEnemyShootableWhenCrouched();
// {
// 	local vector crouchOffset;
// 	crouchOffset.Z = Pawn.CrouchHeight;
// 	return CanFireAtNotFromCover(Enemy, true,,Pawn.Location-crouchOffset);
// }


//***********************************************************************
// TOO CLOSE TO CROUCH FUNCTIONS
//************************ - END SECTION - ******************************

native function bool ShouldIUseTurret();

//************************ - BEGIN SECTION - ****************************
// EVALUATION FUNCTIONS
//***********************************************************************

native function EvaluateSituation();

//-----------------------------------------------------------------------
// Function:
// Description:	Checks to see if it's okay to fire
//-----------------------------------------------------------------------
native function bool ShouldIFire();

//-----------------------------------------------------------------------
// Function:
// Description:	Checks to see if turning is needed to face target
//-----------------------------------------------------------------------
native function bool ShouldITurnToTarget( bool bAtCover );


// To C++
function bool CanUseCover()
{
	return true;
}

// To C++
final function bool HasValidTarget( optional Actor TestTarget )
{
	local Pawn		TestPawn;

	// If no actor given use current fire target
	if( TestTarget == None )
	{
		TestTarget = Target;
	}

	// If we don't have a target - invalid
	if( TestTarget == None )
	{
		return FALSE;
	}

	// If target is a dead pawn - invalid
	TestPawn = Pawn(TestTarget);
	if(  TestPawn != None &&
		!TestPawn.IsValidTargetFor( self ) )
	{
		return FALSE;
	}

	return TRUE;
}

//***********************************************************************
// EVALUATION FUNCTIONS
//************************ - END SECTION - ******************************


//************************ - BEGIN SECTION - ****************************
// SENSORY EVENTS/FUNCTIONS
//***********************************************************************


//***********************************************************************
// SENSORY EVENTS/FUNCTIONS
//************************ - END SECTION - ******************************


//************************ - BEGIN SECTION - ****************************
// WEAPON MANAGEMENT FUNCTIONS
//***********************************************************************

//---------------------------------------------------------------------------
// Function:
// Description:	Callback from weapon when it is fired.
//---------------------------------------------------------------------------
// Not to C++
function NotifyWeaponFired(Weapon W, byte FireMode)
{
	//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ "NotifyWeaponFired fn called");

	if (Pawn != None && Pawn.Weapon != None && !IsInState('FireFromCover') && !IsInState('TakeHit')) //hmm, how to control this a better way?  Something like the 'ignores' keyword?
	{
		++BurstCount;
		if (BurstCount >= TPWeapon(Pawn.Weapon).BulletsPerBurst)
		{
			BurstCount = 0;
			if (!IsInState('BurstFireWait'))
				PushState('BurstFireWait');
		}
	}
}

//---------------------------------------------------------------------------
// Function:
// Description:	Returns true if our weapon can reload.
//---------------------------------------------------------------------------
// To C++
function bool CanReload()
{
	return Pawn != None && Pawn.Weapon != None && TPWeapon(Pawn.Weapon).CanReload();
}

//---------------------------------------------------------------------------
// Function:
// Description:	Returns true if our weapon magazine is full.
//---------------------------------------------------------------------------
// To C++
function bool MagazineFull()
{
	return Pawn != None && Pawn.Weapon != None && TPWeapon(Pawn.Weapon).MagazineFull();
}

//---------------------------------------------------------------------------
// Function:
// Description:	Forces the gun to reload.
//---------------------------------------------------------------------------
// Not to C++
function ForceReload()
{
	if (Pawn != None && Pawn.Weapon != None)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " Makeing weapon reload by ForceReload -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		TPWeapon(Pawn.Weapon).GotoState('Reloading');
		Target = None;
		StopFiring();
	}
}

// called by TPWeapon when the weapon is reloaded
// Not to C++
function WeaponReloaded()
{
	BurstCount = 0; // reset this so it fires the correct number of bullets per burst after reload
	//`log("reset bullet count!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
}

//***********************************************************************
// WEAPON MANAGEMENT FUNCTIONS
//************************ - END SECTION - ******************************



//************************ - BEGIN SECTION - ****************************
// COVER FUNCTIONS
//***********************************************************************


//-----------------------------------------------------------------------
// Function:
// Description:	Returns a weight indicating the desirability of the given
//				cover node, or -1.f if this node should be ignored.
//-----------------------------------------------------------------------
native function float RateCoverSlot(CoverInfo inNode, float chkDist);


//-----------------------------------------------------------------------
// Function:
// Description:	Returns a weight indicating the desirability of the given
//				cover node, or -1.f if this node should be ignored.
//-----------------------------------------------------------------------
//native function float RateCoverSlotForAttack(CoverInfo inNode, Actor TargetOfAttack, float DistanceToTarget);

native function CoverInfo FindBestCoverInCoverGroup();

//-----------------------------------------------------------------------
// Function:
// Description:	Returns the best cover node within the specified distance
//				that isn't already claimed.
//				CHAD CHANGE: Switched to using CoverInfo
//-----------------------------------------------------------------------
native function CoverInfo FindCoverForFreeAttack(float dist, bool bForceNew);

native function CoverInfo EvaluateCoverForFreeAttack();

//***********************************************************************
// COVER FUNCTIONS
//************************ - END SECTION - ******************************




//************************ - BEGIN SECTION - ****************************
// COMBAT MANAGEMENT FUNCTIONS
//***********************************************************************

// To C++
function ClearEnemy()
{
	if (Target == Enemy)
	{
		Target = None;
	}

	if (Focus == Enemy)
	{
		Focus = None;
	}

	m_enemyIdx = -1;
	Enemy = None;
	bEnemyAcquired = false;
}

//***********************************************************************
// COMBAT MANAGEMENT FUNCTIONS
//************************ - END SECTION - ******************************

//************************ - BEGIN SECTION - ****************************
// Aiming functions
//***********************************************************************

//Calculates the TargetAimLocation which we will aim at, and the bullets will go toward.
native function CalcTargetAimLocation();

// Calculate the inaccuracy percentage for this soldier with his current weapon.
native function Rotator CalcInaccuracy();
native function Rotator CalcTurretInaccuracy();

native function DoAimStuff( bool bAtCover, bool bInVechile );

native function UpdateAimAtCover();

native function UpdateAimInTheOpen(bool bInVechile);

native function Vector GetFireTargetLocation();

//-----------------------------------------------------------------------
// Function:	 GetAdjustedAimFor
// Description:  gets the appropriate direction of fire - called by the weapon system at time of fire.
//-----------------------------------------------------------------------

// To C++
function Rotator GetAdjustedAimFor( Weapon W, vector StartFireLoc )
{
	local vector SocketLocation;
	local rotator SocketRotation;
	local rotator AccRot, BaseRot;

	local SkeletalMeshSocket aimSocket;
	local rotator oldSocketRotation;
	local bool bFound;


	if( Pawn != None && Target != None )
	{
		BaseRot = rotator( TargetAimLocation - StartFireLoc );
		AccRot = CalcInaccuracy();
		//`log(" ChadAI - GetAdjustedAimFor Pawn != None && Target != None --- TargetAimLocation: " @ TargetAimLocation @ " - StartFireLoc: " @ StartFireLoc @ " AimOffset.X:" @ Pawn.AimOffset.X @ " Y: " @ Pawn.AimOffset.Y );
		return BaseRot + AccRot;
	}

	if ( WehrmachtPawn(Pawn) != None && WehrmachtPawn(Pawn).bAccuratePerformanceFire )
	{
		WehrmachtPawn(Pawn).bAccuratePerformanceFire = false;
		FindPlayerController();
		if ( m_ThePlayerController != None && m_ThePlayerController.Pawn != None)
		{
			BaseRot = rotator( m_ThePlayerController.Pawn.Location - StartFireLoc );
			AccRot = CalcInaccuracy();
			//`log(" ChadAI - GetAdjustedAimFor WehrmachtPawn(Pawn) != None && WehrmachtPawn(Pawn).bAccuratePerformanceFire --- TargetAimLocation: " @ TargetAimLocation @ " - StartFireLoc: " @ StartFireLoc @ " AimOffset.X:" @ Pawn.AimOffset.X @ " Y: " @ Pawn.AimOffset.Y );
			return BaseRot + AccRot;
		}
	}

	//`log(" ChadAI - GetAdjustedAimFor No target - try to use the muzzle flash socket AimOffset.X:" @ Pawn.AimOffset.X @ " Y: " @ Pawn.AimOffset.Y );
	
	//No target - try to use the muzzle flash socket.  
	bFound=false;
	aimSocket = SkeletalMeshComponent(W.mesh).GetSocketByName( TPWeapon(W).MuzzleFlashSocket );
	if( aimSocket != None )
	{
		//need to hack the relative rotation...
		oldSocketRotation = aimSocket.RelativeRotation;
		aimSocket.RelativeRotation.Pitch=16384;
		aimSocket.RelativeRotation.Roll=-16384;
		if (SkeletalMeshComponent(W.mesh).GetSocketWorldLocationAndRotation(TPWeapon(W).MuzzleFlashSocket, SocketLocation, SocketRotation))
		{
			bFound=true;
		}
		aimSocket.RelativeRotation = oldSocketRotation;
		if( bFound )
		{
			//DrawDebugLine(SocketLocation, SocketLocation + (Vector(SocketRotation) * 500), 255,0,0); 		
			return SocketRotation;
		}
	}

	//`log(" ChadAI - GetAdjustedAimFor No target - FELL THROUGH - FELL THROUGH - FELL THROUGH - FELL THROUGH - FELL THROUGH - FELL THROUGH -FELL THROUGH - " );
	
	return SocketRotation;//Pawn.GetBaseAimRotation();
	
}

// Not to C++
function Rotator old_GetAdjustedAimFor( Weapon W, vector StartFireLoc )
{
	local vector SocketLocation;
	local rotator SocketRotation;
	local vector aimLoc/*, randOffset*/;
	//local SPAIController spAI;
	//local float enemyDist, distCap, aimAlpha;
	//local rotator aimRot;
	local Box bbox;

	if ( Pawn != None )
	{
/*
				if (Enemy != None && Enemy == Target)
				{
					// aim at enemy base location
					aimLoc = m_playerList[m_enemyIdx].PerceivedLocation;
					enemyDist = VSize(Enemy.Location-Pawn.Location);
					if (enemyDist < AimMinAccuracyDistance)
					{
						distCap = 1.f;
					}
					else if (enemyDist >= AimMaxAccuracyDistance)
					{
						distCap = 0.1f;
					}
					else
					{
						distCap = 1.f - ((enemyDist - AimMinAccuracyDistance)/(AimMaxAccuracyDistance - AimMinAccuracyDistance));
					}
					// initial alpha based on time of last perceived location
					aimAlpha = FMin(WorldInfo.TimeSeconds - m_playerList[m_enemyIdx].LastPerceivedTime,AimLockonTime)/AimLockonTime;
					// if enemy isn't at cover,
					spAI = SPAIController(m_playerList[m_enemyIdx].Player);
					if (spAI != None && spAI.GetCurrentCoverType() == CT_None)
					{
						// increase accuracy slightly
						aimAlpha += 0.2f;
					}
					// cap the aim alpha
					aimAlpha = FMin(aimAlpha,distCap);
					// calculate final shot rotation
					randOffset = VRand() * VLerp(AimErrorMax,AimErrorMin,aimAlpha);
					aimRot = rotator((aimLoc + randOffset) - StartFireLoc);
		
					return aimRot;
				}
				
		else */
		if (Target != None)
		{
			// cheat and fire towards the target
			Target.GetComponentsBoundingBox(bbox);
			aimLoc = (bbox.Min + bbox.Max) * 0.5f;

			return Rotator(aimLoc - StartFireLoc);
		}
		//else if (Pawn.mesh.GetSocketWorldLocationAndRotation('AimSocket', SocketLocation, SocketRotation))
		else if (Pawn.mesh.GetSocketWorldLocationAndRotation(TPWeapon(W).MuzzleFlashSocket, SocketLocation, SocketRotation))
		{
			// just fire in the direction of the weapon
			return SocketRotation;
		}
		else
		{
			return Pawn.GetBaseAimRotation();
		}
	}
	return Rotation;
}


//***********************************************************************
// Aiming functions
//************************ - END SECTION - ******************************



//************************ - BEGIN SECTION - ****************************
// KISMET FUNCTIONS
//***********************************************************************

//-----------------------------------------------------------------------
// Function:	 OnAIForceTarget
// Description:  Kismet action that tells us to forcibly target a specific
//				 actor
//-----------------------------------------------------------------------
// Not to C++
function OnAIForceTarget(SeqAct_AIForceTarget Action)
{
	local array<Object> ObjVars;
	
	if( m_bGrappled )
	{
		;
		return;
	}

	
	
	Action.GetObjectVars(ObjVars,"Thing To Target");
	
	//`log(" ChadAI - TPAIController::OnAIForceTarget:: " @ ObjVars[0] @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		


	if (ObjVars.Length > 0)
	{
		if (Controller(ObjVars[0]) != None)
		{
			Target = Controller(ObjVars[0]).Pawn;
		}
		else
		{
			Target = Actor(ObjVars[0]);
		}
		
		//`log(" ChadAI - TPAIController::OnAIForceTarget::Target " @ Target @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		


		if( Action.bMakeEnemy )
		{
			//`log(" ChadAI - TPAIController::OnAIForceTarget::Action.bMakeEnemy " @ Action.bMakeEnemy @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
			;

			if( Controller(Target) != None )
			{
				NotifyEnemy( self, Controller(Target) );
				Enemy = Controller(Target).Pawn;
				m_enemyIdx = GetPlayerIdx(Enemy.Controller);
			}
			else if( Pawn(Target) != None )
			{
				NotifyEnemy( self, Pawn(Target).Controller );
				Enemy = Pawn(Target);
				m_enemyIdx = GetPlayerIdx(Enemy.Controller);
			}
		}


		;
	}
	else
	{
		Target = None;
	}
}


//-----------------------------------------------------------------------
// Function:	 OnAIClearInvalidCoverList
// Description:  Kismet action that tells us to forcibly target a specific
//				 actor
//-----------------------------------------------------------------------
// Not to C++
function OnAIClearInvalidCoverList(SeqAct_AIClearInvalidCoverList Action)
{
	local array<Object> ObjVars;
	Action.GetObjectVars(ObjVars,"Thing To Target");
	
	;		
}

//-----------------------------------------------------------------------
// Function:	 OnAIStartForceFireAtTarget
// Description:  Kismet action that tells us to start shooting at our
//				 target
//-----------------------------------------------------------------------
// Not to C++
function OnAIStartForceFireAtTarget(SeqAct_AIStartForceFireAtTarget Action)
{
	// abort any previous latent moves
	ClearLatentAction(class'SeqAct_AIStartForceFireAtTarget',true,Action);
	ClearMove();

	//`log(" ChadAI - Pawn: " @ Pawn @ " OnAIStartForceFireAtTarget-Target: " @ Target @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	if (Target != None)
	{
		;

		m_forcedFireDuration = Action.m_optionalDuration;
		m_forcedFireShotsLeft = Action.m_optionalNumberOfShots;
		m_Engagement_Tac_Data.m_bFireAtTargetReguardlessOfWhatItIs = Action.bFireAtTargetReguardlessOfWhatItIs;

		GotoState('ForceFireAtTarget');
	}
	else
	{
		;
	}
}

//-----------------------------------------------------------------------
// Function:	 OnAIStartForceAimAtTarget
// Description:  Kismet action that tells us to start shooting at our
//				 target
//-----------------------------------------------------------------------
// Not to C++
function OnAIStartForceAimAtTarget(SeqAct_AIStartForceAimAtTarget Action)
{
	// abort any previous latent moves
	ClearLatentAction(class'SeqAct_AIStartForceAimAtTarget',true,Action);
	ClearMove();
	KynapseClear(); // fix for NYBR6 panzershrek guy running in circles
	if (Target != None)
	{
		m_forcedFireDuration = Action.m_optionalDuration;

		PushState('ForceAimAtTarget');
	}
	else
	{
		;
	}
}

//-----------------------------------------------------------------------
// Function:	 OnAIDefendCover
// Description:  Kismet action that tells us to move to a cover node
//-----------------------------------------------------------------------
// Not to C++
function OnAIDefendCover(SeqAct_AIDefendCover inAction)
{
	local array<Object> objVars;

	if( m_bGrappled )
	{
		;
		return;
	}
	
	//`log(" ChadAI - OnAIUseFightingPosition:: called  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	//bMoved = false;
	//`AILOG(0, 'Move',"OnAIMoveToActor from Kismet Obj:"@inAction@"ObjName:"@inAction.ObjName@"ObjComment:"@inAction.ObjComment);

	ClearLatentAction(class'SeqAct_AIDefendCover',true,inAction);

	// if routing we need to not clear latent actions on these moves
	inAction.GetObjectVars(objVars,"Node to Defend From");
		
	//`log(" ChadAI - Moving NPC: " @ Pawn.Name @ " to: " @ objVars[0].Name @ " Slot: " @ inAction.SlotToStartToDefendFrom @ "  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		
	m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend.Link = TPCoverNode(objVars[0]);
	m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend.SlotIdx = inAction.SlotToStartToDefendFrom;

	// next check for a move to player
	if (Actor(objVars[0]) != None)
	{
		//`log(" ChadAI - Part2 - Setting state to MoveToAndDefendCoverGoal -s-s-s-s-s-s-s-s-s-s-s-s-s-s-s-ss-s--s-s");
		m_MoveToAndDefendCoverGoalInfo.m_TimeToDefendInSeconds = inAction.TimeToDefendInSeconds;
		m_MoveToAndDefendCoverGoalInfo.m_DurrationOfFiringBeforeHiding = inAction.DurationToFirePerCycle;
		m_MoveToAndDefendCoverGoalInfo.m_DurationOfHidingBeforeFiring = inAction.DurationToHidePerCycle;
		m_MoveToAndDefendCoverGoalInfo.m_DurationOfLookingForTargetBeforeEngageAttempt = inAction.DurationToLookForTargetBeforeEngageAttemptPerCycle;


		m_MoveToAndDefendCoverGoalInfo.m_bAllowWaitingForPathOrPositionToClear = inAction.bAllowWaitingForPathOrPositionToClear;
		m_MoveToAndDefendCoverGoalInfo.m_bAllowWanderingWhileWaiting = inAction.bAllowWanderingWhileWaiting;
		m_MoveToAndDefendCoverGoalInfo.m_TimeToWaitBetweenPathChecks = inAction.TimeToWaitBetweenPathChecks;

		//`log(" ChadAI - OnAIUseFightingPosition:: inAction.NoOfTimesToCheckForPathToCover: " @ inAction.NoOfTimesToCheckForPathToCover @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );


		m_MoveToAndDefendCoverGoalInfo.m_NoOfTimesToCheckForPathToCover = inAction.NoOfTimesToCheckForPathToCover;

		m_MoveToAndDefendCoverGoalInfo.m_bAllowAttackWhileWaitingForPathToClear = inAction.bAllowAttackWhileWaitingForPathToClear;

		m_MoveToAndDefendCoverGoalInfo.m_bTaskFailedWhenViolatedByDistenceToEnemy = inAction.bTaskFailedWhenViolatedByDistenceToEnemy;
		m_MoveToAndDefendCoverGoalInfo.m_bTaskFailedWhenViolatedByAngleToEnemy = inAction.bTaskFailedWhenViolatedByAngleToEnemy;

		m_MoveToAndDefendCoverGoalInfo.m_bTaskFailedWhenPathCanNotBeFound = inAction.bTaskFailedWhenPathCanNotBeFound;
		m_MoveToAndDefendCoverGoalInfo.m_bTaskFailedWhenCoverCanNotBeClaimed = inAction.bTaskFailedWhenCoverCanNotBeClaimed;


		//Force the current state to end!
		GotoState('MoveToAndDefendCoverGoal');
	}
	
	//`log(" ChadAI - OnAIUseFightingPosition:: call ENDED  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

}


//-----------------------------------------------------------------------
// Function:	 OnAIAttackUsingCover
// Description:  Kismet action that tells us to move to a cover node
//-----------------------------------------------------------------------
// Not to C++
function OnAIAttackUsingCover(SeqAct_AIAttackUsingCover inAction)
{
	local array<Object> objVars;

	if( m_bGrappled )
	{
		;
		return;
	}
	
	//`log(" ChadAI - OnAIAttackUsingCover:: called  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	//bMoved = false;
	//`AILOG(0, 'Move',"OnAIAttackUsingCover from Kismet Obj:"@inAction@"ObjName:"@inAction.ObjName@"ObjComment:"@inAction.ObjComment);

	;


	ClearLatentAction(class'SeqAct_AIAttackUsingCover',true,inAction);

	// if routing we need to not clear latent actions on these moves
	inAction.GetObjectVars(objVars,"Cover Group");
		
	//`log(" ChadAI - NPC: " @ Pawn.Name @ " using cover group: " @ objVars[0].Name @ "  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		
	m_AttackUsingCoverGoalInfo.m_CoverGroup= CoverGroup(objVars[0]);
	
	inAction.GetObjectVars(objVars,"Attack This");
		
	//`log(" ChadAI - Attacking: " @ objVars[1].Name @ "  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		
	if( objVars[1].IsA('Controller') )
	{
		//`log(" ChadAI - " @ objVars[1].Name @ " is a controller  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		m_AttackUsingCoverGoalInfo.m_TargetOfAttack = Controller(objVars[1]).Pawn;
	}
	else
	{
		//`log(" ChadAI - " @ objVars[1].Name @ " is NOT a controller  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );	
		
		m_AttackUsingCoverGoalInfo.m_TargetOfAttack = Actor(objVars[1]);
	}
		

	// next check for a move to player
	if (Actor(objVars[0]) != None)
	{
		//`log(" ChadAI - Part2 - Setting state to AttackUsingCoverGoal -s-s-s-s-s-s-s-s-s-s-s-s-s-s-s-ss-s--s-s");
		
		
		m_AttackUsingCoverGoalInfo.m_MinTimeToUseCoverInSeconds = inAction.MinTimeToUseCoverInSeconds;
		m_AttackUsingCoverGoalInfo.m_MaxTimeToUseCoverInSeconds = inAction.MaxTimeToUseCoverInSeconds;

		m_AttackUsingCoverGoalInfo.m_bUseCoverGroupToSlaughterMyCurrentEnemy = inAction.bUseCoverGroupToSlaughterMyCurrentEnemy;
		
		m_AttackUsingCoverGoalInfo.m_DurrationOfFiringBeforeHiding = inAction.DurationToFirePerCycle;
		m_AttackUsingCoverGoalInfo.m_DurationOfHidingBeforeFiring = inAction.DurationToHidePerCycle;
		m_AttackUsingCoverGoalInfo.m_DurationOfLookingForTargetBeforeEngageAttempt = inAction.DurationToLookForTargetBeforeEngageAttemptPerCycle;

		m_AttackUsingCoverGoalInfo.m_bUseCoverGroupTimer = inAction.bUseCoverGroupTimer;
		m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup = inAction.AmountOfTimeToStayInCoverGroup;

		m_AttackUsingCoverGoalInfo.m_bAllowWaitingForPathOrPositionToAnyValidCoverToClear = inAction.bAllowWaitingForPathOrPositionToAnyValidCoverToClear;
		m_AttackUsingCoverGoalInfo.m_bAllowWanderingWhileWaitingForPathToAnyValidCover = inAction.bAllowWanderingWhileWaitingForPathToAnyValidCover;
		m_AttackUsingCoverGoalInfo.m_TimeToWaitBetweenPathToAnyValidCoverChecks = inAction.TimeToWaitBetweenPathToAnyValidCoverChecks;
		m_AttackUsingCoverGoalInfo.m_NoOfTimesToCheckForPathToAnyValidCover = inAction.NoOfTimesToCheckForPathToAnyValidCover;
		m_AttackUsingCoverGoalInfo.m_bAllowAttackWhileWaitingForPathToAnyValidCoverToClear = inAction.bAllowAttackWhileWaitingForPathToAnyValidCoverToClear;
		m_AttackUsingCoverGoalInfo.m_bTaskFailedWhenPathToAnyValidCoverCanNotBeFound = inAction.bTaskFailedWhenPathToAnyValidCoverCanNotBeFound;

		//Force the current state to end!
		GotoState('AttackUsingCoverGoal');
	}
	
	//`log(" ChadAI - OnAIAttackUsingCover:: call ENDED  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

}


//-----------------------------------------------------------------------
// Function:	 OnAIBePinpointSniper
// Description:  Kismet action that tells us to move to a cover node
//-----------------------------------------------------------------------
// Not to C++
function OnAIBePinpointSniper(SeqAct_AIBePinpointSniper inAction)
{
	local array<Object> objVars;
	
	//`log(" ChadAI - OnAIBePinpointSniper:: called  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	// if routing we need to not clear latent actions on these moves
	inAction.GetObjectVars(objVars,"Snipe Loc");
	
	m_SniperInfo.m_SniperNest = Actor(objVars[0]);
	
	if( m_SniperInfo.m_SniperNest.IsA('TPCoverNode') )
	{
		m_SniperInfo.m_CoverToUseAsNest.Link = TPCoverNode(m_SniperInfo.m_SniperNest);
		m_SniperInfo.m_CoverToUseAsNest.SlotIdx = inAction.SlotToStartToBeAt;

		;
		
		//`log(" ChadAI - " @ m_SniperInfo.m_SniperNest @ " is a TPCoverNode using slot: " @ m_SniperInfo.m_CoverSlotToUse @ "  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
	}
	else
	{
		;

		//`log(" ChadAI - " @ m_SniperInfo.m_SniperNest @ " is NOT a TPCoverNode  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		// MESSAGEBOX NEEDED
		//m_SniperInfo.m_CoverSlotToUse = - 1;
	}
	
	m_SniperInfo.m_SniperType = SniperType_PinPoint;
					
	inAction.GetObjectVars(objVars,"Target Loc");
		
	//`log(" ChadAI - Attacking: " @ objVars[1].Name @ "  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		
	if( objVars[1].IsA('Actor') )
	{
		m_SniperInfo.m_TargetLoc = Actor(objVars[1]).Location;
			
		// next check for a move to player
		if (Actor(objVars[0]) != None)
		{			
			m_SniperInfo.m_TimeToBeSniperInSeconds = RandRange(inAction.MinTimeToBeSniperInSeconds, inAction.MaxTimeToBeSniperInSeconds);

			m_SniperInfo.m_SearchRange = inAction.SearchRange;
			m_SniperInfo.m_SearchRateUUnitsPerSec = inAction.SearchRateUUnitsPerSec;
			m_SniperInfo.m_MaxDirChangePerSec = inAction.MaxDirChangePerSec;
			m_SniperInfo.m_Accuracy = inAction.Accuracy;
			m_SniperInfo.m_RateOfFirePerMin = inAction.RateOfFirePerMin;
			m_SniperInfo.m_TargetAcquireRange = inAction.TargetAcquireRange;
			m_SniperInfo.m_TimeToWaitAfterLosingContact = inAction.TimeToWaitAfterLosingContact;
			m_SniperInfo.m_bDisplaySniperAimRay = inAction.bDisplaySniperAimRay;
			m_SniperInfo.m_DisplaySniperAimRaySearchingColor = inAction.DisplaySniperAimRaySearchingColor;
			m_SniperInfo.m_DisplaySniperAimRayAcquiredColor = inAction.DisplaySniperAimRayAcquiredColor;
			
			//`log(" ChadAI - Part2 - Setting state to BeASniperGoal -s-s-s-s-s-s-s-s-s-s-s-s-s-s-s-ss-s--s-s");

			m_SniperInfo.m_bAllowWaitingForPathOrPositionToClear = inAction.bAllowWaitingForPathOrPositionToClear;
			m_SniperInfo.m_bAllowWanderingWhileWaiting = inAction.bAllowWanderingWhileWaiting;
			m_SniperInfo.m_TimeToWaitBetweenPathChecks = inAction.TimeToWaitBetweenPathChecks;
			m_SniperInfo.m_NoOfTimesToCheckForPathToCover = inAction.NoOfTimesToCheckForPathToCover;
			m_SniperInfo.m_bAllowAttackWhileWaitingForPathToClear = inAction.bAllowAttackWhileWaitingForPathToClear;

			;


			//Force the current state to end!
			GotoState('BeASniperGoal');
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
	
	//`log(" ChadAI - OnAIBePinpointSniper:: call ENDED  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

}

native function VerifyAndFixSniperTrack();

//-----------------------------------------------------------------------
// Function:	 OnAIBeTrackSniper
// Description:  Kismet action that tells us to move to a cover node
//-----------------------------------------------------------------------
// Not to C++
function OnAIBeTrackSniper(SeqAct_AIBeTrackSniper inAction)
{
	local array<Object> objVars;
	
	//`log(" ChadAI - OnAIBeTrackSniper:: called  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	// if routing we need to not clear latent actions on these moves
	inAction.GetObjectVars(objVars,"Snipe Loc");
	
	m_SniperInfo.m_SniperNest = Actor(objVars[0]);
	
	if( m_SniperInfo.m_SniperNest.IsA('TPCoverNode') )
	{
		m_SniperInfo.m_CoverToUseAsNest.Link = TPCoverNode(m_SniperInfo.m_SniperNest);
		m_SniperInfo.m_CoverToUseAsNest.SlotIdx = inAction.SlotToStartToBeAt;

		;

		
		//`log(" ChadAI - " @ m_SniperInfo.m_SniperNest @ " is a TPCoverNode using slot: " @ m_SniperInfo.m_CoverSlotToUse @ "  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
	}
	else
	{
		;

		;
		//m_SniperInfo.m_CoverSlotToUse = - 1;
	}
	
	m_SniperInfo.m_SniperType = SniperType_Track;
						
	if( inAction.Track.Length > 0 )
	{
		m_SniperInfo.m_Track = inAction.Track;

		VerifyAndFixSniperTrack();

		if( m_SniperInfo.m_Track.Length > 0 )
		{
		
			//`log(" ChadAI - Attacking first target: " @ m_SniperInfo.m_Track[0].Name @ "  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

				
			// next check for a move to player
			if (Actor(objVars[0]) != None)
			{			
				m_SniperInfo.m_TimeToBeSniperInSeconds = RandRange(inAction.MinTimeToBeSniperInSeconds, inAction.MaxTimeToBeSniperInSeconds);

				//m_SniperInfo.m_SearchRange = inAction.SearchRange;
				m_SniperInfo.m_SearchRateUUnitsPerSec = inAction.SearchRateUUnitsPerSec;
				//m_SniperInfo.m_MaxDirChangePerSec = inAction.MaxDirChangePerSec;
				m_SniperInfo.m_Accuracy = inAction.Accuracy;
				m_SniperInfo.m_RateOfFirePerMin = inAction.RateOfFirePerMin;
				m_SniperInfo.m_TargetAcquireRange = inAction.TargetAcquireRange;
				m_SniperInfo.m_TimeToWaitAfterLosingContact = inAction.TimeToWaitAfterLosingContact;
				m_SniperInfo.m_bDisplaySniperAimRay = inAction.bDisplaySniperAimRay;
				m_SniperInfo.m_DisplaySniperAimRaySearchingColor = inAction.DisplaySniperAimRaySearchingColor;
				m_SniperInfo.m_DisplaySniperAimRayAcquiredColor = inAction.DisplaySniperAimRayAcquiredColor;
				m_SniperInfo.m_bLoopTrack = inAction.bLoopTrack;
				
				m_SniperInfo.m_bTrackingUp = true;
				m_SniperInfo.m_NextNodeOnTrack = 1;
				
				//`log(" ChadAI - Setting state to BeASniperGoal -s-s-s-s-s-s-s-s-s-s-s-s-s-s-s-ss-s--s-s");


				m_SniperInfo.m_bAllowWaitingForPathOrPositionToClear = inAction.bAllowWaitingForPathOrPositionToClear;
				m_SniperInfo.m_bAllowWanderingWhileWaiting = inAction.bAllowWanderingWhileWaiting;
				m_SniperInfo.m_TimeToWaitBetweenPathChecks = inAction.TimeToWaitBetweenPathChecks;
				m_SniperInfo.m_NoOfTimesToCheckForPathToCover = inAction.NoOfTimesToCheckForPathToCover;

				m_SniperInfo.m_bAllowAttackWhileWaitingForPathToClear = inAction.bAllowAttackWhileWaitingForPathToClear;

				;

				//Force the current state to end!
				GotoState('BeASniperGoal');
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
	else
	{
		;
	}
	
	//`log(" ChadAI - OnAIBeTrackSniper:: call ENDED  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

}

//-----------------------------------------------------------------------
// Function:	 OnAIPatrol
// Description:  Kismet action that tells us to move to a cover node
//-----------------------------------------------------------------------
// Not to C++
function OnAIPatrol(SeqAct_AIPatrol inAction)
{
}

//-----------------------------------------------------------------------
// Function:	 OnAIBeTerminator
// Description:  
//-----------------------------------------------------------------------
// Not to C++
function OnAIBeTerminator(SeqAct_AIBeTerminator inAction)
{
	local array<Object> objVars;
	local bool bidealRangeValid;
	
	//`log(" ChadAI - Pawn: " @ Pawn @ " OnAIBeTerminator:: called  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	// if routing we need to not clear latent actions on these moves
	inAction.GetObjectVars(objVars,"Start Loc");
	
	m_TerminatorInfo.m_StartLoc = Actor(objVars[0]);

	if( m_TerminatorInfo.m_StartLoc != None )
	{

		inAction.GetObjectVars(objVars,"Thing to Kill");

		if( Controller(objVars[1]) != None )
		{
			m_TerminatorInfo.m_AssignedThingToKill = Controller(objVars[1]).Pawn;
		}


		//`log(" ChadAI - Pawn: " @ Pawn @ " OnAIBeTerminator:: m_AssignedThingToKill: " @ m_TerminatorInfo.m_AssignedThingToKill @ "  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );



		m_TerminatorInfo.m_Accuracy					= inAction.m_Accuracy;
		m_TerminatorInfo.m_RateOfFirePerMin			= inAction.m_RateOfFirePerMin;
		m_TerminatorInfo.m_UseAgainstCurrentEnemy	= inAction.m_UseAgainstCurrentEnemy;

		m_TerminatorInfo.m_MinTimeToTerminate		= inAction.m_MinTimeToTerminate;
		m_TerminatorInfo.m_MaxTimeToTerminate		= inAction.m_MaxTimeToTerminate;

		if( m_TerminatorInfo.m_MinTimeToTerminate < 0.0f && m_TerminatorInfo.m_MaxTimeToTerminate < 0.0f )
		{
			m_TerminatorInfo.m_ActualTimeToTerminate = -1.0;
		}
		else
		{
			m_TerminatorInfo.m_ActualTimeToTerminate = RandRange(inAction.m_MinTimeToTerminate, inAction.m_MaxTimeToTerminate);
		}

		m_TerminatorInfo.m_MinTimeToStandAndShoot = inAction.m_MinTimeToStandAndShoot;
		m_TerminatorInfo.m_MaxTimeToStandAndShoot = inAction.m_MaxTimeToStandAndShoot;
			
		m_TerminatorInfo.m_DistanceToLookForCoverSlot = inAction.m_DistanceToLookForCoverSlot;

		m_TerminatorInfo.m_MinDistanceToBeFromEnemy = inAction.m_MinDistanceToBeFromEnemy;
		m_TerminatorInfo.m_MaxDistanceToBeFromEnemy = inAction.m_MaxDistanceToBeFromEnemy;
		m_TerminatorInfo.m_IdealDistanceToBeFromEnemy = inAction.m_IdealDistanceToBeFromEnemy;

		m_TerminatorInfo.m_MaxDistanceToMoveFromStartLoc = inAction.m_MaxDistanceToMoveFromStartLoc;

		m_TerminatorInfo.m_SuppressionCheckDistance = inAction.m_SuppressionCheckDistance;
		
		//`log(" ChadAI - Pawn: " @ Pawn @ " Setting state to AttackAsTerminatorGoal -s-s-s-s-s-s-s-s-s-s-s-s-s-s-s-ss-s--s-s");

		bidealRangeValid = true;

		if( m_TerminatorInfo.m_IdealDistanceToBeFromEnemy <  m_TerminatorInfo.m_MinDistanceToBeFromEnemy )
		{
			bidealRangeValid = false;
			;

		}

		if( m_TerminatorInfo.m_IdealDistanceToBeFromEnemy >  m_TerminatorInfo.m_MaxDistanceToBeFromEnemy )
		{
			bidealRangeValid = false;
			;
		}

		if( bidealRangeValid )
		{
			//Force the current state to end!
			GotoState('AttackAsTerminatorGoal');
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
	
	//`log(" ChadAI - Pawn: " @ Pawn @ " OnAIBeTerminator:: call ENDED  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

}


//-----------------------------------------------------------------------
// Function:	 OnAIMantleCover
// Description:  Kismet action that tells us to move to a cover node
//-----------------------------------------------------------------------
// Not to C++
function OnAIMantleCover(SeqAct_AIMantleCover inAction)
{
	local array<Object> objVars;
	
	//`log(" ChadAI - OnAIMantleCover:: called  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	// if routing we need to not clear latent actions on these moves
 	inAction.GetObjectVars(objVars,"Node to Mantle");

 	
 	if( (objVars[0]).IsA( 'TPCoverNode' ) )
 	{
		;

		//`log(" ChadAI - OnAIMantleCover:: objVars[0].IsA( 'TPCoverNode' )  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		m_MantleGoalInfo.m_PlaceToMantle.Link = TPCoverNode(objVars[0]);
 		m_MantleGoalInfo.m_PlaceToMantle.SlotIdx = inAction.SlotToMantleFrom;
 	
	
		m_MantleGoalInfo.m_bAllowWaitingForPathOrPositionToClear = inAction.bAllowWaitingForPathOrPositionToClear;
		m_MantleGoalInfo.m_bAllowWanderingWhileWaiting = inAction.bAllowWanderingWhileWaiting;
		m_MantleGoalInfo.m_TimeToWaitBetweenPathChecks = inAction.TimeToWaitBetweenPathChecks;
		m_MantleGoalInfo.m_NoOfTimesToCheckForPathToCover = inAction.NoOfTimesToCheckForPathToCover;

		m_MantleGoalInfo.m_bAllowAttackWhileWaitingForPathToClear = inAction.bAllowAttackWhileWaitingForPathToClear;

		m_MantleGoalInfo.m_JumpDownHorizontalOutDuration = inAction.JumpDownHorizontalOutDuration;
		m_MantleGoalInfo.m_JumpDownMinVirticalDist = inAction.JumpDownMinVirticalDist;

	}
 	else
 	{
		;
		; 
	}
 	
 	m_MantleGoalInfo.m_MantleActionToPerform = inAction.MantleAction;
 	
	GotoState('MantleCoverGoal');
	
	//`log(" ChadAI - OnAIMantleCover:: call ENDED  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

}


//-----------------------------------------------------------------------
// Function:	 OnAIRappel 
// Description:  Kismet action that tells us to move to a point and then reppel
//-----------------------------------------------------------------------
// Not to C++
function OnAIRappel(SeqAct_AIRappel inAction)
{
	local array<Object> objVars;
	
	//`log(" ChadAI - OnAIRappel:: called  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	// if routing we need to not clear latent actions on these moves
 	inAction.GetObjectVars(objVars,"Rappel From");
 	
 	m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.Link = TPCoverNode(objVars[0]);
 	 	
	GotoState('RappelGoal');
	
	//`log(" ChadAI - OnAIRappel:: call ENDED  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

}

//-----------------------------------------------------------------------
// Function:	 OnAIPerformCustomCoverBehavior 
// Description:  Kismet action that tells us to perform a cover sub behavior
//-----------------------------------------------------------------------
// Not to C++
function OnAIPerformCustomCoverBehavior(SeqAct_AIPerformCustomCoverBehavior inAction)
{
	local ScriptedCoverBehaviorData newData;
	
	//`log(" ChadAI - OnAIPerformCustomCoverBehavior:: called  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	newData.m_Behavior  = inAction.BehaviorToPerform;
	newData.m_TimeToPerformInSec  = inAction.TimeToPerformInSeconds;
	newData.m_bOverRideNonScriptedDurations = inAction.bOverRideNonScriptedDurations;

	m_CoverMoveData.m_QueueOfScriptedCoverBehaviors[m_CoverMoveData.m_QueueOfScriptedCoverBehaviors.Length] = newData;
		
	ClearLatentAction(class'SeqAct_AIPerformCustomCoverBehavior',false);

	;
	
	//`log(" ChadAI - OnAIPerformCustomCoverBehavior:: call ENDED  Beh: " @ newData.m_Behavior @ " Time: " @ newData.m_TimeToPerformInSec @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

}

//***********************************************************************
// KISMET FUNCTIONS
//************************ - END SECTION - ******************************



//************************ - BEGIN SECTION - ****************************
// MISC functions
//***********************************************************************

//
// When we decide whether or not we want to fire at an enemy, we can't consider where we are
// right now, because we are behind cover and will for sure not have line of sight.  So this
// function figures out how much to the side we are going to do the line of fire check for.
//
// To C++
function Vector FigureOutLineOfFireOffset( CoverInfo TheSlotInfo )
{
	local	int						theSlotID;
	local	TPCoverNode				theCoverNode;
//		local	Vector					theSlotPos;
	local	Rotator					theSlotRot;
	local	float					theLeanDist;
	local	Vector					offset;
	local	CoverLink.ECoverAction	CA;
	local	Vector					sideVect;
	local	Vector					upVect;

	if( TheSlotInfo.Link == None)
	{
		;
		return ( offset );	
	}

	theSlotID		= TheSlotInfo.slotIDX;
	theCoverNode	= TPCoverNode(TheSlotInfo.Link);//.slots[theSlotID]);

	//
	// Ask the node for the location and rotation of the cover link.  This should give us
	// the values in world space.
	//
//		theSlotPos = theCoverNode.GetSlotLocation( theSlotID );
	theSlotRot = theCoverNode.GetSlotRotation( theSlotID );

	//
	// We now must check to see if this slot is to the left, right, or up.
	// If it can be both to the left and right, we have to check to see what the soldier is doing.
	//
	theLeanDist = theCoverNode.slots[theSlotID].LeanTraceDist;

	//`log( "JohnAI - TPSoldierAIController::UseFightingPosition::FigureOutLineOfFireOffset() theLeanDist is " $ theLeanDist );

	if ( theCoverNode.slots[theSlotID].bCanPopUp == true )
	{
		//`log( "JohnAI - TPSoldierAIController::UseFightingPosition::FigureOutLineOfFireOffset() bCanPopUp == true" );

		offset.X = 0;
		offset.Y = 0;
		offset.Z = theLeanDist;

		return ( offset );
	}

	//
	// Figure out which side, move that amount, and then rotate so it corresponds to the orientation of the slot.
	//
	else
	{
		upVect.x = 0;
		upVect.y = 0;
		upVect.z = 1;

		sideVect = upVect Cross Vector( theSlotRot );
		sideVect = Normal( sideVect );
		sideVect *= (theLeanDist + 0);

		if ( (theCoverNode.slots[theSlotID].bLeanLeft == true) && (theCoverNode.slots[theSlotID].bLeanRight == true) )
		{
			CA = GetCurrentCoverAction();

			if ( (CA == CA_BlindLeft) || (CA == CA_LeanLeft) || (CA == CA_StepLeft) || (CA == CA_PeekLeft) )
			{
				//`log( "JohnAI - TPSoldierAIController::UseFightingPosition::FigureOutLineOfFireOffset() LeftAction" );
				offset = -sideVect;
			}

			else
			{
				//`log( "JohnAI - TPSoldierAIController::UseFightingPosition::FigureOutLineOfFireOffset() RightAction" );
				offset = sideVect;
			}
		}

		else if ( theCoverNode.slots[theSlotID].bLeanLeft == true )
		{
			//`log( "JohnAI - TPSoldierAIController::UseFightingPosition::FigureOutLineOfFireOffset() Left" );
			offset = -sideVect;
		}

		else
		{
			//`log( "JohnAI - TPSoldierAIController::UseFightingPosition::FigureOutLineOfFireOffset() Right" );
			offset = sideVect;
		}

		//`log( "JohnAI - TPSoldierAIController::UseFightingPosition::FigureOutLineOfFireOffset() offset is (" $ offset.x $ ", " $ offset.y $ ", " $ offset.z $ ")" );
		return ( offset );
	}
}



// To C++
// function MarkEnemyHostile(bool bHostile, optional int enemyIdx=-1)
// {
// 	local int idx;
// 	
// 	if( enemyIdx != -1 )
// 	{
// 		idx = enemyIdx;
// 	}
// 	else if( m_enemyIdx != -1 )
// 	{
// 		idx = m_enemyIdx;
// 	}
// 	
// 	if( idx == -1 )
// 		return;
// 
// 	`AILOG(3, 'Sensory',"Pawn:"@m_playerList[idx].Player.GetPawnName(true) @ " is being marked Hostile! " );
// 
// 
// 	m_playerList[idx].bHostile = bHostile;
// }

// Not to C++
function SetDestructibleTarget(Actor destructibleTarget)
{
	//TP STUB DESTRUCTIBLE TARGET
	return;
}

//***********************************************************************
// MISC functions
//************************ - END SECTION - ******************************



//************************ - BEGIN SECTION - ****************************
// PUSHABLE STATES - States that are used to stack on top of current state
//***********************************************************************


//-----------------------------------------------------------------------
// State:		MoveToActorGoalWhileAttacking
// Description:
//-----------------------------------------------------------------------
state MoveToActorGoalWhileAttacking extends MoveToActorGoal
{
	ignores NotifyBump;

	// We may want to increase this in the future if this causes too many failed pathing attempts
	// Not to C++
	function int GetMoveGoalNumTries()
	{
		//return 0;
		return 1;
	}

	// Not to C++
	function BeginState(Name PreviousStateName)
	{
		SetDestructibleTarget(none);
		super(MoveToActorGoal).BeginState(PreviousStateName);
	}

	// Not to C++
	function EndState(Name NextStateName)
	{
		super(MoveToActorGoal).EndState(NextStateName);
		//super.EndState(NextStateName);

		StopFiring();
		Target = None;
		Focus = None;
		SetDestructibleTarget(none);
	}

	// Not to C++
	function PoppedState()
	{
		super(MoveToActorGoal).PoppedState();
		//super.PoppedState();
		StopFiring();
		Target = None;
		Focus = None;
		SetDestructibleTarget(none);
	}

	// Not to C++
	//Per state overridable update function...
	function MoveToGoalTimerUpdate()
	{
//TP OUT - SHOOTING DESTRUCTIBLE TARGETS
//		m_DestructibleTarget = GetBestDestructibleTarget();
//
//		if (m_DestructibleTarget != none && !m_DestructibleTarget.bDeleteMe && Pawn != none &&
//			VSize(m_DestructibleTarget.Location - Pawn.Location) < `DESTRUCTIBLETARGET_CLOSE_DIST
//			)
//		{
//			PushState('ShootAtObstacle');
//		}
//		else if (IsReloading())
//		{
//			//`AILOG(0, 'MoveToGoalTimerUpdate',"IsReloading");
//			//Kelly Removed this to fix reloading
//			//Target = None;
//
//			Focus = None;
//			FocalPoint = Destination;
//			// FIXME: Why this? -> StopFiring();
//			StopFiring();
//		}
//		else if( m_DestructibleTarget != None)
//		{
//			if( /*m_DestructibleTarget.Health >0 &&*/ !m_DestructibleTarget.bDeleteMe )
//			{
//				Target = m_DestructibleTarget;
//				//Focus = m_DestructibleTarget;
//				//FocalPoint = m_DestructibleTarget.Location;
//				Focus = None;
//				FocalPoint = Destination;
//
//				if (ShouldIFire())
//					StartFiring();
//				else
//					StopFiring();
//			}
//			else
//			{
//				SetDestructibleTarget(none);
//				Target = None;
//				Focus = None;
//				StopFiring();
//				FocalPoint = Destination;
//			}
//
//		}
//		else if (HasValidEnemy() || CheckForEnemy())
		/* hack!!! make Kynapse pawns work!
		*/
		if (HasValidEnemy() || CheckForEnemy(false))
		{
			//TP OUT - ENEMY POTENTIALLY VISIBLE
			//if (IsEnemyPotentiallyVisible(true))
			if (true)
			{
				Target = Enemy;
				Focus = Enemy;
				FocalPoint = Enemy.Location;
				if (ShouldIFire())
				{
					
						TP_AiStartFiring();
					


				}
				else
				{
					//`AILOG(0, 'MoveToGoalTimerUpdate',"gun not facing right direction");
					StopFiring();
				}
			}
			else
			{
				Target = None;
				Focus = None;
				StopFiring();
				FocalPoint = Destination;
				//`AILOG(0, 'MoveToGoalTimerUpdate',"target not visible");
			}
		/* hack!!! make Kynapse pawns work!
		*/
		}
		else
		{
			Target = None;
			Focus = None;
			FocalPoint = Destination;
			StopFiring();
			//`AILOG(0, 'MoveToGoalTimerUpdate',"no valid target");
		}


//		SearchForObstacles();

	}

	//Overridden from SPAIController::MoveToGoal
	function float GetMoveStepAsideDelayTime()
	{
		//return (RandRange(0.2f,0.7f));
		return (0.f);
	}

}


//***********************************************************************
// PUSHABLE STATES
//************************ - END SECTION - ******************************


//************************ - BEGIN SECTION - ****************************
// AI STATES
//***********************************************************************


auto state WaitingForPawn
{
	// THIS FUNCTION IS CALLED WHEN THE PAWN IS POSSESSED BY THIS CONTROLLER
	// PUT ANY ONE-TIME INITIALIZATION CODE HERE
	// Not to C++
	function Possess(Pawn aPawn, bool bVehicleTransition)
	{
		Super.Possess(aPawn, bVehicleTransition);

		//log(self @ "TPWehrmachtAIController::WaitingForPawn::Possess");
	    //anode_AIM = AnimNodeAimOffset(Pawn.Mesh.Animations.FindAnimNode('AIM_NODE'));
	}

}

state Parachuting
{
	// Not to C++
    function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		++BurstCount;
		if (BurstCount >= TPWeapon(Pawn.Weapon).BulletsPerBurst)
		{
            TotalTime = 0;
			BurstCount = 0;
            StopFiring();
            PushState ('ParachutingBurstFireWait');
		}
    }

	// Not to C++
    event Tick(float DeltaTime)
    {
        super.Tick(DeltaTime);

        UpdateAimInTheOpen(FALSE);;

        TotalTime += DeltaTime;
        if (TotalTime > 0.1)
        {
            TotalTime = 0;

            if (CheckForEnemy(false) || HasValidEnemy())
		    {
                if (ShouldIAttackEnemy() && CanFireAtNotFromCover(Enemy) && ShouldIFire())
                {
                    //MarkEnemyHostile(true);
                    Target = Enemy;

					
						TP_AiStartFiring();
					


                }
		    }
        }
    }
//Begin:
//    while (true)
//    {
//`log ("AL-> begin!" @ WorldInfo.TimeSeconds);
//        sleep(0.1);
//    }
}

state ParachutingBurstFireWait extends Parachuting
{
	// Not to C++
    function NotifyWeaponFired(Weapon W, byte FireMode)
    {
        // Do nothing
    }

	// Not to C++
    function Tick (float DeltaTime)
    {
        FocalPoint = (20*DescentFocalPoint) + Pawn.Location;
        ClearMove();
        Pawn.Velocity = DescentVelocity;

        TotalTime += DeltaTime;
        if (TotalTime > TPWeapon(Pawn.Weapon).BurstDelayMin)
        {
            TotalTime = 0;
            PopState();
        }
    }
}


state Idle
{
	// Not to C++
	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
	
		//`log(" ChadAI - " @ self @ "Idle::OnSeeEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
		CheckForEnemy(false);
		// acquire as a new enemy and evaluate the situation
// 		if (CheckForEnemy(false) && ShouldIAttackEnemy() )
// 		{
// 		
// 			//`log(" ChadAI - " @ self @ "Idle::OnSeeEnemy I am EvaluateSituation because I found an enemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
// 			`AILOG(2, 'Idle', "OnSeeEnemy and CheckForEnemy is true so EvaluateSituation ");
// 			EvaluateSituation();
// 			//log(self @ "My new enemy is" @ Enemy);
// 		}
	}
	
	// Not to C++
	event OnHearEnemy(int playerIdx)
	{
		//`log(" ChadAI - " @ self @ "Idle::OnHearEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		CheckForEnemy(false);
// 		if (CheckForEnemy(false) && ShouldIAttackEnemy() )
// 		{
// 			//`log(" ChadAI - " @ self @ "Idle::OnHearEnemy I am EvaluateSituation because I found an enemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
// 			`AILOG(2, 'Idle', "OnHearEnemy and CheckForEnemy is true so EvaluateSituation ");
// 			EvaluateSituation();
// 			//log(self @ "My new enemy is" @ Enemy);
// 		}		
	}

	// Not to C++
	event Tick( float DeltaTime )
	{
		//UpdateAimInTheOpen(FALSE);;
		SetAimToStrightAhead();
		UpdateHeadtracking();

		// Don't do all these expensive checks when we just spawn into the world.
		if ( JustSpawned == false )
		{
			if (anode_WeaponBlend != none)
			{
				if (Pawn == none || Pawn.Weapon == none)
					anode_WeaponBlend.SetBlendTarget(1.0, 0.2);
				else
					anode_WeaponBlend.SetBlendTarget(0.0, 0.2);
			}

			if( TestForValidWanderTarget() )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " TPAIController::WanderAround::Tick   TestForValidWanderTarget = true -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
				;

			}
		}
		//Super.Tick(DeltaTime);
	}

	function float GetRandomWaitTime()
	{
		local	float	delay;
		local	int		resolution;
		local	int		min;
		local	int		max;

		// Give the delay a resolution to 0.01 seconds.
		resolution = 100;

		min = 0* resolution;
		max = 1* resolution;

		delay = Rand( max - min );
		delay += min;
		delay /= resolution;

		return delay;
	}

Begin:
	m_SubStateDebugInfoTag="Begin";

	while( true )
	{
		if ( JustSpawned )
		{
			Sleep( GetRandomWaitTime() );
			JustSpawned = false;
		}
		else
			Sleep(0.0);
		StopFiring();
		if( Enemy != None )
		{
			EvaluateSituation();
		}
	}
}

// Not to C++
function bool IsUnderFire()
{
	//TP STUB COVER FIRE
	return false;
}


state BurstFireWait
{

// Not to C++
	event Tick( float DeltaTime )
	{
		//`log(" ChadAI - TPSoldierAIController::BurstFireWait::Tick -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		
		// If able to do melee attacks and the enemy is in range pop this state so hopefully the owner state will handle
		// switching to melee attack
		if( DetermineIfShouldStartCQB_Tick( WorldInfo.TimeSeconds ) )
		{
			//`log(" ChadAI - TPSoldierAIController::BurstFireWait::Tick:: EnemyIsInRange  m_MeleeRangeOfAttack -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			
			PopState();
		}

		UpdateAimInTheOpen(FALSE);;
		UpdateHeadtracking();
		Super.Tick(DeltaTime);
	
	}


Begin:

	m_SubStateDebugInfoTag="Begin";

	// delay if end of burst
	if (Pawn != None && Pawn.Weapon != None)
	{
		StopFiring();
		Sleep(RandRange(TPWeapon(Pawn.Weapon).BurstDelayMin, TPWeapon(Pawn.Weapon).BurstDelayMax));

        if (ShouldIFire())
		{
			
				TP_AiStartFiring();
			


		}
	}
	
	PopState();
}

// if not facing the enemy when want to face cover
native final function bool ReachedDesiredRotationAtCoverAndSetRotDirection( bool bFaceEnemy, CoverInfo CoverToTest );

//-----------------------------------------------------------------------
// State:
// Description:	Utility state, handles a basic firing pattern from cover.
//-----------------------------------------------------------------------
state Fire_From_Cover_Slot
{
	// Not to C++
    function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		if (Pawn != None && Pawn.Weapon != None )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " Fire_From_Cover_Slot::NotifyWeaponFired GetAmmoInMagazine(): " @ TPWeapon(Pawn.Weapon).GetAmmoInMagazine()  @" -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

			if( TPWeapon(Pawn.Weapon).GetAmmoInMagazine() <= 0 )
			{
				;
				m_Engagement_Tac_Data.m_bNeedToReloadAtNextOpertunity = true;
			}

			++BurstCount;

			if( !m_CoverFightData.m_HaveFiredAtLeastOneRoundThisFireStateSubMove )
			{
				if (BurstCount >= TPWeapon(Pawn.Weapon).BulletsPerBurst)
				{
					m_CoverFightData.m_HaveFiredAtLeastOneRoundThisFireStateSubMove = true;
				}
			}

			if (BurstCount >= TPWeapon(Pawn.Weapon).BulletsPerBurst)
			{
				BurstCount = 0;
			}

		}    
	}

	// Not to C++
	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " Fire_From_Cover_Slot::NotifyTakeHit and m_CoverMoveData.m_CoverState = CoverState_GettingHit -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		;

		// if at open field slot set flag to take tactical evasion movement
		m_Engagement_Tac_Data.m_bTookHit = true;
		m_Engagement_Tac_Data.m_LastTimeKnewTookHit = WorldInfo.TimeSeconds;


		Super.NotifyTakeHit(InstigatedBy,HitLocation,Damage,damageType,Momentum);		
	}

	// Not to C++
	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
	
		//`log(" ChadAI - " @ self @ "Fire_From_Cover_Slot::OnSeeEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
	
		// acquire as a new enemy and evaluate the situation
		CheckForEnemy(false);
	}
	
	// Not to C++
	event OnHearEnemy(int playerIdx)
	{
		//`log(" ChadAI - " @ self @ "Fire_From_Cover_Slot::OnHearEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		CheckForEnemy(false);		
	}

	// Not to C++
	event Tick( float DeltaTime )
	{
		//`log(" ChadAI - TPSoldierAIController::Fire_From_Cover_Slot::Tick  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
				
		UpdateAimAtCover();
		UpdateHeadtracking();

		if (anode_WeaponBlend != none)
		{
			if (Pawn == none || Pawn.Weapon == none)
				anode_WeaponBlend.SetBlendTarget(1.0, 0.2);
			else
				anode_WeaponBlend.SetBlendTarget(0.0, 1.0);
		}

		//Super.Tick(DeltaTime);
	}	

	// Not to C++
	function BeginState(Name PreviousStateName)
	{
		;
		m_CoverMoveData.m_CoverState = CoverBehavior_Firing;
		m_CoverMoveData.m_TimeStartedFiringSinceLastHidingState = WorldInfo.TimeSeconds;
		//`log(" ChadAI - TPSoldierAIController::Fire_From_Cover_Slot::BeginState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
	}
	

	// Not to C++
	function EndState(Name NextStateName)
	{
		//`log(" ChadAI - TPSoldierAIController::Fire_From_Cover_Slot::EndState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		
		if( m_CoverMoveData.m_CurrentCover_Clamied.Link != None && m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType == CT_MidLevel )
		{
			if( m_Engagement_Tac_Data.m_bTookHit || m_Engagement_Tac_Data.m_bKnowBeingAimedAt )
			{
				m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_HideFromFire;
				m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;
				;
			}
			else
			{
				m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_FiringToHiding;
				m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;
				;
			}
		}
		else
		{
			m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_FiringToHiding;
			m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;
			;
		}

		if( TPPawn(Pawn) != None )
		{
			TPPawn(Pawn).m_bGoingLowAtHighCornerCover = false;
		}

		StopFiring();
				
	}

	// Not to C++
	event PushedState()
	{
		;

		m_CoverMoveData.m_CoverState = CoverBehavior_Firing;

		//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Fire_From_Cover_Slot PushedState DesiredRotation : " @ DesiredRotation.Yaw @ " - Pawn Rot: " @ Pawn.Rotation.Yaw @ "Pawn.DesiredRotation : " @ Pawn.DesiredRotation.Yaw @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		//`log(" ChadAI - TPSoldierAIController::Fire_From_Cover_Slot::PushedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}
	
	// Not to C++
	event PausedState()
	{
		;

		StopFiring();

		//`log(" ChadAI - TPSoldierAIController::Fire_From_Cover_Slot::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	// Not to C++
	event ContinuedState()
	{
		HandleAtCoverCollisionChange( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos );

		//`log(" ChadAI - TPSoldierAIController::Fire_From_Cover_Slot::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 		if( !IsAtCover(m_CoverFightData.m_CurrentlyCoverToUseAsFightPos, false ) )
// 		{
// 			//`log(" ChadAI - TPSoldierAIController::Fire_From_Cover_Slot::ContinuedState Not At Cover So Going Back to Parent State PopState-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 			`AILOG(1, 'Fire_From_Cover_Slot', "ContinuedState Not At Cover So Going Back to Parent State PopState");
// 
// 			PopState();
// 		}
// 		else
// 		{
// 			`AILOG(1, 'Fire_From_Cover_Slot', "ContinuedState and still At Cover So continue to fire");
// 		}

		PopState();
	}

	// Not to C++
	event PoppedState()
	{
		;

		StopFiring();

		HandleLeftCoverCollisionChange( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos );

		if( TPPawn(Pawn) != None )
		{
			TPPawn(Pawn).m_bGoingLowAtHighCornerCover = false;
		}
	}

Begin:

	m_SubStateDebugInfoTag="Begin";

	//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Fire From Cover - Before Loop m_CoverMoveData.m_CoverTransitionAction = " @ m_CoverMoveData.m_CoverTransitionAction @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	


	m_CoverMoveData.m_CoverState = CoverBehavior_Firing;
	m_CoverFightData.m_HaveFiredAtLeastOneRoundThisFireStateSubMove = false;
	m_Engagement_Tac_Data.m_bTookHit = false;
	m_CoverMoveData.m_TimeStartedFiringSinceLastHidingState = WorldInfo.TimeSeconds;

	m_Engagement_Tac_Data.m_bNeedToReloadAtNextOpertunity = false;
	
	//`log(" ChadAI - Pawn: " @ Pawn @ " Fire_From_Cover_Slot::Begin - m_CoverMoveData.m_CoverState: " @ m_CoverMoveData.m_CoverState @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	//m_bInvalidFireState = false;
	StopFiring(); // tell the wep to stop firing
	//Target = None;
	;

	//`log(" ChadAI - Pawn: " @ Pawn @ " Fire_From_Cover_Slot::SettingPosture  SetCoverAction Getting Called -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


	if( m_CoverFightData.m_bBlindFire )
	{

		//`log(" ChadAI - Pawn: " @ Pawn @ " Fire_From_Cover_Slot bind firing m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_HidingToBlindFiring -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_HidingToBlindFiring;
		m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;

		//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Blind Fire - Before Loop m_CoverMoveData.m_CoverTransitionAction = " @ m_CoverMoveData.m_CoverTransitionAction @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		SetCoverAction(m_CoverMoveData.m_CurrentCover_Clamied, true);

		if( Pawn != None && Pawn.Weapon != None && TPWeapon(Pawn.Weapon) != None )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " BlindFire::Begin - WeapCategory: " @ TPWeapon(Pawn.Weapon).WeapCategory @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			if( TPWeapon(Pawn.Weapon).m_bShouldUseSnapShotInsteadOfBlindFire )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " BlindFire::Begin - WeapCategory: " @ TPWeapon(Pawn.Weapon).WeapCategory @ " so going to BlindFireWithBattleRifle -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				Goto('BlindFireWithBattleRifle');
			}
		}

	}
	else
	{
		if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType	!= CT_OpenFieldStanding  )  &&
			( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldMidLevel ) )
		{
			m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_HidingToFiring;
			m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;
		}
		else if( m_CoverFightData.m_bNeedToPlayOpenFieldTransToFiring )
		{
			m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_HidingToFiring;
			m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;
			m_CoverFightData.m_bNeedToPlayOpenFieldTransToFiring = false;
		}

		SetCoverAction(m_CoverMoveData.m_CurrentCover_Clamied, false);
	}

	HandleAtCoverCollisionChange( m_CoverMoveData.m_CurrentCover_Clamied );

	if( m_CoverFightData.m_PreviousCoverAction != m_CoverFightData.m_CurrentCoverAction )
	{
		//ShiftPawnPositionBasedUponCoverAction( m_CoverMoveData.m_CurrentCover_Clamied, m_CoverFightData.m_CurrentCoverAction, CoverBehavior_Firing);
	}

	m_SubStateDebugInfoTag="Trans out";
	while(( m_CoverMoveData.m_CoverTransitionAction != CoverTransitionAction_NotTransitioning ) &&
		( (WorldInfo.TimeSeconds - m_CoverFightData.m_TimeStartedLastCoverTransition) < class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_MaxTimeToWaitForCoverTransitionToEnd ) )
	{
		Sleep(0.0);
	}

	//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Fire_From_Cover_Slot after trans out DesiredRotation : " @ DesiredRotation.Yaw @ " - Pawn Rot: " @ Pawn.Rotation.Yaw @ "Pawn.DesiredRotation : " @ Pawn.DesiredRotation.Yaw @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


Fire_From_Cover_SlotLoop:

	m_SubStateDebugInfoTag="Top of Loop";

	if( DoINeedToSlideIntoTheSlot( m_CoverMoveData.m_CurrentCover_Clamied ) )
	{
		SlideMeALIttleBitFatherIntoTheSlot(class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_DistToSlideIntoCoverWhileInCoverPerUpdate, m_CoverMoveData.m_CurrentCover_Clamied);
		//Sleep(0.0);
	}

	if( Enemy != None )
	{
		m_SubStateDebugInfoTag="Top of Loop and Has Enemy: " @ (WorldInfo.TimeSeconds - m_CoverMoveData.m_TimeStartedFiringSinceLastHidingState) @ " -> " @ m_CoverMoveData.m_CurrentDurrationOfFiringBeforeHiding;

		Target = Enemy;
		
		//`AILOG(0, 'Begin', "Turn towards target");
		// turn towards our target
		Focus = Target;

		
		// wait til the turn is finished
		m_SubStateDebugInfoTag="Turning to Target";

		DesiredRotation = rotator(Focus.Location - Pawn.Location);
		DesiredRotation.Pitch = 0;
		Pawn.DesiredRotation = DesiredRotation;

		//Rotate Pawn Slowly to face in the right direction
		while( !ReachedDesiredRotationAtCoverAndSetRotDirection(true, m_CoverMoveData.m_CurrentCover_Clamied) )
		{
			;
			//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Fire_From_Cover_Slot Has not reached desired rot m_bSlowRotRight: " @ m_CoverFightData.m_bSlowRotRight @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::HideBehindCurrentCover::Begin:: - SnapToCurrentCover Being Called PopState-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			if( DoINeedToSlideIntoTheSlot( m_CoverMoveData.m_CurrentCover_Clamied ) )
			{
				SlideMeALIttleBitFatherIntoTheSlot(class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_DistToSlideIntoCoverWhileInCoverPerUpdate, m_CoverMoveData.m_CurrentCover_Clamied);
				//Sleep(0.0);
			}

			if( m_CoverFightData.m_bSlowRotRight )
			{
				Pawn.DesiredRotation.Yaw = Pawn.Rotation.Yaw +  (Pawn.bIsCrouched ?
																class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateCrouchedAtCoverPerHertz : 
																class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateStandAtCoverPerHertz );
				Pawn.DesiredRotation.Pitch = 0;
				//Pawn.DesiredRotation = DesiredRotation;
				
			}
			else
			{
				Pawn.DesiredRotation.Yaw = Pawn.Rotation.Yaw -  (Pawn.bIsCrouched ?
																class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateCrouchedAtCoverPerHertz : 
																class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateStandAtCoverPerHertz );
				Pawn.DesiredRotation.Pitch = 0;
				//Pawn.DesiredRotation = DesiredRotation;
			}

			Pawn.SetRotation( Pawn.DesiredRotation );

			Sleep(0.0);
		}
		//Focus = none;

		m_SubStateDebugInfoTag="Done Turning to Target";

		if( IsReloading() || m_Engagement_Tac_Data.m_bNeedToReloadAtNextOpertunity )
		{
			//`log(" ChadAI - TPSoldierAIController::Fire_From_Cover_Slot::Begin - Main Loop - Reloading so Going back Hiding - m_bNeedToReloadAtNextOpertunity: " @ m_Engagement_Tac_Data.m_bNeedToReloadAtNextOpertunity @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			m_SubStateDebugInfoTag="Is Reloading";

			//ForceReload();

			;
			Sleep(0.0);
			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Fire_From_Cover_Slot::PoppedState  Main Loop - Reloading so Going back Hiding -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
			Goto('TransitionBackIntoElCovero');
		}


		if( (m_Engagement_Tac_Data.m_bTookHit || ( m_Engagement_Tac_Data.m_bKnowBeingAimedAt && !m_CoverFightData.m_bBlindFire) ) &&
			(m_CoverMoveData.m_CoverTransitionAction == CoverTransitionAction_NotTransitioning) && m_CoverFightData.m_HaveFiredAtLeastOneRoundThisFireStateSubMove )
		{	// if at open field slot set flag to take tactical evasion movement

			m_SubStateDebugInfoTag="Took Hit or Aimed at";

			if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldStanding  )  && 
				( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldMidLevel ) )
			{
				;
				Sleep(0.0);
				//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Fire_From_Cover_Slot::PoppedState  Taking hit or know being aimed at and at corner cover so popping firing state and going back to hiding -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
				Goto('TransitionBackIntoElCovero');
			}
			else if(!m_CoverFightData.m_bBlindFire)
			{
				// Only allow tac stepping if enough time has passed since posture change
				if( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_LastTimeCrouched ) > class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MinTimeBetweenPostureChanges )
				{
					if( RandRange(0.0,1.0) < class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_ChanceToUseOpenFieldTacticalEvasionPerHit )
					{
						;
						PushState('Open_Field_Tactical_Evasion_From_Cover');
					}
					else
					{
						;
						m_SubStateDebugInfoTag="Took Hit or Aimed at and not Evading";

						m_CoverMoveData.m_CoverState = CoverBehavior_Firing;
					}
				}
				else
				{
					;
					m_SubStateDebugInfoTag="Took Hit or Aimed at and not Evading becuase of time";

					m_CoverMoveData.m_CoverState = CoverBehavior_Firing;
				}
			}
		}









		// Is fighting position still valid
		if( DetermineIfShouldStartCQB_Tick( WorldInfo.TimeSeconds ) )
		{
			//`log(" ChadAI - TPSoldierAIController::Fire_From_Cover_Slot::Tick:: EnemyIsInRange  m_MeleeRangeOfAttack So Popping-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
			m_CoverFightData.m_bContinueToUseUseFightingPosition = false;

			m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_PausedEnemyIsAtCQB_Dist;

			;

			Sleep(0.0);
			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Fire_From_Cover_Slot m_MeleeRangeOfAttack So Popping -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
			Goto('TransitionBackIntoElCovero');
		}

		if( EnemyIsInRange( m_CoverFightData.m_MinDistanceToPlayerInCover ) )
		{
			//`log(" ChadAI - TPSoldierAIController::Fire_From_Cover_Slot::Tick:: EnemyIsInRange  m_CoverFightData.m_MinDistanceToPlayerInCover -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			m_CoverFightData.m_bContinueToUseUseFightingPosition = false;

			m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedDistanceToEnemy;

			;
		
			//`log(" ChadAI - Poping firing state because EnemyIsInRange( m_CoverFightData.m_MinDistanceToPlayerInCover )");
			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Fire_From_Cover_Slot EnemyIsInRange  m_CoverFightData.m_MinDistanceToPlayerInCover So Popping -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

			Goto('TransitionBackIntoElCovero');
		}
		else if( !IsAngleToEnemyValidForThisCoverSlot( m_CoverMoveData.m_CurrentCover_Clamied ) )
		{
			//`log(" ChadAI - TPSoldierAIController::Fire_From_Cover_Slot::Tick:: !IsAngleToEnemyValidForThisCoverSlot Node: " @ m_CoverMoveData.m_CurrentCover_Clamied.Link @ " slot: " @ m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx @"-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			m_CoverFightData.m_bContinueToUseUseFightingPosition = false;

			m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedAngleToEnemy;
			;

			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Fire_From_Cover_Slot Angle to enemy is Invalid So Ending Fire -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

			Goto('TransitionBackIntoElCovero');
		}







		else if( !m_CoverFightData.m_bBlindFire && !CanFireAtEnemyFrom( m_CoverMoveData.m_CurrentCover_Clamied, true ) )
		{
			//`log(" ChadAI - Fire_From_Cover_Slot::Tick:: !CanFireAtEnemyFrom Node: " @ m_CoverMoveData.m_CurrentCover_Clamied.Link @ " slot: " @ m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx @"-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			m_CoverFightData.m_bContinueToUseUseFightingPosition = false;

			m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedNoLineOfFireToEnemy;
			;
			Sleep(0.0);
			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Fire_From_Cover_Slot Not able to fire at the enemy anymore from this position -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

			Goto('TransitionBackIntoElCovero');
		}

		m_SubStateDebugInfoTag="Determined Can Fire From Cover";


		if( ( m_AttackUsingCoverGoalInfo.m_bUseCoverGroupTimer ) && (m_CoverMoveData.m_CoverTransitionAction == CoverTransitionAction_NotTransitioning) && m_CoverFightData.m_HaveFiredAtLeastOneRoundThisFireStateSubMove )
		{

			// if negitive time stay in here for ever
			if( m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup > 0.0f )
			{
				if( (WorldInfo.TimeSeconds - m_AttackUsingCoverGoalInfo.m_TimeStartedInCoverGroup) > m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup )
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ "  Fire_From_Cover_Slot::Tick m_AttackUsingCoverGoalInfo.m_AmountOfTimeInCoverGroup >= m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
					;
				
					Goto('TransitionBackIntoElCovero');
				}
			}
		}

		if( ( m_CoverMoveData.m_TimeToUseCoverInSeconds >= 0.0 ) && (m_CoverMoveData.m_CoverTransitionAction == CoverTransitionAction_NotTransitioning) && m_CoverFightData.m_HaveFiredAtLeastOneRoundThisFireStateSubMove )
		{
			if( WorldInfo.TimeSeconds - m_CoverMoveData.m_TimeStartedUsingCurrentCover > m_CoverMoveData.m_TimeToUseCoverInSeconds )
			{ //m_CoverMoveData.m_TimeStartedUsingCurrentCover = WorldInfo.TimeSeconds
				//`log(" ChadAI - TPSoldierAIController::Fire_From_Cover_Slot::Tick:: m_CoverMoveData.m_AmountOfTimeUsingCurrentCover >= m_CoverMoveData.m_TimeToUseCoverInSeconds -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				// stop firing
				
				m_CoverFightData.m_bContinueToUseUseFightingPosition = false;

				m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_SucceededBecauseTimePassed;

				;	

				//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Fire_From_Cover_Slot Poping firing state because of time m_AmountOfTimeUsingCurrentCover -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

				Goto('TransitionBackIntoElCovero');
			}
		} 

		if( ( (WorldInfo.TimeSeconds - m_CoverMoveData.m_TimeStartedFiringSinceLastHidingState) >= m_CoverMoveData.m_CurrentDurrationOfFiringBeforeHiding ) &&
			(m_CoverMoveData.m_CoverTransitionAction == CoverTransitionAction_NotTransitioning) && 
			m_CoverFightData.m_HaveFiredAtLeastOneRoundThisFireStateSubMove )
		{
			// stop firing

			//`log(" ChadAI - Poping firing state because of time m_TimeStartedFiringSinceLastHidingState");

			;	

			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Fire_From_Cover_Slot Poping firing state because of time m_TimeStartedFiringSinceLastHidingState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
			
			Goto('TransitionBackIntoElCovero');
			//PopState();
		}

		// No fire arc shifting when blind firing because sunil is a meanie
		if( !m_CoverFightData.m_bBlindFire )
		{
			if( m_CoverMoveData.m_CurrentCover_Clamied.Link != None )
			{
				if( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType == CT_Standing || 
					m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType == CT_MidLevel)
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ " Fire_From_Cover_SlotLoop at corner cover lets see if cover action needs changed -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					
					SetCoverAction(m_CoverMoveData.m_CurrentCover_Clamied, m_CoverFightData.m_bBlindFire);

					if( m_CoverFightData.m_PreviousCoverAction != m_CoverFightData.m_CurrentCoverAction )
					{
						// goto shifting fire position sub state
						Goto('ShiftingFireArc');
					}
				}
			}
		}


	}
	else
	{
		;

		//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Fire_From_Cover_Slot Ending Becuase No Enemy -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		Goto('TransitionBackIntoElCovero');
	}
	
		// CHAD make sure this sleep is needed
		m_SubStateDebugInfoTag="End of Loop and Sleep: " @ (WorldInfo.TimeSeconds - m_CoverMoveData.m_TimeStartedFiringSinceLastHidingState) @ " -> " @ m_CoverMoveData.m_CurrentDurrationOfFiringBeforeHiding;

		Sleep(0.0);

Goto('Fire_From_Cover_SlotLoop');

ShiftingFireArc:

	m_SubStateDebugInfoTag="Shifting Fire Arc";

	//ShiftPawnPositionBasedUponCoverAction( m_CoverMoveData.m_CurrentCover_Clamied, m_CoverFightData.m_CurrentCoverAction, CoverBehavior_Firing);

	// get the transition needed based upon old to new action

	m_CoverMoveData.m_CoverTransitionAction = GetCoverTransitionNeededForChangeInFiringArc(		m_CoverFightData.m_PreviousCoverAction,
																							m_CoverFightData.m_CurrentCoverAction, 
																							m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType );

	m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;

	//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Fire_From_Cover_Slot::ShiftingFireArc  m_CoverMoveData.m_CoverTransitionAction = " @ m_CoverMoveData.m_CoverTransitionAction @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

	;

	//`log(" ChadAI - Pawn: " @ Pawn @ " ShiftingFireArc Going from action: " @ m_CoverFightData.m_PreviousCoverAction @ " to action: " @ m_CoverFightData.m_CurrentCoverAction @ " at: " @ m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType @ " cover and Need a transition of: " @ m_CoverMoveData.m_CoverTransitionAction );

	while(( m_CoverMoveData.m_CoverTransitionAction != CoverTransitionAction_NotTransitioning ) &&
		( (WorldInfo.TimeSeconds - m_CoverFightData.m_TimeStartedLastCoverTransition) < class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_MaxTimeToWaitForCoverTransitionToEnd ) )
	{
		Sleep(0.00);
	}

	m_CoverFightData.m_HaveFiredAtLeastOneRoundThisFireStateSubMove = false;

	//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Fire_From_Cover_Slot::ShiftingFireArc Done m_CoverMoveData.m_CoverTransitionAction = " @ m_CoverMoveData.m_CoverTransitionAction @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

	Goto('Fire_From_Cover_SlotLoop');

BlindFireWithBattleRifle:

	if( Enemy != None )
	{
		Target = Enemy;
		Focus = Enemy;


		DesiredRotation = rotator(Focus.Location - Pawn.Location);
		DesiredRotation.Pitch = 0;
		Pawn.DesiredRotation = DesiredRotation;

		//Rotate Pawn Slowly to face in the right direction
		while( !ReachedDesiredRotationAtCoverAndSetRotDirection(true, m_CoverMoveData.m_CurrentCover_Clamied) )
		{
			//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " BlindFireWithBattleRifle Has not reached desired rot m_bSlowRotRight: " @ m_CoverFightData.m_bSlowRotRight @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::HideBehindCurrentCover::Begin:: - SnapToCurrentCover Being Called PopState-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			if( DoINeedToSlideIntoTheSlot( m_CoverMoveData.m_CurrentCover_Clamied ) )
			{
				SlideMeALIttleBitFatherIntoTheSlot(class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_DistToSlideIntoCoverWhileInCoverPerUpdate, m_CoverMoveData.m_CurrentCover_Clamied);
				//Sleep(0.0);
			}

			if( m_CoverFightData.m_bSlowRotRight )
			{
				DesiredRotation.Yaw = Pawn.Rotation.Yaw + (Pawn.bIsCrouched ?
																		class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateCrouchedAtCoverPerHertz : 
																		class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateStandAtCoverPerHertz );
				DesiredRotation.Pitch = 0;
				Pawn.DesiredRotation = DesiredRotation;
				
			}
			else
			{
				DesiredRotation.Yaw = Pawn.Rotation.Yaw -  (Pawn.bIsCrouched ?
																		class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateCrouchedAtCoverPerHertz : 
																		class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateStandAtCoverPerHertz );
				DesiredRotation.Pitch = 0;
				Pawn.DesiredRotation = DesiredRotation;
			}


			if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldStanding  )  && 
				( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldMidLevel ) )
			{
				Pawn.SetRotation( Pawn.DesiredRotation );
			}
			else
			{
				FinishRotation();
			}

			Sleep(0.0);
		}

	}
	else
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " BlindFireWithBattleRifle Ending Becuase No Enemy -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		Goto('TransitionBackIntoElCovero');
	}

	m_SubStateDebugInfoTag="Blind Fire With Battle Rifle";

	while(( m_CoverMoveData.m_CoverTransitionAction != CoverTransitionAction_NotTransitioning ) &&
		( (WorldInfo.TimeSeconds - m_CoverFightData.m_TimeStartedLastCoverTransition) < class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_MaxTimeToWaitForCoverTransitionToEnd ) )
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " BlindFireWithBattleRifle Snap Fire Loop -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		if( Enemy != None )
		{
			Target = Enemy;
			Focus = Enemy;
		}
		Sleep(0.0);
	}

TransitionBackIntoElCovero:

	//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " TransitionBackIntoElCovero Started -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

	StopFiring();

	//m_CoverMoveData.m_CoverState = CoverBehavior_Hiding;

	if( IsAtCover(m_CoverMoveData.m_CurrentCover_Clamied, false) )
	{
		if( m_CoverFightData.m_bBlindFire )
		{
			m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_BlidFiringToHiding;
			//`log(" ChadAI - Pawn: " @ Pawn @ " Fire_From_Cover_Slot::PoppedState  m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_BlidFiringToHiding -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

			m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;
		}
		else
		{
			if( m_CoverMoveData.m_CurrentCover_Clamied.Link != None && ( 
				( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType == CT_MidLevel ) || 
				( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType == CT_Standing ) ) )
			{
				if( m_Engagement_Tac_Data.m_bTookHit || m_Engagement_Tac_Data.m_bKnowBeingAimedAt )
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Fire_From_Cover_Slot::PoppedState  m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_HideFromFire -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

					m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_HideFromFire;
					m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;
					;
				}
				else
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " TransitionBackIntoElCovero  m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_FiringToHiding -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

					m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_FiringToHiding;

					m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;
					;
				}
			}
		}
	}
	else
	{
		m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_NotTransitioning;
	}

	m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;

	//m_CoverMoveData.m_CoverState = CoverBehavior_Hiding;

	while(( m_CoverMoveData.m_CoverTransitionAction != CoverTransitionAction_NotTransitioning ) &&
				( (WorldInfo.TimeSeconds - m_CoverFightData.m_TimeStartedLastCoverTransition) < class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_MaxTimeToWaitForCoverTransitionToEnd ) )
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Fire_From_Cover_Slot TimeToUseCover is up but still transition so will wait until done -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		//`AILOG(2, 'Fire_From_Cover_Slot',"Fire_From_Cover_Slot TimeToUseCover is up but still transition so will wait until done");
		Sleep(0.0);
	}

	m_CoverMoveData.m_CoverState = CoverBehavior_Hiding;

	PopState();

}



state Open_Field_Tactical_Evasion_From_Cover
{
	// Not to C++
	function BeginState(Name PreviousStateName)
	{
		//`log(" ChadAI - Open_Field_Tactical_Evasion_From_Cover::BeginState ");
		;

		SetAimAndHeadTrack();
	}

	// Not to C++
	function EndState (Name NextStateName)
	{
		;

		Target = None; 
		StopFiring();

		if (Pawn != None)
		{
			Pawn.SetMovementType( MovementType_Default );

			Pawn.MaxDesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
			Pawn.DesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
		}
	}

	// Not to C++
	event PushedState()
	{
		;

		SetAimAndHeadTrack();
	}


	// Not to C++
	event PausedState()
	{
		;
	}

	event ContinuedState()
	{
		;
	}

	// Not to C++
	event PoppedState()
	{
		;	

		if (Pawn != None)
		{
			Pawn.SetMovementType( MovementType_Default );

			Pawn.MaxDesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
			Pawn.DesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
		}
	}

	//---------------------------------------------------------------------------
	// Function:
	// Description:	Callback from weapon when it is fired.
	// for now do not burst weapon wait while tac evading, but will reload if needed
	//---------------------------------------------------------------------------
	// Not to C++
	function NotifyWeaponFired(Weapon W, byte FireMode)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Tactical_Evasion_From_Cover::NotifyWeaponFired BurstCount: " @ BurstCount @ " BulletsPerBurst: " @ TPWeapon(Pawn.Weapon).BulletsPerBurst  @" -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
		//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Tactical_Evasion_From_Cover::NotifyWeaponFired bIsNPCWeapon: " @ TPWeapon(Pawn.Weapon).bIsNPCWeapon@ " AmmoCount: " @ TPWeapon(Pawn.Weapon).AmmoCount @ " GetAmmoInMagazine(): " @ TPWeapon(Pawn.Weapon).GetAmmoInMagazine()  @" -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		if (Pawn != None && Pawn.Weapon != None ) //hmm, how to control this a better way?  Something like the 'ignores' keyword?
		{
			if( !m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd )
			{
				++BurstCount;
				if (BurstCount >= TPWeapon(Pawn.Weapon).BulletsPerBurst)
				{
					m_Engagement_Tac_Data.m_TimeToWaitForWeaponBurstDelay = RandRange(TPWeapon(Pawn.Weapon).BurstDelayMin, TPWeapon(Pawn.Weapon).BurstDelayMax);

					m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd = true;
					m_Engagement_Tac_Data.m_TimeStartedWaitForWeaponBurstDelay = WorldInfo.TimeSeconds;

					//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Tactical_Evasion_From_Cover::NotifyWeaponFired Time to wait BurstCount: " @ BurstCount @ " Delay of: " @ m_Engagement_Tac_Data.m_TimeToWaitForWeaponBurstDelay @ " -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
					;

					//StopFiring();
					BurstCount = 0;

	// 				if (!IsInState('BurstFireWait'))
	// 					PushState('BurstFireWait');
				}

			}

			// check to see if mag is empty and if so clear time to start check for reload movement to cover
							//Sleep(RandRange(TPWeapon(Pawn.Weapon).BurstDelayMin, TPWeapon(Pawn.Weapon).BurstDelayMax));

			//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Tactical_Evasion_From_Cover::NotifyWeaponFired GetAmmoInMagazine(): " @ TPWeapon(Pawn.Weapon).GetAmmoInMagazine()  @" -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

			if( TPWeapon(Pawn.Weapon).GetAmmoInMagazine() == 0 )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Tactical_Evasion_From_Cover::NotifyWeaponFired Mag is Empty -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

				m_Engagement_Tac_Data.m_LastTimeLOS_4_DefaultAttacksChecked = -1.0;
				m_Engagement_Tac_Data.m_bHaveAlreadyTestedTacStepForThisReloadOrHitOrAimedAt = false;
				//m_Engagement_Tac_Data.m_bScaredBackToCoverWhileSteppedOut = true;

			}
		}
	}

	// Not to C++
	function WeaponReloaded()
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Tactical_Evasion_From_Cover::NotifyWeaponReloadEnded fn called");
		BurstCount = 0; // reset this so it fires the correct number of bullets per burst after reload
		m_Engagement_Tac_Data.m_LastTimeLOS_4_DefaultAttacksChecked = -1.0;
	}


	// Not to C++
	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
	
		//`log(" ChadAI - SENSING - " @ self @ "Open_Field_Tactical_Evasion_From_Cover::OnSeeEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
			//`AILOG(0, 'Sensory', "- Open_Field_Tactical_Evasion_From_Cover::OnSeeEnemy CheckForEnemy: " @  m_playerList[playerIdx].Player.GetPawnName(true) );

		CheckForEnemy(false);
	}
	
	// Not to C++
	// is only called when the heared player in a new enemy
	event OnHearEnemy(int playerIdx)
	{
		//`log(" ChadAI - SENSING - " @ self @ "Open_Field_Tactical_Evasion_From_Cover::OnHearEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		//`log(" ChadAI - SENSING - " @ self @ "Open_Field_Tactical_Evasion_From_Cover::OnHearEnemy - bNewEnemy so CheckForEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		//`AILOG(0, 'Sensory', "- Open_Field_Tactical_Evasion_From_Cover::OnHearEnemy CheckForEnemy: " @  m_playerList[playerIdx].Player.GetPawnName(true) );
		CheckForEnemy(false);
	}

	// To C++
	function bool IsItReasonIbleToGoBackToCover()
	{
// 		local float PointOnLine;
// 		local vector slotLoc;
// 
		// If I am being amined at no
 		if( m_Engagement_Tac_Data.m_bKnowBeingAimedAt )
 		{
 			;
 			return false;
 		}

		if( IsMyReservedCoverStillValidToMoveTo() )
		{
			;
			return true;
		}

		;

// 		if(  Enemy != None && Pawn != None && m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link != None )
// 		{
// 			// if my enemy is between me and my cover no
// 
// 			slotLoc = m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link.GetSlotLocation( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.SlotIdx );
// 
// 			if ( ( 1.2f * VSize( Enemy.Location - Pawn.Location ) ) < VSize( slotLoc - Pawn.Location ) )
// 			{
// 				// 2) If -the closest point to the enemy on a line between me and the cover- is not on that line, I'm not passing them.
// 				PointOnLine = NearestParametricPointOnLineSegment( Pawn.Location, m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link.Location, Enemy.Location );
// 
// 				if ( PointOnLine >= 0.0f && PointOnLine <= 1.0f )
// 				{
// 					// point is on the line
// 					`AILOG(2, 'IsItReasonIbleToGoBackToCover',"WouldHaveToPassEnemy");
// 					return false;
// 				}
// 				else
// 				{
// 					`AILOG(2, 'IsItReasonIbleToGoBackToCover',"Point not on line Would NOT HaveToPassEnemy");
// 					//`log(" ChadAI - RateCoverSlot Point not on line !!!! --------------------------------------------------------------------------------------------" );
// 
// 				}
// 			}
// 			else
// 			{
// 				`AILOG(2, 'IsItReasonIbleToGoBackToCover',"cover Closer than enemy so can go back");
// 				//`log(" ChadAI - RateCoverSlot Closer than enemy !!!! --------------------------------------------------------------------------------------------" );
// 
// 			}
// 
// 			// if my enemy is to close to my cover no
// 			if( VSizeSq( Enemy.Location - slotLoc ) < 360000.0 )
// 			{
// 				`AILOG(2, 'IsItReasonIbleToGoBackToCover',"The Enemy Is To close to the Cover To Go Back To it");
// 				return false;
// 			}
// 		}

		return false;

	}

	// Not to C++
	event Tick( float DeltaTime )
	{
		if( m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd )
		{
			if( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedWaitForWeaponBurstDelay ) >= m_Engagement_Tac_Data.m_TimeToWaitForWeaponBurstDelay )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Tactical_Evasion_From_Cover Tick Time to wait BurstCount Ended -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

				// enough time has passed so end waiting for burst cool down time
				m_Engagement_Tac_Data.m_LastTimeLOS_4_DefaultAttacksChecked = -1.0;
				m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd = false;
			}
		}

		if( Pawn != None &&  Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching && Enemy != None )
		{

			DesiredRotation = rotator(Enemy.Location - Pawn.Location);
			DesiredRotation.Pitch = 0;
			Pawn.DesiredRotation = DesiredRotation;

			//Rotate Pawn Slowly to face in the right direction
			if( !ReachedDesiredRotationAtCoverAndSetRotDirection(true, m_CoverMoveData.m_ReservedGoToCover_Clamied) )
			{
				//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " BlindFireWithBattleRifle Has not reached desired rot m_bSlowRotRight: " @ m_CoverFightData.m_bSlowRotRight @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::HideBehindCurrentCover::Begin:: - SnapToCurrentCover Being Called PopState-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 				if( DoINeedToSlideIntoTheSlot( m_CoverMoveData.m_CurrentCover_Clamied ) )
// 				{
// 					SlideMeALIttleBitFatherIntoTheSlot(`TuneData.CoverEngagementTuneData.m_DistToSlideIntoCoverWhileInCoverPerUpdate, m_CoverMoveData.m_CurrentCover_Clamied);
// 					//Sleep(0.0);
// 				}

				if( m_CoverFightData.m_bSlowRotRight )
				{
					DesiredRotation.Yaw = Pawn.Rotation.Yaw + (Pawn.bIsCrouched ?
																			class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateCrouchedAtCoverPerHertz : 
																			class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateStandAtCoverPerHertz );
					DesiredRotation.Pitch = 0;
					Pawn.DesiredRotation = DesiredRotation;
					
				}
				else
				{
					DesiredRotation.Yaw = Pawn.Rotation.Yaw -  (Pawn.bIsCrouched ?
																			class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateCrouchedAtCoverPerHertz : 
																			class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateStandAtCoverPerHertz );
					DesiredRotation.Pitch = 0;
					Pawn.DesiredRotation = DesiredRotation;
				}

				Pawn.SetRotation( Pawn.DesiredRotation );
			}
		}

		UpdateAimInTheOpen(FALSE);;
		UpdateHeadtracking();

		Super.Tick(DeltaTime);
	}
begin:

	m_SubStateDebugInfoTag="Begin";
	
	//`log(" ChadAI - Open_Field_Tactical_Evasion_From_Cover::begin: ");
	SetAimAndHeadTrack();

	m_Engagement_Tac_Data.m_bHaveAlreadyTestedTacStepForThisReloadOrHitOrAimedAt = false;

Open_Field_Tactical_Evasion_From_Cover_Loop:


   ClearCurrentCover();

   // and reserve it again just incase someone else wants it

   ReserveCover(m_CoverFightData.m_CurrentlyCoverToUseAsFightPos);

	if( Enemy != None )
	{
		//`log(" ChadAI - Open_Field_Tactical_Evasion_From_Cover::Open_Field_Tactical_Evasion_From_Cover_Loop: has valid enemy: " @ Enemy );

		Target = Enemy;

		if( Enemy != None )
		{
			if( DetermineIfShouldStartCQB_Tick( WorldInfo.TimeSeconds ) )
			{
				Goto('CQB');
			}
		}
		
		Focus = Target;

		DesiredRotation = rotator(Focus.Location - Pawn.Location);
		DesiredRotation.Pitch = 0;

		// most likly if I am here I took a hit and at an open field cover slot so first look for hasty cover and if none just side step to make me harder to hit

		if( m_Engagement_Tac_Data.m_bAllowTacticalSteping && !m_Engagement_Tac_Data.m_bHaveAlreadyTestedTacStepForThisReloadOrHitOrAimedAt )
		{
			m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForHastyCover(	Enemy,
																						Vector(Pawn.Rotation), 
																						m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																						false);

			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Tactical_Evasion_From_Cover_Loop - I am reloading or scared or took hit  and just tested move to hasty cover Move Need: " @ m_Engagement_Tac_Data.m_MoveNeed2Kill @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			//`log(" ChadAI - Pawn: " @ Pawn @ " Vector(Pawn.Rotation):	" @ Vector(Pawn.Rotation) @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			//`log(" ChadAI - Pawn: " @ Pawn @ " Vector(DesiredRotation): " @ Vector(DesiredRotation) @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


			m_Engagement_Tac_Data.m_bHaveAlreadyTestedTacStepForThisReloadOrHitOrAimedAt = true;

			if( m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel &&
				m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_None )
			{
				m_Engagement_Tac_Data.m_bSideSteping = true;

				;

				//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Tactical_Evasion_From_Cover_Loop - I am reloading or scared or took hit  and can move to hasty cover Move Need: " @ m_Engagement_Tac_Data.m_MoveNeed2Kill @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				m_Engagement_Tac_Data.m_TimeStartedToOpenFieldTacticallyEvadeFromCover = WorldInfo.TimeSeconds;
				Goto('SeekHastyCover');						
			}
			else
			{
				;
				m_Engagement_Tac_Data.m_bSideSteping = true;
				m_Engagement_Tac_Data.m_TimeStartedToOpenFieldTacticallyEvadeFromCover = WorldInfo.TimeSeconds;
				Goto('SideStep');
				//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Tactical_Evasion_From_Cover_Loop - I am reloading or scared or took hit and can NOT move to hasty cover Move Need: " @ m_Engagement_Tac_Data.m_MoveNeed2Kill @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			}
		} // end if( m_Engagement_Tac_Data.m_bAllowTacticalSteping )
		else
		{
			;
			PopState();
		}


	} // end else for if (Enemy != None )	
	else
	{
		;
		PopState();
	}

	sleep(0.0);

Goto('Open_Field_Tactical_Evasion_From_Cover_Loop');

CQB:

	//`log(" ChadAI - Open_Field_Tactical_Evasion_From_Cover-CQB  m_RangeToStartCQB_State -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	StopFiring();
	PushState('CloseQuartersBattleAttack');

Goto('Open_Field_Tactical_Evasion_From_Cover_Loop');


SideStep:

	//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Tactical_Evasion_From_Cover-SideStep build path to side step -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


	m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForTacEvasion(	Enemy,
																				Vector(Pawn.Rotation), 
																				m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																				false);


	if(m_Engagement_Tac_Data.m_MoveNeed2Kill == RequiredMove4Engage_Travel ||
		m_Engagement_Tac_Data.m_MoveNeed2Kill == RequiredMove4Engage_None )
	{
		;
		m_Engagement_Tac_Data.m_bSideSteping = false;
		Sleep(0.0);

		// IsMyReservedCoverStillValidToMoveTo
		if( IsItReasonIbleToGoBackToCover() )
		{
			PopState();
		}
		Goto('NotReasonIbleToGoBackToCoverSoKillFromHere');
	}

	/* FIX_STEP: test the new KynapseCanGoStraight function
	// would really like to know path length to test against instead
	//KynapseGoToFindPath( m_Engagement_Tac_Data.m_SideStepTargetMoveLoc );
	//if ( KynapseFoundPath() )
	*/
	if ( KynapseCanGoStraight(m_Engagement_Tac_Data.m_SideStepTargetMoveLoc) )
	{
		m_SubStateDebugInfoTag="Evade";

		//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Tactical_Evasion_From_Cover-SideStep found path to side step so start stepping -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;

		Target = Enemy;

		Focus = Target;

		DesiredRotation = rotator(Focus.Location - Pawn.Location);
		DesiredRotation.Pitch = 0;

		if( DesiredRotation.Yaw < 0 )
		{
			//`log(" ChadAI - Open_Field_Tactical_Evasion_From_Cover - Open_Field_Tactical_Evasion_From_Cover-SideStep found path to side step so start stepping - DesiredRotation.Yaw < 0 -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
		}

		if( !m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Tactical_Evasion_From_Cover SideStep:: not wait for burst cool down. start firing-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

			;

			
				TP_AiStartFiring();
			


		}

		KynapseClear();

		//ActivateKynapseBrain(false);

		if( class'TPTuneManager'.static.Get().GetTuneData().DebugDrawData.m_bDisplayTacticalStepAimRays )
		{
			Pawn.DrawDebugLine( Pawn.Location, m_Engagement_Tac_Data.m_SideStepTargetMoveLoc, 0,
															0, 
															255, true);
		}

		if (Pawn.bIsCrouched)
		{
			m_SubStateDebugInfoTag="Tactical_Evasion_From_Cover UnCrouching";


			m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange = WorldInfo.TimeSeconds;

			if( Pawn != None && TPPawn(Pawn) != none )
			{
				Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToStanding;
			}

			;

			// OpenFieldPostureSwitchingState_GoingToCrouching
			while(	(Pawn.bIsCrouched && Pawn != None && TPPawn(Pawn) != none) ||
					(Pawn != None && TPPawn(Pawn) != none && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching ) )
			{
				Pawn.UnCrouch();
				Sleep(0.0);

				if( !Pawn.bIsCrouched && ( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange) >= 
											class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToStandPostureChangeToFinish ) )
				{
					;
					Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
					break;
				}
			}		
		}

		Pawn.SetMovementType(MovementType_Default);

		Pawn.MaxDesiredSpeed	=	class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_EvadeTacStepSpeedFactor;
		Pawn.DesiredSpeed		=	class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_EvadeTacStepSpeedFactor;

		MoveTo(m_Engagement_Tac_Data.m_SideStepTargetMoveLoc, Enemy);

		//Pawn.Velocity = vect(0,0,0);
		StopThisBot(); // MoveTo affects velocity & acceleration

		if (Pawn != None)
		{
			Pawn.SetMovementType( MovementType_Default );

			Pawn.MaxDesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
			Pawn.DesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
		}


		//ActivateKynapseBrain(true);
		//KynapseClear();


		if( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToOpenFieldTacticallyEvadeFromCover ) > class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_HowLongToOpenFieldTacticallyEvadeFromCover)
		{
			;
			m_Engagement_Tac_Data.m_bSideSteping = false;

			if( IsItReasonIbleToGoBackToCover() )
			{
				PopState();
			}
			Goto('NotReasonIbleToGoBackToCoverSoKillFromHere');
		}

		// can still tac evade so lets find another place

		if( Enemy != None )
		{
			if( DetermineIfShouldStartCQB_Tick( WorldInfo.TimeSeconds ) )
			{
				Goto('CQB');
			}
		}


		m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForTacEvasion(	Enemy,
																				Vector(Pawn.Rotation), 
																				m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																				false);


		if( Enemy != None && 
		m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel &&
		m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_None )
		{
			;
			Sleep(0.0);
			Goto('SideStep');
		}

		m_Engagement_Tac_Data.m_bSideSteping = false;
		//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Tactical_Evasion_From_Cover - SideStep back from MoveTo we made it and return to attack -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;
		m_CoverMoveData.m_CoverState = CoverBehavior_Firing;
		Sleep(0.0);

		if( IsItReasonIbleToGoBackToCover() )
		{
			PopState();
		}
		Goto('NotReasonIbleToGoBackToCoverSoKillFromHere');

	} // end if if ( KynapseCanGoStraight(m_Engagement_Tac_Data.m_SideStepTargetMoveLoc) )
	else
	{
		// the orginal selected side step locaiton can not be pathed to so invalidate it and try for another until they are all gone

		InvalidateThisEvadeTacStepLocation(m_Engagement_Tac_Data.m_MoveNeed2Kill);

		m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForTacEvasion(	Enemy,
																			Vector(Pawn.Rotation), 
																			m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																			false);


		if(m_Engagement_Tac_Data.m_MoveNeed2Kill == RequiredMove4Engage_Travel ||
			m_Engagement_Tac_Data.m_MoveNeed2Kill == RequiredMove4Engage_None )
		{
			;
			m_Engagement_Tac_Data.m_bSideSteping = false;

			if( IsItReasonIbleToGoBackToCover() )
			{
				PopState();
			}
			Goto('NotReasonIbleToGoBackToCoverSoKillFromHere');

		}

		Sleep(0.0);

		Goto('SideStep');

	}
	
	//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Tactical_Evasion_From_Cover-SideStep did not find path to side step so back to loop -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	;
	m_CoverMoveData.m_CoverState = CoverBehavior_Firing;
	//Goto('Open_Field_Tactical_Evasion_From_Cover_Loop');
	Sleep(0.0);

	if( IsItReasonIbleToGoBackToCover() )
	{
		PopState();
	}
	Goto('NotReasonIbleToGoBackToCoverSoKillFromHere');


SeekHastyCover:

	//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Tactical_Evasion_From_Cover-SeekHastyCover build path to side step -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	// would really like to know path length to test against instead
	//KynapseGoToFindPath( m_Engagement_Tac_Data.m_SideStepTargetMoveLoc );

	if ( KynapseCanGoStraight( m_Engagement_Tac_Data.m_SideStepTargetMoveLoc ) )
	{
		m_SubStateDebugInfoTag="Find Hasty Cover";

		//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Tactical_Evasion_From_Cover-SeekHastyCover found path to side step so start stepping -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;

		Target = Enemy;

		Focus = Target;

		DesiredRotation = rotator(Focus.Location - Pawn.Location);
		DesiredRotation.Pitch = 0;

		if( !m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Tactical_Evasion_From_Cover SideStep:: not wait for burst cool down. start firing-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

			;

			
				TP_AiStartFiring();
			


		}

		KynapseClear();
		//ActivateKynapseBrain(false);

		if( class'TPTuneManager'.static.Get().GetTuneData().DebugDrawData.m_bDisplayTacticalStepAimRays )
		{

			Pawn.DrawDebugLine( Pawn.Location, m_Engagement_Tac_Data.m_SideStepTargetMoveLoc, m_Engagement_Tac_Data.m_DisplayTacticalStepAimRaysStrightAheadColor.R,
															m_Engagement_Tac_Data.m_DisplayTacticalStepAimRaysStrightAheadColor.G, 
															m_Engagement_Tac_Data.m_DisplayTacticalStepAimRaysStrightAheadColor.B, true);

		}

		if (Pawn.bIsCrouched)
		{
			m_SubStateDebugInfoTag="Tactical_Evasion_From_Cover_SeekHastyCover UnCrouching";


			m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange = WorldInfo.TimeSeconds;

			if( Pawn != None && TPPawn(Pawn) != none )
			{
				Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToStanding;
			}

			;


			// OpenFieldPostureSwitchingState_GoingToCrouching
			while(	(Pawn.bIsCrouched && Pawn != None && TPPawn(Pawn) != none) ||
					(Pawn != None && TPPawn(Pawn) != none && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching ) )
			{
				Pawn.UnCrouch();
				Sleep(0.0);

				if( !Pawn.bIsCrouched && ( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange) >= 
											class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToStandPostureChangeToFinish ) )
				{
					;
					Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
					break;
				}
			}		
		}

		Pawn.SetMovementType(MovementType_Default);

		Pawn.MaxDesiredSpeed	=	class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_FindHastyCoverTacStepSpeedFactor;
		Pawn.DesiredSpeed		=	class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_FindHastyCoverTacStepSpeedFactor;


		MoveTo(m_Engagement_Tac_Data.m_SideStepTargetMoveLoc, Enemy);

		//Pawn.Velocity = vect(0,0,0);
		StopThisBot();
		//ActivateKynapseBrain(true);
		//KynapseClear();

		if (Pawn != None)
		{
			Pawn.SetMovementType( MovementType_Default );

			Pawn.MaxDesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
			Pawn.DesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
		}

		if( Enemy != None )
		{
			if( DetermineIfShouldStartCQB_Tick( WorldInfo.TimeSeconds ) )
			{
				Goto('CQB');
			}
		}


		m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForHastyCover(	Enemy,
																					Vector(Pawn.Rotation), 
																					m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																					false);


		if( Enemy != None && 
			m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel &&
			m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_None )
		{
			;
			Sleep(0.0);
			Goto('SeekHastyCover');
		}
		else if( m_Engagement_Tac_Data.m_MoveNeed2Kill == RequiredMove4Engage_None )
		{
			;

			while( m_Engagement_Tac_Data.m_MoveNeed2Kill == RequiredMove4Engage_None )
			{
				// we are at a place where I can temp hide from the enemy, and lets stay here until my time to hasty hide is up

				if( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToOpenFieldTacticallyEvadeFromCover ) > class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_HowLongToOpenFieldTacticallyEvadeFromCover)
				{
					;
					m_Engagement_Tac_Data.m_bSideSteping = false;
					Sleep(0.0);

					if( IsItReasonIbleToGoBackToCover() )
					{
						PopState();
					}
					Goto('NotReasonIbleToGoBackToCoverSoKillFromHere');

				}

				StopFiring();

				Sleep(0.0);

				m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForHastyCover(	Enemy,
																							Vector(Pawn.Rotation), 
																							m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																							false);
			}

			if( Enemy != None && 
				m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel )
			{
				;
				Sleep(0.0);
				Goto('SeekHastyCover');
			}

			;
		}

		m_Engagement_Tac_Data.m_bSideSteping = false;
		//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Tactical_Evasion_From_Cover - SeekHastyCover back from MoveTo we made it and return to attack -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		m_Engagement_Tac_Data.m_bScaredBackToCoverWhileSteppedOut = false;
		m_Engagement_Tac_Data.m_bTookHit = false;
		m_CoverMoveData.m_CoverState = CoverBehavior_Firing;

		if( IsItReasonIbleToGoBackToCover() )
		{
			PopState();
		}
		Goto('NotReasonIbleToGoBackToCoverSoKillFromHere');
	}
	else
	{
		InvalidateThisHastyCoverTacStepLocation(m_Engagement_Tac_Data.m_MoveNeed2Kill);

		m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForHastyCover(	Enemy,
																			Vector(Pawn.Rotation), 
																			m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																			false);


		if( Enemy != None && 
			m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel &&
			m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_None )
		{
			;
			
			Sleep(0.0);
			Goto('SeekHastyCover');
		}
	}
	
	//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Tactical_Evasion_From_Cover-SeekHastyCover did not find path to side step so back to loop -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	;
	m_Engagement_Tac_Data.m_bScaredBackToCoverWhileSteppedOut = true;
	m_Engagement_Tac_Data.m_bTookHit = false;
	m_CoverMoveData.m_CoverState = CoverBehavior_Firing;
	Sleep(0.0);

	if( IsItReasonIbleToGoBackToCover() )
	{
		PopState();
	}
	Goto('NotReasonIbleToGoBackToCoverSoKillFromHere');


NotReasonIbleToGoBackToCoverSoKillFromHere:

	PushState('Open_Field_Attack');

	;

	Goto('Open_Field_Tactical_Evasion_From_Cover_Loop');
}




//-----------------------------------------------------------------------
// State:
// Description:	For when at cover and can only enage by stepout out of the cover
//-----------------------------------------------------------------------
state StepOutFromCoverAndFire
{
	// Not to C++
    function NotifyWeaponFired(Weapon W, byte FireMode)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " StepOutFromCoverAndFire::NotifyWeaponFired BurstCount: " @ BurstCount @ " BulletsPerBurst: " @ TPWeapon(Pawn.Weapon).BulletsPerBurst  @" -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
		//`log(" ChadAI - Pawn: " @ Pawn @ " StepOutFromCoverAndFire::NotifyWeaponFired bIsNPCWeapon: " @ TPWeapon(Pawn.Weapon).bIsNPCWeapon@ " AmmoCount: " @ TPWeapon(Pawn.Weapon).AmmoCount @ " GetAmmoInMagazine(): " @ TPWeapon(Pawn.Weapon).GetAmmoInMagazine()  @" -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		if (Pawn != None && Pawn.Weapon != None ) //hmm, how to control this a better way?  Something like the 'ignores' keyword?
		{
			if( !m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd )
			{
				++BurstCount;
				if (BurstCount >= TPWeapon(Pawn.Weapon).BulletsPerBurst)
				{
					m_Engagement_Tac_Data.m_TimeToWaitForWeaponBurstDelay = RandRange(TPWeapon(Pawn.Weapon).BurstDelayMin, TPWeapon(Pawn.Weapon).BurstDelayMax);

					m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd = true;
					m_Engagement_Tac_Data.m_TimeStartedWaitForWeaponBurstDelay = WorldInfo.TimeSeconds;

					//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " StepOutFromCoverAndFire::NotifyWeaponFired Time to wait BurstCount: " @ BurstCount @ " Delay of: " @ m_Engagement_Tac_Data.m_TimeToWaitForWeaponBurstDelay @ " -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
					;

					StopFiring();
					BurstCount = 0;

	// 				if (!IsInState('BurstFireWait'))
	// 					PushState('BurstFireWait');
				}

			}

			// check to see if mag is empty and if so clear time to start check for reload movement to cover
							//Sleep(RandRange(TPWeapon(Pawn.Weapon).BurstDelayMin, TPWeapon(Pawn.Weapon).BurstDelayMax));

			//`log(" ChadAI - Pawn: " @ Pawn @ " StepOutFromCoverAndFire::NotifyWeaponFired GetAmmoInMagazine(): " @ TPWeapon(Pawn.Weapon).GetAmmoInMagazine()  @" -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

			if( TPWeapon(Pawn.Weapon).GetAmmoInMagazine() == 0 )
			{
				;

				//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " StepOutFromCoverAndFire::NotifyWeaponFired Mag is Empty -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
				StopFiring();
				m_Engagement_Tac_Data.m_LastTimeLOS_4_DefaultAttacksChecked = -1.0;
				m_Engagement_Tac_Data.m_bHaveAlreadyTestedTacStepForThisReloadOrHitOrAimedAt = false;
				m_Engagement_Tac_Data.m_bScaredBackToCoverWhileSteppedOut = true;

				//m_Engagement_Tac_Data.m_bScaredBackToCoverWhileSteppedOut = true;

			}
		}
	}

	// Not to C++
	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
	
		//`log(" ChadAI - " @ self @ "StepOutFromCoverAndFire::OnSeeEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
	
		// acquire as a new enemy and evaluate the situation
		CheckForEnemy(false);
	}
	
	// Not to C++
	event OnHearEnemy(int playerIdx)
	{
		//`log(" ChadAI - " @ self @ "StepOutFromCoverAndFire::OnHearEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		CheckForEnemy(false);		
	}

	// To C++
	event Tick( float DeltaTime )
	{
		//`log(" ChadAI - TPSoldierAIController::StepOutFromCoverAndFire::Tick  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
						
		UpdateAimInTheOpen(FALSE);;
		UpdateHeadtracking();

		if( m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd )
		{
			if( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedWaitForWeaponBurstDelay ) >= m_Engagement_Tac_Data.m_TimeToWaitForWeaponBurstDelay )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " StepOutFromCoverAndFire Tick Time to wait BurstCount Ended -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

				// enough time has passed so end waiting for burst cool down time
				m_Engagement_Tac_Data.m_LastTimeLOS_4_DefaultAttacksChecked = -1.0;
				m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd = false;
			}
		}

		if( m_Engagement_Tac_Data.m_bSideSteping && !m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " StepOutFromCoverAndFire : not wait for burst cool down. start firing-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

			;

			
				TP_AiStartFiring();
			


		}

		if( DetermineIfShouldStartCQB_Tick( WorldInfo.TimeSeconds ) )
		{
			//`log(" ChadAI - StepOutFromCoverAndFire EnemyIsInRange  m_MeleeRangeOfAttack So Popping-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
			m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
			m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_PausedEnemyIsAtCQB_Dist;
			StopThisBot();
			PopState();
		}

		//Super.Tick(DeltaTime);
	}	

	// Not to C++
	function BeginState(Name PreviousStateName)
	{
		;
		m_CoverMoveData.m_CoverState = CoverBehavior_Firing;
		m_CoverMoveData.m_TimeStartedFiringSinceLastHidingState = 0.0;
		//`log(" ChadAI - TPSoldierAIController::StepOutFromCoverAndFire::BeginState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
	}
	

	// Not to C++
	function EndState(Name NextStateName)
	{
		;

		//`log(" ChadAI - TPSoldierAIController::StepOutFromCoverAndFire::EndState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		//m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_FiringToHiding;
		m_CoverMoveData.m_CoverState = CoverBehavior_Firing;

		if (Pawn != None)
		{
			Pawn.SetMovementType( MovementType_Default );

			Pawn.MaxDesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
			Pawn.DesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
		}
		
	}
	// Not to C++
	event PausedState()
	{
		;

		//`log(" ChadAI - TPSoldierAIController::StepOutFromCoverAndFire::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}
// Not to C++
	event ContinuedState()
	{
		;

		m_Engagement_Tac_Data.m_bScaredBackToCoverWhileSteppedOut = true;
	
	}
// Not to C++
	event PoppedState()
	{
		;

		//`log(" ChadAI - TPSoldierAIController::StepOutFromCoverAndFire::PoppedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		//m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_FiringToHiding;
		m_CoverMoveData.m_CoverState = CoverBehavior_Firing;
		if (Pawn != None)
		{
			Pawn.SetMovementType( MovementType_Default );

			Pawn.MaxDesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
			Pawn.DesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
		}
	}


Begin:

	m_SubStateDebugInfoTag="Begin";

	SetAimToStrightAhead();

	if( Enemy == None )
	{
		;

		PopState();
	}

	m_CoverMoveData.m_CoverState = CoverBehavior_Firing;
	m_CoverMoveData.m_TimeStartedFiringSinceLastHidingState = WorldInfo.TimeSeconds;

	HandleLeftCoverCollisionChange( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos );
	
	//`log(" ChadAI - StepOutFromCoverAndFire::Begin - m_CoverMoveData.m_CoverState: " @ m_CoverMoveData.m_CoverState @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	//m_bInvalidFireState = false;
	StopFiring(); // tell the wep to stop firing
	//Target = None;
	;
	//`log(" ChadAI - StepOutFromCoverAndFire :"@m_CoverMoveData.m_currentCover.Link @ "-=-=-=-=-=-=-=-=-=-=-=-===============================================================");
// 	if (IsUnderFire())
// 	{
// 		//`AILOG(0, 'Begin', "Under fire - delaying fire at cover...");
// 		//`log(" ChadAI - StepOutFromCoverAndFire:Begin Under fire - delaying fire at cover...-=-=-=-=-=-=-=-=-=-=-=-===============================================================");
// 
// 		do
// 		{
// 			Sleep(1.f);
// 		}
// 		until (!IsUnderFire() );
// 	}
	//SetCoverAction(m_CoverMoveData.m_CurrentCover_Clamied, false);

	//m_CoverFightData.m_CurrentCoverAction = CA_StraightAhead;

	ClearCurrentCover();

	ReserveCover(m_CoverFightData.m_CurrentlyCoverToUseAsFightPos);


	//`log(" ChadAI - Pawn: " @ Pawn @ " StepOutFromCoverAndFire-SideStep Just ClearCurrentCover and Pawn.bIsCrouched = " @ Pawn.bIsCrouched @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	//Sleep(0.05);

	//`log(" ChadAI - Pawn: " @ Pawn @ " StepOutFromCoverAndFire-SideStep Just ClearCurrentCover and Pawn.bIsCrouched = " @ Pawn.bIsCrouched @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	if (Pawn.bIsCrouched)
	{
		m_SubStateDebugInfoTag="StepOutFromCoverAndFire UnCrouching";


		m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange = WorldInfo.TimeSeconds;

		if( Pawn != None && TPPawn(Pawn) != none )
		{
			Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToStanding;
		}

		;


		// OpenFieldPostureSwitchingState_GoingToCrouching
		while(	(Pawn.bIsCrouched && Pawn != None && TPPawn(Pawn) != none) ||
				(Pawn != None && TPPawn(Pawn) != none && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching ) )
		{
			Pawn.UnCrouch();
			Sleep(0.0);

			if( !Pawn.bIsCrouched && ( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange) >= 
										class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToStandPostureChangeToFinish ) )
			{
				;
				Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
				break;
			}
		}		
	}

   m_Engagement_Tac_Data.m_bScaredBackToCoverWhileSteppedOut = false;

   m_Engagement_Tac_Data.m_NumOfTimeTiredToGetBackToCoverAfterStepOut = 0;

	// SET COVER ACTION TO BE STRIGHT AHEAD OR KNEELING

SideStep:

	//`log(" ChadAI - Pawn: " @ Pawn @ " StepOutFromCoverAndFire-SideStep build path to side step -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	//`log(" ChadAI - Pawn: " @ Pawn @ " StepOutFromCoverAndFire-SideStep Just Entered SideStep: and Pawn.bIsCrouched = " @ Pawn.bIsCrouched @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	//Sleep(1.0);

	//`log(" ChadAI - Pawn: " @ Pawn @ " StepOutFromCoverAndFire-SideStep Just Sleep(1.0) and Pawn.bIsCrouched = " @ Pawn.bIsCrouched @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	/* FIX_STEP: test the new KynapseCanGoStraight function
	//KynapseGoToFindPath( m_Engagement_Tac_Data.m_SideStepTargetMoveLoc );
	//`log(" ChadAI - Pawn: " @ Pawn @ " StepOutFromCoverAndFire-SideStep Just KynapseGoToFindPath and Pawn.bIsCrouched = " @ Pawn.bIsCrouched @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	//if ( KynapseFoundPath() )
	*/
	if ( Enemy != None ) //KynapseCanGoStraight(m_Engagement_Tac_Data.m_SideStepTargetMoveLoc) )
	{
		m_SubStateDebugInfoTag="Step Out From Cover";

		//`log(" ChadAI - Pawn: " @ Pawn @ " StepOutFromCoverAndFire-SideStep found path to side step so start stepping -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;

		Target = Enemy;

		Focus = Target;

		DesiredRotation = rotator(Focus.Location - Pawn.Location);
		DesiredRotation.Pitch = 0;

		//`log(" ChadAI - Pawn: " @ Pawn @ " StepOutFromCoverAndFire-SideStep Just StartFiring and Pawn.bIsCrouched = " @ Pawn.bIsCrouched @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		KynapseClear();

		//`log(" ChadAI - Pawn: " @ Pawn @ " StepOutFromCoverAndFire-SideStep Just KynapseClear;and Pawn.bIsCrouched = " @ Pawn.bIsCrouched @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		m_Engagement_Tac_Data.m_bSideSteping = false;


		Pawn.SetMovementType(MovementType_Default);

		Pawn.MaxDesiredSpeed	=	class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_StepOutTacStepSpeedFactor;
		Pawn.DesiredSpeed		=	class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_StepOutTacStepSpeedFactor;


		MoveTo(m_Engagement_Tac_Data.m_SideStepTargetMoveLoc, Enemy);

		//`log(" ChadAI - Pawn: " @ Pawn @ " StepOutFromCoverAndFire-SideStep Just MoveTo;and Pawn.bIsCrouched = " @ Pawn.bIsCrouched @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


		//Pawn.Velocity = vect(0,0,0); // MoveTo affects velocity & acceleration
		StopThisBot(); // MoveTo affects velocity & acceleration
		//KynapseClear();

		if (Pawn != None)
		{
			Pawn.SetMovementType( MovementType_Default );

			Pawn.MaxDesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
			Pawn.DesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
		}

		//`log(" ChadAI - Pawn: " @ Pawn @ " StepOutFromCoverAndFire Done a movement no going to test again -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForEngagement(	Enemy,
																					Vector(m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link.GetSlotRotation(m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.SlotIdx)),
																					m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																					true);


		if( Enemy != None && 
			(m_Engagement_Tac_Data.m_NumOfTimeTiredToGetBackToCoverAfterStepOut++ < class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_NumOfTimesToTryAndGetBackToCoverAfterStepOut ) &&
			m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel &&
			m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_None )
		{
			;

			Goto('SideStep');
		}
		else if ( m_Engagement_Tac_Data.m_NumOfTimeTiredToGetBackToCoverAfterStepOut >= class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_NumOfTimesToTryAndGetBackToCoverAfterStepOut )
		{
			;
			m_Engagement_Tac_Data.m_NumOfTimeTiredToGetBackToCoverAfterStepOut = 0;
			Goto('ReturnToCover');
		}

		m_Engagement_Tac_Data.m_bSideSteping = false;
		//`log(" ChadAI - Pawn: " @ Pawn @ " PursueEnemy - SideStep back from MoveTo we made it and return to attack -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}
	else
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " PursueEnemy-SideStep did not find path to side step so back to loop -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;

		PopState();
	}

   m_Engagement_Tac_Data.m_NumOfTimeTiredToGetBackToCoverAfterStepOut = 0;
	
	
	while( !m_Engagement_Tac_Data.m_bScaredBackToCoverWhileSteppedOut )
	{
	
		if (HasValidEnemy() )
		//if(true)
		{	
			Target = Enemy;
			
			// see if we need to turn towards the target

			if( Enemy != None )
			{
				if( EnemyIsInRange( m_CoverFightData.m_MinDistanceToPlayerInCover ) )
				{
					//`log(" ChadAI - StepOutFromCoverAndFire EnemyIsInRange  m_CoverFightData.m_MinDistanceToPlayerInCover -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					m_CoverFightData.m_bContinueToUseUseFightingPosition = false;

					m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedDistanceToEnemy;

				
					//`log(" ChadAI - Poping firing state because EnemyIsInRange( m_CoverFightData.m_MinDistanceToPlayerInCover )");
					PopState();
				}
				else if( !IsAngleToEnemyValidForThisCoverSlot( m_CoverMoveData.m_PreviousCover_Not_Clamied ) )
				{
					//`log(" ChadAI - StepOutFromCoverAndFire !IsAngleToEnemyValidForThisCoverSlot Node: " @ m_CoverMoveData.m_CurrentCover_Clamied.Link @ " slot: " @ m_CoverMoveData.m_PreviousCover_Not_Clamied.SlotIdx @"-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					m_CoverFightData.m_bContinueToUseUseFightingPosition = false;

					m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedAngleToEnemy;


					PopState();
				}

				Target = Enemy;

				Focus = Target;

				DesiredRotation = rotator(Focus.Location - Pawn.Location);
				DesiredRotation.Pitch = 0;

				if(!m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd )
				{
					
						TP_AiStartFiring();
					


				}
			}
			else
			{
				//`log(" ChadAI - StepOutFromCoverAndFire NO ENEMY -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				Goto('ReturnToCover');
			}

			if( m_AttackUsingCoverGoalInfo.m_bUseCoverGroupTimer )
			{

				//`log(" ChadAI - StepOutFromCoverAndFire m_AttackUsingCoverGoalInfo.m_AmountOfTimeInCoverGroup: " @ m_AttackUsingCoverGoalInfo.m_AmountOfTimeInCoverGroup @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

				// if negitive time stay in here for ever
				if( m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup > 0.0f )
				{
					if( (WorldInfo.TimeSeconds - m_AttackUsingCoverGoalInfo.m_TimeStartedInCoverGroup) > m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup )
					{
						//`log(" ChadAI - TPSoldierAIController::Fire_From_Cover_Slot::Tick m_AttackUsingCoverGoalInfo.m_AmountOfTimeInCoverGroup >= m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
						;

						//`log(" ChadAI - StepOutFromCoverAndFire m_AttackUsingCoverGoalInfo.m_AmountOfTimeInCoverGroup >= m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

						PopState();
					}
				}
			}

			if( m_CoverMoveData.m_TimeToUseCoverInSeconds >= 0.0 ) // m_CoverMoveData.m_AmountOfTimeUsingCurrentCover >= m_CoverMoveData.m_TimeToUseCoverInSeconds )
			{
				if( (WorldInfo.TimeSeconds - m_CoverMoveData.m_TimeStartedUsingCurrentCover) > m_CoverMoveData.m_TimeToUseCoverInSeconds )
				{ 
					//`log(" ChadAI - StepOutFromCoverAndFire::StepOutFromCoverAndFire::Tick:: m_CoverMoveData.m_AmountOfTimeUsingCurrentCover >= m_CoverMoveData.m_TimeToUseCoverInSeconds -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					// stop firing
					
					m_CoverFightData.m_bContinueToUseUseFightingPosition = false;

					m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_SucceededBecauseTimePassed;

					;	


					//`log(" ChadAI - Poping firing state because of time m_AmountOfTimeUsingCurrentCover");
					PopState();
				}
			}


			if( (WorldInfo.TimeSeconds - m_CoverMoveData.m_TimeStartedFiringSinceLastHidingState) > m_CoverMoveData.m_CurrentDurrationOfFiringBeforeHiding )
			{
				// stop firing

				//`log(" ChadAI - Pawn: " @ Pawn @ " Poping step out state because of time m_TimeStartedFiringSinceLastHidingState");

				Goto('ReturnToCover');
			}

		}
		else // no eneamy so go back to cover
		{
			;	
			Goto('ReturnToCover');

		}
	
		// CHAD make sure this sleep is needed
		sleep(0.0);
	}

	;
	Goto('ReturnToCover');

ReturnToCover:

	StopFiring();

	//KynapseGoToFindPath( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link.GetSlotLocation(m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.SlotIdx) );

	if ( KynapseCanGoStraight( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link.GetSlotLocation(m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.SlotIdx) ) )
	{
		m_SubStateDebugInfoTag="Return TO Cover";

		KynapseClear();

		Pawn.SetMovementType(MovementType_Default);

		Pawn.MaxDesiredSpeed	=	class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_StepOutTacStepSpeedFactor;
		Pawn.DesiredSpeed		=	class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_StepOutTacStepSpeedFactor;

		MoveTo(m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link.GetSlotLocation(m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.SlotIdx), Enemy);

		//`log(" ChadAI - Pawn: " @ Pawn @ " StepOutFromCoverAndFire dist from cover: "@  VSize( Pawn.Location - m_CoverMoveData.m_PreviousCover_Not_Clamied.Link.GetSlotLocation(m_CoverMoveData.m_PreviousCover_Not_Clamied.SlotIdx)) @ " dist away to snap in: " @ m_CoverMoveData.m_MaxDistanceAwayFromCoverForSnappingIn @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		//`log(" ChadAI - Pawn: " @ Pawn @ " StepOutFromCoverAndFire No of attempts: "@ `TuneData.EngagementTacData.m_NumOfTimeTiredToGetBackToCoverAfterStepOut @ " No of time to allow: " @ m_Engagement_Tac_Data.m_NumOfTimesToTryAndGetBackToCoverAfterStepOut @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		if( (m_Engagement_Tac_Data.m_NumOfTimeTiredToGetBackToCoverAfterStepOut++ < class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_NumOfTimesToTryAndGetBackToCoverAfterStepOut ) &&
			VSizeSq( Pawn.Location - m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link.GetSlotLocation(m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.SlotIdx) ) > ( (m_CoverMoveData.m_MaxDistanceAwayFromCoverForSnappingIn) * (m_CoverMoveData.m_MaxDistanceAwayFromCoverForSnappingIn) ) )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " Did not make it the first time trying to return to cover so try again -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			//`log(" ChadAI - Pawn: " @ Pawn @ " Dist Sq: " @ VSizeSq( Pawn.Location - m_CoverMoveData.m_PreviousCover_Not_Clamied.Link.GetSlotLocation(m_CoverMoveData.m_PreviousCover_Not_Clamied.SlotIdx) ) @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			//`log(" ChadAI - Pawn: " @ Pawn @ " Snap Dist Sq Plus 20: " @ ( m_CoverMoveData.m_MaxDistanceAwayFromCoverForSnappingIn + 20) * ( m_CoverMoveData.m_MaxDistanceAwayFromCoverForSnappingIn + 20 ) @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			Sleep(0.0);
			Goto('ReturnToCover');
		}

		//Pawn.Velocity = vect(0,0,0);
		//KynapseClear();
		StopThisBot();

		if (Pawn != None)
		{
			Pawn.SetMovementType( MovementType_Default );

			Pawn.MaxDesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
			Pawn.DesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
		}

		m_Engagement_Tac_Data.m_TimeReloadStarted = WorldInfo.TimeSeconds;

		if( IsReloading() )
		{

			if( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link.Slots[m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.SlotIdx].CoverType == CT_MidLevel  )
			{
				;

				m_SubStateDebugInfoTag="Crouching back at cover while reloading";
				while( !Pawn.bIsCrouched )
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ " UseFightingPosition Crouching because at low cover - bIsCrouched: " @ Pawn.bIsCrouched @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					;
					Pawn.ShouldCrouch(true);
					m_Engagement_Tac_Data.m_LastTimeCrouched = WorldInfo.TimeSeconds;
					Sleep(0.0);
				}
			}

			if( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link.Slots[m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.SlotIdx].CoverType == CT_OpenFieldMidLevel) 
			{
				;

				m_SubStateDebugInfoTag="Crouching back at cover while reloading";

				m_Engagement_Tac_Data.m_TimeStartedToWaitForToCrouchPostureChange = WorldInfo.TimeSeconds;

				if( Pawn != None && TPPawn(Pawn) != none )
				{
					Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToCrouching;
					Pawn.ShouldCrouch(true); // use distance and sight check to crouch
				}

				while(	(!Pawn.bIsCrouched && Pawn != None && TPPawn(Pawn) != none) ||
						(Pawn != None && TPPawn(Pawn) != none && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching ) )
				{
					Sleep(0.0);

					//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Pawn.bIsCrouched: " @ Pawn.bIsCrouched @ " Time Waited: " @ WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToCrouchPostureChange @ " Max Time to Wait: " @ `TuneData.EngagementTacData.m_MaxTimeToWaitForToCrouchPostureChangeToFinish @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					if( Pawn.bIsCrouched && ( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToCrouchPostureChange) >= 
												class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToCrouchPostureChangeToFinish ) )
					{
						//`log(" ChadAI - Pawn: " @ Pawn @ " Waited to Long while changing Posture to crouch so force quiting -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

						;
						Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
						break;
					}
				}

				m_Engagement_Tac_Data.m_LastTimeCrouched = WorldInfo.TimeSeconds;

			}

		}

		// if reloading kneel and finish reloading
		while( IsReloading() )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " StepOutFromCoverAndFire is reloading so wait to go back into cover slot -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			
			if( Pawn != None && Pawn.Weapon != None && TPWeapon(Pawn.Weapon) != None && (WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeReloadStarted ) > TPWeapon(Pawn.Weapon).m_MaxReloadTime )
			{
				;
				//`log(" ChadAI - Pawn: " @ Pawn @ " StepOutFromCoverAndFire Been in the reload to long so forced to break out of the reloading wait loop and end the state -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				TPWeapon(Pawn.Weapon).WeaponReloaded();
				Sleep(0.0);
				break;
			}
			else if( Pawn == None || Pawn.Weapon == None || TPWeapon(Pawn.Weapon) == None )
			{	
				break;
			}

			m_SubStateDebugInfoTag="Back at cover reloading";

			Sleep(0.0);
		}
		

		m_SubStateDebugInfoTag="Back at cover Done reloading";

		SnapToCover(m_CoverFightData.m_CurrentlyCoverToUseAsFightPos, true);
	}
	else
	{

		//`log(" ChadAI - Pawn: " @ Pawn @ " Not able to find path back to cover so give up and go back to USE COVER and let it deal with it -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		;
	}

	m_SubStateDebugInfoTag="Done waiting for PopState";

	PopState();

	// PopState();
}


// Not to C++
function SetTransActionStateBackToHiding()
{
	m_CoverFightData.m_CurrentCoverAction = CA_Default;
	m_CoverMoveData.m_CoverState = CoverBehavior_Looking;
	m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_NotTransitioning;

	//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " SetTransActionStateBackToHiding and action to Default and State to Looking - Done m_CoverMoveData.m_CoverTransitionAction = " @ m_CoverMoveData.m_CoverTransitionAction @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
}

//-----------------------------------------------------------------------
// State:
// Description:	Utility state, handles a basic cover behavior set by the designers
//-----------------------------------------------------------------------
state PerformScriptedCoverSubBehavior
{
	// Not to C++
    function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		// do nothing for now
		//`log(" ChadAI - TPSoldierAIController::PerformScriptedCoverSubBehavior::NotifyWeaponFired  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		
    }

	// Not to C++
	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
	
		//`log(" ChadAI - SENSING - " @ self @ "PerformScriptedCoverSubBehavior::OnSeeEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
	
		// evaluate against our current one if new
		CheckForEnemy(false);
	}
	
	// Not to C++
	// is only called when the heared player in a new enemy
	event OnHearEnemy(int playerIdx)
	{
		//`log(" ChadAI - SENSING - " @ self @ "PerformScriptedCoverSubBehavior::OnHearEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
		CheckForEnemy(false);
	}

	// Not to C++
	event Tick( float DeltaTime )
	{
		//`log(" ChadAI - TPSoldierAIController::PerformScriptedCoverSubBehavior::Tick  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		
		UpdateAimAtCover();
		UpdateHeadtracking();

		Super.Tick(DeltaTime);
	}	
// Not to C++
	function BeginState(Name PreviousStateName)
	{
		;

		m_CoverMoveData.m_CoverState = CoverBehavior_Firing;
		m_CoverMoveData.m_TimeStartedFiringSinceLastHidingState = 0.0;
		//`log(" ChadAI - TPSoldierAIController::PerformScriptedCoverSubBehavior::BeginState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
	}
	// Not to C++

	function EndState(Name NextStateName)
	{
		;

		//`log(" ChadAI - TPSoldierAIController::PerformScriptedCoverSubBehavior::EndState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	
		m_CoverMoveData.m_CoverState = CoverBehavior_Firing;
	}
	
	// Not to C++
	event PausedState()
	{
		;
	}
// Not to C++
	event ContinuedState()
	{
		;

		HandleAtCoverCollisionChange( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos );

		//`log(" ChadAI - TPSoldierAIController::PerformScriptedCoverSubBehavior::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		if( !IsAtCover(m_CoverMoveData.m_CurrentCover_Clamied, false ) )
		{
			//`log(" ChadAI - TPSoldierAIController::PerformScriptedCoverSubBehavior::ContinuedState Not At Cover So Going Back to Parent State -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			SetTransActionStateBackToHiding();
			PopState();
		}
	
	}
	
	// Not to C++
	event PoppedState()
	{
		;

		//HandleLeftCoverCollisionChange( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos );

		m_CoverFightData.m_bBlindFire = false;
		m_CoverMoveData.m_TimeLastSubCoverBehaviorFinished= WorldInfo.TimeSeconds;			
	}
	
	// To C++
	function SetCoverActionBasedOnScriptedInput()
	{		
		switch( m_CoverMoveData.m_CurrentScriptedCoverBehaviorData.m_Behavior )
		{
			case ScriptedCoverBehavior_WaveOn:
				m_CoverFightData.m_CurrentCoverAction = CA_BlindUp;
				
				m_CoverMoveData.m_CoverState = CoverBehavior_Waving;

				m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_NotTransitioning;

				
				break;
			case ScriptedCoverBehavior_PeakUp:
				m_CoverFightData.m_CurrentCoverAction = CA_PeekUp;
				
				m_CoverMoveData.m_CoverState = CoverBehavior_Looking;

				m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_HidingToLooking;
				m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;

				
				break;
			case ScriptedCoverBehavior_PeakLeft:
				m_CoverFightData.m_CurrentCoverAction = CA_PeekLeft;
				
				m_CoverMoveData.m_CoverState = CoverBehavior_Looking;

				m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_HidingToLooking;
				m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;
				
				break;
			case ScriptedCoverBehavior_PeakRight:
				m_CoverFightData.m_CurrentCoverAction = CA_PeekRight;
				
				m_CoverMoveData.m_CoverState = CoverBehavior_Looking;

				m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_HidingToLooking;
				m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;
				
				break;
		
			default:

				;
				m_CoverFightData.m_CurrentCoverAction = CA_BlindUp;
				
				m_CoverMoveData.m_CoverState = CoverBehavior_Waving;

				m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_NotTransitioning;
				m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;

				break;
		
		}
	}

	
	// To C++
	function SetTransActionStateBackToHiding()
	{		
		switch( m_CoverMoveData.m_CurrentScriptedCoverBehaviorData.m_Behavior )
		{
			case ScriptedCoverBehavior_WaveOn:
				m_CoverFightData.m_CurrentCoverAction = CA_BlindUp;
				
				m_CoverMoveData.m_CoverState = CoverBehavior_Waving;

				m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_NotTransitioning;

				
				break;
			case ScriptedCoverBehavior_PeakUp:
				m_CoverFightData.m_CurrentCoverAction = CA_PeekUp;
				
				m_CoverMoveData.m_CoverState = CoverBehavior_Looking;

				m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_LookingToHiding;
				m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;

				
				break;
			case ScriptedCoverBehavior_PeakLeft:
				m_CoverFightData.m_CurrentCoverAction = CA_PeekLeft;
				
				m_CoverMoveData.m_CoverState = CoverBehavior_Looking;

				m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_LookingToHiding;
				m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;
				
				break;
			case ScriptedCoverBehavior_PeakRight:
				m_CoverFightData.m_CurrentCoverAction = CA_PeekRight;
				
				m_CoverMoveData.m_CoverState = CoverBehavior_Looking;

				m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_LookingToHiding;
				m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;
				
				break;
			default:
				m_CoverFightData.m_CurrentCoverAction = CA_BlindUp;
				
				m_CoverMoveData.m_CoverState = CoverBehavior_Waving;

				m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_NotTransitioning;
				
				break;
		
		}
	}


Begin:

	;

	m_SubStateDebugInfoTag="Begin";

	SetAimAndHeadTrack();	
	SetCoverActionBasedOnScriptedInput();
	
	m_CoverMoveData.m_TimeStartedPerformingCurrentCoverBehavior = WorldInfo.TimeSeconds;

	HandleAtCoverCollisionChange( m_CoverMoveData.m_CurrentCover_Clamied );
	
	//`log(" ChadAI - TPSoldierAIController::PerformScriptedCoverSubBehavior::Begin - m_CoverMoveData.m_CoverState: " @ m_CoverMoveData.m_CoverState @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	//m_bInvalidFireState = false;
	StopFiring(); // tell the wep to stop firing

	while(true)
	{
		if( ( WorldInfo.TimeSeconds - m_CoverMoveData.m_TimeStartedPerformingCurrentCoverBehavior) > m_CoverMoveData.m_CurrentScriptedCoverBehaviorData.m_TimeToPerformInSec )
		{
			//`log(" ChadAI - TPSoldierAIController::PerformScriptedCoverSubBehavior::Tick out of time PopState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
			SetTransActionStateBackToHiding();
			PopState();
		}
		
		if( Enemy != None )
		{

			if( DetermineIfShouldStartCQB_Tick( WorldInfo.TimeSeconds ) )
			{
				m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
				m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_PausedEnemyIsAtCQB_Dist;

				PopState();
			}

			if( EnemyIsInRange( m_CoverFightData.m_MinDistanceToPlayerInCover ) )
			{
				//`log(" ChadAI - TPSoldierAIController::PerformScriptedCoverSubBehavior::Tick:: EnemyIsInRange  m_CoverFightData.m_MinDistanceToPlayerInCover -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				m_CoverFightData.m_bContinueToUseUseFightingPosition = false;

				m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedDistanceToEnemy;

				
				//`log(" ChadAI - Poping firing state because of time");
				SetTransActionStateBackToHiding();
				PopState();
			}
			else if( !IsAngleToEnemyValidForThisCoverSlot( m_CoverMoveData.m_CurrentCover_Clamied ) )
			{
				//`log(" ChadAI - TPSoldierAIController::PerformScriptedCoverSubBehavior::Tick:: !IsAngleToEnemyValidForThisCoverSlot Node: " @ m_CoverMoveData.m_CurrentCover_Clamied.Link @ " slot: " @m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx @"-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				m_CoverFightData.m_bContinueToUseUseFightingPosition = false;

				m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedAngleToEnemy;

				SetTransActionStateBackToHiding();
				PopState();
			}
		}
		
		if( m_AttackUsingCoverGoalInfo.m_bUseCoverGroupTimer )
		{

			//`log(" ChadAI - TPSoldierAIController::PerformScriptedCoverSubBehavior::Tick m_AttackUsingCoverGoalInfo.m_AmountOfTimeInCoverGroup: " @ m_AttackUsingCoverGoalInfo.m_AmountOfTimeInCoverGroup @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

			// if negitive time stay in here for ever
			if( m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup > 0.0f )
			{
				if( (WorldInfo.TimeSeconds - m_AttackUsingCoverGoalInfo.m_TimeStartedInCoverGroup) > m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup )
				{
					//`log(" ChadAI - TPSoldierAIController::Fire_From_Cover_Slot::Tick m_AttackUsingCoverGoalInfo.m_AmountOfTimeInCoverGroup >= m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
					;

					PopState();
				}
			}
		}
		
		if( ! m_CoverMoveData.m_CurrentScriptedCoverBehaviorData.m_bOverRideNonScriptedDurations )
		{

			if( m_CoverMoveData.m_TimeToUseCoverInSeconds >= 0.0 ) // m_CoverMoveData.m_AmountOfTimeUsingCurrentCover >= m_CoverMoveData.m_TimeToUseCoverInSeconds )
			{
				if( WorldInfo.TimeSeconds - m_CoverMoveData.m_TimeStartedUsingCurrentCover > m_CoverMoveData.m_TimeToUseCoverInSeconds )
				{ 
					//`log(" ChadAI - PerformScriptedCoverSubBehavior::StepOutFromCoverAndFire::Tick:: m_CoverMoveData.m_AmountOfTimeUsingCurrentCover >= m_CoverMoveData.m_TimeToUseCoverInSeconds -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					SetTransActionStateBackToHiding();
					;	
					//`log(" ChadAI - Poping firing state because of time m_AmountOfTimeUsingCurrentCover");
					PopState();
				}
			}
			
		}
		Sleep(0.0);
	} // end while(true)

	
	// CHAD'S CURRENT WORK LOC
	
	// delay while stepping out from cover
	// CHAD make sure this sleep is needed
	Sleep(0.0);
}

//-----------------------------------------------------------------------
// State:
// Description:	Utility state, handles a basic firing pattern as sniper
//-----------------------------------------------------------------------
state EngageAsSniper
{
	// Not to C++
    function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		// do nothing for now
		//`log(" ChadAI - TPSoldierAIController::EngageAsSniper::NotifyWeaponFired  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		
    }
      
    // Not to C++
	event Tick( float DeltaTime )
	{
		local vector viewPoint;

		StopFiring();
		
		//`log(" ChadAI - TPSoldierAIController::EngageAsSniper::Tick  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		
		// update time since last fire		

		if( Enemy != None )
		{
			Target = Enemy;
			Focus = Enemy;
		}
		else
		{
			StopFiring();
			PopState();
		}
		
		UpdateAimInTheOpen(FALSE);;
		UpdateHeadtracking();
		
		if( m_SniperInfo.m_bDisplaySniperAimRay )
		{
			viewPoint = Pawn.Location;
			viewPoint.Z += Pawn.BaseEyeHeight;
			
			Pawn.DrawDebugLine( viewPoint, TargetAimLocation,	m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.R,
																m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.B,
																m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.G );

			m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.R = RandRange(0, 255);
			m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.G = RandRange(0, 255);
			m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.B = RandRange(0, 255);

		}

		Super.Tick(DeltaTime);

	}

	// Not to C++
	function BeginState(Name PreviousStateName)
	{
		;
	}

	// Not to C++
	event PushedState()
	{
		;

		//`log(" ChadAI - TPSoldierAIController::EngageAsSniper::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}
	
// Not to C++
	function EndState(Name NextStateName)
	{
		//`log(" ChadAI - TPSoldierAIController::EngageAsSniper::EndState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		;

		m_CoverMoveData.m_CoverState = CoverBehavior_Firing;
		

		//`AILOG(0, 'EndState', "cleaning up cover claims");
		StopFiring();
		//ClearReservedCover();
		//ClearCurrentCover();
		//bForceDesiredRotation = false;
		
	}
	
	// Not to C++
	event PausedState()
	{
		;

		m_SniperInfo.m_bCurrentlySniping = false;

		//`log(" ChadAI - TPSoldierAIController::EngageAsSniper::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	// Not to C++
	event PoppedState()
	{
		;

		m_SniperInfo.m_bCurrentlySniping = false;

		//`log(" ChadAI - TPSoldierAIController::EngageAsSniper::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		StopFiring();	
	}

	// Not to C++
	event ContinuedState()
	{
		;

		m_SniperInfo.m_bCurrentlySniping = true;

		//`log(" ChadAI - TPSoldierAIController::EngageAsSniper::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}

Begin:

	m_SubStateDebugInfoTag="Begin";

	m_CoverMoveData.m_CoverState = CoverBehavior_Firing;

	m_SniperInfo.m_bCurrentlySniping = true;
	
	//`log(" ChadAI - TPSoldierAIController::EngageAsSniper::Begin -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	//m_bInvalidFireState = false;
		
	
	m_SniperInfo.m_WaitTimeBetweenShots = 60.0 / m_SniperInfo.m_RateOfFirePerMin;
	m_SniperInfo.m_TimeOfLastShot = WorldInfo.TimeSeconds;
	
	m_SniperInfo.m_TimeLastContactLost = -1.0;
	
	//`log(" ChadAI - TPSoldierAIController::EngageAsSniper::Begin m_WaitTimeBetweenShots: " @ m_SniperInfo.m_WaitTimeBetweenShots @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	// To C++
	if ( HasValidEnemy() ) // && SetCoverAction())
	{
		SetCoverAction(m_CoverMoveData.m_CurrentCover_Clamied, false);
	
		//`log(" ChadAI - TPSoldierAIController::EngageAsSniper::Begin Has Valid Enemy-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	
		//`AILOG(0, 'Begin',"HasValidEnemy");
		
		Target = Enemy;
		
		Focus = Enemy;
		
		
			TP_AiStartFiring();
		


					
		// CHAD make sure this sleep is needed
		//Sleep(0.1);
		
		//StopFiring();

			
	}
	else
	{
		//`log(" ChadAI - TPSoldierAIController::EngageAsSniper::Begin Does NOT have Valid Enemy-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	
		Target = None;
		//`AILOG(0, 'Begin', "Invalid enemy or unable to attack!");
		// CHAD make sure this sleep is needed
		Sleep(0.0f);
		//m_bInvalidFireState = true;
	}

	// PopState();
	
EngageAsSniperLoop:
	// CHAD make sure this sleep is needed
	//Sleep(0.2);

	//`log(" ChadAI - Pawn: " @ Pawn @ " EngageAsSniperLoop  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
			
	if( ( WorldInfo.TimeSeconds - m_SniperInfo.m_TimeStartedAsSniperInSeconds) >= m_SniperInfo.m_TimeToBeSniperInSeconds )
	{
		//`log(" ChadAI::Sniper - TPSoldierAIController::EngageAsSniper::Tick Done Being A sniper -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	
		// Done being a sniper
		PopState();
	}
	
	// update time since last fire

//`log(" ChadAI::Sniper - EngageAsSniperLoop Testing Time for another Shot: Cur Time: " @ WorldInfo.TimeSeconds @ "Last Time: " @ m_SniperInfo.m_TimeOfLastShot @ " Passed Time: " @ WorldInfo.TimeSeconds - m_SniperInfo.m_TimeOfLastShot @ " Wait Time: " @ m_SniperInfo.m_WaitTimeBetweenShots @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

	if( Enemy != None )
	{
		if (ShouldITurnToTarget( false ))
		//if( true )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " EngageAsSniperLoop - ShouldITurnToTarget return true-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			//`AILOG(0, 'Begin', "Turn towards target");
			// turn towards our target
			//StopFiring();
			//Focus = Target;

			
			// wait til the turn is finished
			m_SubStateDebugInfoTag="Turning to Target";

			DesiredRotation = rotator(TargetAimLocation - Pawn.Location);
			DesiredRotation.Pitch = 0;
			FinishRotation();

			// preserve the new orientation and stop turning
			//PreserveRotation();
			//Focus = none;
		}
	}


			
	if( ( WorldInfo.TimeSeconds - m_SniperInfo.m_TimeOfLastShot ) > m_SniperInfo.m_WaitTimeBetweenShots )
	{
	//`log(" ChadAI::Sniper - EngageAsSniperLoop Time for another Shot: Cur Time: " @ WorldInfo.TimeSeconds @ "Last Time: " @ m_SniperInfo.m_TimeOfLastShot @ " Passed Time: " @ WorldInfo.TimeSeconds - m_SniperInfo.m_TimeOfLastShot @ " Wait Time: " @ m_SniperInfo.m_WaitTimeBetweenShots @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	
		if( Enemy != None )
		{
			if( CanFireAtNotFromCover(Enemy) )
			{
			//`log(" ChadAI::Sniper - TPSoldierAIController::EngageAsSniper::Tick Has LOS -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

				
					TP_AiStartFiring();
				



				m_SniperInfo.m_TimeOfLastShot = WorldInfo.TimeSeconds;
				m_SniperInfo.m_TimeLastContactLost = -1;
			}
			else
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " EngageAsSniperLoop Does Not LOS m_SniperInfo.m_TimeLastContactLost	: " @ m_SniperInfo.m_TimeLastContactLost @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
				//`log(" ChadAI - Pawn: " @ Pawn @ " EngageAsSniperLoop Does Not LOS WorldInfo.TimeSeconds -				: " @ (WorldInfo.TimeSeconds - m_SniperInfo.m_TimeLastContactLost) @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
				StopFiring();
				
				//`log(" ChadAI - Pawn: " @ Pawn @ " EngageAsSniperLoop No Enemy Starting Lost Contact Timer Time to Wait after Lost Contact: " @ m_SniperInfo.m_TimeToWaitAfterLosingContact @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
				
				if( m_SniperInfo.m_TimeLastContactLost < 0 )
				{ // first interation after losing contact
				
					m_SniperInfo.m_TimeLastContactLost = WorldInfo.TimeSeconds;
				}
				else
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ " EngageAsSniperLoop Does Not LOS WorldInfo.TimeSeconds -				: " @ (WorldInfo.TimeSeconds - m_SniperInfo.m_TimeLastContactLost) @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

					if( ( WorldInfo.TimeSeconds - m_SniperInfo.m_TimeLastContactLost ) > m_SniperInfo.m_TimeToWaitAfterLosingContact )
					{
						// no longer need to engage pop state and go back to looking for target						
						//`log(" ChadAI::Sniper - TPSoldierAIController::EngageAsSniper::Tick no longer need to engage pop state and go back to looking for targe -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
						PopState();
					
					}

					//m_SniperInfo.m_TimeLastContactLost = WorldInfo.TimeSeconds;
				
				}
			
			}
		}
		else
		{

 		//`log(" ChadAI::Sniper - TPSoldierAIController::EngageAsSniperLoop totally Lost contact so giving up the ghost -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
			PopState();
			// start lost contact timer
		
		}
	}
	else
	{
		StopFiring();
	}

	Sleep(0.0);
	
	Goto('EngageAsSniperLoop');
}


//-----------------------------------------------------------------------
// State:
// Description:	Utility state, handles a basic hiding behind cover.
//-----------------------------------------------------------------------
state HideBehindCurrentCover
{

	// Not to C++
	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
	
		//`log(" ChadAI - " @ self @ "HideBehindCurrentCover::OnSeeEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
	
		// acquire as a new enemy and evaluate the situation
		CheckForEnemy(false);
	}
	
	// Not to C++
	event OnHearEnemy(int playerIdx)
	{
		//`log(" ChadAI - " @ self @ "HideBehindCurrentCover::OnHearEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		CheckForEnemy(false);		
	}

	// Not to C++
	function BeginState(Name PreviousStateName)
	{
		;

		if( IsReloading() )
		{
			//`log(" ChadAI - HideBehindCurrentCover::BeginState IsReloading so  m_CoverMoveData.m_CoverState = CoverBehavior_Reloading -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		

			m_CoverMoveData.m_CoverState = CoverBehavior_Reloading;
		}
		else
		{
			m_CoverMoveData.m_CoverState = CoverBehavior_Hiding;
		}
		//`log(" ChadAI - TPSoldierAIController::HideBehindCurrentCover::BeginState m_CoverMoveData.m_CoverState: " @ m_CoverMoveData.m_CoverState @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
	}
	

	// Not to C++
	function EndState(Name NextStateName)
	{
		//`log(" ChadAI - TPSoldierAIController::HideBehindCurrentCover::EndState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		;

		m_CoverMoveData.m_CoverState = CoverBehavior_Hiding;
		m_CoverFightData.m_FirstSubBehaviorAtCover = false;
	}
	

	// Not to C++
	event PushedState()
	{
		;

		if( IsReloading() )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " - HideBehindCurrentCover::BeginState IsReloading so  m_CoverMoveData.m_CoverState = CoverBehavior_Reloading -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
			m_CoverMoveData.m_CoverState = CoverBehavior_Reloading;
		}
		else
		{
			m_CoverMoveData.m_CoverState = CoverBehavior_Hiding;
		}
		//`log(" ChadAI - TPSoldierAIController::HideBehindCurrentCover::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	// Not to C++
	event PausedState()
	{
		;

		//`log(" ChadAI - TPSoldierAIController::HideBehindCurrentCover::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	// Not to C++
	event ContinuedState()
	{
		;

		HandleAtCoverCollisionChange( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos );

		//`log(" ChadAI - TPSoldierAIController::HideBehindCurrentCover::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		if( !IsAtCover(m_CoverMoveData.m_CurrentCover_Clamied, false ) )
		{
			//`log(" ChadAI - TPSoldierAIController::HideBehindCurrentCover::ContinuedState Not At Cover So Going Back to Parent State -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			PopState();
		}
	}

	// Not to C++
	event PoppedState()
	{
		;
		m_CoverFightData.m_FirstSubBehaviorAtCover = false;
	}
	
	// Not to C++
    function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		// do nothing for now
		//`log(" ChadAI - TPSoldierAIController::HideBehindCurrentCover::NotifyWeaponFired  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		StopFiring();
    }
	
		// Not to C++
	// will always fail for now because of lack of animation
	function DetermineIfGoingLow()
	{
		local CoverSlot slot;

		//`log(" ChadAI - HideBehindCurrentCover::DetermineIfGoingLow at Node: " @ m_CoverMoveData.m_CurrentCover_Clamied.Link @ " slot: " @ m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx @" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


		// temp
		TPPawn(Pawn).m_bGoingLowAtHighCornerCover = false;
		return;


		if( m_CoverMoveData.m_CurrentCover_Clamied.Link != None && Pawn != None )
		{
			slot = m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx];
			
			if( slot.CoverType == CT_Standing && slot.bAllowDropToLowCoverToEngage )
			{
				//`log(" ChadAI - HideBehindCurrentCover::DetermineIfGoingLow Node: " @ m_CoverMoveData.m_CurrentCover_Clamied.Link @ " slot: " @ m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx @" is standing and can go low with chance: " @ slot.ChanceToDropToLowCoverPerEngagementAttempt @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				if( RandRange(0.0f , 1.0f) <= slot.ChanceToDropToLowCoverPerEngagementAttempt )
				{
					//`log(" ChadAI - HideBehindCurrentCover::DetermineIfGoingLow GOING LOW at Node: " @ m_CoverMoveData.m_CurrentCover_Clamied.Link @ " slot: " @ m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx @" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					;

					TPPawn(Pawn).m_bGoingLowAtHighCornerCover = true;
				}

			}
		}
	}

	// Not to C++
	event Tick( float DeltaTime )
	{
		//`log(" ChadAI - HideBehindCurrentCover::Tick  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
				
		//UpdateAimAtCover();
		UpdateHeadtracking();

		if (anode_WeaponBlend != none)
		{
			if (Pawn == none || Pawn.Weapon == none)
				anode_WeaponBlend.SetBlendTarget(1.0, 0.2);
			else
				anode_WeaponBlend.SetBlendTarget(0.0, 1.0);
		}

		// DO the go low at high thing
		if( Pawn.m_OpenFieldPostureSwitchingState == OpenFieldPostureSwitchingState_GoingToCrouching )
		{
			DesiredRotation = rotator(Enemy.Location - Pawn.Location);
			DesiredRotation.Pitch = 0;
			Pawn.DesiredRotation = DesiredRotation;
			Pawn.SetRotation( Pawn.DesiredRotation );
		}

	}


Begin:


	//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " HideBehindCurrentCover::Begin:: - Loc: " @ Pawn.Location @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	//`log(" ChadAI - Pawn: " @ Pawn @ " HideBehindCurrentCover -						Pawn Loc1: " @  Pawn.Location @ " BoneLoc2 " @ Pawn.Mesh.GetBoneLocation('JO_hip') @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	m_SubStateDebugInfoTag="Begin";

	m_CoverFightData.m_bNeedToPlayOpenFieldTransToFiring = false;

	if( IsReloading() )
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " HideBehindCurrentCover::Begin IsReloading so  m_CoverMoveData.m_CoverState = CoverBehavior_Reloading -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
		m_CoverMoveData.m_CoverState = CoverBehavior_Reloading;
	}
	else
	{
		//`log(" ChadAI - HideBehindCurrentCover::Begin Is NOT Reloading so  m_CoverMoveData.m_CoverState = CoverBehavior_Hiding -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
		m_CoverMoveData.m_CoverState = CoverBehavior_Hiding;
	}

	m_CoverMoveData.m_TimeStartedHidingSinceLastFiringState = WorldInfo.TimeSeconds;

	HandleAtCoverCollisionChange( m_CoverMoveData.m_CurrentCover_Clamied );

	//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::TravelToCoverSlot::after HandleAtCoverCollisionChange:: - Loc: " @ Pawn.Location @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	//`log(" ChadAI - TPSoldierAIController::HideBehindCurrentCover::Begin - m_CoverMoveData.m_CoverState: " @ m_CoverMoveData.m_CoverState @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	StopFiring();

	Target = None;
	;
	//`log(" ChadAI - Hiding behind cover:"@m_CoverMoveData.m_currentCover.Link @ " Pawn.bIsCrouched: " @ Pawn.bIsCrouched @ " -=-=-=-=-=-=-=-=-=-=-=-===============================================================");

	if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_Standing ) && 
		 ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldStanding) )
	{
		if (!Pawn.bIsCrouched)
		{
			if( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType == CT_MidLevel  )
			{
				;

				m_SubStateDebugInfoTag="Hiding at cover";
				while( !Pawn.bIsCrouched )
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ " UseFightingPosition Crouching because at low cover - bIsCrouched: " @ Pawn.bIsCrouched @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					;
					Pawn.ShouldCrouch(true);
					m_Engagement_Tac_Data.m_LastTimeCrouched = WorldInfo.TimeSeconds;
					Sleep(0.0);
				}
			}

			if( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link.Slots[m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.SlotIdx].CoverType == CT_OpenFieldMidLevel) 
			{
				;

				m_SubStateDebugInfoTag="Hiding at cover";

				m_Engagement_Tac_Data.m_TimeStartedToWaitForToCrouchPostureChange = WorldInfo.TimeSeconds;

				if( Pawn != None && TPPawn(Pawn) != none )
				{
					Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToCrouching;
					Pawn.ShouldCrouch(true); // use distance and sight check to crouch
				}

				while(	(!Pawn.bIsCrouched && Pawn != None && TPPawn(Pawn) != none) ||
						(Pawn != None && TPPawn(Pawn) != none && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching ) )
				{
					Sleep(0.0);

					//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Pawn.bIsCrouched: " @ Pawn.bIsCrouched @ " Time Waited: " @ WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToCrouchPostureChange @ " Max Time to Wait: " @ `TuneData.EngagementTacData.m_MaxTimeToWaitForToCrouchPostureChangeToFinish @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					if( Pawn.bIsCrouched && ( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToCrouchPostureChange) >= 
												class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToCrouchPostureChangeToFinish ) )
					{
						//`log(" ChadAI - Pawn: " @ Pawn @ " Waited to Long while changing Posture to crouch so force quiting -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
						;
						Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
						break;
					}
				}
				m_Engagement_Tac_Data.m_LastTimeCrouched = WorldInfo.TimeSeconds;
			}
		}
	}
	else
	{
		if (Pawn.bIsCrouched)
		{
			//`log(" ChadAI - Hiding behind cover: Pawn.ShouldCrouch(false) -=-=-=-=-=-=-=-=-=-=-=-===============================================================");
			;
			Pawn.UnCrouch();
			//`log(" ChadAI - Hiding behind cover: Pawn.bIsCrouched: " @ Pawn.bIsCrouched @ " -=-=-=-=-=-=-=-=-=-=-=-===============================================================");
			m_SubStateDebugInfoTag="UnCrouching";
			Sleep(0.0);
		}
	}


	//`log(" ChadAI - Pawn: " @ Pawn @ " HideBehindCurrentCover  SetCoverAction Begin Getting Called -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	
	//SetCoverAction(m_CoverMoveData.m_CurrentCover_Clamied, false);

	if( m_Engagement_Tac_Data.m_bNeedToReloadAtNextOpertunity )
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " - HideBehindCurrentCover-Begin - m_bNeedToReloadAtNextOpertunity so Force Load *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType == CT_OpenFieldStanding  )  || 
			( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType == CT_OpenFieldMidLevel ) )
		{
			m_SubStateDebugInfoTag="Is Reloading";

			ForceReload();

			m_CoverMoveData.m_CoverState = CoverBehavior_Reloading;

			;

			m_Engagement_Tac_Data.m_bNeedToReloadAtNextOpertunity = false;
			Sleep(0.0);
		}
		// else need to make sure the transition is done to hiding then reload

	}


SettingGoingLowAtHighCornerCoverPosture:


	if( m_CoverMoveData.m_CurrentCover_Clamied.Link != None && Pawn != None )
	{			
		if( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType == CT_Standing )
		{
			DetermineIfGoingLow();

			//`log(" ChadAI - Pawn: " @ Pawn @ " HideBehindCurrentCover::SettingPosture  CT_Standing TPPawn(Pawn).m_bGoingLowAtHighCornerCover " @ TPPawn(Pawn).m_bGoingLowAtHighCornerCover @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			if( TPPawn(Pawn).m_bGoingLowAtHighCornerCover )
			{
				//Sleep(0.0);

				//`log(" ChadAI - Pawn: " @ Pawn @ " HideBehindCurrentCover::SettingPosture  IS m_bGoingLowAtHighCornerCover -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				if (!Pawn.bIsCrouched)
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " m_bGoingLowAtHighCornerCover Pawn.bIsCrouched: " @ Pawn.bIsCrouched @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					Pawn.bCollideWorld=true;
					Pawn.SetPhysics(PHYS_Walking);

					ClearCurrentCover();
					ReserveCover(m_CoverFightData.m_CurrentlyCoverToUseAsFightPos);

					
					m_Engagement_Tac_Data.m_TimeStartedToWaitForToCrouchPostureChange = WorldInfo.TimeSeconds;

					DesiredRotation = rotator(Enemy.Location - Pawn.Location);
					DesiredRotation.Pitch = 0;
					Pawn.DesiredRotation = DesiredRotation;

					if( Pawn != None && TPPawn(Pawn) != none )
					{
						Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToCrouching;
						Pawn.ShouldCrouch(true); // use distance and sight check to crouch
					}

					while(	(!Pawn.bIsCrouched && Pawn != None && TPPawn(Pawn) != none) ||
							(Pawn != None && TPPawn(Pawn) != none && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching ) )
					{
						Sleep(0.0);

						//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Pawn.bIsCrouched: " @ Pawn.bIsCrouched @ " Time Waited: " @ WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToCrouchPostureChange @ " Max Time to Wait: " @ `TuneData.EngagementTacData.m_MaxTimeToWaitForToCrouchPostureChangeToFinish @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

						if( Pawn.bIsCrouched && ( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToCrouchPostureChange) >= 
													class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToCrouchPostureChangeToFinish ) )
						{
							//`log(" ChadAI - Pawn: " @ Pawn @ " Waited to Long while changing Posture to crouch so force quiting -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

							;
							Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
							break;
						}
					}

					m_Engagement_Tac_Data.m_LastTimeCrouched = WorldInfo.TimeSeconds;

					OccupyCover(m_CoverMoveData.m_ReservedGoToCover_Clamied);

					HandleAtCoverCollisionChange( m_CoverMoveData.m_CurrentCover_Clamied );
				} // end if (!Pawn.bIsCrouched)

			} // end if( TPPawn(Pawn).m_bGoingLowAtHighCornerCover )

		} // end if( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType == CT_Standing )
	} // end if( m_CoverMoveData.m_CurrentCover_Clamied.Link != None && Pawn != None )



	while(true)
	{

		m_SubStateDebugInfoTag="Top of loop";
		//`log(" ChadAI - Pawn: " @ Pawn @ " HideBehindCurrentCover Top of loop - Loc: " @ Pawn.Location @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		//`log(" ChadAI - Pawn: " @ Pawn @ " HideBehindCurrentCover Top of loop			Pawn Loc1: " @  Pawn.Location @ " BoneLoc2 " @ Pawn.Mesh.GetBoneLocation('JO_hip') @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::HideBehindCurrentCover::Begin:: - SnapToCurrentCover Being Called PopState-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		if( DoINeedToSlideIntoTheSlot( m_CoverMoveData.m_CurrentCover_Clamied ) )
		{
			SlideMeALIttleBitFatherIntoTheSlot(class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_DistToSlideIntoCoverWhileInCoverPerUpdate, m_CoverMoveData.m_CurrentCover_Clamied);
			//Sleep(0.0);
		}

					// wait til the turn is finished
		m_SubStateDebugInfoTag="Turning to Target";

		if( Enemy != None )
		{
			DesiredRotation = rotator( Enemy.Location - Pawn.Location );
			DesiredRotation.Pitch = 0;
 
			Pawn.DesiredRotation = DesiredRotation;
		}
		else
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ "HideBehindCurrentCover Rotating Towards Node: " @ m_CoverMoveData.m_CurrentCover_Clamied.Link @ " Slot: " @ m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
 
			DesiredRotation = m_CoverMoveData.m_CurrentCover_Clamied.Link.GetSlotRotation(m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx);
			DesiredRotation.Pitch = 0;
 
			Pawn.DesiredRotation = DesiredRotation;

			//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " HideBehindCurrentCover::Main Loop Slot Rot: " @ m_CoverMoveData.m_CurrentCover_Clamied.Link.GetSlotRotation(m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx).Yaw @ " - Pawn Rot: " @ Pawn.Rotation.Yaw @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " HideBehindCurrentCover::Main Loop DesiredRotation before rot logic: " @ DesiredRotation.Yaw @ " - Pawn Rot: " @ Pawn.Rotation.Yaw @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		}

		//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " HideBehindCurrentCover::Main Loop has Enemy: " @ (Enemy != None ? true : false) @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

 
		if( !ReachedDesiredRotationAtCoverAndSetRotDirection( (Enemy != None ? true : false), m_CoverMoveData.m_CurrentCover_Clamied ) )
		{
			;
			//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " HideBehindCurrentCover::Main Loop Has not reached desired rot m_bSlowRotRight: " @ m_CoverFightData.m_bSlowRotRight @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			if( m_CoverFightData.m_bSlowRotRight )
			{
				Pawn.DesiredRotation.Yaw = Pawn.Rotation.Yaw +  (	Pawn.bIsCrouched ?
																	class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateCrouchedAtCoverPerHertz : 
																	class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateStandAtCoverPerHertz );
				Pawn.DesiredRotation.Pitch = 0;
				
			}
			else
			{
				Pawn.DesiredRotation.Yaw = Pawn.Rotation.Yaw -  (	Pawn.bIsCrouched ?
																	class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateCrouchedAtCoverPerHertz : 
																	class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateStandAtCoverPerHertz );
				Pawn.DesiredRotation.Pitch = 0;
			}

			//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " HideBehindCurrentCover::Main Loop DesiredRotation after first part rot logic: " @ DesiredRotation.Yaw @ "  - Pawn Rot: " @ Pawn.Rotation.Yaw @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			
			Pawn.SetRotation( Pawn.DesiredRotation );

			//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " HideBehindCurrentCover::Main Loop DesiredRotation after last part rot logic: " @ DesiredRotation.Yaw @ "  - Pawn Rot: " @ Pawn.Rotation.Yaw @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
 
			Sleep(0.0);

		}

		if( m_AttackUsingCoverGoalInfo.m_bUseCoverGroupTimer )
		{
			//`log(" ChadAI - TPSoldierAIController::HideBehindCurrentCover::Tick m_AttackUsingCoverGoalInfo.m_AmountOfTimeInCoverGroup: " @ m_AttackUsingCoverGoalInfo.m_AmountOfTimeInCoverGroup @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
			// if negitive time stay in here for ever
			if( m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup > 0.0f )
			{
				if( (WorldInfo.TimeSeconds - m_AttackUsingCoverGoalInfo.m_TimeStartedInCoverGroup) > m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup )
				{
					//`log(" ChadAI - TPSoldierAIController::Fire_From_Cover_Slot::Tick m_AttackUsingCoverGoalInfo.m_AmountOfTimeInCoverGroup >= m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
					;

					PopState();
				}
			}
		}

		if( m_CoverMoveData.m_TimeToUseCoverInSeconds >= 0.0 ) // m_CoverMoveData.m_AmountOfTimeUsingCurrentCover >= m_CoverMoveData.m_TimeToUseCoverInSeconds )
		{
			if( (WorldInfo.TimeSeconds - m_CoverMoveData.m_TimeStartedUsingCurrentCover) > m_CoverMoveData.m_TimeToUseCoverInSeconds )
			{ 
				//`log(" ChadAI - HideBehindCover::StepOutFromCoverAndFire::Tick:: m_CoverMoveData.m_AmountOfTimeUsingCurrentCover >= m_CoverMoveData.m_TimeToUseCoverInSeconds -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
				m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_SucceededBecauseTimePassed;

				;	
				//`log(" ChadAI - Poping firing state because of time m_AmountOfTimeUsingCurrentCover");
				PopState();
			}
		}
		
		
		// To C++
		if( Enemy != None )
		{
			if( DetermineIfShouldStartCQB_Tick( WorldInfo.TimeSeconds ) )
			{
				//`log(" ChadAI - TPSoldierAIController::HideBehindCurrentCover::Tick:: EnemyIsInRange  m_RangeToStartCQB_State so PopState-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
				m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_PausedEnemyIsAtCQB_Dist;

				PopState();
			}

			if( EnemyIsInRange( m_CoverFightData.m_MinDistanceToPlayerInCover ) )
			{
				//`log(" ChadAI - TPSoldierAIController::HideBehindCurrentCover::Tick:: EnemyIsInRange  m_CoverFightData.m_MinDistanceToPlayerInCover -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
				m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedDistanceToEnemy;

				
				//`log(" ChadAI - HideBehindCover - Poping firing state because Enemy != None");
				PopState();
			}
			else if( !IsAngleToEnemyValidForThisCoverSlot( m_CoverMoveData.m_CurrentCover_Clamied ) )
			{
				//`log(" ChadAI - TPSoldierAIController::HideBehindCurrentCover::Tick:: !IsAngleToEnemyValidForThisCoverSlot Node: " @ m_CoverMoveData.m_CurrentCover_Clamied.Link @ " slot: " @m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx @"-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
				m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedAngleToEnemy;
				
				PopState();
			}
		}

	
		if( (m_CoverMoveData.m_CoverTransitionAction == CoverTransitionAction_NotTransitioning) && (
			( WorldInfo.TimeSeconds - m_CoverMoveData.m_TimeStartedHidingSinceLastFiringState ) > (
																			(m_Engagement_Tac_Data.m_bKnowBeingAimedAt || m_CoverFightData.m_FirstSubBehaviorAtCover) ?
																			m_CoverMoveData.m_CurrentDurationOfHidingBeforeFiring / 10.0f : // if being aimed at do not want to hide to long
																			m_CoverMoveData.m_CurrentDurationOfHidingBeforeFiring ) ) )
		{
			if( ! IsReloading() )
			{
				//`log(" ChadAI - HideBehindCover- Poping hiding state because of time m_TimeStartedHidingSinceLastFiringState");
				;
				if( m_CoverMoveData.m_CoverState != CoverBehavior_Reloading )
				{
					m_CoverFightData.m_bNeedToPlayOpenFieldTransToFiring = true;
				}

				PopState();
			}
			else
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " HideBehindCover-Enough time has passed to quite hiding but still reloading so stay hiding until done");
				;
			}
		}

		if( m_CoverMoveData.m_CoverState == CoverBehavior_Reloading && !IsReloading())
		{
			;
			PopState();
		}

		m_SubStateDebugInfoTag="Bottom of loop Duration";

		//`log(" ChadAI - Pawn: " @ Pawn @ " HideBehindCover-Bottom of loop Duration");

		Sleep(0.0);

	}
		
}


// The attack state when not told to do any thing else
state Free_Attack_Goal
{

	// Not to C++
	function BeginState(Name PreviousStateName)
	{
		;
	}
	
	// Not to C++
	event PausedState()
	{
		;
	}

	// Not to C++
	event ContinuedState()
	{
		;

		m_HighLevelAiGoal = HighLevelAiGoal_FreeAttackGoal;
	
	}

	// Not to C++
	function EndState(Name NextStateName)
	{
		;

		//`log(" ChadAI - TPSoldierAIController::Free_Attack_Goal::EndState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	
		m_HighLevelAiGoal = HighLevelAiGoal_NONE;
	}
	
	// Not to C++
	event PoppedState()
	{
		;

		//`log(" ChadAI - TPSoldierAIController::Free_Attack_Goal::PoppedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		m_HighLevelAiGoal = HighLevelAiGoal_NONE;
	
	}

	// Not to C++
	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
	
		//`log(" ChadAI - SENSING - " @ self @ "Free_Attack_Goal::OnSeeEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
			//`AILOG(0, 'Sensory', "- Free_Attack::OnSeeEnemy CheckForEnemy: " @  m_playerList[playerIdx].Player.GetPawnName(true) );

		CheckForEnemy(false);
	}
	
	
	// Not to C++
	// is only called when the heared player in a new enemy
	event OnHearEnemy(int playerIdx)
	{
		//`log(" ChadAI - SENSING - " @ self @ "Free_Attack_Goal::OnHearEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		//`log(" ChadAI - SENSING - " @ self @ "Free_Attack_Goal::OnHearEnemy - bNewEnemy so CheckForEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		//`AILOG(0, 'Sensory', "- Free_Attack::OnHearEnemy CheckForEnemy: " @  m_playerList[playerIdx].Player.GetPawnName(true) );
		CheckForEnemy(false);
	}

	// Not to C++
	event Tick( float DeltaTime )
	{
		//UpdateAimInTheOpen(FALSE);;
		SetAimToStrightAhead();
		UpdateHeadtracking();

		//Super.Tick(DeltaTime);
	}

Begin:

	m_SubStateDebugInfoTag="Begin";

	//`log(" ChadAI - TPSoldierAIController::Free_Attack_Goal::Begin() m_CoverMoveData.m_bAllowUseOfCover: " @ m_CoverMoveData.m_bAllowUseOfCover @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	;

	m_HighLevelAiGoal = HighLevelAiGoal_FreeAttackGoal;

	m_FreeAttackGoalInfo.m_bContinueToFreeAttack = true;

	m_CoverMoveData.m_CoverState = CoverBehavior_Hiding;

	//MarkEnemyHostile(true);



FreeAttackGoalLoop:

	if( m_FreeAttackGoalInfo.m_bContinueToFreeAttack )
	{
		//`log(" ChadAI - Pawn " @ Pawn @ " FreeAttackGoalLoop:: Begin -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		if( DetermineIfGrenadeShouldBeAutoThrown() )
		{
			//`log(" ChadAI - Pawn " @ Pawn @ " FreeAttackGoalLoop DetermineIfGrenadeShouldBeThrown");
			;
			PushState('UseGrenadeAgainstEnemy');
		}
		else if (Enemy == None || !HasValidEnemy())
		{
			;
			//`log(" ChadAI - TPSoldierAIController::FreeAttackGoalLoop Does Not have valid enemy -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			//EvaluateSituation();
			m_FreeAttackGoalInfo.m_bContinueToFreeAttack = false;
			Goto('DoneAttacking');
		}
		else if( DetermineIfShouldStartCQB_Latent( WorldInfo.TimeSeconds ) )
		{
			;

			//`log(" ChadAI - TPSoldierAIController::FreeAttackGoalLoop::Tick:: EnemyIsInRange  m_RangeToStartCQB_State -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			
			PushState('CloseQuartersBattleAttack');
		}
		else if (ShouldIUseTurret() && m_DesiredTurret.ClaimTurret(Self) )
		{
			;

			PushState('Action_TurretGunning');
		}
// 		else if (ShouldIPursueEnemy())
// 		{
// 			`AILOG(1, 'FreeAttackGoal', "I SHOULD PURSUE");
// 
// 			PushState('PursueEnemy');
// 
// 		}
		else // either use cover or stand and attack
		{
			if ( m_CoverMoveData.m_bAllowUseOfCover )
			{
				// try finding cover

				//`log(" ChadAI - Pawn " @ Pawn @ " FreeAttackGoalLoop:: Can use cover now lets see if can find some -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek = EvaluateCoverForFreeAttack();

				;





				if( m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.Link != None &&
					( m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek ==  m_CoverMoveData.m_PreviousCover_Not_Clamied ) )
				{
					//`log(" ChadAI - - Pawn: " @ Pawn @ " AttackUsingCoverGoalLoop m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek ==  m_CoverMoveData.m_PreviousCover_Not_Clamied So lets see if I can just stay here -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

					;

					// check to see if the old cover is valid

					if ( m_CoverMoveData.m_PreviousCover_Not_Clamied.Link != None )
					{
						//`log(" ChadAI - - " @ Pawn @ " Evaluating m_PreviousCover_NOT_Clamied Node : " @ m_CoverMoveData.m_PreviousCover_Not_Clamied.Link @ " slot: " @ m_CoverMoveData.m_PreviousCover_Not_Clamied.SlotIdx @ "  --------------------------------------------------------------------------------------------" );	

						if( m_CoverMoveData.m_PreviousCover_Not_Clamied.Link.Slots[m_CoverMoveData.m_PreviousCover_Not_Clamied.SLotIdx].SlotOwner == None )
						{
							//`log(" ChadAI - - " @ Pawn @ " Node : " @ m_CoverMoveData.m_PreviousCover_Not_Clamied.Link @ " slot: " @ m_CoverMoveData.m_PreviousCover_Not_Clamied.SlotIdx @ " Does Not Have a Slot Owner that is not you --------------------------------------------------------------------------------------------" );	

							if( IsPotentialCover( m_CoverMoveData.m_PreviousCover_Not_Clamied ))
							{
								if(IsAngleToEnemyValidForThisCoverSlot( m_CoverMoveData.m_PreviousCover_Not_Clamied ) )
								{
									//`log(" ChadAI - Find best cover for goal - "@Pawn @ " Can conciderbecause of angle to enemy is valid for this slot Node: " @ currEvanNodeInfo.Link @ " slot: " @currEvanNodeInfo.SlotIdx @"-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");

									if( !IsSomeJerkBlockingYourCover( m_CoverMoveData.m_PreviousCover_Not_Clamied.Link.GetSlotLocation(m_CoverMoveData.m_PreviousCover_Not_Clamied.SLotIdx) ) )
									{
										//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackUsingCoverGoal::AttackUsingCoverGoalLoop FindBestCover failed and IsAngleToEnemyValidForThisCoverSlot = true -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

										// if close enough to the new slot just occipy it snap to it and then use it
										if( CanIjustStayHereAndReuseThisCoverSlot(m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek) )
										{
											;
											Goto('AttackFromCoverSubState');
										}

									} // end if !IsSomeJerkBlockingYourCover
								} // end if(IsAngleToEnemyValidForThisCoverSlot( m_CoverMoveData.m_PreviousCover_Not_Clamied ) )
							} // end if( IsPotentialCover( m_CoverMoveData.m_PreviousCover_Not_Clamied ))
						} // end if( m_CoverMoveData.m_PreviousCover_Not_Clamied.Link.Slots[m_CoverMoveData.m_PreviousCover_Not_Clamied.SLotIdx].SlotOwner == None )
					} // end if ( m_CoverMoveData.m_PreviousCover_Not_Clamied.Link != None )
				}




				if( m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.Link != None &&
					( m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek ==  m_CoverMoveData.m_CurrentCover_Clamied ) )
				{
					//`log(" ChadAI - - Pawn: " @ Pawn @ " AttackUsingCoverGoalLoop m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek ==  m_CoverMoveData.m_CurrentCover_Clamied So lets see if I can just stay here -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

					;

					// check to see if the old cover is valid

					if ( m_CoverMoveData.m_CurrentCover_Clamied.Link != None )
					{
						//`log(" ChadAI - - " @ Pawn @ " Evaluating m_PreviousCover_NOT_Clamied Node : " @ m_CoverMoveData.m_CurrentCover_Clamied.Link @ " slot: " @ m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx @ "  --------------------------------------------------------------------------------------------" );	


							if( IsPotentialCover( m_CoverMoveData.m_CurrentCover_Clamied ))
							{
								if(IsAngleToEnemyValidForThisCoverSlot( m_CoverMoveData.m_CurrentCover_Clamied ) )
								{
									//`log(" ChadAI - Find best cover for goal - "@Pawn @ " Can conciderbecause of angle to enemy is valid for this slot Node: " @ currEvanNodeInfo.Link @ " slot: " @currEvanNodeInfo.SlotIdx @"-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");

									if( !IsSomeJerkBlockingYourCover( m_CoverMoveData.m_CurrentCover_Clamied.Link.GetSlotLocation(m_CoverMoveData.m_CurrentCover_Clamied.SLotIdx) ) )
									{
										//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackUsingCoverGoal::AttackUsingCoverGoalLoop FindBestCover failed and IsAngleToEnemyValidForThisCoverSlot = true -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

										//m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse = m_CoverMoveData.m_CurrentCover_Clamied;

										// if close enough to the new slot just occipy it snap to it and then use it
										if( CanIjustStayHereAndReuseThisCoverSlot(m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek) )
										{
											;
											
											// if the current cover is an open field mid level need to trans back to hide because that is where use cover expects NPCs to start at even in the open
											if(( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType == CT_OpenFieldMidLevel  ))
											{
												// the the pawn is hiding have him go to a non hiding pose then stand up
												 ;

												 m_CoverMoveData.m_RotAtStartOfTravel = Pawn.Rotation;

												m_CoverFightData.m_CurrentCoverAction = CA_PopUp;

												m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_FiringToHiding;
												m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;

												m_SubStateDebugInfoTag="Trans to hiding to redo an Free Attack Cover Slot";
												while(( m_CoverMoveData.m_CoverTransitionAction != CoverTransitionAction_NotTransitioning ) &&
													( (WorldInfo.TimeSeconds - m_CoverFightData.m_TimeStartedLastCoverTransition) < class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_MaxTimeToWaitForCoverTransitionToEnd ) )
												{
													DesiredRotation = m_CoverMoveData.m_RotAtStartOfTravel;
   													Pawn.DesiredRotation = DesiredRotation;
   													Pawn.SetRotation( DesiredRotation );
													Sleep(0.0);
												}
											}

											Goto('AttackFromCoverSubState');
										}

									} // end if !IsSomeJerkBlockingYourCover
								} // end if(IsAngleToEnemyValidForThisCoverSlot( m_CoverMoveData.m_PreviousCover_Not_Clamied ) )
							} // end if( IsPotentialCover( m_CoverMoveData.m_PreviousCover_Not_Clamied ))
					} // end if ( m_CoverMoveData.m_PreviousCover_Not_Clamied.Link != None )
				}



















				if( m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.Link != None )
				{
					//`log(" ChadAI - Pawn " @ Pawn @ " FreeAttackGoalLoop:: Can use cover and found some to use Node: " @ m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.Link @ " slot: " @ m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.SlotIdx @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					// now try to reserve the cover
					if( ReserveCover( m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek ) )
					{
						//`log(" ChadAI - Pawn " @ Pawn @ " FreeAttackGoalLoop:: Reserved Cover Node: " @ m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.Link @ " slot: " @ m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.SlotIdx @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

						// good cover to use

						//`log(" ChadAI - Pawn " @ Pawn @ " FreeAttackGoalLoop::Begin Has Cover that can be used lets try finding a path there -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


						m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_BuildingPath;

						KynapseGoToFindPath( m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.Link.GetSlotLocation( m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.SlotIdx ) );

						if ( KynapseFoundPath() )
						{
							//`log(" ChadAI - Pawn " @ Pawn @ " FreeAttackGoalLoop::Begin Has Cover Path Found Now Travel There -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

							m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_PathBuiltWaitingToMove;

							m_CoverMoveData.m_HasPathToCoverBeenBuilt = true;

							m_CoverMoveData.m_bCheckToSeeIfCoverIsStillValidDuringMoveToCover = true;

							PushState('TravelToCoverSlot');

							;

							//`log(" ChadAI - Pawn " @ Pawn @ " FreeAttackGoalLoop::Begin Back From Travel To Cover Slot status: " @ m_CoverMoveData.m_Move2CoverStatus @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

							if( Enemy == None )
							{
								//`log(" ChadAI - Pawn: " @ Pawn @ " FreeAttackGoalLoop:back from TravelToCoverSlot No More Enemy so need to end attack poping state-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
								;
								ClearCurrentCover();
								PopState();
							}
							else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_DoneMovingAtCover )
							{
								//`log(" ChadAI - Pawn " @ Pawn @ " FreeAttackGoalLoop::Begin Back From Travel To Cover Slot and status == Move2CovStat_DoneMovingAtCover PushState('UseFightingPosition') -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
							
								Goto('AttackFromCoverSubState');

							}
							else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedCQB_Needed )
							{
								//`log(" ChadAI - Pawn " @ Pawn @ " FreeAttackGoalLoop::Begin Back From Travel To Cover Slot and status == Move2CovStat_FailedCQB_Needed PushState('CloseQuartersBattleAttack') -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

								PushState('CloseQuartersBattleAttack');
							}
							else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedBlockedByPawn )
							{
								//`log(" ChadAI - Pawn " @ Pawn @ " FreeAttackGoalLoop::Begin Back From Travel To Cover Slot and status == Move2CovStat_FailedBlockedByPawn make cover invalid for small time -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
							}
							else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedBlockedByActor )
							{
								//`log(" ChadAI - Pawn " @ Pawn @ " FreeAttackGoalLoop::Begin Back From Travel To Cover Slot and status == Move2CovStat_FailedBlockedByActor make cover invalid for small time -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
							}
							else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedEnemyMadeCoverInvalid )
							{
								;

								InvalidateMoveGoal( m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.Link, m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.SlotIdx );

								ClearReservedCover();

								Goto('FreeAttackGoalLoop');
							}

						} // end if ( KynapseFoundPath() )
						else
						{

							//`log(" ChadAI - Pawn " @ Pawn @ " FreeAttackGoalLoop::Begin Does Not Have Cover Path Make Cover Invalid and Try for new cover by looping again -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

							;

							// no path
							m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_NoPathBuiltWaitingToMove;

							InvalidateMoveGoal( m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.Link, m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.SlotIdx );

							ClearReservedCover();

							// make cover invalid
						}

					}
					else // can not reserve the cover so make invalid and try again
					{
						;

						//`log(" ChadAI - Pawn " @ Pawn @ " FreeAttackGoalLoop:: Not able to Reserved Cover Node: " @ m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.Link @ " slot: " @ m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.SlotIdx @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
						InvalidateMoveGoal( m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.Link, m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.SlotIdx );
						// make cover invalid
					}
				} // end if( m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.Link != None )
				else
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ " FreeAttackGoalLoop Can use Cover But Not able to find any so Attack Stand -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					;
					Goto('NotAbleToAttackFromCoverSubState');
				}

			} // end trying to use cover
			else
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " FreeAttackGoalLoop Can not use cover so Going to default attack stand -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				;
				Goto('NotAbleToAttackFromCoverSubState');
			}
		} // end else if going to try cover or just stand and attack

		sleep(0.0);
		Goto('FreeAttackGoalLoop');
	}

NotAbleToAttackFromCoverSubState:

	if (ShouldIPursueEnemy())
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " NotAbleToAttackFromCoverSubState ShouldIPursueEnemy = true -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		;

		PushState('PursueEnemy');
	}
	else
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " NotAbleToAttackFromCoverSubState ShouldIPursueEnemy = false -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		;
	}

	PushState('Open_Field_Attack');

	Goto('FreeAttackGoalLoop');

AttackFromCoverSubState:

	m_CoverFightData.m_CurrentlyCoverToUseAsFightPos = m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek;

	m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_DoneMovingAtCover;

	m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_CurrentlyUsing;

	//`log(" ChadAI - Pawn " @ Pawn @ " Free_Attack_Goal Going to start using Node: " @ m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.Link @ " slot: " @ m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.SlotIdx @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	;

	PushState('UseFightingPosition');

	m_CoverFightData.m_CurrentlyCoverToUseAsFightPos = m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek;

	;

	//`log(" ChadAI - Pawn " @ Pawn @ " Free_Attack_Goal Back from Use Fighting Position Status: " @ m_CoverFightData.m_UseFightingPositionStatus  @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_None;

	if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_SucceededBecauseTimePassed )
	{
		Goto('DoneAttacking');
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_FailedBecauseForgotIt )
	{
		sleep(0.0);
		Goto('FreeAttackGoalLoop');
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_PausedGrenadeOut )
	{
		//sleep(0.0);
		Goto('FreeAttackGoalLoop');
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_FailedAngleToEnemy )
	{
		//sleep(0.1);
		Goto('FreeAttackGoalLoop');	
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_FailedNoLineOfFireToEnemy )
	{
		//sleep(0.1);
		Goto('FreeAttackGoalLoop');	
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_FailedDistanceToEnemy )
	{
		//sleep(0.1);
		Goto('FreeAttackGoalLoop');	
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_PausedEnemyIsAtCQB_Dist )
	{
		//`log(" ChadAI - Pawn " @ Pawn @ " Free_Attack_Goal::Begin Back From Use Fighting Pos and status == UseFightingPosition_PausedEnemyIsAtCQB_Dist PushState('CloseQuartersBattleAttack') -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		PushState('CloseQuartersBattleAttack');
		Goto('DoneAttacking');
	}
	else
	{
		;	
		//`log(" ChadAI - Free_Attack_Goal Back from Use Fighing Position and Failed for an Unknown Reason  m_CoverFightData.m_UseFightingPositionStatus: " @ m_CoverFightData.m_UseFightingPositionStatus @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		Goto('DoneAttacking');	
	}

DoneAttacking:

	//PopState();

	;

	m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link = None;
	m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.SlotIdx = -1;

	EvaluateSituation();
}


// checks to see if the current enemy may be CQBed and if so registers the attack and returns true
// if not returns false and does not register so the NPC should not be then told to attack
native final function bool RegisterToCQB_CurrentEnemy();

native function UnRegisterToCQB_CurrentEnemy();

state CloseQuartersBattleAttack
{
	ignores NotifyBump;

	// Not to C++
	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
	
		//`log(" ChadAI - SENSING - " @ self @ "CloseQuartersBattleAttack::OnSeeEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		if( CheckForEnemy(false) )
		{
			;
		}
	}
	
	// Not to C++
	// is only called when the heared player in a new enemy
	event OnHearEnemy(int playerIdx)
	{
		//`log(" ChadAI - SENSING - " @ self @ "CloseQuartersBattleAttack::OnHearEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		//`log(" ChadAI - SENSING - " @ self @ "CloseQuartersBattleAttack::OnHearEnemy - bNewEnemy so AcquireEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		//`AILOG(0, 'Sensory', "- CloseQuartersBattleAttack::OnHearEnemy CheckForEnemy: " @  m_playerList[playerIdx].Player.GetPawnName(true) );

		//AcquireEnemy(playerIdx);

		if( CheckForEnemy(false) )
		{
			;
		}
	}	
	
	// Not to C++
	function NotifyWeaponFired(Weapon W, byte FireMode)
	{
// 		if (Pawn != None && Pawn.Weapon != None && !IsInState('FireFromCover') && !IsInState('TakeHit')) //hmm, how to control this a better way?  Something like the 'ignores' keyword?
// 		{
// 			++BurstCount;
// 			if (BurstCount >= TPWeapon(Pawn.Weapon).BulletsPerBurst)
// 			{
// 				BurstCount = 0;
// 				//PushState('BurstFireWait');
// 			}
// 		}
	}
	
	// Not to C++
	function BeginState(Name PreviousStateName)
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		//`log(" ChadAI - MeleeAttack::BeginState ");

		SetAimAndHeadTrack();
	}
	
	// Not to C++
	function EndState (Name NextStateName)
	{
		;	

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;


		Target = None; 
		StopFiring();
		
		// don't crouch when player is too close fix. DK
		bForcedStand = false;
				
		m_bPauseFire = false;

		m_CQB_Data.m_SpeedBeforeChargeScale = Pawn.MaxDesiredSpeed;


		Pawn.MaxDesiredSpeed=m_CQB_Data.m_SpeedBeforeChargeScale;
		Pawn.DesiredSpeed=m_CQB_Data.m_SpeedBeforeChargeScale;

		if( m_CQB_Data.m_IamRegToCQBMyEnemy )
		{
			UnRegisterToCQB_CurrentEnemy();
		}
	}

// Not to C++
	event PausedState()
	{
		;	

			m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;


		m_bPauseFire = false;

	}
// Not to C++
	event ContinuedState()
	{
		;		

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;
	}
// Not to C++
	event PoppedState()
	{
		;					

		//`log(" ChadAI - TPSoldierAIController::CloseQuartersBattleAttack::PoppedState() -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;
	
		if( TPPawn(Pawn) != None )
		{
			Pawn.MaxDesiredSpeed=m_CQB_Data.m_SpeedBeforeChargeScale;
			Pawn.DesiredSpeed=m_CQB_Data.m_SpeedBeforeChargeScale;

		}
		else
		{
			//`log(" ChadAI - TPSoldierAIController::CloseQuartersBattleAttack::PoppedState() does not have valid pawn -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		}

		Target = None; 
		StopFiring();

		if( m_CQB_Data.m_IamRegToCQBMyEnemy )
		{
			UnRegisterToCQB_CurrentEnemy();
		}
	}
// Not to C++
	event Tick( float DeltaTime )
	{
		// No need to aim the Gun when Meleeing
		//UpdateAimInTheOpen(FALSE);;
		SetAimToStrightAhead();
		UpdateHeadtracking();

// 		if (Enemy != None && Pawn != None && TPWeapon(Pawn.Weapon) != None /*&& !IsInState('MeleeAttack')*/ )
// 		{
// 			
// 			if (VSizeSq(Enemy.Location - Pawn.Location) < (TPWeapon(Pawn.Weapon).MeleeDistance +  m_CQB_Data.m_AdditionalMeleeRangeOfAttack)*( TPWeapon(Pawn.Weapon).MeleeDistance + m_CQB_Data.m_AdditionalMeleeRangeOfAttack))
// 			{
// 				//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::CloseQuartersBattleAttack::Tick() Inside melee range before Kynapse Got us there so ending movement and pushing melee-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 				`AILOG(1, 'Melee', "Tick() Inside melee range before Kynapse Got us there so ending movement if moving");
// 
// 				KynapseClear();
// 			}
// 		}
// 		else
// 		{
// 			`AILOG(1, 'CloseQuartersBattleAttack', "Tick I have no Enemy or no Pawn so I am going to quit moving. parent state Goal: " @ m_HighLevelAiGoal @ "!");
// 			KynapseClear();
// 
// 			// PopState();
// 		}
		Super.Tick(DeltaTime);
	}

Begin:

	m_SubStateDebugInfoTag="Begin";

	//`log(" ChadAI - TPSoldierAIController::CloseQuartersBattleAttack::Begin() Time: " @ WorldInfo.TimeSeconds @ "!-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	if( Enemy != None )
	{
		//`log(" ChadAI - TPSoldierAIController::CloseQuartersBattleAttack::Begin() RegisterToCQB_CurrentEnemy -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		if( !RegisterToCQB_CurrentEnemy() )
		{
			;
			
			Sleep(0.0);
			PopState();
		}
		else
		{
			//`log(" ChadAI - TPSoldierAIController::CloseQuartersBattleAttack::Begin() I: "@ Pawn @ " was able to RegisterToCQB_CurrentEnemy: " @ Enemy @ " so i will start killing this guy -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		}

	}

	SetAimAndHeadTrack();

	if( !m_CQB_Data.m_bAbleToMeleeAttacks )
	{
		if( (Enemy != None) && Pawn != None && Pawn.Weapon != None && TPWeapon(Pawn.Weapon) != None )
		{
			if ( EnemyIsInRange( TPWeapon(Pawn.Weapon).MeleeDistance +  m_CQB_Data.m_AdditionalMeleeRangeOfAttack ) )
			{
				;
				Goto('CQB_MeleeAttackOnlySubState');
			}
		}
		else
		{
			Sleep(0.0);
			PopState();
		}
	}




	m_CQB_Data.m_NoOfTimesFailedCQB_Charge = 0;

	m_CQB_Data.m_bHasBlownOneMagBeforeCharge = false;

	ClearCurrentCover();
	ReserveCover(m_CoverFightData.m_CurrentlyCoverToUseAsFightPos);

	if (Pawn.bIsCrouched)
	{
		m_SubStateDebugInfoTag="CQB UnCrouching";

		DesiredRotation = rotator(Enemy.Location - Pawn.Location);
		DesiredRotation.Pitch = 0;
		Pawn.DesiredRotation = DesiredRotation;


		m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange = WorldInfo.TimeSeconds;

		if( Pawn != None && TPPawn(Pawn) != none )
		{
			Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToStanding;
		}

		;

		// OpenFieldPostureSwitchingState_GoingToCrouching
		while(	(Pawn.bIsCrouched && Pawn != None && TPPawn(Pawn) != none) ||
				(Pawn != None && TPPawn(Pawn) != none && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching ) )
		{
			Pawn.UnCrouch();
			Sleep(0.0);

			DesiredRotation = rotator(Enemy.Location - Pawn.Location);
			DesiredRotation.Pitch = 0;
			Pawn.DesiredRotation = DesiredRotation;
			Pawn.SetRotation(DesiredRotation);

			if( EnemyIsInRange( TPWeapon(Pawn.Weapon).MeleeDistance +  m_CQB_Data.m_AdditionalMeleeRangeOfAttack + 10 ) )
			{
				;					
				Goto('CQB_MeleeAttackSubState');
				break;
			}

			if( !Pawn.bIsCrouched && ( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange) >= 
										class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToStandPostureChangeToFinish ) )
			{
				;
				Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
				break;
			}
		}		
	}

   //ClearReservedCover();

	m_CQB_Data.m_SpeedBeforeChargeScale = Pawn.MaxDesiredSpeed;

CQB_Loop:

	if( (Enemy != None) && HasValidEnemy() && TPWeapon(Pawn.Weapon) != None)
	{

		if( IsInvalidatedCQB_Target( Enemy ) )
		{
			;

			;

			Goto('CQB_EndSubState');

		}

		if( EnemyIsInRange( TPWeapon(Pawn.Weapon).MeleeDistance +  m_CQB_Data.m_AdditionalMeleeRangeOfAttack + 10 ) )
		{
			;					

			Goto('CQB_MeleeAttackSubState');
		}

		if( m_CQB_Data.m_bHasBlownOneMagBeforeCharge && !EnemyIsInRange( m_CQB_Data.m_RangeToStartCQB_State + 100 ) )
		{
			//`log(" ChadAI -  Pawn: " @ Pawn @ " CloseQuartersBattleAttack:: first part of loop Reblow through mag -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			;

			// if I have LOS go back to blowing mag if not Charge
			if (Enemy != None && CanFireAtNotFromCover(Enemy))
			{
				m_CQB_Data.m_bHasBlownOneMagBeforeCharge = false;
			}
			else
			{
				Goto('CQB_MeleeChargeSubState');
			}
			//CHAD make sure this sleep is needed
			//sleep(0.1);
		}
		else
		{
			if( !m_CQB_Data.m_bHasBlownOneMagBeforeCharge )
			{
				//`log(" ChadAI -  Pawn: " @ Pawn @ " CloseQuartersBattleAttack::begin: pushing Attack_Stand_Before_Charge because !m_bHasBlownOneMagBeforeCharge ");

//				Pawn.PlaySound(SoundCue'S_Dia_AI_Cue.Combat.German_A.AI_Combat_01_German_A_01Cue');
				;

				Goto('CQB_BlowOneMagSubState');
			}
			else
			{
				//`log(" ChadAI - CloseQuartersBattleAttack::begin: not pushing  Attack_Stand_Before_Charge because m_bHasBlownOneMagBeforeCharge ");

			}
			// CHAD make sure this sleep is needed

			sleep(0.0);

			Goto('CQB_MeleeChargeSubState');

		} // the end of the big normal CQB state part of the loop
		
		sleep(0.0);

		Goto('CQB_Loop');
	} 

	Goto('CQB_EndSubState');

CQB_BlowOneMagSubState:

//	Pawn.PlaySound(SoundCue'S_Dia_AI_Cue.Combat.German_A.AI_Combat_01_German_A_01Cue');
	;

	// need to go through a mag before charging so 
	PushState('Attack_Stand_Before_Charge');

	Sleep(0.0);

	//`log(" ChadAI - CloseQuartersBattleAttack::begin: back from pushing Attack_Stand_Before_Charge ");

	if (Pawn.bIsCrouched)
	{
		m_SubStateDebugInfoTag="CQB BLow Mag UnCrouching";


		m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange = WorldInfo.TimeSeconds;

		if( Pawn != None && TPPawn(Pawn) != none )
		{
			Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToStanding;
		}

		;

		// OpenFieldPostureSwitchingState_GoingToCrouching
		while(	(Pawn.bIsCrouched && Pawn != None && TPPawn(Pawn) != none) ||
				(Pawn != None && TPPawn(Pawn) != none && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching ) )
		{
			Pawn.UnCrouch();
			Sleep(0.0);

			if( !Pawn.bIsCrouched && ( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange) >= 
										class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToStandPostureChangeToFinish ) )
			{
				;
				Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
				break;
			}
		}		
	}

	if( Enemy == None )
	{
		;
		Goto('CQB_EndSubState');
	}

	Goto('CQB_Loop');


CQB_MeleeChargeSubState:

	PushState('MeleeCharge');

	;

	Goto('CQB_Loop');

CQB_MeleeAttackSubState:

	if( m_CQB_Data.m_DelayBetweenStartOfMeleeStateAndTheAttackStart > 0.05 )
	{
		//`log(" ChadAI - CloseQuartersBattleAttack::begin: Sleeping for: " @ m_DelayBetweenStartOfMeleeStateAndTheAttackStart @ " before melee attack ");
		;

		Sleep(m_CQB_Data.m_DelayBetweenStartOfMeleeStateAndTheAttackStart);
	}

	//`log(" ChadAI - CloseQuartersBattleAttack::begin: About to push MeleeAttack before sound-Time: " @ WorldInfo.TimeSeconds @ "!" );
//	Pawn.PlaySound(SoundCue'S_Dia_AI_Cue.Combat.German_A.AI_Combat_01_German_A_01Cue');

	//`log(" ChadAI - TPSoldierAIController::CloseQuartersBattleAttack back from Kynapse but KynapseHas NOT Arrived But With In Melee Range push melee Melee -Time: " @ WorldInfo.TimeSeconds @ "!*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	PushState('MeleeAttack');

	// THIS SLEEP REALLY REALLY NEEDS TO BE HERE TO GIVE TIME FOR THE ANIMATIONS TO RESET
	Sleep(0.0);

	Goto('CQB_Loop');

CQB_MeleeAttackOnlySubState:

	if (Pawn.bIsCrouched)
	{
		m_SubStateDebugInfoTag="CQB Melee Only UnCrouching";

		m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange = WorldInfo.TimeSeconds;

		if( Pawn != None && TPPawn(Pawn) != none )
		{
			Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToStanding;
		}

		;


		// OpenFieldPostureSwitchingState_GoingToCrouching
		while(	(Pawn.bIsCrouched && Pawn != None && TPPawn(Pawn) != none) ||
				(Pawn != None && TPPawn(Pawn) != none && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching ) )
		{
			Pawn.UnCrouch();
			Sleep(0.0);

			if( !Pawn.bIsCrouched && ( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange) >= 
										class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToStandPostureChangeToFinish ) )
			{
				;
				Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
				break;
			}
		}	
	}

	ClearCurrentCover();
	ReserveCover(m_CoverFightData.m_CurrentlyCoverToUseAsFightPos);

	if( m_CQB_Data.m_DelayBetweenStartOfMeleeStateAndTheAttackStart > 0.05 )
	{
		//`log(" ChadAI - CloseQuartersBattleAttack::begin: Sleeping for: " @ m_DelayBetweenStartOfMeleeStateAndTheAttackStart @ " before melee attack ");
		;

		Sleep(m_CQB_Data.m_DelayBetweenStartOfMeleeStateAndTheAttackStart);
	}

	//`log(" ChadAI - CloseQuartersBattleAttack::begin: About to push MeleeAttack before sound-Time: " @ WorldInfo.TimeSeconds @ "!" );
//	Pawn.PlaySound(SoundCue'S_Dia_AI_Cue.Combat.German_A.AI_Combat_01_German_A_01Cue');

	//`log(" ChadAI - TPSoldierAIController::CloseQuartersBattleAttack back from Kynapse but KynapseHas NOT Arrived But With In Melee Range push melee Melee -Time: " @ WorldInfo.TimeSeconds @ "!*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	PushState('MeleeAttack');

	// THIS SLEEP REALLY REALLY NEEDS TO BE HERE TO GIVE TIME FOR THE ANIMATIONS TO RESET
	Sleep(0.0);

	if( (Enemy != None) && Pawn != None && Pawn.Weapon != None && TPWeapon(Pawn.Weapon) != None )
	{
		if ( EnemyIsInRange( TPWeapon(Pawn.Weapon).MeleeDistance +  m_CQB_Data.m_AdditionalMeleeRangeOfAttack ) )
		{
			;
			Goto('CQB_MeleeAttackOnlySubState');
		}
	}

	Goto('CQB_EndSubState');



CQB_EndSubState:

	PopState();

}

native final function MeleeChargeTickLogic();

state MeleeCharge
{
	function float GetDeathForceForRun()
	{
		return class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_DeathForceFactor_MeleeCharge;
	}

	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " TravelToCoverSlot::NotifyTakeHit m_bTookHitWhilePursuing set to true Pawn.Health: " @ Pawn.Health @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		//local Vector			centerPos;

		if( Pawn.Health < 1 )
		{
			if( !TPPawn(Pawn).m_bNeedsToPlowIn )
			{
				;
				
				Pawn.Health = 100;
				TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet = true;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetInstigatedBy = InstigatedBy;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetHitlocation = HitLocation;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetMomentum = Vector(Pawn.Rotation) * GetDeathForceForRun() ;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetDamageType = damageType;
				TPPawn(Pawn).m_bNeedsToPlowIn = true;

				KynapseClear();

			}
		}
	}


	// Not to C++
	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
	
		//`log(" ChadAI - SENSING - " @ self @ "MeleeCharge::OnSeeEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		if( CheckForEnemy(false) )
		{
			;
		}
	}
	
	// Not to C++
	// is only called when the heared player in a new enemy
	event OnHearEnemy(int playerIdx)
	{
		//`log(" ChadAI - SENSING - " @ self @ "MeleeCharge::OnHearEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		//`log(" ChadAI - SENSING - " @ self @ "MeleeCharge::OnHearEnemy - bNewEnemy so AcquireEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		//`AILOG(0, 'Sensory', "- MeleeCharge::OnHearEnemy CheckForEnemy: " @  m_playerList[playerIdx].Player.GetPawnName(true) );

		//AcquireEnemy(playerIdx);

		if( CheckForEnemy(false) )
		{
			;
		}
	}	
	// Not to C++
	function NotifyWeaponFired(Weapon W, byte FireMode)
	{

		if( m_Engagement_Tac_Data.m_bEngagingOnTheRun )
		{
			m_Engagement_Tac_Data.m_NoOfRoundsFiredThisBurst++;
		}

// 		if (Pawn != None && Pawn.Weapon != None && !IsInState('FireFromCover') && !IsInState('TakeHit')) //hmm, how to control this a better way?  Something like the 'ignores' keyword?
// 		{
// 			++BurstCount;
// 			if (BurstCount >= TPWeapon(Pawn.Weapon).BulletsPerBurst)
// 			{
// 				BurstCount = 0;
// 				//PushState('BurstFireWait');
// 			}
// 		}
	}
	// Not to C++
	function BeginState(Name PreviousStateName)
	{
		;	

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		SetAimAndHeadTrack();
	}
	// Not to C++
	function EndState (Name NextStateName)
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
		{
			KillTheTraveller();
		}

		Target = None; 
		StopFiring();
		
		// don't crouch when player is too close fix. DK
		bForcedStand = false;
				
		m_bPauseFire = false;

		m_CQB_Data.m_SpeedBeforeChargeScale = Pawn.MaxDesiredSpeed;


		if( Pawn != None )
		{
			Pawn.MaxDesiredSpeed=m_CQB_Data.m_SpeedBeforeChargeScale;
			Pawn.DesiredSpeed=m_CQB_Data.m_SpeedBeforeChargeScale;
		}


		if( m_CQB_Data.m_IamRegToCQBMyEnemy )
		{
			UnRegisterToCQB_CurrentEnemy();
		}

		if( m_Engagement_Tac_Data.m_bEngagingOnTheRun )
		{
			m_Engagement_Tac_Data.m_bEngagingOnTheRun = false;
			StopFiring();
		}

	}

// Not to C++
	event PausedState()
	{
		;	

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		m_bPauseFire = false;

		if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
		{
			KillTheTraveller();
			PopState();
		}

	}
// Not to C++
	event ContinuedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;
		m_Engagement_Tac_Data.m_bEngagingOnTheRun = false;
	}
// Not to C++
	event PoppedState()
	{
		;		

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		//`log(" ChadAI - TPSoldierAIController::MeleeCharge::PoppedState() -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		if( Pawn != None )
		{
			Pawn.MaxDesiredSpeed=m_CQB_Data.m_SpeedBeforeChargeScale;
			Pawn.DesiredSpeed=m_CQB_Data.m_SpeedBeforeChargeScale;

			if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
			{
				KillTheTraveller();
			}


		}
		else
		{
			//`log(" ChadAI - TPSoldierAIController::MeleeCharge::PoppedState() does not have valid pawn -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		}

		Target = None; 
		StopFiring();

		if( m_CQB_Data.m_IamRegToCQBMyEnemy )
		{
			UnRegisterToCQB_CurrentEnemy();
		}

		if( m_Engagement_Tac_Data.m_bEngagingOnTheRun )
		{
			m_Engagement_Tac_Data.m_bEngagingOnTheRun = false;
			StopFiring();
		}
	}
// Not to C++
	event Tick( float DeltaTime )
	{
		MeleeChargeTickLogic();
	}

Begin:

	m_SubStateDebugInfoTag="Begin";

	m_Engagement_Tac_Data.m_bEngagingOnTheRun = false;

	m_CQB_Data.m_TimeOfLastMeleeChargeFire = -1.0;

	//`log(" ChadAI - TPSoldierAIController::MeleeCharge::Begin() Time: " @ WorldInfo.TimeSeconds @ "!-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	SetAimAndHeadTrack();

	m_CQB_Data.m_NoOfTimesFailedCQB_Charge = 0;

	if (Pawn.bIsCrouched)
	{
		m_SubStateDebugInfoTag="Melee Charge UnCrouching";


		m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange = WorldInfo.TimeSeconds;

		if( Pawn != None && TPPawn(Pawn) != none )
		{
			Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToStanding;
		}

		;


		// OpenFieldPostureSwitchingState_GoingToCrouching
		while(	(Pawn.bIsCrouched && Pawn != None && TPPawn(Pawn) != none) ||
				(Pawn != None && TPPawn(Pawn) != none && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching ) )
		{
			Pawn.UnCrouch();
			Sleep(0.0);

			if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
			{
				KillTheTraveller();
				PopState();
			}


			if( !Pawn.bIsCrouched && ( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange) >= 
										class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToStandPostureChangeToFinish ) )
			{
				;
				Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
				break;
			}
		}		
	}

	if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
	{
		KillTheTraveller();
		PopState();
	}


	m_CQB_Data.m_SpeedBeforeChargeScale = Pawn.MaxDesiredSpeed;

	while( (Enemy != None) && HasValidEnemy() && TPWeapon(Pawn.Weapon) != None)
	{
		Target = Enemy;
		Focus = Target;

		Pawn.MaxDesiredSpeed	= m_CQB_Data.m_SpeedToChargeScale;
		Pawn.DesiredSpeed		= m_CQB_Data.m_SpeedToChargeScale;

//		Pawn.PlaySound(SoundCue'S_Dia_AI_Cue.Combat.German_A.AI_Combat_01_German_A_01Cue');


		;

		KynapseGoTowardFindPath(Enemy.Controller, (TPWeapon(Pawn.Weapon).MeleeDistance +  m_CQB_Data.m_AdditionalMeleeRangeOfAttack - 20) );
		if (KynapseFoundPath())
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " MeleeCharge I have a Path to: " @ Enemy @ " So Charging");
			;
			KynapseFollowPath(); // follow the found path

			if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
			{
				KillTheTraveller();
				PopState();
			}
		}
		else
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " MeleeCharge I DO NOT have a Path to: " @ Enemy @ " So InvalidateCQB_Target and go back to parent state");
			;
			InvalidateCQB_Target( Enemy );
			PopState();
		}
		/**************************/

		//TPPawn(Pawn).PostMoveTowardNotify();

		;

		if( Enemy != None && Pawn != None  && TPWeapon(Pawn.Weapon) != None)
		{
			if ( EnemyIsInRange( TPWeapon(Pawn.Weapon).MeleeDistance +  m_CQB_Data.m_AdditionalMeleeRangeOfAttack ) )
			{
				PopState();
			}
			else
			{
				if( (m_CQB_Data.m_TimeOfLastMeleeChargeFire < 0.0f ) || (m_CQB_Data.m_TimeOfLastMeleeChargeFire - WorldInfo.TimeSeconds ) > class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_TimeAfterLastMeleeChargeFireToGiveUpCharge )
				{

					m_CQB_Data.m_NoOfTimesFailedCQB_Charge = m_CQB_Data.m_NoOfTimesFailedCQB_Charge + 1;
					//`log("MeleeCharge::Back from Charge: EnemyIs NOT InRange: so looping CQB again m_NoOfTimesFailedCQB_Charge: " @ m_CQB_Data.m_NoOfTimesFailedCQB_Charge @ " !!!!!!!!!! ");
					;

					if( m_CQB_Data.m_NoOfTimesFailedCQB_Charge >= m_CQB_Data.m_NoOfTimesToFailCQB_ChargeBeforeGivingUp )
					{
						//`log("MeleeCharge::Loop: Charge Failed: " @ m_CQB_Data.m_NoOfTimesFailedCQB_Charge @ " so going to give up InvalidateCQB_Target and go back to what ever I was doing ");
						;
						InvalidateCQB_Target( Enemy );
						//Sleep(1.0f);
						PopState();
					}
					else if( m_CQB_Data.m_NoOfTimesFailedCQB_Charge >= m_CQB_Data.m_NoOfTimesToFailCQB_ChargeBeforeReblowingMag )
					{
						;					

						//`log("MeleeCharge::begin: Charge Failed: " @ m_CQB_Data.m_NoOfTimesFailedCQB_Charge @ " so going to reblow a mag ");

						m_CQB_Data.m_bHasBlownOneMagBeforeCharge = false;
					}
				}
			} // end else on if (VSizeSq(Enemy.Location - Pawn.Location) < (m_CQB_Data.m_MeleeRangeOfAttack-40)*(m_CQB_Data.m_MeleeRangeOfAttack-40))
		} // Knapse has not arrived and I do not have an enemy or pawn so give up
		else
		{
			;
			PopState();
		}
		
		sleep(0.0);
	} // while( (Enemy != None) && HasValidEnemy())

	PopState();
}

state Attack_While_Following
{
	// Not to C++
	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
	
		//`log(" ChadAI - SENSING - " @ self @ "Attack_While_Following::OnSeeEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
	
		// evaluate against our current one if new
// 		if (bNewEnemy)
// 		{
// 			//`log(" ChadAI - SENSING - " @ self @ "Attack_While_Following::OnSeeEnemy - bNewEnemy so AcquireEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
// 					`AILOG(1, 'Begin', "- defaulting to AttackStand");
// 
// 			`AILOG(3, 'Sensory', "- Attack_While_Following::OnSeeEnemy AcquiredEnemy: " @  m_playerList[playerIdx].Player.GetPawnName(true) );
// 			AcquireEnemy(playerIdx);
// 		}

		if( CheckForEnemy(false) )
		{
			;
		}

	}
	
	// Not to C++
	// is only called when the heared player in a new enemy
	event OnHearEnemy(int playerIdx)
	{
		//`log(" ChadAI - SENSING - " @ self @ "Attack_While_Following::OnHearEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		//`log(" ChadAI - SENSING - " @ self @ "Attack_While_Following::OnHearEnemy - bNewEnemy so AcquireEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		//`AILOG(0, 'Sensory', "- Attack_While_Following::OnHearEnemy AcquiredEnemy: " @  m_playerList[playerIdx].Player.GetPawnName(true) );
		//AcquireEnemy(playerIdx);
		if ( CheckForEnemy(false) )
		{
			;
		}

	}

	// Not to C++
	event Tick( float DeltaTime )
	{
		//`log(" ChadAI - TPSoldierAIController::Attack_While_Following::Tick -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		//`log(" ChadAI - TPSoldierAIController::Attack_While_Following::Tick:: Pawn.Location " @ Pawn.Location @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		
		if( DetermineIfShouldStartCQB_Tick( WorldInfo.TimeSeconds ) )
		{
			//`log(" ChadAI - TPSoldierAIController::Attack_While_Following::Tick:: EnemyIsInRange  m_RangeToStartCQB_State -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			
			PushState('CloseQuartersBattleAttack');
		}

		Super.Tick(DeltaTime);
	
	}

Begin:

	m_SubStateDebugInfoTag="Begin";

	//`log(" ChadAI - TPSoldierAIController::Attack_While_Following::Begin() -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	//MarkEnemyHostile(true);


	//`AILOG(0, 'Begin', "");
    //Sleep(0.1f);

FollowAttackLoop:

    while (HasValidEnemy())
	{

		if (ShouldIUseTurret() && m_DesiredTurret.ClaimTurret(Self) )
		{
			;

			PushState('Action_TurretGunning');
		}
		else // either use cover or stand and attack
		{
			if ( m_CoverMoveData.m_bAllowUseOfCover )
			{
				// try finding cover

				//`log(" ChadAI - Pawn " @ Pawn @ " Attack_While_Following:: Can use cover now lets see if can find some -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek = EvaluateCoverForFreeAttack();

				if( m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.Link != None )
				{
					//`log(" ChadAI - Pawn " @ Pawn @ " Attack_While_Following:: Can use cover and found some to use Node: " @ m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.Link @ " slot: " @ m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.SlotIdx @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					// now try to reserve the cover
					if( ReserveCover( m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek ) )
					{
						//`log(" ChadAI - Pawn " @ Pawn @ " Attack_While_Following:: Reserved Cover Node: " @ m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.Link @ " slot: " @ m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.SlotIdx @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

						// good cover to use

						//`log(" ChadAI - Pawn " @ Pawn @ " Attack_While_Following::Begin Has Cover that can be used lets try finding a path there -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


						m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_BuildingPath;

						KynapseGoToFindPath( m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.Link.GetSlotLocation( m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.SlotIdx ) );

						if ( KynapseFoundPath() )
						{
							//`log(" ChadAI - Pawn " @ Pawn @ " Attack_While_Following::Begin Has Cover Path Found Now Travel There -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

							m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_PathBuiltWaitingToMove;

							m_CoverMoveData.m_HasPathToCoverBeenBuilt = true;
							m_CoverMoveData.m_bCheckToSeeIfCoverIsStillValidDuringMoveToCover = true;

							PushState('TravelToCoverSlot');

							//`log(" ChadAI - Pawn " @ Pawn @ " Attack_While_Following::Begin Back From Travel To Cover Slot status: " @ m_CoverMoveData.m_Move2CoverStatus @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

							if( Enemy == None )
							{
								//`log(" ChadAI - Pawn: " @ Pawn @ " Attack_While_Following:back from TravelToCoverSlot No More Enemy so need to end attack poping state-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
								;

								PopState();
							}
							else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_DoneMovingAtCover )
							{
								//`log(" ChadAI - Pawn " @ Pawn @ " Attack_While_Following::Begin Back From Travel To Cover Slot and status == Move2CovStat_DoneMovingAtCover PushState('UseFightingPosition') -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
							
								Goto('AttackFromCoverSubState');


							}
							else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedCQB_Needed )
							{
								//`log(" ChadAI - Pawn " @ Pawn @ " Attack_While_Following::Begin Back From Travel To Cover Slot and status == Move2CovStat_FailedCQB_Needed PushState('CloseQuartersBattleAttack') -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

								PushState('CloseQuartersBattleAttack');
							}
							else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedBlockedByPawn )
							{
								//`log(" ChadAI - Pawn " @ Pawn @ " Attack_While_Following::Begin Back From Travel To Cover Slot and status == Move2CovStat_FailedBlockedByPawn make cover invalid for small time -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
							}
							else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedBlockedByActor )
							{
								//`log(" ChadAI - Pawn " @ Pawn @ " Attack_While_Following::Begin Back From Travel To Cover Slot and status == Move2CovStat_FailedBlockedByActor make cover invalid for small time -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
							}
							else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedEnemyMadeCoverInvalid )
							{
								;

								InvalidateMoveGoal( m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.Link, m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.SlotIdx );

								ClearReservedCover();

								Goto('FollowAttackLoop');
							}

						} // end if ( KynapseFoundPath() )
						else
						{

							//`log(" ChadAI - Pawn " @ Pawn @ " Attack_While_Following::Begin Does Not Have Cover Path Make Cover Invalid and Try for new cover by looping again -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

							// no path
							m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_NoPathBuiltWaitingToMove;

							InvalidateMoveGoal( m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.Link, m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.SlotIdx );

							ClearReservedCover();
							// make cover invalid
						}

					}
					else // can not reserve the cover so make invalid and try again
					{
						//`log(" ChadAI - Pawn " @ Pawn @ " Attack_While_Following:: Not able to Reserved Cover Node: " @ m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.Link @ " slot: " @ m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.SlotIdx @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
						;

						// make cover invalid
					}
				} // end if( m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.Link != None )
				else
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ " Attack_While_Following Can use Cover But Not able to find any so Attack Stand -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					;
					PushState('Open_Field_Attack');
				}

			} // end trying to use cover
			else
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " Attack_While_Following Can not use cover so Going to default attack stand -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				;
				PushState('Open_Field_Attack');
			}
		} // end else if going to try cover or just stand and attack

		Sleep(0.0);

	} // end while has valid enemy

	Goto('DoneAttacking');


AttackFromCoverSubState:

	m_CoverFightData.m_CurrentlyCoverToUseAsFightPos = m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek;

	m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_DoneMovingAtCover;

	m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_CurrentlyUsing;

	PushState('UseFightingPosition');

	m_CoverFightData.m_CurrentlyCoverToUseAsFightPos = m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek;

	//`log(" ChadAI - Pawn " @ Pawn @ " Attack_While_Following Back from Use Fighting Position Status: " @ m_CoverFightData.m_UseFightingPositionStatus  @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_None;

	if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_SucceededBecauseTimePassed )
	{
		Goto('DoneAttacking');
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_FailedBecauseForgotIt )
	{
		Goto('FollowAttackLoop');
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_PausedGrenadeOut )
	{
		Goto('FollowAttackLoop');
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_FailedAngleToEnemy )
	{
		Goto('FollowAttackLoop');	
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_FailedNoLineOfFireToEnemy )
	{
		Goto('FollowAttackLoop');	
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_FailedDistanceToEnemy )
	{
		Goto('FollowAttackLoop');	
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_PausedEnemyIsAtCQB_Dist )
	{
		//`log(" ChadAI - Pawn " @ Pawn @ " Attack_While_Following::Begin Back From Use Fighting Pos and status == UseFightingPosition_PausedEnemyIsAtCQB_Dist PushState('CloseQuartersBattleAttack') -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		PushState('CloseQuartersBattleAttack');
		Goto('FollowAttackLoop');
	}
	else
	{
		;	
		//`log(" ChadAI - Attack_While_Following Back from Use Fighing Position and Failed for an Unknown Reason  m_CoverFightData.m_UseFightingPositionStatus: " @ m_CoverFightData.m_UseFightingPositionStatus @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		Goto('DoneAttacking');	
	}

DoneAttacking:

	m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link = None;
	m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.SlotIdx = -1;


	PopState();
}



state Open_Field_Attack
{
	// Not to C++
	function BeginState(Name PreviousStateName)
	{
		//`log(" ChadAI - Open_Field_Attack::BeginState ");
		;

		// don't crouch when player is too close fix. DK
		//UpdateForcedStand(); // need to force an update so bForcedStand is set
		//Pawn.ShouldCrouch(!bForcedStand && ChanceOfCrouching() && IsEnemyShootableWhenCrouched()); // use distance and sight check to crouch

		SetAimAndHeadTrack();
	}

	// Not to C++
	function EndState (Name NextStateName)
	{
		;

		Target = None; 
		StopFiring();
		
		// don't crouch when player is too close fix. DK
		bForcedStand = false;
		
		if (Pawn != None)
		{
			Pawn.SetMovementType( MovementType_Default );

			Pawn.MaxDesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
			Pawn.DesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
		}

		
		m_bPauseFire = false;

		m_Engagement_Tac_Data.m_bTookHit = false;
	}
// Not to C++
	event PushedState()
	{
		;

		//UpdateForcedStand(); // need to force an update so bForcedStand is set
		//Pawn.ShouldCrouch(!bForcedStand && ChanceOfCrouching() && IsEnemyShootableWhenCrouched()); // use distance and sight check to crouch

		m_Engagement_Tac_Data.m_bScaredBackToCoverWhileSteppedOut = false;

		SetAimAndHeadTrack();
	}

// Not to C++
	event PausedState()
	{
		;

		StopFiring();

		m_bPauseFire = false;
	}
// Not to C++
	event ContinuedState()
	{
		;
		StopFiring();
	}
// Not to C++
	event PoppedState()
	{
		;

		Target = None; 
		StopFiring();
		
		// don't crouch when player is too close fix. DK
		bForcedStand = false;
		
		if (Pawn != None)
		{
			Pawn.SetMovementType( MovementType_Default );

			Pawn.MaxDesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
			Pawn.DesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;

		}
		
		m_bPauseFire = false;

		m_Engagement_Tac_Data.m_bTookHit = false;

	
	}
// Not to C++
	//callback called by timer
	function ClearHitTimeOut()
	{
		m_bHitTimeOut = false;
	}
// Not to C++
	//callback called by timer - this is a safety timeout, but OnAnimEnd should really be responsible for popping this state
	function HitAnimTimeOut()
	{
		//PopState();
	}

// Not to C++
	function TakeHitStart(bool bRestart)
	{	
		m_bHitTimeOut = true;
		m_bHitRestart = bRestart;
		
		SetTimer(0.2f,false,'ClearHitTimeOut');
				
	}
	// Not to C++
	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Attack::NotifyTakeHit m_bTookHit set to true -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;
		m_Engagement_Tac_Data.m_bTookHit = true;
		m_Engagement_Tac_Data.m_LastTimeKnewTookHit = WorldInfo.TimeSeconds;

		m_Engagement_Tac_Data.m_bHaveAlreadyTestedTacStepForThisReloadOrHitOrAimedAt = false;
	}

	// Not to C++
	//---------------------------------------------------------------------------
	// Function:
	// Description:	Callback from weapon when it is fired.
	//---------------------------------------------------------------------------
	function NotifyWeaponFired(Weapon W, byte FireMode)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Attack::NotifyWeaponFired BurstCount: " @ BurstCount @ " BulletsPerBurst: " @ TPWeapon(Pawn.Weapon).BulletsPerBurst  @" -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
		//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Attack::NotifyWeaponFired bIsNPCWeapon: " @ TPWeapon(Pawn.Weapon).bIsNPCWeapon@ " AmmoCount: " @ TPWeapon(Pawn.Weapon).AmmoCount @ " GetAmmoInMagazine(): " @ TPWeapon(Pawn.Weapon).GetAmmoInMagazine()  @" -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		if (Pawn != None && Pawn.Weapon != None ) //hmm, how to control this a better way?  Something like the 'ignores' keyword?
		{
			if( !m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd )
			{
				++BurstCount;
				if (BurstCount >= TPWeapon(Pawn.Weapon).BulletsPerBurst)
				{
					m_Engagement_Tac_Data.m_TimeToWaitForWeaponBurstDelay = RandRange(TPWeapon(Pawn.Weapon).BurstDelayMin, TPWeapon(Pawn.Weapon).BurstDelayMax);

					m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd = true;
					m_Engagement_Tac_Data.m_TimeStartedWaitForWeaponBurstDelay = WorldInfo.TimeSeconds;

					//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack::NotifyWeaponFired Time to wait BurstCount: " @ BurstCount @ " Delay of: " @ m_Engagement_Tac_Data.m_TimeToWaitForWeaponBurstDelay @ " -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
					;

					StopFiring();
					BurstCount = 0;
				}

			}

			if( TPWeapon(Pawn.Weapon).GetAmmoInMagazine() == 0 )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack::NotifyWeaponFired Mag is Empty -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

				m_Engagement_Tac_Data.m_LastTimeLOS_4_DefaultAttacksChecked = -1.0;
				m_Engagement_Tac_Data.m_bHaveAlreadyTestedTacStepForThisReloadOrHitOrAimedAt = false;

			}
		}
	}
// Not to C++
	function WeaponReloaded()
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack::NotifyWeaponReloadEnded fn called");
		BurstCount = 0; // reset this so it fires the correct number of bullets per burst after reload
		m_Engagement_Tac_Data.m_LastTimeLOS_4_DefaultAttacksChecked = -1.0;
	}
// Not to C++
	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
	
		//`log(" ChadAI - SENSING - " @ self @ "Open_Field_Attack::OnSeeEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
			//`AILOG(0, 'Sensory', "- Open_Field_Attack::OnSeeEnemy CheckForEnemy: " @  m_playerList[playerIdx].Player.GetPawnName(true) );

		CheckForEnemy(false);
	}
	
	// Not to C++
	// is only called when the heared player in a new enemy
	event OnHearEnemy(int playerIdx)
	{
		//`log(" ChadAI - SENSING - " @ self @ "Open_Field_Attack::OnHearEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		//`log(" ChadAI - SENSING - " @ self @ "Open_Field_Attack::OnHearEnemy - bNewEnemy so CheckForEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		//`AILOG(0, 'Sensory', "- Open_Field_Attack::OnHearEnemy CheckForEnemy: " @  m_playerList[playerIdx].Player.GetPawnName(true) );
		CheckForEnemy(false);
	}
// To C++
	function bool DetermineIfShouldStandForTurn()
	{
		local int positiveDesiredYaw;
		local int positivePawnYaw;
		//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfShouldStandForTurn ---------------------------------------------------------------------------------------------");

		//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfShouldStandForTurn DesiredRotation.Yaw: " @ DesiredRotation.Yaw @ " Pawn.Rotation.Yaw: " @ Pawn.Rotation.Yaw  @ " diff: " @ Abs( DesiredRotation.Yaw- Abs( Pawn.Rotation.Yaw )) @ " -----------------------------------------------------------------------------------");
		//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfShouldStandForTurn Abs( DesiredRotation.Yaw): " @ Abs( DesiredRotation.Yaw ) @ " Abs(  Pawn.Rotation ) : " @ Abs( Pawn.Rotation.Yaw ) @ " diff: " @ Abs(Abs( DesiredRotation.Yaw ) - Abs( Pawn.Rotation.Yaw )) @ " -----------------------------------------------------------------------------------");

		positiveDesiredYaw = DesiredRotation.Yaw;

		if( positiveDesiredYaw < 0.0 )
		{
			positiveDesiredYaw = 65536.0f + positiveDesiredYaw;
		}

		positivePawnYaw = Pawn.Rotation.Yaw;

		if( positivePawnYaw < 0.0 )
		{
			positivePawnYaw = 65536.0f + positivePawnYaw;
		}

		//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfShouldStandForTurn positiveDesiredYaw: " @ positiveDesiredYaw @ " positivePawnYaw : " @ positivePawnYaw @ " diff: " @ Abs( positiveDesiredYaw - positivePawnYaw ) @ " -----------------------------------------------------------------------------------");


		if( Abs( positiveDesiredYaw - positivePawnYaw) > 3000.0 )
		{
			return true;
		}

		return false;
	}

	// To C++
	event Tick( float DeltaTime )
	{

		if( m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd )
		{
			if( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedWaitForWeaponBurstDelay ) >= m_Engagement_Tac_Data.m_TimeToWaitForWeaponBurstDelay )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack_ Tick Time to wait BurstCount Ended -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

				// enough time has passed so end waiting for burst cool down time
				m_Engagement_Tac_Data.m_LastTimeLOS_4_DefaultAttacksChecked = -1.0;
				m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd = false;
			}
		}

		if( m_Engagement_Tac_Data.m_bSideSteping && !m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack_ SideStep:: not wait for burst cool down. start firing-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

			;

			
				TP_AiStartFiring();
			


		}



		UpdateAimInTheOpen(FALSE);;
		UpdateHeadtracking();

		if (anode_WeaponBlend != none)
		{
			if (Pawn == none || Pawn.Weapon == none)
				anode_WeaponBlend.SetBlendTarget(1.0, 0.2);
			else
				anode_WeaponBlend.SetBlendTarget(0.0, 0.2);
		}

		Super.Tick(DeltaTime);
	}
begin:

	m_SubStateDebugInfoTag="Begin";
	
	//`log(" ChadAI - Open_Field_Attack::begin: &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
	//`log(" ChadAI - Open_Field_Attack::begin: &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
	//`log(" ChadAI - Open_Field_Attack::begin: &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
	//`log(" ChadAI - Open_Field_Attack::begin: &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
	//`log(" ChadAI - Open_Field_Attack::begin: &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");

	SetAimAndHeadTrack();

	m_Engagement_Tac_Data.m_LastTimeLOS_4_DefaultAttacksChecked = -1.0;

	m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd = false;

	m_Engagement_Tac_Data.m_bScaredBackToCoverWhileSteppedOut = false;

	m_Engagement_Tac_Data.m_bTookHit = false;

	m_Engagement_Tac_Data.m_bHaveAlreadyTestedTacStepForThisReloadOrHitOrAimedAt = false;

	if( m_CoverMoveData.m_CurrentCover_Clamied.Link != None )
	{
		ClearCurrentCover();
	}

	m_Engagement_Tac_Data.m_bShouldCrouchForFreeAttack = !bForcedStand && ChanceOfCrouching() && IsEnemyShootableWhenCrouched();

Open_Field_Attack_Loop:

	m_SubStateDebugInfoTag="Top Of Loop";
	//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack::Open_Field_Attack_Loop: Top Of Loop Enemy: " @ Enemy @ " Pawn.bIsCrouched " @ Pawn.bIsCrouched );


	if (!HasValidEnemy())
	{
		;
		//`log(" ChadAI - Attack_Stand::begin: No valid enemy ");

		;
		//EvaluateSituation();
		Sleep(0.0);
		PopState();
	}
	else
	{
		//`log(" ChadAI - Open_Field_Attack::Open_Field_Attack_Loop: has valid enemy: " @ Enemy );

		if( Enemy != None )
		{
			Target = Enemy;
			Focus = Target;

			if( DetermineIfShouldStartCQB_Tick( WorldInfo.TimeSeconds ) )
			{
				Goto('CQB');
			}
			else if( DetermineIfGrenadeShouldBeAutoThrown() )
			{
				//`log(" ChadAI - Pawn " @ Pawn @ " FreeAttackGoalLoop DetermineIfGrenadeShouldBeThrown");
				;
				PushState('UseGrenadeAgainstEnemy');
				Goto('Open_Field_Attack_Loop');
			}
		}

		// need to determine if I should turn at all

		if( Enemy != None && ShouldITurnToTarget( false ) )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack_Loop: ShouldITurnToTarget == true ");

			;

		
			if (Pawn.bIsCrouched)
			{

				//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack_Loop: Pawn.bIsCrouched before DetermineIfShouldStandForTurn");

				if( DetermineIfShouldStandForTurn() )
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack_Loop: Pawn.bIsCrouched and Determined IfShouldStandForTurn so UnCrouch");

					m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange = WorldInfo.TimeSeconds;

					if( Pawn != None && TPPawn(Pawn) != none )
					{
						Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToStanding;
					}

					;


					// OpenFieldPostureSwitchingState_GoingToCrouching
					while(	(Pawn.bIsCrouched && Pawn != None && TPPawn(Pawn) != none) ||
							(Pawn != None && TPPawn(Pawn) != none && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching ) )
					{
						Pawn.UnCrouch();
						Sleep(0.0);

						if( !Pawn.bIsCrouched && ( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange) >= 
													class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToStandPostureChangeToFinish ) )
						{
							;
							Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
							break;
						}
					}

					//m_Engagement_Tac_Data.m_TimeStartedToWaitForToCrouchPostureChange
					//`TuneData.EngagementTacData.m_MaxTimeToWaitForToCrouchPostureChangeToFinish

					//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack_Loop: after Determined IfShouldStandForTurn and UnCrouch- Pawn.bIsCrouched: " @ Pawn.bIsCrouched );

				}

				// if Pawn.Rotation.Yaw - DesiredRotation.Yaw > 3000.0 then stand

				Focus = Target;

				if( Focus != None )
				{
					DesiredRotation = rotator(Focus.Location - Pawn.Location);
					DesiredRotation.Pitch = 0;

					if( DesiredRotation.Yaw < 0 )
					{
						DesiredRotation.Yaw = 65536 + DesiredRotation.Yaw;
					}

					if( DesiredRotation.Yaw < 0 )
					{
						//`log(" ChadAI - &$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@! -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
						//`log(" ChadAI - OPEN_FIELD_ATTACK_LOOP: DesiredRotation.Yaw: " @ DesiredRotation.Yaw);					
						//`log(" ChadAI - OPEN_FIELD_ATTACK_LOOP: BEFORE FINISHROTATION AND PRESERVEROTATION - DESIREDROTATION.YAW < 0 -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
						//`log(" ChadAI - OPEN_FIELD_ATTACK_LOOP: BEFORE FINISHROTATION AND PRESERVEROTATION - DESIREDROTATION.YAW < 0 -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
						//`log(" ChadAI - OPEN_FIELD_ATTACK_LOOP: BEFORE FINISHROTATION AND PRESERVEROTATION - DESIREDROTATION.YAW < 0 -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
						//`log(" ChadAI - OPEN_FIELD_ATTACK_LOOP: BEFORE FINISHROTATION AND PRESERVEROTATION - DESIREDROTATION.YAW < 0 -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
						//`log(" ChadAI - OPEN_FIELD_ATTACK_LOOP: BEFORE FINISHROTATION AND PRESERVEROTATION - DESIREDROTATION.YAW < 0 -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
						//`log(" ChadAI - OPEN_FIELD_ATTACK_LOOP: BEFORE FINISHROTATION AND PRESERVEROTATION - DESIREDROTATION.YAW < 0 -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
						//`log(" ChadAI - OPEN_FIELD_ATTACK_LOOP: BEFORE FINISHROTATION AND PRESERVEROTATION - DESIREDROTATION.YAW < 0 -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
						//`log(" ChadAI - &$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@! -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
					}

					//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack_Loop: Before FinishRotation and PreserveRotation- Pawn.bIsCrouched: " @ Pawn.bIsCrouched );

					FinishRotation();

					// preserve the new orientation and stop turning
					PreserveRotation();
				}

				//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack_Loop: after FinishRotation and PreserveRotation- Pawn.bIsCrouched: " @ Pawn.bIsCrouched );

				//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack_Loop: after ChangePosture- Pawn.bIsCrouched: " @ Pawn.bIsCrouched );

			}
			else // for if (Pawn.bIsCrouched)
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack_Loop: Pawn.bIsCrouched == false before FinishRotation- Pawn.bIsCrouched: " @ Pawn.bIsCrouched);

				Focus = Target;

				if( Focus != None )
				{

					DesiredRotation = rotator(Focus.Location - Pawn.Location);
					DesiredRotation.Pitch = 0;

// 					if( DesiredRotation.Yaw < 0 )
// 					{
// 						DesiredRotation.Yaw = 65536 + DesiredRotation.Yaw;
// 					}
// 
// 					if( DesiredRotation.Yaw < 0 )
// 					{
// 						//`log(" ChadAI - &$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@! -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
// 						//`log(" ChadAI - OPEN_FIELD_ATTACK_LOOP: Pawn.bIsCrouched == false  BEFORE FINISHROTATION AND PRESERVEROTATION - DESIREDROTATION.YAW < 0 -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
// 						//`log(" ChadAI - OPEN_FIELD_ATTACK_LOOP: Pawn.bIsCrouched == false  BEFORE FINISHROTATION AND PRESERVEROTATION - DESIREDROTATION.YAW < 0 -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
// 						//`log(" ChadAI - OPEN_FIELD_ATTACK_LOOP: Pawn.bIsCrouched == false  BEFORE FINISHROTATION AND PRESERVEROTATION - DESIREDROTATION.YAW < 0 -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
// 						//`log(" ChadAI - OPEN_FIELD_ATTACK_LOOP: Pawn.bIsCrouched == false  BEFORE FINISHROTATION AND PRESERVEROTATION - DESIREDROTATION.YAW < 0 -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
// 						//`log(" ChadAI - OPEN_FIELD_ATTACK_LOOP: Pawn.bIsCrouched == false  BEFORE FINISHROTATION AND PRESERVEROTATION - DESIREDROTATION.YAW < 0 -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
// 						//`log(" ChadAI - OPEN_FIELD_ATTACK_LOOP: Pawn.bIsCrouched == false  BEFORE FINISHROTATION AND PRESERVEROTATION - DESIREDROTATION.YAW < 0 -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
// 						//`log(" ChadAI - OPEN_FIELD_ATTACK_LOOP: Pawn.bIsCrouched == false  BEFORE FINISHROTATION AND PRESERVEROTATION - DESIREDROTATION.YAW < 0 -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
// 						//`log(" ChadAI - &$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@! -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
// 					}

					FinishRotation();

					// preserve the new orientation and stop turning
					PreserveRotation();
				}

				//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack_Loop: Pawn.bIsCrouched == false after FinishRotation- Pawn.bIsCrouched: " @ Pawn.bIsCrouched);

			} // end else for if (Pawn.bIsCrouched)

		} // end ShouldITurnToTarget
		else
		{
			;

			if( Focus != None )
			{

				DesiredRotation = rotator(Focus.Location - Pawn.Location);
				DesiredRotation.Pitch = 0;

// 				if( DesiredRotation.Yaw < 0 )
// 				{
// 					DesiredRotation.Yaw = 65536 + DesiredRotation.Yaw;
// 				}
// 
// 				if( DesiredRotation.Yaw < 0 )
// 				{
// 						//`log(" ChadAI - &$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@! -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
// 						//`log(" ChadAI - OPEN_FIELD_ATTACK_LOOP: !ShouldITurnToTarget - DESIREDROTATION.YAW < 0 -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
// 						//`log(" ChadAI - OPEN_FIELD_ATTACK_LOOP: !ShouldITurnToTarget - DESIREDROTATION.YAW < 0 -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
// 						//`log(" ChadAI - OPEN_FIELD_ATTACK_LOOP: !ShouldITurnToTarget - DESIREDROTATION.YAW < 0 -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
// 						//`log(" ChadAI - OPEN_FIELD_ATTACK_LOOP: !ShouldITurnToTarget - DESIREDROTATION.YAW < 0 -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
// 						//`log(" ChadAI - OPEN_FIELD_ATTACK_LOOP: !ShouldITurnToTarget - DESIREDROTATION.YAW < 0 -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
// 						//`log(" ChadAI - OPEN_FIELD_ATTACK_LOOP: !ShouldITurnToTarget - DESIREDROTATION.YAW < 0 -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
// 						//`log(" ChadAI - OPEN_FIELD_ATTACK_LOOP: !ShouldITurnToTarget - DESIREDROTATION.YAW < 0 -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
// 						//`log(" ChadAI - &$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@! -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
// 				}
			}
		}

		if( m_Engagement_Tac_Data.m_bShouldCrouchForFreeAttack && !Pawn.bIsCrouched && !IsReloading())
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack_Loop - m_Engagement_Tac_Data.m_bShouldCrouchForFreeAttack && !Pawn.bIsCrouched -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			//UpdateForcedStand();
			// OpenFieldPostureSwitchingState_GoingToCrouching or OpenFieldPostureSwitchingState_GoingToStanding
			;

			m_Engagement_Tac_Data.m_TimeStartedToWaitForToCrouchPostureChange = WorldInfo.TimeSeconds;

			if( Pawn != None && TPPawn(Pawn) != none )
			{
				Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToCrouching;
				Pawn.ShouldCrouch(true); // use distance and sight check to crouch
			}

			if( !m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack_ SideStep:: not wait for burst cool down. start firing-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

				;

				
					TP_AiStartFiring();
				


			}

			while(	(Pawn.bIsCrouched && Pawn != None && TPPawn(Pawn) != none) ||
					(Pawn != None && TPPawn(Pawn) != none && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching ) )
			{
				Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToCrouching;
				Pawn.ShouldCrouch(true); // use distance and sight check to crouch
				Sleep(0.0);

				if( !m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd )
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack_ SideStep:: not wait for burst cool down. start firing-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

					;

					
						TP_AiStartFiring();
					


				}

				//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Pawn.bIsCrouched: " @ Pawn.bIsCrouched @ " Time Waited: " @ WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToCrouchPostureChange @ " Max Time to Wait: " @ `TuneData.EngagementTacData.m_MaxTimeToWaitForToCrouchPostureChangeToFinish @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				if( Pawn.bIsCrouched && ( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToCrouchPostureChange) >= 
											class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToCrouchPostureChangeToFinish ) )
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ " Waited to Long while changing Posture to crouch so force quiting -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					;
					Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
					break;
				}
			}

			m_Engagement_Tac_Data.m_LastTimeCrouched = WorldInfo.TimeSeconds;
		}

		//`log(" ChadAI - Pawn: " @ Pawn @ " Done with crouching and on to the attack -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


		// Put while loop to let rotation catch up

		//m_Engagement_Tac_Data.m_bScaredBackToCoverWhileSteppedOut = true;
		if( IsReloading() || m_Engagement_Tac_Data.m_bScaredBackToCoverWhileSteppedOut || m_Engagement_Tac_Data.m_bTookHit || m_Engagement_Tac_Data.m_bKnowBeingAimedAt )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack_Loop - IsReloading() || m_Engagement_Tac_Data.m_bScaredBackToCoverWhileSteppedOut || m_Engagement_Tac_Data.m_bTookHit: -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack_Loop - m_bAllowTacticalSteping: " @ m_Engagement_Tac_Data.m_bAllowTacticalSteping @ " m_bHaveAlreadyTestedTacStepForThisReloadOrHitOrAimedAt: " @ m_Engagement_Tac_Data.m_bHaveAlreadyTestedTacStepForThisReloadOrHitOrAimedAt @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			// Only allow tac stepping if enough time has passed since posture change
			if( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_LastTimeCrouched ) > class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MinTimeBetweenPostureChanges )
			{
			// else if reloading see if can seek hasty cover
				if( m_Engagement_Tac_Data.m_bAllowTacticalSteping && (!m_Engagement_Tac_Data.m_bHaveAlreadyTestedTacStepForThisReloadOrHitOrAimedAt || IsReloading() ) )
				{  
					m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForHastyCover(	Enemy,
																								Vector(Pawn.Rotation), 
																								m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																								false);

					//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack_Loop - I am reloading or scared or took hit  and just tested move to hasty cover Move Need: " @ m_Engagement_Tac_Data.m_MoveNeed2Kill @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					//`log(" ChadAI - Pawn: " @ Pawn @ " Vector(Pawn.Rotation):	" @ Vector(Pawn.Rotation) @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					//`log(" ChadAI - Pawn: " @ Pawn @ " Vector(DesiredRotation): " @ Vector(DesiredRotation) @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


					m_Engagement_Tac_Data.m_bHaveAlreadyTestedTacStepForThisReloadOrHitOrAimedAt = true;

					if( m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel &&
						m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_None )
					{
						m_Engagement_Tac_Data.m_bSideSteping = true;

						;

						//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack_Loop - I am reloading or scared or took hit  and can move to hasty cover Move Need: " @ m_Engagement_Tac_Data.m_MoveNeed2Kill @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
						m_Engagement_Tac_Data.m_TimeStartedToOpenFieldTacticallyEvadeFromCover = WorldInfo.TimeSeconds;
						Goto('SeekHastyCover');						
					}
					else
					{
						;
						m_Engagement_Tac_Data.m_TimeStartedToOpenFieldTacticallyEvadeFromCover = WorldInfo.TimeSeconds;
						m_Engagement_Tac_Data.m_bSideSteping = true;
						Goto('SideStepEvade');

						//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Attack_Loop - I am reloading or scared or took hit and can NOT move to hasty cover Move Need: " @ m_Engagement_Tac_Data.m_MoveNeed2Kill @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					}
				} // end if( m_Engagement_Tac_Data.m_bAllowTacticalSteping )
				else
				{
					;
				}
			}
			else
			{
				 ;
			}

		} // end else for reoading and can shoot

		
        if ( !m_Engagement_Tac_Data.m_bSideSteping && !EnemyRecentlyVisible(true) )
		{
			//`log(" ChadAI - Open_Field_Attack_Loop EnemyRecentlyVisible(true): " @ EnemyRecentlyVisible(true) @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			//`log(" ChadAI - Open_Field_Attack_Loop CanFireAt(Enemy): " @ CanFireAt(Enemy) @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			//`log(" ChadAI - Open_Field_Attack_Loop SO STOP FIRING and  EvaluateSituation -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			StopFiring();
			
			;
			
			Sleep(0.0);
			PopState();
		}
		else
		{

			if( (m_Engagement_Tac_Data.m_LastTimeLOS_4_DefaultAttacksChecked < 0.0f ) ||
				( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_LastTimeLOS_4_DefaultAttacksChecked ) >= class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_HowOfftenToCheckLOS_4_DefaultAttacks ) )
			{
				m_Engagement_Tac_Data.m_LastTimeLOS_4_DefaultAttacksChecked = WorldInfo.TimeSeconds;

				if ( ShouldIFireTactical() )
				{
					m_Engagement_Tac_Data.m_LastTimeHadGoodLineOfFire = WorldInfo.TimeSeconds;

					// I should fire now let me see if I can fire from here or do I need to side step

					if( m_Engagement_Tac_Data.m_bAllowTacticalSteping &&
						m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel &&
						m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_None )
					{
						m_Engagement_Tac_Data.m_bSideSteping = true;

						;

						//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Attack_Loop - ShouldIFireTactical it true but need to side step -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
						
						Goto('SideStep');
					}
					else
					{
						//`log(" ChadAI - Attack_Stand::begin: start firing ");

						if( !m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd )
						{
							//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack_Loop::Has Good LOF and not grappeling etc and not wait for burst cool down. start firing-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

							;
							
								TP_AiStartFiring();
							



						}
					}
				}
				else if( !IsReloading() )
				{
					;
					//`log(" ChadAI - Open_Field_Attack_Loop stop firing ");
					StopFiring();

					if( (WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_LastTimeHadGoodLineOfFire) > class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_HowLongAfterLeftGoodLOF2GiveUpDefaultAttack )
					{
						;
						Sleep(0.0);
						PopState();
						//EvaluateSituation();
					}
				}
// 				else // is reloading
// 				{
// 					// else if reloading see if can seek hasty cover
// 					if( m_Engagement_Tac_Data.m_bAllowTacticalSteping )
// 					{
// 						m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForHastyCover(	Enemy,
// 																									Vector(Pawn.Rotation), 
// 																									m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
// 																									false);
// 						if( m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel &&
// 							m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_None )
// 						{
// 							m_Engagement_Tac_Data.m_bSideSteping = true;
// 
// 							`AILOG(1, 'Open_Field_Attack', "I am reloading and can move to hasty cover Move Need: " @ m_Engagement_Tac_Data.m_MoveNeed2Kill);
// 
// 							//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack_Loop - I am reloading and can move to hasty cover Move Need: " @ m_Engagement_Tac_Data.m_MoveNeed2Kill @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 						
// 							Goto('SeekHastyCover');						
// 						}
// 						else
// 						{
// 							`AILOG(1, 'Open_Field_Attack', "I am reloading and can NOT move to hasty cover Move Need: " @ m_Engagement_Tac_Data.m_MoveNeed2Kill);
// 
// 							//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Attack_Loop - I am reloading and can NOT move to hasty cover Move Need: " @ m_Engagement_Tac_Data.m_MoveNeed2Kill @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 						}
// 					} // end if( m_Engagement_Tac_Data.m_bAllowTacticalSteping )
// 
// 				} // end else for reoading and can shoot
			} // end if for LOS count checker
		}
	} // end else for if (!HasValidEnemy())		

	sleep(0.0);

Goto('Open_Field_Attack_Loop');

CQB:

	//`log(" ChadAI - Open_Field_Attack-CQB  m_RangeToStartCQB_State -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	StopFiring();
	PushState('CloseQuartersBattleAttack');

Goto('Open_Field_Attack_Loop');


SideStep:

	//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Attack-SideStep build path to side step -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	/* FIX_STEP: test the new KynapseCanGoStraight function
	// would really like to know path length to test against instead
	//KynapseGoToFindPath( m_Engagement_Tac_Data.m_SideStepTargetMoveLoc );
	//if ( KynapseFoundPath() )
	*/
	if ( KynapseCanGoStraight(m_Engagement_Tac_Data.m_SideStepTargetMoveLoc) )
	{
		m_SubStateDebugInfoTag="Step to Engage";

		//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Attack-SideStep found path to side step so start stepping -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;

		Target = Enemy;

		Focus = Target;

		DesiredRotation = rotator(Focus.Location - Pawn.Location);
		DesiredRotation.Pitch = 0;

		KynapseClear();

		if( class'TPTuneManager'.static.Get().GetTuneData().DebugDrawData.m_bDisplayTacticalStepAimRays )
		{

			Pawn.DrawDebugLine( Pawn.Location, m_Engagement_Tac_Data.m_SideStepTargetMoveLoc, 0,
															0, 
															255, true);

		}

		if (Pawn.bIsCrouched)
		{
			m_SubStateDebugInfoTag="Step to Engage UnCrouching";

			m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange = WorldInfo.TimeSeconds;

			if( Pawn != None && TPPawn(Pawn) != none )
			{
				Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToStanding;
			}

			;


			// OpenFieldPostureSwitchingState_GoingToCrouching
			while(	(Pawn.bIsCrouched && Pawn != None && TPPawn(Pawn) != none) ||
					(Pawn != None && TPPawn(Pawn) != none && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching ) )
			{
				Pawn.UnCrouch();
				Sleep(0.0);

				if( !Pawn.bIsCrouched && ( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange) >= 
											class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToStandPostureChangeToFinish ) )
				{
					;
					Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
					break;
				}
			}
		}

		m_SubStateDebugInfoTag="Step to Engage Moving";

		Pawn.SetMovementType(MovementType_Default);

		Pawn.MaxDesiredSpeed	=	class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_EnageTacStepSpeedFactor;
		Pawn.DesiredSpeed		=	class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_EnageTacStepSpeedFactor;

		MoveTo(m_Engagement_Tac_Data.m_SideStepTargetMoveLoc, Enemy);

		//Pawn.Velocity = vect(0,0,0);
		StopThisBot(); // MoveTo affects velocity & acceleration

		if (Pawn != None)
		{
			Pawn.SetMovementType( MovementType_Default );

			Pawn.MaxDesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
			Pawn.DesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
		}

		//ActivateKynapseBrain(true);
		//KynapseClear();

		if( DetermineIfShouldStartCQB_Tick( WorldInfo.TimeSeconds ) )
		{
			Goto('CQB');
		}
		else if( DetermineIfGrenadeShouldBeAutoThrown() )
		{
			//`log(" ChadAI - Pawn " @ Pawn @ " FreeAttackGoalLoop DetermineIfGrenadeShouldBeThrown");
			;
			PushState('UseGrenadeAgainstEnemy');
			Goto('Open_Field_Attack_Loop');
		}


		m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForEngagement(	Enemy,
																					Vector(Pawn.Rotation), 
																					m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																					false);


		if( Enemy != None && 
			m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel &&
			m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_None )
		{
			;

			Sleep(0.0);
			Goto('SideStep');
		}

		m_Engagement_Tac_Data.m_bSideSteping = false;
		//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Attack - SideStep back from MoveTo we made it and return to attack -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		Sleep(0.0);
		Goto('Open_Field_Attack_Loop');
	}

	;

	InvalidateThisSliceThePieTacStepLocation(m_Engagement_Tac_Data.m_MoveNeed2Kill);

	m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForEngagement(	Enemy,
																				Vector(Pawn.Rotation), 
																				m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																				false);


	if( Enemy != None && 
		m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel &&
		m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_None )
	{
		;
		Sleep(0.0);
		Goto('SideStep');
	}

	m_Engagement_Tac_Data.m_bSideSteping = false;
	//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Attack-SideStep did not find path to side step so back to loop -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	;
	Sleep(0.0);
	
	//Goto('Open_Field_Attack_Loop');
	PopState();

SeekHastyCover:

	//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Attack-SeekHastyCover build path to side step -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	m_Engagement_Tac_Data.m_bShouldCrouchForFreeAttack = false;

	if ( KynapseCanGoStraight( m_Engagement_Tac_Data.m_SideStepTargetMoveLoc ) )
	{
		m_SubStateDebugInfoTag="Find Hasty Cover";

		//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Attack-SeekHastyCover found path to side step so start stepping -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;

		Target = Enemy;

		Focus = Target;

		DesiredRotation = rotator(Focus.Location - Pawn.Location);
		DesiredRotation.Pitch = 0;

		KynapseClear();
		//ActivateKynapseBrain(false);

		if( class'TPTuneManager'.static.Get().GetTuneData().DebugDrawData.m_bDisplayTacticalStepAimRays )
		{

			Pawn.DrawDebugLine( Pawn.Location, m_Engagement_Tac_Data.m_SideStepTargetMoveLoc, m_Engagement_Tac_Data.m_DisplayTacticalStepAimRaysStrightAheadColor.R,
															m_Engagement_Tac_Data.m_DisplayTacticalStepAimRaysStrightAheadColor.G, 
															m_Engagement_Tac_Data.m_DisplayTacticalStepAimRaysStrightAheadColor.B, true);

		}

		if (Pawn.bIsCrouched)
		{
			m_SubStateDebugInfoTag="Find Hasty Cover UnCrouching";


			m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange = WorldInfo.TimeSeconds;

			if( Pawn != None && TPPawn(Pawn) != none )
			{
				Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToStanding;
			}

			;


			// OpenFieldPostureSwitchingState_GoingToCrouching
			while(	(Pawn.bIsCrouched && Pawn != None && TPPawn(Pawn) != none) ||
					(Pawn != None && TPPawn(Pawn) != none && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching ) )
			{
				Pawn.UnCrouch();
				Sleep(0.0);

				if( !Pawn.bIsCrouched && ( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange) >= 
											class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToStandPostureChangeToFinish ) )
				{
					;
					Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
					break;
				}
			}		
		}

		m_SubStateDebugInfoTag="Find Hasty Cover Moving";

		Pawn.SetMovementType(MovementType_Default);

		Pawn.MaxDesiredSpeed	=	class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_FindHastyCoverTacStepSpeedFactor;
		Pawn.DesiredSpeed		=	class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_FindHastyCoverTacStepSpeedFactor;

		MoveTo(m_Engagement_Tac_Data.m_SideStepTargetMoveLoc, Enemy);

		//Pawn.Velocity = vect(0,0,0);
		StopThisBot();
		//ActivateKynapseBrain(true);
		//KynapseClear();

		if (Pawn != None)
		{
			Pawn.SetMovementType( MovementType_Default );

			Pawn.MaxDesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
			Pawn.DesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
		}

		if( DetermineIfShouldStartCQB_Tick( WorldInfo.TimeSeconds ) )
		{
			Goto('CQB');
		}
		else if( DetermineIfGrenadeShouldBeAutoThrown() )
		{
			//`log(" ChadAI - Pawn " @ Pawn @ " FreeAttackGoalLoop DetermineIfGrenadeShouldBeThrown");
			;
			PushState('UseGrenadeAgainstEnemy');
			Goto('Open_Field_Attack_Loop');
		}

		m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForHastyCover(	Enemy,
																					Vector(Pawn.Rotation), 
																					m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																					false);


		if( Enemy != None && 
			m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel &&
			m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_None )
		{
			;

			Sleep(0.0);
			Goto('SeekHastyCover');
		}

		while( IsReloading() )
		{
			m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForHastyCover(	Enemy,
																						Vector(Pawn.Rotation), 
																						m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																						false);


			if( Enemy != None && 
				m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel &&
				m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_None )
			{
				;

				Sleep(0.0);
				Goto('SeekHastyCover');
			}

			Sleep(0.0);
		}

		m_Engagement_Tac_Data.m_bSideSteping = false;
		//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Attack - SeekHastyCover back from MoveTo we made it and return to attack -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		m_Engagement_Tac_Data.m_bScaredBackToCoverWhileSteppedOut = false;
		m_Engagement_Tac_Data.m_bTookHit = false;
		Goto('Open_Field_Attack_Loop');
	}

	;

	InvalidateThisHastyCoverTacStepLocation(m_Engagement_Tac_Data.m_MoveNeed2Kill);

	m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForHastyCover(	Enemy,
																				Vector(Pawn.Rotation), 
																				m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																				false);


	if( Enemy != None && 
		m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel &&
		m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_None )
	{
		;
		Sleep(0.0);
		Goto('SeekHastyCover');
	}

	;	
	//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Attack-SeekHastyCover did not find path to side step so back to loop -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	m_Engagement_Tac_Data.m_bScaredBackToCoverWhileSteppedOut = true;
	m_Engagement_Tac_Data.m_bTookHit = false;
	Sleep(0.0);
	Goto('Open_Field_Attack_Loop');

SideStepEvade:

	//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Attack- SideStepEvade build path to side step -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


	m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForTacEvasion(	Enemy,
																				Vector(Pawn.Rotation), 
																				m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																				false);


	if(m_Engagement_Tac_Data.m_MoveNeed2Kill == RequiredMove4Engage_Travel ||
		m_Engagement_Tac_Data.m_MoveNeed2Kill == RequiredMove4Engage_None )
	{
		;
		m_Engagement_Tac_Data.m_bSideSteping = false;
		Goto('PanicFire');
	}

	/* FIX_STEP: test the new KynapseCanGoStraight function
	// would really like to know path length to test against instead
	//KynapseGoToFindPath( m_Engagement_Tac_Data.m_SideStepTargetMoveLoc );
	//if ( KynapseFoundPath() )
	*/
	if ( KynapseCanGoStraight(m_Engagement_Tac_Data.m_SideStepTargetMoveLoc) )
	{
		m_SubStateDebugInfoTag="Side Step Evade";

		m_SubStateDebugInfoTag="Evade";

		//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Attack-SideStep found path to side step so start stepping -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;

		Target = Enemy;

		Focus = Target;

		DesiredRotation = rotator(Focus.Location - Pawn.Location);
		DesiredRotation.Pitch = 0;

		if( DesiredRotation.Yaw < 0 )
		{
			DesiredRotation.Yaw = 65536.0f + DesiredRotation.Yaw;
		}

		if( DesiredRotation.Yaw < 0 )
		{
			//`log(" ChadAI - Open_Field_Attack SideStepEvade - DesiredRotation.Yaw < 0 -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
		}

// 		if( !m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd )
// 		{
// 			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack_ SideStepEvade:: not wait for burst cool down. start firing-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
// 
// 			`AILOG(1, 'Open_Field_Attack', "SideStepEvade: not wait for burst cool down. start firing");
// 			`if(`isdefined(FINAL_RELEASE))
// 				StartFiring();
// 			`else
// 				StartFiring('Open_Field_Attack_SideStepEvade');
// 			`endif		
// 		}

		KynapseClear();

		//ActivateKynapseBrain(false);

		if( class'TPTuneManager'.static.Get().GetTuneData().DebugDrawData.m_bDisplayTacticalStepAimRays )
		{

			Pawn.DrawDebugLine( Pawn.Location, m_Engagement_Tac_Data.m_SideStepTargetMoveLoc, 0,
																								0, 
																								255, true);

		}

	   if (Pawn.bIsCrouched)
		{
			m_SubStateDebugInfoTag="Side Step Evade UnCrouching";

			m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange = WorldInfo.TimeSeconds;

			if( Pawn != None && TPPawn(Pawn) != none )
			{
				Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToStanding;
			}

			;


			// OpenFieldPostureSwitchingState_GoingToCrouching
			while(	(Pawn.bIsCrouched && Pawn != None && TPPawn(Pawn) != none) ||
					(Pawn != None && TPPawn(Pawn) != none && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching ) )
			{
				Pawn.UnCrouch();
				Sleep(0.0);

				if( !Pawn.bIsCrouched && ( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange) >= 
											class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToStandPostureChangeToFinish ) )
				{
					;
					Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
					break;
				}
			}	   
	   }

		m_SubStateDebugInfoTag="Side Step Evade Moving";

		Pawn.SetMovementType(MovementType_Default);

		Pawn.MaxDesiredSpeed	=	class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_EvadeTacStepSpeedFactor;
		Pawn.DesiredSpeed		=	class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_EvadeTacStepSpeedFactor;

		MoveTo(m_Engagement_Tac_Data.m_SideStepTargetMoveLoc, Enemy);

		//Pawn.Velocity = vect(0,0,0);
		StopThisBot(); // MoveTo affects velocity & acceleration

		if (Pawn != None)
		{
			Pawn.SetMovementType( MovementType_Default );

			Pawn.MaxDesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
			Pawn.DesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
		}

		//ActivateKynapseBrain(true);
		//KynapseClear();

		if( DetermineIfShouldStartCQB_Tick( WorldInfo.TimeSeconds ) )
		{
			Goto('CQB');
		}
		else if( DetermineIfGrenadeShouldBeAutoThrown() )
		{
			//`log(" ChadAI - Pawn " @ Pawn @ " FreeAttackGoalLoop DetermineIfGrenadeShouldBeThrown");
			;
			PushState('UseGrenadeAgainstEnemy');
			Goto('Open_Field_Attack_Loop');
		}


		if( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToOpenFieldTacticallyEvadeFromCover ) > class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_HowLongToOpenFieldTacticallyEvadeFromCover )
		{
			;
			m_Engagement_Tac_Data.m_bSideSteping = false;
			Sleep(0.0);
			Goto('Open_Field_Attack_Loop');
		}

		// can still tac evade so lets find another place

		if( Enemy != None )
		{
			if( DetermineIfShouldStartCQB_Tick( WorldInfo.TimeSeconds ) )
			{
				Goto('CQB');
			}
		}

		m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForTacEvasion(	Enemy,
																					Vector(Pawn.Rotation), 
																					m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																					false);


		if( Enemy != None && 
			m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel &&
			m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_None )
		{
			;
			Sleep(0.0);
			Goto('SideStepEvade');
		}

		m_Engagement_Tac_Data.m_bSideSteping = false;
		//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Attack - SideStepEvade back from MoveTo we made it and return to attack -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;
		m_CoverMoveData.m_CoverState = CoverBehavior_Firing;
		Sleep(0.0);
		Goto('Open_Field_Attack_Loop');
	}

	;

	InvalidateThisEvadeTacStepLocation( m_Engagement_Tac_Data.m_MoveNeed2Kill );

	m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForTacEvasion(	Enemy,
																				Vector(Pawn.Rotation), 
																				m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																				false);


	if( Enemy != None && 
		m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel &&
		m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_None )
	{
		;
		Sleep(0.0);
		Goto('SideStepEvade');
	}

	;	
	//`log(" ChadAI - Pawn: " @ Pawn @ " Open_Field_Attack-SideStepEvade did not find path to side step so back to loop -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	m_CoverMoveData.m_CoverState = CoverBehavior_Firing;
	Sleep(0.0);
	Goto('Open_Field_Attack_Loop');

PanicFire:

	if ( ShouldIFire() )
	{
		m_Engagement_Tac_Data.m_LastTimeHadGoodLineOfFire = WorldInfo.TimeSeconds;

		if( !m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack_Loop::Has Good LOF and not grappeling etc and not wait for burst cool down. start firing-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

			;
			
				TP_AiStartFiring();
			


		}
	}
	Sleep(0.1);
	Goto('Open_Field_Attack_Loop');
}


state Attack_Stand_Before_Charge
{

	function NotifyWeaponFired(Weapon W, byte FireMode)
	{
		m_CQB_Data.m_NoOfRoundsShotBeforeCharge = m_CQB_Data.m_NoOfRoundsShotBeforeCharge + 1;
	}

	
	function BeginState(Name PreviousStateName)
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		//`log(" ChadAI - Attack_Stand_Before_Charge::BeginState ");

		SetAimAndHeadTrack();
	}
	
	function EndState (Name NextStateName)
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;


		Target = None; 
		StopFiring();
		
		// don't crouch when player is too close fix. DK
		bForcedStand = false;
		
		m_bPauseFire = false;
	}

	event PoppedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;


		Target = None; 
		StopFiring();
		
		// don't crouch when player is too close fix. DK
		bForcedStand = false;
		
	}

	event PushedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;


		SetAimAndHeadTrack();

	}


	event PausedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		m_bPauseFire = false;
		/* going with a bullet count
		ClearTimer('BurstTimer');
		*/
	}

	event ContinuedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		/* going with a bullet count
		SetBurstTimer();
		*/
	}

	function SetPauseTimer()
	{
		//make this designer-configable
		//SetTimer(RandRange(0.2, 0.5), false,'BurstTimer');
	}

	event Tick( float DeltaTime )
	{

		//`log(" ChadAI - TPSoldierAIController::Attack_Stand_Before_Charge::Tick m_NoOfRoundsShotBeforeCharge: " @  TPPawn(Pawn).m_NoOfRoundsShotBeforeCharge @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		UpdateAimInTheOpen(FALSE);;
		UpdateHeadtracking();

		Super.Tick(DeltaTime);
	}
begin:

	m_SubStateDebugInfoTag="Begin";
	
	//`log(" ChadAI - Pawn: " @ Pawn @ " Attack_Stand_Before_Charge::begin: ");


	m_CQB_Data.m_NoOfRoundsShotBeforeCharge = 0;
	SetAimAndHeadTrack();

	m_CQB_Data.m_LastTimeForLOS_ForBlow = -1.0;

	//`log(" ChadAI - Pawn: " @ Pawn @ " Attack_Stand_Before_Charge::Tick  TPWeapon(Pawn.Weapon).GetMagazineSize(): " @ TPWeapon(Pawn.Weapon).GetMagazineSize() @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	//`log(" ChadAI - Pawn: " @ Pawn @ " Attack_Stand_Before_Charge::Tick  TPWeapon(Pawn.Weapon).GetAmmoInMagazine(): " @ TPWeapon(Pawn.Weapon).GetAmmoInMagazine() @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	//`log(" ChadAI - Pawn: " @ Pawn @ " Attack_Stand_Before_Charge::Tick  m_OverridePercentOfMagToBlowThroughBeforeCharge: " @ m_CQB_Data.m_OverridePercentOfMagToBlowThroughBeforeCharge @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	if( TPWeapon(Pawn.Weapon) == None )
	{
		PopState();
	}

	if( m_CQB_Data.m_OverridePercentOfMagToBlowThroughBeforeCharge > 0.0f )
	{
		if( TPWeapon(Pawn.Weapon).GetAmmoInMagazine() < ( TPWeapon(Pawn.Weapon).GetMagazineSize() * m_CQB_Data.m_OverridePercentOfMagToBlowThroughBeforeCharge ) )
		{
			m_CQB_Data.m_NoOfRoundsToShootBeforeCharge = TPWeapon(Pawn.Weapon).GetAmmoInMagazine();
			//`log(" ChadAI - Pawn: " @ Pawn @ " Attack_Stand_Before_ChargeNo of round to shoot before charge: " @ m_CQB_Data.m_NoOfRoundsToShootBeforeCharge @ " using ammo in mag -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		}
		else
		{
			m_CQB_Data.m_NoOfRoundsToShootBeforeCharge = TPWeapon(Pawn.Weapon).GetAmmoInMagazine() * m_CQB_Data.m_OverridePercentOfMagToBlowThroughBeforeCharge;
			////`log(" ChadAI - Pawn: " @ Pawn @ " Attack_Stand_Before_ChargeNo of round to shoot before charge: " @ m_CQB_Data.m_NoOfRoundsToShootBeforeCharge @ " using percent of mag -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		}

	}
	else
	{
		if( TPWeapon(Pawn.Weapon).GetAmmoInMagazine() < ( TPWeapon(Pawn.Weapon).GetMagazineSize() * TPWeapon(Pawn.Weapon).PercentOfMagToBlowThroughBeforeMeleeCharge ) )
		{
			m_CQB_Data.m_NoOfRoundsToShootBeforeCharge = TPWeapon(Pawn.Weapon).GetAmmoInMagazine();
			//`log(" ChadAI - Pawn: " @ Pawn @ " Attack_Stand_Before_ChargeNo of round to shoot before charge: " @ m_CQB_Data.m_NoOfRoundsToShootBeforeCharge @ " using ammo in mag -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		}
		else
		{
			m_CQB_Data.m_NoOfRoundsToShootBeforeCharge = TPWeapon(Pawn.Weapon).GetAmmoInMagazine() * TPWeapon(Pawn.Weapon).PercentOfMagToBlowThroughBeforeMeleeCharge;
			//`log(" ChadAI - Pawn: " @ Pawn @ " Attack_Stand_Before_ChargeNo of round to shoot before charge: " @ m_CQB_Data.m_NoOfRoundsToShootBeforeCharge @ " using percent of mag -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		}
	}


	while( true )
	{
// 		if (UpdateForcedStand())
// 		{
// 			Pawn.ShouldCrouch(!bForcedStand && ChanceOfCrouching() && IsEnemyShootableWhenCrouched()); // use distance and sight check to crouch
// 		}

		if( Enemy != None  && TPWeapon(Pawn.Weapon) != None)
		{
			if( m_CQB_Data.m_bAbleToMeleeAttacks )
			{
				if( EnemyIsInRange( TPWeapon(Pawn.Weapon).MeleeDistance +  m_CQB_Data.m_AdditionalMeleeRangeOfAttack ) )
				{
					;
					StopFiring();
					PopState();
				}

			}
		}
	
		if (!HasValidEnemy())
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " Attack_Stand_Before_Charge::begin: !HasValidEnemy() ");
		
			//`AILOG(0, 'Begin', "No valid enemy");
			PopState();
		}
		else
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " Attack_Stand_Before_Charge::begin: HasValidEnemy() ");
		
			Target = Enemy;
			
			Focus = Target;

			DesiredRotation = rotator(Focus.Location - Pawn.Location);
			DesiredRotation.Pitch = 0;


			if( Pawn.Weapon != None )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " Attack_Stand_Before_Charge  m_NoOfRoundsShotBeforeCharge: " @ m_CQB_Data.m_NoOfRoundsShotBeforeCharge @ " To Shoot: " @ m_CQB_Data.m_NoOfRoundsToShootBeforeCharge @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				if( m_CQB_Data.m_NoOfRoundsShotBeforeCharge >= m_CQB_Data.m_NoOfRoundsToShootBeforeCharge )
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ " Attack_Stand_Before_Charge  m_CQB_Data.m_NoOfRoundsShotBeforeCharge >= m_CQB_Data.m_NoOfRoundsToShootBeforeCharge so Done Shooting so poping -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					m_CQB_Data.m_bHasBlownOneMagBeforeCharge = true;
					StopFiring();
					PopState();
				}

			}
			else
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " Attack_Stand_Before_Charge Pawn.Weapon == None so poping -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				StopFiring();
				PopState();
			}


			if( ( m_CQB_Data.m_LastTimeForLOS_ForBlow < 0.0f) || 
					WorldInfo.TimeSeconds - m_CQB_Data.m_LastTimeForLOS_ForBlow >= m_CQB_Data.m_HowOfftenInSecsToCheck_LOS_ForBlow )
			{	
				m_CQB_Data.m_LastTimeForLOS_ForBlow = WorldInfo.TimeSeconds;

				if ( !EnemyRecentlyVisible(true) /*|| !CanFireAtNotFromCover(Enemy)*/)
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ " Attack_Stand_Before_Charge::begin: !EnemyRecentlyVisible(true) ");
					;

					StopFiring();
					m_CQB_Data.m_bHasBlownOneMagBeforeCharge = true;
					PopState();		
				}
				else
				{
					if ( ShouldIFire() )
					{
						
							TP_AiStartFiring();
						


					}
					else
					{
						//StopFiring();
						//`log(" ChadAI - Pawn: " @ Pawn @ " Attack_Stand_Before_Charge::begin: shouldIFire returned false so time to quit trying to shoot and charge");
						;
						StopFiring();
						m_CQB_Data.m_bHasBlownOneMagBeforeCharge = true;
						PopState();
					}
				}
			}
// 			else
// 			{
// 				//`log(" ChadAI - Attack_Stand_Before_Charge::begin: EnemyRecentlyVisible(true) && CanFireAt(Enemy) ");
// 			
// 				if ( ShouldIFire() )
// 				{
// 					StartFiring();
// 				}
// 				else
// 				{
// 					StopFiring();
// 				}
// 			}
		}		
		// CHAD make sure this sleep is needed
		sleep(0.0);
	}

}


function DoMeleeAttackHit()
{
	//`log("TPAISoldierController::DoMeleeAttack: BAD RETURN EVENT NOT IN THE MELEE STATE");
	;

}

function FailedMeleeAttackPushAway()
{
	//`log("TPAISoldierController::FailedMeleeAttackPushAway: BAD RETURN EVENT NOT IN THE MELEE STATE");
	;

}

state MeleeAttack
{
	 ignores NotifyBump;

	function NotifyWeaponFired(Weapon W, byte FireMode)
	{
// 		if (Pawn != None && Pawn.Weapon != None && !IsInState('FireFromCover') && !IsInState('TakeHit')) //hmm, how to control this a better way?  Something like the 'ignores' keyword?
// 		{
// 			++BurstCount;
// 			if (BurstCount >= TPWeapon(Pawn.Weapon).BulletsPerBurst)
// 			{
// 				BurstCount = 0;
// 				//PushState('BurstFireWait');
// 			}
// 		}
	}
	
	function BeginState(Name PreviousStateName)
	{
		//`log(" ChadAI - MeleeAttack::BeginState ");
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		SetAimAndHeadTrack();

		m_CQB_Data.m_TimeMeleeAttemptStarted = -1.0f;
	
	}

	
	function EndState (Name NextStateName)
	{
		//`log(" ChadAI - MeleeAttack::EndState Time: " @ WorldInfo.TimeSeconds @ "!");
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		Target = None; 
		StopFiring();
		
		// don't crouch when player is too close fix. DK
		bForcedStand = false;
		
		if (Pawn != None)
		{
			TPPawn(Pawn).m_bPerformingMeleeRifleHorizontalButtstroke = false;
		}

		m_bPauseFire = false;
	}

	event PoppedState()
	{
		//`log(" ChadAI - MeleeAttack::PoppedState Time: " @ WorldInfo.TimeSeconds @ "!");
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		Target = None; 
		StopFiring();
		
		// don't crouch when player is too close fix. DK
		bForcedStand = false;
		
		if (Pawn != None)
		{
			TPPawn(Pawn).m_bPerformingMeleeRifleHorizontalButtstroke = false;
		}		
		m_bPauseFire = false;
	}


	event PausedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		m_bPauseFire = false;
		/* going with a bullet count
		ClearTimer('BurstTimer');
		*/
	}

	event ContinuedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;
		FailedMeleeAttackPushAway();
		/* going with a bullet count
		SetBurstTimer();
		*/
	}

	function FailedMeleeAttackPushAway()
	{
		//local PlayerPawn P;
		local TPPawn P;
		local vector LNormal;

		//`log(" ChadAI - MeleeAttack::FailedMeleeAttackPushAway: Time: " @ WorldInfo.TimeSeconds @ "!");

		m_CQB_Data.m_TimeMeleeAttemptStarted = -1.0f;

		// This is what turns the Animation Off

		if( TPPawn(Pawn) != None )
		{
			TPPawn(Pawn).m_bPerformingMeleeRifleHorizontalButtstroke = false;

			ForEach VisibleCollidingActors(class'TPPawn', P, Pawn.CylinderComponent.CollisionRadius * 4, Pawn.Location, true)
			{
				//`log(" ChadAI - MeleeAttack::FailedMeleeAttackPushAway: VisibleCollidingActorsL " @ P @ "-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-! ");

				LNormal = Normal(P.Location - Pawn.Location);
				if  (LNormal dot vector(Pawn.Rotation) > 0.5)
				{
					P.TakeDamage(1, Self, P.Location, LNormal * 55000.0f , class'TPDamageTypeGrapple');
				}
			}
		}

		PopState();
	}

	function DoMeleeAttackFinished()
	{
		//`log(" JohnAI - MeleeAttack::DoMeleeAttackFinished");
		;

		//m_CQB_Data.m_TimeSpentMeleeWait = -1.0f;
		// Deactivated to allow the melee animation to cycle
		//PopState();
	}

	function DoMeleeAttackHit()
	{
		//local PlayerPawn P;
		local TPPawn P;
		
		local vector LNormal;
		local int meleeDmg;
		local float hitForce;


		//`log(" ChadAI - MeleeAttack::DoMeleeAttack: ");

		;


		m_CQB_Data.m_TimeMeleeAttemptStarted = -1.0f;

//		TPPawn(Pawn).m_bPerformingMeleeRifleHorizontalButtstroke = false;

		// This is what turns the Animation Off

		// reset the wait time started each time a hit happens
		m_CQB_Data.m_TimeMeleeAttemptStarted = WorldInfo.TimeSeconds;

		ForEach VisibleCollidingActors(class'TPPawn', P, Pawn.CylinderComponent.CollisionRadius * 4, Pawn.Location, true)
		{
			//`log(" ChadAI - MeleeAttack::DoMeleeAttack: VisibleCollidingActorsL " @ P @ "-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-! ");

			if( IsValidEnemyController(P.Controller, TRUE) )
			{

				LNormal = Normal(P.Location - Pawn.Location);
				if  (LNormal dot vector(Pawn.Rotation) > 0.5)
				{
					if( P.InGodMode() )
					{
						meleeDmg = 0;
						//`log("MeleeAttack::DoMeleeAttack: IN GOD MODE SO NO MELEE DAMAGE - WIMPS -!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-! ");
					}
					else if( TPWeapon(Pawn.Weapon) != None )
					{
						meleeDmg = TPWeapon(Pawn.Weapon).MeleeDamage + m_CQB_Data.m_AdditionalMeleeAttackDamage;
						hitForce = TPWeapon(Pawn.Weapon).MeleeHitForce + m_CQB_Data.m_AdditionalMeleeHitForce;
					}
					else
					{
						meleeDmg = 0;
						hitForce = 500;
					}

					//`log(" ChadAI - MeleeAttack::DoMeleeAttack: HitPoints Before " @ P.Health @ " dmg: " @ meleeDmg @ " -!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-! ");


					//P.TakeDamage(P.Health, P.Controller, P.Location, LNormal * TPPawn(Pawn).m_MeleeHitForce, class'TPDamageTypeImpactGrenade');

					P.TakeDamage(meleeDmg, Self, P.Location, LNormal * hitForce, class'TPDamageTypeGrapple');

					//P.Health = P.Health - meleeDmg;
					// TPDamageTypeImpact TPDamageTypeImpactMortarShell TPDamageTypeImpactGrenade
					//`log(" ChadAI - MeleeAttack::DoMeleeAttack: HitPoints After " @ P.Health @ "-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-! ");

					// ONLY DMG ONE GUY
					return;
				}
			}
		}

//		`log(" JohnAI - MeleeAttack::DoMeleeAttack: About to PopState");
//		PopState();
	}


	event Tick( float DeltaTime )
	{
		//UpdateAim();

		//`log(" ChadAI - " @ Pawn @" MeleeAttack::Tick m_TimeSpentMeleeWait: " @ m_CQB_Data.m_TimeSpentMeleeWait @ " -!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-! ");

		//UpdateAim();
		SetAimToStrightAhead();
		UpdateHeadtracking();

		if(  Pawn != None && m_CQB_Data.m_TimeMeleeAttemptStarted >= 0.0f )
		{

			// Fail safe timer.  Should never be hit, but I'll leave it in just in case.
			if( WorldInfo.TimeSeconds - m_CQB_Data.m_TimeMeleeAttemptStarted >= m_CQB_Data.m_MeleeWaitToFailTime)
			{
//				TPPawn(Pawn).m_bPerformingMeleeRifleHorizontalButtstroke = false;
				//`log(" ChadAI - " @ Pawn @" MeleeAttack::Tick Force Quiting because of no hit in time -!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-! ");

				;


				FailedMeleeAttackPushAway();
				//PopState();

				//`log(" ChadAI - " @ Pawn @" MeleeAttack::Tick Force Quiting because of no hit in time -!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-! ");
			}
		}

		// the enemy has moved to far away so should end melee attack
		if( TPWeapon(Pawn.Weapon) != None && !EnemyIsInRange( TPWeapon(Pawn.Weapon).MeleeDistance +  m_CQB_Data.m_AdditionalMeleeRangeOfAttack + 30 ) )
		{
			FailedMeleeAttackPushAway();
		}

		Super.Tick(DeltaTime);
	}
begin:

	m_SubStateDebugInfoTag="Begin";
	
	//`log(" ChadAI - MeleeAttack::begin: Time: " @ WorldInfo.TimeSeconds @ "!");

	;

	SetAimAndHeadTrack();


	if( Pawn == None )
	{
		;

		PopState();
	}

	m_CQB_Data.m_TimeMeleeAttemptStarted = -1.0;

   if (Pawn.bIsCrouched)
	{
		//`log("Pawn: " @ Pawn @ " MeleeAttack started with me Crouched");
		m_SubStateDebugInfoTag="Melee Attack UnCrouching";


		m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange = WorldInfo.TimeSeconds;

		if( Pawn != None && TPPawn(Pawn) != none )
		{
			Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToStanding_Panic;
		}

		;


		// OpenFieldPostureSwitchingState_GoingToCrouching
		while(	(Pawn.bIsCrouched && Pawn != None && TPPawn(Pawn) != none) ||
				(Pawn != None && TPPawn(Pawn) != none && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching ) )
		{
			Pawn.UnCrouch();
			Sleep(0.00);

			if( !Pawn.bIsCrouched && ( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange) >= 
										class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToStandPostureChangeToFinish ) )
			{
				;
				Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
				break;
			}
		}			

		ClearCurrentCover();
		ReserveCover(m_CoverFightData.m_CurrentlyCoverToUseAsFightPos);


		//`log(" ChadAI - MeleeAttack::begin: Pawn.bIsCrouched = " @ Pawn.bIsCrouched @ " ------------------- ");

   } // end if (Pawn.bIsCrouched)
   else
   {
		//`log(" ChadAI - MeleeAttack::begin: Pawn.bIsCrouched = False so Pawn.ShouldCrouch(false) NOT CALLED THIS IS GOOD");
   }

	if (Enemy == None)
	{
		//`AILOG(0, 'Begin', "No valid enemy");
		//`log(" ChadAI - MeleeAttack::begin: Enemy == None so ending THIS IS BAD");

		PopState();
	}
	else
	{
		//`log(" ChadAI - MeleeAttack::begin: Enemy != None so Target = Enemy");

		Target = Enemy;
		
		// see if we need to turn towards the target
		//if (ShouldITurnToTarget())
		Focus = Target;

		DesiredRotation = rotator(Focus.Location - Pawn.Location);
		DesiredRotation.Pitch = 0;

		
		//`AILOG(0, 'Begin',"dist to enemy=" @ VSize(Pawn.Location-Enemy.Location) );			
		//if (!EnemyRecentlyVisible())

		//`log(" ChadAI - MeleeAttack::begin: check CanMeleeAttack ");


        if ( !CanMeleeAttack(Enemy) )
		{			
			//`log(" ChadAI - MeleeAttack::begin:Ending because can not Melee attack");
			;

			PopState();
		}
		else
		{
			// This is what turns the Animation On

			//`log(" ChadAI - MeleeAttack::begin: Launching attack");


			m_CQB_Data.m_NoOfTimesFailedCQB_Charge = 0;

			m_CQB_Data.m_TimeMeleeAttemptStarted = WorldInfo.TimeSeconds;

			TPPawn(Pawn).m_bPerformingMeleeRifleHorizontalButtstroke = true;

			// this sleep is needed to give the animation time to cycle
			Sleep(0.0);

		}
	}// end else if (!HasValidEnemy())	

}

//-----------------------------------------------------------------------
// State:		MoveToAndDefendCoverGoal
// Description:
//-----------------------------------------------------------------------
state MoveToAndDefendCoverGoal
{
	function BeginState(Name PreviousStateName)
	{
		;
		m_CoverFightData.m_bUsingFightingPosition = true;
		//`log(" ChadAI - TPSoldierAIController::MoveToAndDefendCoverGoal::BeginState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
	}
	
	event PausedState()
	{
		;

		//`log(" ChadAI - TPSoldierAIController::MoveToAndDefendCoverGoal::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	event ContinuedState()
	{
		;

		//`log(" ChadAI - TPSoldierAIController::MoveToAndDefendCoverGoal::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		
	
	}

	event PoppedState()
	{
		;

		//`log(" ChadAI - TPSoldierAIController::MoveToAndDefendCoverGoal::PoppedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		ClearLatentAction(class'SeqAct_AIDefendCover',true);

		m_HighLevelAiGoal = HighLevelAiGoal_NONE;
	}
	
	function EndState(Name NextStateName)
	{
		;

		m_HighLevelAiGoal = HighLevelAiGoal_NONE;
	}
	
	function AccomplishedGoal()
	{
		//`log(" ChadAI - TPSoldierAIController::MoveToAndDefendCoverGoal::AccomplishedGoal() -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		m_CoverFightData.m_bUsingFightingPosition = false;
		ClearLatentAction(class'SeqAct_AIDefendCover',false);
	}

	function FailedGoal()
	{
		//`log(" ChadAI - TPSoldierAIController::MoveToAndDefendCoverGoal::AccomplishedGoal() -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		m_CoverFightData.m_bUsingFightingPosition = false;
		ClearLatentAction(class'SeqAct_AIDefendCover',true);
	}
	
	event Tick( float DeltaTime )
	{
		//`log(" ChadAI - TPSoldierAIController::MoveToAndDefendCoverGoal::Tick -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		UpdateAimInTheOpen(FALSE);;
		UpdateHeadtracking();
		Super.Tick(DeltaTime);	
	}

Begin:

	m_SubStateDebugInfoTag="Begin";

	//`log(" ChadAI - TPSoldierAIController::MoveToAndDefendCoverGoal::Begin()-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	m_HighLevelAiGoal = HighLevelAiGoal_MoveToAndDefendCoverGoal;

	m_MoveToAndDefendCoverGoalInfo.m_NoOfTimesPathHasBeenTried = 0;

MoveToAndDefendCoverGoalLoop:

	if ( m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend.Link != None)
	{

		m_MoveToAndDefendCoverGoalInfo.m_CoverSlotToDefend = 
				m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend.Link.Slots[ m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend.SlotIdx ];
		
				
		if( ReserveCover( m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend ) )
		{
		
			m_CoverMoveData.m_TimeToUseCoverInSeconds = m_MoveToAndDefendCoverGoalInfo.m_TimeToDefendInSeconds;
			m_CoverMoveData.m_CurrentDurrationOfFiringBeforeHiding = m_MoveToAndDefendCoverGoalInfo.m_DurrationOfFiringBeforeHiding;
			m_CoverMoveData.m_CurrentDurationOfHidingBeforeFiring = m_MoveToAndDefendCoverGoalInfo.m_DurationOfHidingBeforeFiring;
			m_CoverMoveData.m_CurrentDurationOfLookingForTargetBeforeEngageAttempt = m_MoveToAndDefendCoverGoalInfo.m_DurationOfLookingForTargetBeforeEngageAttempt;
			
			if( !IsAtCover(m_CoverMoveData.m_ReservedGoToCover_Clamied, false ) )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " MoveToAndDefendCoverGoal::Begin() Is not at cover so move there -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_BuildingPath;


				m_MoveToAndDefendCoverGoalInfo.m_NoOfTimesPathHasBeenTried++;

				KynapseGoToFindPath( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link.GetSlotLocation( m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx ) );

				if ( KynapseFoundPath() )
				{
					//`log(" ChadAI - Pawn " @ Pawn @ " MoveToAndDefendCoverGoal::Begin Has Cover Path Found Now Travel There -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_PathBuiltWaitingToMove;

					m_CoverMoveData.m_HasPathToCoverBeenBuilt = true;

					m_CoverMoveData.m_bCheckToSeeIfCoverIsStillValidDuringMoveToCover = true;

					PushState('TravelToCoverSlot');

					//`log(" ChadAI - Pawn " @ Pawn @ " MoveToAndDefendCoverGoal::Begin Back From Travel To Cover Slot status: " @ m_CoverMoveData.m_Move2CoverStatus @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_DoneMovingAtCover )
					{
						//`log(" ChadAI - Pawn " @ Pawn @ " MoveToAndDefendCoverGoal::Begin Back From Travel To Cover Slot and status == Move2CovStat_DoneMovingAtCover Goto('DefendCoverSubState') -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					
						Goto('DefendCoverSubState');

					}
					else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedCQB_Needed )
					{
						//`log(" ChadAI - Pawn " @ Pawn @ " MoveToAndDefendCoverGoal::Begin Back From Travel To Cover Slot and status == Move2CovStat_FailedCQB_Needed PushState('CloseQuartersBattleAttack') -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

						PushState('CloseQuartersBattleAttack');

						m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_None;
					}
					else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedBlockedByPawn )
					{
						//`log(" ChadAI - Pawn " @ Pawn @ " MoveToAndDefendCoverGoal::Begin Back From Travel To Cover Slot and status == Move2CovStat_FailedBlockedByPawn make cover invalid for small time -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
						m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_None;
					}
					else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedBlockedByActor )
					{
						//`log(" ChadAI - Pawn " @ Pawn @ " MoveToAndDefendCoverGoal::Begin Back From Travel To Cover Slot and status == Move2CovStat_FailedBlockedByActor make cover invalid for small time -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
						m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_None;
					}
					else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedEnemyMadeCoverInvalid )
					{
						//`log(" ChadAI - Pawn " @ Pawn @ " MoveToAndDefendCoverGoal::m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedEnemyMadeCoverInvalid -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

						;

						InvalidateMoveGoal( m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend.Link, m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend.SlotIdx );

						ClearReservedCover();

						if( m_MoveToAndDefendCoverGoalInfo.m_bTaskFailedWhenViolatedByAngleToEnemy )
						{
							;

							FailedGoal();
						}
						else
						{
							;

							AccomplishedGoal();
						}

						Goto('DoneDefendingCover');
					}

				} // end if ( KynapseFoundPath() )
				else
				{
					//`log(" ChadAI - Pawn " @ Pawn @ " MoveToAndDefendCoverGoal::Begin Does Not Have Cover Path-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					// no path
					m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_NoPathBuiltWaitingToMove;


					if( m_MoveToAndDefendCoverGoalInfo.m_bAllowWaitingForPathOrPositionToClear )
					{
						//`log(" ChadAI - Pawn " @ Pawn @ " MoveToAndDefendCoverGoal::Begin Does Not Have Cover Path if have not tried path to many times Num Tried: " @ m_MoveToAndDefendCoverGoalInfo.m_NoOfTimesPathHasBeenTried @ " to try " @m_MoveToAndDefendCoverGoalInfo.m_NoOfTimesToCheckForPathToCover@ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

						if( ( m_MoveToAndDefendCoverGoalInfo.m_NoOfTimesToCheckForPathToCover < 0 ) ||( m_MoveToAndDefendCoverGoalInfo.m_NoOfTimesPathHasBeenTried < m_MoveToAndDefendCoverGoalInfo.m_NoOfTimesToCheckForPathToCover ) )
						{

							//`log(" ChadAI - Pawn " @ Pawn @ " MoveToAndDefendCoverGoal still allowed to try finding a path -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

							ClearReservedCover();

							//Goto('DoneDefendingCover');

							if( Enemy != None && m_MoveToAndDefendCoverGoalInfo.m_bAllowAttackWhileWaitingForPathToClear && CanFireAtNotFromCover(Enemy, true ) )
							{
								//`log(" ChadAI - Pawn " @ Pawn @ " MoveToAndDefendCoverGoal::Begin Does Not Have Cover Path and has enemy with Line of Fire so attack -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

								PushState('Open_Field_Attack');

							}
							else
							{

								;

								Goto('WaitForCoverToClear');
							}

						}
						else
						{

							//`log(" ChadAI - Pawn " @ Pawn @ " MoveToAndDefendCoverGoal Not allowed to try finding a path again -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

							ClearReservedCover();
							InvalidateMoveGoal( m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend.Link, m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend.SlotIdx );

							if( m_MoveToAndDefendCoverGoalInfo.m_bTaskFailedWhenPathCanNotBeFound )
							{
								;
								FailedGoal();
							}
							else
							{
								;
								AccomplishedGoal();
							}

							Goto('DoneDefendingCover');
						}
					}
					else
					{
						//`log(" ChadAI - Pawn " @ Pawn @ " MoveToAndDefendCoverGoal Not allowed to try finding a path more then once -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

						ClearReservedCover();
						InvalidateMoveGoal( m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend.Link, m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend.SlotIdx );

						if( m_MoveToAndDefendCoverGoalInfo.m_bTaskFailedWhenPathCanNotBeFound )
						{
							;
							FailedGoal();
						}
						else
						{
							;
							AccomplishedGoal();
						}

						Goto('DoneDefendingCover');
					}
					
				} // end  else of if ( KynapseFoundPath() )			
			} // end if( !IsAtCover(m_CoverMoveData.m_ReservedGoToCover_Clamied) )
			else
			{
				//`log(" ChadAI - Pawn " @ Pawn @ " MoveToAndDefendCoverGoal:: I am already at the cover so start defending -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				Goto('DefendCoverSubState');

			}
		} // end if( ReserveCover( m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend ) )
		else // can not reserve the cover so make invalid and try again
		{
			;

			//`log(" ChadAI - Pawn " @ Pawn @ " MoveToAndDefendCoverGoal:: Not able to Reserved Cover Node: " @ m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend.Link @ " slot: " @ m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend.SlotIdx @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			//InvalidateMoveGoal( m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend.Link, m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend.SlotIdx );

			if( m_MoveToAndDefendCoverGoalInfo.m_bAllowWaitingForPathOrPositionToClear )
			{
				//`log(" ChadAI - Pawn " @ Pawn @ " MoveToAndDefendCoverGoal:: Not able to Reserved Cove and if have not tried path to many times Num Tried: " @ m_MoveToAndDefendCoverGoalInfo.m_NoOfTimesPathHasBeenTried @ " to try " @m_MoveToAndDefendCoverGoalInfo.m_NoOfTimesToCheckForPathToCover@ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				
				if( ( m_MoveToAndDefendCoverGoalInfo.m_NoOfTimesToCheckForPathToCover < 0 ) ||( m_MoveToAndDefendCoverGoalInfo.m_NoOfTimesPathHasBeenTried < m_MoveToAndDefendCoverGoalInfo.m_NoOfTimesToCheckForPathToCover ) )
				{
					//`log(" ChadAI - Pawn " @ Pawn @ " MoveToAndDefendCoverGoal:: Not able to Reserved Cover and has not tried to many times yet -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					if( Enemy != None )
					{
						if ( CanFireAtNotFromCover(Enemy, true ) )
						{
							//`log(" ChadAI - Pawn " @ Pawn @ " MoveToAndDefendCoverGoal:: Not able to Reserved Cover Node and has enemy with line of fire so attack -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
							;

							PushState('Open_Field_Attack');
						}
						else
						{
							;
							Goto('WaitForCoverToClear');
						}

					}
					else
					{
						;

						Goto('WaitForCoverToClear');

					}
				} // end if( m_MoveToAndDefendCoverGoalInfo.m_NoOfTimesPathHasBeenTried < m_MoveToAndDefendCoverGoalInfo.m_NoOfTimesToCheckForPathToCover )
				else
				{

					//`log(" ChadAI - Pawn " @ Pawn @ " MoveToAndDefendCoverGoal:: Not able to Reserved Cover Node and allowed to wait for it clear but tried to many times -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					InvalidateMoveGoal( m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend.Link, m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend.SlotIdx );

					if( m_MoveToAndDefendCoverGoalInfo.m_bTaskFailedWhenCoverCanNotBeClaimed )
					{
						;
						FailedGoal();
					}
					else
					{
						;
						AccomplishedGoal();
					}

					Goto('DoneDefendingCover');
				}
			}
			else
			{

				//`log(" ChadAI - Pawn " @ Pawn @ " MoveToAndDefendCoverGoal:: Not able to Reserved Cover Node and not allowed to wait for it clear so invalidate and then fail task-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				InvalidateMoveGoal( m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend.Link, m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend.SlotIdx );


				if( m_MoveToAndDefendCoverGoalInfo.m_bTaskFailedWhenCoverCanNotBeClaimed )
				{
					;
					FailedGoal();
				}
				else
				{
					;
					AccomplishedGoal();
				}

				Goto('DoneDefendingCover');
			}
			

			//Goto('DoneDefendingCover');
			// make cover invalid
		}


	} // end if ( m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend.Link != None)
	else
	{
		;

		InvalidateMoveGoal( m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend.Link, m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend.SlotIdx );
		FailedGoal();
		Goto('DoneDefendingCover');
	}

	Sleep(0.0);


		//`AILOG(0, 'Move', "OnAIMoveToActor: moving to actor");	
	//`log(" ChadAI - MoveToAndDefendCoverGoal::Begin call AccomplishedGoal()  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	Goto('MoveToAndDefendCoverGoalLoop');


DefendCoverSubState:

	m_CoverFightData.m_CurrentlyCoverToUseAsFightPos = m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend;

	//`log(" ChadAI - Pawn " @ Pawn @ " MoveToAndDefendCoverGoalLoop Back from Use Fighting Position-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_DoneMovingAtCover;

	m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_CurrentlyUsing;

	PushState('UseFightingPosition');

	m_CoverFightData.m_CurrentlyCoverToUseAsFightPos = m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend;

	//`log(" ChadAI - Pawn " @ Pawn @ " MoveToAndDefendCoverGoalLoop Back from Use Fighting Position Status: " @ m_CoverFightData.m_UseFightingPositionStatus  @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_None;


	if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_SucceededBecauseTimePassed )
	{
		AccomplishedGoal();
		Goto('DoneDefendingCover');
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_FailedBecauseForgotIt )
	{
		Goto('MoveToAndDefendCoverGoalLoop');
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_PausedGrenadeOut )
	{
		Goto('MoveToAndDefendCoverGoalLoop');
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_FailedNoLineOfFireToEnemy )
	{
		Goto('MoveToAndDefendCoverGoalLoop');
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_FailedAngleToEnemy )
	{
		if( m_MoveToAndDefendCoverGoalInfo.m_bTaskFailedWhenViolatedByAngleToEnemy )
		{
			;

			FailedGoal();
		}
		else
		{
			;

			AccomplishedGoal();
		}
		Goto('DoneDefendingCover');	
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_FailedDistanceToEnemy )
	{
		if( m_MoveToAndDefendCoverGoalInfo.m_bTaskFailedWhenViolatedByDistenceToEnemy )
		{
			;

			FailedGoal();
		}
		else
		{
			;

			AccomplishedGoal();
		}
		Goto('DoneDefendingCover');	
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_PausedEnemyIsAtCQB_Dist )
	{
		//`log(" ChadAI -Pawn " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " MoveToAndDefendCoverGoal::Begin Back From Use Fighting Pos and status == UseFightingPosition_PausedEnemyIsAtCQB_Dist PushState('CloseQuartersBattleAttack') -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		PushState('CloseQuartersBattleAttack');
		Goto('MoveToAndDefendCoverGoalLoop');
	}
	else
	{
		;	
		//`log(" ChadAI - MoveToAndDefendCoverGoal Back from Use Fighing Position and Failed for an Unknown Reason  m_CoverFightData.m_UseFightingPositionStatus: " @ m_CoverFightData.m_UseFightingPositionStatus @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		FailedGoal();
		Goto('DoneDefendingCover');	
	}

WaitForCoverToClear:

	m_WanderInfo.m_TimeToWanderOrStandWaitingForPathOrPositionToClear = m_MoveToAndDefendCoverGoalInfo.m_TimeToWaitBetweenPathChecks;
	m_WanderInfo.m_bAllowAttackWhileWaitingForPathToClear = m_MoveToAndDefendCoverGoalInfo.m_bAllowAttackWhileWaitingForPathToClear;

	if( m_MoveToAndDefendCoverGoalInfo.m_bAllowWanderingWhileWaiting && m_WanderInfo.m_bAllowIdleWander )
	{
		;

		//`log(" ChadAI - Pawn " @ Pawn @ " MoveToAndDefendCoverGoal:: Not able to Reserved Cover Node and allowed to wander a little bit  and try again -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		PushState('WanderAround');
	}
	else
	{
		//`log(" ChadAI - Pawn " @ Pawn @ " MoveToAndDefendCoverGoal:: Not able to Reserved Cover Node and Not allowed to wander a little bit  so stand and try again -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;

		PushState('StandWaitingForPathToClear');
	}

	Goto('MoveToAndDefendCoverGoalLoop');

DoneDefendingCover:

	m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link = None;
	m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.SlotIdx. = -1;
	
	//`log(" ChadAI - MoveToAndDefendCoverGoal::Begin call ENDED  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );


// 	if( IsInState('MoveToAndDefendCoverGoal') )
// 	{
// 		PopState();
// 	}

// 	
	//`log(" ChadAI - TPSoldierAIController::MoveToAndDefendCoverGoal::MoveToAndDefendCoverGoalLoop:: GotoState('Idle') -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 
	//Sleep(0.1);
// 
	Sleep(0.0);

	;	

	EvaluateSituation();

}

native final function bool CanIjustStayHereAndReuseThisCoverSlot( CoverInfo Cov2Test );

//-----------------------------------------------------------------------
// State:		AttackUsingCoverGoal
// Description:
//-----------------------------------------------------------------------
state AttackUsingCoverGoal
{

	function BeginState(Name PreviousStateName)
	{
		;

		m_CoverFightData.m_bUsingFightingPosition = true;
		//`log(" ChadAI - TPSoldierAIController::AttackUsingCoverGoal::BeginState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
	}
	
	event PausedState()
	{
		;

		//`log(" ChadAI - TPSoldierAIController::AttackUsingCoverGoal::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
	
		//`log(" ChadAI - SENSING - " @ self @ "AttackUsingCoverGoal::OnSeeEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
		if( CheckForEnemy(false) )
		{
			;
		}

	}
	
	
	// is only called when the heared player in a new enemy
	event OnHearEnemy(int playerIdx)
	{
		//`log(" ChadAI - SENSING - " @ self @ "AttackUsingCoverGoal::OnHearEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		//`log(" ChadAI - SENSING - " @ self @ "AttackUsingCoverGoal::OnHearEnemy - bNewEnemy so AcquireEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		//`AILOG(0, 'Sensory', "- AttackUsingCoverGoal::OnHearEnemy AcquiredEnemy: " @  m_playerList[playerIdx].Player.GetPawnName(true) );
		//AcquireEnemy(playerIdx);

		if( CheckForEnemy(false) )
		{
			;
		}
	}

	event ContinuedState()
	{
		;
		m_HighLevelAiGoal = HighLevelAiGoal_AttackUsingCoverGroupGoal;

		//`log(" ChadAI - TPSoldierAIController::AttackUsingCoverGoal::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	}
	
	function EndState(Name NextStateName)
	{
		;

		//`log(" ChadAI - TPSoldierAIController::AttackUsingCoverGoal::EndState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		m_AttackUsingCoverGoalInfo.m_bUseCoverGroupTimer = false;
		m_HighLevelAiGoal = HighLevelAiGoal_NONE;
		m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link = None;
		m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.SlotIdx = -1;
	}

	event PoppedState()
	{
		;

		ClearLatentAction(class'SeqAct_AIAttackUsingCover',true);

		m_AttackUsingCoverGoalInfo.m_bUseCoverGroupTimer = false;
		m_HighLevelAiGoal = HighLevelAiGoal_NONE;
		m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link = None;
		m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.SlotIdx = -1;
	}
	
	function bool HasGoalBeenAccomplished()
	{
		//`log(" ChadAI - TPSoldierAIController::AttackUsingCoverGoal::HasGoalBeenAccomplished m_AttackUsingCoverGoalInfo.m_AmountOfTimeToInCoverGroup: " @ m_AttackUsingCoverGoalInfo.m_AmountOfTimeInCoverGroup @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		if( m_AttackUsingCoverGoalInfo.m_bUseCoverGroupTimer )
		{
			//`log(" ChadAI - TPSoldierAIController::AttackUsingCoverGoal::HasGoalBeenAccomplished m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup: " @ m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
			// if negitive time stay in here for ever
			if( m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup > 0.0f )
			{
				if( (WorldInfo.TimeSeconds - m_AttackUsingCoverGoalInfo.m_TimeStartedInCoverGroup) > m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup )
				{
					//`log(" ChadAI - TPSoldierAIController::Fire_From_Cover_Slot::Tick m_AttackUsingCoverGoalInfo.m_AmountOfTimeInCoverGroup >= m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
					;

					return true;
				}

				//`log(" ChadAI - TPSoldierAIController::AttackUsingCoverGoal::HasGoalBeenAccomplished No enough time has not passed -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
			}
		}

		return false;
	}


 	event Tick( float DeltaTime )
 	{
 		//`log(" ChadAI - TPSoldierAIController::AttackUsingCoverGoal::Tick m_AttackUsingCoverGoalInfo.m_AmountOfTimeToInCoverGroup: " @ m_AttackUsingCoverGoalInfo.m_AmountOfTimeInCoverGroup @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");			
 		UpdateAimInTheOpen(FALSE);;
		UpdateHeadtracking();
		Super.Tick(DeltaTime);	
	}

Begin:

	m_SubStateDebugInfoTag="Begin";

	//`log(" ChadAI - TPSoldierAIController::AttackUsingCoverGoal::Begin -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	m_HighLevelAiGoal = HighLevelAiGoal_AttackUsingCoverGroupGoal;

	m_AttackUsingCoverGoalInfo.m_TimeStartedInCoverGroup = WorldInfo.TimeSeconds;
		
	//`log(" ChadAI - AttackUsingCoverGoal::Begin call ENDED  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

AttackUsingCoverGoalLoop:
// 	
	//`log(" ChadAI - TPSoldierAIController::AttackUsingCoverGoal::AttackUsingCoverGoalLoop::-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 
	//`log(" ChadAI - AttackUsingCoverGoal::AttackUsingCoverGoalLoop call HasGoalBeenAccomplished()  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	if( HasGoalBeenAccomplished() )
	{
		//`log(" ChadAI - AttackUsingCoverGoal::AttackUsingCoverGoalLoop Goal Has Been Accomplished*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		;

		Goto('AccomplishedGoal');
	}
	
	//`log(" ChadAI - AttackUsingCoverGoal::AttackUsingCoverGoalLoop Goal Has Not Been Accomplished  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
	
	// Check for if should Melee Attack
	if( DetermineIfShouldStartCQB_Tick( WorldInfo.TimeSeconds ) )
	{
		//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::Tick:: EnemyIsInRange  m_RangeToStartCQB_State -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		
		PushState('CloseQuartersBattleAttack');
	}	

	if ( m_AttackUsingCoverGoalInfo.m_CoverGroup != None)
	{
		//`log(" ChadAI - TPSoldierAIController::AttackUsingCoverGoal::AttackUsingCoverGoalLoop m_AttackUsingCoverGoalInfo.m_CoverGroup != None -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		if (ShouldIUseTurret() && m_DesiredTurret.ClaimTurret(Self))
		{
			;
			PushState('Action_TurretGunning', 'Begin');
		}
		else
		{
			// need to get the loc of a cover slot to move to
						
			m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse = FindBestCoverInCoverGroup();

			;


			// special checks to see if find cover found nothing

// 			if( m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse.Link == None )
// 			{
			
				//`log(" ChadAI - - Pawn: " @ Pawn @ " TPSoldierAIController::AttackUsingCoverGoal::AttackUsingCoverGoalLoop FindBestCover was not able to find a cover node to go to, so check to see if the old cover is valid -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

				//`AILOG(1, 'AttackUsingCoverGoal', "FindBestCoverInCoverGroup - " @ Pawn @ " Failed to find acceptable cover! so checking current - reserved - and previous cover to see if still good--------------------------------------------------------------------------------------------" );

				// check to see if the old cover is valid








				if( m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse.Link != None &&
					( m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse ==  m_CoverMoveData.m_CurrentCover_Clamied ) )
				{
					//`log(" ChadAI - - Pawn: " @ Pawn @ " AttackUsingCoverGoalLoop m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse ==  m_CoverMoveData.m_CurrentCover_Clamied So lets see if I can just stay here -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

					;

					// check to see if the old cover is valid

					if ( m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse.Link != None )
					{
						//`log(" ChadAI - - " @ Pawn @ " Evaluating m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse Node : " @ m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse.Link @ " slot: " @ m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse.SlotIdx @ "  --------------------------------------------------------------------------------------------" );	


							if( IsPotentialCover( m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse ))
							{
								if(IsAngleToEnemyValidForThisCoverSlot( m_CoverMoveData.m_CurrentCover_Clamied ) )
								{
									//`log(" ChadAI - Find best cover for goal - "@Pawn @ " Can conciderbecause of angle to enemy is valid for this slot Node: " @ currEvanNodeInfo.Link @ " slot: " @currEvanNodeInfo.SlotIdx @"-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");

									if( !IsSomeJerkBlockingYourCover( m_CoverMoveData.m_CurrentCover_Clamied.Link.GetSlotLocation(m_CoverMoveData.m_CurrentCover_Clamied.SLotIdx) ) )
									{
										//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackUsingCoverGoal::AttackUsingCoverGoalLoop FindBestCover failed and IsAngleToEnemyValidForThisCoverSlot = true -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

										//m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse = m_CoverMoveData.m_CurrentCover_Clamied;

										// if close enough to the new slot just occipy it snap to it and then use it
										if( CanIjustStayHereAndReuseThisCoverSlot( m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse) )
										{
											;
											
											// if the current cover is an open field mid level need to trans back to hide because that is where use cover expects NPCs to start at even in the open
											if(( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType == CT_OpenFieldMidLevel  ))
											{
												// the the pawn is hiding have him go to a non hiding pose then stand up
												 ;	
												
												m_CoverMoveData.m_RotAtStartOfTravel = Pawn.Rotation;

												m_CoverFightData.m_CurrentCoverAction = CA_PopUp;

												m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_FiringToHiding;
												m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;

												m_SubStateDebugInfoTag="Trans to hiding to redo an AUsCoG Cover Slot";
												while(( m_CoverMoveData.m_CoverTransitionAction != CoverTransitionAction_NotTransitioning ) &&
													( (WorldInfo.TimeSeconds - m_CoverFightData.m_TimeStartedLastCoverTransition) < class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_MaxTimeToWaitForCoverTransitionToEnd ) )
												{
 													DesiredRotation = m_CoverMoveData.m_RotAtStartOfTravel;
													Pawn.DesiredRotation = DesiredRotation;
													Pawn.SetRotation( DesiredRotation );
													Sleep(0.0);
												}
											}

											Goto('AttackFromCoverSubState');
										}
										else
										{
											//`log(" ChadAI - - Pawn: " @ Pawn @ " AttackUsingCoverGoalLoop CanIjustStayHereAndReuseThisCoverSlot( m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse) -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

											;
										}

									} // end if !IsSomeJerkBlockingYourCover
									else
									{
										//`log(" ChadAI - - Pawn: " @ Pawn @ " AttackUsingCoverGoalLoop IsSomeJerkBlockingYourCover( m_CoverMoveData.m_CurrentCover_Clamied.Link.GetSlotLocation(m_CoverMoveData.m_CurrentCover_Clamied.SLotIdx) -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

										;
									}
								} // end if(IsAngleToEnemyValidForThisCoverSlot( m_CoverMoveData.m_PreviousCover_Not_Clamied ) )
								else
								{
									//`log(" ChadAI - - Pawn: " @ Pawn @ " AttackUsingCoverGoalLoop  !IsAngleToEnemyValidForThisCoverSlot( m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse ) -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

									;
								}
							} // end if( IsPotentialCover( m_CoverMoveData.m_PreviousCover_Not_Clamied ))
							else
							{
								//`log(" ChadAI - - Pawn: " @ Pawn @ " AttackUsingCoverGoalLoop  Is NOT PotentialCover( m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse ) -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

								;
							}
					} // end if ( m_CoverMoveData.m_PreviousCover_Not_Clamied.Link != None )
				}












				if ( m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse.Link == None && m_CoverMoveData.m_PreviousCover_Not_Clamied.Link != None )
				{
					//`log(" ChadAI - - " @ Pawn @ " Evaluating m_PreviousCover_NOT_Clamied Node : " @ m_CoverMoveData.m_PreviousCover_Not_Clamied.Link @ " slot: " @ m_CoverMoveData.m_PreviousCover_Not_Clamied.SlotIdx @ "  --------------------------------------------------------------------------------------------" );	

					if( m_CoverMoveData.m_PreviousCover_Not_Clamied.Link.Slots[m_CoverMoveData.m_PreviousCover_Not_Clamied.SLotIdx].SlotOwner == None )
					{
						//`log(" ChadAI - - " @ Pawn @ " Node : " @ m_CoverMoveData.m_PreviousCover_Not_Clamied.Link @ " slot: " @ m_CoverMoveData.m_PreviousCover_Not_Clamied.SlotIdx @ " Does Not Have a Slot Owner that is not you --------------------------------------------------------------------------------------------" );	

						if( IsPotentialCover( m_CoverMoveData.m_PreviousCover_Not_Clamied ))
						{
							if(IsAngleToEnemyValidForThisCoverSlot( m_CoverMoveData.m_PreviousCover_Not_Clamied ) )
							{
								//`log(" ChadAI - Find best cover for goal - "@Pawn @ " Can conciderbecause of angle to enemy is valid for this slot Node: " @ currEvanNodeInfo.Link @ " slot: " @currEvanNodeInfo.SlotIdx @"-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");

								if( !IsSomeJerkBlockingYourCover( m_CoverMoveData.m_PreviousCover_Not_Clamied.Link.GetSlotLocation(m_CoverMoveData.m_PreviousCover_Not_Clamied.SLotIdx) ) )
								{
									//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackUsingCoverGoal::AttackUsingCoverGoalLoop FindBestCover failed and IsAngleToEnemyValidForThisCoverSlot = true -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

									m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse = m_CoverMoveData.m_PreviousCover_Not_Clamied;

									// if close enough to the new slot just occipy it snap to it and then use it
									if( CanIjustStayHereAndReuseThisCoverSlot(m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse) )
									{
										;
										
										if(( m_CoverMoveData.m_PreviousCover_Not_Clamied.Link.Slots[m_CoverMoveData.m_PreviousCover_Not_Clamied.SlotIdx].CoverType == CT_OpenFieldMidLevel  ))
										{
											// the the pawn is hiding have him go to a non hiding pose then stand up
											 ;	

											m_CoverMoveData.m_RotAtStartOfTravel = Pawn.Rotation;

											m_CoverFightData.m_CurrentCoverAction = CA_PopUp;

											m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_FiringToHiding;
											m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;

											m_SubStateDebugInfoTag="Trans to hiding to redo an AUsCoG Cover Slot";
											while(( m_CoverMoveData.m_CoverTransitionAction != CoverTransitionAction_NotTransitioning ) &&
												( (WorldInfo.TimeSeconds - m_CoverFightData.m_TimeStartedLastCoverTransition) < class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_MaxTimeToWaitForCoverTransitionToEnd ) )
											{
													DesiredRotation = m_CoverMoveData.m_RotAtStartOfTravel;
   													Pawn.DesiredRotation = DesiredRotation;
   													Pawn.SetRotation( DesiredRotation );
												Sleep(0.0);
											}
										}
										
										Goto('AttackFromCoverSubState');
									}

									;

								} // end if !IsSomeJerkBlockingYourCover
							} // end if(IsAngleToEnemyValidForThisCoverSlot( m_CoverMoveData.m_PreviousCover_Not_Clamied ) )
						} // end if( IsPotentialCover( m_CoverMoveData.m_PreviousCover_Not_Clamied ))
					} // end if( m_CoverMoveData.m_PreviousCover_Not_Clamied.Link.Slots[m_CoverMoveData.m_PreviousCover_Not_Clamied.SLotIdx].SlotOwner == None )
				} // end if ( m_CoverMoveData.m_PreviousCover_Not_Clamied.Link != None )
			//}

		
			if( m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse.Link != None )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackUsingCoverGoal::AttackUsingCoverGoalLoop FindBestCover found cover and now going to it -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

				if( ReserveCover(m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse) )
				{
				
					//`log(" ChadAI - TPSoldierAIController::AttackUsingCoverGoal::AttackUsingCoverGoalLoop m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse.Link " @ m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse.Link @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				
					m_CoverMoveData.m_TimeToUseCoverInSeconds = RandRange(m_AttackUsingCoverGoalInfo.m_MinTimeToUseCoverInSeconds, m_AttackUsingCoverGoalInfo.m_MaxTimeToUseCoverInSeconds);

				
					//`log(" ChadAI - TPSoldierAIController::AttackUsingCoverGoal::AttackUsingCoverGoalLoop m_TimeToUseCoverInSeconds " @ m_CoverMoveData.m_TimeToUseCoverInSeconds @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");							
				

					//`log(" ChadAI - Pawn: " @ Pawn @ " AttackUsingCoverGoal::Begin() Is not at cover so KynapseGoToFindPath Node: " @ m_CoverMoveData.m_ReservedGoToCover_Clamied.Link @ " SLot: " @ m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					//`log(" ChadAI - Pawn: " @ Pawn @ " AttackUsingCoverGoal::Begin() Is not at cover so KynapseGoToFindPath Point: " @ m_CoverMoveData.m_ReservedGoToCover_Clamied.Link.GetSlotLocation( m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx )  @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					//`log(" ChadAI - Pawn: " @ Pawn @ " AttackUsingCoverGoal::Begin() Is not at cover so KynapseGoToFindPath Pawn Loc: " @ Pawn.Location @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_BuildingPath;

					KynapseGoToFindPath( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link.GetSlotLocation( m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx ) );

					if ( KynapseFoundPath() )
					{
						//`log(" ChadAI - Pawn " @ Pawn @ " AttackUsingCoverGoal::Begin Has Cover Path Found Now Travel There -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

						m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_PathBuiltWaitingToMove;

						m_CoverMoveData.m_HasPathToCoverBeenBuilt = true;
						m_CoverMoveData.m_bCheckToSeeIfCoverIsStillValidDuringMoveToCover = true;

						PushState('TravelToCoverSlot');

						//`log(" ChadAI - Pawn " @ Pawn @ " AttackUsingCoverGoal::Begin Back From Travel To Cover Slot status: " @ m_CoverMoveData.m_Move2CoverStatus @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

						if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_DoneMovingAtCover )
						{
							//`log(" ChadAI - Pawn " @ Pawn @ " AttackUsingCoverGoal::Begin Back From Travel To Cover Slot and status == Move2CovStat_DoneMovingAtCover Goto('AttackFromCoverSubState') -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
						
							Goto('AttackFromCoverSubState');

						}
						else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedCQB_Needed )
						{
							//`log(" ChadAI - Pawn " @ Pawn @ " AttackUsingCoverGoal::Begin Back From Travel To Cover Slot and status == Move2CovStat_FailedCQB_Needed PushState('CloseQuartersBattleAttack') -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

							PushState('CloseQuartersBattleAttack');

							m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_None;

						}
						else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedBlockedByPawn )
						{
							//`log(" ChadAI - Pawn " @ Pawn @ " AttackUsingCoverGoal::Begin Back From Travel To Cover Slot and status == Move2CovStat_FailedBlockedByPawn make cover invalid for small time -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
							m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_None;

						}
						else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedBlockedByActor )
						{
							//`log(" ChadAI - Pawn " @ Pawn @ " AttackUsingCoverGoal::Begin Back From Travel To Cover Slot and status == Move2CovStat_FailedBlockedByActor make cover invalid for small time -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
							m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_None;
						}
						else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedEnemyMadeCoverInvalid )
						{
							;

							InvalidateMoveGoal( m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse.Link, m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse.SlotIdx );

							ClearReservedCover();

							Goto('AttackUsingCoverGoalLoop');
						}

					} // end if ( KynapseFoundPath() )
					else
					{
						//`log(" ChadAI - Pawn " @ Pawn @ " AttackUsingCoverGoal::Begin Does Not Have Cover Path Make Cover Invalid and find another cover to try -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

						;

						// no path
						m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_NoPathBuiltWaitingToMove;

						InvalidateMoveGoal( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link, m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx );

						ClearReservedCover();

						//PushState('WanderAround');

						// make cover invalid
					}			
					//Sleep(0.1);
				} // if( ReserveCover(m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse) )
				else // can not reserve the cover so make invalid and try again
				{
					//`log(" ChadAI - Pawn " @ Pawn @ " AttackUsingCoverGoal:: Not able to Reserved Cover Node: " @ m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse.Link @ " slot: " @ m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse.SlotIdx @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		
					;

					InvalidateMoveGoal( m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse.Link, m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse.SlotIdx );
					// make cover invalid
				}

			}// end if( m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse.Link != None )
			else
			{
				//`log(" ChadAI - - Pawn: " @ Pawn @ "TPSoldierAIController::AttackUsingCoverGoal::AttackUsingCoverGoalLoop FindBestCover was not able to find a cover node to go to and do not have another node to go to so having to free attack for a bit -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
				;


				m_AttackUsingCoverGoalInfo.m_NoOfTimesPathToAnyValidCoverHasBeenTried++;

				if( m_AttackUsingCoverGoalInfo.m_bAllowWaitingForPathOrPositionToAnyValidCoverToClear )
				{
					//`log(" ChadAI - Pawn " @ Pawn @ " AttackUsingCoverGoalLoop:: FindBestCover was not able to find a cover node to go to, see how many times I am allowed to try: " @ m_AttackUsingCoverGoalInfo.m_NoOfTimesPathToAnyValidCoverHasBeenTried @ " to try " @m_AttackUsingCoverGoalInfo.m_NoOfTimesToCheckForPathToAnyValidCover@ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					
					if( ( m_AttackUsingCoverGoalInfo.m_NoOfTimesToCheckForPathToAnyValidCover < 0 ) ||( m_AttackUsingCoverGoalInfo.m_NoOfTimesPathToAnyValidCoverHasBeenTried < m_AttackUsingCoverGoalInfo.m_NoOfTimesToCheckForPathToAnyValidCover ) )
					{
						//`log(" ChadAI - Pawn " @ Pawn @ " AttackUsingCoverGoalLoop:: Not able to go to any Cover and has not tried to many times yet -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

						if( m_AttackUsingCoverGoalInfo.m_bAllowWaitingForPathOrPositionToAnyValidCoverToClear && Enemy != None && CanFireAtNotFromCover(Enemy, true ) )
						{
							//`log(" ChadAI - Pawn " @ Pawn @ " AttackUsingCoverGoalLoop:: Not able to move to any Cover Node and has enemy with line of fire so attack -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
							;

							PushState('Open_Field_Attack');

						}
						else
						{
							m_WanderInfo.m_TimeToWanderOrStandWaitingForPathOrPositionToClear = m_AttackUsingCoverGoalInfo.m_TimeToWaitBetweenPathToAnyValidCoverChecks;
							m_WanderInfo.m_bAllowAttackWhileWaitingForPathToClear = m_AttackUsingCoverGoalInfo.m_bAllowAttackWhileWaitingForPathToAnyValidCoverToClear;

							if( m_AttackUsingCoverGoalInfo.m_bAllowWanderingWhileWaitingForPathToAnyValidCover && m_WanderInfo.m_bAllowIdleWander)
							{
								//`log(" ChadAI - Pawn " @ Pawn @ " AttackUsingCoverGoalLoop:: Not able to move to any Cover Node and allowed to wander a little bit  and try again -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
								;
								
								PushState('WanderAround');
							}
							else
							{
								//`log(" ChadAI - Pawn " @ Pawn @ " AttackUsingCoverGoalLoop:: Not able to Reserved Cover Node and Not allowed to wander a little bit  so stand and try again -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
								;

								PushState('StandWaitingForPathToClear');
							}
						}
					} // end if( m_AttackUsingCoverGoalInfo.m_NoOfTimesPathHasBeenTried < m_AttackUsingCoverGoalInfo.m_NoOfTimesToCheckForPathToCover )
					else
					{

						//`log(" ChadAI - Pawn " @ Pawn @ " AttackUsingCoverGoalLoop:: Not able to move to any Cover Node and allowed to wait for one to clear but tried to many times -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

						if( m_AttackUsingCoverGoalInfo.m_bTaskFailedWhenPathToAnyValidCoverCanNotBeFound )
						{
							;
							Goto('FailedGoal');
						}
						else
						{
							;
							Goto('AccomplishedGoal');
						}
					}
				} // end if m_AttackUsingCoverGoalInfo.m_bAllowWaitingForPathOrPositionToAnyValidCoverToClear
				else
				{

					//`log(" ChadAI - Pawn " @ Pawn @ " AttackUsingCoverGoal:: Not able to find ANY valid cover slots to go to and not allowed to wait for it clear so fail task-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					if( m_AttackUsingCoverGoalInfo.m_bTaskFailedWhenPathToAnyValidCoverCanNotBeFound )
					{
						;
						Goto('FailedGoal');
					}
					else
					{
						;
						Goto('AccomplishedGoal');
					}
				}
			}
	
		}// end else for ShouldIUseTurret()

	}
	else
	{ 
		;

		// we have no cover group so go quit this task
		Goto('FailedGoal');

	}
	Sleep(0.0);	
	
	Goto('AttackUsingCoverGoalLoop');

AttackFromCoverSubState:

	m_CoverFightData.m_CurrentlyCoverToUseAsFightPos = m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse;

	m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_DoneMovingAtCover;

	m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_CurrentlyUsing;

	PushState('UseFightingPosition');

	m_CoverFightData.m_CurrentlyCoverToUseAsFightPos = m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse;

	//`log(" ChadAI - Pawn " @ Pawn @ " AttackUsingCoverGoal Back from Use Fighting Position Status: " @ m_CoverFightData.m_UseFightingPositionStatus  @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_None;

	if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_SucceededBecauseTimePassed )
	{
		Goto('AttackUsingCoverGoalLoop');
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_FailedBecauseForgotIt )
	{
		Goto('AttackUsingCoverGoalLoop');
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_PausedGrenadeOut )
	{
		Goto('AttackUsingCoverGoalLoop');
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_FailedAngleToEnemy )
	{
		Goto('AttackUsingCoverGoalLoop');	
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_FailedNoLineOfFireToEnemy )
	{
		Goto('AttackUsingCoverGoalLoop');	
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_FailedDistanceToEnemy )
	{
		Goto('AttackUsingCoverGoalLoop');	
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_PausedEnemyIsAtCQB_Dist )
	{
		//`log(" ChadAI - Pawn " @ Pawn @ " AttackUsingCoverGoal::Begin Back From Use Fighting Pos and status == UseFightingPosition_PausedEnemyIsAtCQB_Dist PushState('CloseQuartersBattleAttack') -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		PushState('CloseQuartersBattleAttack');
		Goto('AttackUsingCoverGoalLoop');
	}
	else
	{
		;	
		//`log(" ChadAI - Free_Attack_Goal Back from Use Fighing Position and Failed for an Unknown Reason  m_CoverFightData.m_UseFightingPositionStatus: " @ m_CoverFightData.m_UseFightingPositionStatus @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		Goto('AttackUsingCoverGoalLoop');	
	}


AccomplishedGoal:
	m_CoverFightData.m_bUsingFightingPosition = false;

	ClearLatentAction(class'SeqAct_AIAttackUsingCover',false);

	Sleep(0.0);

	;	


	EvaluateSituation();


FailedGoal:

	m_CoverFightData.m_bUsingFightingPosition = false;

	ClearLatentAction(class'SeqAct_AIAttackUsingCover',true);

	Sleep(0.0);

	;	

	EvaluateSituation();

}



//-----------------------------------------------------------------------
// State:		MultiTierAttackUsingCoverGoal
// Description:
//-----------------------------------------------------------------------
state MultiTierAttackUsingCoverGoal
{
	function BeginState(Name PreviousStateName)
	{
		;

		m_HighLevelAiGoal = HighLevelAiGoal_MultiTierAttackUsingCoverGoal;

		m_CoverFightData.m_bUsingFightingPosition = true;
		//`log(" ChadAI - TPSoldierAIController::MultiTierAttackUsingCoverGoal::BeginState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
	}
	
	event PausedState()
	{
		;

		//`log(" ChadAI - TPSoldierAIController::MultiTierAttackUsingCoverGoal::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	event PoppedState()
	{
		;

		m_HighLevelAiGoal = HighLevelAiGoal_NONE;

		//`log(" ChadAI - TPSoldierAIController::MultiTierAttackUsingCoverGoal::PoppedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	event ContinuedState()
	{
		;

		m_HighLevelAiGoal = HighLevelAiGoal_MultiTierAttackUsingCoverGoal;


		//`log(" ChadAI - TPSoldierAIController::MultiTierAttackUsingCoverGoal::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	
		if( Enemy != None )
		{
			if( !IsAngleToEnemyValidForThisCoverSlot( m_CoverMoveData.m_CurrentCover_Clamied ) )
			{
				//`log(" ChadAI - TPSoldierAIController::MultiTierAttackUsingCoverGoal::ContinuedState:: !IsAngleToEnemyValidForThisCoverSlot Node: " @ m_CoverMoveData.m_CurrentCover_Clamied.Link @ " slot: " @ m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx @"-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
				m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedAngleToEnemy;

				PopState();
			}
		}
		else
		{
			PopState();
		}
	}
	
	function EndState(Name NextStateName)
	{
		;

		m_HighLevelAiGoal = HighLevelAiGoal_NONE;

		//`log(" ChadAI - TPSoldierAIController::MultiTierAttackUsingCoverGoal::EndState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}
	
	function bool HasGoalBeenAccomplished()
	{
		if( Enemy == None )
		{
			return true;
		}

		return false;
	}
	
	function AccomplishedGoal()
	{
		//`log(" ChadAI - TPSoldierAIController::MultiTierAttackUsingCoverGoal::AccomplishedGoal() -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		m_CoverFightData.m_bUsingFightingPosition = false;
	}
	
	function CoverInfo FindBestCoverMTE()
	{		
		local CoverInfo bestNode, coverClosestToEnemy, coverClosestToMe, currentTestInfo;
		local int slotNo;
		local TPCoverNode curNode;
		local vector slotLoc;
			
		local float shortestDistFromEnemy;
		local float distFromEnemy;
		
		local float shortestDistFromMe;
		local float distFromMe;
		
		shortestDistFromEnemy = 900000.0f;
		distFromEnemy = 0.0f;
		
		shortestDistFromMe = 900000.0f;
		distFromMe = 0.0f;
				
		//find node closest to the enemy
		
		//then make a list of nodes close to me
		
		// CanFireAt

		if( Enemy != None && Pawn != None )
		{
			//foreach WorldInfo.RadiusNavigationPoints(class'TPCoverNode', nav, anchorLoc, dist)
			foreach WorldInfo.AllNavigationPoints(class'TPCoverNode', curNode)//KMM says, just iterate through cover nodes?
			{
				//`log(" ChadAI - " @ Pawn @ " Evaluating Cover Node: " @ curNode @ " Loc: " @ curNode.Location @ " --------------------------------------------------------------------------------------------" );
				
				if( curNode.bEnabled )
				{
					for( slotNo = 0; slotNo < curNode.Slots.Length; slotNo++ )
					{
						// make sure not on InvalidateMoveGoal list
						if( !IsInvalidatedMoveGoal(slotNo, curNode) )
						{
							slotLoc = curNode.GetSlotLocation(slotNo);

							currentTestInfo.Link = curNode;
							currentTestInfo.SlotIdx = slotNo;
							
							//`log(" ChadAI - " @ Pawn @ " Evaluating Cover Node Slot : " @ slotNo @ " Loc: " @ slotLoc @ " --------------------------------------------------------------------------------------------" );
						
							// make sure slot it not off or disabled
							if( curNode.Slots[slotNo].bEnabled )
							{
								// make sure that the slot has at least one other slot that can fire at it
								if( curNode.Slots[slotNo].FireLinks.Length > 0 )
								{
								
									//`log(" ChadAI - " @ Pawn @ " Cover Node Slot has at least one fire link: " @ curNode.Slots[slotNo].FireLinks.Length @ " --------------------------------------------------------------------------------------------" );
									
									distFromEnemy = VSize(slotLoc - Enemy.Location);
									distFromMe = VSize(slotLoc - Pawn.Location);
									
									//`log(" ChadAI - " @ Pawn @ " slot is: " @ distFromEnemy @ " from enemy and the closest so far is: " @ shortestDistFromEnemy @ " away --------------------------------------------------------------------------------------------" );
									//`log(" ChadAI - " @ Pawn @ " slot is: " @ distFromMe @ " from me and the closest so far is: " @ shortestDistFromMe @ " away --------------------------------------------------------------------------------------------" );
								
									if ( distFromEnemy < shortestDistFromEnemy)
									{
									
										//`log(" ChadAI - " @ Pawn @ " Cover Node Slot is closer then current best for enemy--------------------------------------------------------------------------------------------" );
									
															
										//node = TPCoverNode(nav);
										coverClosestToEnemy.Link = curNode;
										coverClosestToEnemy.SlotIdx = slotNo;
										
										shortestDistFromEnemy = distFromEnemy;
									}
									
									if ( distFromMe < shortestDistFromMe)
									{
										//`log(" ChadAI - " @ Pawn @ " Cover Node Slot is closer then current best for me so test if valid --------------------------------------------------------------------------------------------" );
									
										if( curNode.Slots[slotNo].SlotOwner == None )
										{
											//`log(" ChadAI - " @ Pawn @ " Evaluating Cover Node Slot : " @ slotNo @ " has not Slot Owner --------------------------------------------------------------------------------------------" );	

											if(IsAngleToEnemyValidForThisCoverSlot( currentTestInfo ) )
											{
												//`log(" ChadAI - Find best cover for goal - "@Pawn @ " Can conciderbecause of angle to enemy is valid for this slot Node: " @ currEvanNodeInfo.Link @ " slot: " @currEvanNodeInfo.SlotIdx @"-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");

												if( !IsSomeJerkBlockingYourCover( slotLoc ) )
												{					
													//node = TPCoverNode(nav);
													coverClosestToMe.Link = curNode;
													coverClosestToMe.SlotIdx = slotNo;
													
													shortestDistFromMe = distFromMe;

												} // end if( !IsSomeJerkBlockingYourCover( slotLoc ) )
										
											} // end if(IsAngleToEnemyValidForThisCoverSlot( currentTestInfo ) )
										} // end if( curNode.Slots[slotNo].SlotOwner == None )

									} // end if ( distFromMe < shortestDistFromMe)
								}
								else
								{
									//`log(" ChadAI - " @ Pawn @ " Cover Node Slot does NOT have at least one fire link: " @ curNode.Slots[slotNo].FireLinks.Length @ " --------------------------------------------------------------------------------------------" );
								}
							} // end if( curNode.Slots[slotNo].bEnabled )
						} // end if( !IsInvalidatedMoveGoal(slotNo, nav) )
						else
						{
							//`log(" ChadAI - " @ Pawn @ " IsInvalidatedMoveGoal Node: " @ curNode @ " slot: " @ slotNo @ ' --------------------------------------------------------------------------------------------" );
						}
							
					} // end for( slotNo = 0; slotNo < curNode.Slots.Length; slotNo++ )		
					
				} // end if( curNode.bEnabled )
			}
			
			if( coverClosestToEnemy.Link != None && coverClosestToEnemy.Link != None )
			{
				if( CanFireFromCoverToCover( coverClosestToMe, coverClosestToEnemy) )
				{
					bestNode = coverClosestToMe;			
					//`log(" ChadAI - MultiTierAttackUsingCoverGoal moving to coverClosestToMe.Link " @ coverClosestToMe.Link @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				}
			
			}

		} // end if( Enemy != None && Pawn != None )
								
		return bestNode;
	
	}
	
	
	
	event Tick( float DeltaTime )
	{
		//`log(" ChadAI - TPSoldierAIController::MultiTierAttackUsingCoverGoal::Tick -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		UpdateAimInTheOpen(FALSE);;
		UpdateHeadtracking();
		Super.Tick(DeltaTime);	
	}	

Begin:

	m_SubStateDebugInfoTag="Begin";


	m_HighLevelAiGoal = HighLevelAiGoal_MultiTierAttackUsingCoverGoal;


MultiTierAttackUsingCoverGoalLoop:
// 	
	//`log(" ChadAI - TPSoldierAIController::MultiTierAttackUsingCoverGoal::MultiTierAttackUsingCoverGoalLoop::-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	if( HasGoalBeenAccomplished() )
	{
		//`log(" ChadAI - MultiTierAttackUsingCoverGoalLoop Goal Has Been Accomplished*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		Goto('EndMTE_Attack');
	}
	
	//`log(" ChadAI - MultiTierAttackUsingCoverGoalLoop Goal Has Not Been Accomplished  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
	
	// Check for if should Melee Attack
	if( DetermineIfShouldStartCQB_Tick( WorldInfo.TimeSeconds ) )
	{
		//`log(" ChadAI - MultiTierAttackUsingCoverGoalLoop EnemyIsInRange  m_RangeToStartCQB_State -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		
		PushState('CloseQuartersBattleAttack');
	}	

	if ( Enemy != None)
	{
		//`log(" ChadAI - TPSoldierAIController::AttackUsingCoverGoal::AttackUsingCoverGoalLoop m_AttackUsingCoverGoalInfo.m_CoverGroup != None -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		if (ShouldIUseTurret() && m_DesiredTurret.ClaimTurret(Self))
		{
			PushState('Action_TurretGunning', 'Begin');
		}
		else
		{

			// need a tac engagement check
			if ( ShouldIFireTactical() )
			{
				// I can kill form here so lets do it
				;

				PushState('Open_Field_Attack');
				PopState();
			}

			// need to get the loc of a cover slot to move to
						
			m_MultiTierEngagementInfo.m_CurrentCoverToUseForMTE = FindBestCoverMTE(); // InvalidateMoveGoal( m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.Link, m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.SlotIdx );

			;


			// special checks to see if find cover found nothing

		
			if( m_MultiTierEngagementInfo.m_CurrentCoverToUseForMTE.Link != None )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " MultiTierAttackUsingCoverGoalLoop FindBestCoverMTE found cover and now going to it -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

				if( ReserveCover(m_MultiTierEngagementInfo.m_CurrentCoverToUseForMTE) )
				{
				
					//`log(" ChadAI - Pawn: " @ Pawn @ " MultiTierAttackUsingCoverGoalLoop m_CurrentCoverToUseForMTE.Link " @ m_MultiTierEngagementInfo.m_CurrentCoverToUseForMTE.Link @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				
					//m_CoverMoveData.m_TimeToUseCoverInSeconds = RandRange(m_AttackUsingCoverGoalInfo.m_MinTimeToUseCoverInSeconds, m_AttackUsingCoverGoalInfo.m_MaxTimeToUseCoverInSeconds);

				
					//`log(" ChadAI - TPSoldierAIController::AttackUsingCoverGoal::AttackUsingCoverGoalLoop m_TimeToUseCoverInSeconds " @ m_CoverMoveData.m_TimeToUseCoverInSeconds @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");							
				

					//`log(" ChadAI - Pawn: " @ Pawn @ " MultiTierAttackUsingCoverGoalLoop Is not at cover so move there -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_BuildingPath;

					KynapseGoToFindPath( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link.GetSlotLocation( m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx ) );

					if ( KynapseFoundPath() )
					{
						//`log(" ChadAI - Pawn " @ Pawn @ " MultiTierAttackUsingCoverGoalLoop Has Cover Path Found Now Travel There -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

						m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_PathBuiltWaitingToMove;

						m_CoverMoveData.m_HasPathToCoverBeenBuilt = true;
						m_CoverMoveData.m_bCheckToSeeIfCoverIsStillValidDuringMoveToCover = false;

						PushState('TravelToCoverSlot');

						//`log(" ChadAI - Pawn " @ Pawn @ " AttackUsingCoverGoal::Begin Back From Travel To Cover Slot status: " @ m_CoverMoveData.m_Move2CoverStatus @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

						if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_DoneMovingAtCover )
						{
							//`log(" ChadAI - Pawn " @ Pawn @ " MultiTierAttackUsingCoverGoalLoop Back From Travel To Cover Slot and status == Move2CovStat_DoneMovingAtCover Goto('AttackFromCoverSubState') -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
						
							Goto('AttackFromCoverSubState');

						}
						else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedCQB_Needed )
						{
							//`log(" ChadAI - Pawn " @ Pawn @ " MultiTierAttackUsingCoverGoalLoop Back From Travel To Cover Slot and status == Move2CovStat_FailedCQB_Needed PushState('CloseQuartersBattleAttack') -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

							PushState('CloseQuartersBattleAttack');

							m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_None;

						}
						else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedBlockedByPawn )
						{
							//`log(" ChadAI - Pawn " @ Pawn @ " MultiTierAttackUsingCoverGoalLoop Back From Travel To Cover Slot and status == Move2CovStat_FailedBlockedByPawn make cover invalid for small time -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
							m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_None;

						}
						else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedBlockedByActor )
						{
							//`log(" ChadAI - Pawn " @ Pawn @ " MultiTierAttackUsingCoverGoalLoop Back From Travel To Cover Slot and status == Move2CovStat_FailedBlockedByActor make cover invalid for small time -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
							m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_None;
						}
						else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedEnemyMadeCoverInvalid )
						{
							;

							InvalidateMoveGoal( m_MultiTierEngagementInfo.m_CurrentCoverToUseForMTE.Link, m_MultiTierEngagementInfo.m_CurrentCoverToUseForMTE.SlotIdx );

							ClearReservedCover();

							Goto('MultiTierAttackUsingCoverGoalLoop');
						}

					} // end if ( KynapseFoundPath() )
					else
					{
						//`log(" ChadAI - Pawn " @ Pawn @ " MultiTierAttackUsingCoverGoalLoop Does Not Have Cover Path Make Cover Invalid and find another cover to try -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

						// no path
						m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_NoPathBuiltWaitingToMove;

						InvalidateMoveGoal( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link, m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx );

						ClearReservedCover();

						//PushState('WanderAround');

						// make cover invalid
					}			
					//Sleep(0.1);
				} // if( ReserveCover(m_AttackUsingCoverGoalInfo.m_CurrentCoverToUse) )
				else // can not reserve the cover so make invalid and try again
				{

					;

					//`log(" ChadAI - Pawn " @ Pawn @ " MultiTierAttackUsingCoverGoalLoop:: Not able to Reserved Cover Node: " @ m_MultiTierEngagementInfo.m_CurrentCoverToUseForMTE.Link @ " slot: " @ m_MultiTierEngagementInfo.m_CurrentCoverToUseForMTE.SlotIdx @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					InvalidateMoveGoal( m_MultiTierEngagementInfo.m_CurrentCoverToUseForMTE.Link, m_MultiTierEngagementInfo.m_CurrentCoverToUseForMTE.SlotIdx );
					// make cover invalid
				}

			}// end if( m_MultiTierEngagementInfo.m_CurrentCoverToUseForMTE.Link != None )
			else
			{
				//`warn(" ChadAI - Pawn " @ Pawn @ " MultiTierAttackUsingCoverGoalLoop Not albe to get to any place to attack my enemy so going to freak out and make the game look bad -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			
				m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing = false;

				;

				m_WanderInfo.m_bAllowAttackWhileWaitingForPathToClear = true;

				if( m_WanderInfo.m_bAllowIdleWander )
				{
					;

					//`log(" ChadAI - Pawn " @ Pawn @ " MultiTierAttackUsingCoverGoalLoop:: No Cover to go to and allowed to wander so start wandering-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					PushState('WanderAround');
				}
				else
				{
					//`log(" ChadAI - Pawn " @ Pawn @ " MultiTierAttackUsingCoverGoalLoop:: No Cover to go to and NOT allowed to wander so start StandWaitingForPathToClear -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					;

					PushState('StandWaitingForPathToClear');
				}

				//`log(" ChadAI - Pawn: " @ Pawn @ "MultiTierAttackUsingCoverGoal: back from wander after failed MTE Travel To Cover Slot check to see if saw enemy -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				
				if( m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing )
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ "MultiTierAttackUsingCoverGoal: back from wander after failed MTE Travel and saw enemy with good LOS so lets kill this guy -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					PushState('Open_Field_Attack');

					//`log(" ChadAI - Pawn: " @ Pawn @ "MultiTierAttackUsingCoverGoal: back from Attack after wander and failed MTE Travel -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				}

				//AccomplishedGoal();
				////`log(" ChadAI - TPSoldierAIController::MultiTierAttackUsingCoverGoal::Begin No Cover Found to Go to so Ending Goal GotoState('Idle') -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				//PopState();

			}
	
		}// end else for ShouldIUseTurret()

	} // end if ( Enemy != None)
	else
	{ 
		;
	}
	Sleep(0.0);	
	
	Goto('MultiTierAttackUsingCoverGoalLoop');


AttackFromCoverSubState:

	m_CoverFightData.m_CurrentlyCoverToUseAsFightPos = m_MultiTierEngagementInfo.m_CurrentCoverToUseForMTE;

	m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_DoneMovingAtCover;

	m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_CurrentlyUsing;

	PushState('UseFightingPosition');

	m_CoverFightData.m_CurrentlyCoverToUseAsFightPos = m_MultiTierEngagementInfo.m_CurrentCoverToUseForMTE;

	//`log(" ChadAI - Pawn " @ Pawn @ " MultiTierAttackUsingCoverGoalLoop Back from Use Fighting Position Status: " @ m_CoverFightData.m_UseFightingPositionStatus  @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_None;

	if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_SucceededBecauseTimePassed )
	{
		Goto('MultiTierAttackUsingCoverGoalLoop');
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_FailedBecauseForgotIt )
	{
		Goto('MultiTierAttackUsingCoverGoalLoop');
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_PausedGrenadeOut )
	{
		Goto('MultiTierAttackUsingCoverGoalLoop');
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_FailedAngleToEnemy )
	{
		Goto('MultiTierAttackUsingCoverGoalLoop');	
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_FailedNoLineOfFireToEnemy )
	{
		Goto('MultiTierAttackUsingCoverGoalLoop');	
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_FailedDistanceToEnemy )
	{
		Goto('MultiTierAttackUsingCoverGoalLoop');	
	}
	else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_PausedEnemyIsAtCQB_Dist )
	{
		//`log(" ChadAI - Pawn " @ Pawn @ " AttackUsingCoverGoal::Begin Back From Use Fighting Pos and status == UseFightingPosition_PausedEnemyIsAtCQB_Dist PushState('CloseQuartersBattleAttack') -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		PushState('CloseQuartersBattleAttack');
		Goto('MultiTierAttackUsingCoverGoalLoop');
	}
	else
	{
		;	
		//`log(" ChadAI - Free_Attack_Goal Back from Use Fighing Position and Failed for an Unknown Reason  m_CoverFightData.m_UseFightingPositionStatus: " @ m_CoverFightData.m_UseFightingPositionStatus @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		Goto('MultiTierAttackUsingCoverGoalLoop');	
	}

EndMTE_Attack:

	m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link = None;
	m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.SlotIdx = -1;

	AccomplishedGoal();

	//`log(" ChadAI - MultiTierAttackUsingCoverGoalLoop Goal Has Been Accomplished  EvaluateSituation *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	;
	
	EvaluateSituation();

}


//-----------------------------------------------------------------------
// State:		AttackAsTerminatorGoal
// Description:
//-----------------------------------------------------------------------
state AttackAsTerminatorGoal
{

	function BeginState(Name PreviousStateName)
	{
		//`log(" ChadAI - TPSoldierAIController::AttackAsTerminatorGoal::BeginState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
		;

		m_HighLevelAiGoal = HighLevelAiGoal_AttackAsTerminatorGoal;

	}
	
	event PausedState()
	{
		//`log(" ChadAI - TPSoldierAIController::AttackAsTerminatorGoal::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		;

	}

	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
	
		//`log(" ChadAI - SENSING - " @ self @ "AttackAsTerminatorGoal::OnSeeEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
	
		// evaluate against our current one if new
// 		if (bNewEnemy)
// 		{
// 			//`log(" ChadAI - SENSING - " @ self @ "AttackAsTerminatorGoal::OnSeeEnemy - bNewEnemy so AcquireEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
// 		
// 			`AILOG(3, 'Sensory', "- AttackAsTerminatorGoal::OnSeeEnemy AcquiredEnemy: " @  m_playerList[playerIdx].Player.GetPawnName(true) );
// 			AcquireEnemy(playerIdx);
// 		}
		CheckForEnemy(false);

		;

	}
	
	
	// is only called when the heared player in a new enemy
	event OnHearEnemy(int playerIdx)
	{
		//`log(" ChadAI - SENSING - " @ self @ "AttackAsTerminatorGoal::OnHearEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		//`log(" ChadAI - SENSING - " @ self @ "AttackAsTerminatorGoal::OnHearEnemy - bNewEnemy so AcquireEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		//`AILOG(0, 'Sensory', "- AttackAsTerminatorGoal::OnHearEnemy AcquiredEnemy: " @  m_playerList[playerIdx].Player.GetPawnName(true) );
		//AcquireEnemy(playerIdx);
		CheckForEnemy(false);

		;
	}

	event ContinuedState()
	{
		;

		m_HighLevelAiGoal = HighLevelAiGoal_AttackAsTerminatorGoal;
	}
	
	function EndState(Name NextStateName)
	{
		;
		m_HighLevelAiGoal = HighLevelAiGoal_NONE;

		//`log(" ChadAI - TPSoldierAIController::AttackAsTerminatorGoal::EndState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}

	event PoppedState()
	{
		;

		m_HighLevelAiGoal = HighLevelAiGoal_NONE;
	}
	
	function bool HasGoalBeenAccomplished()
	{
		if( m_TerminatorInfo.m_ActualTimeToTerminate > 0.0f )
		{
			if( WorldInfo.TimeSeconds - m_TerminatorInfo.m_TimeStartedTerminating > m_TerminatorInfo.m_ActualTimeToTerminate )
			{
				//`log(" ChadAI - AttackAsTerminatorGoal::HasGoalBeenAccomplished yes enough time has passed -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
				return true;
			}
		}
		return false;
	}


	event Tick( float DeltaTime )
 	{
 		//`log(" ChadAI - TPSoldierAIController::AttackAsTerminatorGoal::Tick m_AttackUsingCoverGoalInfo.m_AmountOfTimeToInCoverGroup: " @ m_AttackUsingCoverGoalInfo.m_AmountOfTimeInCoverGroup @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
 
		UpdateAimInTheOpen(FALSE);;
		UpdateHeadtracking();
		Super.Tick(DeltaTime);
 	}

	
	function CoverInfo FindBestTerminatorCover()
	{		
		local CoverInfo bestNode,currentTestInfo;
		local int slotNo;
		local TPCoverNode curNode;
		local vector slotLoc;
			
// 		local float shortestDistFromEnemy;
// 		local float distFromEnemy;
		
		local float distanceToCover;
		local float rating, bestRating;

		local float idealDistenceFactor;
		local float weightLine;
		
// 		shortestDistFromEnemy = 900000.0f;
// 		distFromEnemy = 0.0f;
// 		
// 		shortestDistFromMe = 900000.0f;
// 		distFromMe = 0.0f;

		rating = 0.0f;
		bestRating = 0.0f;
				
		//find node closest to the enemy
		
		//then make a list of nodes close to me
		
		// CanFireAt

		if( m_TerminatorInfo.m_CurrentThingToKill != None && Pawn != None )
		{
			//foreach WorldInfo.RadiusNavigationPoints(class'TPCoverNode', nav, anchorLoc, dist)		
			foreach WorldInfo.AllNavigationPoints(class'TPCoverNode', curNode)
			{
				//`log(" ChadAI - " @ Pawn @ " Evaluating Terminator Cover Node: " @ curNode @ " Loc: " @ curNode.Location @ " --------------------------------------------------------------------------------------------" );
				
				if( curNode.bEnabled )
				{
					for( slotNo = 0; slotNo < curNode.Slots.Length; slotNo++ )
					{
						//`log(" ChadAI - " @ Pawn @ " Evaluating Terminator Cover Node: " @ curNode @ " Slot : " @ slotNo @ " Loc: " @ curNode.GetSlotLocation(slotNo) @ " Type: " @ curNode.Slots[slotNo].CoverType @ " --------------------------------------------------------------------------------------------" );

						// make sure slot is open field standing or can not use
						if( curNode.Slots[slotNo].CoverType == CT_OpenFieldStanding )
						{

							//`log(" ChadAI - " @ Pawn @ " Evaluating Terminator Cover Node: " @ curNode @ " Slot : " @ slotNo @ " is CT_OpenFieldStanding so Old Boy Can Use It --------------------------------------------------------------------------------------------" );


							// make sure not on InvalidateMoveGoal list
							if( !IsInvalidatedMoveGoal(slotNo, curNode) )
							{

								slotLoc = curNode.GetSlotLocation(slotNo);

								currentTestInfo.Link = curNode;
								currentTestInfo.SlotIdx = slotNo;
													
								// make sure slot it not off or disabled
								if( curNode.Slots[slotNo].bEnabled )
								{
									if( currentTestInfo.Link.Slots[slotNo].SlotOwner == None )
									{
										//`log(" ChadAI - " @ Pawn @ " Evaluating c Cover Node Slot : " @ slotNo @ " has not Slot Owner --------------------------------------------------------------------------------------------" );	

										if(IsAngleToEnemyValidForThisCoverSlot( currentTestInfo ) )
										{
											//`log(" ChadAI - Find best cover for Terminator - "@Pawn @ " Can concider because of angle to enemy is valid for this slot Node: " @ currentTestInfo.Link @ " slot: " @currentTestInfo.SlotIdx @"-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");

											if( !IsSomeJerkBlockingYourCover( currentTestInfo.Link.GetSlotLocation(slotNo) ) )
											{
												//`log(" ChadAI - " @ Pawn @ " Evaluating Cover Terminator Node Slot : " @ slotNo @ " IS Potential Cover Because Not Blocked--------------------------------------------------------------------------------------------" );	

												idealDistenceFactor = GetCurrentTargetsIdealRangeFactorFromThisPoint(slotLoc);

												//`log(" ChadAI - " @ Pawn @ " Evaluating Cover Terminator Node Slot : " @ slotNo @ " idealDistenceFactor: " @ idealDistenceFactor @ " --------------------------------------------------------------------------------------------" );	


												weightLine = GetCoversLineToAttackLocFactor(currentTestInfo, m_TerminatorInfo.m_CurrentThingToKill);
												//`log(" ChadAI - " @ Pawn @ " Evaluating Cover Terminator Node Slot : " @ slotNo @ " weightLine: " @ weightLine @ " --------------------------------------------------------------------------------------------" );	

	// 											// adjust weight for the difference in the rotation of the cover vs the direction to the enemy
	// 											weightDir = GetCoversDirectionToLineFoAttackFactor(inNode, TargetOfAttack);
												//`log(" ChadAI - RateCoverSlotForAttack GetCoversDirectionToLineFoAttackFactor: " @ weightDir @ " --------------------------------------------------------------------------------------------" );

												//weight = weightLine + weightDir;

												distanceToCover = VSize(slotLoc - Pawn.Location);
												
												//`log(" ChadAI - " @ Pawn @ " Evaluating Cover Terminator Node Slot : " @ slotNo @ " distanceToCover: " @ distanceToCover @ " --------------------------------------------------------------------------------------------" );	

												//rating = (weight * 1) * Abs((DistanceToTarget - distanceToCover));

												rating = weightLine * (idealDistenceFactor * distanceToCover);
												
												//`log(" ChadAI - " @ Pawn @ " Evaluating Cover Terminator Node Slot : " @ slotNo @ " rating: " @ rating @ " --------------------------------------------------------------------------------------------" );	

												
												;

												if (rating > bestRating)
												{
													bestNode = currentTestInfo;
													bestRating = rating;
													
													//`log(" ChadAI - " @ Pawn @ " Evaluating Cover Node Slot : " @ slotNo @ " has best rating: " @ bestRating @ " --------------------------------------------------------------------------------------------" );	

												} // end if (rating > bestRating)

											} // end !IsSomeJerkBlockingYourCover( curNode.GetSlotLocation(slotNo) 
											else
											{
												//`log(" ChadAI - " @ Pawn @ " Evaluating Cover Node Slot : " @ slotNo @ " Is NOT Potential Cover Because Blocked--------------------------------------------------------------------------------------------" );	
											}// end else !IsSomeJerkBlockingYourCover( curNode.GetSlotLocation(slotNo) 

										}// end if(!IsAngleToEnemyValidForThisCoverSlot( CoverToSnapTo ) 
										else
										{
											//`log(" ChadAI - " @ Pawn @ " Evaluating Cover Node Slot : " @ slotNo @ " Is NOT valid for current enemy Cover Node: " @ currentTestInfo.Link @ " slot: " @ currentTestInfo.SlotIdx @"--------------------------------------------------------------------------------------------" );	

										} // end else if(!IsAngleToEnemyValidForThisCoverSlot( CoverToSnapTo ) 

									} // end if( curNode.Slots[slotNo].SlotOwner == None )
									else
									{
										//`log(" ChadAI - " @ Pawn @ " Evaluating Cover Node Slot : " @ slotNo @ " Is Occupied Allready--------------------------------------------------------------------------------------------" );	
									}// end else if( curNode.Slots[slotNo].SlotOwner == None )

									
								} // end if( curNode.Slots[slotNo].bEnabled )
							} // end if( !IsInvalidatedMoveGoal(slotNo, currEvanNodeInfo.Link) )
							else
							{
								//`log(" ChadAI - " @ Pawn @ " IsInvalidatedMoveGoalr Node Slot : " @ slotNo @ " is not enabled --------------------------------------------------------------------------------------------" );	
								;	
							}
						}// end if( curNode.Slots[slotNo].CoverType == CT_OpenFieldStanding )
						else
						{
							//`log(" ChadAI - " @ Pawn @ " Evaluating Terminator Cover Node: " @ curNode @ " Slot : " @ slotNo @ " is NOT CT_OpenFieldStanding so Old Boy Can NOT Use It --------------------------------------------------------------------------------------------" );

						}
							
					} // end for( slotNo = 0; slotNo < curNode.Slots.Length; slotNo++ )		
					
				} // end if( curNode.bEnabled )
			}

		} // end if( Enemy != None && Pawn != None )
								
		return bestNode;
	
	}

	// if allowed to use current enemy use that if not, attack assigned enemy, and if not either pound sand
	function DetermineTerminatorTarget()
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackAsTerminatorGoal::DetermineTerminatorTarget m_UseAgainstCurrentEnemy: " @ m_TerminatorInfo.m_UseAgainstCurrentEnemy @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		CheckForEnemy(false);

		if( m_TerminatorInfo.m_UseAgainstCurrentEnemy )
		{
			
			//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackAsTerminatorGoal::DetermineTerminatorTarget Can be current enemy: " @ Enemy @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			
			if( Enemy != None )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackAsTerminatorGoal::DetermineTerminatorTarget Can be current enemy and I have one so let kill him : " @ Enemy @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				m_TerminatorInfo.m_CurrentThingToKill = Enemy;
			}
			else if( m_TerminatorInfo.m_AssignedThingToKill != None )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackAsTerminatorGoal::DetermineTerminatorTarget Can be current enemy and I do not have one but I have an assigned enemy so let try and kill him -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				
				m_TerminatorInfo.m_CurrentThingToKill = m_TerminatorInfo.m_AssignedThingToKill;
			}
			else
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackAsTerminatorGoal::DetermineTerminatorTarget Can be current enemy and I do not have one and I do not have an assigned enemy so let cry, SAD NAZI -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				
				m_TerminatorInfo.m_CurrentThingToKill = None;
			}
		}
		else
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackAsTerminatorGoal::DetermineTerminatorTarget Can NOT be current enemy so go after assigned target: " @ m_TerminatorInfo.m_AssignedThingToKill @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			m_TerminatorInfo.m_CurrentThingToKill = m_TerminatorInfo.m_AssignedThingToKill;


		}
	}

	// validty of the ideal range should have allready been checked
	function float GetCurrentTargetsIdealRangeFactorFromThisPoint( Vector TestLoc )
	{
		local float factorValue;
		local float distBetweenTestAndTarget;
		local float distFromIdeal;
		local float rangeOfDomain;

		factorValue = -1.0f;

		//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackAsTerminatorGoal::GetCurrentTargetsIdealRangeFactorFromThisPoint Urahh " @ m_TerminatorInfo.m_CurrentThingToKill @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


		if( m_TerminatorInfo.m_CurrentThingToKill != None )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackAsTerminatorGoal::GetCurrentTargetsIdealRangeFactorFromThisPoint TestLoc " @ TestLoc @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackAsTerminatorGoal::GetCurrentTargetsIdealRangeFactorFromThisPoint Urahh.Loc " @ m_TerminatorInfo.m_CurrentThingToKill.Location @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			// get range to target from test loc
			distBetweenTestAndTarget = VSize( TestLoc - m_TerminatorInfo.m_CurrentThingToKill.Location );

			//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackAsTerminatorGoal::GetCurrentTargetsIdealRangeFactorFromThisPoint distBetweenTestAndTarget " @ distBetweenTestAndTarget @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackAsTerminatorGoal::GetCurrentTargetsIdealRangeFactorFromThisPoint m_MaxDistanceToBeFromEnemy " @ m_TerminatorInfo.m_MaxDistanceToBeFromEnemy @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackAsTerminatorGoal::GetCurrentTargetsIdealRangeFactorFromThisPoint m_MinDistanceToBeFromEnemy " @ m_TerminatorInfo.m_MinDistanceToBeFromEnemy @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackAsTerminatorGoal::GetCurrentTargetsIdealRangeFactorFromThisPoint m_IdealDistanceToBeFromEnemy " @ m_TerminatorInfo.m_IdealDistanceToBeFromEnemy @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


			// make sure range is not outside max range

			if( distBetweenTestAndTarget < m_TerminatorInfo.m_MaxDistanceToBeFromEnemy )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackAsTerminatorGoal::GetCurrentTargetsIdealRangeFactorFromThisPoint distBetweenTestAndTarget is less then max range-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				if( distBetweenTestAndTarget > m_TerminatorInfo.m_MinDistanceToBeFromEnemy )
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackAsTerminatorGoal::GetCurrentTargetsIdealRangeFactorFromThisPoint distBetweenTestAndTarget is More then min range-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					// see if it is more or less then ideal and then linerly interpolate from there.

					if( distBetweenTestAndTarget < m_TerminatorInfo.m_IdealDistanceToBeFromEnemy )
					{
						distFromIdeal = m_TerminatorInfo.m_IdealDistanceToBeFromEnemy - distBetweenTestAndTarget;
						rangeOfDomain = m_TerminatorInfo.m_IdealDistanceToBeFromEnemy - m_TerminatorInfo.m_MinDistanceToBeFromEnemy;

						factorValue = distFromIdeal / rangeOfDomain;
						//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackAsTerminatorGoal::GetCurrentTargetsIdealRangeFactorFromThisPoint distBetweenTestAndTarget < m_TerminatorInfo.m_IdealDistanceToBeFromEnemy-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


					}
					else
					{
						distFromIdeal = distBetweenTestAndTarget - m_TerminatorInfo.m_IdealDistanceToBeFromEnemy;
						rangeOfDomain = m_TerminatorInfo.m_MaxDistanceToBeFromEnemy - m_TerminatorInfo.m_IdealDistanceToBeFromEnemy;

						factorValue = distFromIdeal / rangeOfDomain;
						//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackAsTerminatorGoal::GetCurrentTargetsIdealRangeFactorFromThisPoint distBetweenTestAndTarget >= m_TerminatorInfo.m_IdealDistanceToBeFromEnemy-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					}

					//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackAsTerminatorGoal::GetCurrentTargetsIdealRangeFactorFromThisPoint distFromIdeal " @ distFromIdeal @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackAsTerminatorGoal::GetCurrentTargetsIdealRangeFactorFromThisPoint rangeOfDomain " @ rangeOfDomain @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackAsTerminatorGoal::GetCurrentTargetsIdealRangeFactorFromThisPoint factorValue " @ factorValue @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


				}
				else
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackAsTerminatorGoal::GetCurrentTargetsIdealRangeFactorFromThisPoint distBetweenTestAndTarget is less then min range-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					factorValue = -1.0f;
				}

			}
			else
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::AttackAsTerminatorGoal::GetCurrentTargetsIdealRangeFactorFromThisPoint distBetweenTestAndTarget is greater then max range-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				factorValue = -1.0f;
			}

		}

		return factorValue;
	}	

Begin:

	m_SubStateDebugInfoTag="Begin";

	//`log(" ChadAI - - TPSoldierAIController::AttackAsTerminatorGoal::Begin -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	m_HighLevelAiGoal = HighLevelAiGoal_AttackAsTerminatorGoal;

	if( TPPawn(Pawn) != None )
	{
		TPPawn(Pawn).FaceEnemyDist = 4000.0;
		TPPawn(Pawn).BeginFacingEnemyDist = 3900.0;
	}

	m_TerminatorInfo.m_bContinueToTerminate = true;

	m_TerminatorInfo.m_TimeStartedTerminating = WorldInfo.TimeSeconds;

	// Get Starting Target, if allowed to use current enemy use that if not, attack assigned enemy, and if not either pound sand (wander for now).

	DetermineTerminatorTarget();

	// if range to taget is with in ideal range and los open up

	if( m_TerminatorInfo.m_CurrentThingToKill != None && Pawn != None )
	{
		if( GetCurrentTargetsIdealRangeFactorFromThisPoint(Pawn.Location) > 0.01 )
		{
			//`log(" ChadAI - TPSoldierAIController::AttackAsTerminatorGoal::Begin Started in range of target so start killing -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			PushState('Attack_Stand_Terminator');
		}
		else
		{
			//`log(" ChadAI - TPSoldierAIController::AttackAsTerminatorGoal::Begin Did Not Start in range of target so CAN NOT start Killing -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		}
	}


AttackAsTerminatorGoalLoop:
// 	
	//`log(" ChadAI - Pawn " @ Pawn @ " AttackAsTerminatorGoalLoop::-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	Enemy = m_TerminatorInfo.m_CurrentThingToKill;
	m_enemyIdx = GetPlayerIdx(Enemy.Controller);

	if( HasGoalBeenAccomplished() )
	{
		//`log(" ChadAI - Pawn " @ Pawn @ " AttackAsTerminatorGoalLoop- Goal Has Been Accomplished::-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		m_TerminatorInfo.m_bContinueToTerminate = false;
		Goto('AccomplishedGoal');
	}
	else
	{
		DetermineTerminatorTarget();

		// pick new location to move to
// 		m_TerminatorInfo.m_CurrentCoverToTerminateFrom = FindBestTerminatorCover();
// 
// 	
// 		// need to get the loc of a cover slot to move to
// 					
// 		`AILOG(1, 'AttackAsTerminatorGoal', "FindBestTerminatorCover return node: " @ m_TerminatorInfo.m_CurrentCoverToTerminateFrom.Link @ " slot: " @ m_TerminatorInfo.m_CurrentCoverToTerminateFrom.SlotIdx @ "--------------------------------------------------------------------------------------------" );
// 
// 
// 		// special checks to see if find cover found nothing
// 
// 		if( m_TerminatorInfo.m_CurrentCoverToTerminateFrom.Link != None )
// 		{
// 	
// 			//`log(" ChadAI - Pawn: " @ Pawn @ " AttackAsTerminatorGoalLoop FindBestTerminatorCover found cover and now going to it -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
// 
// 			if( ReserveCover(m_TerminatorInfo.m_CurrentCoverToTerminateFrom) )
// 			{
// 				//`log(" ChadAI - AttackAsTerminatorGoalLoop Was able to reserve Cover Node:" @ m_TerminatorInfo.m_CurrentCoverToTerminateFrom.Link @ " Slot: " @ m_TerminatorInfo.m_CurrentCoverToTerminateFrom.SlotIdx @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 									
// 				m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_BuildingPath;
// 
// 				KynapseGoToFindPath( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link.GetSlotLocation( m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx ) );
// 
// 				if ( KynapseFoundPath() )
// 				{
// 					//`log(" ChadAI - Pawn " @ Pawn @ " AttackAsTerminatorGoalLoop Has Cover Path Found Now Travel There -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 
// 					m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_PathBuiltWaitingToMove;
// 
// 					m_CoverMoveData.m_HasPathToCoverBeenBuilt = true;
// 
// 					PushState('TravelToCoverWhileTerimating');
// 
// 					//`log(" ChadAI - Pawn " @ Pawn @ " AttackAsTerminatorGoalLoop Back From TravelToCoverWhileTerimating status: " @ m_CoverMoveData.m_Move2CoverStatus @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 
// 					if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_DoneMovingAtCover )
// 					{
// 						//`log(" ChadAI - Pawn " @ Pawn @ " AttackAsTerminatorGoalLoop Back From TravelToCoverWhileTerimating and status == Move2CovStat_DoneMovingAtCover Goto('AttackFromCoverSubState') -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 					
// 						Goto('TerminateFromHereSubState');
// 
// 					}
// 					else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedBlockedByPawn )
// 					{
// 						//`log(" ChadAI - Pawn " @ Pawn @ " AttackAsTerminatorGoalLoop Back From TravelToCoverWhileTerimating and status == Move2CovStat_FailedBlockedByPawn make cover invalid for small time -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 						m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_None;
// 
// 					}
// 					else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedBlockedByActor )
// 					{
// 						//`log(" ChadAI - Pawn " @ Pawn @ " AttackAsTerminatorGoalLoop Back From TravelToCoverWhileTerimating and status == Move2CovStat_FailedBlockedByActor make cover invalid for small time -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 						m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_None;
// 					}
// 					else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedEnemyMadeCoverInvalid )
// 					{
// 						`AILOG(2, 'AttackAsTerminatorGoal', "My Travel to Node: " @ m_TerminatorInfo.m_CurrentCoverToTerminateFrom.Link @ " slot: " @ m_TerminatorInfo.m_CurrentCoverToTerminateFrom.SlotIdx @ " was interputed because my current enemy made the cover invalid So Invalidate and try again");
// 
// 						InvalidateMoveGoal( m_TerminatorInfo.m_CurrentCoverToTerminateFrom.Link, m_TerminatorInfo.m_CurrentCoverToTerminateFrom.SlotIdx );
// 
// 						ClearReservedCover();
// 
// 						Goto('AttackAsTerminatorGoalLoop');
// 					}
// 
// 				} // end if ( KynapseFoundPath() )
// 				else
// 				{
// 					//`log(" ChadAI - Pawn " @ Pawn @ "AttackAsTerminatorGoalLoop Does Not Have Cover Path Make Cover Invalid and find another cover to try -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 
// 					// no path
// 					m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_NoPathBuiltWaitingToMove;
// 
// 					InvalidateMoveGoal( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link, m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx );
// 
// 					ClearReservedCover();
// 				}			
// 				//Sleep(0.1);
// 			} // if( ReserveCover(m_TerminatorInfo.m_CurrentCoverToTerminateFrom) )
// 			else // can not reserve the cover so make invalid and try again
// 			{
// 
// 				`AILOG(1, 'AttackAsTerminatorGoal', "Was not able to Reserve Node: " @ m_TerminatorInfo.m_CurrentCoverToTerminateFrom.Link @ 
// 								" slot: " @ m_TerminatorInfo.m_CurrentCoverToTerminateFrom.SlotIdx @ " So Invalidate and try another cover, Slot Currently Reserved by: " @
// 								m_TerminatorInfo.m_CurrentCoverToTerminateFrom.Link.Slots[m_TerminatorInfo.m_CurrentCoverToTerminateFrom.SlotIdx].SlotOwner);
// 
// 
// 				//`log(" ChadAI - Pawn " @ Pawn @ " AttackAsTerminatorGoalLoop:: Not able to Reserved Cover Node: " @ m_TerminatorInfo.m_CurrentCoverToTerminateFrom.Link @ " slot: " @ m_TerminatorInfo.m_CurrentCoverToTerminateFrom.SlotIdx @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 				InvalidateMoveGoal( m_TerminatorInfo.m_CurrentCoverToTerminateFrom.Link,m_TerminatorInfo.m_CurrentCoverToTerminateFrom.SlotIdx );
// 				// make cover invalid
// 			}
// 
// 		}// end if( m_TerminatorInfo.m_CurrentCoverToTerminateFrom.Link != None )
// 		else
		//{
			//`log(" ChadAI - Pawn: " @ Pawn @ "TPSoldierAIController::AttackAsTerminatorGoal:: Failed to find a cover slot to move to so will see if can kill from here -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			;

			// If I can fire from here go for it

			if( CanFireAtNotFromCover( m_TerminatorInfo.m_CurrentThingToKill, true ) )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ "TPSoldierAIController::AttackAsTerminatorGoal:: Can kill from here so will -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				;
				Goto('TerminateFromHereSubState');
			}
			else
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ "TPSoldierAIController::AttackAsTerminatorGoal:: No line of fire from here so pursue -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				;

				Goto('TerminateWhilePursuingSubState');
			}
		//}
	} // end else if( HasGoalBeenAccomplished() )
	
	Goto('AttackAsTerminatorGoalLoop');

TerminateFromHereSubState:

	PushState('Attack_Stand_Terminator');
	Goto('AttackAsTerminatorGoalLoop');

TerminateWhilePursuingSubState:

	PushState('TerminatorPursueEnemy');
	Goto('AttackAsTerminatorGoalLoop');


AccomplishedGoal:

	//`log(" ChadAI - TPSoldierAIController::AttackAsTerminatorGoal::AccomplishedGoal() -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	m_CoverFightData.m_bUsingFightingPosition = false;

	ClearLatentAction(class'SeqAct_AIBeTerminator',false);

	Sleep(0.0);

	EvaluateSituation();

}


state Attack_Stand_Terminator
{

	function NotifyWeaponFired(Weapon W, byte FireMode)
	{
		// m_CQB_Data.m_NoOfRoundsShotBeforeCharge = m_CQB_Data.m_NoOfRoundsShotBeforeCharge + 1;
	}

	
	function BeginState(Name PreviousStateName)
	{
		SetAimAndHeadTrack();
	
	}
	
	function EndState (Name NextStateName)
	{
		Target = None; 
		StopFiring();
		
		// don't crouch when player is too close fix. DK
		bForcedStand = false;
		
		m_bPauseFire = false;

	}


	event PausedState()
	{
		m_bPauseFire = false;

	}

	event ContinuedState()
	{

	}

	function SetPauseTimer()
	{
		//make this designer-configable
		//SetTimer(RandRange(0.2, 0.5), false,'BurstTimer');
	}

	event Tick( float DeltaTime )
	{

		//`log(" ChadAI - TPSoldierAIController::Attack_Stand_Terminator::Tick m_NoOfRoundsShotBeforeCharge: " @  TPPawn(Pawn).m_NoOfRoundsShotBeforeCharge @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		UpdateAimInTheOpen(FALSE);;
		UpdateHeadtracking();
		Super.Tick(DeltaTime);
	}
begin:

	m_SubStateDebugInfoTag="Begin";
	
	//`log(" ChadAI - Attack_Stand_Terminator::begin: ");

	Enemy = m_TerminatorInfo.m_CurrentThingToKill;

	m_enemyIdx = GetPlayerIdx(Enemy.Controller);

	SetAimAndHeadTrack();


	m_TerminatorInfo.m_ActualTimeToStandAndShoot = RandRange(m_TerminatorInfo.m_MinTimeToStandAndShoot, m_TerminatorInfo.m_MaxTimeToStandAndShoot);
	m_TerminatorInfo.m_TimeStartedStandingAndShootingThisTurn = WorldInfo.TimeSeconds;

	//`log(" ChadAI - Attack_Stand_Terminator::begin: m_ActualTimeToStandAndShoot: " @ m_TerminatorInfo.m_ActualTimeToStandAndShoot @ " ++++++++ ");

	while( ( WorldInfo.TimeSeconds - m_TerminatorInfo.m_TimeStartedStandingAndShootingThisTurn ) < m_TerminatorInfo.m_ActualTimeToStandAndShoot )
	{
		Pawn.Velocity = vect(0,0,0);
		//`log(" ChadAI - Attack_Stand_Terminator::Top Of Loop m_TimeStartedStandingAndShootingThisTurn: " @ m_TerminatorInfo.m_TimeStartedStandingAndShootingThisTurn @ " ++++++++ ");
		//`log(" ChadAI - Attack_Stand_Terminator::Top Of Loop Current Time: " @ WorldInfo.TimeSeconds @ " ++++++++ ");
		//`log(" ChadAI - Attack_Stand_Terminator::Top Of Loop m_ActualTimeToStandAndShoot: " @ m_TerminatorInfo.m_ActualTimeToStandAndShoot @ " ++++++++ ");


		if( m_TerminatorInfo.m_CurrentThingToKill != None)
		{
			//`log(" ChadAI - Attack_Stand_Before_Charge::begin: HasValidEnemy() ");
		
			//Target = Enemy;
			Target = m_TerminatorInfo.m_CurrentThingToKill;

			Focus = Target;

			DesiredRotation = rotator(Focus.Location - Pawn.Location);
			DesiredRotation.Pitch = 0;
			
            if ( ShouldIFire() )
			{				
				//`AILOG(0, 'Begin', "start firing");
				
					TP_AiStartFiring();
				



			}
			else
			{
				StopFiring();
				PopState();
			}
		}		
		// CHAD make sure this sleep is needed
		sleep(0.0);
	}

	PopState();

}

state TerminatorPursueEnemy
{
	ignores NotifyBump;

	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " TerminatorPursueEnemy::NotifyTakeHit m_bTookHitWhilePursuing set to true -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		m_MultiTierEngagementInfo.m_bTookHitWhilePursuing = true;

		Super.NotifyTakeHit(InstigatedBy,HitLocation,Damage,damageType,Momentum);		
	}

    function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		// do nothing for now
		//`log(" ChadAI - Pawn: " @ Pawn @ " TerminatorPursueEnemy::NotifyWeaponFired-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		
    }

	event PoppedState()
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " PursueEnemy::PoppedState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;
		Pawn.Velocity = vect(0,0,0);
		KynapseClear();
	}

	event PushedState()
	{
		;
	}

	event PausedState()
	{
		;
		//`log(" ChadAI - Pawn: " @ Pawn @ " PursueEnemy::PausedState and m_bInteruptedWhileLookingForPath -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		m_MultiTierEngagementInfo.m_bInteruptedWhileLookingForPath = true;
	}

	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " TerminatorPursueEnemy::OnSeeEnemy -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		CheckForEnemy(false);

		if (!HasValidEnemy())
		{
			;
			KynapseClear();
			//PopState();
		}
		else if (EnemyRecentlyVisible(true) && !m_Engagement_Tac_Data.m_bSideSteping)
		{
			m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForEngagement(	Enemy,
																						Vector(Pawn.Rotation), 
																						m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																						false );

			if( m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel )
			{
				;
				//`log(" ChadAI - Pawn: " @ Pawn @ " PursueEnemy::OnSeeEnemy enemy can be tactically enaged so end pursue for now move needed to Kill: " @ m_Engagement_Tac_Data.m_MoveNeed2Kill @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
				
				m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing = true;

				KynapseClear();
			}
			//PopState();
		}
	}

	// is only called when the heared player in a new enemy
	event OnHearEnemy(int playerIdx)
	{
		CheckForEnemy(false);
	}

	function EndState(Name NextStateName)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " TPAIController::TerminatorPursueEnemy::EndState  NextStateName: " @ NextStateName @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;
		Pawn.Velocity = vect(0,0,0);
		KynapseClear();
	}

	event ContinuedState()
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " TPAIController::TerminatorPursueEnemy::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;
	
	}

	event Tick( float DeltaTime )
	{
		UpdateAimInTheOpen(FALSE);;
		UpdateHeadtracking();
		Super.Tick(DeltaTime);
	}


Begin:

	m_SubStateDebugInfoTag="Begin";

	//`log(" ChadAI - Pawn: " @ Pawn @ " TerminatorPursueEnemy:KynapseGoToward moving to Enemy: " @ Enemy @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	
	m_CQB_Data.m_NoOfTimesWaitedForCheckForCQB = 0;
	m_MultiTierEngagementInfo.m_bTookHitWhilePursuing = false;
	m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing = false;

	//m_MultiTierEngagementInfo.m_LastEnemyTriedToPursue = Enemy;

	Enemy = m_TerminatorInfo.m_CurrentThingToKill;

	m_enemyIdx = GetPlayerIdx(Enemy.Controller);

	if( Enemy == None )
	{
		;
		Sleep(0.0);
		PopState();
	}


TerminatorPursueEnemyLoop:

	StopFiring();

	Enemy = m_TerminatorInfo.m_CurrentThingToKill;

	m_enemyIdx = GetPlayerIdx(Enemy.Controller);

	m_Engagement_Tac_Data.m_bSideSteping = false;

	if( Enemy == None )
	{
		;
		Sleep(0.0);
		PopState();
	}


	//`log(" ChadAI - Pawn: " @ Pawn @ " PursueEnemy:KynapseGoToward moving to Enemy: " @ Enemy @ "  TOP OF THE LOOP -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	if( m_MultiTierEngagementInfo.m_LastEnemyTriedToPursue == Enemy )
	{
		m_MultiTierEngagementInfo.m_NumTimesTriedToPursueSameEnemy = m_MultiTierEngagementInfo.m_NumTimesTriedToPursueSameEnemy + 1;
	}
	else
	{
		m_MultiTierEngagementInfo.m_LastEnemyTriedToPursue = Enemy;
		m_MultiTierEngagementInfo.m_NumTimesTriedToPursueSameEnemy = 1;
	}

	//************************** new hottness
	m_MultiTierEngagementInfo.m_bInteruptedWhileLookingForPath = false;
	KynapseGoTowardFindPath(Enemy.Controller, 250);

	if( m_MultiTierEngagementInfo.m_bInteruptedWhileLookingForPath )
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ "PursueEnemy:Main Loop m_bInteruptedWhileLookingForPath so look for path again -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;

	}
	else if ( KynapseFoundPath() )
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ "PursueEnemy: KynapseFoundPath so KynapseFollowPath-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;
		KynapseFollowPath(); // follow the found path 

		//`log(" ChadAI - Pawn: " @ Pawn @ "PursueEnemy: back from KynapseFollowPath Enemy: " @ Enemy @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


		if( Enemy == None )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " TerminatorPursueEnemy:back from KynapseFollowPath No More Enemy so need to end purse -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			;
			Sleep(0.0);
			PopState();
		}
 
		//`log(" ChadAI - Pawn: " @ Pawn @ "PursueEnemy: KynapseFollowPathcompletted so lets see of arrived m_NumTimesTriedToPursueSameEnemy: " @ m_MultiTierEngagementInfo.m_NumTimesTriedToPursueSameEnemy @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		if( m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ "TerminatorPursueEnemy: KynapseFollowPathcompletted and m_bSawEnemyWhilePursuing so see if should side step or go back to goal -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			// while if need to side step do that here

			if( m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel &&
				m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_None )
			{
				m_Engagement_Tac_Data.m_bSideSteping = true;

				;

				//`log(" ChadAI - Pawn: " @ Pawn @ " TerminatorPursueEnemy:back from KynapseFollowPath and need to side step -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				
				Goto('SideStep');
			}

			;

			//`log(" ChadAI - Pawn: " @ Pawn @ "TerminatorPursueEnemy: KynapseFollowPathcompletted and m_bSawEnemyWhilePursuing so see if should side step or go back to goal -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


			m_MultiTierEngagementInfo.m_bSawEnemyWhilePursuing = false;

			Sleep(0.0);
			PopState();

			// if still here need to purse again

			//`log(" ChadAI - Pawn: " @ Pawn @ "PursueEnemy: still here after EvaluateSituation so still needs to purse -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


		}
		else if ( KynapseHasArrived() )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ "PursueEnemy: KynapseFollowPathcompletted and KynapseHasArrived so EvaluateSituation -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			;
			Sleep(0.0);
			PopState();

			// if still here need to purse again

			//`log(" ChadAI - Pawn: " @ Pawn @ "PursueEnemy: still here after EvaluateSituation so still needs to purse -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		}
	}
	else
	{
		;
		Sleep(0.0);
	}

	//`log(" ChadAI - Pawn: " @ Pawn @ " TerminatorPursueEnemy; No More Enemy so poping state -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	Sleep(0.0);
	Goto('TerminatorPursueEnemyLoop');

	PopState();


SideStep:

	m_MultiTierEngagementInfo.m_NumTimesTriedToPursueSameEnemy = 0;

	//`log(" ChadAI - Pawn: " @ Pawn @ " TerminatorPursueEnemy;SideStep build path to side step -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	/* FIX_STEP: test the new KynapseCanGoStraight function
	//KynapseGoToFindPath( m_Engagement_Tac_Data.m_SideStepTargetMoveLoc );
	//if ( KynapseFoundPath() )
	*/
	if ( KynapseCanGoStraight( m_Engagement_Tac_Data.m_SideStepTargetMoveLoc ) )
	{
		m_SubStateDebugInfoTag="Slice The Pie";

		//`log(" ChadAI - Pawn: " @ Pawn @ " TerminatorPursueEnemy;SideStep found path to side step so start stepping -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;

		Target = m_TerminatorInfo.m_CurrentThingToKill;

		Focus = Target;

		DesiredRotation = rotator(Focus.Location - Pawn.Location);
		DesiredRotation.Pitch = 0;

		
			TP_AiStartFiring();
		


		//KynapseFollowPath(); // follow the found path

// 		while( Enemy != None && 
// 				m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel &&
// 				m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_None )
// 		{
		KynapseClear();
		MoveTo(m_Engagement_Tac_Data.m_SideStepTargetMoveLoc, m_TerminatorInfo.m_CurrentThingToKill);

		StopThisBot(); // MoveTo affects velocity & acceleration

		m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForEngagement(	Enemy,	
																					Vector(Pawn.Rotation), 
																					m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																					false);


		if( Enemy != None && 
			m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel &&
			m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_None )
		{
			Sleep(0.1);
			Goto('SideStep');
		}

		m_Engagement_Tac_Data.m_bSideSteping = false;
		//`log(" ChadAI - Pawn: " @ Pawn @ " TerminatorPursueEnemy;SideStep back from KynapseFollowPath let assume we made it and return to attack -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		Sleep(0.0);
		PopState();
	}

	InvalidateThisSliceThePieTacStepLocation(m_Engagement_Tac_Data.m_MoveNeed2Kill);

	m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForEngagement(	Enemy,	
																				Vector(Pawn.Rotation), 
																				m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																				false);


	if( Enemy != None && 
		m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel &&
		m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_None )
	{
		Sleep(0.0);
		Goto('SideStep');
	}

	m_Engagement_Tac_Data.m_bSideSteping = false;
	
	//`log(" ChadAI - Pawn: " @ Pawn @ " TerminatorPursueEnemy;SideStep did not find path to side step so back to loop -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	;

	Sleep(0.0);
	Goto('TerminatorPursueEnemyLoop');

}


native function FollowActorGoalEvaluateSituation();
//-----------------------------------------------------------------------
// State:		FollowActorGoal 
// Description: Wehrmach Specific Instantiations of state fns
//-----------------------------------------------------------------------
state FollowActorGoal
{

	function NotifyWeaponFired(Weapon W, byte FireMode)
	{
	}

// 	function FollowActorGoalEvaluateSituation()
// 	{
// 		//`log(" ChadAI - TPSoldierAICOntroller::FollowActorGoal::function EvaluateSituation() StartStateName: " @StartStateName@" -----------------------------------------------------------------------------------");
// 
// 		if (CheckForEnemy(false) || HasValidEnemy())
// 		// 1
// 		{
// 			if( DetermineIfGrenadeShouldBeAutoThrown() )
// 			{
// 				//`log(" ChadAI - Pawn " @ Pawn @ " TPSoldierAIController::EvaluateSituation  DetermineIfGrenadeShouldBeThrown");
// 				`AILOG(1, 'ThrowGrenade', "FollowActorGoal::EvaluateSituation  pushing UseGrenadeAgainstEnemy because DetermineIfGrenadeShouldBeThrown");
// 
// 				PushState('UseGrenadeAgainstEnemy');
// 			}
// 			else if( ShouldIAttackEnemy() )
// 			// 1.2
// 			{
// 						
// 				if (ShouldIPursueEnemy())
// 				// 1.2.1
// 				{
// 					//`AILOG(0, 'EvaluateSituation', "I SHOULD PURSUE");
// 					if ( !EnemyRecentlyVisible(true) || !CanFireAtNotFromCover(Enemy) )
// 					//1.2.1.1
// 					{
// 						//`log(" ChadAI - TPSoldierAICOntroller::FollowActorGoal::function EvaluateSituation() PushState(PursueEnemy) -----------------------------------------------------------------------------------");
// 						//PushState('PursueEnemy_While_Following');
// 						PushState('Attack_While_Following');
// 					}
// 					else if ( VSize(Pawn.Location-Enemy.Location)>=m_pursueMaxRange )
// 					// 1.2.1.2
// 					{
// 						//`log(" ChadAI - TPSoldierAICOntroller::FollowActorGoal::function EvaluateSituation() PushState(PursueEnemyRange) -----------------------------------------------------------------------------------");
// 						//PushState('PursueEnemyRange');
// 						PushState('Attack_While_Following');
// 					}
// 					else
// 					// 1.2.1.3
// 					{
// 						//`log(" ChadAI - TPSoldierAICOntroller::FollowActorGoal::function EvaluateSituation() PushState(Attack) -----------------------------------------------------------------------------------");					
// 						PushState('Attack_While_Following');
// 					}
// 						
// 				}
// 				else
// 				//1.2.2
// 				{
// 					//`log(" ChadAI - TPSoldierAICOntroller::FollowActorGoal::function EvaluateSituation() PushState(Attack) -----------------------------------------------------------------------------------");				
// 					PushState('Attack_While_Following');
// 				}
// 			}
// 			else
// 			// 1.3
// 			{
// 				//Ignore him
// 				//GotoState('Idle');
// 				//`log(" ChadAI - TPSoldierAICOntroller::FollowActorGoal::function EvaluateSituation() Ignore him -----------------------------------------------------------------------------------");
// 
// 			}
// 			
// 			
// 		}
// 		else
// 		// 2
// 		{
// 			//GotoState('Idle');
// 			//`log(" ChadAI - TPSoldierAICOntroller::FollowActorGoal::function EvaluateSituation() Do nothing -----------------------------------------------------------------------------------");
// 
// 		}
// 		
// 	}
}

//-----------------------------------------------------------------------
// State:		BeASniperGoal
// Description:
//-----------------------------------------------------------------------
state BeASniperGoal
{
	function BeginState(Name PreviousStateName)
	{
		;
		m_CoverFightData.m_bUsingFightingPosition = true;
		m_HighLevelAiGoal = HighLevelAiGoal_BeASniperGoal;

		//`log(" ChadAI - TPSoldierAIController::BeASniperGoal::BeginState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
	}
	
	event PausedState()
	{
		;

		m_SniperInfo.m_bCurrentlySniping = false;

		//`log(" ChadAI - TPSoldierAIController::BeASniperGoal::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	event ContinuedState()
	{
		;

		m_HighLevelAiGoal = HighLevelAiGoal_BeASniperGoal;

		m_SniperInfo.m_bCurrentlySniping = true;

		//`log(" ChadAI - TPSoldierAIController::BeASniperGoal::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}

	event PoppedState()
	{
		;

		m_HighLevelAiGoal = HighLevelAiGoal_NONE;

		m_SniperInfo.m_bCurrentlySniping = false;

		//`log(" ChadAI - TPSoldierAIController::BeASniperGoal::PoppedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}
	
	function EndState(Name NextStateName)
	{
		;

		m_HighLevelAiGoal = HighLevelAiGoal_NONE;

		//`log(" ChadAI - TPSoldierAIController::BeASniperGoal::EndState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		m_SniperInfo.m_bCurrentlySniping = false;	
	}
	
	function bool HasGoalBeenAccomplished()
	{
		return false;
	}
	
Begin:

	m_SubStateDebugInfoTag="Begin";

	//`log(" ChadAI - TPSoldierAIController::BeASniperGoal::Begin -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	m_HighLevelAiGoal = HighLevelAiGoal_BeASniperGoal;

	m_SniperInfo.m_bCurrentlySniping = true;

	m_SniperInfo.m_TimeStartedAsSniperInSeconds = WorldInfo.TimeSeconds;
	
	m_SniperInfo.m_PreviousAccuracy = BaseWeaponAccuracy;
	BaseWeaponAccuracy = m_SniperInfo.m_Accuracy;

	// check to see if at the loc of the snipers nest and if not move there

	m_SniperInfo.m_NoOfTimesPathHasBeenTried = 0;

TravelToSnipersNest:

	if ( m_SniperInfo.m_CoverToUseAsNest.Link != None)
	{
				
		if( ReserveCover( m_SniperInfo.m_CoverToUseAsNest ) )
		{
					
			if( !IsAtCover(m_CoverMoveData.m_ReservedGoToCover_Clamied, false ) )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " BeASniperGoal::Begin() Is not at cover so move there -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				;

				m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_BuildingPath;

				m_SniperInfo.m_NoOfTimesPathHasBeenTried++;

				KynapseGoToFindPath( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link.GetSlotLocation( m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx ) );

				if ( KynapseFoundPath() )
				{
					;

					//`log(" ChadAI - Pawn " @ Pawn @ " BeASniperGoal::Begin Has Cover Path Found Now Travel There -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_PathBuiltWaitingToMove;

					m_CoverMoveData.m_HasPathToCoverBeenBuilt = true;
					m_CoverMoveData.m_bCheckToSeeIfCoverIsStillValidDuringMoveToCover = false;

					PushState('TravelToCoverSlot');

					//`log(" ChadAI - Pawn " @ Pawn @ " BeASniperGoal::Begin Back From Travel To Cover Slot status: " @ m_CoverMoveData.m_Move2CoverStatus @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_DoneMovingAtCover )
					{
						;

						//`log(" ChadAI - Pawn " @ Pawn @ " BeASniperGoal::Begin Back From Travel To Cover Slot and status == Move2CovStat_DoneMovingAtCover Goto('DefendCoverSubState') -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					
						Goto('SnipeSubStateLoop');

					}
					else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedCQB_Needed )
					{
						//`log(" ChadAI - Pawn " @ Pawn @ " BeASniperGoal::Begin Back From Travel To Cover Slot and status == Move2CovStat_FailedCQB_Needed PushState('CloseQuartersBattleAttack') -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

						PushState('CloseQuartersBattleAttack');

						m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_None;

					}
					else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedBlockedByPawn )
					{
						;

						//`log(" ChadAI - Pawn " @ Pawn @ " BeASniperGoal::Begin Back From Travel To Cover Slot and status == Move2CovStat_FailedBlockedByPawn make cover invalid for small time -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
						m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_None;
					}
					else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedBlockedByActor )
					{
						;

						//`log(" ChadAI - Pawn " @ Pawn @ " BeASniperGoal::Begin Back From Travel To Cover Slot and status == Move2CovStat_FailedBlockedByActor make cover invalid for small time -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
						m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_None;					
					}
					else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedEnemyMadeCoverInvalid )
					{
						;

						InvalidateMoveGoal( m_SniperInfo.m_CoverToUseAsNest.Link, m_SniperInfo.m_CoverToUseAsNest.SlotIdx );

						ClearReservedCover();

						Goto('FailedGoal');
					}

				} // end if ( KynapseFoundPath() )
				else // no path
				{
					;


					m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_NoPathBuiltWaitingToMove;


					if( m_SniperInfo.m_bAllowWaitingForPathOrPositionToClear )
					{
						//`log(" ChadAI - Pawn " @ Pawn @ " BeASniperGoal::Begin Does Not Have Cover Path if have not tried path to many times Num Tried: " @ m_SniperInfo.m_NoOfTimesPathHasBeenTried @ " to try " @m_SniperInfo.m_NoOfTimesToCheckForPathToCover@ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

						if( ( m_SniperInfo.m_NoOfTimesToCheckForPathToCover < 0 ) ||( m_SniperInfo.m_NoOfTimesPathHasBeenTried < m_SniperInfo.m_NoOfTimesToCheckForPathToCover ) )
						{

							//`log(" ChadAI - Pawn " @ Pawn @ " BeASniperGoal still allowed to try finding a path -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

							ClearReservedCover();

							if( m_SniperInfo.m_bAllowAttackWhileWaitingForPathToClear && Enemy != None && CanFireAtNotFromCover(Enemy, true ) )
							{
								//`log(" ChadAI - Pawn " @ Pawn @ " BeASniperGoal::Begin Does Not Have Cover Path and has enemy with Line of Fire so attack -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

								PushState('Open_Field_Attack');

							}
							else
							{
								m_WanderInfo.m_TimeToWanderOrStandWaitingForPathOrPositionToClear = m_SniperInfo.m_TimeToWaitBetweenPathChecks;
								m_WanderInfo.m_bAllowAttackWhileWaitingForPathToClear = m_SniperInfo.m_bAllowAttackWhileWaitingForPathToClear;

								if( m_SniperInfo.m_bAllowWanderingWhileWaiting && m_WanderInfo.m_bAllowIdleWander )
								{
									//`log(" ChadAI - Pawn " @ Pawn @ " BeASniperGoal::Begin Does Not Have Cover Path and allowed to wander so wander -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
									PushState('WanderAround');
								}
								else
								{
									//`log(" ChadAI - Pawn " @ Pawn @ " BeASniperGoal::Begin Does Not Have Cover Path and aNot llowed to wander so stand -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

									PushState('StandWaitingForPathToClear');
								}
							}

						}
						else
						{
							//`log(" ChadAI - Pawn " @ Pawn @ " BeASniperGoal Not allowed to try finding a path again -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

							ClearReservedCover();
							InvalidateMoveGoal( m_SniperInfo.m_CoverToUseAsNest.Link, m_SniperInfo.m_CoverToUseAsNest.SlotIdx );
							Goto('FailedGoal');
						}
					}
					else
					{
						//`log(" ChadAI - Pawn " @ Pawn @ " BeASniperGoal Not allowed to try finding a path more then once -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

						ClearReservedCover();
						InvalidateMoveGoal( m_SniperInfo.m_CoverToUseAsNest.Link, m_SniperInfo.m_CoverToUseAsNest.SlotIdx );
						Goto('FailedGoal');
					}
					
				} // end  else of if ( KynapseFoundPath() )			
			} // end if( !IsAtCover(m_SniperInfo.m_CoverToUseAsNest) )
			else
			{
				//`log(" ChadAI - Pawn " @ Pawn @ " BeASniperGoal:: I am already at the cover so start defending -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				Goto('SnipeSubStateLoop');

			}
		} // end if( ReserveCover( m_SniperInfo.m_CoverToUseAsNest ) )
		else // can not reserve the cover so make invalid and try again
		{

			;


			//`log(" ChadAI - Pawn " @ Pawn @ " BeASniperGoal:: Not able to Reserved Cover Node: " @ m_SniperInfo.m_CoverToUseAsNest.Link @ " slot: " @ m_SniperInfo.m_CoverToUseAsNest.SlotIdx @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			if( m_SniperInfo.m_bAllowWaitingForPathOrPositionToClear )
			{
				//`log(" ChadAI - Pawn " @ Pawn @ " BeASniperGoal:: Not able to Reserved Cove and if have not tried path to many times Num Tried: " @ m_SniperInfo.m_NoOfTimesPathHasBeenTried @ " to try " @m_SniperInfo.m_NoOfTimesToCheckForPathToCover@ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				
				if( ( m_SniperInfo.m_NoOfTimesToCheckForPathToCover < 0 ) ||( m_SniperInfo.m_NoOfTimesPathHasBeenTried < m_SniperInfo.m_NoOfTimesToCheckForPathToCover ) )
				{
					//`log(" ChadAI - Pawn " @ Pawn @ " BeASniperGoal:: Not able to Reserved Cover and has not tried to many times yet -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					if( m_SniperInfo.m_bAllowAttackWhileWaitingForPathToClear && Enemy != None && CanFireAtNotFromCover(Enemy, true ) )
					{
						//`log(" ChadAI - Pawn " @ Pawn @ " BeASniperGoal:: Not able to Reserved Cover Node and has enemy with line of fire so attack -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
						;

						PushState('Open_Field_Attack');

					}
					else
					{

						m_WanderInfo.m_TimeToWanderOrStandWaitingForPathOrPositionToClear = m_SniperInfo.m_TimeToWaitBetweenPathChecks;
						m_WanderInfo.m_bAllowAttackWhileWaitingForPathToClear = m_SniperInfo.m_bAllowAttackWhileWaitingForPathToClear;


						if( m_SniperInfo.m_bAllowWanderingWhileWaiting && m_WanderInfo.m_bAllowIdleWander )
						{
							//`log(" ChadAI - Pawn " @ Pawn @ " BeASniperGoal:: Not able to Reserved Cover Node and allowed to wander a little bit  and try again -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
							PushState('WanderAround');
						}
						else
						{
							//`log(" ChadAI - Pawn " @ Pawn @ " BeASniperGoal:: Not able to Reserved Cover Node and Not allowed to wander a little bit  so stand and try again -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
							;

							PushState('StandWaitingForPathToClear');
						}
					}
				} // end if( m_SniperInfo.m_NoOfTimesPathHasBeenTried < m_SniperInfo.m_NoOfTimesToCheckForPathToCover )
				else
				{

					//`log(" ChadAI - Pawn " @ Pawn @ " BeASniperGoal:: Not able to Reserved Cover Node and allowed to wait for it clear but tried to many times -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					;

					InvalidateMoveGoal( m_SniperInfo.m_CoverToUseAsNest.Link, m_SniperInfo.m_CoverToUseAsNest.SlotIdx );
					Goto('FailedGoal');
				}
			}
			else
			{

				//`log(" ChadAI - Pawn " @ Pawn @ " BeASniperGoal:: Not able to Reserved Cover Node and not allowed to wait for it clear so invalidate and then fail task-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				;

				InvalidateMoveGoal( m_SniperInfo.m_CoverToUseAsNest.Link, m_SniperInfo.m_CoverToUseAsNest.SlotIdx );
				Goto('FailedGoal');
			}
			
		}

	} // end if (m_SniperInfo.m_CoverToUseAsNest.Link != None)
	else
	{
		;
		;
		Goto('FailedGoal');

	}

	Sleep(0.0);
	
	Goto('TravelToSnipersNest');

SnipeSubStateLoop:

	m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_DoneMovingAtCover;

	if(  ( WorldInfo.TimeSeconds - m_SniperInfo.m_TimeStartedAsSniperInSeconds ) > m_SniperInfo.m_TimeToBeSniperInSeconds )
	{
		Goto('AccomplishedGoal');
	}
	else
	{
		PushState('LookForSniperTarget');

		m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_None;
	}

	if(  ( WorldInfo.TimeSeconds - m_SniperInfo.m_TimeStartedAsSniperInSeconds ) > m_SniperInfo.m_TimeToBeSniperInSeconds )
	{
		Goto('AccomplishedGoal');
	}
	else
	{
		PushState('EngageAsSniper');
	}
		
	Goto('SnipeSubStateLoop');




AccomplishedGoal:

	//`log(" ChadAI - TPSoldierAIController::BeASniperGoal::AccomplishedGoal() -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	// reset the accuracy to the default accuracy
	m_CoverFightData.m_bUsingFightingPosition = false;
	
	BaseWeaponAccuracy = m_SniperInfo.m_PreviousAccuracy;

	m_SniperInfo.m_bCurrentlySniping = false;

	if( m_SniperInfo.m_SniperType == SniperType_Track )
	{
		ClearLatentAction(class'SeqAct_AIBeTrackSniper',false);
	}
	else
	{
		ClearLatentAction(class'SeqAct_AIBePinpointSniper',false);
	}

	Sleep(0.0); // some time to finish what ever animaion may be happening

	;
	
	//PopState();
	//`log(" ChadAI - BeASniperGoal::Begin call m_SniperInfo.m_TimeAsSniperInSeconds >= m_SniperInfo.m_TimeStartedAsSniperInSeconds   GotoState('Idle')*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
	EvaluateSituation();


FailedGoal:
	//`log(" ChadAI - TPSoldierAIController::BeASniperGoal::FailedGoal() -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	// reset the accuracy to the default accuracy
	m_CoverFightData.m_bUsingFightingPosition = false;
	
	BaseWeaponAccuracy = m_SniperInfo.m_PreviousAccuracy;

	m_SniperInfo.m_bCurrentlySniping = false;

	if( m_SniperInfo.m_SniperType == SniperType_Track )
	{
		ClearLatentAction(class'SeqAct_AIBeTrackSniper',true);
	}
	else
	{
		ClearLatentAction(class'SeqAct_AIBePinpointSniper',true);
	}

	Sleep(0.0); // some time to finish what ever animaion may be happening

	;
	
	//PopState();
	//`log(" ChadAI - BeASniperGoal::Begin call m_SniperInfo.m_TimeAsSniperInSeconds >= m_SniperInfo.m_TimeStartedAsSniperInSeconds   GotoState('Idle')*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
	EvaluateSituation();
}


//-----------------------------------------------------------------------
// State:		MantleCoverGoal
// Description:
//-----------------------------------------------------------------------
state MantleCoverGoal
{
	function BeginState(Name PreviousStateName)
	{
		;

		m_CoverFightData.m_bUsingFightingPosition = true;
		m_HighLevelAiGoal = HighLevelAiGoal_MantleCoverGoal;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		//`log(" ChadAI - TPSoldierAIController::MantleCoverGoal::BeginState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
	}
	
	event PausedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;


		//`log(" ChadAI - TPSoldierAIController::MantleCoverGoal::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	event ContinuedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;


		//`log(" ChadAI - TPSoldierAIController::MantleCoverGoal::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		m_HighLevelAiGoal = HighLevelAiGoal_MantleCoverGoal;
	}


	event PoppedState()
	{
		;

		//`log(" ChadAI - TPSoldierAIController::MantleCoverGoal::PoppedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		m_HighLevelAiGoal = HighLevelAiGoal_NONE;

		TestForMantleDoneEvent();

		StopThisBot();

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

	}
	
	function EndState(Name NextStateName)
	{
		;

		//`log(" ChadAI - TPSoldierAIController::MantleCoverGoal::EndState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		m_CoverFightData.m_bUsingFightingPosition = false;
		m_HighLevelAiGoal = HighLevelAiGoal_NONE;

		TestForMantleDoneEvent();

		StopThisBot();

		ClearCurrentCover();

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

	}

    function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		// do nothing for now
		//`log(" ChadAI - TPSoldierAIController::MantleCoverGoal::NotifyWeaponFired  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		

		if( m_Engagement_Tac_Data.m_bEngagingOnTheRun )
		{
			m_Engagement_Tac_Data.m_NoOfRoundsFiredThisBurst++;
		}
	}

	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " MantleCoverGoal::NotifyTakeHit from: " @ InstigatedBy.Pawn @ " for DamageL " @ Damage @ " With Health: " @ Pawn.Health @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		Super.NotifyTakeHit(InstigatedBy,HitLocation,Damage,damageType,Momentum);		

		//`log(" ChadAI - Pawn: " @ Pawn @ " MantleCoverGoal::NotifyTakeHit after Super Call Health: " @ Pawn.Health @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		if( Pawn != None )
		{
			if( Pawn.Health < 1  )
			{
				//`AILog(2, 'MantleCoverGoal',"NotifyTakeHit " for DamageL " @ Damage @ " With Health: " @ Pawn.Health @ " So turning phycics back to normal" );
				//`log(" ChadAI - Pawn: " @ Pawn @ " NotifyTakeHit from: " @ InstigatedBy.Pawn @ " for DamageL " @ Damage @ " With Health: " @ Pawn.Health @ " So turning phycics back to normal -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

				Pawn.bCollideWorld=true;
				TPPawn(Pawn).Obstacle=OB_Nothing;
				//StopThisBot();
				Pawn.Mesh.bUpdateSkelWhenNotRendered=false;
			}
		}
		else
		{
			//`log(" ChadAI - Con: " @ Self @ " MantleCoverGoal NotifyTakeHit Has no Pawn *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		}
	}
		
	function AccomplishedGoal()
	{
		//`log(" ChadAI - TPSoldierAIController::MantleCoverGoal::AccomplishedGoal() -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		m_CoverFightData.m_bUsingFightingPosition = false;
	
		ClearLatentAction(class'SeqAct_AIMantleCover',false);
	}

	function FailedGoal()
	{
		//`log(" ChadAI - TPSoldierAIController::MantleCoverGoal::FailedGoal() -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		m_CoverFightData.m_bUsingFightingPosition = false;
	
		ClearLatentAction(class'SeqAct_AIMantleCover',true);
	}

	//-----------------------------------------------------------------------
	// Function:
	// Description:	Teleports/snaps the pawn to the current cover
	//-----------------------------------------------------------------------
	function TestForMantleDoneEvent()
	{
		
		//local CoverSlot slot;
		local int idx;
		local SeqEvent_AiMantleFinished doneEvt;	
		
		//`log(" ChadAI - Pawn "@Pawn @ " TestForMantleDoneEvent: Node:" @ m_MantleGoalInfo.m_PlaceToMantle.Link @ " Slot: " @ m_MantleGoalInfo.m_PlaceToMantle.SlotIdx @ " -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");

		if( Pawn != None )
		{
			for (idx = 0; idx < Pawn.GeneratedEvents.Length; idx++)
			{
			   //`log(" ChadAI - Pawn "@Pawn @ " TestForMantleDoneEvent: - GeneratedEvents.Length[" @ idx @ "]:" @ Pawn.GeneratedEvents[idx] @ " -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");	
				doneEvt = SeqEvent_AiMantleFinished(Pawn.GeneratedEvents[Idx]);
				if (doneEvt != None)
				{	
					//`log(" ChadAI - Pawn "@Pawn @ " TestForMantleDoneEvent: - callin CheckIfCorrespondingCoverSlot -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
					;			
					doneEvt.CheckIfCorrespondingCoverSlot( Pawn, Self, m_MantleGoalInfo.m_PlaceToMantle );
				}
			}
		}
	}
	
	function PerformMantle()
	{		
		switch(m_MantleGoalInfo.m_MantleActionToPerform)
		{
			case MantleAction_Vaulting:
				PushState ('Vaulting');
				break;
			case MantleAction_VaultMedium:
				PushState ('VaultMedium');
				break;
			case MantleAction_VaultHigh:
				PushState ('VaultHigh');
				break;
			case MantleAction_VaultMantling:
				PushState ('VaultMantling');
				break;
			case MantleAction_MantlingLow:
				PushState ('MantlingLow');
				break;
			case MantleAction_MantlingMedium:
				PushState ('MantlingMedium');
				break;
			case MantleAction_JumpDown:
				PushState ('JumpDown');
				break;
		}
    }

	

Begin:

	m_SubStateDebugInfoTag="Begin";

	m_MantleGoalInfo.m_NoOfTimesPathHasBeenTried = 0;

	m_HighLevelAiGoal = HighLevelAiGoal_MantleCoverGoal;


MantleCoverGoalLoop:

	//`log(" ChadAI - TPSoldierAIController::MantleCoverGoal::Begin -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


	//`log(" ChadAI - TPSoldierAIController::MantleCoverGoal::Begin Need to move to a cover slot -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	

	if ( m_MantleGoalInfo.m_PlaceToMantle.Link != None)
	{
				
		if( ReserveCover( m_MantleGoalInfo.m_PlaceToMantle ) )
		{
					
			if( !IsAtCover(m_CoverMoveData.m_ReservedGoToCover_Clamied, false ) )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " MantleCoverGoal::Begin() Is not at cover so move there -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_BuildingPath;

				m_MantleGoalInfo.m_NoOfTimesPathHasBeenTried++;

				KynapseGoToFindPath( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link.GetSlotLocation( m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx ) );

				if ( KynapseFoundPath() )
				{
					//`log(" ChadAI - Pawn " @ Pawn @ " MantleCoverGoal::Begin Has Cover Path Found Now Travel There -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_PathBuiltWaitingToMove;

					m_CoverMoveData.m_HasPathToCoverBeenBuilt = true;
					m_CoverMoveData.m_bCheckToSeeIfCoverIsStillValidDuringMoveToCover = false;

					PushState('TravelToCoverSlot');

					//`log(" ChadAI - Pawn " @ Pawn @ " MantleCoverGoal::Begin Back From Travel To Cover Slot status: " @ m_CoverMoveData.m_Move2CoverStatus @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_DoneMovingAtCover )
					{
						//`log(" ChadAI - Pawn " @ Pawn @ " MantleCoverGoal::Begin Back From Travel To Cover Slot and status == Move2CovStat_DoneMovingAtCover Goto('MantleCover') -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					
						// snap to the cover slot

						if( Pawn != None )
						{
							Pawn.SetLocation( m_CoverMoveData.m_CurrentCover_Clamied.Link.GetSlotLocation(m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx) );
						}

						Goto('MantleCover');

					}
					else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedCQB_Needed )
					{
						//`log(" ChadAI - Pawn " @ Pawn @ " MantleCoverGoal::Begin Back From Travel To Cover Slot and status == Move2CovStat_FailedCQB_Needed PushState('CloseQuartersBattleAttack') -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

						PushState('CloseQuartersBattleAttack');

						m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_None;

					}
					else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedBlockedByPawn )
					{
						//`log(" ChadAI - Pawn " @ Pawn @ " MantleCoverGoal::Begin Back From Travel To Cover Slot and status == Move2CovStat_FailedBlockedByPawn make cover invalid for small time -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
						m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_None;
					}
					else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedBlockedByActor )
					{
						//`log(" ChadAI - Pawn " @ Pawn @ " MantleCoverGoal::Begin Back From Travel To Cover Slot and status == Move2CovStat_FailedBlockedByActor make cover invalid for small time -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
						m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_None;					
					}
					else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedEnemyMadeCoverInvalid )
					{
						;

						InvalidateMoveGoal( m_MantleGoalInfo.m_PlaceToMantle.Link, m_MantleGoalInfo.m_PlaceToMantle.SlotIdx );

						ClearReservedCover();

						FailedGoal();
						Goto('DoneMantling');
					}

				} // end if ( KynapseFoundPath() )
				else // no path
				{

					m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_NoPathBuiltWaitingToMove;


					if( m_MantleGoalInfo.m_bAllowWaitingForPathOrPositionToClear )
					{
						//`log(" ChadAI - Pawn " @ Pawn @ " MantleCoverGoal::Begin Does Not Have Cover Path if have not tried path to many times Num Tried: " @ m_MantleGoalInfo.m_NoOfTimesPathHasBeenTried @ " to try " @m_MantleGoalInfo.m_NoOfTimesToCheckForPathToCover@ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

						if( ( m_MantleGoalInfo.m_NoOfTimesToCheckForPathToCover < 0 ) ||( m_MantleGoalInfo.m_NoOfTimesPathHasBeenTried < m_MantleGoalInfo.m_NoOfTimesToCheckForPathToCover ) )
						{

							//`log(" ChadAI - Pawn " @ Pawn @ " MantleCoverGoal still allowed to try finding a path -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

							ClearReservedCover();

							if( m_MantleGoalInfo.m_bAllowAttackWhileWaitingForPathToClear && Enemy != None && CanFireAtNotFromCover(Enemy, true ) )
							{
								//`log(" ChadAI - Pawn " @ Pawn @ " MantleCoverGoal::Begin Does Not Have Cover Path and has enemy with Line of Fire so attack -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

								PushState('Open_Field_Attack');

							}
							else
							{
		
								m_WanderInfo.m_TimeToWanderOrStandWaitingForPathOrPositionToClear = m_MantleGoalInfo.m_TimeToWaitBetweenPathChecks;
								m_WanderInfo.m_bAllowAttackWhileWaitingForPathToClear = m_MantleGoalInfo.m_bAllowAttackWhileWaitingForPathToClear;


								if( m_MantleGoalInfo.m_bAllowWanderingWhileWaiting && m_WanderInfo.m_bAllowIdleWander )
								{
									//`log(" ChadAI - Pawn " @ Pawn @ " MantleCoverGoal::Begin Does Not Have Cover Path and allowed to wander so wander -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
									PushState('WanderAround');
								}
								else
								{
									//`log(" ChadAI - Pawn " @ Pawn @ " MantleCoverGoal::Begin Does Not Have Cover Path and aNot llowed to wander so stand -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
									PushState('StandWaitingForPathToClear');
								}
							}

						}
						else
						{
							//`log(" ChadAI - Pawn " @ Pawn @ " MantleCoverGoal Not allowed to try finding a path again -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

							ClearReservedCover();
							InvalidateMoveGoal( m_MantleGoalInfo.m_PlaceToMantle.Link, m_MantleGoalInfo.m_PlaceToMantle.SlotIdx );
							FailedGoal();
							Goto('DoneMantling');
						}
					}
					else
					{
						//`log(" ChadAI - Pawn " @ Pawn @ " MantleCoverGoal Not allowed to try finding a path more then once -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

						ClearReservedCover();
						InvalidateMoveGoal( m_MantleGoalInfo.m_PlaceToMantle.Link, m_MantleGoalInfo.m_PlaceToMantle.SlotIdx );
						FailedGoal();
						Goto('DoneMantling');
					}
					
				} // end  else of if ( KynapseFoundPath() )			
			} // end if( !IsAtCover(m_MantleGoalInfo.m_PlaceToMantle) )
			else
			{
				//`log(" ChadAI - Pawn " @ Pawn @ " MantleCoverGoal:: I am already at the cover so start defending -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				Goto('MantleCover');

			}
		} // end if( ReserveCover( m_MoveToAndDefendCoverGoalInfo.m_CoverToDefend ) )
		else // can not reserve the cover so make invalid and try again
		{

			;

			//`log(" ChadAI - Pawn " @ Pawn @ " MantleCoverGoal:: Not able to Reserved Cover Node: " @ m_MantleGoalInfo.m_PlaceToMantle.Link @ " slot: " @ m_MantleGoalInfo.m_PlaceToMantle.SlotIdx @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			if( m_MantleGoalInfo.m_bAllowWaitingForPathOrPositionToClear )
			{
				//`log(" ChadAI - Pawn " @ Pawn @ " MantleCoverGoal:: Not able to Reserved Cove and if have not tried path to many times Num Tried: " @ m_MantleGoalInfo.m_NoOfTimesPathHasBeenTried @ " to try " @m_MantleGoalInfo.m_NoOfTimesToCheckForPathToCover@ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				
				if( ( m_MantleGoalInfo.m_NoOfTimesToCheckForPathToCover < 0 ) ||( m_MantleGoalInfo.m_NoOfTimesPathHasBeenTried < m_MantleGoalInfo.m_NoOfTimesToCheckForPathToCover ) )
				{
					//`log(" ChadAI - Pawn " @ Pawn @ " MantleCoverGoal:: Not able to Reserved Cover and has not tried to many times yet -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					if( m_MantleGoalInfo.m_bAllowAttackWhileWaitingForPathToClear && Enemy != None && CanFireAtNotFromCover(Enemy, true ) )
					{
						//`log(" ChadAI - Pawn " @ Pawn @ " MantleCoverGoal:: Not able to Reserved Cover Node and has enemy with line of fire so attack -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
						;

						PushState('Open_Field_Attack');

					}
					else
					{
						m_WanderInfo.m_TimeToWanderOrStandWaitingForPathOrPositionToClear = m_MantleGoalInfo.m_TimeToWaitBetweenPathChecks;
						m_WanderInfo.m_bAllowAttackWhileWaitingForPathToClear = m_MantleGoalInfo.m_bAllowAttackWhileWaitingForPathToClear;

						if( m_MantleGoalInfo.m_bAllowWanderingWhileWaiting && m_WanderInfo.m_bAllowIdleWander )
						{
							//`log(" ChadAI - Pawn " @ Pawn @ " MantleCoverGoal:: Not able to Reserved Cover Node and allowed to wander a little bit  and try again -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
							PushState('WanderAround');
						}
						else
						{
							//`log(" ChadAI - Pawn " @ Pawn @ " MantleCoverGoal:: Not able to Reserved Cover Node and Not allowed to wander a little bit  so stand and try again -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
							;
							PushState('StandWaitingForPathToClear');
						}
					}
				} // end if( m_SniperInfo.m_NoOfTimesPathHasBeenTried < m_SniperInfo.m_NoOfTimesToCheckForPathToCover )
				else
				{

					//`log(" ChadAI - Pawn " @ Pawn @ " MantleCoverGoal:: Not able to Reserved Cover Node and allowed to wait for it clear but tried to many times -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					;

					InvalidateMoveGoal( m_MantleGoalInfo.m_PlaceToMantle.Link, m_MantleGoalInfo.m_PlaceToMantle.SlotIdx );
					FailedGoal();
					Goto('DoneMantling');
				}
			}
			else
			{

				//`log(" ChadAI - Pawn " @ Pawn @ " MantleCoverGoal:: Not able to Reserved Cover Node and not allowed to wait for it clear so invalidate and then fail task-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				;

				InvalidateMoveGoal( m_MantleGoalInfo.m_PlaceToMantle.Link, m_MantleGoalInfo.m_PlaceToMantle.SlotIdx );
				FailedGoal();
				Goto('DoneMantling');
			}
			
		}

	} // end if (m_MantleGoalInfo.m_PlaceToMantle.Link != None)
	else
	{
		;
		;
		FailedGoal();
		Goto('DoneMantling');

	}

	Sleep(0.0);

	Goto('MantleCoverGoalLoop');

MantleCover:

	DesiredRotation = m_MantleGoalInfo.m_PlaceToMantle.Link.GetSlotRotation( m_MantleGoalInfo.m_PlaceToMantle.SlotIdx ) ;
	DesiredRotation.Pitch = 0;
	Pawn.SetRotation( DesiredRotation );

	//ChangeKynapseEntityToPassiveEntity();
	/* should not use, causes sliding
	//ActivateKynapseBrain(false);
	*/

	//DesiredRotation = m_MantleGoalInfo.m_PlaceToMantle.Link.GetSlotRotation( m_MantleGoalInfo.m_PlaceToMantle.SlotIdx ) ;
	//Pawn.SetRotation( DesiredRotation );

	if (Pawn.bIsCrouched)
	{
		m_SubStateDebugInfoTag="Mantle UnCrouching";


		m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange = WorldInfo.TimeSeconds;

		if( Pawn != None && TPPawn(Pawn) != none )
		{
			Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToStanding;
		}

		;


		// OpenFieldPostureSwitchingState_GoingToCrouching
		while(	(Pawn.bIsCrouched && Pawn != None && TPPawn(Pawn) != none) ||
				(Pawn != None && TPPawn(Pawn) != none && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching ) )
		{
			Pawn.UnCrouch();
			Sleep(0.0);

			if( !Pawn.bIsCrouched && ( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange) >= 
										class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToStandPostureChangeToFinish ) )
			{
				;
				Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
				break;
			}
		}			
	}
	
	PerformMantle();

	StopThisBot();
	
	//ChangeKynapseEntityToActiveEntity();	
	/* should not use, causes sliding
	//ActivateKynapseBrain(true);
	*/
	
	Sleep(0.0); // some time to finish what ever animaion may be happening
			
	AccomplishedGoal();


DoneMantling:
	
	Sleep(0.0); // some time to finish what ever animaion may be happening

	;
		
	EvaluateSituation();

}



//-----------------------------------------------------------------------
// State:		RappelGoal
// Description:
//-----------------------------------------------------------------------
state RappelGoal
{
	function BeginState(Name PreviousStateName)
	{
		m_CoverFightData.m_bUsingFightingPosition = true;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;
		//`log(" ChadAI - TPSoldierAIController::RappelGoal::BeginState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
	}
	
	event PausedState()
	{
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;
		//`log(" ChadAI - TPSoldierAIController::RappelGoal::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	event ContinuedState()
	{
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;
		//`log(" ChadAI - TPSoldierAIController::RappelGoal::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}

	event PoppedState()
	{
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;
		//`log(" ChadAI - TPSoldierAIController::RappelGoal::PoppedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}
	
	function EndState(Name NextStateName)
	{
		//`log(" ChadAI - TPSoldierAIController::RappelGoal::EndState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		m_CoverFightData.m_bUsingFightingPosition = false;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;
		ClearCurrentCover();	
	}
		
	function AccomplishedGoal()
	{
		//`log(" ChadAI - TPSoldierAIController::RappelGoal::AccomplishedGoal() -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		m_CoverFightData.m_bUsingFightingPosition = false;
	
		ClearLatentAction(class'SeqAct_AIRappel',false);
	}


	
Begin:

	m_SubStateDebugInfoTag="Begin";

	//`log(" ChadAI - TPSoldierAIController::RappelGoal::Begin -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	
	//ChangeKynapseEntityToPassiveEntity();
	/* should not use, causes sliding
	ActivateKynapseBrain(false);
	*/
	
	Pawn.SetLocation( m_FreeAttackGoalInfo.m_FreeAttackCoverToSeek.Link.Location );
	
	PushState('Rappelling');
	
	//ChangeKynapseEntityToActiveEntity();	
	/* should not use, causes sliding
	ActivateKynapseBrain(true);
	*/
				
	//`log(" ChadAI - RappelGoal::Begin call ENDED  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

RappelGoalLoop:
// 	
	//`log(" ChadAI - TPSoldierAIController::RappelGoal::RappelGoalLoop::-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		
	AccomplishedGoal();
		
	Sleep(0.0); // some time to finish what ever animaion may be happening

	;
				
	EvaluateSituation();

		
	//Goto('BeASniperGoalLoop');
}

//-----------------------------------------------------------------------
// State:		UseFightingPosition - Used to be DefendCover
// Description:
//-----------------------------------------------------------------------
state UseFightingPosition
{
	
	function BeginState(Name PreviousStateName)
	{
		;

		m_CoverFightData.m_bUsingFightingPosition = true;
		//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::BeginState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
	}
	
	event PausedState()
	{
		;
		//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		//HandleLeftCoverCollisionChange( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos );
		m_CoverFightData.m_bUsingFightingPosition = false;
		m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
		m_CoverMoveData.m_CoverState = CoverBehavior_Hiding;

// 		if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType	== CT_OpenFieldStanding  )  || 
// 		( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType == CT_OpenFieldMidLevel ) )
// 		{
// 			Pawn.SetPhysics(PHYS_Walking);
// 		}

		//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition PausedState DesiredRotation : " @ DesiredRotation.Yaw @ " - Pawn Rot: " @ Pawn.Rotation.Yaw @ "Pawn.DesiredRotation : " @ Pawn.DesiredRotation.Yaw @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		//ClearCurrentCover();	
	}

	event ContinuedState()
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		//`AILOG(1, 'UseFightingPosition', "ContinuedState: ");

		//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition ContinuedState DesiredRotation : " @ DesiredRotation.Yaw @ " - Pawn Rot: " @ Pawn.Rotation.Yaw @ "Pawn.DesiredRotation : " @ Pawn.DesiredRotation.Yaw @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			if( !IsAtCover(m_CoverFightData.m_CurrentlyCoverToUseAsFightPos, false ) )
			{
				//`log(" ChadAI - TPSoldierAIController::Fire_From_Cover_Slot::ContinuedState Not At Cover So Going Back to Parent State PopState-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				;

				if ( m_CoverFightData.m_UseFightingPositionStatus != UseFightingPosition_PausedGrenadeOut )
				{
					;

					//`log("Pawn: " @ Pawn @ "TPSoldierAIController::UseFightingPosition::Tick:: UseFightingPositionLoop  Not at cover to defend and I do not remember which one I am to defend So going back to parnent state -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedBecauseForgotIt;
				}
				else
				{
					;

					//`log("Pawn: " @ Pawn @ " UseFightingPositionLoop  Not at cover to defend becuase I was responding to a grenade out so return to parnent state and get new orders -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				}

				PopState();
			}
			else
			{
				;


				m_CoverFightData.m_bUsingFightingPosition = true;
				m_CoverFightData.m_bContinueToUseUseFightingPosition = true;

				HandleAtCoverCollisionChange( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos );

				//m_CoverMoveData.m_CoverState = CoverBehavior_Hiding; can not be this because will always fire when returning to this state even from a firing state
				//SetCoverAction(m_CoverMoveData.m_CurrentCover_Clamied, false);

				//ShiftPawnPositionBasedUponCoverAction( m_CoverMoveData.m_CurrentCover_Clamied, m_CoverFightData.m_CurrentCoverAction, CoverBehavior_Hiding);

			}
		
	}

	event PoppedState()
	{
		;

		//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::PoppedState  Fight Pos: " @ m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link @ " Cur Cover: " @ m_CoverMoveData.m_CurrentCover_Clamied.Link @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		HandleLeftCoverCollisionChange( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos );

		m_CoverFightData.m_bUsingFightingPosition = false;
		//ClearCurrentCover();

		m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link = None;
		m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.SlotIdx = -1;

		bForceDesiredRotation = false;
		//leaving cover, so reenable aim and head tracking
		SetAimAndHeadTrack(false);

	}
	
	function EndState(Name NextStateName)
	{
		;

		//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::EndState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		HandleLeftCoverCollisionChange( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos );
		m_CoverFightData.m_bUsingFightingPosition = false;
		//ClearCurrentCover();

		m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link = None;
		m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.SlotIdx = -1;

		bForceDesiredRotation = false;
		//leaving cover, so reenable aim and head tracking
		SetAimAndHeadTrack(false);
	}
	
    function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		// do nothing for now
		//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::NotifyWeaponFired  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		
    }
	
	
	event Tick( float DeltaTime )
	{
		if( Enemy != None )
		{
			UpdateAimAtCover();
		}
		UpdateHeadtracking();

		if (anode_WeaponBlend != none)
		{
			if (Pawn == none || Pawn.Weapon == none)
				anode_WeaponBlend.SetBlendTarget(1.0, 0.2);
			else
				anode_WeaponBlend.SetBlendTarget(0.0, 0.2);
		}

		//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition Tick DesiredRotation : " @ DesiredRotation.Yaw @ " - Pawn Rot: " @ Pawn.Rotation.Yaw @ "Pawn.DesiredRotation : " @ Pawn.DesiredRotation.Yaw @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		//Super.Tick(DeltaTime);

	}
	
	function bool CheckNodeThisSpecificSubBehaviorCriteria(	SubCoverBehaviorInfo SubInfo, 
															TPCoverNode NodeAt, 
															float RandSumDelta, 
															out ScriptedCoverBehaviorData SubBehData )
	{	
		local bool b_shouldPerform;

		//`log(" ChadAI - TPSoldierAIController::CheckNodeThisSpecificSubBehaviorCriteria -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		
		b_shouldPerform = false;
		
		if( SubInfo.m_bAllowSubBehavior )
		{
			//`log(" ChadAI - TPSoldierAIController::CheckNodeThisSpecificSubBehaviorCriteria m_bAllowSubBehavior == TRUE -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		
			if( m_CoverMoveData.m_TimeLastSubCoverBehaviorFinished <= 0 ||
				( WorldInfo.TimeSeconds - m_CoverMoveData.m_TimeLastSubCoverBehaviorFinished) >= SubInfo.m_FrequencyOfChanceOfSubBehavior )
			{
				//`log(" ChadAI - TPSoldierAIController::CheckNodeThisSpecificSubBehaviorCriteria Time IS Valid -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				//`log(" ChadAI - TPSoldierAIController::CheckNodeThisSpecificSubBehaviorCriteria m_CoverFightInfo.m_TimeLastSubCoverBehaviorFinished: " @ m_CoverMoveData.m_TimeLastSubCoverBehaviorFinished@ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				//`log(" ChadAI - TPSoldierAIController::CheckNodeThisSpecificSubBehaviorCriteria m_FrequencyOfChanceOfSubBehavior: " @ SubInfo.m_FrequencyOfChanceOfSubBehavior @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			
				if( RandSumDelta < SubInfo.m_ChanceOfSubBehavior )
				{
					//`log(" ChadAI - TPSoldierAIController::CheckNodeThisSpecificSubBehaviorCriteria RandSumDelta: " @ RandSumDelta @ " < SubInfo.m_ChanceOfSubBehavior: " @ SubInfo.m_ChanceOfSubBehavior @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				
					SubBehData.m_TimeToPerformInSec = RandRange(SubInfo.m_MinDurationOfSubBehaviorPerOccurrence, SubInfo.m_MaxDurationOfSubBehaviorPerOccurrence);
					SubBehData.m_bOverRideNonScriptedDurations = true;
					
					b_shouldPerform = true;	
					
					//`log(" ChadAI - TPSoldierAIController::CheckNodeThisSpecificSubBehaviorCriteria Should Perform a Sub Behavior for time: " @ SubBehData.m_TimeToPerformInSec @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");							
				}
			
			}
			else
			{
				//`log(" ChadAI - TPSoldierAIController::CheckNodeThisSpecificSubBehaviorCriteria Time NOT Valid -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				//`log(" ChadAI - TPSoldierAIController::CheckNodeThisSpecificSubBehaviorCriteria m_FrequencyOfChanceOfSubBehavior: " @ SubInfo.m_FrequencyOfChanceOfSubBehavior @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			}
			
		}
		else
		{
			//`log(" ChadAI - TPSoldierAIController::CheckNodeThisSpecificSubBehaviorCriteria m_bAllowSubBehavior == FALSE -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		
		}		
		
		
		return b_shouldPerform;
	
	}	

	
	function eScriptedCoverBehavior GetScriptedCoverBehaviorForPeek()
	{
		local CoverSlot slot;
		local eScriptedCoverBehavior returnVal;
		
		returnVal = ScriptedCoverBehavior_PeakUp;
		
		slot = m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx];	
	
		switch ( slot.CoverType )
		{
			case CT_MidLevel:

				// need to check for multiple directions
				if (m_CoverFightData.m_CurrentCoverAction == CA_LeanLeft )
				{
					returnVal = ScriptedCoverBehavior_PeakLeft;
				}
				else if (m_CoverFightData.m_CurrentCoverAction == CA_LeanRight )
				{
					returnVal = ScriptedCoverBehavior_PeakRight;
				}
				else
				{
					returnVal = ScriptedCoverBehavior_PeakUp;
				}
				break;
			case CT_Standing:
				// need to check for multiple directions
				if ( m_CoverFightData.m_CurrentCoverAction == CA_LeanLeft )
				{
					returnVal = ScriptedCoverBehavior_PeakLeft;
				}
				else if ( m_CoverFightData.m_CurrentCoverAction == CA_LeanRight )
				{
					returnVal = ScriptedCoverBehavior_PeakRight;
				}
				else
				{
					returnVal = ScriptedCoverBehavior_PeakRight;
				}
				break;
			case CT_OpenFieldStanding:
				returnVal = ScriptedCoverBehavior_StraightAhead;
				break;
			case CT_OpenFieldMidLevel:
				returnVal = ScriptedCoverBehavior_StraightAhead;
				break;
			case CT_OpenFieldStandingAtCover:
				returnVal = ScriptedCoverBehavior_StraightAhead;
				break;
			default:
				;
				//`log(" ChadAI - Unknown cover type: " @ slot.CoverType @ "--------------------------------------------------------------------------------------------------------------------------");
				break;	
		}
		
		return returnVal;
	}	
	
	
	function CheckForNodeSpecificSubBehavior()
	{
		local TPCoverNode nodeAt;
		local float randNum, randSumDelta;
		local ScriptedCoverBehaviorData subBehData;
		local bool b_subBehFound;
		
		b_subBehFound = false;

		// get the current cover node and check to see if there are any sub cover behaviors enabled for it
		
		if( m_CoverMoveData.m_CurrentCover_Clamied.Link != None )
		{
			nodeAt = TPCoverNode( m_CoverMoveData.m_CurrentCover_Clamied.Link );
			
			randNum = RandRange( 0.0, 1.0 );
			
			randSumDelta = randNum; 
			
			//`log(" ChadAI - TPSoldierAIController::CheckForNodeSpecificSubBehavior randNum: " @ randNum @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");			
						
			//`log(" ChadAI - TPSoldierAIController::CheckForNodeSpecificSubBehavior for m_PeekOut -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			// for Peek out
			if( !b_subBehFound && CheckNodeThisSpecificSubBehaviorCriteria( nodeAt.m_NodesSubCoverBehaviorInfo.m_PeekOut, nodeAt, randSumDelta, subBehData ) )
			{
				// determin the type of peek based on what type of slot the pawn is at
				
				subBehData.m_Behavior = GetScriptedCoverBehaviorForPeek();							
				b_subBehFound = true;
			}
			
			if( nodeAt.m_NodesSubCoverBehaviorInfo.m_PeekOut.m_bAllowSubBehavior )
			{
				randSumDelta = randSumDelta - nodeAt.m_NodesSubCoverBehaviorInfo.m_PeekOut.m_ChanceOfSubBehavior;
			}
												
			//`log(" ChadAI - TPSoldierAIController::CheckForNodeSpecificSubBehavior for m_WaveOn -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			// for Wave On
			if( !b_subBehFound && CheckNodeThisSpecificSubBehaviorCriteria( nodeAt.m_NodesSubCoverBehaviorInfo.m_WaveOn, nodeAt, randSumDelta, subBehData ) )
			{
				// determin the type of peek based on what type of slot the pawn is at

				// only for mid level right now check standing and othat types of slots
				
				subBehData.m_Behavior = ScriptedCoverBehavior_WaveOn;							
				b_subBehFound = true;
			}
			
			if( nodeAt.m_NodesSubCoverBehaviorInfo.m_WaveOn.m_bAllowSubBehavior )
			{
				randSumDelta = randSumDelta - nodeAt.m_NodesSubCoverBehaviorInfo.m_WaveOn.m_ChanceOfSubBehavior;
			}			
		
		}
		
		// if so check to see if they should be activated
		if( b_subBehFound )
		{
			//`log(" ChadAI - TPSoldierAIController::CheckForNodeSpecificSubBehavior Sub Behavior Found: " @ subBehData.m_Behavior @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		
			// if so add to the sub behavior queue
			m_CoverMoveData.m_QueueOfScriptedCoverBehaviors[m_CoverMoveData.m_QueueOfScriptedCoverBehaviors.Length] = subBehData;
		}
		else
		{
			//`log(" ChadAI - TPSoldierAIController::CheckForNodeSpecificSubBehavior Sub Behavior NOT!!! Found -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		
		}
	
	}																							
	
	function PerformForcedCoverBehavior()
	{
	
		//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::PerformForcedCoverBehavior() -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	
		if( m_CoverMoveData.m_QueueOfScriptedCoverBehaviors.Length > 0 )
		{
			m_CoverMoveData.m_CurrentScriptedCoverBehaviorData = m_CoverMoveData.m_QueueOfScriptedCoverBehaviors[0];
			
			//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::PerformForcedCoverBehavior() m_CurrentScriptedCoverBehaviorData.Behavior: " @ m_CoverMoveData.m_CurrentScriptedCoverBehaviorData.m_Behavior @ " Time: " @ m_CoverMoveData.m_CurrentScriptedCoverBehaviorData.m_TimeToPerformInSec @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			
			m_CoverMoveData.m_QueueOfScriptedCoverBehaviors.Remove(0,1);
			
			;

			
			PushState('PerformScriptedCoverSubBehavior');
		}
	}
	
	function CoverBehavior GetEngageTheEnemyState()
	{
		//local bool benemyRecentlyVisible;
		local bool bcanFireAtEnemyFromHere;
		//local vector lineOfFireOffset;
		
			
		//benemyRecentlyVisible = EnemyRecentlyVisible(true);
		
// 		if( benemyRecentlyVisible )
// 		{
// 			//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::EngageTheEnemy() EnemyRecentlyVisible is TRUE -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 		}
// 		else 		
// 		{
// 			//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::EngageTheEnemy() EnemyRecentlyVisible is FALSE -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 		}

		if( m_CoverFightData.m_FirstSubBehaviorAtCover )
		{
			// if at corner cover do a quick hid to get the animations to line up and if in the open and standing do normal
			if( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldStanding  ) 
			{
				;
				return CoverBehavior_Hiding;
			}
			else
			{
				m_CoverFightData.m_FirstSubBehaviorAtCover = false;
			}
		}


		//lineOfFireOffset = FigureOutLineOfFireOffset(m_CoverMoveData.m_CurrentCover_Clamied);
		bcanFireAtEnemyFromHere = CanFireAtEnemyFrom(m_CoverMoveData.m_CurrentCover_Clamied, true);

		//`AILOG(2, 'UseFightingPostion', "GetEngageTheEnemyState bcanFireAtEnemyFromHere: " @ bcanFireAtEnemyFromHere @ " and benemyRecentlyVisible: " @ benemyRecentlyVisible);
		;
		//`log(" ChadAI - Pawn: " @ Pawn @ " GetEngageTheEnemyState bcanFireAtEnemyFromHere: " @ bcanFireAtEnemyFromHere @ " and benemyRecentlyVisible: " @ benemyRecentlyVisible @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		if( bcanFireAtEnemyFromHere )
		{
			//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::EngageTheEnemy() benemyRecentlyVisible || bbanFireAtEnemyFromHere so going to FIRE at ENEMY -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			
			//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::EngageTheEnemy() m_CoverMoveData.m_CoverState: " @ m_CoverMoveData.m_CoverState @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			if( m_CoverMoveData.m_CoverState == CoverBehavior_Hiding || m_CoverMoveData.m_CoverState == CoverBehavior_Looking || m_CoverMoveData.m_CoverState == CoverBehavior_Reloading )
			{
				;

				//PushState('Fire_From_Cover_Slot');
				return CoverBehavior_Firing;
				//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::EngageTheEnemy() returned from FireFromCover -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			}
			else if ( m_CoverMoveData.m_CoverState == CoverBehavior_Firing || m_Engagement_Tac_Data.m_bTookHit || IsReloading() )
			{

				if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldStanding  )  && 
					( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldMidLevel ) )
				{
// 					if( !m_Engagement_Tac_Data.m_bKnowBeingAimedAt )
// 					{
// 						`AILOG(2, 'UseFightingPostion', "GetEngageTheEnemyState all ready know I can shoot from here and just came back from firing or taking a hit " @ m_CoverMoveData.m_CoverState @ " but m_bKnowBeingAimedAt so set CoverTransitionAction_HidingToFiring");
// 
// 						m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_FiringToHiding;
// 					}
					//PushState('HideBehindCurrentCover');
					;
					return CoverBehavior_Hiding;
				}
				else
				{
					if( !IsReloading() && !m_Engagement_Tac_Data.m_bNeedToReloadAtNextOpertunity )
					{
						//`log(" ChadAI - GetEngageTheEnemyState all ready know I can shoot from here and just came back from firing or taking a hit: " @ m_CoverMoveData.m_CoverState @ " but at a open field slot so keep firing");
						;
						return CoverBehavior_Firing;
					}
					else
					{
						//`log(" ChadAI - GetEngageTheEnemyState all ready know I can shoot from here and just came back from firing or taking a hit: " @ m_CoverMoveData.m_CoverState @ " and at a open field slot but reloading so hide instead");

						;
						return CoverBehavior_Hiding;
					}
				}
				//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::EngageTheEnemy() returned from HideBehindCover -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			}
			else
			{
				;

				//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::EngageTheEnemy() Invaild Cover State: " @ m_CoverMoveData.m_CoverState @"  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			}
		} // end if if ( benemyRecentlyVisible || bcanFireAtEnemyFromHere)
		else
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " UseFightingPosition::EngageTheEnemy() !benemyRecentlyVisible && !bbanFireAtEnemyFromHere so going to....... -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		}

// 		if (m_bInvalidFireState)
// 		{
// 			//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::EngageTheEnemy() Has m_bInvalidFireState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 
// 			//`AILOG(0, 'CoverAttackLoop', "invalid fire state");
// 			m_bDoIdle = true;
// 		}

		if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldStanding  )  && 
			( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldMidLevel ) )
		{
			//`AILOG(2, 'UseFightingPostion', "GetEngageTheEnemyState because either bcanFireAtEnemyFromHere: " @ bcanFireAtEnemyFromHere @ " is false and benemyRecentlyVisible: " @ benemyRecentlyVisible @ " is false and at corner cover returning CoverBehavior_Looking");
			;	
			//`log(" ChadAI - Pawn: " @ Pawn @ " UseFightingPosition::GetEngageTheEnemyState because either bcanFireAtEnemyFromHere: " @ bcanFireAtEnemyFromHere @ " is false and benemyRecentlyVisible: " @ benemyRecentlyVisible @ " is false and at corner cover returning CoverBehavior_Looking -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			//return CoverBehavior_Hiding;
			return CoverBehavior_Looking;
		}

		;
		//`AILOG(2, 'UseFightingPostion', "GetEngageTheEnemyState because either bcanFireAtEnemyFromHere: " @ bcanFireAtEnemyFromHere @ " is false and benemyRecentlyVisible: " @ benemyRecentlyVisible @ " is false and at a open field position returning CoverBehavior_Hiding");
		//`log(" ChadAI - Pawn: " @ Pawn @ " UseFightingPosition::GetEngageTheEnemyState because either bcanFireAtEnemyFromHere: " @ bcanFireAtEnemyFromHere @ " is false and benemyRecentlyVisible: " @ benemyRecentlyVisible @ " is false and at a open field position returning CoverBehavior_Hiding -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		//return CoverBehavior_Looking;
		return CoverBehavior_Hiding;
	}


Begin:

	m_SubStateDebugInfoTag="Begin";

	;

	//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition::Begin() m_CurrentCover_Clamied: " @ m_CoverMoveData.m_CurrentCover_Clamied.Link @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	//`log(" ChadAI - Pawn: " @ Pawn @ " UseFightingPosition  SetCoverAction Begin Getting Called -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	m_CoverMoveData.m_CoverState = CoverBehavior_Hiding;
	SetCoverAction(m_CoverMoveData.m_CurrentCover_Clamied, false);

	//`log(" ChadAI - Pawn: " @ Pawn @ " UseFightingPosition  SetCoverAction Begin Getting Called m_CoverMoveData.m_CoverState: " @ m_CoverMoveData.m_CoverState @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	m_CoverFightData.m_FirstSubBehaviorAtCover = true;

	if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_Standing ) && 
		 ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldStanding) )
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " UseFightingPosition at low cover and - bIsCrouched: " @ Pawn.bIsCrouched @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;

		if( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType == CT_MidLevel  )
		{
			;

			m_SubStateDebugInfoTag="Hiding at cover";
			while( !Pawn.bIsCrouched )
			{
				if( Pawn != None)
				{
					if( !Pawn.bCollideWorld )
					{
						Pawn.bCollideWorld=true;
						Pawn.SetPhysics(PHYS_Walking);
					}

				}
				//`log(" ChadAI - Pawn: " @ Pawn @ " UseFightingPosition Crouching because at low cover - bIsCrouched: " @ Pawn.bIsCrouched @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				;
				Pawn.ShouldCrouch(true);
				m_Engagement_Tac_Data.m_LastTimeCrouched = WorldInfo.TimeSeconds;
				Sleep(0.0);
			}
		}

	}
	else
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " UseFightingPosition at standing cover and - bIsCrouched: " @ Pawn.bIsCrouched @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;

		m_SubStateDebugInfoTag="UnCrouching";
		while(Pawn.bIsCrouched)
		{
			//if phyics is not walking make it so
			if( Pawn != None)
			{
				if( !Pawn.bCollideWorld )
				{
					Pawn.bCollideWorld=true;
					Pawn.SetPhysics(PHYS_Walking);
				}

			}

			//`log(" ChadAI - Pawn: " @ Pawn @ " UseFightingPosition standing because at low cover - bIsCrouched: " @ Pawn.bIsCrouched @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			;
			Pawn.UnCrouch();
			Sleep(0.0);
		}
	}

	HandleAtCoverCollisionChange( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos );

	//`log(" ChadAI - Pawn: " @ Pawn @ " UseFightingPosition::Begin() pawn before shift loc: " @ Pawn.Location @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	//ShiftPawnPositionBasedUponCoverAction( m_CoverMoveData.m_CurrentCover_Clamied, m_CoverFightData.m_CurrentCoverAction, CoverBehavior_Hiding);	

	//`log(" ChadAI - Pawn: " @ Pawn @ " UseFightingPosition::Begin() pawn after shift loc: " @ Pawn.Location @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	//`AILOG(0, 'Begin', "");
	m_CoverMoveData.m_TimeStartedUsingCurrentCover = WorldInfo.TimeSeconds;
	m_CoverFightData.m_bContinueToUseUseFightingPosition = true;
	m_CoverFightData.m_bUsingFightingPosition = true;
	m_CoverMoveData.m_TimeLastSubCoverBehaviorFinished= -1.0;
	
	SetAimAndHeadTrack();
	//Sleep a bit to avoid duplicate checks
	//Sleep(0.1f);
	
	//ResetPursueTimer();

	m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_CurrentlyUsing;

UseFightingPositionLoop:

	//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition Top of Loop DesiredRotation : " @ DesiredRotation.Yaw @ " - Pawn Rot: " @ Pawn.Rotation.Yaw @ "Pawn.DesiredRotation : " @ Pawn.DesiredRotation.Yaw @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	
	//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::UseFightingPositionLoop::-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	if( m_AttackUsingCoverGoalInfo.m_bUseCoverGroupTimer )
	{
		//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::Tick m_AttackUsingCoverGoalInfo.m_AmountOfTimeInCoverGroup: " @ m_AttackUsingCoverGoalInfo.m_AmountOfTimeInCoverGroup @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		// if negitive time stay in here for ever
		if( m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup > 0.0f )
		{
			if( (WorldInfo.TimeSeconds - m_AttackUsingCoverGoalInfo.m_TimeStartedInCoverGroup) > m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup )
			{
				while(( m_CoverMoveData.m_CoverTransitionAction != CoverTransitionAction_NotTransitioning ) &&
					( (WorldInfo.TimeSeconds - m_CoverFightData.m_TimeStartedLastCoverTransition) < class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_MaxTimeToWaitForCoverTransitionToEnd ) )
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPositionLoop Cover Group time is up but still transition so will wait until done -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
					;
					Sleep(0.0);
				}

				//`log(" ChadAI - TPSoldierAIController::Fire_From_Cover_Slot::Tick m_AttackUsingCoverGoalInfo.m_AmountOfTimeInCoverGroup >= m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
				;
				//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::Tick m_AttackUsingCoverGoalInfo.m_AmountOfTimeInCoverGroup >= m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
				m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
				m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_SucceededBecauseTimePassed;
				Goto('EndUseingCover');

			}
		}
	}


	if(m_CoverMoveData.m_TimeToUseCoverInSeconds >= 0.0 )
	{
		//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::UseFightingPositionLoop:: m_CoverMoveData.m_AmountOfTimeUsingCurrentCover >= m_CoverMoveData.m_TimeToUseCoverInSeconds -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		if( WorldInfo.TimeSeconds - m_CoverMoveData.m_TimeStartedUsingCurrentCover > m_CoverMoveData.m_TimeToUseCoverInSeconds )
		{
			//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::UseFightingPositionLoop:: WorldInfo.TimeSeconds - m_CoverMoveData.m_TimeStartedUsingCurrentCover >= m_CoverMoveData.m_TimeToUseCoverInSeconds -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			while(( m_CoverMoveData.m_CoverTransitionAction != CoverTransitionAction_NotTransitioning ) &&
				( (WorldInfo.TimeSeconds - m_CoverFightData.m_TimeStartedLastCoverTransition) < class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_MaxTimeToWaitForCoverTransitionToEnd ) )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPositionLoop TimeToUseCover is up but still transition so will wait until done -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
				;
				Sleep(0.03);
			}


			m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
			m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_SucceededBecauseTimePassed;
			;	
			Goto('EndUseingCover');
		}
	}

	if( Enemy != None )
	{

		if( DetermineIfShouldStartCQB_Latent( WorldInfo.TimeSeconds ) )
		{
			;

			//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPositionLoop EnemyIsInRange  m_RangeToStartCQB_State so popping to goal -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			
			m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_PausedEnemyIsAtCQB_Dist;

			PopState();

		}

		if( EnemyIsInRange( m_CoverFightData.m_MinDistanceToPlayerInCover ) )
		{
			;

			//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::UseFightingPositionLoop:: UseFightingPositionLoop  m_CoverFightData.m_MinDistanceToPlayerInCover -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			m_CoverFightData.m_bContinueToUseUseFightingPosition = false;

			m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedDistanceToEnemy;

		
			//`log(" ChadAI - Poping Defend Cover state because EnemyIsInRange( m_CoverFightData.m_MinDistanceToPlayerInCover )");
			PopState();
		}
		else if( DetermineIfGrenadeShouldBeAutoThrown() )
		{
			//`log(" ChadAI - Pawn " @ Pawn @ " TPSoldierAIController::UseFightingPosition::UseFightingPositionLoop::  DetermineIfGrenadeShouldBeThrown");
			;

			PushState('UseGrenadeAgainstEnemy');
		}
		else if( !IsAngleToEnemyValidForThisCoverSlot( m_CoverMoveData.m_CurrentCover_Clamied ) )
		{
			;

			//`log(" ChadAI - TPSoldierAIController::UseFightingPositionLoop:: !IsAngleToEnemyValidForThisCoverSlot Node: " @ m_IntermediateCoverInfo.m_CoverToSeek.Link @ " slot: " @m_IntermediateCoverInfo.m_CoverToSeek.SlotIdx @"-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			m_CoverFightData.m_bContinueToUseUseFightingPosition = false;

			m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedAngleToEnemy;

			PopState();
		}
	} // if( Enemy != None )

	// check to make sure at cover

	if( !IsAtCover(m_CoverFightData.m_CurrentlyCoverToUseAsFightPos, true ) )
	{
		;

// 		if( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link != None )
// 		{
// 			//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::Tick:: UseFightingPositionLoop  !IsAtCover(m_CoverFightData.m_CurrentlyCoverToUseAsFightPos) so move to it -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 			`AILOG(1, 'UseFightingPosition', "UseFightingPosition::UseFightingPositionLoop: Not at cover to defend Node: " @ m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link @ " slot: " @ m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.SlotIdx @ " So going to move back" );
// 
// 			MoveBackToCover();
// 
// 			if( !m_CoverFightData.m_bContinueToUseUseFightingPosition )
// 			{
// 				`AILOG(1, 'UseFightingPosition', "UseFightingPosition::UseFightingPositionLoop: failed to move back to cover to defend a So going back to parnent state Goal: " @ m_HighLevelAiGoal @ "!" );
// 				PopState();
// 			}
// 		}
// 		else
// 		{
// 			`log("Pawn: " @ Pawn @ "TPSoldierAIController::UseFightingPosition::Tick:: UseFightingPositionLoop  Not at cover to defend and I do not remember which one I am to defend So going back to parnent state -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 
// 			`AILOG(1, 'UseFightingPosition', "UseFightingPosition::UseFightingPositionLoop: Not at cover to defend and I do not remember which one I am to defend So going back to parnent state Goal: " @ m_HighLevelAiGoal @ "!" );
// 			PopState();
// 		}

		if ( m_CoverFightData.m_UseFightingPositionStatus != UseFightingPosition_PausedGrenadeOut )
		{
			;

			//`log("Pawn: " @ Pawn @ "TPSoldierAIController::UseFightingPosition::Tick:: UseFightingPositionLoop  Not at cover to defend and I do not remember which one I am to defend So going back to parnent state -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedBecauseForgotIt;
		}
		else
		{
			;

			//`log("Pawn: " @ Pawn @ " UseFightingPositionLoop  Not at cover to defend becuase I was responding to a grenade out so return to parnent state and get new orders -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		}

		PopState();

		//Sleep(0.1);
	}


	CheckForNodeSpecificSubBehavior();

	if( m_CoverMoveData.m_QueueOfScriptedCoverBehaviors.Length == 0 )
	{

		;


		//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPositionLoop::IsValidState()-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		//m_bDoIdle = true;
		//m_sleepTime = 0.2f;
		if	( Enemy != None )
		{
			 m_CoverMoveData.m_CoverState = GetEngageTheEnemyState();

			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition Just after GetEngageTheEnemyState- state: " @ m_CoverMoveData.m_CoverState @ " - DesiredRotation : " @ DesiredRotation.Yaw @ " - Pawn Rot: " @ Pawn.Rotation.Yaw @ "Pawn.DesiredRotation : " @ Pawn.DesiredRotation.Yaw @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


		 	;	
			//`log(" ChadAI - Pawn: " @ Pawn @ " UseFightingPositionLoop GetEngageTheEnemyState returned: " @ m_CoverMoveData.m_CoverState @ " m_CoverMoveData.m_CurrentCover_Clamied: " @ m_CoverMoveData.m_CurrentCover_Clamied.Link @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


			if( m_CoverMoveData.m_CoverState == CoverBehavior_Firing )
			{
				if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldStanding  )  && 
					( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldMidLevel ) &&
					( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldStandingAtCover ) &&
					m_Engagement_Tac_Data.m_bKnowBeingAimedAt && Pawn != None && Pawn.Weapon != None && TPWeapon(Pawn.Weapon) != None &&
					( TPWeapon(Pawn.Weapon).m_bCanBlindFireWithWith || TPWeapon(Pawn.Weapon).m_bShouldUseSnapShotInsteadOfBlindFire ) )
				{
				 	;	
					//PushState('BlindFire');
					m_CoverFightData.m_bBlindFire = true;
				}
				else
				{
					m_CoverFightData.m_bBlindFire = false;
				}

				//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition PushState('Fire_From_Cover_Slot')- DesiredRotation : " @ DesiredRotation.Yaw @ " - Pawn Rot: " @ Pawn.Rotation.Yaw @ "Pawn.DesiredRotation : " @ Pawn.DesiredRotation.Yaw @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				PushState('Fire_From_Cover_Slot');

			}
			else if( m_CoverMoveData.m_CoverState == CoverBehavior_Hiding )
			{
				if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType == CT_OpenFieldStanding  )  || 
					( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType == CT_OpenFieldMidLevel ))
				{
					if( m_CoverFightData.m_FirstSubBehaviorAtCover && m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType == CT_OpenFieldMidLevel)
					{
						//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition This is my first sub behavior at open field mid level and I need to do a Quick Hide -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

						;	

						PushState('HideBehindCurrentCover');

						//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition Back from first hide DesiredRotation : " @ DesiredRotation.Yaw @ " - Pawn Rot: " @ Pawn.Rotation.Yaw @ "Pawn.DesiredRotation : " @ Pawn.DesiredRotation.Yaw @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					}
					else if( !IsReloading() && !m_Engagement_Tac_Data.m_bNeedToReloadAtNextOpertunity )
					{
						//`log(" ChadAI - Pawn: " @ Pawn @ " UseFightingPositionLoop Told to hide but at an Open Field position and not reloading, so see if possible to step out -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		 				;	

						if( Enemy != None && ( RandRange(0.0,1.0) <= m_CoverFightData.m_ChanceToStepOutFromCoverToEngage)  )
						{
							Goto('CheckForStepOut');
						}
						else
						{
							PushState('HideBehindCurrentCover');
						}
					}
					else
					{
						//`log(" ChadAI - Pawn: " @ Pawn @ " UseFightingPositionLoop Told to hide but at an Open Field position and is reloading, so HIDE -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		 				;	

						PushState('HideBehindCurrentCover');
					}
				}
				else
				{
					PushState('HideBehindCurrentCover');
				}
				
			}
			else
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " UseFightingPositionLoop Not able to fire while at cover so see if can step out by calling GetRequiredMovementForEngagement -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		 		;	

				if( RandRange(0.0,1.0) <= m_CoverFightData.m_ChanceToStepOutFromCoverToEngage  )
				{
					Goto('CheckForStepOut');
				}
				else
				{

					;	
					m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_HidingToLooking;
					m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;

					PushState('LookForTargetFromCover');

					//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition Back from  fight Look DesiredRotation : " @ DesiredRotation.Yaw @ " - Pawn Rot: " @ Pawn.Rotation.Yaw @ "Pawn.DesiredRotation : " @ Pawn.DesiredRotation.Yaw @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


					if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_PausedEnemyIsAtCQB_Dist )
					{
						;
						//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " No Chance of CheckForStepOut back from LookForTargetFromCover  EnemyIsInRange  m_RangeToStartCQB_State so popping to goal -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
						PopState();
					}
					else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_FailedDistanceToEnemy )
					{
						;
						m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
						PopState();
					}
					else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_FailedAngleToEnemy )
					{
						;
						m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
						PopState();
					}

					m_CoverMoveData.m_CoverState = CoverBehavior_Hiding;

					//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition right BTansitioning Back to Hiding - DesiredRotation : " @ DesiredRotation.Yaw @ " - Pawn Rot: " @ Pawn.Rotation.Yaw @ "Pawn.DesiredRotation : " @ Pawn.DesiredRotation.Yaw @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					m_SubStateDebugInfoTag="Tansitioning Back to Hiding";

		 			//`AILOG(2, 'UseFightingPosition', "Back from Look for Target and Now going to wait m_TimeToStayBehindCoverAfterLookAndBeforeEngagement: " @ `TuneData.CoverEngagementTuneData.m_TimeToStayBehindCoverAfterLookAndBeforeEngagement);	

					while(( m_CoverMoveData.m_CoverTransitionAction != CoverTransitionAction_NotTransitioning ) &&
						( (WorldInfo.TimeSeconds - m_CoverFightData.m_TimeStartedLastCoverTransition) < class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_MaxTimeToWaitForCoverTransitionToEnd ) )
					{
						Sleep(0.0);

						if( DetermineIfShouldStartCQB_Latent( WorldInfo.TimeSeconds ) )
						{
							//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition::Transitioning from look m_RangeToStartCQB_State so poping state-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
							m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_PausedEnemyIsAtCQB_Dist;
							PopState();
						}

						if( EnemyIsInRange( m_CoverFightData.m_MinDistanceToPlayerInCover ) )
						{
							//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition::Transitioning from look  m_CoverFightData.m_MinDistanceToPlayerInCover -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
							m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
							m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedDistanceToEnemy;
							//`log(" ChadAI - LookForTargetFromCover::Tick Poping firing state because Enemy != None");
							PopState();
						}
						else if( !IsAngleToEnemyValidForThisCoverSlot( m_CoverMoveData.m_CurrentCover_Clamied ) )
						{
							//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition::Transitioning from look !IsAngleToEnemyValidForThisCoverSlot Node: " @ m_CoverMoveData.m_CurrentCover_Clamied.Link @ " slot: " @ m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx @"-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
							m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
							m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedAngleToEnemy;
							PopState();
						}
					}

					//`log(" ChadAI - Pawn: " @ Pawn @ " UseFightingPositionLoop - NOT ABLE TO FIRE LOOK - Back from Look for Target and Now going to wait m_TimeToStayBehindCoverAfterLookAndBeforeEngagement: " @ `TuneData.CoverEngagementTuneData.m_TimeToStayBehindCoverAfterLookAndBeforeEngagement @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition right Before Staying Hidden After Look DesiredRotation : " @ DesiredRotation.Yaw @ " - Pawn Rot: " @ Pawn.Rotation.Yaw @ "Pawn.DesiredRotation : " @ Pawn.DesiredRotation.Yaw @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					m_SubStateDebugInfoTag="Staying Hidden After Look";
					// after a look from cover hide for a little bit

					m_CoverFightData.m_TimeStartedToWaitAfterLookFromCover = WorldInfo.TimeSeconds;

					while( (WorldInfo.TimeSeconds - m_CoverFightData.m_TimeStartedToWaitAfterLookFromCover) <= class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TimeToStayBehindCoverAfterLookAndBeforeEngagement )
					{
						Sleep(0.0);
						if( DetermineIfShouldStartCQB_Latent( WorldInfo.TimeSeconds ) )
						{
							//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition::Transitioning from look m_RangeToStartCQB_State so poping state-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
							m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_PausedEnemyIsAtCQB_Dist;
							PopState();
						}

						if( EnemyIsInRange( m_CoverFightData.m_MinDistanceToPlayerInCover ) )
						{
							//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition::Transitioning from look  m_CoverFightData.m_MinDistanceToPlayerInCover -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
							m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
							m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedDistanceToEnemy;
							//`log(" ChadAI - LookForTargetFromCover::Tick Poping firing state because Enemy != None");
							PopState();
						}
						else if( !IsAngleToEnemyValidForThisCoverSlot( m_CoverMoveData.m_CurrentCover_Clamied ) )
						{
							//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition::Transitioning from look !IsAngleToEnemyValidForThisCoverSlot Node: " @ m_CoverMoveData.m_CurrentCover_Clamied.Link @ " slot: " @ m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx @"-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
							m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
							m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedAngleToEnemy;
							PopState();
						}
					}

				}
			}


			//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::UseFightingPositionLoop::EngageTheEnemy() Done-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		}// end if	( Enemy != None )
		else
		{
			;

			if( m_CoverFightData.m_FirstSubBehaviorAtCover )
			{
				;

				m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_NotTransitioning;
				PushState('HideBehindCurrentCover');
				Goto('UseFightingPositionLoop');
			}

			//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::UseFightingPositionLoop::DOES NOT HasValidEnemy()-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		
			if (!CheckForEnemy(false))
			{
				//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::UseFightingPositionLoop::!CheckForEnemy() NO ENEMY ACQUIRED-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::UseFightingPositionLoop LookForTargetFromCover -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				 ;	
				m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_HidingToLooking;
				m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;

				//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPositionLoop m_CoverMoveData.m_CoverTransitionAction = " @ m_CoverMoveData.m_CoverTransitionAction @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

								
				PushState('LookForTargetFromCover');

				//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition Back from first Look DesiredRotation : " @ DesiredRotation.Yaw @ " - Pawn Rot: " @ Pawn.Rotation.Yaw @ "Pawn.DesiredRotation : " @ Pawn.DesiredRotation.Yaw @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_PausedEnemyIsAtCQB_Dist )
				{
					;

					//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPositionLoop back from LookForTargetFromCover  EnemyIsInRange  m_RangeToStartCQB_State so popping to goal -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					PopState();
				}
				else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_FailedDistanceToEnemy )
				{

					;

					m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
				
					PopState();


				}
				else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_FailedAngleToEnemy )
				{
					;

					m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
	
					PopState();
				}		

				//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPositionLoop::Main Loop Back from Look for Target -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				m_CoverMoveData.m_CoverState = CoverBehavior_Hiding;

				//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition Back from first look and before Tansitioning Back to Hiding - DesiredRotation : " @ DesiredRotation.Yaw @ " - Pawn Rot: " @ Pawn.Rotation.Yaw @ "Pawn.DesiredRotation : " @ Pawn.DesiredRotation.Yaw @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


				m_SubStateDebugInfoTag="Tansitioning Back to Hiding";

		 		//`AILOG(2, 'UseFightingPosition', "Back from Look for Target and Now going to wait m_TimeToStayBehindCoverAfterLookAndBeforeEngagement: " @ `TuneData.CoverEngagementTuneData.m_TimeToStayBehindCoverAfterLookAndBeforeEngagement);	

				while(( m_CoverMoveData.m_CoverTransitionAction != CoverTransitionAction_NotTransitioning ) &&
					( (WorldInfo.TimeSeconds - m_CoverFightData.m_TimeStartedLastCoverTransition) < class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_MaxTimeToWaitForCoverTransitionToEnd ) )
				{
					Pawn.DesiredRotation = DesiredRotation;

// 					if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType	== CT_OpenFieldStanding  )  || 
//  					( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType == CT_OpenFieldMidLevel ) )
//  					{
//  						Pawn.SetPhysics(PHYS_None);
//  					}

					Sleep(0.0);

					if( DetermineIfShouldStartCQB_Latent( WorldInfo.TimeSeconds ) )
					{
						//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition::Transitioning from look m_RangeToStartCQB_State so poping state-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
						m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_PausedEnemyIsAtCQB_Dist;
						PopState();
					}

					if( EnemyIsInRange( m_CoverFightData.m_MinDistanceToPlayerInCover ) )
					{
						//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition::Transitioning from look  m_CoverFightData.m_MinDistanceToPlayerInCover -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
						m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
						m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedDistanceToEnemy;
						//`log(" ChadAI - LookForTargetFromCover::Tick Poping firing state because Enemy != None");
						PopState();
					}
					else if( !IsAngleToEnemyValidForThisCoverSlot( m_CoverMoveData.m_CurrentCover_Clamied ) )
					{
						//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition::Transitioning from look !IsAngleToEnemyValidForThisCoverSlot Node: " @ m_CoverMoveData.m_CurrentCover_Clamied.Link @ " slot: " @ m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx @"-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
						m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
						m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedAngleToEnemy;
						PopState();
					}
				}

				//`log(" ChadAI - Pawn: " @ Pawn @ " UseFightingPositionLoop - NOT ABLE TO FIRE LOOK - Back from Look for Target and Now going to wait m_TimeToStayBehindCoverAfterLookAndBeforeEngagement: " @ `TuneData.CoverEngagementTuneData.m_TimeToStayBehindCoverAfterLookAndBeforeEngagement @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition Back from first look and before Staying Hidden After Look - DesiredRotation : " @ DesiredRotation.Yaw @ " - Pawn Rot: " @ Pawn.Rotation.Yaw @ "Pawn.DesiredRotation : " @ Pawn.DesiredRotation.Yaw @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType	!= CT_OpenFieldStanding  )  && 
 					( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldMidLevel ) )
				{
					m_SubStateDebugInfoTag="Staying Hidden After Look";
					// after a look from cover hide for a little bit

					m_CoverFightData.m_TimeStartedToWaitAfterLookFromCover = WorldInfo.TimeSeconds;

					;

					while( (WorldInfo.TimeSeconds - m_CoverFightData.m_TimeStartedToWaitAfterLookFromCover) <= class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TimeToStayBehindCoverAfterLookAndBeforeEngagement )
					{
						Sleep(0.0);
						if( DetermineIfShouldStartCQB_Latent( WorldInfo.TimeSeconds ) )
						{
							//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition::Transitioning from look m_RangeToStartCQB_State so poping state-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
							m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_PausedEnemyIsAtCQB_Dist;
							PopState();
						}

						if( EnemyIsInRange( m_CoverFightData.m_MinDistanceToPlayerInCover ) )
						{
							//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition::Transitioning from look  m_CoverFightData.m_MinDistanceToPlayerInCover -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
							m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
							m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedDistanceToEnemy;
							//`log(" ChadAI - LookForTargetFromCover::Tick Poping firing state because Enemy != None");
							PopState();
						}
						else if( !IsAngleToEnemyValidForThisCoverSlot( m_CoverMoveData.m_CurrentCover_Clamied ) )
						{
							//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition::Transitioning from look !IsAngleToEnemyValidForThisCoverSlot Node: " @ m_CoverMoveData.m_CurrentCover_Clamied.Link @ " slot: " @ m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx @"-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
							m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
							m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedAngleToEnemy;
							PopState();
						}
					}	

					;

				}
				else
				{
					;
				}

				//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::UseFightingPositionLoop returned from LookForTargetFromCover -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

            }
            else
            {
				 ;	

        		//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::UseFightingPositionLoop::CheckForEnemy() ENEMY IS ACQUIRED-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			}

		}
		
	} // end if m_CoverInfo.m_ListOfScriptedCoverBehaviors.Length == 0
	else
	{
		PerformForcedCoverBehavior();
	}		

// 	if (m_bDoIdle)
// 	{
//    		//`log(" ChadAI - TPSoldierAIController::UseFightingPosition::UseFightingPositionLoop Ideling -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 
// 		//`AILOG(0, 'UseFightingPositionLoop', "do idle: accumulated time: "@m_accumulatedTime@" timetowait: "@m_timeToWait@" sleeptime: "@m_sleepTime);
// 		//just idle...
// 		Target = None;
// 		StopFiring();
// 		Sleep(m_sleepTime);
// 		m_accumulatedTime += m_sleepTime;
// 	}
		


	if( m_CoverFightData.m_bContinueToUseUseFightingPosition )
	{
		//Sleep(0.0);

		//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition End of loo[ DesiredRotation : " @ DesiredRotation.Yaw @ " - Pawn Rot: " @ Pawn.Rotation.Yaw @ "Pawn.DesiredRotation : " @ Pawn.DesiredRotation.Yaw @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		Goto('UseFightingPositionLoop');
	}
	
	 ;	

	Goto('EndUseingCover');

CheckForStepOut:

	;


	m_Engagement_Tac_Data.m_MoveNeed2Kill = GetRequiredMovementForEngagement(	Enemy,
																				Vector(m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link.GetSlotRotation(m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.SlotIdx)),
																				m_Engagement_Tac_Data.m_SideStepTargetMoveLoc,
																				true);

	;	
	//`log(" ChadAI - Pawn: " @ Pawn @ " UseFightingPositionLoop lets try and see if there is a rand chance: " @ m_CoverFightData.m_ChanceToStepOutFromCoverToEngage @ "  for: " @ m_Engagement_Tac_Data.m_MoveNeed2Kill @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


	if( m_Engagement_Tac_Data.m_MoveNeed2Kill == RequiredMove4Engage_None )
	{
		;	
		Goto('EndUseingCover');
	}


	if( (m_Engagement_Tac_Data.m_MoveNeed2Kill != RequiredMove4Engage_Travel) /*&& 
		( RandRange(0.0,1.0) <= m_CoverFightData.m_ChanceToStepOutFromCoverToEngage  ) */)
	{
		if ( KynapseCanGoStraight(m_Engagement_Tac_Data.m_SideStepTargetMoveLoc) )
		{
			;

			while(( m_CoverMoveData.m_CoverTransitionAction != CoverTransitionAction_NotTransitioning ) &&
				( (WorldInfo.TimeSeconds - m_CoverFightData.m_TimeStartedLastCoverTransition) < class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_MaxTimeToWaitForCoverTransitionToEnd ) )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPositionLoop CheckForStepOut want to step out but still finishing Transition so wait -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
				;
				if( DetermineIfShouldStartCQB_Latent( WorldInfo.TimeSeconds ) )
				{
					//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition::CheckForStepOut:Transitioning from look m_RangeToStartCQB_State so poping state-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_PausedEnemyIsAtCQB_Dist;
					PopState();
				}

				if( EnemyIsInRange( m_CoverFightData.m_MinDistanceToPlayerInCover ) )
				{
					//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition::CheckForStepOut:Transitioning from look  m_CoverFightData.m_MinDistanceToPlayerInCover -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
					m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedDistanceToEnemy;
					//`log(" ChadAI - LookForTargetFromCover::Tick Poping firing state because Enemy != None");
					PopState();
				}
				else if( !IsAngleToEnemyValidForThisCoverSlot( m_CoverMoveData.m_CurrentCover_Clamied ) )
				{
					//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition::CheckForStepOut:Transitioning from look !IsAngleToEnemyValidForThisCoverSlot Node: " @ m_CoverMoveData.m_CurrentCover_Clamied.Link @ " slot: " @ m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx @"-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
					m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedAngleToEnemy;
					PopState();
				}

				Sleep(0.03);
			}

			PushState('StepOutFromCoverAndFire');
		}
		else
		{
			;
			KynapseClear();
			InvalidateThisSliceThePieTacStepLocation(m_Engagement_Tac_Data.m_MoveNeed2Kill);
			Sleep(0.0);
			Goto('CheckForStepOut');
		}
	}
	else 
	{
		;	
		m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_HidingToLooking;
		m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;

		PushState('LookForTargetFromCover');

		if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_PausedEnemyIsAtCQB_Dist )
		{
			;
			//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " CheckForStepOut back from LookForTargetFromCover  EnemyIsInRange  m_RangeToStartCQB_State so popping to goal -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			PopState();
		}
		else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_FailedDistanceToEnemy )
		{
			;
			m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
			PopState();
		}
		else if( m_CoverFightData.m_UseFightingPositionStatus == UseFightingPosition_FailedAngleToEnemy )
		{
			;
			m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
			PopState();
		}

		m_CoverMoveData.m_CoverState = CoverBehavior_Hiding;

		m_SubStateDebugInfoTag="Staying Hidden After Look";

		while(( m_CoverMoveData.m_CoverTransitionAction != CoverTransitionAction_NotTransitioning ) &&
			( (WorldInfo.TimeSeconds - m_CoverFightData.m_TimeStartedLastCoverTransition) < class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_MaxTimeToWaitForCoverTransitionToEnd ) )
		{
			Sleep(0.0);

			if( DetermineIfShouldStartCQB_Latent( WorldInfo.TimeSeconds ) )
			{
				//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition::CheckForStepOut:Transitioning from look m_RangeToStartCQB_State so poping state-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_PausedEnemyIsAtCQB_Dist;
				PopState();
			}

			if( EnemyIsInRange( m_CoverFightData.m_MinDistanceToPlayerInCover ) )
			{
				//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition::CheckForStepOut:Transitioning from look  m_CoverFightData.m_MinDistanceToPlayerInCover -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
				m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedDistanceToEnemy;
				//`log(" ChadAI - LookForTargetFromCover::Tick Poping firing state because Enemy != None");
				PopState();
			}
			else if( !IsAngleToEnemyValidForThisCoverSlot( m_CoverMoveData.m_CurrentCover_Clamied ) )
			{
				//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition::CheckForStepOut:Transitioning from look !IsAngleToEnemyValidForThisCoverSlot Node: " @ m_CoverMoveData.m_CurrentCover_Clamied.Link @ " slot: " @ m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx @"-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
				m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedAngleToEnemy;
				PopState();
			}
		}

		//`log(" ChadAI - Pawn: " @ Pawn @ " UseFightingPositionLoop - NOT ABLE TO FIRE LOOK - Back from Look for Target and Now going to wait m_TimeToStayBehindCoverAfterLookAndBeforeEngagement: " @ `TuneData.CoverEngagementTuneData.m_TimeToStayBehindCoverAfterLookAndBeforeEngagement @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		m_SubStateDebugInfoTag="Staying Hidden After Look";
		// after a look from cover hide for a little bit

		m_CoverFightData.m_TimeStartedToWaitAfterLookFromCover = WorldInfo.TimeSeconds;

		while( (WorldInfo.TimeSeconds - m_CoverFightData.m_TimeStartedToWaitAfterLookFromCover) <= class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TimeToStayBehindCoverAfterLookAndBeforeEngagement )
		{
			Sleep(0.0);
			if( DetermineIfShouldStartCQB_Latent( WorldInfo.TimeSeconds ) )
			{
				//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition::CheckForStepOut:Transitioning from look m_RangeToStartCQB_State so poping state-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_PausedEnemyIsAtCQB_Dist;
				PopState();
			}

			if( EnemyIsInRange( m_CoverFightData.m_MinDistanceToPlayerInCover ) )
			{
				//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition::CheckForStepOut:Transitioning from look  m_CoverFightData.m_MinDistanceToPlayerInCover -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
				m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedDistanceToEnemy;
				//`log(" ChadAI - LookForTargetFromCover::Tick Poping firing state because Enemy != None");
				PopState();
			}
			else if( !IsAngleToEnemyValidForThisCoverSlot( m_CoverMoveData.m_CurrentCover_Clamied ) )
			{
				//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " UseFightingPosition::CheckForStepOut:Transitioning from look !IsAngleToEnemyValidForThisCoverSlot Node: " @ m_CoverMoveData.m_CurrentCover_Clamied.Link @ " slot: " @ m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx @"-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
				m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedAngleToEnemy;
				PopState();
			}
		}
	}

	Sleep(0.0);
	Goto('UseFightingPositionLoop');

EndUseingCover:
	//m_CoverMoveData.m_CoverState = CoverBehavior_Looking;
	m_CoverMoveData.m_CoverState = CoverBehavior_Hiding;
	;

	PopState();


	//wait a bit to avoid duplication of checks in a single frame...
	Sleep(0.0f);

	//`AILOG(0, 'CoverAttackLoop', "evaluate situation");
	;
	;
	;
	;
	;
	;
	;
	;
	;
	;
	;
	;
	;
	;

	;
	EvaluateSituation();
}

//-----------------------------------------------------------------------
// State:	LookForTargetFromCover
// Description: Generic state for either peeking up over cover or around cover
// to look for an enemy
//-----------------------------------------------------------------------
state LookForTargetFromCover
{

	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
	
		//`log(" ChadAI - " @ self @ "LookForTargetFromCover::OnSeeEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
	
		// acquire as a new enemy and evaluate the situation
		CheckForEnemy(false);
	}
	
	event OnHearEnemy(int playerIdx)
	{
		//`log(" ChadAI - " @ self @ "LookForTargetFromCover::OnHearEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		CheckForEnemy(false);		
	}

	function BeginState(Name PreviousStateName)
	{
		;
	}
	

	function EndState(Name NextStateName)
	{
		;	

		//HandleLeftCoverCollisionChange( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos );
// 		if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType	== CT_OpenFieldStanding  )  || 
//  					( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType == CT_OpenFieldMidLevel ) )
// 		{
// 			Pawn.SetPhysics(PHYS_Walking);
// 		}
	}

	event PushedState()
	{
		;
	}
	
	event PausedState()
	{
		;

		//HandleLeftCoverCollisionChange( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos );

	}

	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " LookForTargetFromCover::NotifyTakeHit -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		if( IsValidEnemyController(InstigatedBy, TRUE) )
		{
			//`log(" ChadAI - Pawn: " @Pawn@" LookForTargetFromCover::NotifyTakeHit InstigatedBy: " @ InstigatedBy.Pawn @ " and is an Enemy Duh so test for LOF -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");		
			if( CanFireAtFromCover( InstigatedBy.Pawn, m_CoverMoveData.m_CurrentCover_Clamied ) )
			{ 
				;
				//`log(" ChadAI - Pawn: " @Pawn@" LookForTargetFromCover::NotifyTakeHit InstigatedBy: " @ InstigatedBy.Pawn @ " and is an Enemy and has LOF so make current enemy and end wander -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");		
				Enemy = InstigatedBy.Pawn;
				m_enemyIdx = GetPlayerIdx(Enemy.Controller);

				PopState();
			}
			else
			{
				;

				//`log(" ChadAI - Pawn: " @Pawn@" LookForTargetFromCover::NotifyTakeHit InstigatedBy: " @ InstigatedBy.Pawn @ " and is an Enemy but does not have LOF so keep looking-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");		
			}
		}

		Super.NotifyTakeHit(InstigatedBy,HitLocation,Damage,damageType,Momentum);		
	}


	event PoppedState()
	{
		;

// 		if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType	== CT_OpenFieldStanding  )  || 
//  					( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType == CT_OpenFieldMidLevel ) )
// 		{
// 			Pawn.SetPhysics(PHYS_Walking);
// 		}

		//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " LookForTargetFromCoverPoppedState DesiredRotation : " @ DesiredRotation.Yaw @ " - Pawn Rot: " @ Pawn.Rotation.Yaw @ "Pawn.DesiredRotation : " @ Pawn.DesiredRotation.Yaw @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


		//HandleLeftCoverCollisionChange( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos );
	}

	event ContinuedState()
	{
		;

		HandleAtCoverCollisionChange( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos );

		if( !IsAtCover(m_CoverMoveData.m_CurrentCover_Clamied, false ) )
		{
			PopState();
		}
	}
	
    function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		// do nothing for now
		//`log(" ChadAI - TPSoldierAIController::LookForTargetFromCover::NotifyWeaponFired  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		StopFiring();
    }	
	
	event Tick( float DeltaTime )
	{
		TestForValidAttackFromCoverTarget();

		//UpdateAimAtCover();
		UpdateHeadtracking();

		Super.Tick(DeltaTime);
	}

// 	function ShowAllPlayerListMemebers()
// 	{
// 		local int i;
// 		for( i = 0; i < m_playerList.Length; i++ )
// 		{
// 			//`log(" ChadAI -ShowAllPlayerListMemebers No: " @ i @ " Known Player: " @  m_playerList[i].Player.Pawn @ " Is Enemy: " @ !m_playerList[i].bFriendly @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
// 
// 		}
// 	}

Begin:

	m_SubStateDebugInfoTag="Begin";

	Target = None;

	//`log(" ChadAI - TPSoldierAIController::LookForTargetFromCover::Begin  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	//`log(" ChadAI -

	m_CoverMoveData.m_CoverState = CoverBehavior_Looking;
	m_CoverMoveData.m_TimeStartedLookingForTargetSinceLastEngageAttempt = WorldInfo.TimeSeconds;

	//Pawn.SetMovementPhysics();

	//m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_HidingToLooking;
	
	//m_CoverFightData.m_CurrentCoverAction = CA_LeanRight;
	//`log(" ChadAI - TPSoldierAIController::LookForTargetFromCover::Begin  SetCoverAction Getting Called -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	SetCoverAction(m_CoverMoveData.m_CurrentCover_Clamied, false);

	HandleAtCoverCollisionChange( m_CoverMoveData.m_CurrentCover_Clamied );

	//ShiftPawnPositionBasedUponCoverAction( m_CoverMoveData.m_CurrentCover_Clamied, m_CoverFightData.m_CurrentCoverAction, CoverBehavior_Looking);	

	//`log(" ChadAI - Pawn: " @ Pawn @ " LookForTargetFromCover::Begin() pawn loc: " @ Pawn.Location @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

LookForTargetFromCoverLoop:

	m_SubStateDebugInfoTag="Top of Loop - " @ (WorldInfo.TimeSeconds - m_CoverMoveData.m_TimeStartedLookingForTargetSinceLastEngageAttempt) @ " -> " @ m_CoverMoveData.m_CurrentDurationOfLookingForTargetBeforeEngageAttempt @ " No Known: " @ m_playerList.Length;

	//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " LookForTargetFromCover::Main Loop Top:: m_playerList.Length: " @ m_playerList.Length @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	//ShowAllPlayerListMemebers();

	StopFiring();


	if( Enemy != None )
	{
		//`AILOG(0, 'Begin', "Turn towards target");
		// turn towards our target
		//StopFiring();
		Target = Enemy;
		Focus = Target;

		
		// wait til the turn is finished
		m_SubStateDebugInfoTag="Turning to Target";

// 		if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldStanding  )  && 
// 			( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldMidLevel ) )
// 		{
			;

			DesiredRotation = rotator(Focus.Location - Pawn.Location);
			DesiredRotation.Pitch = 0;
			Pawn.DesiredRotation = DesiredRotation;

			//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " LookForTargetFromCover::Main Loop DesiredRotation before rot logic: " @ DesiredRotation.Yaw @ " - Pawn Rot: " @ Pawn.Rotation.Yaw @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


			//Rotate Pawn Slowly to face in the right direction
			if( !ReachedDesiredRotationAtCoverAndSetRotDirection(TRUE, m_CoverMoveData.m_CurrentCover_Clamied) )
			{
				//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " LookForTargetFromCover::Main Loop Has not reached desired rot m_bSlowRotRight: " @ m_CoverFightData.m_bSlowRotRight @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

// 				if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType	== CT_OpenFieldStanding  )  || 
//  					( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType == CT_OpenFieldMidLevel ) )
//  				{
//  					Pawn.SetPhysics(PHYS_None);
//  				}

				if( m_CoverFightData.m_bSlowRotRight )
				{
					Pawn.DesiredRotation.Yaw = Pawn.Rotation.Yaw +  (	Pawn.bIsCrouched ?
																		class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateCrouchedAtCoverPerHertz : 
																		class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateStandAtCoverPerHertz );
					Pawn.DesiredRotation.Pitch = 0;
					//Pawn.DesiredRotation = Pawn.DesiredRotation;
					
				}
				else
				{
					Pawn.DesiredRotation.Yaw = Pawn.Rotation.Yaw -  (	Pawn.bIsCrouched ?
																		class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateCrouchedAtCoverPerHertz : 
																		class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateStandAtCoverPerHertz );
					Pawn.DesiredRotation.Pitch = 0;
					//Pawn.DesiredRotation = Pawn.DesiredRotation;
				}

				//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " LookForTargetFromCover::Main Loop DesiredRotation after first part rot logic: " @ DesiredRotation.Yaw @ "  - Pawn Rot: " @ Pawn.Rotation.Yaw @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				Pawn.SetRotation( Pawn.DesiredRotation );

// 				if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldStanding  )  && 
// 					( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldMidLevel ) )
// 				{
// 					Pawn.SetRotation( Pawn.DesiredRotation );
// 				}
// 				else
// 				{
// 					FinishRotation();
// 				}

				//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " LookForTargetFromCover::Main Loop DesiredRotation after last part rot logic: " @ DesiredRotation.Yaw @ "  - Pawn Rot: " @ Pawn.Rotation.Yaw @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


				if( DoINeedToSlideIntoTheSlot( m_CoverMoveData.m_CurrentCover_Clamied ) )
				{
					SlideMeALIttleBitFatherIntoTheSlot(class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_DistToSlideIntoCoverWhileInCoverPerUpdate, m_CoverMoveData.m_CurrentCover_Clamied);
					//Sleep(0.0);
				}

				/*if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType	== CT_OpenFieldStanding  )  || 
 					( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType == CT_OpenFieldMidLevel ) )
 				{
 					Pawn.SetPhysics(PHYS_Walking);
 				}*/

				//Sleep(0.0);
			}

// 		}
// 		else
// 		{
// 			`AILOG(2, 'LookForTargetFromCover',"Main Loop - At Open Cover and has enemy so need to turn to them, so FinishRotation to it");
// 
// 			DesiredRotation = rotator(Focus.Location - Pawn.Location);
// 			DesiredRotation.Pitch = 0;
// 			FinishRotation();
// 		}

		// preserve the new orientation and stop turning
		//PreserveRotation();
		Focus = none;
	}
	else
	{
		// face in the direction of the cover slot
// 		if( Abs(m_CoverMoveData.m_CurrentCover_Clamied.Link.GetSlotRotation(m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx).Yaw - Pawn.Rotation.Yaw) > 600 )
// 		{
			m_SubStateDebugInfoTag="Turning to Cover Dir";

// 			if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldStanding  )  && 
// 				( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldMidLevel ) )
// 			{
				;

				DesiredRotation = m_CoverMoveData.m_CurrentCover_Clamied.Link.GetSlotRotation(m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx);
				DesiredRotation.Pitch = 0;
				Pawn.DesiredRotation = DesiredRotation;

			//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " LookForTargetFromCover::Main Loop Slot Rot: " @ m_CoverMoveData.m_CurrentCover_Clamied.Link.GetSlotRotation(m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx).Yaw @ " - Pawn Rot: " @ Pawn.Rotation.Yaw @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " LookForTargetFromCover::Main Loop DesiredRotation before rot logic: " @ DesiredRotation.Yaw @ " - Pawn Rot: " @ Pawn.Rotation.Yaw @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


			//Rotate Pawn Slowly to face in the right direction
			if( !ReachedDesiredRotationAtCoverAndSetRotDirection(FALSE, m_CoverMoveData.m_CurrentCover_Clamied) )
			{
// 				if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType	== CT_OpenFieldStanding  )  || 
//  					( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType == CT_OpenFieldMidLevel ) )
//  				{
//  					Pawn.SetPhysics(PHYS_None);
//  				}

				//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " LookForTargetFromCover::Main Loop Has not reached desired rot m_bSlowRotRight: " @ m_CoverFightData.m_bSlowRotRight @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				if( m_CoverFightData.m_bSlowRotRight )
				{
					Pawn.DesiredRotation.Yaw = Pawn.Rotation.Yaw +  (	Pawn.bIsCrouched ?
																		class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateCrouchedAtCoverPerHertz : 
																		class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateStandAtCoverPerHertz );
					Pawn.DesiredRotation.Pitch = 0;
					//Pawn.DesiredRotation = Pawn.DesiredRotation;
					
				}
				else
				{
					Pawn.DesiredRotation.Yaw = Pawn.Rotation.Yaw -  (	Pawn.bIsCrouched ?
																		class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateCrouchedAtCoverPerHertz : 
																		class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateStandAtCoverPerHertz );
					Pawn.DesiredRotation.Pitch = 0;
					//Pawn.DesiredRotation = Pawn.DesiredRotation;
				}

				//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " LookForTargetFromCover::Main Loop DesiredRotation after first part rot logic: " @ DesiredRotation.Yaw @ "  - Pawn Rot: " @ Pawn.Rotation.Yaw @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				Pawn.SetRotation( Pawn.DesiredRotation );

// 				if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldStanding  )  && 
// 					( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldMidLevel ) )
// 				{
// 					Pawn.SetRotation( Pawn.DesiredRotation );
// 				}
// 				else
// 				{
// 					FinishRotation();
// 				}

				//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " LookForTargetFromCover::Main Loop DesiredRotation after last part rot logic: " @ DesiredRotation.Yaw @ "  - Pawn Rot: " @ Pawn.Rotation.Yaw @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


				if( DoINeedToSlideIntoTheSlot( m_CoverMoveData.m_CurrentCover_Clamied ) )
				{
					SlideMeALIttleBitFatherIntoTheSlot(class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_DistToSlideIntoCoverWhileInCoverPerUpdate, m_CoverMoveData.m_CurrentCover_Clamied);
					//Sleep(0.0);
				}

// 				if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType	== CT_OpenFieldStanding  )  || 
//  					( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType == CT_OpenFieldMidLevel ) )
//  				{
//  					Pawn.SetPhysics(PHYS_Walking);
//  				}

				//Sleep(0.0);
			}


				//Pawn.SetRotation( DesiredRotation );			
// 			}
// 			else
// 			{
// 				`AILOG(2, 'LookForTargetFromCover',"Main Loop - At Open Cover and has no enemy so need to turn in the cover slot dir, so FinishRotation to it");
// 
// 				DesiredRotation = m_CoverMoveData.m_CurrentCover_Clamied.Link.GetSlotRotation(m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx);
// 				DesiredRotation.Pitch = 0;
// 				Pawn.DesiredRotation = DesiredRotation;
// 				FinishRotation();
// 			}
		//}
	}

	m_SubStateDebugInfoTag="Seeing it Time is Up";

	if( m_AttackUsingCoverGoalInfo.m_bUseCoverGroupTimer && (m_CoverMoveData.m_CoverTransitionAction == CoverTransitionAction_NotTransitioning))
	{

		//`log(" ChadAI - TPSoldierAIController::LookForTargetFromCover::Tick m_AttackUsingCoverGoalInfo.m_AmountOfTimeInCoverGroup: " @ m_AttackUsingCoverGoalInfo.m_AmountOfTimeInCoverGroup @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		// if negitive time stay in here for ever
		if( m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup > 0.0f )
		{
			if( (WorldInfo.TimeSeconds - m_AttackUsingCoverGoalInfo.m_TimeStartedInCoverGroup) > m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup )
			{
				//`log(" ChadAI - TPSoldierAIController::LookForTargetFromCover::Tick m_AttackUsingCoverGoalInfo.m_AmountOfTimeInCoverGroup >= m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
				;
				//`log(" ChadAI - TPSoldierAIController::LookForTargetFromCover::Tick m_AttackUsingCoverGoalInfo.m_AmountOfTimeInCoverGroup >= m_AttackUsingCoverGoalInfo.m_AmountOfTimeToStayInCoverGroup -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
				if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType	!= CT_OpenFieldStanding  )  &&
 					( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldMidLevel ) )
				{
					m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_LookingToHiding;
					m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;
				}

				//m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_LookingToHiding;
				//m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;
				PopState();
			}
		}
	}

	if( m_CoverMoveData.m_TimeToUseCoverInSeconds >= 0.0 && (m_CoverMoveData.m_CoverTransitionAction == CoverTransitionAction_NotTransitioning) )
	{
		//`log(" ChadAI - TPSoldierAIController::LookForTargetFromCover::UseFightingPositionLoop:: m_CoverMoveData.m_AmountOfTimeUsingCurrentCover >= m_CoverMoveData.m_TimeToUseCoverInSeconds -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		if( WorldInfo.TimeSeconds - m_CoverMoveData.m_TimeStartedUsingCurrentCover > m_CoverMoveData.m_TimeToUseCoverInSeconds )
		{
				m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
				m_CoverMoveData.m_CoverState = CoverBehavior_Hiding;

				if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType	!= CT_OpenFieldStanding  )  &&
 					( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldMidLevel ) )
				{
					m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_LookingToHiding;
					m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;
				}

				//m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_LookingToHiding;
				//m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;
				m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_SucceededBecauseTimePassed;
			;	
			PopState();
		}
	}
		
	if( Enemy != None )
	{
		//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " LookForTargetFromCover::Main Loop:: Enemy != None so checking CQB -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		if( DetermineIfShouldStartCQB_Latent( WorldInfo.TimeSeconds ) )
		{
			//`log(" ChadAI - TPSoldierAIController::LookForTargetFromCover::Tick:: EnemyIsInRange  m_RangeToStartCQB_State so poping state-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_PausedEnemyIsAtCQB_Dist;

			PopState();
		}

		if( EnemyIsInRange( m_CoverFightData.m_MinDistanceToPlayerInCover ) )
		{
			//`log(" ChadAI - TPSoldierAIController::LookForTargetFromCover::Tick:: EnemyIsInRange  m_CoverFightData.m_MinDistanceToPlayerInCover -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
			m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedDistanceToEnemy;

			
			//`log(" ChadAI - LookForTargetFromCover::Tick Poping firing state because Enemy != None");
			PopState();
		}
		else if( !IsAngleToEnemyValidForThisCoverSlot( m_CoverMoveData.m_CurrentCover_Clamied ) )
		{
			//`log(" ChadAI - TPSoldierAIController::LookForTargetFromCover::Tick:: !IsAngleToEnemyValidForThisCoverSlot Node: " @ m_CoverMoveData.m_CurrentCover_Clamied.Link @ " slot: " @m_IntermediateCoverInfo.m_CoverToSeek.SlotIdx @"-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			m_CoverFightData.m_bContinueToUseUseFightingPosition = false;
			m_CoverFightData.m_UseFightingPositionStatus = UseFightingPosition_FailedAngleToEnemy;

			PopState();
		}
	}		
		

		//`log(" ChadAI - TPSoldierAIController::LookForTargetFromCover::Tick m_CoverMoveData.m_AmountOfTimeUsingCurrentCover: " @ m_CoverMoveData.m_AmountOfTimeUsingCurrentCover @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		
		
	if( (m_CoverMoveData.m_CoverTransitionAction == CoverTransitionAction_NotTransitioning) && ( (WorldInfo.TimeSeconds - m_CoverMoveData.m_TimeStartedLookingForTargetSinceLastEngageAttempt) > m_CoverMoveData.m_CurrentDurationOfLookingForTargetBeforeEngageAttempt ) )
	{
		//`log(" ChadAI - LookForTargetFromCover::Tick Poping Looking for targets state because of time");
		;

		m_CoverMoveData.m_CoverState = CoverBehavior_Hiding;
		//m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_LookingToHiding;
		//m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;

		if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType	!= CT_OpenFieldStanding  )  &&
			( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldMidLevel ) )
		{
			m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_LookingToHiding;
			m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;
		}

		//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " LookForTargetFromCoverLoop m_CoverMoveData.m_CoverTransitionAction = " @ m_CoverMoveData.m_CoverTransitionAction @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	


		PopState();
	}

	if( CanFireAtEnemyFrom(m_CoverMoveData.m_CurrentCover_Clamied, true) )
	{
		if(m_CoverMoveData.m_CoverTransitionAction == CoverTransitionAction_NotTransitioning)
		{
			;
	
			//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " LookForTargetFromCover::Main Loop - I can fire at the enemy from this cover now and am done with the transition so I should end looking for target-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			//m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_LookingToHiding;
			//m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;
			if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType	!= CT_OpenFieldStanding  )  &&
				( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldMidLevel ) )
			{
				m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_LookingToHiding;
				m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;
			}
			PopState();
		}
		else
		{
			;
			//`log(" ChadAI -Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " LookForTargetFromCover::Main Loop - I can fire at the enemy from this cover now But I am not done with the transition so wait to end -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		}
	}

	m_SubStateDebugInfoTag="End of Loop No Shot- " @ (WorldInfo.TimeSeconds - m_CoverMoveData.m_TimeStartedLookingForTargetSinceLastEngageAttempt) @ " -> " @ m_CoverMoveData.m_CurrentDurationOfLookingForTargetBeforeEngageAttempt;

	// if my current enemy is grappled remove him from being my enemy
	if( Enemy != None && Enemy.Controller != None )
	{
		if( TPAIController(Enemy.Controller) != None )
		{
			if( TPAIController(Enemy.Controller).m_bGrappled )
			{
				Enemy = None;
			}
		}

	}

	Sleep(0.0);

Goto('LookForTargetFromCoverLoop');
	
}

native function DoSniperAimStuff();
native function CalcTrackSnipersTargetAimLocation( float DeltaTime );
native function CalcPinPointSnipersTargetAimLocation( float DeltaTime );

//-----------------------------------------------------------------------
// Function:
// Description:	Goes through all know players and if enemy tries to acquire them if in sniper acquire range
// if first found not targetible will continue to search
//-----------------------------------------------------------------------
native function bool TestForValidSniperTarget();

//-----------------------------------------------------------------------
// State:	LookForSniperTarget
// Description: 
//-----------------------------------------------------------------------
state LookForSniperTarget
{
	function BeginState(Name PreviousStateName)
	{
		;

		//`log(" ChadAI - TPSoldierAIController::LookForSniperTarget::BeginState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
	}


	event PoppedState()
	{
		;

		//`log(" ChadAI - TPSoldierAIController::LookForSniperTarget::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		m_SniperInfo.m_bCurrentlySniping = false;
	}
	
	event PausedState()
	{
		;

		//`log(" ChadAI - TPSoldierAIController::LookForSniperTarget::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		m_SniperInfo.m_bCurrentlySniping = false;
	}

	event PushedState()
	{
		;

		//`log(" ChadAI - TPSoldierAIController::LookForSniperTarget::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		m_SniperInfo.m_bCurrentlySniping = true;	
	}

	event ContinuedState()
	{
		;

		//`log(" ChadAI - TPSoldierAIController::LookForSniperTarget::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		m_SniperInfo.m_bCurrentlySniping = true;	
	}
	
	function EndState(Name NextStateName)
	{
		;

		//`log(" ChadAI - TPSoldierAIController::LookForSniperTarget::EndState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	
		m_SniperInfo.m_bCurrentlySniping = false;	
	}
	
    function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		// do nothing for now
		//`log(" ChadAI - TPSoldierAIController::LookForSniperTarget::NotifyWeaponFired  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		
    }
    
	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
		//local int newEnemyIdx;
		local float rangeToTarget;
		
		//`log(" ChadAI - SENSING - " @ self @ "LookForSniperTarget::OnSeeEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");		
	
		// check to see if this target is in range
		
		rangeToTarget = VSizeSq( m_playerList[playerIdx].Player.Pawn.Location - TargetAimLocation );
		
		//`log(" ChadAI - SENSING - LookForSniperTarget::OnSeeEnemy the range to the target is: " @ rangeToTarget @ " and Target Acquire Range is: " @ m_SniperInfo.m_TargetAcquireRange @ " -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");		
		
		
		if( rangeToTarget < m_SniperInfo.m_TargetAcquireRange * m_SniperInfo.m_TargetAcquireRange )
		{
			//`log(" ChadAI - SENSING - LookForSniperTarget::OnSeeEnemy FOUND A TARGET: " @ m_playerList[playerIdx].Player @ "-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");		
			if( AcquireEnemy(playerIdx) )
			{
				//Enemy = m_playerList[playerIdx].Player.Pawn;
				
				PopState();
			}
		}
	}

	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " LookForSniperTarget::NotifyTakeHit m_bTookHitWhilePursuing set to true -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		if( IsValidEnemyController(InstigatedBy, TRUE) )
		{
			//`log(" ChadAI - SENSING - Pawn: " @Pawn@" LookForSniperTarget::NotifyTakeHit InstigatedBy: " @ InstigatedBy.Pawn @ " and is an Enemy Duh so test for LOS -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");		
			if( CanFireAtNotFromCover( InstigatedBy.Pawn, true ) )
			{
				;
				//`log(" ChadAI - SENSING - Pawn: " @Pawn@" LookForSniperTarget::NotifyTakeHit InstigatedBy: " @ InstigatedBy.Pawn @ " and is an Enemy and has LOS so make current enemy and end wander -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");		
				Enemy = InstigatedBy.Pawn;

				m_enemyIdx = GetPlayerIdx(Enemy.Controller);

				PopState();
			}
			else
			{
				;

				//`log(" ChadAI - SENSING - Pawn: " @Pawn@" LookForSniperTarget::NotifyTakeHit InstigatedBy: " @ InstigatedBy.Pawn @ " and is an Enemy but does not have LOS so end wander and freak out -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");		
			}
		}

		Super.NotifyTakeHit(InstigatedBy,HitLocation,Damage,damageType,Momentum);		
	}
    
	function UpdateSnipersAim( float DeltaTime )
	{
		local vector viewPoint;
		local vector dirTrack, p1,p2,p3,p4,p5,p6,p7,p8, perp1, perp2;
		local float rangeLook;
		local int nodeCount;
		//local vector midpointOfTrack;
		//local vector extentOfTrackBox;
		
		//`log(" ChadAI::Sniper - TPSoldierAIController::BeASniperGoal::UpdateAim() -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		
		if( m_SniperInfo.m_SniperType == SniperType_PinPoint )
		{
			CalcPinPointSnipersTargetAimLocation( DeltaTime );
		}
		else//( m_SniperInfo.m_SniperType == SniperType_Track )
		{
			CalcTrackSnipersTargetAimLocation( DeltaTime );
		}
// 		else
// 		{
// 			CalcZoneSnipersTargetAimLocation( DeltaTime );
// 		}

		DoSniperAimStuff();
		
		if( m_SniperInfo.m_bDisplaySniperAimRay )
		{
		
			viewPoint = Pawn.Location;
			viewPoint.Z += Pawn.BaseEyeHeight;

		
			Pawn.DrawDebugLine( viewPoint, TargetAimLocation, 	m_SniperInfo.m_DisplaySniperAimRaySearchingColor.R,
																m_SniperInfo.m_DisplaySniperAimRaySearchingColor.B,
																m_SniperInfo.m_DisplaySniperAimRaySearchingColor.G );
																									
			// DrawDebugCone(FVector Origin, FVector Direction, FLOAT Length, FLOAT AngleWidth, FLOAT AngleHeight, INT NumSides
			
			Pawn.DrawDebugCone( viewPoint,											// FVector Origin
								TargetAimLocation - viewPoint,						// FVector Direction
								VSize(TargetAimLocation - viewPoint),				// FLOAT Length
								0.03,					// FLOAT AngleWidth // m_SniperInfo.m_TargetAcquireRange
								0.03,					// FLOAT AngleHeight
								9,													// INT NumSides
								m_SniperInfo.m_DisplaySniperAimRaySearchingColor);

			// draw kill zone

			Pawn.DrawDebugSphere(	TargetAimLocation,
									m_SniperInfo.m_TargetAcquireRange,
									10,
									m_SniperInfo.m_DisplaySniperAimRaySearchingColor.R,
									m_SniperInfo.m_DisplaySniperAimRaySearchingColor.B,
									m_SniperInfo.m_DisplaySniperAimRaySearchingColor.G );
																
			if( m_SniperInfo.m_SniperType == SniperType_PinPoint )
			{
				Pawn.DrawDebugSphere(	m_SniperInfo.m_TargetLoc,
										m_SniperInfo.m_SearchRange,
										10,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.R,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.B,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.G );					
			}
			else if ( m_SniperInfo.m_SniperType == SniperType_Track )
			{
				// draw a series of boxs from node to node that are the width of the target zone
				// this is only an approximation of the scan zone
				for( nodeCount = 0; nodeCount < (m_SniperInfo.m_Track.Length - 1); nodeCount++ )
				{
				
					rangeLook = m_SniperInfo.m_TargetAcquireRange;
				
					// get direction of this track segment
					dirTrack = m_SniperInfo.m_Track[nodeCount+1].Location - m_SniperInfo.m_Track[nodeCount].Location ;
					
					dirTrack = Normal( dirTrack );
					
					perp1 = m_SniperInfo.m_Track[nodeCount+1].Location cross m_SniperInfo.m_Track[nodeCount].Location;

					perp1 = Normal(perp1);

					perp2 = perp1 cross dirTrack;

					p1 = m_SniperInfo.m_Track[nodeCount].Location + ((-1 * dirTrack) * rangeLook) + (perp1 * rangeLook);

					p2 = m_SniperInfo.m_Track[nodeCount].Location + ((-1 * dirTrack) * rangeLook) + (perp2* rangeLook);

					p3 = m_SniperInfo.m_Track[nodeCount].Location + ((-1 * dirTrack) * rangeLook) - (perp1 * rangeLook);

					p4 = m_SniperInfo.m_Track[nodeCount].Location + ((-1 * dirTrack) * rangeLook) - (perp2 * rangeLook);

					p5 = m_SniperInfo.m_Track[nodeCount+ 1].Location + ((dirTrack) * rangeLook) + (perp1 * rangeLook);

					p6 = m_SniperInfo.m_Track[nodeCount+ 1].Location + ((dirTrack) * rangeLook) + (perp2 * rangeLook);

					p7 = m_SniperInfo.m_Track[nodeCount+ 1].Location + ((dirTrack) * rangeLook) - (perp1 * rangeLook);

					p8 = m_SniperInfo.m_Track[nodeCount+ 1].Location + ((dirTrack) * rangeLook) - (perp2 * rangeLook);


					// draw midline
					Pawn.DrawDebugLine (m_SniperInfo.m_Track[nodeCount].Location , m_SniperInfo.m_Track[nodeCount+ 1].Location,
										m_SniperInfo.m_DisplaySniperAimRaySearchingColor.R,
										m_SniperInfo.m_DisplaySniperAimRaySearchingColor.B,
										m_SniperInfo.m_DisplaySniperAimRaySearchingColor.G);


					// first end cap
										
					Pawn.DrawDebugLine (p1, p2,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.R,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.B,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.G);
// 															
					Pawn.DrawDebugLine (p2, p3,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.R,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.B,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.G);
// 										
					Pawn.DrawDebugLine (p3, p4,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.R,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.B,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.G);
// 										
					Pawn.DrawDebugLine (p4, p1,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.R,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.B,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.G);

					// 2nd end cap

					Pawn.DrawDebugLine (p5, p6,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.R,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.B,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.G);
// 															
					Pawn.DrawDebugLine (p6, p7,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.R,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.B,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.G);
// 										
					Pawn.DrawDebugLine (p7, p8,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.R,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.B,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.G);
// 										
					Pawn.DrawDebugLine (p8, p5,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.R,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.B,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.G);


					// connect the caps

					Pawn.DrawDebugLine (p1, p5,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.R,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.B,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.G);
// 															
					Pawn.DrawDebugLine (p2, p6,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.R,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.B,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.G);
// 										
					Pawn.DrawDebugLine (p3, p7,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.R,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.B,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.G);
// 										
					Pawn.DrawDebugLine (p4, p8,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.R,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.B,
										m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.G);	


					m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.R = RandRange(0, 255);
					m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.G = RandRange(0, 255);
					m_SniperInfo.m_DisplaySniperAimRayAcquiredColor.B = RandRange(0, 255);

				}

			}
			else
			{
				//CalcZoneSnipersTargetAimLocation( DeltaTime );
			}													
			
		}


		//log(self @ "aiming at" @ Target @ "aimnode=" @ anode_AIM @ anode_AIM.Aim.X @ anode_AIM.Aim.Y);
		
	}
	
	event Tick( float DeltaTime )
	{
		//`log(" ChadAI - TPSoldierAIController::LookForSniperTarget::Tick bUseAimOffset: " @ TPPawn(Pawn).bUseAimOffset @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
			
		UpdateSnipersAim(DeltaTime);
		UpdateHeadTracking();

		Super.Tick(DeltaTime);
	}


Begin:

	m_SubStateDebugInfoTag="Begin";

	//`log(" ChadAI - TPSoldierAIController::LookForSniperTarget::Begin  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	
	// just in case

	SetAimAndHeadTrack();

	m_SniperInfo.m_bTrackingUp = true;

	m_SniperInfo.m_NextNodeOnTrack = 1;

	StopFiring();

	if( m_SniperInfo.m_SniperType == SniperType_PinPoint )
	{
		m_SniperInfo.m_DirOfScan.X = RandRange( -1.0, 1.0 );
		m_SniperInfo.m_DirOfScan.Y = RandRange( -1.0, 1.0 );
		m_SniperInfo.m_DirOfScan.Z = RandRange( -1.0, 1.0 );
		
		m_SniperInfo.m_DirOfScan = Normal( m_SniperInfo.m_DirOfScan );

		TargetAimLocation = m_SniperInfo.m_TargetLoc; 
	}
	else if ( m_SniperInfo.m_SniperType == SniperType_Track )
	{
		if( (m_SniperInfo.m_Track[0] == none) || (m_SniperInfo.m_Track[1] == None) )
		{
			VerifyAndFixSniperTrack();
		}

		if( m_SniperInfo.m_Track.Length > 1 )
		{
			m_SniperInfo.m_DirOfScan = m_SniperInfo.m_Track[1].Location - m_SniperInfo.m_Track[0].Location;
			
			m_SniperInfo.m_DirOfScan = Normal( m_SniperInfo.m_DirOfScan );
		}
		else
		{
			m_SniperInfo.m_DirOfScan.X = 0.0;
			m_SniperInfo.m_DirOfScan.Y = 0.0;
			m_SniperInfo.m_DirOfScan.Z = 0.0;
		}

		TargetAimLocation = m_SniperInfo.m_Track[0].Location; 
	}
	else // in the zone
	{
		m_SniperInfo.m_DirOfScan.X = RandRange( -1.0, 1.0 );
		m_SniperInfo.m_DirOfScan.Y = RandRange( -1.0, 1.0 );
		m_SniperInfo.m_DirOfScan.Z = RandRange( -1.0, 1.0 );
		
		m_SniperInfo.m_DirOfScan = Normal( m_SniperInfo.m_DirOfScan );

		TargetAimLocation = m_SniperInfo.m_TargetLoc; 
	}

	//`log(" ChadAI - TPSoldierAIController::LookForSniperTarget::Begin  m_SniperInfo.m_TargetLoc: " @ m_SniperInfo.m_TargetLoc @ " TargetAimLocation: " @ TargetAimLocation @ " m_DirOfScan: " @ m_SniperInfo.m_DirOfScan @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


LookForSniperTargetLoop:

	//`log(" ChadAI::Sniper - TPSoldierAIController::LookForSniperTarget::LookForSniperTargetLoop  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	if( (WorldInfo.TimeSeconds - m_SniperInfo.m_TimeStartedAsSniperInSeconds) > m_SniperInfo.m_TimeToBeSniperInSeconds )
	{
		//`log(" ChadAI::Sniper - LookForSniperTargetLoop Done Being A sniper -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	
		// Done being a sniper
		PopState();
	}
	else
	{
		if( TestForValidSniperTarget() )
		{
			PopState();
		}
		// look for enemy throgh know pawns
	}

	//if (ShouldITurnToTargetInTheOpen())
	//if( true )
	if (Enemy != None && ShouldITurnToTarget( false ))
	{
		//`log(" ChadAI - - Pawn: " @ Pawn @ " LookForSniperTargetLoop - ShouldITurnToTarget returned true-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		//`AILOG(0, 'Begin', "Turn towards target");
		// turn towards our target
		//StopFiring();
		//Focus = Target;

		
		// wait til the turn is finished
		m_SubStateDebugInfoTag="Turning to Target";

		DesiredRotation = rotator(TargetAimLocation - Pawn.Location);
		DesiredRotation.Pitch = 0;
		FinishRotation();

		// preserve the new orientation and stop turning
		//PreserveRotation();
		//Focus = none;
	}


	Sleep(0.0);
	
	Goto('LookForSniperTargetLoop');
}


//-----------------------------------------------------------------------
// State:		 ForceAttentionAtTarget
// Description:  forcibly Pays attention to our target
//				 base class for ForceFireAtTarget and ForceAimAtTarget
//-----------------------------------------------------------------------
state ForceAttentionAtTarget
{

	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
	
		//`log(" ChadAI - " @ self @ "ForceAttentionAtTarget::OnSeeEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
	
		// acquire as a new enemy and evaluate the situation
		CheckForEnemy(false);
	}
	
	event OnHearEnemy(int playerIdx)
	{
		//`log(" ChadAI - " @ self @ "ForceAttentionAtTarget::OnHearEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		CheckForEnemy(false);		
	}

	function BeginState(Name PreviousStateName)
	{
		;
	}
	

	function EndState(Name NextStateName)
	{
		;	

		//HandleLeftCoverCollisionChange( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos );
	}


	function PoppedState()
	{
		// clean up code
		PreserveRotation();
		Focus = None;
		StopFiring();
		m_Engagement_Tac_Data.m_bFireAtTargetReguardlessOfWhatItIs = false;
	}

	function PushedState()
	{
		if (Pawn != None)
		{
			// make sure the pawn physics are initialized
			//Pawn.SetMovementPhysics();
		}
	}

	event Tick(float DeltaTime)
	{
		//do this every frame
		UpdateHeadTracking();

		if( !IsReloading() )
		{
			if( m_Engagement_Tac_Data.m_bFireAtTargetReguardlessOfWhatItIs && Target != None )
			{
				if( m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd )
				{
					if( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedWaitForWeaponBurstDelay ) >= m_Engagement_Tac_Data.m_TimeToWaitForWeaponBurstDelay )
					{
						//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " ForceAttentionAtTarget Tick Time to wait BurstCount Ended -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

						// enough time has passed so end waiting for burst cool down time
						m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd = false;
					}
				}
				UpdateAimAtActorTarget(DeltaTime);
			}
			else
			{
				UpdateAimInTheOpen(FALSE);;
			}
		}
	}

	//---------------------------------------------------------------------------
	// Function:
	// Description:	Callback from weapon when it is fired.
	//---------------------------------------------------------------------------
	function NotifyWeaponFired(Weapon W, byte FireMode)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " ForceAttentionAtTarget::NotifyWeaponFired BurstCount: " @ BurstCount @ " BulletsPerBurst: " @ TPWeapon(Pawn.Weapon).BulletsPerBurst  @" **************************************************************************************************");
		//`log(" ChadAI - Pawn: " @ Pawn @ " ForceAttentionAtTarget::NotifyWeaponFired bIsNPCWeapon: " @ TPWeapon(Pawn.Weapon).bIsNPCWeapon@ " AmmoCount: " @ TPWeapon(Pawn.Weapon).AmmoCount @ " GetAmmoInMagazine(): " @ TPWeapon(Pawn.Weapon).GetAmmoInMagazine()  @" -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		if( m_Engagement_Tac_Data.m_bFireAtTargetReguardlessOfWhatItIs && Target != None )
		{

			if (Pawn != None && Pawn.Weapon != None ) 
			{
				if( !m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd )
				{
					++BurstCount;
					if (BurstCount >= TPWeapon(Pawn.Weapon).BulletsPerBurst)
					{
						m_Engagement_Tac_Data.m_TimeToWaitForWeaponBurstDelay = RandRange(TPWeapon(Pawn.Weapon).BurstDelayMin, TPWeapon(Pawn.Weapon).BurstDelayMax);

						m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd = true;
						m_Engagement_Tac_Data.m_TimeStartedWaitForWeaponBurstDelay = WorldInfo.TimeSeconds;

						//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " ForceAttentionAtTarget::NotifyWeaponFired Time to wait BurstCount: " @ BurstCount @ " Delay of: " @ m_Engagement_Tac_Data.m_TimeToWaitForWeaponBurstDelay @ " -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
						;

						StopFiring();
						BurstCount = 0;

		// 				if (!IsInState('BurstFireWait'))
		// 					PushState('BurstFireWait');
					}
					else
					{
						//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " ForceAttentionAtTarget::NotifyWeaponFired Time to wait BurstCount: " @ BurstCount @ " Must be less then TPWeapon(Pawn.Weapon).BulletsPerBurst: " @ TPWeapon(Pawn.Weapon).BulletsPerBurst @ " -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
					}

				}
				else
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " ForceAttentionAtTarget::NotifyWeaponFired m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd so no need to do any thing -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
					StopFiring();
				}
			}
		}
		else
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " ForceAttentionAtTarget::NotifyWeaponFired NOT m_bFireAtTargetReguardlessOfWhatItIs: " @ m_Engagement_Tac_Data.m_bFireAtTargetReguardlessOfWhatItIs @ "  OR Target == None: " @ Target @ " -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

			Super.NotifyWeaponFired(W, FireMode);
		}

		if (m_forcedFireShotsLeft > 0)
		{
			m_forcedFireShotsLeft--;
			if (m_forcedFireShotsLeft == 0)
			{

				;
				EndForceAction();
			}
		}
	}

	function WeaponReloaded()
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " ForceAttentionAtTarget::NotifyWeaponReloadEnded fn called");
		BurstCount = 0; // reset this so it fires the correct number of bullets per burst after reload
	}

	function UpdateAimAtActorTarget( float DeltaTime )
	{
		
		//`log(" ChadAI - Pawn: " @ Pawn @ " ForceAttentionAtTarget::UpdateAimAtActorTarget() -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		
		CalcForceTargetAimLocation( DeltaTime );
		DoAimStuff( false, false );	
	}

	function EndForceAction()
	{
		PopState();
	}

    

	function CalcForceTargetAimLocation( float DeltaTime )
	{
		local Box bbox;
		local Vector AimPoint;

		if( Target != None )
		{
			Target.GetComponentsBoundingBox(bbox);

			if( VSize(bbox.Max) > 2.0 )
			{
				AimPoint = (bbox.Min + bbox.Max) * 0.5f;
				//`log(" ChadAI - Pawn: " @ Pawn @ " ForceAttentionAtTarget::CalcTargetAimLocation() bbox.Max.Size() > 0.1 so AimPoint: " @AimPoint @ " bbox.Min: " @ bbox.Min @ " bbox.Max: " @ bbox.Max @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			}
			else
			{
				AimPoint = Target.Location;
				//`log(" ChadAI - Pawn: " @ Pawn @ " ForceAttentionAtTarget::CalcTargetAimLocation() bbox.Max.Size() ! > 0.1 so AimPoint: " @AimPoint @ " bbox.Min: " @ bbox.Min @ " bbox.Max: " @ bbox.Max @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			}
			
			TargetAimLocation = AimPoint;
		}
	}

Begin:

	m_SubStateDebugInfoTag="Begin";

	// keep firing at our target until done

	//`log(" ChadAI - Pawn: " @ Pawn @ " ForceAttentionAtTarget-Begin: " @ Target @ " m_bFireAtTargetReguardlessOfWhatItIs: " @ m_Engagement_Tac_Data.m_bFireAtTargetReguardlessOfWhatItIs @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	//m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd = false;

	StopThisBot();

ForceAttentionAtTargetLoop:

		if (Target == None)
		{
			Goto('ForceAttentionAtTargetEnd');
		}
		if (Target.bDeleteMe || (Pawn(Target) != None && Pawn(Target).Health <= 0))
		{
			Goto('ForceAttentionAtTargetEnd');
		}
		// see if we need to turn towards the target
		if (ShouldITurnToTarget( false ))
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " ForceAttentionAtTarget-Main Loop ShouldITurnToTargetInTheOpen return true: " @ Target @ " m_bFireAtTargetReguardlessOfWhatItIs: " @ m_Engagement_Tac_Data.m_bFireAtTargetReguardlessOfWhatItIs @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			// turn towards our target
			StopFiring();
			Focus = Target;

			DesiredRotation = rotator(Focus.Location - Pawn.Location);
			DesiredRotation.Pitch = 0;

			// wait til the turn is finished
			FinishRotation();

			// preserve the new orientation and stop turning
			PreserveRotation();
			Focus = None;
		}


		// shoot

		if( m_Engagement_Tac_Data.m_bFireAtTargetReguardlessOfWhatItIs && Target != None )
		{
			if( !m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd && !IsReloading() )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " ForceAttentionAtTarget-Main Loop: " @ Target @ " m_bFireAtTargetReguardlessOfWhatItIs: " @ m_Engagement_Tac_Data.m_bFireAtTargetReguardlessOfWhatItIs @ " so StartFiring %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");

				
					TP_AiStartFiring();
				



// 				if(Pawn != None && Pawn.Weapon != None && TPWeapon(Pawn.Weapon) != None )
// 				{
// 					if( TPWeapon(Pawn.Weapon).WeapCategory == WeaponCategory_Panzer) 
// 					{
// 						//`log(" ChadAI - Pawn: " @ Pawn @ " ForceAttentionAtTarget-Main Loop: WeaponCategory_Panzer so stop shooting -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 
// 						StopFiring();
// 						Sleep(20.0);
// 					}
// 				}
			}
		}
		else if (ShouldIFire() && !m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd  )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " ForceAttentionAtTarget-Main Loop: ShouldIFire so StartFiring %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");

			
				TP_AiStartFiring();
			



// 			if(Pawn != None && Pawn.Weapon != None && TPWeapon(Pawn.Weapon) != None )
// 			{
// 				if( TPWeapon(Pawn.Weapon).WeapCategory == WeaponCategory_Panzer) 
// 				{
// 					//`log(" ChadAI - Pawn: " @ Pawn @ " ForceAttentionAtTarget-Main Loop: WeaponCategory_Panzer so stop shooting -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 
// 					Sleep(0.0);
// 					StopFiring();
// 				}
// 			}

		}
		else
		{
			//`AILOG(0, 'ForceAttentionAtTarget', "Not Firing");
		
			StopFiring();
		}

		// sleep for a bit before we check if we need to turn again
		Sleep(0.0f);
		StopFiring();

Goto('ForceAttentionAtTargetLoop');

ForceAttentionAtTargetEnd:

	EndForceAction();
}

// dummy fn in case out of state when call returns
function EndForceAction()
{

}

//-----------------------------------------------------------------------
// State:		 ForceFireAtTarget
// Description:  forcibly fires at our target
//-----------------------------------------------------------------------
state ForceFireAtTarget extends ForceAttentionAtTarget
{

	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
	
		//`log(" ChadAI - " @ self @ "ForceFireAtTarget::OnSeeEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
	
		// acquire as a new enemy and evaluate the situation
		CheckForEnemy(false);
	}
	
	event OnHearEnemy(int playerIdx)
	{
		//`log(" ChadAI - " @ self @ "ForceFireAtTarget::OnHearEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		CheckForEnemy(false);		
	}

	function EndForceAction()
	{
		//`log(" ChadAI - " @ self @ "ForceFireAtTarget::EndForceAction called -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		ClearLatentAction(class'SeqAct_AIStartForceFireAtTarget', false);
	}

	function BeginState(Name PreviousStateName)
	{
		;

		if (m_forcedFireDuration > 0.0)
		{
			SetTimer(m_forcedFireDuration, false, 'ForceFireTimeUp');
		}

	}
	

	function EndState(Name NextStateName)
	{
		;	

		//		ClearLatentAction(class'SeqAct_AIStartForceFireAtTarget', false);
		ClearTimer('ForceFireTimeUp');
		m_forcedFireShotsLeft = 0;
		m_bForcedFire = false;
	}


	function PoppedState()
	{
		// clean up code
		Super(ForceAttentionAtTarget).PoppedState();
		;

		ClearLatentAction(class'SeqAct_AIStartForceFireAtTarget', false);
		ClearTimer('ForceFireTimeUp');
		m_forcedFireShotsLeft = 0;
		m_bForcedFire = false;
	}

	function ForceFireTimeUp()
	{
		;

		PopState();
	}

	function PushedState()
	{
		Super(ForceAttentionAtTarget).PushedState();

		;

		if (m_forcedFireDuration > 0.0)
		{
			m_bForcedFire = true;
			SetTimer(m_forcedFireDuration, false, 'ForceFireTimeUp');
		}
	}

	event PausedState()
	{
		;
		m_bForcedFire = false;
	}

	event ContinuedState()
	{
		;
		m_bForcedFire = true;
	}

	function WeaponJustFired()
	{
		;

		if (m_forcedFireShotsLeft > 0)
		{
			m_forcedFireShotsLeft--;
			if (m_forcedFireShotsLeft == 0)
			{
				PopState();
			}
		}
	}

	function OnAIStopForceFireAtTarget()
	{
		;

		PopState();
	}
}

//-----------------------------------------------------------------------
// State:		 ForceAimAtTarget
// Description:  forcibly Aims at our target
//-----------------------------------------------------------------------
state ForceAimAtTarget extends ForceAttentionAtTarget
{
	function bool ShouldIFire()
	{
		return false;
	}
	function PoppedState()
	{
		// clean up code
		Super(ForceAttentionAtTarget).PoppedState();

		ClearLatentAction(class'SeqAct_AIStartForceAimAtTarget', false);
		ClearTimer('ForceAimTimeUp');
	}

	function ForceAimTimeUp()
	{
		PopState();
	}

	function PushedState()
	{
		Super(ForceAttentionAtTarget).PushedState();

		if (m_forcedFireDuration > 0.0)
		{
			SetTimer(m_forcedFireDuration, false, 'ForceAimTimeUp');
		}
	}

	function WeaponJustFired()
	{
	}

	function OnAIStopForceAimAtTarget()
	{
		PopState();
	}
}




//************************ - BEGIN SECTION - ****************************
// STEP ASIDE
//***********************************************************************
/* don't think we should do this, DK
state StepAside
{

	event PushedState()
	{
		SetFocus();
	}
//	event PoppedState()
//	{
//		SetFocus();
//	}

//	event YouAreStuck()
//	{
//		`AILOG(1, 'YouAreStuck', "Stuck in stepaside! popping");
//
//		PopState();
//	}


	function SetFocus()
	{
		if (Enemy != None)
		{
			//Look at enemy
			Target = Enemy;// FIXME: This shouldn't be here if we're not always strafing
			Focus = Enemy;
			`AILOG(1, 'Focus',"Setting focus to enemy: "@Enemy);
			FocalPoint = Enemy.Location;
		}
		else if(m_moveGoalInfo.goalActor != None)
		{
			//Look at move goal actor
			//Target = m_moveGoalInfo.goalActor;
			Focus = m_moveGoalInfo.goalActor;
			`AILOG(1, 'Focus',"Setting focus to goal: "@Focus);
			FocalPoint = m_moveGoalInfo.goalActor.Location;
		}
		else
		{
			//`AILOG(0, 'step aside', "Clearing target");
			//Target = None;
			Focus = None;
			FocalPoint = Destination;
		}

	}


	function bool GetStepAsideLocation()
	{
		local vector x, y, z;
		local array<vector> chkLocs;
		local int idx;
		// first try a direction perpendicular to the target's velocity
		if (VSize(m_stepAsideGoal.Velocity) > 0)
		{
			x = Normal(m_stepAsideGoal.Velocity);
		}
		else if (IsMoving())
		{
			//AILog("- IS MOVING, YAY"@MoveTarget@MoveGoal.GoalActor,'Sensory');
			if (MoveTarget != None)
			{
				x = Normal(MoveTarget.Location-Pawn.Location);
			}
			else
			{
				x = Normal(m_moveGoalInfo.GoalActor.Location-Pawn.Location);
			}
		}
		else
		{
			x = Normal(vector(Pawn.Rotation));
		}
		z = vect(0,0,1);
		y = Normal(x cross z);
		if (Normal(Pawn.Location-m_stepAsideGoal.Location) dot y > 0.f)
		{
			//AILog("-++ flipping y baby",'Sensory');
			// flip the y to avoid running into them more
			y *= -1;
		}

//
//		chkLocs.Length = 3;
//		// test first dir at max distance
//		chkLocs[0] = Pawn.Location + y * m_maxStepAsideDist;
//		// half distance
//		chkLocs[1] = Pawn.Location + y * m_maxStepAsideDist * 0.5f;
//		// half dir max distance
//		chkLocs[2] = Pawn.Location + x * m_maxStepAsideDist * 0.5f + y * m_maxStepAsideDist * 0.5f;
//
//		// other dir max distance
//		//chkLocs[1] = Pawn.Location - y * m_maxStepAsideDist;
//		// other dir half distance
//		//chkLocs[3] = Pawn.Location - y * m_maxStepAsideDist * 0.5f;
//		// half other dir max distance
//		//chkLocs[5] = Pawn.Location + x * m_maxStepAsideDist * 0.5f - y * m_maxStepAsideDist * 0.5f;
//


		//Sanjay: It's just too expensive to do this many trace checks to find where to go.
		//Kynapse will allow us to make this complex again.
		chkLocs.Length = 2;
		// test first dir at max distance
		//chkLocs[0] = Pawn.Location + y * m_maxStepAsideDist;
		// half distance
		chkLocs[0] = Pawn.Location + y * m_maxStepAsideDist * 0.5f;
		// half dir max distance
		//chkLocs[2] = Pawn.Location + x * m_maxStepAsideDist * 0.5f + y * m_maxStepAsideDist * 0.5f;

		// other dir max distance
		//chkLocs[3] = Pawn.Location - y * m_maxStepAsideDist;
		// other dir half distance
		chkLocs[1] = Pawn.Location - y * m_maxStepAsideDist * 0.5f;
		// half other dir max distance
		//
		//chkLocs[5] = Pawn.Location + x * m_maxStepAsideDist * 0.5f - y * m_maxStepAsideDist * 0.5f;


		//new
		//chkLocs[6] = Pawn.Location + x * m_maxStepAsideDist;
		//chkLocs[7] = Pawn.Location - x * m_maxStepAsideDist * 0.5f - y * m_maxStepAsideDist * 0.5f;
		//chkLocs[8] = Pawn.Location - x * m_maxStepAsideDist * 0.5f + y * m_maxStepAsideDist * 0.5f;
		//chkLocs[9] = Pawn.Location - x * m_maxStepAsideDist;
		//


		// return the first valid one
		for (idx = 0; idx < chkLocs.Length; idx++)
		{
			if (IsValidMoveLocation(chkLocs[idx]))
			{
				m_stepAsideLocation = chkLocs[idx];
				//`AILOG(0, 'GetStepAsideLocation', "Found valid step aside location"@m_stepAsideLocation);
				return true;
			}
		}

		`AILOG(1, 'GetStepAsideLocation', "No valid step aside location");
		return false;
	}



}
*/

//************************ - END SECTION - ****************************
// STEP ASIDE
//***********************************************************************
native final function int YawToEnemy();

native final function TravelToCoverSlotTickLogic();
//-----------------------------------------------------------------------
// State:		TravelToCoverSlot
// Description: Concreate state to move to a spesific cover slot while engaged
//
// For this state to get the pawn to the cover slot these values need to be set
//	m_CoverMoveData.m_ReservedGoToCover_Clamied needs to be set to the cover link you want the pawn to move to
//		so m_CoverMoveData.m_ReservedGoToCover_Clamied.Link need to point to a tp cover node
//		and m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx need to correspond to a cover slot
////-----------------------------------------------------------------------
state TravelToCoverSlot
{

	function BeginState(Name PreviousStateName)
	{
		//`log(" ChadAI - TPAIController::TravelToCoverSlot::BeginState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
		;		
		//Super.BeginState(PreviousStateName);

		m_Engagement_Tac_Data.m_bEngagingOnTheRun = false;
		m_CoverFightData.m_bCanRotateToTargetDuringTrans = false;
		m_CoverFightData.m_bCanRotateToCoverSlotDuringTrans = false;
		m_bMoveAborted = false;

	}
	function EndState(Name NextStateName)
	{
		//`log(" ChadAI - TPAIController::TravelToCoverSlot::EndState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;		
		
		m_CoverMoveData.m_HasPathToCoverBeenBuilt = false;

		if( Pawn != None )
		{
			TPPawn(Pawn).SetMovementType( MovementType_Default );

			Pawn.MaxDesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
			Pawn.DesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
			Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
		}

		if( m_Engagement_Tac_Data.m_bEngagingOnTheRun )
		{
			m_Engagement_Tac_Data.m_bEngagingOnTheRun = false;
			StopFiring();
		}

		m_CoverMoveData.m_bNotAbleToTransitionIntoCover = false;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
		{
			KillTheTraveller();
			//PopState();
		}

		//Super.EndState(NextStateName);		
	}

	
	event PushedState()
	{
		;

		m_Engagement_Tac_Data.m_bEngagingOnTheRun = false;
		m_CoverFightData.m_bCanRotateToTargetDuringTrans = false;
		m_CoverFightData.m_bCanRotateToCoverSlotDuringTrans = false;
		//`log(" ChadAI - TPAIController::TravelToCoverSlot::PushedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	event PoppedState()
	{
		;		

		KynapseClear();


		
		if( Pawn != None )
		{
			TPPawn(Pawn).SetMovementType( MovementType_Default );

			if( TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
			{
				KillTheTraveller();
				//PopState();
			}

			Pawn.MaxDesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
			Pawn.DesiredSpeed=m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover;
			Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
		}

		if( m_Engagement_Tac_Data.m_bEngagingOnTheRun )
		{
			m_Engagement_Tac_Data.m_bEngagingOnTheRun = false;
			StopFiring();
		}

		m_CoverMoveData.m_HasPathToCoverBeenBuilt = false;
		m_CoverMoveData.m_bNotAbleToTransitionIntoCover = false;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

	}	

	
	event PausedState()
	{
		//`log(" ChadAI - TPAIController::TravelToCoverSlot::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		;

		KynapseClear();

		m_Engagement_Tac_Data.m_bEngagingOnTheRun = false;
		if( Pawn != None )
		{
			Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
		}

		if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
		{
			KillTheTraveller();
			PopState();
		}
	}

	event ContinuedState()
	{
		//`log(" ChadAI - TPAIController::TravelToCoverSlot::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;		
		if (Pawn != none)
		{
            //Pawn.SetMovementPhysics();
        }

		KynapseClear();

		m_Engagement_Tac_Data.m_bEngagingOnTheRun = false;

		if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_DoneMovingAtCover )
		{
			// I some how got interputted right before I Snapepd in so I need to started the loop from the beginning
			;
			m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_PausedUnknown;
		}

		//Super.ContinuedState(); 
		
	}
	
	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
		CheckForEnemy(false);
	}
	
	event OnHearEnemy(int playerIdx)
	{
		CheckForEnemy(false);
	}
	
    function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		// do nothing for now
		//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " TRAVELTOCOVERSLOT::NOTIFYWEAPONFIRED  No Round: " @ m_Engagement_Tac_Data.m_NoOfRoundsFiredThisBurst + 1 @ " - YawToEnemy: " @ YawToEnemy() @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		

		if( m_Engagement_Tac_Data.m_bEngagingOnTheRun )
		{
			m_Engagement_Tac_Data.m_NoOfRoundsFiredThisBurst++;
			m_Engagement_Tac_Data.m_TimeOfLastFire = WorldInfo.TimeSeconds;
		}
	}

	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " TravelToCoverSlot::NotifyTakeHit m_bTookHitWhilePursuing set to true Pawn.Health: " @ Pawn.Health @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		//local Vector			centerPos;

		if( Pawn.Health < 1 && (m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_Moving || m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_DoneMovingAtCover) )
		{
			if( !TPPawn(Pawn).m_bNeedsToPlowIn )
			{
				;
				
				Pawn.Health = 100;
				TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet = true;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetInstigatedBy = InstigatedBy;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetHitlocation = HitLocation;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetMomentum = Vector(Pawn.Rotation) * GetDeathForceForRun() ;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetDamageType = damageType;
				TPPawn(Pawn).m_bNeedsToPlowIn = true;
				KynapseClear();
			}
		}
	}
		
	
	event Tick( float DeltaTime )
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " TravelToCoverSlot::Tick() START DesiredRotation: " @ DesiredRotation.Yaw @ " Pawn.DesiredRotation " @ Pawn.DesiredRotation  @ " Pawn.Rotation " @ Pawn.Rotation  @ " Focus.Loc: " @ FocalPoint @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " TravelToCoverSlot::Tick() m_Move2CoverStatus: " @ m_CoverMoveData.m_Move2CoverStatus @ " - GetDistenceLeftOnPath: " @ GetDistenceLeftOnPath() @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		TravelToCoverSlotTickLogic();

		if( Enemy == None )
		{
			Focus = None;
			//FindPlayer();
// 			FindPlayerController();
// 			if( m_ThePlayerController != None )
// 			{
// 				Target = m_ThePlayerController
// 			}
		}

		if( m_CoverMoveData.m_bNotAbleToTransitionIntoCover )
		{
			if( Pawn != None &&  Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching )
			{

				//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " TravelToCoverSlot::Tick() m_Move2CoverStatus: " @ m_CoverMoveData.m_Move2CoverStatus @ " Starting to rotate towards either target or slot-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " TravelToCoverSlot::Tick() DesiredRotation: " @ DesiredRotation.Yaw @ " Pawn.DesiredRotation " @ Pawn.DesiredRotation  @ " Pawn.Rotation " @ Pawn.Rotation  @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				if( Enemy != None )
				{
					bForceDesiredRotation = true;
					DesiredRotation = rotator( Enemy.Location - Pawn.Location );
					DesiredRotation.Pitch = 0;
		 
					Pawn.DesiredRotation = DesiredRotation;

					Focus = Enemy;

					//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " TravelToCoverSlot::Tick() has enemy DesiredRotation: " @ DesiredRotation.Yaw @ " Pawn.DesiredRotation " @ Pawn.DesiredRotation  @ " Pawn.Rotation " @ Pawn.Rotation  @ " Focus.Loc: " @ Focus.Location @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				}
				else
				{
					bForceDesiredRotation = true;
					DesiredRotation = m_CoverMoveData.m_ReservedGoToCover_Clamied.Link.GetSlotRotation(m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx);
					DesiredRotation.Pitch = 0;
		 
					Pawn.DesiredRotation = DesiredRotation;

					//Focus = m_CoverMoveData.m_ReservedGoToCover_Clamied.Link;

					//FocalPoint = Pawn.Location + (Vector(DesiredRotation) * 1000);

					//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " TravelToCoverSlot::Tick() has NO enemy DesiredRotation: " @ DesiredRotation.Yaw @ " Pawn.DesiredRotation " @ Pawn.DesiredRotation  @ "  Pawn.Rotation " @ Pawn.Rotation  @ " Focus.Loc: " @ FocalPoint @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				}
		 
				//Rotate Pawn Slowly to face in the right direction
				if( !ReachedDesiredRotationAtCoverAndSetRotDirection((Enemy != None ? true : false), m_CoverMoveData.m_ReservedGoToCover_Clamied) )
				{

					//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " TravelToCoverSlot::Tick() Has not ReachedDesiredRotationAtCoverAndSetRotDirection - DesiredRotation: " @ DesiredRotation.Yaw @ " Pawn.DesiredRotation " @ Pawn.DesiredRotation  @ " Pawn.Rotation " @ Pawn.Rotation  @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	 				if( DoINeedToSlideIntoTheSlot( m_CoverMoveData.m_ReservedGoToCover_Clamied ) )
	 				{
	 					SlideMeALIttleBitFatherIntoTheSlot(class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_DistToSlideIntoCoverWhileInCoverPerUpdate, m_CoverMoveData.m_ReservedGoToCover_Clamied);
	 					//Sleep(0.0);
	 				}

 					if( m_CoverFightData.m_bSlowRotRight )
 					{
 						Pawn.DesiredRotation.Yaw = Pawn.Rotation.Yaw + (Pawn.bIsCrouched ?
 																				class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateCrouchedAtCoverPerHertz : 
 																				class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateStandAtCoverPerHertz );
 						Pawn.DesiredRotation.Pitch = 0;
 						//Pawn.DesiredRotation = DesiredRotation;
 						
 					}
 					else
 					{
 						Pawn.DesiredRotation.Yaw = Pawn.Rotation.Yaw -  (Pawn.bIsCrouched ?
 																				class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateCrouchedAtCoverPerHertz : 
 																				class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_TurnRateStandAtCoverPerHertz );
 						Pawn.DesiredRotation.Pitch = 0;
 						//Pawn.DesiredRotation = DesiredRotation;
 					}
 
 					Pawn.SetRotation( Pawn.DesiredRotation );
					//Pawn.DesiredRotation = DesiredRotation; 

					//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " TravelToCoverSlot::Tick() After Set Rot - DesiredRotation: " @ DesiredRotation.Yaw @ " Pawn.DesiredRotation " @ Pawn.DesiredRotation  @ " Pawn.Rotation " @ Pawn.Rotation  @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				}
			}
		}

	}


Begin:

	m_SubStateDebugInfoTag="Begin";


	m_Engagement_Tac_Data.m_bEngagingOnTheRun = false;
	m_CoverFightData.m_bCanRotateToTargetDuringTrans = false;
	m_CoverFightData.m_bCanRotateToCoverSlotDuringTrans = false;
	
	m_Engagement_Tac_Data.m_TimeSnappedIn = -1.0f;
	m_Engagement_Tac_Data.m_TimeOfLastFire = -1.0f;

	m_CoverMoveData.m_RotAtStartOfTravel = Pawn.Rotation;

	SetAimAndHeadTrack();

	m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_NotTransitioning;
	m_CoverMoveData.m_bNotAbleToTransitionIntoCover = false;

	//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " TravelToCoverSlot::Begin() m_CoverTransitionAction: " @ m_CoverMoveData.m_CoverTransitionAction @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	
	m_moveGoalInfo.goalActor = None;
	
	m_CoverFightData.m_bUsingFightingPosition = true;

	m_CoverMoveData.m_SpeedFactorBeforeCrouchWalkToCover = Pawn.MaxDesiredSpeed;

	StopFiring();

	m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_None;

	//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " TravelToCoverSlot::Begin() Before set to walking -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	//Sleep(5.0);

	Pawn.SetPhysics(PHYS_Walking);

	//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " TravelToCoverSlot::Begin() After set to walking -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	//Sleep(5.0);

	/*ClearCurrentCover();*/

TravelToCoverSlotLoop:

	m_SubStateDebugInfoTag="TravelToCoverSlotLoop-Top";

	//`log(" ChadAI - Pawn: " @ Pawn @ " TPAIController::TravelToCoverSlot::TravelToCoverSlotLoop() top path built already: " @ m_CoverMoveData.m_HasPathToCoverBeenBuilt @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	m_CoverMoveData.m_bTookHitWhileTraveling = false;

	if (TPGameInfo(WorldInfo.Game).bKynapseEnabled)
	{
		if( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link != None )
		{
			if( !m_CoverMoveData.m_HasPathToCoverBeenBuilt || !KynapseFoundPath() )
			{
				;

				// old way
				//`log(" ChadAI - Pawn: " @ Pawn @ " TPAIController::TravelToCoverSlot::TravelToCoverSlotLoop() path has not already been builtBuilding Path -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_BuildingPath;

				KynapseGoToFindPath( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link.GetSlotLocation( m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx ) );

				//`log(" ChadAI - Pawn: " @ Pawn @ " TPAIController::TravelToCoverSlot::TravelToCoverSlotLoop() back from building path -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				
				if ( !KynapseFoundPath() )
				{
					;

					//`log(" ChadAI - Pawn " @ Pawn @ " TravelToCoverSlot::Begin Does Not have Cover Path so fail travel and InvalidateMoveGoal -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_FailedNoPath;

					InvalidateMoveGoal( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link, m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx );

					PopState();
				}
				else
				{
					;

					//`log(" ChadAI - Pawn " @ Pawn @ " TravelToCoverSlot::Begin Does Have Cover Path so travel -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				}
			
			}
			else
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " TPAIController::TravelToCoverSlot::TravelToCoverSlotLoop() Path has already been built -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				;

				// new way
			}

			//`log(" ChadAI - Pawn: " @ Pawn @ " TPAIController::TravelToCoverSlot::TravelToCoverSlotLoop() just before KynapseFollowPath -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			if (Pawn.bIsCrouched)
			{

				KynapseClear();

				if( m_CoverMoveData.m_CurrentCover_Clamied.Link != None &&
					( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType == CT_MidLevel  ))
				{
					// the the pawn is hiding have him go to a non hiding pose then stand up
					 ;	

					m_CoverFightData.m_CurrentCoverAction = CA_PopUp;

					m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_HidingToFiring;
					m_CoverFightData.m_TimeStartedLastCoverTransition = WorldInfo.TimeSeconds;

					m_SubStateDebugInfoTag="Trans out Before Stand";
					while(( m_CoverMoveData.m_CoverTransitionAction != CoverTransitionAction_NotTransitioning ) &&
						( (WorldInfo.TimeSeconds - m_CoverFightData.m_TimeStartedLastCoverTransition) < class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_MaxTimeToWaitForCoverTransitionToEnd ) )
					{
						DesiredRotation = m_CoverMoveData.m_RotAtStartOfTravel;
   						Pawn.DesiredRotation = DesiredRotation;
   						Pawn.SetRotation( DesiredRotation );
						Sleep(0.0);
					}
				}

				if( m_CoverMoveData.m_CurrentCover_Clamied.Link != None )
				{
					ClearCurrentCover();
				}

				m_SubStateDebugInfoTag="Travel UnCrouching";

				m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange = WorldInfo.TimeSeconds;

				if( Pawn != None && TPPawn(Pawn) != none )
				{
					Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToStanding;
				}

				//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " TravelToCoverSlotLoop:: Need to stand m_OpenFieldPostureSwitchingState: " @ Pawn.m_OpenFieldPostureSwitchingState @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				//Pawn.UnCrouch();

				;

				// OpenFieldPostureSwitchingState_GoingToCrouching
  				while(	(Pawn.bIsCrouched && Pawn != None && TPPawn(Pawn) != none) ||
  						(Pawn != None && TPPawn(Pawn) != none && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching ) )
  				{
  					// Keep The Pawn Facing the Same Direction when Standing
   					DesiredRotation = m_CoverMoveData.m_RotAtStartOfTravel;
   					Pawn.DesiredRotation = DesiredRotation;
   					Pawn.SetRotation( DesiredRotation );
  
  					Pawn.UnCrouch();
  					Sleep(0.0);
  
  					//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " TravelToCoverSlotLoop:: Need to stand and In Loop m_OpenFieldPostureSwitchingState: " @ Pawn.m_OpenFieldPostureSwitchingState @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
  
  
  					if( !Pawn.bIsCrouched && ( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange) >= 
  												class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToStandPostureChangeToFinish ) )
  					{
  						;
  						Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
  						break;
  					}
 				}

				if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedCQB_Needed )
				{
					;

					//`log(" ChadAI - Pawn " @ Pawn @ " TravelToCoverSlotLoop Movement was interputed by getting to close to an enemy so end travel with CQB need flag -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					PopState();
				}
				else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_PausedGrenadeOut )
				{
					;

					m_CoverMoveData.m_HasPathToCoverBeenBuilt = false;
					//Sleep(0.0);
					Goto('TravelToCoverSlotLoop');

				}

				//Sleep(5.0);
			}

			// if still in cover clear it
			if( m_CoverMoveData.m_CurrentCover_Clamied.Link != None )
			{
				ClearCurrentCover();
			}

			// yes we are getting the path again plame doug - why because you can
			KynapseClear();
			if( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link == None )
			{
				;
				PopState();
			}

			KynapseGoToFindPath( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link.GetSlotLocation( m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx ) );
			//DetermineMovementStyleToCoverSlot();

			m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_Moving;

			m_CoverMoveData.m_bTravelToCoverSlotTickLogicProcessedOnce = false;
			m_CoverMoveData.m_bNotAbleToTransitionIntoCover = true;

			;
			m_SubStateDebugInfoTag="KynapseFollowPath";
			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " TravelToCoverSlotLoop:: Calling KynapseFollowPath GetDistenceLeftOnPath: " @ GetDistenceLeftOnPath() @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			KynapseFollowPath(); // follow the found path 

			if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
			{
				KillTheTraveller();
				PopState();
			}

			;
			m_SubStateDebugInfoTag="KynapseFollowPath-Done";
			//`log(" ChadAI - Pawn: " @ Pawn @ " TPAIController::TravelToCoverSlot::TravelToCoverSlotLoop() back from KynapseFollowPath -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedCQB_Needed )
			{
				;

				//`log(" ChadAI - Pawn " @ Pawn @ " TravelToCoverSlotLoop Movement was interputed by getting to close to an enemy so end travel with CQB need flag -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				PopState();
			}
			else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_PausedGrenadeOut )
			{
				;

				m_CoverMoveData.m_HasPathToCoverBeenBuilt = false;
				Sleep(0.0);
				Goto('TravelToCoverSlotLoop');

			}
			else if( m_CoverMoveData.m_bTookHitWhileTraveling )
			{
				;

				m_CoverMoveData.m_HasPathToCoverBeenBuilt = false;
				Sleep(0.0);
				Goto('TravelToCoverSlotLoop');
			}
			else if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedEnemyMadeCoverInvalid )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " TravelToCoverSlotLoop - My Travel to Node: " @ m_MantleGoalInfo.m_PlaceToMantle.Link @ " slot: " @ m_MantleGoalInfo.m_PlaceToMantle.SlotIdx @ " was interputed because my current enemy made the cover invalid So Quit Travel State -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				;
		
				PopState();
			}
			else if( !m_CoverMoveData.m_bTravelToCoverSlotTickLogicProcessedOnce || m_CoverMoveData.m_bNotAbleToTransitionIntoCover )
			{
				;

				if( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link.Slots[m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx].CoverType == CT_Standing  )
				{
					Goto('TransitionIntoStandingCover');
				}
				else if( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link.Slots[m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx].CoverType == CT_OpenFieldMidLevel  )
				{
					Goto('TransitionIntoMidlevelCover');
				}
				else if( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link.Slots[m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx].CoverType == CT_MidLevel  )
				{
					Goto('TransitionIntoMidlevelCover');
				}
				else
				{	
					Goto('OpenFieldSnapToStandingCover');
				}
			}
			else if( Pawn.m_OpenFieldPostureSwitchingState == OpenFieldPostureSwitchingState_TransToStandingRight ||
						Pawn.m_OpenFieldPostureSwitchingState == OpenFieldPostureSwitchingState_TransToStandingLeft)
			{
				Goto('TransitionIntoStandingCover');
			}
			else if( Pawn.m_OpenFieldPostureSwitchingState == OpenFieldPostureSwitchingState_TransToMidlevel )
			{
				Goto('TransitionIntoMidlevelCover');
			}
			else if( Pawn.m_OpenFieldPostureSwitchingState == OpenFieldPostureSwitchingState_TransToMidlevelLeft )
			{
				Goto('TransitionIntoMidlevelCover');
			}
			else if ( !KynapseHasArrived() )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " TravelToCoverSlotLoop - back from KynapseFollowPath and Kynapse Failed so lets try again -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				;

				// m_CoverMoveData.m_bTookHitWhileTraveling;

				m_CoverMoveData.m_HasPathToCoverBeenBuilt = false;
				Sleep(0.0);
				Goto('TravelToCoverSlotLoop');
			}
			else
			{	
				// did arive yip
				;
				//`log(" ChadAI - Pawn: " @ Pawn @ " TravelToCoverSlotLoop - back from KynapseFollowPath and Kynapse got us there so end hopefully -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_DoneMovingAtCover;
			}


		} // end if( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link != None )
		else
		{
			;
			
			;
		
			PopState();
			//EvaluateSituation();
		} // end else of if( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link != None )
		
	} // end 	if (TPGameInfo(WorldInfo.Game).bKynapseEnabled)
	else
	{
		;
		;
		
		PopState();
	}
	//Sleep(3.0);

	;

	if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_PausedUnknown )
	{
		;
		Goto('TravelToCoverSlotLoop');
	}

	if( ( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link.Slots[m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx].CoverType == CT_OpenFieldStanding  )  || 
		( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link.Slots[m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx].CoverType == CT_OpenFieldStandingAtCover ) )
	{
		;

		Goto('OpenFieldSnapToStandingCover');
	}
	else
	{
		;
		PopState();
	}


OpenFieldSnapToStandingCover:

	m_SubStateDebugInfoTag="OpenFieldSnapToStandingCover";

	if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_PausedUnknown )
	{
		;
		Goto('TravelToCoverSlotLoop');
	}

	m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_DoneMovingAtCover;

	if( !m_CoverMoveData.m_bOccupingCoverSlot )
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::UseFightingPosition::OpenFieldSnapToStandingCover::!m_CoverMoveData.m_bOccupingCoverSlot: " @ m_CoverMoveData.m_bOccupingCoverSlot @ " THIS IS OK -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		if (!OccupyCover(m_CoverMoveData.m_ReservedGoToCover_Clamied))
		{
			;
			;
			
			EvaluateSituation();
		}
		else
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::TravelToCoverSlot::OpenFieldSnapToStandingCover::OccupyCover(m_CoverMoveData.m_ReservedGoToCover_Clamied) -  THIS IS GOOD-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			;
		}
	}
	else
	{
		//`log(" ChadAI - TPSoldierAIController::TravelToCoverSlot::OpenFieldSnapToStandingCover::m_CoverMoveData.m_bOccupingCoverSlot: " @ m_CoverMoveData.m_bOccupingCoverSlot @ " ||IsAtCover(m_CoverMoveData.m_currentCover) THIS IS BAD -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			;	
	}

	if( Enemy != None )
	{
		DesiredRotation = rotator( Enemy.Location - Pawn.Location );
		DesiredRotation.Pitch = 0;

		Pawn.DesiredRotation = DesiredRotation;
	}
	else
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ "TransitionIntoMidlevelCover Rotating Towards Node: " @ m_CoverMoveData.m_ReservedGoToCover_Clamied.Link @ " Slot: " @ m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		DesiredRotation = m_CoverMoveData.m_CurrentCover_Clamied.Link.GetSlotRotation(m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx);
		DesiredRotation.Pitch = 0;

		Pawn.DesiredRotation = DesiredRotation;
	}

	StopThisBot();

	if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
	{
		KillTheTraveller();
		PopState();
	}

	//`AILOG(0, 'Begin', "Snap to current cover");
	// snap to the location
	//`log(" ChadAI - TPSoldierAIController::TravelToCoverSlot::OpenFieldSnapToStandingCover:: - SnapToCurrentCover Being Called PopState-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	if (m_CoverMoveData.m_bOccupingCoverSlot)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::TravelToCoverSlot::OpenFieldSnapToStandingCover:: - SnapToCurrentCover Being Called PopState-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		SnapToCover(  m_CoverMoveData.m_CurrentCover_Clamied, true );		
	}
	m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_DoneMovingAtCover;

	PopState();

TransitionIntoMidlevelCover:

	m_SubStateDebugInfoTag="TransitionIntoMidlevelCover";

	m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_DoneMovingAtCover;

	m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

	//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ "TransitionIntoMidlevelCover started -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	StopFiring();

	;

	m_Engagement_Tac_Data.m_TimeStartedToWaitForToCrouchPostureChange = WorldInfo.TimeSeconds;

	if( m_CoverMoveData.m_bNotAbleToTransitionIntoCover )
	{
		Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToCrouching;
		//Pawn.SetPhysics(PHYS_None);
	}

 	Pawn.Mesh.RootMotionMode=RMM_Translate;
 	//Pawn.Mesh.RootMotionRotationMode=RMRM_Ignore;
 	Pawn.Mesh.bUpdateSkelWhenNotRendered=true;

	m_CoverFightData.m_bCanRotateToTargetDuringTrans = false;
	m_CoverFightData.m_bCanRotateToCoverSlotDuringTrans = true;

	if( Pawn != None )
	{
		Pawn.ShouldCrouch(true); // use distance and sight check to crouch
	}

	DesiredRotation = rotator( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link.GetSlotLocation(m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx) - Pawn.Location );
	DesiredRotation.Pitch = 0;

	Pawn.DesiredRotation = DesiredRotation;
	Pawn.SetRotation(DesiredRotation);

	while(	(Pawn != None && !Pawn.bIsCrouched ) ||
			(Pawn != None && (Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching) ) )
	{
		if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
		{
			KillTheTraveller();
			PopState();
		}

		//`log(" ChadAI - Pawn: " @ Pawn @ " TravelToCoverSlot Trans Loop -				Pawn Loc1: " @  Pawn.Location @ " BoneLoc2 " @ Pawn.Mesh.GetBoneLocation('JO_hip') @ " BoneLoc3 " @ Pawn.Mesh.GetBoneLocation('JO_positionTracker') @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ "TransitionIntoMidlevelCover trans Loop Crouching bIsCrouched: " @ Pawn.bIsCrouched @ " Switching State: " @ Pawn.m_OpenFieldPostureSwitchingState @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		//`AILog(2, 'TravelToCoverSlot',"TransitionIntoMidlevelCover Crouching bIsCrouched: " @ Pawn.bIsCrouched @ " Switching State: " @ Pawn.m_OpenFieldPostureSwitchingState @ " m_Move2CoverStatus: " @ m_CoverMoveData.m_Move2CoverStatus);
		Sleep(0.0);


		if( m_CoverMoveData.m_bNotAbleToTransitionIntoCover && Pawn.bIsCrouched)
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " TravelToCoverSlot Trans Loop - m_CoverMoveData.m_bNotAbleToTransitionIntoCover && Pawn.bIsCrouched so turning Phys off -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			Pawn.SetPhysics(PHYS_None);
		}

		//`log(" ChadAI - Pawn: " @ Pawn @ " TravelToCoverSlot Trans Loop after sleep-	Pawn Loc1: " @  Pawn.Location @ " BoneLoc2 " @ Pawn.Mesh.GetBoneLocation('JO_hip') @ " BoneLoc3 " @ Pawn.Mesh.GetBoneLocation('JO_positionTracker') @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_PausedUnknown || m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_PausedGrenadeOut)
		{
			;
			m_CoverMoveData.m_HasPathToCoverBeenBuilt = false;
			Goto('TravelToCoverSlotLoop');
		}

		//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Pawn.bIsCrouched: " @ Pawn.bIsCrouched @ " m_OpenFieldPostureSwitchingState: " @ Pawn.m_OpenFieldPostureSwitchingState @ " Time Waited: " @ WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToCrouchPostureChange @ " Max Time to Wait: " @ `TuneData.EngagementTacData.m_MaxTimeToWaitForToCrouchPostureChangeToFinish @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		if( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToCrouchPostureChange) >= 
									class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToTransIntoLowCoverToFinish )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ "TransitionIntoMidlevelCover trans Loop Crouching Waited to Long while changing Posture to crouch so force quiting bIsCrouched: " @ Pawn.bIsCrouched @ " Switching State: " @ Pawn.m_OpenFieldPostureSwitchingState @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ "TransitionIntoMidlevelCover Time Waited: " @ ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToCrouchPostureChange) @ "  Time to Wait: " @ `TuneData.EngagementTacData.m_MaxTimeToWaitForToTransIntoLowCoverToFinish @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			;
			Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
			break;
		}
	
	}
	Pawn.Mesh.RootMotionMode=RMM_Ignore;
 	Pawn.Mesh.bUpdateSkelWhenNotRendered=false;


	if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
	{
		KillTheTraveller();
		PopState();
	}

	//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ "TRANSITIONINTOMIDLEVELCOVER DONE WITH ANIMATION -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	m_CoverMoveData.m_CoverState = CoverBehavior_Hiding;

	m_Engagement_Tac_Data.m_LastTimeCrouched = WorldInfo.TimeSeconds;

	;
	

	if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_PausedUnknown )
	{
		;
		Goto('TravelToCoverSlotLoop');
	}

	m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_DoneMovingAtCover;

	if( !m_CoverMoveData.m_bOccupingCoverSlot )
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::UseFightingPosition::Begin::!m_CoverMoveData.m_bOccupingCoverSlot: " @ m_CoverMoveData.m_bOccupingCoverSlot @ " THIS IS OK -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		if (!OccupyCover(m_CoverMoveData.m_ReservedGoToCover_Clamied))
		{
			;
			;
			
			EvaluateSituation();
		}
		else
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::TravelToCoverSlot::TransitionIntoMidlevelCover::OccupyCover(m_CoverMoveData.m_ReservedGoToCover_Clamied) -  THIS IS GOOD-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			
		}
	}
	else
	{
		//`log(" ChadAI - TPSoldierAIController::TravelToCoverSlot::TransitionIntoMidlevelCover::m_CoverMoveData.m_bOccupingCoverSlot: " @ m_CoverMoveData.m_bOccupingCoverSlot @ " ||IsAtCover(m_CoverMoveData.m_currentCover) THIS IS BAD -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}
	if (m_CoverMoveData.m_bOccupingCoverSlot)
	{

		//`log(" ChadAI - Pawn: " @ Pawn @ " TravelToCoverSlot Before SnapToCover-		Pawn Loc1: " @  Pawn.Location @ " BoneLoc2 " @ Pawn.Mesh.GetBoneLocation('JO_hip') @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		SnapToCover(  m_CoverMoveData.m_CurrentCover_Clamied, true );
	}

	StopThisBot();
	//`log(" ChadAI - Pawn: " @ Pawn @ " TravelToCoverSlot after SnapToCover -		Pawn Loc1: " @  Pawn.Location @ " BoneLoc2 " @ Pawn.Mesh.GetBoneLocation('JO_hip') @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


	PopState();

TransitionIntoStandingCover:

	m_SubStateDebugInfoTag="TransitionIntoStandingCover";

	m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_DoneMovingAtCover;

	m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

	//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ "TransitionIntoStandingCover started -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	StopFiring();

	;

	m_Engagement_Tac_Data.m_TimeStartedToWaitForToCrouchPostureChange = WorldInfo.TimeSeconds;

 	Pawn.Mesh.RootMotionMode=RMM_Translate;
 	Pawn.Mesh.RootMotionRotationMode=RMRM_Ignore;
 	Pawn.Mesh.bUpdateSkelWhenNotRendered=true;

	m_CoverFightData.m_bCanRotateToTargetDuringTrans = false;
	m_CoverFightData.m_bCanRotateToCoverSlotDuringTrans = true;


	DesiredRotation = rotator( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link.GetSlotLocation(m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx) - Pawn.Location );
	DesiredRotation.Pitch = 0;

	Pawn.DesiredRotation = DesiredRotation;
	Pawn.SetRotation(DesiredRotation);

	while(	(Pawn != None && (Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching) ) )
	{
		if( TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
		{
			KillTheTraveller();
			PopState();
		}

		//`log(" ChadAI - Pawn: " @ Pawn @ " TravelToCoverSlot Trans Loop -				Pawn Loc1: " @  Pawn.Location @ " BoneLoc2 " @ Pawn.Mesh.GetBoneLocation('JO_hip') @ " BoneLoc3 " @ Pawn.Mesh.GetBoneLocation('JO_positionTracker') @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ "TransitionIntoStandingCover trans Loop Crouching bIsCrouched: " @ Pawn.bIsCrouched @ " Switching State: " @ Pawn.m_OpenFieldPostureSwitchingState @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		//`AILog(2, 'TravelToCoverSlot',"TransitionIntoStandingCover Crouching bIsCrouched: " @ Pawn.bIsCrouched @ " Switching State: " @ Pawn.m_OpenFieldPostureSwitchingState @ " m_Move2CoverStatus: " @ m_CoverMoveData.m_Move2CoverStatus);
		Sleep(0.0);

		//`log(" ChadAI - Pawn: " @ Pawn @ " TravelToCoverSlot Trans Loop after sleep-	Pawn Loc1: " @  Pawn.Location @ " BoneLoc2 " @ Pawn.Mesh.GetBoneLocation('JO_hip') @ " BoneLoc3 " @ Pawn.Mesh.GetBoneLocation('JO_positionTracker') @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_PausedUnknown || m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_PausedGrenadeOut)
		{
			;
			m_CoverMoveData.m_HasPathToCoverBeenBuilt = false;
			Goto('TravelToCoverSlotLoop');
		}

		//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Pawn.bIsCrouched: " @ Pawn.bIsCrouched @ " m_OpenFieldPostureSwitchingState: " @ Pawn.m_OpenFieldPostureSwitchingState @ " Time Waited: " @ WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToCrouchPostureChange @ " Max Time to Wait: " @ `TuneData.EngagementTacData.m_MaxTimeToWaitForToCrouchPostureChangeToFinish @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		if( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToCrouchPostureChange) >= 
									class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToTransIntoLowCoverToFinish )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ "TransitionIntoStandingCover trans Loop Crouching Waited to Long while changing Posture to crouch so force quiting bIsCrouched: " @ Pawn.bIsCrouched @ " Switching State: " @ Pawn.m_OpenFieldPostureSwitchingState @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ "TransitionIntoStandingCover Time Waited: " @ ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToCrouchPostureChange) @ "  Time to Wait: " @ `TuneData.EngagementTacData.m_MaxTimeToWaitForToTransIntoLowCoverToFinish @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			;
			Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
			break;
		}
	}

	//Pawn.Mesh.RootMotionMode=RMM_Accel;
	Pawn.Mesh.RootMotionMode=RMM_Ignore;
	//Pawn.Mesh.RootMotionRotationMode=RMRM_Ignore;
 	Pawn.Mesh.bUpdateSkelWhenNotRendered=false;


	if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
	{
		KillTheTraveller();
		PopState();
	}

	//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ "TRANSITIONINTOSTANDINGCOVER DONE WITH ANIMATION -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	m_CoverMoveData.m_CoverState = CoverBehavior_Hiding;

	m_Engagement_Tac_Data.m_LastTimeCrouched = WorldInfo.TimeSeconds;

	;
	

	if( m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_PausedUnknown )
	{
		;
		Goto('TravelToCoverSlotLoop');
	}

	m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_DoneMovingAtCover;

	if( !m_CoverMoveData.m_bOccupingCoverSlot )
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " TransitionIntoStandingCover::!m_CoverMoveData.m_bOccupingCoverSlot: " @ m_CoverMoveData.m_bOccupingCoverSlot @ " THIS IS OK -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		if (!OccupyCover(m_CoverMoveData.m_ReservedGoToCover_Clamied))
		{
			;
			;
			
			EvaluateSituation();
		}
// 		else
// 		{
// 			//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::TravelToCoverSlot::TransitionIntoMidlevelCover::OccupyCover(m_CoverMoveData.m_ReservedGoToCover_Clamied) -  THIS IS GOOD-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 			
// 		}
	}
	else
	{
		//`log(" ChadAI - TransitionIntoStandingCover::m_CoverMoveData.m_bOccupingCoverSlot: " @ m_CoverMoveData.m_bOccupingCoverSlot @ " ||IsAtCover(m_CoverMoveData.m_currentCover) THIS IS BAD -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}

	//`AILOG(0, 'Begin', "Snap to current cover");
	//Sleep(0.0);

	if (m_CoverMoveData.m_bOccupingCoverSlot)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " TransitionIntoStandingCover Before SnapToCover-		Pawn Loc1: " @  Pawn.Location @ " BoneLoc2 " @ Pawn.Mesh.GetBoneLocation('JO_hip') @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		SnapToCover(  m_CoverMoveData.m_CurrentCover_Clamied, true );
	}

	StopThisBot();

	//`log(" ChadAI - Pawn: " @ Pawn @ " TransitionIntoStandingCover after SnapToCover -		Pawn Loc1: " @  Pawn.Location @ " BoneLoc2 " @ Pawn.Mesh.GetBoneLocation('JO_hip') @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


	PopState();
}


native final function bool DoINeedToSlideIntoTheSlot(CoverInfo SlotToSlideInto);
// {
// 	//`log(" ChadAI - Pawn: " @ Pawn @ " DoINeedToSlideIntoTheSlot Dist to Slot: " @ VSize(m_CoverMoveData.m_CurrentCover_Clamied.Link.GetSlotLocation( m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx) - Pawn.Location) @ " Max Snap Dist: " @ `TuneData.CoverEngagementTuneData.m_MinDistToSlideIntoCoverCrouched @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 
// 	if( VSizeSq(SlotToSlideInto.Link.GetSlotLocation( SlotToSlideInto.SlotIdx) - Pawn.Location) > (`TuneData.CoverEngagementTuneData.m_MinDistToSlideIntoCoverCrouched*`TuneData.CoverEngagementTuneData.m_MinDistToSlideIntoCoverCrouched ) )
// 	{
// 		return true;
// 	}
// 
// 	return false;
// }

native final function SlideMeALIttleBitFatherIntoTheSlot( float AmountToSlide, CoverInfo SlotToSlideInto );
// {
// 	local vector vecToSlot;
// 
// 	vecToSlot = Normal(SlotToSlideInto.Link.GetSlotLocation( SlotToSlideInto.SlotIdx) - Pawn.Location);
// 	vecToSlot.Z = 0.0f;
// 
// 	Pawn.SetLocation( Pawn.Location + ( vecToSlot * AmountToSlide ));
// 
// }

//-----------------------------------------------------------------------
// State:		TravelToCoverWhileTerimating
// Description: 
//	
//-----------------------------------------------------------------------
state TravelToCoverWhileTerimating
{
	function BeginState(Name PreviousStateName)
	{
		//`log(" ChadAI - TPAIController::TravelToCoverWhileTerimating::BeginState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
		;		
		//Super.BeginState(PreviousStateName);
		m_bMoveAborted = false;
	}
	function EndState(Name NextStateName)
	{
		//`log(" ChadAI - TPAIController::TravelToCoverWhileTerimating::EndState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;		
		
		//Super.EndState(NextStateName);		
	}

	
	event PushedState()
	{
		;		
	}
	event PoppedState()
	{
		;		

		KynapseClear();
	}	
	
	event PausedState()
	{
		//`log(" ChadAI - TPAIController::TravelToCoverWhileTerimating::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		;		
	}

	event ContinuedState()
	{
		//`log(" ChadAI - TPAIController::TravelToCoverWhileTerimating::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;		
		if (Pawn != none)
		{
            //Pawn.SetMovementPhysics();
        }

		//Super.ContinuedState(); 
		
	}
	
	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
		//`log(" ChadAI - " @ self @ "TravelToCoverWhileTerimating::OnSeeEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
		CheckForEnemy(false);
	}
	
	event OnHearEnemy(int playerIdx)
	{
		//`log(" ChadAI - SENSING - " @ self @ "TravelToCoverWhileTerimating::OnHearEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
		CheckForEnemy(false);
	}
	
    function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		// do nothing for now
		//`log(" ChadAI - TPSoldierAIController::TravelToCoverSlot::NotifyWeaponFired  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		
    }
		
	
	event Tick( float DeltaTime )
	{
		//`log(" ChadAI - TPSoldierAIController::TravelToCoverWhileTerimating::Tick -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		//`log(" ChadAI - TPSoldierAIController::TravelToCoverWhileTerimating::Tick:: Pawn.Location " @ Pawn.Location @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		

		if( m_TerminatorInfo.m_CurrentThingToKill != None )
		{
			Focus = m_TerminatorInfo.m_CurrentThingToKill;

			Target = m_TerminatorInfo.m_CurrentThingToKill;
			DesiredRotation = rotator(Focus.Location - Pawn.Location);
			DesiredRotation.Pitch = 0;

		}
		else
		{
			Focus = m_CoverMoveData.m_ReservedGoToCover_Clamied.Link;

			Target = None; //m_CoverMoveData.m_ReservedGoToCover_Clamied.Link;

			DesiredRotation = rotator(Focus.Location - Pawn.Location);
			DesiredRotation.Pitch = 0;
		}

		if ( ShouldIFire() )
		{
			//`log(" ChadAI - TravelToCoverWhileTerimating::begin: ShouldIFire()");

			//`AILOG(0, 'Begin', "start firing");
			
				TP_AiStartFiring();
			


		}
		else
		{
			StopFiring();
		}

		UpdateAimInTheOpen(FALSE);;
		UpdateHeadtracking();
		Super.Tick(DeltaTime);
	
	}
	
	function bool FinishedTravelling()
	{
		;

		//`log(" ChadAI - Pawn: " @ Pawn @ " TPAIController TravelToCoverSlot::FinishedTravelling() --------------------------------------------------------------------------------------------");
		
		if( !m_CoverMoveData.m_bOccupingCoverSlot )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::UseFightingPosition::Begin::!m_CoverMoveData.m_bOccupingCoverSlot: " @ m_CoverMoveData.m_bOccupingCoverSlot @ " THIS IS OK -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			if (!OccupyCover(m_CoverMoveData.m_ReservedGoToCover_Clamied))
			{
				;
				;
				;
				;
				;
				;
				;
				;
				;
				;
				;
				;
				;
				;
				;
				;
				;
				;
				;
				;
				;
				;
				;
				;
				;
				;
				;
				
				EvaluateSituation();

			}
			else
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::TravelToCoverSlot::FinishedTravelling::OccupyCover(m_CoverMoveData.m_ReservedGoToCover_Clamied) -  THIS IS GOOD-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				
			}
		}
		else
		{
			//`log(" ChadAI - TPSoldierAIController::TravelToCoverSlot::Begin::m_CoverMoveData.m_bOccupingCoverSlot: " @ m_CoverMoveData.m_bOccupingCoverSlot @ " ||IsAtCover(m_CoverMoveData.m_currentCover) THIS IS BAD -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		}

		//`AILOG(0, 'Begin', "Snap to current cover");
		// snap to the location
		//`log(" ChadAI - TPSoldierAIController::TravelToCoverSlot::Begin:: - SnapToCurrentCover Being Called PopState-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		if (m_CoverMoveData.m_bOccupingCoverSlot)
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " TPSoldierAIController::TravelToCoverSlot::Begin:: - SnapToCurrentCover Being Called PopState-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			SnapToCover(  m_CoverMoveData.m_CurrentCover_Clamied, true );		
			return true;
		}

		//`log(" ChadAI - TPSoldierAIController::TravelToCoverSlot::Begin:: - SnapToCurrentCover Not being called did not get there -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


		return false;
	}	

Begin:

	m_SubStateDebugInfoTag="Begin";

	//`log(" ChadAI - Pawn: " @ Pawn @ " TPAIController::TravelToCoverWhileTerimating::Begin()-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					
	m_CoverFightData.m_bUsingFightingPosition = true;

TravelToCoverWhileTerimatingLoop:

	if( m_TerminatorInfo.m_CurrentThingToKill != None )
	{
		Target = m_TerminatorInfo.m_CurrentThingToKill;

		Focus = Target;
	}
	else
	{
		Target = None;
		Focus = None;
	}


	if ( ShouldIFire() )
	{
		//`log(" ChadAI - Attack_Stand_Before_Charge::begin: ShouldIFire()");

		//`AILOG(0, 'Begin', "start firing");
		
			TP_AiStartFiring();
		


	}
	else
	{
		StopFiring();
	}

	//`log(" ChadAI - Pawn: " @ Pawn @ " TPAIController::TravelToCoverWhileTerimatingLoop() top -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	if (TPGameInfo(WorldInfo.Game).bKynapseEnabled)
	{
		if( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link != None )
		{
			if( !m_CoverMoveData.m_HasPathToCoverBeenBuilt )
			{
				// old way
				//`log(" ChadAI - Pawn: " @ Pawn @ " TravelToCoverWhileTerimatingLoop path has not already been builtBuilding Path -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_BuildingPath;

				KynapseGoToFindPath( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link.GetSlotLocation( m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx ) );

				//`log(" ChadAI - Pawn: " @ Pawn @ " TravelToCoverWhileTerimatingLoop back from building path -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				
				if ( !KynapseFoundPath() )
				{
					//`log(" ChadAI - Pawn " @ Pawn @ " TravelToCoverWhileTerimatingLoop Does Not have Cover Path so fail travel and InvalidateMoveGoal -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
					m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_FailedNoPath;

					InvalidateMoveGoal( m_CoverMoveData.m_ReservedGoToCover_Clamied.Link, m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx );

					PopState();
				}
				else
				{
					//`log(" ChadAI - Pawn " @ Pawn @ " TravelToCoverWhileTerimatingLoop::Begin Does Have Cover Path so travel -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				}
			
			}
			else
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " TravelToCoverWhileTerimatingLoop Path has already been built -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				// new way
			}

			//`log(" ChadAI - Pawn: " @ Pawn @ " TravelToCoverWhileTerimatingLoop just before KynapseFollowPath -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_Moving;
			KynapseFollowPath(); // follow the found path 

			//`log(" ChadAI - Pawn: " @ Pawn @ " TravelToCoverWhileTerimatingLoop back from KynapseFollowPath -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


			if ( !KynapseHasArrived() )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " TravelToCoverWhileTerimatingLoop - back from KynapseFollowPath and Kynapse Failed so lets try again -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				// m_CoverMoveData.m_bTookHitWhileTraveling;

				m_CoverMoveData.m_HasPathToCoverBeenBuilt = false;
				Sleep(0.0);
				Goto('TravelToCoverWhileTerimatingLoop');
			}
			else
			{	
				// did arive yip
				//`log(" ChadAI - Pawn: " @ Pawn @ " TravelToCoverWhileTerimatingLoop - back from KynapseFollowPath and Kynapse got us there so end hopefully -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_DoneMovingAtCover;
			}

		}
		else
		{
			;
			;
			;
			;
			;
			;
			;
			;
			;
			;
			;
			;
			;
			;
			;
			;
			;
			;
			;
			;
			;
		
			;

			EvaluateSituation();
		}

		
	}
	else
	{
		;
		;
		;
		;
		;
		;
		;
		;
		;
		;
		;
		;
	}
	//Sleep(3.0);

	if( !FinishedTravelling() )
	{
		Goto('TravelToCoverWhileTerimatingLoop');
	}
	else
	{
		PopState();
	}
}

native final function bool TestCanMantleNow();

//-----------------------------------------------------------------------
// State:		RespondToGrenadeOutGoal
// Description:
//-----------------------------------------------------------------------
state RespondToGrenadeOutGoal
{
	function BeginState(Name PreviousStateName)
	{

		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		//m_CoverFightData.m_bUsingFightingPosition = true;
		//`log(" ChadAI - TPSoldierAIController::RespondToGrenadeOutGoal::BeginState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
	}
	
	event PausedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		//`log(" ChadAI - TPSoldierAIController::RespondToGrenadeOutGoal::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	event ContinuedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		//`log(" ChadAI - TPSoldierAIController::RespondToGrenadeOutGoal::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}

	event PoppedState()
	{
		;

		//m_HighLevelAiGoal = HighLevelAiGoal_NONE;
		m_DangerAwarenessData.m_bReactingToGrenadeOut = false;
		m_DangerAwarenessData.m_bCoverHasBeenClearedAndReserved = false;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;


		//`log(" ChadAI - TPSoldierAIController::RespondToGrenadeOutGoal::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}
	
	function EndState(Name NextStateName)
	{
		;

		//m_HighLevelAiGoal = HighLevelAiGoal_NONE;
		m_DangerAwarenessData.m_bReactingToGrenadeOut = false;
		m_DangerAwarenessData.m_bCoverHasBeenClearedAndReserved = false;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		//`log(" ChadAI - TPSoldierAIController::RespondToGrenadeOutGoal::EndState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}
	
	function AccomplishedGoal()
	{
		//`log(" ChadAI - TPSoldierAIController::RespondToGrenadeOutGoal::AccomplishedGoal() -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		m_CoverFightData.m_bUsingFightingPosition = false;
		//ClearLatentAction(class'SeqAct_AIDefendCover',false);
	}

	function RandomlyChooseReactionStateBesidesHotToss()
	{
		//local TPPawn tppawn;
		local bool bcanMantle;

		bcanMantle = false;

		//tppawn = TPPawn(Pawn);

		// test if mantling is possible if enabled and if not possible if enabled remove its chance of happening

		
		if( m_DangerAwarenessData.m_bReactToGrenadesByJumpingOverCover )
		{
			bcanMantle = TestCanMantleNow();

			if( !bcanMantle )
			{
				m_DangerAwarenessData.m_RandDrawForReaction = m_DangerAwarenessData.m_RandDrawForReaction - m_DangerAwarenessData.m_ChanceOfReactingToGrenadesByJumpingOverCover;
				//`log(" ChadAI - Pawn: " @ Pawn @ " RandomlyChooseReactionStateBesidesHotToss Can NOT Jump Over Cover TestCanMantleNow() = True - Rand Draw: " @ m_DangerAwarenessData.m_RandDrawForReaction @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			}
			else
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " RandomlyChooseReactionStateBesidesHotToss Can Jump Over Cover TestCanMantleNow() = False -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			}
		}
		else
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " RandomlyChooseReactionStateBesidesHotToss Can Not Jump Over Cover m_bReactToGrenadesByJumpingOverCover = False -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		}

		// Try Each possible reaction except hot toss because I already tested
		if( bcanMantle )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " RandomlyChooseReactionStateBesidesHotToss bcanMantle = True so check chance: " @ m_DangerAwarenessData.m_RandDrawForReaction @"  againts: " @ m_DangerAwarenessData.m_ChanceOfReactingToGrenadesByJumpingOverCover @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			if( m_DangerAwarenessData.m_RandDrawForReaction <= m_DangerAwarenessData.m_ChanceOfReactingToGrenadesByJumpingOverCover )
			{
				m_DangerAwarenessData.m_ResponseToGrenadeSubBehavior = GrenResposeBeh_JumpOverCover;
				return;
				//PushState('JumpOverCoverToGetAwayFromGrenade');			
			}
			else
			{
				;

				m_DangerAwarenessData.m_RandDrawForReaction = m_DangerAwarenessData.m_RandDrawForReaction - m_DangerAwarenessData.m_ChanceOfReactingToGrenadesByJumpingOverCover;

				//`log(" ChadAI - Pawn: " @ Pawn @ " RandomlyChooseReactionStateBesidesHotToss Able to Mantle but Not going to becuase rand draw-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			}
		}
		
		if( m_DangerAwarenessData.m_bReactToGrenadesByRunningAway )
		{
			if( m_DangerAwarenessData.m_RandDrawForReaction <= m_DangerAwarenessData.m_ChanceOfReactingToGrenadesByRunningAway )
			{
				;
				m_DangerAwarenessData.m_ResponseToGrenadeSubBehavior = GrenResposeBeh_RunAway;
				return;
				//PushState('RunawayFromGrenade'); // test for Doug			
			}
			else
			{
				;

				m_DangerAwarenessData.m_RandDrawForReaction = m_DangerAwarenessData.m_RandDrawForReaction - m_DangerAwarenessData.m_ChanceOfReactingToGrenadesByRunningAway;
			}
		}
		
		if( m_DangerAwarenessData.m_bReactToGrenadesByCowering )
		{
			if( m_DangerAwarenessData.m_RandDrawForReaction <= m_DangerAwarenessData.m_ChanceOfReactingToGrenadesByCowering )
			{
				;
				m_DangerAwarenessData.m_ResponseToGrenadeSubBehavior = GrenResposeBeh_Cower;
				return;
				//PushState('CoweringFromGrenade');		
			}
			else
			{
				;

				m_DangerAwarenessData.m_RandDrawForReaction = m_DangerAwarenessData.m_RandDrawForReaction - m_DangerAwarenessData.m_ChanceOfReactingToGrenadesByCowering;
			}
		}

		if( m_DangerAwarenessData.m_ResponseToGrenadeSubBehavior == GrenResposeBeh_HaveNotChosenResponse )
		{
			;
			m_DangerAwarenessData.m_ResponseToGrenadeSubBehavior = GrenResposeBeh_NotGoingToRespond;
		}
	}

	function bool ShouldDoIntialResponseToGrenadeOut()
	{
		local float randDraw;

		randDraw = RandRange(0.0, 1.0);

		if( randDraw <= m_DangerAwarenessData.m_ChanceToPerformInitialReactingToGrenadeOut )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " RespondToGrenadeOutGoal ShouldDoIntialResponseToGrenadeOut YES randDraw: " @ randDraw @ " Chance " @ m_DangerAwarenessData.m_ChanceToPerformInitialReactingToGrenadeOut @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
			return true;
		}

		//`log(" ChadAI - Pawn: " @ Pawn @ " RespondToGrenadeOutGoal ShouldDoIntialResponseToGrenadeOut NO randDraw: " @ randDraw @ " Chance " @ m_DangerAwarenessData.m_ChanceToPerformInitialReactingToGrenadeOut @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		return false;
	}

	function HandleCoverStatusClearingAndReserving()
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " RespondToGrenadeOutGoal:: Before ClearCurrentCover Node: " @ m_CoverMoveData.m_CurrentCover_Clamied.Link @ " Slot: " @ m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		if (m_CoverMoveData.m_CurrentCover_Clamied.Link != None)
		{
			;

			m_DangerAwarenessData.m_CoverToReserve = m_CoverMoveData.m_CurrentCover_Clamied;
			ClearCurrentCover();
		}

		if( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link != None )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " RespondToGrenadeOutGoal:: has m_CurrentlyCoverToUseAsFightPos Node: " @ m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link @ " Slot: " @ m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.SlotIdx @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
			;

			m_DangerAwarenessData.m_CoverToReserve = m_CoverFightData.m_CurrentlyCoverToUseAsFightPos;
		}

		//`log(" ChadAI - Pawn: " @ Pawn @ " RespondToGrenadeOutGoal:: after ClearCurrentCover Pawn.bIsCrouched: " @ Pawn.bIsCrouched @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		if( m_DangerAwarenessData.m_CoverToReserve.Link != None )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " RespondToGrenadeOutGoal:: has m_CoverToReserve Node: " @ m_DangerAwarenessData.m_CoverToReserve.Link @ " Slot: " @ m_DangerAwarenessData.m_CoverToReserve.SlotIdx @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
			;

			ReserveCover(m_DangerAwarenessData.m_CoverToReserve);
		}
		else
		{
			;

			//`log(" ChadAI - Pawn: " @ Pawn @ " RespondToGrenadeOutGoal:: Does not have m_CoverToReserve but My already reserved cover is Node: " @ m_CoverMoveData.m_ReservedGoToCover_Clamied.Link @ " Slot: " @ m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		}

		//`log(" ChadAI - Pawn: " @ Pawn @ " RespondToGrenadeOutGoal:: after ReserveCover Pawn.bIsCrouched: " @ Pawn.bIsCrouched @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		HandleLeftCoverCollisionChange(m_CoverFightData.m_CurrentlyCoverToUseAsFightPos);

		//`log(" ChadAI - Pawn: " @ Pawn @ " RespondToGrenadeOutGoal:: after HandleLeftCoverCollisionChange Pawn.bIsCrouched: " @ Pawn.bIsCrouched @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		ResetCoverAction();

		//`log(" ChadAI - Pawn: " @ Pawn @ " RespondToGrenadeOutGoal:: after ResetCoverAction Pawn.bIsCrouched: " @ Pawn.bIsCrouched @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		StopFiring();

		m_DangerAwarenessData.m_bCoverHasBeenClearedAndReserved = true;
	}
	
	event Tick( float DeltaTime )
	{
		//`log(" ChadAI - TPSoldierAIController::RespondToGrenadeOutGoal::Tick -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		//UpdateAimInTheOpen(FALSE);;
		SetAimToStrightAhead();
		UpdateHeadtracking();
		//Super.Tick(DeltaTime);	
	}

Begin:

	m_SubStateDebugInfoTag="Begin";

	m_DangerAwarenessData.m_CoverToReserve.Link = None;
	m_DangerAwarenessData.m_CoverToReserve.SlotIdx = -1;

	m_DangerAwarenessData.m_bCoverHasBeenClearedAndReserved = false;

	// no matter what we were doing as far as a cover transition it is now over.
	m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_NotTransitioning;

	//`log(" ChadAI - Pawn: " @ Pawn @ " RespondToGrenadeOutGoal::Begin Pawn.bIsCrouched: " @ Pawn.bIsCrouched @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	m_DangerAwarenessData.m_ResponseToGrenadeSubBehavior = GrenResposeBeh_HaveNotChosenResponse;

	//m_HighLevelAiGoal = HighLevelAiGoal_RespondToGrenadeOutGoal;

	//`log(" ChadAI - RespondToGrenadeOutGoal::Begin jUST ClearCurrentCover AND ResetCoverAction *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
	RandomlyPlayGrenadeScream();

	if( m_LastThreat.ThreatMaker != None )
	{
		m_DangerAwarenessData.m_CurrentGrenToReactToo = PhysicsGrenade(m_LastThreat.ThreatMaker);
	}

	//`log(" ChadAI - RespondToGrenadeOutGoal::Begin jUST Back From Sleep Before PushState('InitialResponseToGrenadeOut')*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	// see if should do Initial Response to gren by rand chance
	if( ShouldDoIntialResponseToGrenadeOut() )
	{
		HandleCoverStatusClearingAndReserving();

		PushState('InitialResponseToGrenadeOut');
	}

	//`log(" ChadAI - Pawn: " @ Pawn @ " RespondToGrenadeOutGoal:: after InitialResponseToGrenadeOut Pawn.bIsCrouched: " @ Pawn.bIsCrouched @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );


	//`log(" ChadAI - RespondToGrenadeOutGoal::Begin jUST Back From PushState('InitialResponseToGrenadeOut')*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	//Sleep(0.0);

	//`log(" ChadAI - RespondToGrenadeOutGoal::Begin jUST Back From Sleep after PushState('InitialResponseToGrenadeOut')*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
	
	m_DangerAwarenessData.m_RandDrawForReaction = RandRange(0.0f, 1.0f);

DetermineWhatToDoPhase:

	m_SubStateDebugInfoTag="Determining What to do";

	//`log(" ChadAI - Pawn: " @ Pawn @ " RespondToGrenadeOutGoal - RandomlyChooseReactionState " @ m_DangerAwarenessData.m_RandDrawForReaction @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	m_DangerAwarenessData.m_bCanThrowThisGrenBack = false;
	// lets try hot tossing the gren first then try everything else
	// if m_DangerAwarenessData.m_ResponseToGrenadeSubBehavior == GrenResposeBeh_ThrowBack it means that I already tried to throw is back and can not get there after standing up
	if( m_DangerAwarenessData.m_bReactToGrenadesByThrowingBack && m_DangerAwarenessData.m_ResponseToGrenadeSubBehavior != GrenResposeBeh_ThrowBack)
	{
		m_DangerAwarenessData.m_DistanceToGrenade =	VSize( m_DangerAwarenessData.m_CurrentGrenToReactToo.Location - Pawn.Location );

		if( m_DangerAwarenessData.m_DistanceToGrenade <= m_DangerAwarenessData.m_RangeOfReactingToGrenadesByThrowingBack )
		{
			;

			KynapseGoToFindPath(m_DangerAwarenessData.m_CurrentGrenToReactToo.Location);

			if ( KynapseFoundPath() )
			{
				;

				if( m_DangerAwarenessData.m_RandDrawForReaction <= m_DangerAwarenessData.m_ChanceOfReactingToGrenadesByThrowingBack )
				{
					;

					if( m_DangerAwarenessData.m_CurrentGrenToReactToo.RegisterToHotToss( Pawn ) )
					{
						;

						m_DangerAwarenessData.m_PathBuiltToGrenade = true;
						m_DangerAwarenessData.m_bCanThrowThisGrenBack = true;


						m_DangerAwarenessData.m_ResponseToGrenadeSubBehavior = GrenResposeBeh_ThrowBack;

						Goto('PrepForSubState');
					}
					else
					{
						;

						KynapseClear();
						m_DangerAwarenessData.m_PathBuiltToGrenade = false;
						m_DangerAwarenessData.m_bCanThrowThisGrenBack = false;
					}
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
		
		if( !m_DangerAwarenessData.m_bCanThrowThisGrenBack )
		{
			m_DangerAwarenessData.m_RandDrawForReaction = m_DangerAwarenessData.m_RandDrawForReaction - m_DangerAwarenessData.m_ChanceOfReactingToGrenadesByThrowingBack;
		}
	}

	if( !m_DangerAwarenessData.m_bCanThrowThisGrenBack )
	{
		RandomlyChooseReactionStateBesidesHotToss();

		if( ( m_DangerAwarenessData.m_ResponseToGrenadeSubBehavior != GrenResposeBeh_HaveNotChosenResponse ) || 
			( m_DangerAwarenessData.m_ResponseToGrenadeSubBehavior != GrenResposeBeh_NotGoingToRespond ) )
		{
			Goto('PrepForSubState');
		}
	}

	//`log(" ChadAI - RespondToGrenadeOutGoal::Begin jUST Back From RandomlyChooseReactionState *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	Sleep(0.0);

	//`log(" ChadAI - RespondToGrenadeOutGoal::Begin jUST Back From Sleep(0.01) after RandomlyChooseReactionState *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );


	//`log(" ChadAI - RespondToGrenadeOutGoal::Begin call ENDED  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

RespondToGrenadeOutGoalLoop:
	//`log(" ChadAI - RespondToGrenadeOutGoal::RespondToGrenadeOutGoalLoop PopState *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
	
	AccomplishedGoal();
	
	PopState();

	Sleep(0.0);
	//GotoState('Idle');

PrepForSubState:

	m_SubStateDebugInfoTag="PrepForSubState";

	if( !m_DangerAwarenessData.m_bCoverHasBeenClearedAndReserved && m_DangerAwarenessData.m_ResponseToGrenadeSubBehavior != GrenResposeBeh_Cower )
	{
		;
		HandleCoverStatusClearingAndReserving();
	}


	// intentially fall through to stand up
StandUp:

	if (Pawn.bIsCrouched && m_DangerAwarenessData.m_ResponseToGrenadeSubBehavior != GrenResposeBeh_Cower )
	{
		m_SubStateDebugInfoTag="Respond UnCrouching";

		//`log(" ChadAI - Pawn: " @ Pawn @ " RespondToGrenadeOutGoal standing m_ResponseToGrenadeSubBehavior: " @ m_DangerAwarenessData.m_ResponseToGrenadeSubBehavior @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange = WorldInfo.TimeSeconds;

		if( Pawn != None && TPPawn(Pawn) != none )
		{
			Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToStanding_Panic;
		}

		;


		// OpenFieldPostureSwitchingState_GoingToCrouching
		while(	(Pawn.bIsCrouched && Pawn != None && TPPawn(Pawn) != none) ||
				(Pawn != None && TPPawn(Pawn) != none && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching ) )
		{
			Pawn.UnCrouch();
			Sleep(0.0);

			if( !Pawn.bIsCrouched && ( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange) >= 
										class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToPanicStandPostureChangeToFinish ) )
			{
				;
				Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
				break;
			}
		}

		// if going to try and throw back see if it is still close enough

		if( ( m_DangerAwarenessData.m_CurrentGrenToReactToo == None ) || ( m_DangerAwarenessData.m_CurrentGrenToReactToo.HaveGoneBoom() ) )
		{
			// gren all ready blew so go back
			;
			Goto('RespondToGrenadeOutGoalLoop');
		}

		if( m_DangerAwarenessData.m_ResponseToGrenadeSubBehavior == GrenResposeBeh_ThrowBack )
		{
			// intentail of size and not size sq
			m_DangerAwarenessData.m_DistanceToGrenade =	VSize( m_DangerAwarenessData.m_CurrentGrenToReactToo.Location - Pawn.Location );

			if( m_DangerAwarenessData.m_DistanceToGrenade <= m_DangerAwarenessData.m_RangeOfReactingToGrenadesByThrowingBack )
			{
				;
				//`log(" ChadAI - Pawn: " @ Pawn @ " RespondToGrenadeOutGoal After Standing the Grenade is still close enough to throw back *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

			}
			else
			{
				;
				//`log(" ChadAI - Pawn: " @ Pawn @ " RespondToGrenadeOutGoal After Standing the Grenade is to far to throw back so try something else *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

				Goto('DetermineWhatToDoPhase');
			}

		}

	}

GotoSubStatePhase:

	m_SubStateDebugInfoTag="PrepForSubState";

	switch( m_DangerAwarenessData.m_ResponseToGrenadeSubBehavior )
	{
	case GrenResposeBeh_ThrowBack:
		PushState('ThrowGrenadeBack');
		break;

	case GrenResposeBeh_RunAway:
		PushState('RunawayFromGrenade'); // test for Doug
		break;

	case GrenResposeBeh_JumpOverCover:
		PushState('JumpOverCoverToGetAwayFromGrenade');
		break;

	case GrenResposeBeh_Cower:
		PushState('CoweringFromGrenade');
		break;
	}

	Goto('RespondToGrenadeOutGoalLoop');

		
}

//-----------------------------------------------------------------------
// State:	InitialResponseToGrenadeOut
// Description: 
//-----------------------------------------------------------------------
state InitialResponseToGrenadeOut
{
	function BeginState(Name PreviousStateName)
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		//`log(" ChadAI - TPSoldierAIController::InitialResponseToGrenadeOut::BeginState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
	}
	
	event PausedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;
		if( Pawn != None )
		{
			TPPawn(Pawn).m_bReactingToGrenadeOut = false;
		}

		//`log(" ChadAI - TPSoldierAIController::InitialResponseToGrenadeOut::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	event ContinuedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		if( Pawn != None )
		{
			TPPawn(Pawn).m_bReactingToGrenadeOut = true;
		}

		//`log(" ChadAI - TPSoldierAIController::InitialResponseToGrenadeOut::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}

	event PoppedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		if( Pawn != None )
		{
			TPPawn(Pawn).m_bReactingToGrenadeOut = false;
		}

		m_DangerAwarenessData.m_TimeStartedInitialReactingToGrenadeOut = -1.0;

		//`log(" ChadAI - TPSoldierAIController::InitialResponseToGrenadeOut::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}
	
	function EndState(Name NextStateName)
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		if( Pawn != None )
		{
			TPPawn(Pawn).m_bReactingToGrenadeOut = false;
		}

		m_DangerAwarenessData.m_TimeStartedInitialReactingToGrenadeOut = -1.0;

		//`log(" ChadAI - TPSoldierAIController::InitialResponseToGrenadeOut::EndState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}
	
    function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		// do nothing for now
		//`log(" ChadAI - TPSoldierAIController::InitialResponseToGrenadeOut::NotifyWeaponFired  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
    }

	function DoneWithSupriseAnimation()
	{
		if( Pawn != None )
		{
			TPPawn(Pawn).m_bReactingToGrenadeOut = false;
		}

		PopState();
	}

	function float GetDelayBeforeReaction()
	{
		local float randDraw;

		randDraw = RandRange(0.0, class'TPTuneManager'.static.Get().GetTuneData().GrenadeUseData.m_MaxDelayTimeBeforeReactingToInitialGrenadeOut );

		//`log(" ChadAI - Pawn: " @ Pawn @ " InitialResponseToGrenadeOut GetDelayBeforeReaction: " @ randDraw @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		return randDraw;
	}
	
	event Tick( float DeltaTime )
	{
		//UpdateAimInTheOpen(FALSE);;
		SetAimToStrightAhead();
		UpdateHeadtracking();

		// make sure that two much time has not has passed for the animation to finish
		if( Pawn != None && m_DangerAwarenessData.m_TimeStartedInitialReactingToGrenadeOut > 0.0 )
		{
			if( (WorldInfo.TimeSeconds - m_DangerAwarenessData.m_TimeStartedInitialReactingToGrenadeOut ) >= class'TPTuneManager'.static.Get().GetTuneData().GrenadeUseData.m_MaxTimeReactingToInitialGrenadeOut )
			{
				;

				TPPawn(Pawn).m_bReactingToGrenadeOut = false;
				m_DangerAwarenessData.m_TimeStartedInitialReactingToGrenadeOut = -1.0;
				PopState();
			}
		}

		//Super.Tick(DeltaTime);	
	}		

Begin:

	m_SubStateDebugInfoTag="Begin";

	//`log(" ChadAI - Pawn: " @ Pawn @ " InitialResponseToGrenadeOut::Begin Pawn.bIsCrouched: " @ Pawn.bIsCrouched @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );


	m_DangerAwarenessData.m_TimeStartedInitialReactingToGrenadeOut = -1.0;

	StopFiring();

	if( m_DangerAwarenessData.m_CurrentGrenToReactToo != None )
	{
		if( RandRange(0.0, 1.0) <= m_DangerAwarenessData.m_ChanceToTurnTowardsGrenDuringInitialReactingToGrenadeOut )
		{
			Focus = m_DangerAwarenessData.m_CurrentGrenToReactToo;
		}
	}

	//`log(" ChadAI - TPSoldierAIController::InitialResponseToGrenadeOut::Begin  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	
	m_SubStateDebugInfoTag="Delay before animation starts";
	//Random SHort Delay to help with distribution of animations
	Sleep( GetDelayBeforeReaction() );

	//`log(" ChadAI - Pawn: " @ Pawn @ " InitialResponseToGrenadeOut::after Sleep( GetDelayBeforeReaction() ) Pawn.bIsCrouched: " @ Pawn.bIsCrouched @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

InitialResponseToGrenadeOutLoop:


	//`log(" ChadAI - TPSoldierAIController::InitialResponseToGrenadeOut::InitialResponseToGrenadeOutLoop PopState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	//Sleep(0.3);
	
	// do some oh wow state
	// Need to comment back in when able

	m_SubStateDebugInfoTag="Started Animation";

	m_DangerAwarenessData.m_TimeStartedInitialReactingToGrenadeOut = WorldInfo.TimeSeconds;

	TPPawn(Pawn).m_bReactingToGrenadeOut = true;

	//`log(" ChadAI - Pawn: " @ Pawn @ " InitialResponseToGrenadeOut::after TPPawn(Pawn).m_bReactingToGrenadeOut = true Pawn.bIsCrouched: " @ Pawn.bIsCrouched @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	
	//TPPawn(Pawn).m_bReactingToGrenadeOut = false;

	
	//PopState();
	
	//Goto('InitialResponseToGrenadeOutLoop');
}

//-----------------------------------------------------------------------
// State:	CoweringFromGrenade
// Description: 
//-----------------------------------------------------------------------
state CoweringFromGrenade
{
	function BeginState(Name PreviousStateName)
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		//`log(" ChadAI - TPSoldierAIController::CoweringFromGrenade::BeginState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
	}
	
	event PausedState()
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		//`log(" ChadAI - TPSoldierAIController::CoweringFromGrenade::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		if( Pawn != None )
		{
			TPPawn(Pawn).m_bCoweringFromGrenade = false;
		}
	}

	event ContinuedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;
		//`log(" ChadAI - TPSoldierAIController::CoweringFromGrenade::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		if( Pawn != None )
		{
			TPPawn(Pawn).m_bCoweringFromGrenade = true;
		}
	}

	event PoppedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		//`log(" ChadAI - TPSoldierAIController::CoweringFromGrenade::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		if( TPPawn(Pawn) != None )
		{
			TPPawn(Pawn).m_bCoweringFromGrenade = false;
		}
	}
	
	function EndState(Name NextStateName)
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		//`log(" ChadAI - TPSoldierAIController::CoweringFromGrenade::EndState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		if( TPPawn(Pawn) != None )
		{
			TPPawn(Pawn).m_bCoweringFromGrenade = false;
		}
	}
	
    function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		// do nothing for now
		//`log(" ChadAI - TPSoldierAIController::CoweringFromGrenade::NotifyWeaponFired  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
    }

	function Float GetCowerTime()
	{
		Local Float TimeLeft;
		
		if (m_DangerAwarenessData.m_CurrentGrenToReactToo != None)
		{
			// The theory here is that they should stop cowering once they notice that the grenade has gone off.
			TimeLeft = m_DangerAwarenessData.m_CurrentGrenToReactToo.GetTimerCount();

			TimeLeft += RandRange( 0.0f, class'TPTuneManager'.static.Get().GetTuneData().GrenadeUseData.m_MaxDelayTimeAfterCoweringFromGrenade );

			return TimeLeft;
		}
		else
			return m_DangerAwarenessData.m_TimeReactingToGrenadesByCowering;
	}
		
 	event Tick( float DeltaTime )
 	{
		// no need to update aiming while throwing a gren it will fail anyways and spawn the log and take processing time.
 		//UpdateAimInTheOpen(FALSE);;
		SetAimToStrightAhead();
		UpdateHeadtracking();
		//Super.Tick(DeltaTime);	
	}		

Begin:

	m_SubStateDebugInfoTag="Begin";

	//`log(" ChadAI - TPSoldierAIController::CoweringFromGrenade::Begin  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		
	StopFiring();
	StopThisBot();

// 	if (Pawn.bIsCrouched)
// 	{
// 		m_SubStateDebugInfoTag="Cower UnCrouching";
// 
// 
// 		m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange = WorldInfo.TimeSeconds;
// 
// 		if( Pawn != None && TPPawn(Pawn) != none )
// 		{
// 			Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToStanding_Panic;
// 		}
// 
// 		// OpenFieldPostureSwitchingState_GoingToCrouching
// 		while(	(Pawn.bIsCrouched && Pawn != None && TPPawn(Pawn) != none) ||
// 				(Pawn != None && TPPawn(Pawn) != none && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching ) )
// 		{
// 			Pawn.UnCrouch();
// 			Sleep(0.1);
// 
// 			if( !Pawn.bIsCrouched && ( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange) >= 
// 										`TuneData.EngagementTacData.m_MaxTimeToWaitForToStandPostureChangeToFinish ) )
// 			{
// 				`AILOG(3, 'CoweringFromGrenade', "Waited to Long while changing Posture to stand so force quiting");
// 				Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
// 				break;
// 			}
// 		}		
// 	}

	TPPawn(Pawn).m_bCoweringFromGrenade = true;
	
	Sleep( GetCowerTime() );
	
	TPPawn(Pawn).m_bCoweringFromGrenade = false;
	
	PopState();

CoweringFromGrenadeLoop:

	//`log(" ChadAI - TPSoldierAIController::CoweringFromGrenade::CoweringFromGrenadeLoop  PopState-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	
	PopState();
	
}

//-----------------------------------------------------------------------
// State:	RunawayFromGrenade
// Description: 
//-----------------------------------------------------------------------
state RunawayFromGrenade
{
	function BeginState(Name PreviousStateName)
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;
		//`log(" ChadAI - TPSoldierAIController::RunawayFromGrenade::BeginState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
	}
	
	event PausedState()
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
		{
			KillTheTraveller();
			PopState();
		}

		//`log(" ChadAI - TPSoldierAIController::RunawayFromGrenade::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	event ContinuedState()
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		//`log(" ChadAI - TPSoldierAIController::RunawayFromGrenade::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}

	event PoppedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		if( TPPawn(Pawn) != None )
		{
			Pawn.MaxDesiredSpeed	=	m_DangerAwarenessData.m_SpeedScaleBeforeRunaway;
			Pawn.DesiredSpeed	=	m_DangerAwarenessData.m_SpeedScaleBeforeRunaway;
			Pawn.SetMovementType( MovementType_Default );
			TPPawn(Pawn).m_bCoweringFromGrenade = false;

			if( TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
			{
				KillTheTraveller();
			}
		}

		m_DangerAwarenessData.m_bShouldStartCQB = false;

		//`log(" ChadAI - TPSoldierAIController::CoweringFromGrenade::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}
	
	function EndState(Name NextStateName)
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		if( TPPawn(Pawn) != None )
		{
			Pawn.MaxDesiredSpeed = m_DangerAwarenessData.m_SpeedScaleBeforeRunaway;
			Pawn.DesiredSpeed	= m_DangerAwarenessData.m_SpeedScaleBeforeRunaway;
			Pawn.SetMovementType( MovementType_Default );
			TPPawn(Pawn).m_bCoweringFromGrenade = false;

			if( TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
			{
				KillTheTraveller();
			}
		}

		m_DangerAwarenessData.m_bShouldStartCQB = false;

		//`log(" ChadAI - TPSoldierAIController::RunawayFromGrenade::EndState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}
	
    function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		// do nothing for now
		//`log(" ChadAI - TPSoldierAIController::RunawayFromGrenade::NotifyWeaponFired  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
    }

	function Float GetCowerTime()
	{
		Local Float TimeLeft;
		
		if (m_DangerAwarenessData.m_CurrentGrenToReactToo != None)
		{
			// The theory here is that they should stop cowering once they notice that the grenade has gone off.
			TimeLeft = m_DangerAwarenessData.m_CurrentGrenToReactToo.GetTimerCount();

			TimeLeft += RandRange( 0.0f, class'TPTuneManager'.static.Get().GetTuneData().GrenadeUseData.m_MaxDelayTimeAfterCoweringFromGrenade );

			return TimeLeft;
		}
		else
		{
			return m_DangerAwarenessData.m_TimeReactingToGrenadesByCowering;
		}
	}

	function float GetDeathForceForRun()
	{
		return class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_DeathForceFactor_RunAwayFromGren;
	}

	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " RunawayFromGrenade::NotifyTakeHit m_bTookHitWhilePursuing set to true Pawn.Health: " @ Pawn.Health @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		if( Pawn.Health < 1 && !TPPawn(Pawn).m_bCoweringFromGrenade)
		{
			if( !TPPawn(Pawn).m_bNeedsToPlowIn )
			{
				;
				
				Pawn.Health = 100;
				TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet = true;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetInstigatedBy = InstigatedBy;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetHitlocation = HitLocation;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetMomentum = Vector(Pawn.Rotation) * GetDeathForceForRun() ;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetDamageType = damageType;
				TPPawn(Pawn).m_bNeedsToPlowIn = true;

				KynapseClear();
			}
		}
		else
		{
			Super.NotifyTakeHit(InstigatedBy, HitLocation, Damage, damageType, Momentum);
		}
	}
	
	event Tick( float DeltaTime )
	{
		//UpdateAimInTheOpen(FALSE);;
		SetAimToStrightAhead();
		UpdateHeadtracking();

		if(  Pawn != None && TPPawn(Pawn).m_bCoweringFromGrenade )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " RunawayFromGrenade::Tick:: EnemyIsInRange  m_MeleeRangeOfAttack -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			Pawn.SetRotation(DesiredRotation);
			//Pawn.DesiredRotation = Pawn.Rotation;
		}

		if( DetermineIfShouldStartCQB_Tick( WorldInfo.TimeSeconds ) )
		{
			m_DangerAwarenessData.m_bShouldStartCQB = true;
			//`log(" ChadAI - TPSoldierAIController::RunawayFromGrenade::Tick:: EnemyIsInRange  m_MeleeRangeOfAttack -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			KynapseClear();
		}
		//Super.Tick(DeltaTime);	
	}		

Begin:

	m_SubStateDebugInfoTag="Begin";

	//`log(" ChadAI - TPSoldierAIController::RunawayFromGrenade::Begin  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	
	//m_recentThreats[m_IdOfCurrentThreat].ThreatMaker is an actor
	
	//m_recentThreats[m_IdOfCurrentThreat].ThreatLocation is its loc
	
	// HEY DOUG THIS IS THE SPOT FOR THE RUNAWAY CODE!!!!

	Focus = None;
	Target = None;

	m_DangerAwarenessData.m_bShouldStartCQB = false;

	// Should not need this anymore because done in respond to gren
	//ClearCurrentCover();
	//ReserveCover(m_CoverFightData.m_CurrentlyCoverToUseAsFightPos);

	StopFiring();

	m_DangerAwarenessData.m_SpeedScaleBeforeRunaway = Pawn.MaxDesiredSpeed;

	Pawn.MaxDesiredSpeed	= m_DangerAwarenessData.m_SpeedToRunAwayScale;
	Pawn.DesiredSpeed		= m_DangerAwarenessData.m_SpeedToRunAwayScale;

	Pawn.SetMovementType( MovementType_Sprint );
	
	Danger.Point = m_DangerAwarenessData.m_CurrentGrenToReactToo.Location;
	Danger.Radius = class'TPTuneManager'.static.Get().GetTuneData().GrenadeUseData.m_DesiredDistToRunawayFromGren;


	m_SubStateDebugInfoTag="starting flee - " @ class'TPTuneManager'.static.Get().GetTuneData().GrenadeUseData.m_DesiredDistToRunawayFromGren;
	KynapseFleeDangerousPoint(Danger);

	if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
	{
		KillTheTraveller();
		PopState();
	}

	m_SubStateDebugInfoTag="Back From flee";

	if( m_DangerAwarenessData.m_bShouldStartCQB )
	{
		;
		PushState('CloseQuartersBattleAttack');
		//Sleep(0.1);
		;
		PopState();
	}	

RunawayFromGrenadeLoop:

	//`log(" ChadAI - Pawn: " @ Pawn @ " RunawayFromGrenade::RunawayFromGrenadeLoop  Threat Maker: " @ m_DangerAwarenessData.m_CurrentGrenToReactToo @ " Exploded: " @ m_DangerAwarenessData.m_CurrentGrenToReactToo.HaveGoneBoom() @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


	if( m_DangerAwarenessData.m_CurrentGrenToReactToo != NONE && !m_DangerAwarenessData.m_CurrentGrenToReactToo.HaveGoneBoom() && Pawn != None )
	{
		m_SubStateDebugInfoTag = "Cowering";
		DesiredRotation = Pawn.Rotation;
		Pawn.DesiredRotation = Pawn.Rotation;

		TPPawn(Pawn).m_bCoweringFromGrenade = true;
		//`log(" ChadAI - TPSoldierAIController::RunawayFromGrenade::RunawayFromGrenadeLoop  PopState-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		Sleep( GetCowerTime() );
		//Goto('RunawayFromGrenadeLoop');
	}

	PopState();
	
}


//-----------------------------------------------------------------------
// State:	JumpOverCoverToGetAwayFromGrenade
// Description: 
//-----------------------------------------------------------------------
state JumpOverCoverToGetAwayFromGrenade
{
	function BeginState(Name PreviousStateName)
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		//`log(" ChadAI - TPSoldierAIController::JumpOverCoverToGetAwayFromGrenade::BeginState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
	}
	
	event PausedState()
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		//`log(" ChadAI - TPSoldierAIController::JumpOverCoverToGetAwayFromGrenade::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	event ContinuedState()
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		//`log(" ChadAI - TPSoldierAIController::JumpOverCoverToGetAwayFromGrenade::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}
	
	function EndState(Name NextStateName)
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		if( Pawn != None )
		{
			TPPawn(Pawn).m_bCoweringFromGrenade = false;
		}
		/* should not use, causes sliding
		ActivateKynapseBrain(true);
		*/

		//`log(" ChadAI - TPSoldierAIController::JumpOverCoverToGetAwayFromGrenade::EndState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}

	event PoppedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		/* should not use, causes sliding
		ActivateKynapseBrain(true);
		*/

		//`log(" ChadAI - TPSoldierAIController::CoweringFromGrenade::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		if( Pawn != None )
		{
			TPPawn(Pawn).m_bCoweringFromGrenade = false;
		}
	}
	
    function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		// do nothing for now
		//`log(" ChadAI - TPSoldierAIController::JumpOverCoverToGetAwayFromGrenade::NotifyWeaponFired  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
    }
    
	function PerformMantle()
	{
	
		PushState ('Vaulting');		
// 		switch(m_CoverInfo.m_MantleActionToPerform)
// 		{
// 			case MantleAction_Vaulting:
// 				PushState ('Vaulting');
// 				break;
// 			case MantleAction_VaultMedium:
// 				PushState ('VaultMedium');
// 				break;
// 			case MantleAction_VaultHigh:
// 				PushState ('VaultHigh');
// 				break;
// 			case MantleAction_VaultMantling:
// 				PushState ('VaultMantling');
// 				break;
// 			case MantleAction_MantlingLow:
// 				PushState ('MantlingLow');
// 				break;
// 			case MantleAction_MantlingMedium:
// 				PushState ('MantlingMedium');
// 				break;						
// 		}
    }    
	
	event Tick( float DeltaTime )
	{
		//UpdateAimInTheOpen(FALSE);;
		SetAimToStrightAhead();
		UpdateHeadtracking();
		//Super.Tick(DeltaTime);	
	}		

Begin:

	m_SubStateDebugInfoTag="Begin";

	//`log(" ChadAI - TPSoldierAIController::JumpOverCoverToGetAwayFromGrenade::Begin  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	
	StopFiring();
	
	m_MantleGoalInfo.m_PlaceToMantle = m_CoverMoveData.m_PreviousCover_Not_Clamied;	

	/* should not use, causes sliding
	ActivateKynapseBrain(false);
	*/

	DesiredRotation = m_MantleGoalInfo.m_PlaceToMantle.Link.GetSlotRotation( m_MantleGoalInfo.m_PlaceToMantle.SlotIdx );
	DesiredRotation.Pitch = 0;

	if( Pawn == None )
	{
		PopState();
	}

	Pawn.SetRotation( DesiredRotation );
	
	PerformMantle();
	
	//ChangeKynapseEntityToActiveEntity();	
	/* should not use, causes sliding
	ActivateKynapseBrain(true);
	*/
	
	Sleep(0.0); // some time to finish what ever animaion may be happening

	StopThisBot();
	
	//`log(" ChadAI - TPSoldierAIController::MantleCoverGoal::Begin Done Vaulting -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
			
	//`log(" ChadAI - BeASniperGoal::Begin call ENDED  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

JumpOverCoverToGetAwayFromGrenadeLoop:
	
	PopState();
	
}


//-----------------------------------------------------------------------
// State:	ThrowGrenadeBack
// Description: 
//-----------------------------------------------------------------------
state ThrowGrenadeBack
{
	ignores NotifyBump;

	function BeginState(Name PreviousStateName)
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		//`log(" ChadAI - TPSoldierAIController::ThrowGrenadeBack::BeginState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
	}
	
	event PausedState()
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
		{
			KillTheTraveller();
			PopState();
		}


		//`log(" ChadAI - TPSoldierAIController::ThrowGrenadeBack::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	event ContinuedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		//`log(" ChadAI - TPSoldierAIController::ThrowGrenadeBack::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}


	event PoppedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		if( TPPawn(Pawn) != None )
		{
			if( TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
			{
				KillTheTraveller();
				PopState();
			}

			Pawn.MaxDesiredSpeed=m_CQB_Data.m_SpeedBeforeChargeScale;
			Pawn.DesiredSpeed=m_CQB_Data.m_SpeedBeforeChargeScale;
			TPPawn(Pawn).m_bHotTossingThePotato = false;
		}

		m_DangerAwarenessData.m_bRunningToGren = false;

		//`log(" ChadAI - TPSoldierAIController::ThrowGrenadeBack::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}


	
	function EndState(Name NextStateName)
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;


		if( TPPawn(Pawn) != None )
		{
			if( TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
			{
				KillTheTraveller();
				PopState();
			}

			Pawn.MaxDesiredSpeed=m_CQB_Data.m_SpeedBeforeChargeScale;
			Pawn.DesiredSpeed=m_CQB_Data.m_SpeedBeforeChargeScale;
			TPPawn(Pawn).m_bHotTossingThePotato = false;
		}

		m_DangerAwarenessData.m_bRunningToGren = false;


		//`log(" ChadAI - TPSoldierAIController::ThrowGrenadeBack::EndState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}

	function float GetDeathForceForRun()
	{
		return class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_DeathForceFactor_RunToGren;
	}

	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " ThrowGrenadeBack::NotifyTakeHit m_bTookHitWhilePursuing set to true Pawn.Health: " @ Pawn.Health @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		if( Pawn.Health < 1 && !TPPawn(Pawn).m_bCoweringFromGrenade && !TPPawn(Pawn).m_bHotTossingThePotato )
		{
			if( !TPPawn(Pawn).m_bNeedsToPlowIn )
			{
				;			
				Pawn.Health = 100;
				TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet = true;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetInstigatedBy = InstigatedBy;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetHitlocation = HitLocation;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetMomentum = Vector(Pawn.Rotation) * GetDeathForceForRun() ;
				TPPawn(Pawn).m_DeadAndDoesNotKnowItYetDamageType = damageType;
				TPPawn(Pawn).m_bNeedsToPlowIn = true;
				KynapseClear();
			}
		}
	}

    function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		// do nothing for now
		//`log(" ChadAI - ThrowGrenadeBack::NotifyWeaponFired  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
    }

	function PickUpOfGrenadeThrowBack()
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " ThrowGrenadeBack:PickUpOfGrenadeThrowBack Called -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	
		// Create a dummy grenade, while hiding the real one.
		m_DangerAwarenessData.m_CurrentGrenToReactToo.SkeletalMeshComponent.SetHidden(TRUE);
		SpawnGrenade();

	}

	function EndThrowBackGrenade()
	{
		//`log(" ChadAI - TPSoldierAIController::ThrowGrenadeBack::EndThrowGrenadeAtActor  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		;	
		//TPPawn(Pawn).FinishSceneAnimation(0.1);

// 		if (TPPawn(Pawn).Weapon != None)
// 		{
// 			TPPawn(Pawn).Weapon.SetWeaponHidden(false);
// 			//EnableAI();
// 		}

		if( TPPawn(Pawn) != None )
		{
			TPPawn(Pawn).m_bHotTossingThePotato = false;
		}

		PopState();

	}

	function bool ShouldIBeAnActionHeroAndThrowGrenBackAtEnemy()
	{
		local rotator rotToEnemy, deltaRot;
		local int yawToEnemy;
		local float maxYaw;

		local vector maxRightThrowLineLocation;
		local vector maxLeftThrowLineLocation;

		if( Enemy != None && Pawn != None )
		{


			if( class'TPTuneManager'.static.Get().GetTuneData().DebugDrawData.m_bDisplayGrenadeThrowArcs && Pawn != None )
			{
				maxYaw = class'TPTuneManager'.static.Get().GetTuneData().m_AimingAngleDataConverted.m_MaxAngleToEnemyToTossBackTooInUU;
				//maxPitch = GetMaxVerticalFiringAngleForCurrentWeaponInTheOpen();

				//`log(" ChadAI - Pawn: " @ Pawn @ " ShouldIBeAnActionHeroAndThrowGrenBackAtEnemy  m_MaxAngleToEnemyToTossBackTooInUU: " @ `TuneData.m_AimingAngleDataConverted.m_MaxAngleToEnemyToTossBackTooInUU @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		


				Pawn.FlushPersistentDebugLines();

				deltaRot = Pawn.Rotation;

				// yaw to the right
				deltaRot.Yaw = deltaRot.Yaw + maxYaw;

				maxRightThrowLineLocation = Vector(deltaRot);

				maxRightThrowLineLocation = Pawn.Location + (maxRightThrowLineLocation * 500);

				Pawn.DrawDebugLine( Pawn.Location, maxRightThrowLineLocation, class'TPTuneManager'.static.Get().GetTuneData().DebugDrawData.m_AimMaxRightDisplayLineColor.R,
																			class'TPTuneManager'.static.Get().GetTuneData().DebugDrawData.m_AimMaxRightDisplayLineColor.G,
																			class'TPTuneManager'.static.Get().GetTuneData().DebugDrawData.m_AimMaxRightDisplayLineColor.B, true);

				// yaw to the Left
				deltaRot = Pawn.Rotation;
				deltaRot.Yaw = deltaRot.Yaw - maxYaw;

				maxLeftThrowLineLocation = Vector(deltaRot);

				maxLeftThrowLineLocation = Pawn.Location + (maxLeftThrowLineLocation * 500);

				Pawn.DrawDebugLine( Pawn.Location, maxLeftThrowLineLocation, class'TPTuneManager'.static.Get().GetTuneData().DebugDrawData.m_AimMaxLeftDisplayLineColor.R,
																			class'TPTuneManager'.static.Get().GetTuneData().DebugDrawData.m_AimMaxLeftDisplayLineColor.G,
																			class'TPTuneManager'.static.Get().GetTuneData().DebugDrawData.m_AimMaxLeftDisplayLineColor.B, true);
			}


			// get the vector to the enemy and covert to rot
			rotToEnemy = rotator(Enemy.Location - Pawn.Location);

			yawToEnemy = rotToEnemy.Yaw - Pawn.Rotation.Yaw;

			//`log(" ChadAI - Pawn: " @ Pawn @ " ShouldIBeAnActionHeroAndThrowGrenBackAtEnemy  yawToEnemy: " @ Abs(yawToEnemy) @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		

			if( Abs(yawToEnemy) > 32768 )
			{
				yawToEnemy = 65536 - Abs(yawToEnemy);
				//`log(" ChadAI - Pawn: " @ Pawn @ " ShouldIBeAnActionHeroAndThrowGrenBackAtEnemy  yawToEnemy: " @ yawToEnemy @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
			}

			//`log(" ChadAI - Pawn: " @ Pawn @ " ShouldIBeAnActionHeroAndThrowGrenBackAtEnemy  Max Rot To Enemy for Shot Yaw: " @ `TuneData.m_AimingAngleDataConverted.m_MaxAngleToEnemyToTossBackTooInUU @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		

			// if the Yaw to the enemy less then the max yaw to shot
			if( Abs(yawToEnemy) <= class'TPTuneManager'.static.Get().GetTuneData().m_AimingAngleDataConverted.m_MaxAngleToEnemyToTossBackTooInUU )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " ShouldIBeAnActionHeroAndShootWhileRunning  Should Shoot -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
				;		
				return true;
			}
		}
		return false;

	}


	function ReleaseOfGrenadeThrowBack()
	{
		local vector  SocketLoc;
		local rotator SocketRot;
		//local vector tossVelocity;
		//local Pawn targetsPawn;
		//local vector targetVec;
		local TPPawn tpPawnRef;


				// Get rid of our dummy grenade
		if (HeldGrenade != None)
		{
			;
			if( !HeldGrenade.DroppedPickupMesh.HiddenGame )
			{
				HeldGrenade.DroppedPickupMesh.SetHidden(TRUE);
			}
		}
		else
		{
			;
		}

		if( m_DangerAwarenessData.m_CurrentGrenToReactToo.HaveGoneBoom() )
		{
			;
			return;
		}

		m_DangerAwarenessData.m_CurrentGrenToReactToo.SkeletalMeshComponent.SetHidden(FALSE);


		//tossVelocity = m_GrenadeUseData.m_CalculatedThrowVelocity * vect(0.50f,0.50f,1.f);

		tpPawnRef = TPPawn(Pawn);

		if( tpPawnRef == None )
		{
			;
			return;
		}

		if( !tpPawnRef.Mesh.GetSocketWorldLocationAndRotation('GrenadeHand', SocketLoc, SocketRot) )
		{
			tpPawnRef.Mesh.GetSocketWorldLocationAndRotation('Grenade', SocketLoc, SocketRot);
		}

		//`log(" ChadAI - ThrowGrenadeBack  SocketLoc: " @ SocketLoc @ " SocketRot: " @ SocketRot @ " Pawn Loc: " @ Pawn.Location @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

// 		MyGrenade.Activate(m_GrenadeUseData.m_NextFuesTime, class'Grenade_Persistent'.static.GetDefaultImpulseForce(),
// 						class'Grenade_Persistent'.static.GetDefaultAffectedRadius(), class'Grenade_Persistent'.static.GetDefaultDamageCaused_AI());

		m_DangerAwarenessData.m_CurrentGrenToReactToo.SkeletalMeshComponent.SetRBPosition(SocketLoc);

		m_DangerAwarenessData.m_CurrentGrenToReactToo.SkeletalMeshComponent.SetRBRotation(tpPawnRef.Mesh.Rotation);
		//MyGrenade.SkeletalMeshComponent.AddForce(tossVelocity >> Pawn.Rotation);
		m_DangerAwarenessData.m_CurrentGrenToReactToo.SkeletalMeshComponent.SetRBAngularVelocity(vect(0,10,0) >> Pawn.Rotation, true);

		// if my enemy is in front of me give him the gren back
		if( ShouldIBeAnActionHeroAndThrowGrenBackAtEnemy() )
		{
			;
			SetHotTossGrenadeThrowVelocity();
		}
		else
		{
			;

			// pawns rot to vector add Z and then multiple by mag
			m_DangerAwarenessData.m_HotGrenTossBackThrowVelocity = Vector(Pawn.Rotation);
			m_DangerAwarenessData.m_HotGrenTossBackThrowVelocity *= m_DangerAwarenessData.m_HotGrenTossBackThrowForceFactor;
			m_DangerAwarenessData.m_HotGrenTossBackThrowVelocity.Z += m_DangerAwarenessData.m_HotGrenTossBackThrowZForce;
			//tossVelocity = Vector(Pawn.Rotation) + m_DangerAwarenessData.m_HotGrenTossBackThrowForce;
		}

		m_DangerAwarenessData.m_CurrentGrenToReactToo.SkeletalMeshComponent.SetRBLinearVelocity(m_DangerAwarenessData.m_HotGrenTossBackThrowVelocity, true );
	}
	
	
	function AddTimeToGrenade(float AdditionalTime)
	{
		Local Float OldTime, NewTime;
		
		OldTime = m_DangerAwarenessData.m_CurrentGrenToReactToo.GetTimerCount();
		if (OldTime > 0)
		{
			NewTime = OldTime + AdditionalTime;
			m_DangerAwarenessData.m_CurrentGrenToReactToo.SetTimer(NewTime);
		}
	}
	
	event Tick( float DeltaTime )
	{
		//Local Float TimeLeft;
		//local vector deltaOfGren;
		
		// No Need to Aim a weapon that is not in hand
		//UpdateAimInTheOpen(FALSE);;
		//SetAimToStrightAhead();
		SetAimToStrightAhead();
		UpdateHeadtracking();
		//Super.Tick(DeltaTime);

		if( Pawn != None && TPPawn(Pawn) != None )
		{
			if( TPPawn(Pawn).m_bHotTossingThePotato && m_DangerAwarenessData.m_TimeStartedThrowBack > 0.0 )
			{
				if( (WorldInfo.TimeSeconds - m_DangerAwarenessData.m_TimeStartedThrowBack ) >= class'TPTuneManager'.static.Get().GetTuneData().GrenadeUseData.m_HowLongToWaitToCancelThrowBack )
				{
					;
					StopThisBot();
					TPPawn(Pawn).m_bHotTossingThePotato = false;
					PopState();
				}
			}
		
		
			if( m_DangerAwarenessData.m_CurrentGrenToReactToo == None || m_DangerAwarenessData.m_CurrentGrenToReactToo.HaveGoneBoom() )
			{
				;
				KynapseClear();
				StopThisBot();
				TPPawn(Pawn).m_bHotTossingThePotato = false;
			}
			else if( m_DangerAwarenessData.m_bRunningToGren )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " ThrowGrenadeBack m_bRunningToGren gren Current Loc: " @ m_DangerAwarenessData.m_CurrentGrenToReactToo.Location @ " @ -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
				//`log(" ChadAI - Pawn: " @ Pawn @ " ThrowGrenadeBack m_bRunningToGren gren Last Loc: " @ m_DangerAwarenessData.m_HotGrenLastKnowLoc @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
				//`log(" ChadAI - Pawn: " @ Pawn @ " ThrowGrenadeBack m_bRunningToGren gren Dist Move: " @ VSize(m_DangerAwarenessData.m_CurrentGrenToReactToo.Location - m_DangerAwarenessData.m_HotGrenLastKnowLoc) @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
				//`log(" ChadAI - Pawn: " @ Pawn @ " ThrowGrenadeBack m_bRunningToGren gren Allow Dist To Move: " @ `TuneData.GrenadeUseData.m_MaxDeltaForThrowBackGrenBeforeAdjustMove @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

				if( VSizeSq(m_DangerAwarenessData.m_CurrentGrenToReactToo.Location - m_DangerAwarenessData.m_HotGrenLastKnowLoc) >= 
					( class'TPTuneManager'.static.Get().GetTuneData().GrenadeUseData.m_MaxDeltaForThrowBackGrenBeforeAdjustMove * class'TPTuneManager'.static.Get().GetTuneData().GrenadeUseData.m_MaxDeltaForThrowBackGrenBeforeAdjustMove ) )
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ " ThrowGrenadeBack Running to Gren and it moved to far so need to quit movement and adjust !!!!!!!!! -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
					//`log(" ChadAI - Pawn: " @ Pawn @ " ThrowGrenadeBack Running to Gren and it moved to far so need to quit movement and adjust !!!!!!!!! -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
					//`log(" ChadAI - Pawn: " @ Pawn @ " ThrowGrenadeBack Running to Gren and it moved to far so need to quit movement and adjust !!!!!!!!! -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
					//`log(" ChadAI - Pawn: " @ Pawn @ " ThrowGrenadeBack Running to Gren and it moved to far so need to quit movement and adjust !!!!!!!!! -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
					//`log(" ChadAI - Pawn: " @ Pawn @ " ThrowGrenadeBack Running to Gren and it moved to far so need to quit movement and adjust !!!!!!!!! -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

					;
					StopThisBot();
					m_DangerAwarenessData.m_bRunningToGren = false;

				} // end if to far away
			} // end else if( m_DangerAwarenessData.m_bRunningToGren )
		} // end if( Pawn != None && TPPawn(Pawn) != None )
// 		if (m_DangerAwarenessData.m_HotGrenForTossBack != None)
// 		{
// 			//TimeLeft = m_DangerAwarenessData.m_HotGrenForTossBack.GetTimerCount();
// 			
// //			if (TimeLeft < 0.1f)
// //			{
// 				//`Log("Time Left:"@TimeLeft);
// //				PopState();
// //			}
// 		}
	}		



Begin:

	m_SubStateDebugInfoTag="Begin";

	//`log(" ChadAI - TPSoldierAIController::ThrowGrenadeBack::Begin  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	
	//m_recentThreats[m_IdOfCurrentThreat].ThreatMaker is an actor
	
	//m_recentThreats[m_IdOfCurrentThreat].ThreatLocation is its loc

	m_DangerAwarenessData.m_TimeStartedThrowBack = -1.0;
	m_DangerAwarenessData.m_bRunningToGren = false;

	if( m_DangerAwarenessData.m_CurrentGrenToReactToo == None || m_DangerAwarenessData.m_CurrentGrenToReactToo.HaveGoneBoom() )
	{
		;
		PopState();
	}

	StopFiring();

	if (Pawn.bIsCrouched)
	{
		m_SubStateDebugInfoTag="Throw Gren Back UnCrouching";

		m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange = WorldInfo.TimeSeconds;

		if( Pawn != None && TPPawn(Pawn) != none )
		{
			Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToStanding_Panic;
		}

		;


		// OpenFieldPostureSwitchingState_GoingToCrouching
		while(	(Pawn.bIsCrouched && Pawn != None && TPPawn(Pawn) != none) ||
				(Pawn != None && TPPawn(Pawn) != none && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching ) )
		{
			Pawn.UnCrouch();
			Sleep(0.0);

			if( !Pawn.bIsCrouched && ( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange) >= 
										class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToPanicStandPostureChangeToFinish ) )
			{
				;
				Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
				break;
			}
		}		
	}

	m_CQB_Data.m_SpeedBeforeChargeScale = Pawn.MaxDesiredSpeed;

	if( Pawn != None )
	{
		Pawn.MaxDesiredSpeed	= m_CQB_Data.m_SpeedToChargeScale;
		Pawn.DesiredSpeed		= m_CQB_Data.m_SpeedToChargeScale;
	}

	m_SubStateDebugInfoTag="Moving To Grenade";

ThrowGrenadeBackLoop:

	m_DangerAwarenessData.m_bRunningToGren = false;

	if( m_DangerAwarenessData.m_CurrentGrenToReactToo == None || m_DangerAwarenessData.m_CurrentGrenToReactToo.HaveGoneBoom() )
	{
		;
		PopState();
	}

	if ( KynapseCanGoStraight(m_DangerAwarenessData.m_CurrentGrenToReactToo.Location) )
	{
		;

		m_DangerAwarenessData.m_bSimpleMovement = TRUE;
		KynapseClear();
	}
	else if( !m_DangerAwarenessData.m_PathBuiltToGrenade )
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " ThrowGrenadeBackLoop m_PathBuiltToGrenade == false *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		;

		KynapseGoToFindPath(m_DangerAwarenessData.m_CurrentGrenToReactToo.Location);

		if ( !KynapseFoundPath() )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " ThrowGrenadeBackLoop Not able to build path to gren so CoweringFromGrenade *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

			PushState('CoweringFromGrenade');

			PopState();
		}
	}
	else
	{
		;
	}

	m_DangerAwarenessData.m_HotGrenLastKnowLoc = m_DangerAwarenessData.m_CurrentGrenToReactToo.Location;
	
	if (m_DangerAwarenessData.m_bSimpleMovement)
	{
		m_SubStateDebugInfoTag="Steping to Gren";

		if( m_DangerAwarenessData.m_CurrentGrenToReactToo == None || m_DangerAwarenessData.m_CurrentGrenToReactToo.HaveGoneBoom() )
		{
			;
			PopState();
		}

		m_DangerAwarenessData.m_bRunningToGren = true;

		DesiredRotation = rotator(m_DangerAwarenessData.m_CurrentGrenToReactToo.Location - Pawn.Location);

		//MoveTo(m_recentThreats[m_IdOfCurrentThreat].ThreatMaker.Location, m_recentThreats[m_IdOfCurrentThreat].ThreatMaker);

		MoveTo(m_DangerAwarenessData.m_CurrentGrenToReactToo.Location, m_DangerAwarenessData.m_CurrentGrenToReactToo);

		if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
		{
			KillTheTraveller();
			PopState();
		}

		if( m_DangerAwarenessData.m_CurrentGrenToReactToo == None || m_DangerAwarenessData.m_CurrentGrenToReactToo.HaveGoneBoom() )
		{
			;
			PopState();
		}
	}
	else
	{
		m_SubStateDebugInfoTag="Running to Gren";

		;
		m_DangerAwarenessData.m_bRunningToGren = true;
		KynapseFollowPath(); // follow the found path

		if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
		{
			KillTheTraveller();
			PopState();
		}

		if( m_DangerAwarenessData.m_CurrentGrenToReactToo == None || m_DangerAwarenessData.m_CurrentGrenToReactToo.HaveGoneBoom() )
		{
			;
			PopState();
		}

	}

	m_DangerAwarenessData.m_PathBuiltToGrenade = false;

	//if( KynapseHasArrived() )
	if( VSizeSq( m_DangerAwarenessData.m_CurrentGrenToReactToo.Location - Pawn.Location) < ( class'TPTuneManager'.static.Get().GetTuneData().GrenadeUseData.m_HowCloseToThrowBackGrenToPickUpAndThrowBack * class'TPTuneManager'.static.Get().GetTuneData().GrenadeUseData.m_HowCloseToThrowBackGrenToPickUpAndThrowBack)  )
	{
		m_DangerAwarenessData.m_bRunningToGren = false;

		if (m_DangerAwarenessData.m_bSimpleMovement)
		{
			StopThisBot();
		}
		
		//`log(" ChadAI - Pawn: " @ Pawn @ " ThrowGrenadeBackLoop Back From Following the path and close enough to throw the gren *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		;

		//m_DangerAwarenessData.m_CurrentGrenToReactToo = PhysicsGrenade(m_recentThreats[m_IdOfCurrentThreat].ThreatMaker);
		
		AddTimeToGrenade(class'TPTuneManager'.static.Get().GetTuneData().GrenadeUseData.m_TimeToAddToThrowBackGren);

		// start the animation
		TPPawn(Pawn).m_bHotTossingThePotato = true;

		m_DangerAwarenessData.m_TimeStartedThrowBack = WorldInfo.TimeSeconds;

		Goto('HotTossingWaitLoop');
	}
	else
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " ThrowGrenadeBackLoop Back From Following the path and NOT close enough: " @ VSize(m_DangerAwarenessData.m_CurrentGrenToReactToo.Location - Pawn.Location) @ " to throw the gren so trying again to get to it. Need to be: " @ `TuneData.GrenadeUseData.m_HowCloseToThrowBackGrenToPickUpAndThrowBack @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		;

		Goto('ThrowGrenadeBackLoop');
		//PushState('CoweringFromGrenade');
	}

	PopState();

HotTossingWaitLoop:

	m_SubStateDebugInfoTag="HotTossingWaitLoop";

	Sleep(0.0);

	if( m_DangerAwarenessData.m_CurrentGrenToReactToo == None || m_DangerAwarenessData.m_CurrentGrenToReactToo.HaveGoneBoom() )
	{
		;
		TPPawn(Pawn).m_bHotTossingThePotato = false;
		PopState();
	}

	Goto('HotTossingWaitLoop');
	
}

function OnAiThrowGrenadeAtActor(SeqAct_AiThrowGrenadeAtActor inAction)
{
	local array<Object> objVars;

	m_GrenadeUseData.m_NumberOfTimesTriedToTaskThrow = 0;
	
	//`log(" ChadAI - Pawn: " @ Pawn @ " OnAiThrowGrenadeAtActor:: called  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	// if routing we need to not clear latent actions on these moves
	inAction.GetObjectVars(objVars,"Actor to Throw At");

	m_GrenadeUseData.m_GrenadeTarget = Actor(objVars[0]);

	m_GrenadeUseData.m_NextFuesTime = inAction.m_FuesTime;
	m_GrenadeUseData.m_bCalcUpperArcForTask = inAction.m_bCalcUpperArcForTask;


	m_GrenadeUseData.m_bUseAgainstCurrentEnemyForTask = inAction.m_bUseAgainstCurrentEnemy;

	m_GrenadeUseData.m_TimeToSmokeForTask = inAction.m_TimeToSmoke;
	m_GrenadeUseData.m_bUseSmokeGrenadeForTask = inAction.m_bUseSmokeGrenade;
	m_GrenadeUseData.m_bCheckMinDistToTargetForTask = inAction.m_bCheckMinDistToTarget;
	m_GrenadeUseData.m_bCheckMaxDistToTargetForTask = inAction.m_bCheckMaxDistToTarget;
	m_GrenadeUseData.m_bCheckMinDistToFriendlyForTask = inAction.m_bCheckMinDistToFriendly;
	m_GrenadeUseData.m_bUseDynamicTacticalThrowingForTask = inAction.m_bUseDynamicTacticalThrowing;
	m_GrenadeUseData.m_MinDistToTargetForTask = inAction.m_MinDistToTarget;
	m_GrenadeUseData.m_MaxDistToTargetForTask = inAction.m_MaxDistToTarget;
	m_GrenadeUseData.m_MinDistToFriendlyForTask = inAction.m_MinDistToFriendly;


	//`log(" ChadAI - Pawn: " @ Pawn @ " OnAiThrowGrenadeAtActor:: called  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );


	//`log(" ChadAI - Pawn: " @ Pawn @ " OnAiThrowGrenadeAtActor:: m_NextFuesTime: " @ m_GrenadeUseData.m_NextFuesTime @ "  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	if( m_GrenadeUseData.m_bUseAgainstCurrentEnemyForTask )
	{
		if( Enemy != None )
		{
			m_GrenadeUseData.m_GrenadeTarget = Enemy;
		}
	}

	m_GrenadeUseData.m_bTaskAssignedToUseGrenade = true;

	if( DetermineIfGrenadeShouldBeTaskThrown() )
	{
		//`log(" ChadAI - OnAiThrowGrenadeAtActor:: DetermineIfGrenadeShouldBeTaskThrown said yes  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		;

		if( IsInState('UseGrenadeAgainstEnemy') )
		{
			//`log(" ChadAI - TPSoldierAIController::UseGrenadeAgainstEnemy::EndThrowGrenadeAtActor  poping UseGrenadeAgainstEnemy -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
			;
			PopState();
		}

		if( (m_CoverMoveData.m_Move2CoverStatus != Move2CovStat_None) ||
			(m_CoverMoveData.m_Move2CoverStatus != Move2CovStat_DoneMovingAtCover) )
		{
			m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_PausedGrenadeOut;
		}

		PushState('UseGrenadeAgainstEnemy');
	}
	else
	{
		//`log(" ChadAI - OnAiThrowGrenadeAtActor:: DetermineIfGrenadeShouldBeTaskThrown said No  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		m_GrenadeUseData.m_bTaskAssignedToUseGrenade = false;

		if( inAction.m_NumberOfTimesToTryIfFailureToThrow > 0 )
		{
			//`log(" ChadAI - OnAiThrowGrenadeAtActor:: DetermineIfGrenadeShouldBeTaskThrown said No and inAction.m_NumberOfTimesToTryIfFailureToThrow > 0 so setting timer to retry *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

			m_GrenadeUseData.m_SeqActForTaskThrowRetry = inAction;
			;
			SetTimer( class'TPTuneManager'.static.Get().GetTuneData().GrenadeUseData.m_TimeToWaitBetweenTaskThrowTries,,'RetryGrenadeTaskThrow');
		}
		else
		{
			//`log(" ChadAI - OnAiThrowGrenadeAtActor:: DetermineIfGrenadeShouldBeTaskThrown said No and inAction.m_NumberOfTimesToTryIfFailureToThrow == 0 so NOT seting timer to retry *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

			;
		}

		//`log(" ChadAI - OnAiThrowGrenadeAtActor:: DetermineIfGrenadeShouldBeTaskThrown said no  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	}
	
	//`log(" ChadAI - OnAiThrowGrenadeAtActor:: call ENDED  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
}

function RetryGrenadeTaskThrow()
{
	local array<Object> objVars;
	
	//`log(" ChadAI - Pawn: " @ Pawn @ " RetryGrenadeTaskThrow:: called  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
	m_GrenadeUseData.m_NumberOfTimesTriedToTaskThrow++;

	// if routing we need to not clear latent actions on these moves
	m_GrenadeUseData.m_SeqActForTaskThrowRetry.GetObjectVars(objVars,"Actor to Throw At");

	m_GrenadeUseData.m_GrenadeTarget = Actor(objVars[0]);

	m_GrenadeUseData.m_NextFuesTime = m_GrenadeUseData.m_SeqActForTaskThrowRetry.m_FuesTime;
	m_GrenadeUseData.m_bCalcUpperArcForTask = m_GrenadeUseData.m_SeqActForTaskThrowRetry.m_bCalcUpperArcForTask;


	m_GrenadeUseData.m_bUseAgainstCurrentEnemyForTask = m_GrenadeUseData.m_SeqActForTaskThrowRetry.m_bUseAgainstCurrentEnemy;

	m_GrenadeUseData.m_TimeToSmokeForTask = m_GrenadeUseData.m_SeqActForTaskThrowRetry.m_TimeToSmoke;
	m_GrenadeUseData.m_bUseSmokeGrenadeForTask = m_GrenadeUseData.m_SeqActForTaskThrowRetry.m_bUseSmokeGrenade;
	m_GrenadeUseData.m_bCheckMinDistToTargetForTask = m_GrenadeUseData.m_SeqActForTaskThrowRetry.m_bCheckMinDistToTarget;
	m_GrenadeUseData.m_bCheckMaxDistToTargetForTask = m_GrenadeUseData.m_SeqActForTaskThrowRetry.m_bCheckMaxDistToTarget;
	m_GrenadeUseData.m_bCheckMinDistToFriendlyForTask = m_GrenadeUseData.m_SeqActForTaskThrowRetry.m_bCheckMinDistToFriendly;
	m_GrenadeUseData.m_bUseDynamicTacticalThrowingForTask = m_GrenadeUseData.m_SeqActForTaskThrowRetry.m_bUseDynamicTacticalThrowing;
	m_GrenadeUseData.m_MinDistToTargetForTask = m_GrenadeUseData.m_SeqActForTaskThrowRetry.m_MinDistToTarget;
	m_GrenadeUseData.m_MaxDistToTargetForTask = m_GrenadeUseData.m_SeqActForTaskThrowRetry.m_MaxDistToTarget;
	m_GrenadeUseData.m_MinDistToFriendlyForTask = m_GrenadeUseData.m_SeqActForTaskThrowRetry.m_MinDistToFriendly;


	//`log(" ChadAI - Pawn: " @ Pawn @ " RetryGrenadeTaskThrow:: called  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );


	//`log(" ChadAI - Pawn: " @ Pawn @ " RetryGrenadeTaskThrow:: m_NextFuesTime: " @ m_GrenadeUseData.m_NextFuesTime @ "  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	if( m_GrenadeUseData.m_bUseAgainstCurrentEnemyForTask )
	{
		if( Enemy != None )
		{
			m_GrenadeUseData.m_GrenadeTarget = Enemy;
		}
	}

	m_GrenadeUseData.m_bTaskAssignedToUseGrenade = true;

	if( DetermineIfGrenadeShouldBeTaskThrown() )
	{
		//`log(" ChadAI - RetryGrenadeTaskThrow:: DetermineIfGrenadeShouldBeTaskThrown said yes  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		;

		if( IsInState('UseGrenadeAgainstEnemy') )
		{
			//`log(" ChadAI - RetryGrenadeTaskThrow::EndThrowGrenadeAtActor  poping UseGrenadeAgainstEnemy -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
			;
			PopState();
		}

		if( (m_CoverMoveData.m_Move2CoverStatus != Move2CovStat_None) ||
			(m_CoverMoveData.m_Move2CoverStatus != Move2CovStat_DoneMovingAtCover) )
		{
			m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_PausedGrenadeOut;
		}

		PushState('UseGrenadeAgainstEnemy');
	}
	else
	{
		m_GrenadeUseData.m_bTaskAssignedToUseGrenade = false;

		if( m_GrenadeUseData.m_SeqActForTaskThrowRetry.m_NumberOfTimesToTryIfFailureToThrow >m_GrenadeUseData.m_NumberOfTimesTriedToTaskThrow )
		{
			//m_GrenadeUseData.m_SeqActForTaskThrowRetry = inAction;
			;
			SetTimer( class'TPTuneManager'.static.Get().GetTuneData().GrenadeUseData.m_TimeToWaitBetweenTaskThrowTries,,'RetryGrenadeTaskThrow');
		}
		else
		{
			;
			m_GrenadeUseData.m_SeqActForTaskThrowRetry = None;
		}


	}
}

function OnAIBonziCharge(SeqAct_AIBonziCharge inAction)
{
	//local array<Object> objVars;
	
	;

	//// if routing we need to not clear latent actions on these moves
	//inAction.GetObjectVars(objVars,"Actor to Throw At");

	//m_GrenadeUseData.m_GrenadeTarget = Actor(objVars[0]);

	//m_GrenadeUseData.m_NextFuesTime = inAction.m_FuesTime;


	//m_GrenadeUseData.m_bUseAgainstCurrentEnemyForTask = inAction.m_bUseAgainstCurrentEnemy;

	//m_GrenadeUseData.m_TimeToSmokeForTask = inAction.m_TimeToSmoke;
	//m_GrenadeUseData.m_bUseSmokeGrenadeForTask = inAction.m_bUseSmokeGrenade;
	//m_GrenadeUseData.m_bCheckMinDistToTargetForTask = inAction.m_bCheckMinDistToTarget;
	//m_GrenadeUseData.m_bCheckMaxDistToTargetForTask = inAction.m_bCheckMaxDistToTarget;
	//m_GrenadeUseData.m_bCheckMinDistToFriendlyForTask = inAction.m_bCheckMinDistToFriendly;
	//m_GrenadeUseData.m_bUseDynamicTacticalThrowingForTask = inAction.m_bUseDynamicTacticalThrowing;
	//m_GrenadeUseData.m_MinDistToTargetForTask = inAction.m_MinDistToTarget;
	//m_GrenadeUseData.m_MaxDistToTargetForTask = inAction.m_MaxDistToTarget;
	//m_GrenadeUseData.m_MinDistToFriendlyForTask = inAction.m_MinDistToFriendly;


	////`log(" ChadAI - Pawn: " @ Pawn @ " OnAiThrowGrenadeAtActor:: called  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );


	////`log(" ChadAI - Pawn: " @ Pawn @ " OnAiThrowGrenadeAtActor:: m_NextFuesTime: " @ m_GrenadeUseData.m_NextFuesTime @ "  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	//if( DetermineIfGrenadeShouldBeTaskThrown() )
	//{
	//	//`log(" ChadAI - OnAiThrowGrenadeAtActor:: DetermineIfGrenadeShouldBeTaskThrown said yes  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	//	PushState('UseGrenadeAgainstEnemy');
	//}
	//else
	//{
	//	//`log(" ChadAI - OnAiThrowGrenadeAtActor:: DetermineIfGrenadeShouldBeTaskThrown said no  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	//}
	//
	////`log(" ChadAI - OnAiThrowGrenadeAtActor:: call ENDED  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

}


// TO C++;
function bool DetermineIfGrenadeShouldBeTaskThrown()
{

	local Pawn targetsPawn;
	local vector targetVec;
	local float rangeToEnemySq;

	if( Pawn == None )
	{
		return false;
	}

	if( !m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut )
	{
		;
		return false;
	}


	if(	!m_GrenadeUseData.m_bCheckMinDistToTargetForTask && !m_GrenadeUseData.m_bCheckMaxDistToTargetForTask && !m_GrenadeUseData.m_bCheckMinDistToFriendlyForTask )
	{
		;

		//`log(" ChadAI - TPSoldierAIController::DetermineIfGrenadeShouldBeTaskThrown No conditions to check so KILL KILL KILL -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		return DetermineGrenadeThrowVelocityAndTacStepLocation();
	}

	if( m_GrenadeUseData.m_bUseAgainstCurrentEnemyForTask )
	{
		//`log(" ChadAI - TPSoldierAIController::DetermineIfGrenadeShouldBeTaskThrown UseAgainstCurrentEnemyForTask -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		if( Enemy != None )
		{
			;
			//`log(" ChadAI - TPSoldierAIController::DetermineIfGrenadeShouldBeTaskThrown UseAgainstCurrentEnemyForTask and has an enemy: " @ Enemy @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
			m_GrenadeUseData.m_GrenadeTarget = Enemy;
		}
		else
		{
			;

			//`log(" ChadAI - TPSoldierAIController::DetermineIfGrenadeShouldBeTaskThrown UseAgainstCurrentEnemyForTask and DOES NOT have an enemy so NO JOY -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
			return false;
		}

	}
	else
	{
		//`log(" ChadAI - TPSoldierAIController::DetermineIfGrenadeShouldBeTaskThrown Do not UseAgainstCurrentEnemyForTask -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	}

	// checking to see if current target is a controller and if so get pawn location

	if( m_GrenadeUseData.m_GrenadeTarget.IsA('Controller') )
	{
		targetsPawn = Controller(m_GrenadeUseData.m_GrenadeTarget).Pawn;
	}

	//`log(" ChadAI - TPSoldierAIController::DetermineIfGrenadeShouldBeTaskThrown m_GrenadeUseData.m_GrenadeTarget: " @ m_GrenadeUseData.m_GrenadeTarget @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	//`log(" ChadAI - TPSoldierAIController::DetermineIfGrenadeShouldBeTaskThrown targetsPawn: " @ targetsPawn @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

	//`log(" ChadAI - TPSoldierAIController::DetermineIfGrenadeShouldBeTaskThrown Enemy: " @ Enemy @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

	//`log(" ChadAI - TPSoldierAIController::DetermineIfGrenadeShouldBeTaskThrown m_GrenadeUseData.m_GrenadeTarget.Location: " @ m_GrenadeUseData.m_GrenadeTarget.Location @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
	//`log(" ChadAI - TPSoldierAIController::DetermineIfGrenadeShouldBeTaskThrown Pawn.Location: " @ Pawn.Location @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

	//`log(" ChadAI - TPSoldierAIController::DetermineIfGrenadeShouldBeTaskThrown m_GrenadeUseData.m_GrenadeTarget == Enemy: " @ m_GrenadeUseData.m_GrenadeTarget == Enemy @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	


	if (TPPawn(Pawn).IsInState('Dying'))
	{
		;
		return false;
	}

	if( m_GrenadeUseData.m_GrenadeTarget == None )
	{
		;

		//`log(" ChadAI - TPSoldierAIController::DetermineIfGrenadeShouldBeTaskThrown  DOES NOT m_GrenadeTarget so NO JOY -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		return false;
	}

	if( targetsPawn != None )
	{
		targetVec = targetsPawn.Location;
	}
	else
	{
		targetVec = m_GrenadeUseData.m_GrenadeTarget.Location;
	}

	//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfGrenadeShouldBeTaskThrown:: should throw if conditions are right *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
	// then check condition of throwing


	//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfGrenadeShouldBeTaskThrown:: See if a distence to the target needs to be checked *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
	//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfGrenadeShouldBeTaskThrown:: m_bCheckMinDistToTargetForTask: " @ m_GrenadeUseData.m_bCheckMinDistToTargetForTask @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
	//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfGrenadeShouldBeTaskThrown:: m_bCheckMaxDistToTargetForTask: " @ m_GrenadeUseData.m_bCheckMaxDistToTargetForTask @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );


	if( m_GrenadeUseData.m_bCheckMinDistToTargetForTask || m_GrenadeUseData.m_bCheckMaxDistToTargetForTask )
	{
		rangeToEnemySq = VSizeSq(Pawn.Location - targetVec);

		//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfGrenadeShouldBeTaskThrown:: Needs to do a distence to target check *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfGrenadeShouldBeTaskThrown::  rangeToEnemy: " @ VSize(Pawn.Location - targetVec) @  " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		
		//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfGrenadeShouldBeTaskThrown::  rangeToEnemySq: " @ rangeToEnemySq @  " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfGrenadeShouldBeTaskThrown::  m_MinDistToTargetForTask: " @ m_GrenadeUseData.m_MinDistToTargetForTask @  " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfGrenadeShouldBeTaskThrown::  m_MinDistToTargetForTaskSq: " @ m_GrenadeUseData.m_MinDistToTargetForTask * m_GrenadeUseData.m_MinDistToTargetForTask @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfGrenadeShouldBeTaskThrown::  m_MaxDistToTargetForTask: " @ m_GrenadeUseData.m_MaxDistToTargetForTask @  " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfGrenadeShouldBeTaskThrown::  m_MaxDistToTargetForTaskSq: " @ m_GrenadeUseData.m_MaxDistToTargetForTask * m_GrenadeUseData.m_MaxDistToTargetForTask @  " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		// check if min distence is violated
		if( m_GrenadeUseData.m_bCheckMinDistToTargetForTask )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfGrenadeShouldBeTaskThrown::  checking min range to target  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

			if( rangeToEnemySq < m_GrenadeUseData.m_MinDistToTargetForTask * m_GrenadeUseData.m_MinDistToTargetForTask )
			{
				;

				//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfGrenadeShouldBeTaskThrown::  The target is inside the min rage so NO JOY  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
				return false;
			}
			else
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfGrenadeShouldBeTaskThrown::  The target is outside the min rage so KILL KILL KILL  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
			}
		}
		else
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfGrenadeShouldBeTaskThrown::  no need to check min range to target  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		}

		// check if max distence if violated

		if( m_GrenadeUseData.m_bCheckMaxDistToTargetForTask )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfGrenadeShouldBeTaskThrown::  checking max range to target  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

			if( rangeToEnemySq > m_GrenadeUseData.m_MaxDistToTargetForTask * m_GrenadeUseData.m_MaxDistToTargetForTask )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfGrenadeShouldBeTaskThrown::  The target is outside the max rage so NO JOY  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
				;

				return false;
			}
			else
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfGrenadeShouldBeTaskThrown::  The target is inside the max rage so KILL KILL KILL  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
			}
		}
		else
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfGrenadeShouldBeTaskThrown::  no need to check max range to target  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		}
	}
	else
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfGrenadeShouldBeTaskThrown::  no need to check min or max range to target  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
	}

	if( m_GrenadeUseData.m_bCheckMinDistToFriendlyForTask )
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfGrenadeShouldBeTaskThrown:: Needs to do a min distence to friendlies check *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfGrenadeShouldBeTaskThrown::  m_MinDistToFriendlyForTask: " @ m_GrenadeUseData.m_MinDistToFriendlyForTask @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		
		if( IsAFriendlyToCloseToThisLocation( targetVec, m_GrenadeUseData.m_MinDistToFriendlyForTask ) )
		{
			;
			//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfGrenadeShouldBeTaskThrown:: checking range conditions: and friend is too close SO NO JOY*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
			return false;
		}
		else
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfGrenadeShouldBeTaskThrown:: No friends to close so KILL KILL KILL *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		}
	}
	else
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " DetermineIfGrenadeShouldBeTaskThrown::  no need to check min range to friendlies  *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
	}

	;
	return DetermineGrenadeThrowVelocityAndTacStepLocation();
}


function ThrowGrenadeAtActor()
{
	;		
}

function EndThrowGrenadeAtActor()
{
	;		

	if (TPPawn(Pawn).Weapon != None)
	{
		TPPawn(Pawn).Weapon.SetWeaponHidden(false);
		//EnableAI();
	}

	if( Pawn != None )
	{
		TPPawn(Pawn).m_bThrowingGrenade = false;

		TPPawn(Pawn).FinishSceneAnimation(0.1);
	}
}

function SpawnGrenade()
{
	local Class<Inventory> Item;
	local TPWeapon Weapon;
// 	local vector  SocketLoc;
// 	local rotator SocketRot;

	
	// If we already have a handy grenade (um... sorry...), then just use that.
	if (HeldGrenade != None)
	{
		;
		if( HeldGrenade.DroppedPickupMesh.HiddenGame )
		{
			HeldGrenade.DroppedPickupMesh.SetHidden(FALSE);
		}
	}
	else if( Pawn != None )
	{
		;

		Item =  class<Weapon>(FindObject("TPGameContent.Grenade", class'Class'));
		if (Item != None)
		{
			Weapon = TPWeapon(Spawn(Item));
		    Weapon.AmmoCount      = 1;
			Weapon.AmmoInMagazine = 0;
			
			HeldGrenade = Weapon;

			if( Pawn.Mesh.GetSocketByName('GrenadeHand') != None) 
			{
				;
				Pawn.Mesh.AttachComponentToSocket(HeldGrenade.DroppedPickupMesh, 'GrenadeHand');
			}
			else if( Pawn.Mesh.GetSocketByName('Grenade') != None)
			{
				;
				Pawn.Mesh.AttachComponentToSocket(HeldGrenade.DroppedPickupMesh, 'Grenade');
			}
			else
			{
				;
			}

			HeldGrenade.DroppedPickupMesh.SetShadowParent(Pawn.Mesh);
			HeldGrenade.DroppedPickupMesh.SetLightEnvironment(Pawn.Mesh.LightEnvironment);
		}
		else
		{
			;
		}
	}
}

function DropGrenade()
{
	local Vector TossVelocity;
	local DroppedPickup P;
	local TPWeapon SpawnWeapon;
	
	if (Pawn != None)
		TossVelocity = vector(Pawn.GetViewRotation()) * 100.0f;

	;
				
	if( Instigator != None && Instigator.InvManager != None )
	{
		Instigator.InvManager.RemoveFromInventory(HeldGrenade);
	}

    if( HeldGrenade.DroppedPickupClass == None)
	{
		Destroy();
		return;
	}

	P = HeldGrenade.Spawn(HeldGrenade.DroppedPickupClass,,, HeldGrenade.Location);
	if( P == None )
	{
		Destroy();
		return;
	}

	P.SetPhysics(PHYS_Falling);
	P.Inventory	= HeldGrenade;
	P.InventoryClass = HeldGrenade.class;
	P.Velocity = TossVelocity;
	P.Instigator = HeldGrenade.Instigator;
	P.SetPickupMesh(HeldGrenade.DroppedPickupMesh);
	P.LifeSpan = HeldGrenade.DroppedPickupLifespan;
	SpawnWeapon = TPWeapon(P.Inventory);
	if (SpawnWeapon != None)
	{
		SpawnWeapon.AmmoInMagazine = 0;
		SpawnWeapon.AmmoCount = 1;
	}
	;
}

//-----------------------------------------------------------------------
// State:	UseGrenadeAgainstEnemy
// Description: 
//-----------------------------------------------------------------------
state UseGrenadeAgainstEnemy
{
	ignores NotifyBump;

	function BeginState(Name PreviousStateName)
	{
		//`log(" ChadAI - TPSoldierAIController::UseGrenadeAgainstEnemy::BeginState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");		
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		//ActivateKynapseBrain(false);
	}

	event PushedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;
		//ActivateKynapseBrain(false);
	}

	/* don't think we should do this, DK
	event bool NotifyBump(Actor Other, vector HitNormal)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " UseGrenadeAgainstEnemy:NotifyBump ignoring for now -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	


		return true;
	}
	*/

	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " UseGrenadeAgainstEnemy:NotifyTakeHit ignoring for now -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		//m_MultiTierEngagementInfo.m_bTookHitWhilePursuing = true;

		//Super.NotifyTakeHit(InstigatedBy,HitLocation,Damage,damageType,Momentum);		
	}
	
	event PausedState()
	{
		//`log(" ChadAI - TPSoldierAIController::UseGrenadeAgainstEnemy::PausedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		if( Pawn != None )
		{
			TPPawn(Pawn).m_bThrowingGrenade = false;
		}
		;	

	}

	event ContinuedState()
	{
		//`log(" ChadAI - TPSoldierAIController::UseGrenadeAgainstEnemy::ContinuedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;	

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		//ActivateKynapseBrain(false);

		PopState();
	}

	event PoppedState()
	{
		//`log(" ChadAI - TPSoldierAIController::UseGrenadeAgainstEnemy::PoppedState  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		if( Pawn != None )
		{
			TPPawn(Pawn).m_bThrowingGrenade = false;
		}

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		m_CoverMoveData.m_CoverState = CoverBehavior_Hiding;

		m_GrenadeUseData.m_bUseSmokeGrenadeForTask = false;

		m_GrenadeUseData.m_bHasThrowForceBeenCalculated = false;

		m_GrenadeUseData.m_TimeGrenadeThrowAnimStarted = -1.0;

		m_GrenadeUseData.m_bTaskAssignedToUseGrenade = false;
		m_GrenadeUseData.m_bCalcUpperArcForTask = false;

		//ActivateKynapseBrain(true);

		// Get rid of our dummy grenade if it happens to be still around
		if (HeldGrenade != None)
		{
			if (!HeldGrenade.DroppedPickupMesh.HiddenGame)
			{
				;
				HeldGrenade.DroppedPickupMesh.SetHidden(TRUE);
			
				// If our hapless soldier has died, drop a grenade for his killer to enjoy
				if (Pawn == None || Pawn.Health <= 0)
				{
					DropGrenade();
				}
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

		;	
	}
	
	function EndState(Name NextStateName)
	{
		//`log(" ChadAI - TPSoldierAIController::UseGrenadeAgainstEnemy::EndState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		if( Pawn != None )
		{
			TPPawn(Pawn).m_bThrowingGrenade = false;
		}

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		m_CoverMoveData.m_CoverState = CoverBehavior_Hiding;

		m_GrenadeUseData.m_bUseSmokeGrenadeForTask = false;

		m_GrenadeUseData.m_bHasThrowForceBeenCalculated = false;

		//ActivateKynapseBrain(true);

		m_GrenadeUseData.m_TimeGrenadeThrowAnimStarted = -1.0;

		m_GrenadeUseData.m_bTaskAssignedToUseGrenade = false;
		m_GrenadeUseData.m_bCalcUpperArcForTask = false;

		if (HeldGrenade != None)
		{
 			if (!HeldGrenade.DroppedPickupMesh.HiddenGame)
 			{
				;
				HeldGrenade.DroppedPickupMesh.SetHidden(TRUE);
			
				// If our hapless soldier has died, drop a grenade for his killer to enjoy
				if (Pawn == None || Pawn.Health <= 0)
					DropGrenade();
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

		;	

	}
	
    function NotifyWeaponFired(Weapon W, byte FireMode)
    {
		// do nothing for now
		//`log(" ChadAI - TPSoldierAIController::UseGrenadeAgainstEnemy::NotifyWeaponFired  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
    }

	function ThrowGrenadeAtActor( )
	{
		local PhysicsGrenade MyGrenade;
		local PhysicsSmokeGrenade   MySmokeGrenade;
		local vector  SocketLoc;
		local rotator SocketRot;
		local vector tossVelocity;
		//local Pawn targetsPawn;
		//local vector targetVec;
		local TPPawn tpPawnRef;
		//local TPAIController aiCon;

		//`log(" ChadAI - Pawn: " @ Pawn @ " ThrowGrenadeAtActor called -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		// Get rid of our dummy grenade
		if (HeldGrenade != None)
		{
			if( !HeldGrenade.DroppedPickupMesh.HiddenGame )
			{
				;
				HeldGrenade.DroppedPickupMesh.SetHidden(TRUE);
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
		
		tpPawnRef = TPPawn(Pawn);

		if( tpPawnRef != None && m_GrenadeUseData.m_bHasThrowForceBeenCalculated )

		{

			tossVelocity = m_GrenadeUseData.m_CalculatedThrowVelocity * vect(0.50f,0.50f,1.f);


			if( !tpPawnRef.Mesh.GetSocketWorldLocationAndRotation('GrenadeHand', SocketLoc, SocketRot) )
			{
				tpPawnRef.Mesh.GetSocketWorldLocationAndRotation('Grenade', SocketLoc, SocketRot);
			}

			//`log(" ChadAI - TPSoldierAIController::UseGrenadeAgainstEnemy::ThrowGrenadeAtActor  SocketLoc: " @ SocketLoc @ " SocketRot: " @ SocketRot @ " Pawn Loc: " @ Pawn.Location @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

			if( m_GrenadeUseData.m_bUseSmokeGrenadeForTask )
			{
				//`log(" ChadAI - TPSoldierAIController::UseGrenadeAgainstEnemy::ThrowGrenadeAtActor  Using Smoke: " @ m_GrenadeUseData.m_bUseSmokeGrenadeForTask @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

 				MySmokeGrenade = Spawn(class'PhysicsSmokeGrenade',Self,,SocketLoc, tpPawnRef.Mesh.Rotation);
				//MyGrenade = Spawn(class'PhysicsGrenade',Self,,SocketLoc, TPPawn(Pawn).Mesh.Rotation);


				//`log(" ChadAI - TPSoldierAIController::UseGrenadeAgainstEnemy::ThrowGrenadeAtActor  Spawned: " @ MySmokeGrenade @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

	 
 				//TPPawn(Pawn).Mesh.DetachComponent(TPPawn(Pawn).PhySmokeGrenade.SkeletalMeshComponent);
 				//PhyGrenade = None;

				MySmokeGrenade.CookTime = m_GrenadeUseData.m_NextFuesTime;
 				MySmokeGrenade.SetSmokingTime=m_GrenadeUseData.m_TimeToSmokeForTask;

				MySmokeGrenade.SkeletalMeshComponent.SetRBRotation(tpPawnRef.Mesh.Rotation);
				//MySmokeGrenade.SkeletalMeshComponent.AddForce(vect(30,10,30)  >> Pawn.Rotation);
				MySmokeGrenade.SkeletalMeshComponent.SetRBAngularVelocity(vect(0,10,0) >> Pawn.Rotation, true);

				MySmokeGrenade.SkeletalMeshComponent.SetRBLinearVelocity(tossVelocity, true );

			}
			else
			{
				//`log(" ChadAI - TPSoldierAIController::UseGrenadeAgainstEnemy::ThrowGrenadeAtActor  Using Frag: " @ m_GrenadeUseData.m_bUseSmokeGrenadeForTask @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

				MyGrenade = Spawn(class'PhysicsGrenade',Self,,SocketLoc,tpPawnRef.Mesh.Rotation);

				//TPPawn(Pawn).Mesh.DetachComponent(TPPawn(Pawn).PhyGrenade.SkeletalMeshComponent);
				//PhyGrenade = None;

				//`log(" ChadAI - TPSoldierAIController::UseGrenadeAgainstEnemy::ThrowGrenadeAtActor m_NextFuesTime" @ m_GrenadeUseData.m_NextFuesTime @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

				MyGrenade.Activate(m_GrenadeUseData.m_NextFuesTime, class'Grenade_Persistent'.static.GetDefaultImpulseForce(),
								class'Grenade_Persistent'.static.GetDefaultAffectedRadius(), class'Grenade_Persistent'.static.GetDefaultDamageCaused_AI());


				MyGrenade.SkeletalMeshComponent.SetRBRotation(tpPawnRef.Mesh.Rotation);
				//MyGrenade.SkeletalMeshComponent.AddForce(tossVelocity >> Pawn.Rotation);
				MyGrenade.SkeletalMeshComponent.SetRBAngularVelocity(vect(0,10,0) >> Pawn.Rotation, true);

				MyGrenade.SkeletalMeshComponent.SetRBLinearVelocity(tossVelocity, true );

			}


			m_GrenadeUseData.m_NextFuesTime = class'TPTuneManager'.static.Get().GetTuneData().GrenadeUseData.m_DefaultFuseTime;


			//RandomlyPlayGrenadeScream();
		}

				//}

			//}
	}

	function TimeToSpawnGrenadeForThrow()
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " UseGrenadeAgainstEnemy:TimeToSpawnGrenadeForThrow Called -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
		if (TPPawn(Pawn).PhySmokeGrenade != None)
		{
			TPPawn(Pawn).Mesh.DetachComponent(TPPawn(Pawn).PhySmokeGrenade.SkeletalMeshComponent);
		}

		if (TPPawn(Pawn).PhyGrenade != None)
		{
			TPPawn(Pawn).Mesh.DetachComponent(TPPawn(Pawn).PhyGrenade.SkeletalMeshComponent);
		}

		SpawnGrenade();
	}

	function EndThrowGrenadeAtActor()
	{
		//`log(" ChadAI - TPSoldierAIController::UseGrenadeAgainstEnemy::EndThrowGrenadeAtActor  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		//TPPawn(Pawn).FinishSceneAnimation(0.1);

// 		if (TPPawn(Pawn).Weapon != None)
// 		{
// 			TPPawn(Pawn).Weapon.SetWeaponHidden(false);
// 			//EnableAI();
// 		}

		if( Pawn != None )
		{
			TPPawn(Pawn).m_bThrowingGrenade = false;
			m_CoverMoveData.m_CoverState = CoverBehavior_Hiding;
		}

		PopState();
	}
	
	event Tick( float DeltaTime )
	{
		if( m_GrenadeUseData.m_TimeGrenadeThrowAnimStarted > 0.0 )
		{
			if( (WorldInfo.TimeSeconds - m_GrenadeUseData.m_TimeGrenadeThrowAnimStarted ) >= class'TPTuneManager'.static.Get().GetTuneData().GrenadeUseData.m_TimeToWaitForGrenadeThrowAnimToEnd )
			{
				;
				m_GrenadeUseData.m_TimeGrenadeThrowAnimStarted = -1.0;
				// Get rid of our dummy grenade
				PopState();
			}
		}

		// no need to update aiming while throwing a gren it will fail anyways and spawn the log and take processing time.
		//UpdateAimInTheOpen(FALSE);;
		SetAimToStrightAhead();
		UpdateHeadtracking();
		//Super.Tick(DeltaTime);	
	}		

Begin:

	m_SubStateDebugInfoTag="Begin";

	StopThisBot();

	//m_GrenadeUseData.m_bThrowFromCover = true;

	if( !m_GrenadeUseData.m_bThrowFromCover )
	{
		HandleLeftCoverCollisionChange( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos );
	}

	m_GrenadeUseData.m_TimeGrenadeThrowAnimStarted = -1.0;

	//`log(" ChadAI - Pawn: " @ Pawn @ " :UseGrenadeAgainstEnemy::Begin  m_MoveNeededThrowGrenade: " @ m_GrenadeUseData.m_MoveNeededThrowGrenade @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	if( m_GrenadeUseData.m_MoveNeededThrowGrenade != RequiredMove4Engage_None )
	{
		;

		m_Engagement_Tac_Data.m_NumOfTimeTiredToGetBackToCoverAfterStepOut = 1;
		Goto('TacStepToThrowPosition');
	}

	;


	if( !m_GrenadeUseData.m_bThrowFromCover )
	{
		;

		ClearCurrentCover();

		if( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link != None )
		{
			ReserveCover(m_CoverFightData.m_CurrentlyCoverToUseAsFightPos);
		}

		if (Pawn.bIsCrouched)
		{
			m_SubStateDebugInfoTag="Throw Gren UnCrouching";

			;

			m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange = WorldInfo.TimeSeconds;

			if( Pawn != None && TPPawn(Pawn) != none )
			{
				Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToStanding_Panic;
			}

			;


			// OpenFieldPostureSwitchingState_GoingToCrouching
			while(	(Pawn.bIsCrouched && Pawn != None && TPPawn(Pawn) != none) ||
					(Pawn != None && TPPawn(Pawn) != none && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching ) )
			{
				Pawn.UnCrouch();
				Sleep(0.0);

				if( !Pawn.bIsCrouched && ( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange) >= 
											class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToPanicStandPostureChangeToFinish ) )
				{
					;
					Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
					break;
				}
			}		
		}
		else
		{
			;
		}

		//Sleep(0.0);
	}

PrepareToThrowGren:

	m_SubStateDebugInfoTag="PrepareToThrowGren";

	StopFiring();

	KynapseClear();
	StopThisBot();

	m_GrenadeUseData.m_TimePassedSinceLastThrownGrenade = 0.0f;

    //if (TPPawn(Pawn).Weapon != None)
    //{
        //DisableAI();
        //TPPawn(Pawn).Weapon.SetWeaponHidden(true);
    //}
	
    //Mesh.AttachComponentToSocket(PhyGrenade.SkeletalMeshComponent,'GrenadeHand');

// 	if( m_GrenadeUseData.m_GrenadeTarget.IsA('Controller') )
// 	{
// 		//`log(" ChadAI - UseGrenadeAgainstEnemy::Begin   m_GrenadeUseData.m_GrenadeTarget.IsA('Controller')  Controller(m_GrenadeUseData.m_GrenadeTarget).Pawn.Location: " @ Controller(m_GrenadeUseData.m_GrenadeTarget).Pawn.Location @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 		Focus = Controller(m_GrenadeUseData.m_GrenadeTarget).Pawn;
// 		Target = Focus;	
// 		DesiredRotation.Yaw = rotator( Focus.Location - Pawn.Location ).Yaw;	
// 	}
// 	else
// 	{
// 		//`log(" ChadAI - UseGrenadeAgainstEnemy::Begin   m_GrenadeUseData.m_GrenadeTarget.Is NOT A('Controller')  m_GrenadeUseData.m_GrenadeTarget.Location: " @ m_GrenadeUseData.m_GrenadeTarget.Location @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 
// 		DesiredRotation.Yaw = rotator( m_GrenadeUseData.m_GrenadeTarget.Location - Pawn.Location ).Yaw;
// 		Focus = m_GrenadeUseData.m_GrenadeTarget;
// 		Target = Focus;
// 	
// 	}

// 	if( !m_GrenadeUseData.m_bThrowFromCover )
// 	{
// 		m_SubStateDebugInfoTag="FinishRotation";
// 
// 		DesiredRotation = rotator( m_GrenadeUseData.m_SpotToThrowGrenadeAt - Pawn.Location );	
// 		DesiredRotation.Pitch = 0;
// 
// 		`AILOG(2, 'UseGrenadeAgainstEnemy', "Not throwing from cover and needs to turn to yaw: " @ DesiredRotation.Yaw );
// 
// 		Pawn.DesiredRotation = DesiredRotation;
// 		// wait til the turn is finished
// 		//FinishRotation();
// 
// 		Pawn.SetRotation( DesiredRotation );
// 		// preserve the new orientation and stop turning
// 		//PreserveRotation();
// 	}
// 	else
//  	{
//  		// I am Going to throw from cover but I might still be facng the wrong way so make sure I am facing the direction towrads the enemy. because my phyiscs may be turned off
// 		// need to just snap to that direction
//  		if( Abs(m_CoverMoveData.m_CurrentCover_Clamied.Link.GetSlotRotation(m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx).Yaw - Pawn.Rotation.Yaw) > 600 )
//  		{
//  			m_SubStateDebugInfoTag="Turning to Cover Dir";
//  
//  			if( ( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldStanding  )  && 
//  				( m_CoverMoveData.m_CurrentCover_Clamied.Link.Slots[m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx].CoverType != CT_OpenFieldMidLevel ) )
//  			{
//  				`AILOG(2, 'UseGrenadeAgainstEnemy',"Main Loop - At Corner Cover and need to turn, so just snap to it");
//  
//  				//DesiredRotation = m_CoverMoveData.m_CurrentCover_Clamied.Link.GetSlotRotation(m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx);
// 				DesiredRotation = rotator( m_GrenadeUseData.m_SpotToThrowGrenadeAt - Pawn.Location );
//  				DesiredRotation.Pitch = 0;
//  				Pawn.DesiredRotation = DesiredRotation;
//  				Pawn.SetRotation( DesiredRotation );			
//  			}
//  			else
//  			{
// 				`AILOG(2, 'UseGrenadeAgainstEnemy',"Main Loop - At open Cover and need to turn, so turn to it");
//  				//DesiredRotation = m_CoverMoveData.m_CurrentCover_Clamied.Link.GetSlotRotation(m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx);
// 				DesiredRotation = rotator( m_GrenadeUseData.m_SpotToThrowGrenadeAt - Pawn.Location );
//  				DesiredRotation.Pitch = 0;
//  				Pawn.DesiredRotation = DesiredRotation;
//  				//FinishRotation();
// 				Pawn.SetRotation( DesiredRotation );
//  			}
//  		}
//  
//  	}

	//`log(" ChadAI - UseGrenadeAgainstEnemy:: after turn  DesiredRotation.Yaw: " @ DesiredRotation.Yaw @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	if( Pawn != None )
	{
		m_SubStateDebugInfoTag="Started Throw";

		m_GrenadeUseData.m_TimeGrenadeThrowAnimStarted = WorldInfo.TimeSeconds;

		//`log(" ChadAI - UseGrenadeAgainstEnemy::Begin  right before TPPawn(Pawn).m_bThrowingGrenade = true-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		if( !m_GrenadeUseData.m_bThrowFromCover )
		{
			TPPawn(Pawn).m_bThrowingGrenade = true;
		}
		else
		{
			// set cover action to be the correct dir;
			m_CoverFightData.m_CurrentCoverAction =  m_GrenadeUseData.m_CoverActionNeededToThrowGrenFromCover;
			m_CoverMoveData.m_CoverState = CoverBehavior_ThrowingGrenade;
		}
	}

UseGrenadeAgainstEnemyLoop:
	
	//PopState();

	if(Enemy == None && !m_GrenadeUseData.m_bTaskAssignedToUseGrenade )
	{
		;
		PopState();
	}

	DesiredRotation = rotator( m_GrenadeUseData.m_SpotToThrowGrenadeAt - Pawn.Location );
	DesiredRotation.Pitch = 0;
	Pawn.DesiredRotation = DesiredRotation;
	//FinishRotation();
	Pawn.SetRotation( DesiredRotation );

	Sleep(0.0);
	Goto('UseGrenadeAgainstEnemyLoop');

TacStepToThrowPosition:

	m_SubStateDebugInfoTag="TacStepToThrowPosition";


	//`log(" ChadAI - Pawn: " @ Pawn @ " UseGrenadeAgainstEnemy-SideStep build path to side step -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	//`log(" ChadAI - Pawn: " @ Pawn @ " UseGrenadeAgainstEnemy-SideStep Just Entered SideStep: and Pawn.bIsCrouched = " @ Pawn.bIsCrouched @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	//Sleep(1.0);

	//`log(" ChadAI - Pawn: " @ Pawn @ " UseGrenadeAgainstEnemy-SideStep Just Sleep(1.0) and Pawn.bIsCrouched = " @ Pawn.bIsCrouched @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	/* FIX_STEP: test the new KynapseCanGoStraight function
	//KynapseGoToFindPath( m_Engagement_Tac_Data.m_SideStepTargetMoveLoc );
	//`log(" ChadAI - Pawn: " @ Pawn @ " UseGrenadeAgainstEnemy-SideStep Just KynapseGoToFindPath and Pawn.bIsCrouched = " @ Pawn.bIsCrouched @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	//if ( KynapseFoundPath() )
	*/

	if(Enemy == None && !m_GrenadeUseData.m_bTaskAssignedToUseGrenade)
	{
		;
		PopState();
	}

	//Pawn.DrawDebugSphere(m_GrenadeUseData.m_ZBoundSpotToThrowGrenadeFrom, 30, 20, 255,255,255, true);

	//`log(" ChadAI - Pawn: " @ Pawn @ " UseGrenadeAgainstEnemy-SideStep m_SpotToThrowGrenadeFrom: " @ m_GrenadeUseData.m_ZBoundSpotToThrowGrenadeFrom @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	//`log(" ChadAI - Pawn: " @ Pawn @ " UseGrenadeAgainstEnemy-SideStep Pawn Loc: " @ Pawn.Location @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	if ( KynapseCanGoStraight(m_GrenadeUseData.m_ZBoundSpotToThrowGrenadeFrom) )
	{
		m_SubStateDebugInfoTag="Step to Gren Throw Spot";

		//`log(" ChadAI - Pawn: " @ Pawn @ " UseGrenadeAgainstEnemy-SideStep found path to tac step so start stepping -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;

		if( m_CoverFightData.m_CurrentlyCoverToUseAsFightPos.Link != None )
		{
			ClearCurrentCover();

			ReserveCover(m_CoverFightData.m_CurrentlyCoverToUseAsFightPos);
		}

		Sleep(0.0);

		if (Pawn.bIsCrouched)
		{
			m_SubStateDebugInfoTag="Tac Step UnCrouching";


			m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange = WorldInfo.TimeSeconds;

			if( Pawn != None && TPPawn(Pawn) != none )
			{
				Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToStanding;
			}

			;


			// OpenFieldPostureSwitchingState_GoingToCrouching
			while(	(Pawn.bIsCrouched && Pawn != None && TPPawn(Pawn) != none) ||
					(Pawn != None && TPPawn(Pawn) != none && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching ) )
			{
				Pawn.UnCrouch();
				Sleep(0.0);

				if( !Pawn.bIsCrouched && ( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToStandPostureChange) >= 
											class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToStandPostureChangeToFinish ) )
				{
					;
					Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
					break;
				}
			}		
		}

		//Target = Enemy;

		//Focus = Target;

		m_SubStateDebugInfoTag="TacStepToThrowPosition Moving";


		DesiredRotation = rotator(m_GrenadeUseData.m_SpotToThrowGrenadeAt - Pawn.Location);
		DesiredRotation.Pitch = 0;

		//`log(" ChadAI - Pawn: " @ Pawn @ " UseGrenadeAgainstEnemy-SideStep Just StartFiring and Pawn.bIsCrouched = " @ Pawn.bIsCrouched @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		KynapseClear();

		//`log(" ChadAI - Pawn: " @ Pawn @ " UseGrenadeAgainstEnemy-SideStep Just KynapseClear;and Pawn.bIsCrouched = " @ Pawn.bIsCrouched @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		MoveTo(m_GrenadeUseData.m_SpotToThrowGrenadeFrom, Enemy);

		//`log(" ChadAI - - Pawn: " @ Pawn @ " UseGrenadeAgainstEnemy-SideStep Just MoveTo;and Pawn.bIsCrouched = " @ Pawn.bIsCrouched @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		//Pawn.Velocity = vect(0,0,0); // MoveTo affects velocity & acceleration
		StopThisBot(); // MoveTo affects velocity & acceleration
		//KynapseClear();

		if( VSizeSq(m_GrenadeUseData.m_ZBoundSpotToThrowGrenadeFrom- Pawn.Location) <= (class'TPTuneManager'.static.Get().GetTuneData().GrenadeUseData.m_ErrorDistWhenSideSteppngToGrenThrowLoc * class'TPTuneManager'.static.Get().GetTuneData().GrenadeUseData.m_ErrorDistWhenSideSteppngToGrenThrowLoc ) )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " UseGrenadeAgainstEnemy-TacStep got me close enough to throw spot so let throw the pill -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			;
			Goto('PrepareToThrowGren');
		}
		else if(m_Engagement_Tac_Data.m_NumOfTimeTiredToGetBackToCoverAfterStepOut++ < class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_NumOfTimesToTryAndGetBackToCoverAfterStepOut ) 
		{
			Goto('TacStepToThrowPosition');
		}

		//`log(" ChadAI - Pawn: " @ Pawn @ " UseGrenadeAgainstEnemy-TacStep did not get me close enough to throw spot so lets not throw the pill -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		;

		PopState();
	}

	//`log(" ChadAI - Pawn: " @ Pawn @ " UseGrenadeAgainstEnemy-TacStep did not find path to tac step so do not throw gren -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	;

	PopState();
	
}


//***********************************************************************
// AI STATES
//************************ - END SECTION - ******************************






//
//function vector SelectPatrolPoint()
//{
//    local vector vSide,vDir,vUp,vHit,vNormal,vResult;
//    local Actor AHit;
//    local int sign;
//
//
//    vDir = vector(Pawn.Rotation);
//    vUp.X = 0;
//    vUp.Y = 0;
//    vUp.Z = 1;
//
//    vSide = vDir cross vUp;
//
//    sign = Rand(3)-1;
//    if (Rand(2) == 0)
//       vResult = Pawn.Location + sign*(Rand(10)*500)*vSide;
//    else
//       vResult = Pawn.Location + sign*(Rand(10)*500)*vDir;
//
//     AHit = Trace(vHit,vNormal,vResult,Pawn.Location);
//     if (AHit != none)
//         return vHit;
//     else
//         return vResult;
//
//}
//
//function vector CalculateCurrentSidePosition()
//{
//    local vector vSide,vDir,vUp,vHit,vNormal,vResult;
//    local Actor AHit;
//    local int Random;
//    local float fDist;
//    fDist = VSize(Target.Location - Pawn.Location);
//    vDir = Normal(Target.Location - Pawn.Location);
//    vUp.X = 0;
//    vUp.Y = 0;
//    vUp.Z = 1;
//
//    vSide = vDir cross vUp;
//
//    vResult = Pawn.Location - 300*vSide; // check for hiding place on the left
//
//    // can you get to that place?
//    AHit = Trace(vHit,vNormal,vResult,Pawn.Location);
//    if (AHit==none)
//    {
//        // yes you can, check if it will hide you?
//        AHit = Trace(vHit,vNormal,vResult,Target.Location);
//        if (AHit!=none)
//          return vResult; // found hiding object
//    }
//
//    vResult = Pawn.Location + 300*vSide; // check for hiding place on the right
//    // can you get to that place?
//    AHit = Trace(vHit,vNormal,vResult,Pawn.Location);
//    if (AHit == none)
//    {
//        AHit = Trace(vHit,vNormal,vResult,Target.Location);
//        if (AHit!=none)
//          return vResult; // found hiding object
//    }
//
//    // if not found any hiding objects,
//
//
//    if (fDist > 1000)
//    {
//        // if player too far, move closer
//        vResult = Target.Location - 400*vDir;
//        AHit = Trace(vHit,vNormal,vResult,Pawn.Location);
//        if (AHit != none)
//            return vHit;
//    }
//    else
//    {
//        // move randomly
//        Random = Rand(3)-1;
//        vResult = Pawn.Location + (Random*300)*vSide;
//        return vResult;
//    }
//
//}
//



/** Convenience macro for special moves debugging */









/**
 * ===========
 * DEBUG STATES
 * ===========
 */
state DEBUGSTATE
{
	function BeginState( Name PreviousStateName )
	{
		//debug
		;
	}

	function EndState( Name NextStateName )
	{
		//debug
		;
	}

	function PushedState()
	{
		//debug
		;
	}

	function PoppedState()
	{
		//debug
		;
	}

	function ContinuedState()
	{
		//debug
		;
	}

	function PausedState()
	{
		//debug
		;
	}
}


/************************************************************************************
 * Turret support
 **********************************************************************************/

state UseTurret 
{
	function BeginState( Name PreviousStateName )
	{
		super.BeginState( PreviousStateName );
		m_bReachedTurret = FALSE;
	}

	function EndState( Name NextStateName )
	{
		super.EndState( NextStateName );
		m_bReachedTurret = FALSE;
	}

	final function bool IsAtTurret()
	{
		return m_bReachedTurret;
	}

	final function bool HasValidTurret()
	{
		return (m_CurrentTurret != None && (TPPawn(Pawn) != None || m_CurrentTurret.Driver != None));
	}
}

/**
 * Handler for scripted use of turrets.  Push into turret state.
 */
function OnAIUseTurret( SeqAct_AIUseTurret Action )
{
	// if it's a valid turret, and
	// we're allowed the transition, and
	// we can claim the turret
	if (Action.Turret != None &&
		Action.Turret.ClaimTurret(self))
	{
		// transition away
		GotoState('Action_TurretGunning', 'Begin', true, false);
	}
}

state Action_TurretGunning extends UseTurret
{
	function BeginState(Name PrevStateName)
	{
		;	

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		Super.BeginState(PrevStateName);
		//bUseFireTickets = FALSE;
//		SetTimer( 1.f, TRUE, 'SelectTarget' );
		;
	}

	function EndState( Name NextStateName )
	{
		local Turret turret;
		local TPPawn Gunner;
		
		super.EndState( NextStateName );

		;	

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		if (Pawn != None)
		{
			if (Pawn.IsA('Turret'))
			{
				Gunner = TPPawn(Turret(Pawn).Driver);
			}
			else
				Gunner = TPPawn(Pawn);

			if (Gunner != None)
			{
				if (Gunner.m_bDeadAndDoesNotKnowItYet)
					KillTheTraveller();
				Gunner.m_bForceCrouchWhileDying = false;
			}
		}

		if( m_CurrentTurret != None )
		{
			turret = m_CurrentTurret;
			if (turret.UnclaimTurret( self ))
				turret.DriverLeave( TRUE );
		}

	}

	event PoppedState()
	{
		local Turret turret;
		super.PoppedState();

		;	

		if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
		{
			KillTheTraveller();
		}


		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		if( m_CurrentTurret != None )
		{
			turret = m_CurrentTurret;
			if (turret.UnclaimTurret( self ))
				turret.DriverLeave( TRUE );
		}

		if( Pawn != None )
		{
			Pawn.m_bForceCrouchWhileDying = false;
		}
	}

	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
		CheckForEnemy(false);
	}
	
	event OnHearEnemy(int playerIdx)
	{
		CheckForEnemy(false);
	}

	function float GetDeathForceForRun()
	{
		return class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_DeathForceFactor_RunToTurret;
	}

	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " Action_TurretGunning::NotifyTakeHit *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		if( Pawn != None && !m_bReachedTurret && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching)
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " Action_TurretGunning::NotifyTakeHit Took hit while moving to turret or transitioning in set to true Pawn.Health: " @ Pawn.Health @ " Trans State: " @ Pawn.m_OpenFieldPostureSwitchingState @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

			if( Pawn.Health < 1 && !TPPawn(Pawn).m_bCoweringFromGrenade)
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " Action_TurretGunning::NotifyTakeHit Health Less the 1 and not cowering Pawn.Health: " @ Pawn.Health @ " Need to Plow In: " @ TPPawn(Pawn).m_bNeedsToPlowIn @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

				if( !TPPawn(Pawn).m_bNeedsToPlowIn )
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ " Action_TurretGunning::NotifyTakeHit NotifyTakeHit and this one will kill me but running to the big gun so not going to die quite yet -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

					;
					
					Pawn.Health = 100;
					TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet = true;
					TPPawn(Pawn).m_DeadAndDoesNotKnowItYetInstigatedBy = InstigatedBy;
					TPPawn(Pawn).m_DeadAndDoesNotKnowItYetHitlocation = HitLocation;
					TPPawn(Pawn).m_DeadAndDoesNotKnowItYetMomentum = Vector(Pawn.Rotation) * GetDeathForceForRun() ;
					TPPawn(Pawn).m_DeadAndDoesNotKnowItYetDamageType = damageType;
					TPPawn(Pawn).m_bNeedsToPlowIn = true;

					KynapseClear();
					return;
				}
			}
	
		}
		else
		{
			Super.NotifyTakeHit(InstigatedBy,HitLocation,Damage,damageType,Momentum);
		}

		if( Pawn != None )
		{
			if( Pawn.Health < 1  )
			{
				//`AILog(2, 'Action_TurretGunning',"NotifyTakeHit  for DamageL " @ Damage @ " With Health: " @ Pawn.Health @ " So turning phycics back to normal" );
				//`log(" ChadAI - Pawn: " @ Pawn @ " Action_TurretGunning NotifyTakeHit from: " @ InstigatedBy.Pawn @ " for DamageL " @ Damage @ " With Health: " @ Pawn.Health @ " So turning phycics back to normal -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
				Pawn.ShouldCrouch(true); // use distance and sight check to crouch
			}
		}
		else
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " Action_TurretGunning-NotifyTakeHit Has no Pawn *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
		}

		//`log(" ChadAI - Pawn: " @ Pawn @ " Action_TurretGunning- NotifyTakeHit; " @ InstigatedBy.Pawn @ " for DamageL " @ Damage @ " With Health: " @ Pawn.Health @ " Pawn.bIsCrouched: " @ Pawn.bIsCrouched @ " m_OpenFieldPostureSwitchingState: " @ Pawn.m_OpenFieldPostureSwitchingState @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


	}

	function bool ShouldStopFiring()
	{
		return (!HasValidTarget() || !CanTurretFireAt(Target));
	}

	function Tick( float DeltaTime )
	{
		if (HasValidTurret() && IsAtTurret())
		{
			m_bTurretOverrotated = FALSE; // Automatically set during the update call below if necessary
			
			// have turret define how we should track enemies
			m_CurrentTurret.UpdateAIController( self, DeltaTime );
		}

		if( !m_bReachedTurret )
		{
			//`log(" ChadAI - Pawn: " @ Pawn @ " Action_TurretGunning-tick- m_bReachedTurret = calling DetermineIfShouldStartCQB_Tick  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			SetAimToStrightAhead();

			UpdateHeadtracking();

			if( DetermineIfShouldStartCQBForGoingToTurret_Tick() )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " Action_TurretGunning-tick- m_bReachedTurret = DetermineIfShouldStartCQB_Tick return true -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_FailedCQB_Needed;
				KynapseClear();
			}
			else  if( CurrentEnemyBehindTurret() )
			{
				m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_FailedEnemyBehindTurret;
				KynapseClear();
			}

		}

		super.Tick( DeltaTime );
	}

	/**
	 * Figure out current aim error and return fire rotation.
	 */
	function Rotator GetAdjustedAimFor(Weapon W, vector StartFireLoc)
	{
		local Rotator	POVRot;
		local Vector	POVLoc;

		GetPlayerViewPoint( POVLoc, POVRot );

		// base aim error
		POVRot.Pitch += RandRange(-256,128);
		POVRot.Yaw	 += RandRange(-512,512);

		return POVRot;
	}

	simulated function PreRotTurret()
	{
		if( Enemy != None && m_CurrentTurret != None )
		{
			m_CurrentTurret.AimDir = rotator(Enemy.Location - m_CurrentTurret.Location);//m_CurrentTurret.GetTurretAimDir();
		}
	}

	simulated event GetPlayerViewPoint(out vector out_Location, out Rotator out_rotation)
	{
		if( Pawn != None && m_CurrentTurret != None )
		{
			out_Location	= m_CurrentTurret.GetPhysicalFireStartLoc();
			out_Rotation	= m_CurrentTurret.AimDir;
		}
		else
		{
			out_Location = Location;
			out_rotation = Rotation;
		}
	}

Begin:

	m_SubStateDebugInfoTag="Begin";

	Pawn.m_bForceCrouchWhileDying = false;

	//debug
	//`AILOG(0, 'State', "BEGIN TAG"@HasValidTurret()@IsAtTurret() );
	m_bReachedTurret = FALSE;
	
	Sleep(0.0f);

TurretGunnerMainLoop:

	if( HasValidTurret() )
	{
		while( HasValidTurret() )
		{
			// Make sure we're at the turret
			if( !IsAtTurret() )
			{
				m_SubStateDebugInfoTag="Moving To Turret";
				Goto('MoveToTurretSubState');
			}
			else
			{
				m_SubStateDebugInfoTag="At Turret";

				// check to make sure the Pawn posture matchs the type of turret and if not switch

				//`log(" ChadAI - Pawn: " @ Pawn @ " TurretGunnerMainLoop - bIsCrouched : " @ Pawn.bIsCrouched @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				// Turret burst management
				do
				{
					if (!m_bCoolDown) // If we were firing, continue firing until the weapon gets too hot.
					{
						if (!m_CurrentTurret.AbleToFire())
							m_bCoolDown = TRUE;
					}
					else	// If the barrel was too hot, then wait for it to return almost to normal before firing again
					{
						if (m_CurrentTurret.GetTemperature() < 0.10f)
							m_bCoolDown = FALSE;
						Sleep(0.1f);
						
						//debug
						//`AILOG(0, 'Loop', "Waiting for reload");
					}
				} until (!m_bCoolDown);

				// found an enemy to fire at
				if ((HasValidEnemy() || CheckForEnemy()) && CanTurretFireAt(Enemy) && ShouldIAttackEnemy() )
				{
                    Target = Enemy;

					//debug
					//`AILOG(0, 'Turret', "Aiming at an enemy...?"@Enemy@Target@LineOfSightTo(Target));
					
					// Fire a burst
					while (!m_bTurretOverrotated && HasValidEnemy() && HasValidTarget() && CanTurretFireAt(Enemy))
					{
						m_CurrentTurret.StartFire(0);
						Sleep(2.0f);
					}
					
					m_CurrentTurret.StopFire(0);
					//`AILOG(0, 'Turret', "Can still fire at?"@Target@CanTurretFireAt(Target));
				}
				else
				{
					//debug
					//`AILOG(0, 'Turret', "Idle look..."@Target@Enemy@CanTurretFireAt( Target ));

					Sleep( 1.0f );
					m_CurrentTurret.AIIdleNotification( self );
				}
			}

			// added to avoid infinite recursion
			Sleep( 0.1f );
		}
	}
	else
	{
		//debug
		//`AILOG(0, 'Turret', "Error: No turret, can't gun!" );

		Sleep( 1.f );
	}


MoveToTurretSubState:

	KynapseGoToFindpath(m_CurrentTurret.GetEntryLocation());

	if (KynapseFoundPath())
	{
		m_CoverMoveData.m_Move2CoverStatus = Move2CovStat_PathBuiltWaitingToMove;
		m_CoverMoveData.m_bTookHitWhileTraveling = false;

	
		if( m_CoverMoveData.m_CurrentCover_Clamied.Link != None )
		{
			ClearCurrentCover();
		}


		KynapseFollowPath();

		//`log(" ChadAI - Pawn: " @ Pawn @ " Action_TurretGunning:: Back from Moving to Turret and TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet: "@ TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
		{
			KillTheTraveller();
			PopState();
		}

		//`log(" ChadAI - Pawn: " @ Pawn @ " Action_TurretGunning-Main Loop- back from KynapseFollowPath - m_CoverMoveData.m_Move2CoverStatus: " @ m_CoverMoveData.m_Move2CoverStatus @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		if(  m_CoverMoveData.m_Move2CoverStatus == Move2CovStat_FailedCQB_Needed )
		{
			PushState('CloseQuartersBattleAttack');
			Sleep(0.0);
			Goto('Begin');
		}
		else if( m_CoverMoveData.m_Move2CoverStatus ==  Move2CovStat_FailedEnemyBehindTurret )
		{
			;	
			Goto('EndUsingTurret');
		}
		else if( m_CoverMoveData.m_bTookHitWhileTraveling )
		{
			;	

			Sleep(0.0);
			Goto('MoveToTurretSubState');
		}

		if (KynapseHasArrived())
		{
			m_NoOfTimeTriedToMountTurret = 0;

			;

			//`log(" ChadAI - Pawn: " @ Pawn @ " Action_TurretGunning-KynapseHasArrived IS Yes  - m_CurrentTurret.TurretType: " @ m_CurrentTurret.TurretType @ " Pawn.bIsCrouched: " @ Pawn.bIsCrouched @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			//`log(" ChadAI - Pawn: " @ Pawn @ " Action_TurretGunning-KynapseHasArrived Dist From Turret Entry Loc: " @ VSize(Pawn.Location - m_CurrentTurret.GetEntryLocation()) @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			
			PreRotTurret();

			while( VSize(Pawn.Location - m_CurrentTurret.m_MountLoc ) > m_CurrentTurret.m_MinDistToMountTurret )
			{
				m_NoOfTimeTriedToMountTurret++;
				MoveTo( m_CurrentTurret.m_MountLoc );
				//`log(" ChadAI - Pawn: " @ Pawn @ " Action_TurretGunning-MoveTo Dist From Turret Entry Loc: " @ VSize(Pawn.Location - m_CurrentTurret.m_MountLoc) @ " m_CurrentTurret.m_MinDistToMountTurret: " @ m_CurrentTurret.m_MinDistToMountTurret @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				
				if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
				{
					KillTheTraveller();
					PopState();
				}

				if( m_NoOfTimeTriedToMountTurret >= class'TPTuneManager'.static.Get().GetTuneData().CoverEngagementTuneData.m_MaxNumberOfTimeToTryAndMountTurretBeforeSnappingToIt )
				{
					;
					break;
				}
			}
			
			// if a low turret have the NPC crouch
			if( m_CurrentTurret.TurretType == TU_Crouch )
			{
				m_SubStateDebugInfoTag="Crouching";

				m_Engagement_Tac_Data.m_TimeStartedToWaitForToCrouchPostureChange = WorldInfo.TimeSeconds;

				if( Pawn != None && TPPawn(Pawn) != none )
				{
					Pawn.m_bForceCrouchWhileDying = true;
					Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToMountLowMG;
					Pawn.ShouldCrouch(true); // use distance and sight check to crouch
				}

				while(	(Pawn.bIsCrouched && Pawn != None && TPPawn(Pawn) != none) ||
						(Pawn != None && TPPawn(Pawn) != none && Pawn.m_OpenFieldPostureSwitchingState != OpenFieldPostureSwitchingState_NotSwitching ) )
				{
					//`log(" ChadAI - Pawn: " @ Pawn @ " Action_TurretGunning- in the while Crouching Pawn.bIsCrouched: " @ Pawn.bIsCrouched @ " m_OpenFieldPostureSwitchingState: " @ Pawn.m_OpenFieldPostureSwitchingState @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_GoingToMountLowMG;
					Pawn.ShouldCrouch(true); // use distance and sight check to crouch
					Sleep(0.0);

					if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
					{
						KillTheTraveller();
						PopState();
					}

					//`log(" ChadAI - Pawn: " @ Pawn @ " Action_TurretGunning- in the while Crouching after Sleep(0.1); Pawn.bIsCrouched: " @ Pawn.bIsCrouched @ " m_OpenFieldPostureSwitchingState: " @ Pawn.m_OpenFieldPostureSwitchingState @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


					//	|-|-|
					//	|-|-|
					//	|-|-|
					//    __
					//	|*|*
					//	|-+-|
					//	___|*|
					//	|*|*|
					//	|+|+|
					//	|*|*|

// 					if( !m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd )
// 					{
// 						//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Action_TurretGunning not wait for burst cool down. start firing-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
// 
// 						`AILOG(4, 'Action_TurretGunning', "Crouching in While not wait for burst cool down. start firing");
// 
// 						`if(`isdefined(FINAL_RELEASE))
// 							StartFiring();
// 						`else
// 							StartFiring('Action_TurretGunning Crouching IN While');
// 						`endif
// 					}

					//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Pawn.bIsCrouched: " @ Pawn.bIsCrouched @ " Time Waited: " @ WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToCrouchPostureChange @ " Max Time to Wait: " @ `TuneData.EngagementTacData.m_MaxTimeToWaitForToCrouchPostureChangeToFinish @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

					if( Pawn.bIsCrouched && ( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedToWaitForToCrouchPostureChange) >= 
												class'TPTuneManager'.static.Get().GetTuneData().EngagementTacData.m_MaxTimeToWaitForToMountLowMGPostureChangeToFinish ) )
					{
						//`log(" ChadAI - Pawn: " @ Pawn @ " Waited to Long while changing Posture to crouch so force quiting -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

						;
						Pawn.m_OpenFieldPostureSwitchingState = OpenFieldPostureSwitchingState_NotSwitching;
						break;
					} // end if time is up

				} // end while( Not Yet Crouched )

				//`log(" ChadAI - Pawn: " @ Pawn @ " Action_TurretGunning- after the while Crouching Pawn.bIsCrouched: " @ Pawn.bIsCrouched @ " - bWantsToCrouch: " @ Pawn.bWantsToCrouch @ " m_OpenFieldPostureSwitchingState: " @ Pawn.m_OpenFieldPostureSwitchingState @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			} // end if( m_CurrentTurret.TurretType == TU_Crouch )

			m_bReachedTurret = TRUE;

			//{TU_Crouch, TU_Stand} TurretType
						
			if( !m_CurrentTurret.TryToDrive(Pawn) )
			{
				//debug
				;
				;

				//@hack!!!
				Pawn.SetLocation( m_CurrentTurret.GetEntryLocation() );
				m_CurrentTurret.TryToDrive(Pawn);
				m_bReachedTurret = TRUE;

				Sleep(1.f);
				Goto('TurretGunnerMainLoop');
			}
			else
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " Action_TurretGunning- after the TryToDrive - bIsCrouched: " @ Pawn.bIsCrouched @ " - bWantsToCrouch: " @ Pawn.bWantsToCrouch @ "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
				//Sleep(10.0);
				m_bReachedTurret = TRUE;
				Goto('TurretGunnerMainLoop');
			}
		}
		else
		{
			;	

			Sleep(0.0);
			Goto('MoveToTurretSubState');
		}

	}
	else
	{
		;	

		Goto('EndUsingTurret');
	}

EndUsingTurret:

	if( m_HighLevelAiGoal != HighLevelAiGoal_NONE )
	{
		PopState();
	}

	EvaluateSituation();

	Goto('Begin');

}

//************************ - START SECTION - ****************************
// GRAPPLE INTERACTION v2
//***********************************************************************

function GrappleFailSafe()
{
    ;

    TPPawn(Pawn).FinishSceneAnimation();
    PopState();
}

function bool GrappleKilled()
{
    return eGrappleAction == GA_Kill || eGrappleAction == GA_EnvKill || eGrappleAction == GA_ShieldKill ||
           eGrappleAction == GA_ShieldDied;
}

state Grapple_v2
{
// 	function EvaluateSituation()
// 	{
// 
// 	}

    event PushedState()
    {
		local SkelControlLookAt htrack;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		;

		m_bGrappled = true;


       	htrack = SkelControlLookAt(Pawn.Mesh.FindSkelControl('HeadTrack'));
       	if( htrack != None )
       	{
           	htrack.ControlStrength = 0;
       		htrack.SetSkelControlActive(false);
       	}

        Pawn.AimOffset.X = 0;
        Pawn.AimOffset.Y = 0;
  
        AbortMove(false);
        ClearLatentAction(class'SeqAct_AIMoveToActor',true);
        
        //ResetMovement();
		Velocity = vect(0,0,0);
		Acceleration = vect(0,0,0);

		Pawn.Velocity = vect(0,0,0);
		Pawn.Acceleration = vect(0,0,0);

        Pawn.DesiredRotation = Pawn.Rotation;
        DesiredRotation      = Pawn.Rotation;

        StopFiring();
        KynapseClear();

        Pawn.bProjTarget = false;
    }

	event ContinuedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;
	}

    event PausedState()
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;
	}


    event PoppedState()
    {
		local SkelControlLookAt htrack;

		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;


        if (Pawn == None)
            return;

        TPPawn(Pawn).FinishSceneAnimation();

		Pawn.InvManager.SwitchToBestWeapon();

       	htrack = SkelControlLookAt(Pawn.Mesh.FindSkelControl('HeadTrack'));
       	if( htrack != None )
       	{
       		htrack.SetSkelControlActive(true);
       	}

        Pawn.bProjTarget = true;
        Pawn.SetBase(None);
        Pawn.SetPhysics(PHYS_Falling);
        Pawn.SetCollision(true, true);
        Pawn.bCollideWorld=true;

		m_bGrappled=false;
    }

    function GrabbedBy(TPPlayerController tppController)
    {
        Pawn.SetPhysics(PHYS_None);
        Pawn.SetHardAttach(true);
        Pawn.SetCollision(false, false);

		Pawn.Mesh.bForceUpdateAttachmentsInTick=true;

        // This works with no lag for placed pawns...
        //Pawn.SetBase(tppController.Pawn, , tppController.Pawn.Mesh, 'JO_positionTracker');

        // ...this works for factory spawned pawns.  Hmm...
        Pawn.SetBase(tppController.Pawn);

        // Trigger this when grabbed as requested by designers
        Pawn.TriggerEventClass(class'SeqEvent_Death', self);
    }

    function TriggerGrappleFinish()
    {
        //FindPlayer();
		FindPlayerController();
		if( m_ThePlayerController != None )
		{
			Pawn.TriggerEventClass(class'SeqEvent_GrappleFinish', m_ThePlayerController, 1);
			Pawn.TakeDamage(Pawn.Health, m_ThePlayerController, Pawn.Location, vect(0,0,0), class'TPDamageTypeGrapple');
		}
    }

    // This may not always be triggered for each grapple action since GrappleInteraction
    // may call StartGrappleAction before the animation finishes since the timing is controlled
    // by the player's animations...for the kill anims however, this will be triggered since
    // the anim for the nazi is shorter than the player's in all cases
	event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
	{
        ClearTimer('GrappleFailSafe');

        if (SeqNode.AnimSeqName == GrappleAnimName)
        {
            if (eGrappleAction == GA_Kill || eGrappleAction == GA_EnvKill || eGrappleAction == GA_ShieldKill ||
                eGrappleAction == GA_ShieldDied)
            {
                TriggerGrappleFinish();
            }
        }

        if (eGrappleAction == GA_ShieldHit)
        {
            // Would be nice to not have to do this here but we intentionally
            // don't want to have a reference to grapple interaction class in here...
            TPPawn(Pawn).PlaySceneAnimation('be0048n_ground_static_stand_attack_humanshieldnaziidle', 0);
            eGrappleAction = GA_Shield;
        }
    }

	function StartGrappleAction(eGrappleAction action, name AnimName, optional float FailTimer = 5.0f, optional int NumTimes = 1, optional bool bNoRagDollDeath = false, optional bool bNoRagDollBlending = false)
	{
        local TPPawn tpPawn;
        local TPAnimNodeDeath deathNode;
        local array<name> fixedBones;
        local vector center, extent;
        local bool bPrevCollidWorld;

        tpPawn         = TPPawn(Pawn);
        eGrappleAction = action;

        GrappleAnimName = AnimName;

        SetTimer(FailTimer,,'GrappleFailSafe');

       if (eGrappleAction == GA_Kill || eGrappleAction == GA_EnvKill || eGrappleAction == GA_ShieldKill ||
           eGrappleAction == GA_ShieldDied)
       {
           tpPawn.m_currentCoverActionCopy = CA_Default; // Force proper child (DeathStanding) for anim tree death branch

           deathNode = TPAnimNodeDeath(Pawn.Mesh.Animations.FindAnimNode('DeathStanding'));
           if (deathNode == None)
              ;

           if (bNoRagDollDeath)
           {
                if (deathNode != None)
                {
                    deathNode.NoRagDollAfterDeathAnim(true);
                    deathNode.ForceNextDeathAnim(AnimName);
                    TriggerGrappleFinish();
                }
           }
           else
           {
               if (!bNoRagDollBlending)
               {
                   if (deathNode != None)
                   {
                       center.Z = deathNode.EncroachCylinderZOffset;
                       center   = Pawn.Mesh.GetBoneLocation('JO_Hip') + center;

                       extent.X = deathNode.EncroachCylinderRadius;
                       extent.Y = deathNode.EncroachCylinderRadius;
                       extent.Z = deathNode.EncroachCylinderHeight/2;

                       DescentVelocity = center;
                       DescentFocalPoint = extent;
                   }

                   //FindPlayer();
				   FindPlayerController();
                   bPrevCollidWorld = m_ThePlayerController.Pawn.bCollideWorld;
                   m_ThePlayerController.Pawn.bCollideWorld = false;

                   if (tpPawn.IsTooCloseToWall(center, extent))
                   {
                       ;

                       fixedBones.AddItem('JO_wrist_R');
                       fixedBones.AddItem('JO_wrist_L');
                       fixedBones.AddItem('JO_gun');

                       Pawn.Mesh.SetBlockRigidBody(true);
                       tpPawn.InitiateRagDollBlending(Pawn.Mesh.GetAnimLength(AnimName), fixedBones);
                   }

                   m_ThePlayerController.Pawn.bCollideWorld = bPrevCollidWorld;
               }

               tpPawn.PlaySceneAnimation(AnimName, NumTimes);
           }
       }
       else
       {
           tpPawn.PlaySceneAnimation(AnimName, NumTimes);
       }
    }

    event Tick(float DeltaTime)
    {
        local TPPawn tpPawn;
        tpPawn = TPPawn(Pawn);
        if (tpPawn.IsRagDollBlending() && tpPawn.Health > 0)
            tpPawn.TickRagDollBlending(DeltaTime);
    }
}

//************************ - END SECTION - ******************************
// GRAPPLE INTERACTION v2
//***********************************************************************

final function bool CanTurretFireAt(Actor TestActor)
{
	local TPPawn targetTP;
	local Vector fireLoc;
	if (TestActor != None)
	{
		fireLoc = m_CurrentTurret.GetPhysicalFireStartLoc();
		
		// check to see if it's a target protected by cover
		targetTP = TPPawn(TestActor);
		if (targetTP != None &&
			targetTP.IsProtectedByCover(Normal(targetTP.Location - fireLoc)))
		{
			// add special flag setting here to enable supressive fire
			;
			return FALSE;
		}
		
		// Check to see if we have LOS
		return CanFireAtNotFromCover(Pawn(TestActor), , , fireLoc);
	}
//	`Log(TestActor@" Invalid target");

	return FALSE;
}

final function TargetInsideFireArc()
{
//	local class<WarCombatAction> Action;

	//debug
	;
/*	
//	GetAction( class'WarCombatAction_Melee', Action, TRUE );
	if( Action == None )
	{
		Action = GetDefaultCombatAction();
	}

	TransitionTo( Action, "Target got inside turret arc" );*/
}

final function NotifyTurretRotationClamped()
{
	//debug
	;

	m_bTurretOverrotated = TRUE;
}

state Ride_Blimp_Idle
{
	// Not to C++
	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
		//`log(" ChadAI - " @ self @ "Ride_Blimp_Idle::OnSeeEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
		CheckForEnemy(false);
	}
	
	// Not to C++
	event OnHearEnemy(int playerIdx)
	{
		//`log(" ChadAI - " @ self @ "Ride_Blimp_Idle::OnHearEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
		CheckForEnemy(false);
	}

	// Not to C++
	function BeginState(Name PreviousStateName)
	{
		;
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;
		m_BlimpState = BlimpWarriorState_Idle;
	}
	
	// Not to C++
	function EndState(Name NextStateName)
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;
		m_BlimpState = BlimpWarriorState_NotInBlimp;
		m_bNeedToSwitchBlimpPosture = false;

	}
// Not to C++
    event PoppedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;
		m_BlimpState = BlimpWarriorState_NotInBlimp;
		m_bNeedToSwitchBlimpPosture = false;
	}
// Not to C++
    event PushedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		m_BlimpState = BlimpWarriorState_Idle;
	}

// Not to C++
	event PausedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		m_BlimpState = BlimpWarriorState_NotInBlimp;
		m_bNeedToSwitchBlimpPosture = false;
	}
// Not to C++
	event ContinuedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		m_BlimpState = BlimpWarriorState_Idle;
	}

	// Not to C++
	event Tick( float DeltaTime )
	{
		//UpdateAimInTheOpen(FALSE);;
		SetAimToStrightAhead();
		UpdateHeadtracking();
	}

	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Ride_Blimp_Idle NotifyTakeHit - InstigatedBy: " @ InstigatedBy @ "  Damage: " @ Damage @ " -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		NotifyTakeHitWhileRidingInBlimp(InstigatedBy, HitLocation, Damage, damageType, Momentum);
	}

Begin:
	m_SubStateDebugInfoTag="Begin";

	m_bNeedToSwitchBlimpPosture = false;
	m_BlimpAttackSubState = BlimpAttackSubState_StandingNotAttacking;

	if( ShouldIKneeInBlimpForAttack() )
	{
		m_BlimpAttackSubState = BlimpAttackSubState_TransitioningFromStandToCrouch;

		while( m_BlimpAttackSubState != BlimpAttackSubState_CrouchingNotAttacking )
		{
			Sleep(0.0);
		}
	}

MainRidingLoop:

	if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
	{
		if( RandRange(0.0,1.0) <= TPAssaultBlimp_Persistent(TPPawn(Pawn).Blimp).m_NPCChanceToEjectBackWardsWhenKilled )
		{
			KillTheTraveller(false);
		}
		else
		{
			KillTheTraveller(true);
		}
		PopState();
	}

 	if( m_bNeedToSwitchBlimpPosture )
 	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Ride_Blimp_Idle-MainRidingLoop - m_bNeedToSwitchBlimpPosture - m_BlimpAttackSubState: " @ m_BlimpAttackSubState @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

 		if( m_BlimpAttackSubState == BlimpAttackSubState_TransitioningFromStandToCrouch )
		{
			m_SubStateDebugInfoTag="Crouching";
			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Ride_Blimp_Idle-MainRidingLoop - m_bNeedToSwitchBlimpPosture-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

 			while( m_BlimpAttackSubState != BlimpAttackSubState_CrouchingNotAttacking )
 			{
 				Sleep(0.0);
				if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
				{
					if( RandRange(0.0,1.0) <= TPAssaultBlimp_Persistent(TPPawn(Pawn).Blimp).m_NPCChanceToEjectBackWardsWhenKilled )
					{
						KillTheTraveller(false);
					}
					else
					{
						KillTheTraveller(true);
					}

					PopState();
				}
 			}

			m_bNeedToSwitchBlimpPosture = false;
		}
		else //( m_BlimpAttackSubState == BlimpAttackSubState_TransitioningFromCrouchToStand )
		{
			m_SubStateDebugInfoTag="Standing";

 			while( m_BlimpAttackSubState != BlimpAttackSubState_StandingNotAttacking )
 			{
 				Sleep(0.0);
				if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
				{
					if( RandRange(0.0,1.0) <= TPAssaultBlimp_Persistent(TPPawn(Pawn).Blimp).m_NPCChanceToEjectBackWardsWhenKilled )
					{
						KillTheTraveller(false);
					}
					else
					{
						KillTheTraveller(true);
					}

					PopState();
				}

 			}

			m_bNeedToSwitchBlimpPosture = false;
		}
 	}

	Sleep(0.0);
	Goto('MainRidingLoop');
}

native final function bool ShouldIKneeInBlimpForAttack();
// {
// 	local float chanceToGoLow;
// 
// 	chanceToGoLow = RandRange(0.0, 1.0);
// 
// 	//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " ShouldIKneeInBlimpForAttack - chanceToGoLow: " @ chanceToGoLow @ " and rate: " @ TPAssaultBlimp_Persistent(TPPawn(Pawn).Blimp).m_NPCChanceToGoDown @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 
// 	if( chanceToGoLow<= TPAssaultBlimp_Persistent(TPPawn(Pawn).Blimp).m_NPCChanceToGoDown )
// 	{
// 		return true;
// 	}
// 
// 	return false;
// }

native final function bool CanIFireFromBlimp();


state Ride_Blimp_Attack
{
	// Not to C++
	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
		//`log(" ChadAI - " @ self @ "Ride_Blimp_Attack::OnSeeEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
		CheckForEnemy(false);
	}
	
	// Not to C++
	event OnHearEnemy(int playerIdx)
	{
		//`log(" ChadAI - " @ self @ "Ride_Blimp_Attack::OnHearEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
		CheckForEnemy(false);
	}

	// Not to C++
	function BeginState(Name PreviousStateName)
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		GetMyTPWeapon();
		if( m_MyTPWeapon != None )
		{
			m_MyTPWeapon.m_BlimpDmgPlus = TPAssaultBlimp_Persistent(TPPawn(Pawn).Blimp).m_NPCWeaponDamageIncrease;
		}

		m_BlimpState = BlimpWarriorState_Attack;
	}
	
	// Not to C++
	function EndState(Name NextStateName)
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		GetMyTPWeapon();
		if( m_MyTPWeapon != None )
		{
			m_MyTPWeapon.m_BlimpDmgPlus = 0;
		}

		m_BlimpState = BlimpWarriorState_NotInBlimp;
		m_bNeedToSwitchBlimpPosture = false;

	}
// Not to C++
    event PoppedState()
	{
		;

		GetMyTPWeapon();
		if( m_MyTPWeapon != None )
		{
			m_MyTPWeapon.m_BlimpDmgPlus = 0;
		}

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		m_BlimpState = BlimpWarriorState_NotInBlimp;
		m_bNeedToSwitchBlimpPosture = false;
	}
// Not to C++
    event PushedState()
	{
		;

		m_BlimpState = BlimpWarriorState_Attack;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		GetMyTPWeapon();
		if( m_MyTPWeapon != None )
		{
			m_MyTPWeapon.m_BlimpDmgPlus = TPAssaultBlimp_Persistent(TPPawn(Pawn).Blimp).m_NPCWeaponDamageIncrease;
		}
	}

// Not to C++
	event PausedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		GetMyTPWeapon();
		if( m_MyTPWeapon != None )
		{
			m_MyTPWeapon.m_BlimpDmgPlus = 0;
		}

		m_BlimpState = BlimpWarriorState_NotInBlimp;
		m_bNeedToSwitchBlimpPosture = false;
	}
// Not to C++
	event ContinuedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		m_BlimpState = BlimpWarriorState_Attack;

		GetMyTPWeapon();
		if( m_MyTPWeapon != None )
		{
			m_MyTPWeapon.m_BlimpDmgPlus = TPAssaultBlimp_Persistent(TPPawn(Pawn).Blimp).m_NPCWeaponDamageIncrease;
		}
	}

	// Not to C++
	//---------------------------------------------------------------------------
	// Function:
	// Description:	Callback from weapon when it is fired.
	//---------------------------------------------------------------------------
	function NotifyWeaponFired(Weapon W, byte FireMode)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " Ride_Blimp_Attack::NotifyWeaponFired BurstCount: " @ BurstCount @ " BulletsPerBurst: " @ TPWeapon(Pawn.Weapon).BulletsPerBurst  @" -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
		//`log(" ChadAI - Pawn: " @ Pawn @ " Ride_Blimp_Attack::NotifyWeaponFired bIsNPCWeapon: " @ TPWeapon(Pawn.Weapon).bIsNPCWeapon@ " AmmoCount: " @ TPWeapon(Pawn.Weapon).AmmoCount @ " GetAmmoInMagazine(): " @ TPWeapon(Pawn.Weapon).GetAmmoInMagazine()  @" -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		if (Pawn != None && Pawn.Weapon != None ) 
		{
			if( !m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd )
			{
				++BurstCount;
				if (BurstCount >= TPWeapon(Pawn.Weapon).BulletsPerBurst)
				{
					m_Engagement_Tac_Data.m_TimeToWaitForWeaponBurstDelay = RandRange(TPWeapon(Pawn.Weapon).BurstDelayMin, TPWeapon(Pawn.Weapon).BurstDelayMax);

					m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd = true;
					m_Engagement_Tac_Data.m_TimeStartedWaitForWeaponBurstDelay = WorldInfo.TimeSeconds;

					//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Ride_Blimp_Attack::NotifyWeaponFired Time to wait BurstCount: " @ BurstCount @ " Delay of: " @ m_Engagement_Tac_Data.m_TimeToWaitForWeaponBurstDelay @ " -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
					;
					
					if( m_BlimpAttackSubState == BlimpAttackSubState_CrouchingNotAttacking ||
						m_BlimpAttackSubState == BlimpAttackSubState_CrouchingAttacking)
					{
						m_BlimpAttackSubState = BlimpAttackSubState_CrouchingNotAttacking; //BlimpAttackSubState_CrouchingAttacking;
					}
					else if( m_BlimpAttackSubState == BlimpAttackSubState_StandingNotAttacking ||
						m_BlimpAttackSubState == BlimpAttackSubState_StandingAttacking )
					{
						m_BlimpAttackSubState = BlimpAttackSubState_StandingNotAttacking;
					}
					
					StopFiring();
					BurstCount = 0;
				}

			}
			//`log(" ChadAI - Pawn: " @ Pawn @ " Ride_Blimp_Attack::NotifyWeaponFired GetAmmoInMagazine(): " @ TPWeapon(Pawn.Weapon).GetAmmoInMagazine()  @" -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

 			if( TPWeapon(Pawn.Weapon).GetAmmoInMagazine() == 0 )
 			{
 				//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Ride_Blimp_Attack::NotifyWeaponFired Mag is Empty -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
 
				StopFiring();
				ForceReload();
				//BurstCount = 0;

				if( m_BlimpAttackSubState == BlimpAttackSubState_CrouchingNotAttacking ||
					m_BlimpAttackSubState == BlimpAttackSubState_CrouchingAttacking ||
					m_BlimpAttackSubState == BlimpAttackSubState_CrouchReload)
				{
					m_BlimpAttackSubState = BlimpAttackSubState_CrouchReload; //BlimpAttackSubState_CrouchingAttacking;
				}
				else if( m_BlimpAttackSubState == BlimpAttackSubState_StandingNotAttacking ||
						m_BlimpAttackSubState == BlimpAttackSubState_StandingAttacking ||
						m_BlimpAttackSubState == BlimpAttackSubState_StandingReload)
				{
					m_BlimpAttackSubState = BlimpAttackSubState_StandingReload;
				}
			}
		}

		//`log(" ChadAI - Pawn: " @ Pawn @ " Ride_Blimp_Attack::NotifyWeaponFired END - m_BlimpAttackSubState: " @ m_BlimpAttackSubState  @" -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

	}

// Not to C++
	function WeaponReloaded()
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Ride_Blimp_Attack::NotifyWeaponReloadEnded fn called");
		BurstCount = 0; // reset this so it fires the correct number of bullets per burst after reload
		//m_BlimpAttackSubState = BlimpAttackSubState_StandingAttacking;
		//m_Engagement_Tac_Data.m_LastTimeLOS_4_DefaultAttacksChecked = -1.0;
	}

	function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Ride_Blimp_Attack NotifyTakeHit - InstigatedBy: " @ InstigatedBy @ "  Damage: " @ Damage @ " -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		NotifyTakeHitWhileRidingInBlimp(InstigatedBy, HitLocation, Damage, damageType, Momentum);
	}

	// Not to C++
	event Tick( float DeltaTime )
	{
		if( m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd )
		{
			if( ( WorldInfo.TimeSeconds - m_Engagement_Tac_Data.m_TimeStartedWaitForWeaponBurstDelay ) >= m_Engagement_Tac_Data.m_TimeToWaitForWeaponBurstDelay )
			{
				//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Ride_Blimp_Attack Tick Time to wait BurstCount Ended -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

				// enough time has passed so end waiting for burst cool down time
				//m_Engagement_Tac_Data.m_LastTimeLOS_4_DefaultAttacksChecked = -1.0;
				m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd = false;
			}
		}

		if( Enemy != None )
		{
  			DesiredRotation = rotator( Enemy.Location - Pawn.Location);
  			DesiredRotation.Pitch = 0;
		}

		UpdateAimInTheOpen(TRUE);
		//SetAimToStrightAhead();
		UpdateHeadtracking();
	}

Begin:
	m_SubStateDebugInfoTag="Begin";

	//ActivateKynapseBrain(false);

	//Pawn.SetPhysics(PHYS_None);
	m_bNeedToSwitchBlimpPosture = false;
	m_BlimpAttackSubState = BlimpAttackSubState_StandingNotAttacking;

	if( ShouldIKneeInBlimpForAttack() )
	{
		m_BlimpAttackSubState = BlimpAttackSubState_TransitioningFromStandToCrouch;

		while( m_BlimpAttackSubState != BlimpAttackSubState_CrouchingNotAttacking )
		{
			Sleep(0.0);
		}
	}

MainKillingLoop:

	if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
	{
		if( RandRange(0.0,1.0) <= TPAssaultBlimp_Persistent(TPPawn(Pawn).Blimp).m_NPCChanceToEjectBackWardsWhenKilled )
		{
			KillTheTraveller(false);
		}
		else
		{
			KillTheTraveller(true);
		}

		PopState();
	}

 	if( m_bNeedToSwitchBlimpPosture )
 	{
		//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Ride_Blimp_Attack-MainKillingLoop - m_bNeedToSwitchBlimpPosture - m_BlimpAttackSubState: " @ m_BlimpAttackSubState @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

 		if( m_BlimpAttackSubState == BlimpAttackSubState_TransitioningFromStandToCrouch )
		{
			m_SubStateDebugInfoTag="Crouching";
			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Ride_Blimp_Attack-MainKillingLoop - m_bNeedToSwitchBlimpPosture-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

 			while( m_BlimpAttackSubState != BlimpAttackSubState_CrouchingNotAttacking )
 			{
 				Sleep(0.0);
				if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
				{
					if( RandRange(0.0,1.0) <= TPAssaultBlimp_Persistent(TPPawn(Pawn).Blimp).m_NPCChanceToEjectBackWardsWhenKilled )
					{
						KillTheTraveller(false);
					}
					else
					{
						KillTheTraveller(true);
					}

					PopState();
				}
 			}

			m_bNeedToSwitchBlimpPosture = false;
		}
		else //( m_BlimpAttackSubState == BlimpAttackSubState_TransitioningFromCrouchToStand )
		{
			m_SubStateDebugInfoTag="Standing";

 			while( m_BlimpAttackSubState != BlimpAttackSubState_StandingNotAttacking )
 			{
 				Sleep(0.0);
				if( Pawn != None && TPPawn(Pawn).m_bDeadAndDoesNotKnowItYet )
				{
					if( RandRange(0.0,1.0) <= TPAssaultBlimp_Persistent(TPPawn(Pawn).Blimp).m_NPCChanceToEjectBackWardsWhenKilled )
					{
						KillTheTraveller(false);
					}
					else
					{
						KillTheTraveller(true);
					}

					PopState();
				}
 			}

			m_bNeedToSwitchBlimpPosture = false;
		}
 	}

	if( Enemy == None )
	{
		m_SubStateDebugInfoTag="Enemy == None";
		Sleep(0.0);
		Goto('MainKillingLoop');
	}

	if( Enemy != None )
	{
		m_SubStateDebugInfoTag="Enemy == " @ Enemy;
		Target = Enemy;
		Focus = Target;

		if( IsReloading() )
		{
			m_SubStateDebugInfoTag="Enemy == " @ Enemy @ " and IsReloading";

			Sleep(0.0);
			Goto('MainKillingLoop');
			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack_Loop - IsReloading() || m_Engagement_Tac_Data.m_bScaredBackToCoverWhileSteppedOut || m_Engagement_Tac_Data.m_bTookHit: -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Open_Field_Attack_Loop - m_bAllowTacticalSteping: " @ m_Engagement_Tac_Data.m_bAllowTacticalSteping @ " m_bHaveAlreadyTestedTacStepForThisReloadOrHitOrAimedAt: " @ m_Engagement_Tac_Data.m_bHaveAlreadyTestedTacStepForThisReloadOrHitOrAimedAt @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		} // end else for reoading and can shoot


		// CanFireAtNotFromCover(Pawn TargetPawn, optional bool bIgnoreRotation,  optional out Actor hitActor, optional vector chkLoc );
		if( !m_Engagement_Tac_Data.m_bWaitingForWeaponBurstDelayToEnd )
		{
			if( CanIFireFromBlimp() )
			{
				if( m_BlimpAttackSubState == BlimpAttackSubState_CrouchingNotAttacking ||
					m_BlimpAttackSubState == BlimpAttackSubState_CrouchingAttacking ||
					m_BlimpAttackSubState == BlimpAttackSubState_CrouchReload )
				{
					m_BlimpAttackSubState = BlimpAttackSubState_CrouchingAttacking;
				}
				else
				{
					m_BlimpAttackSubState = BlimpAttackSubState_StandingAttacking;
				}

				m_SubStateDebugInfoTag="Enemy == " @ Enemy @ " and Firing";
				//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " Ride_Blimp_Attack not wait for burst cool down. And CanFireAtNotFromCover-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

				;

				
					TP_AiStartFiring();
				


			}
			else
			{
				StopFiring();
				m_SubStateDebugInfoTag="Enemy == " @ Enemy @ " and Can NOT FireAt";
			}
		}
		else
		{
			m_SubStateDebugInfoTag="Enemy == " @ Enemy @ " and Burst Waiting";
		}

	sleep(0.0);

Goto('MainKillingLoop');

	}


}


state Ride_Blimp_Gunner
{
	// Not to C++
	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
		//`log(" ChadAI - " @ self @ "Ride_Blimp_Gunner::OnSeeEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
		CheckForEnemy(false);
	}
	
	// Not to C++
	event OnHearEnemy(int playerIdx)
	{
		//`log(" ChadAI - " @ self @ "Ride_Blimp_Gunner::OnHearEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
		CheckForEnemy(false);
	}

	// Not to C++
	function BeginState(Name PreviousStateName)
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		m_BlimpState = BlimpWarriorState_Gunner;
	}
	
	// Not to C++
	function EndState(Name NextStateName)
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		m_BlimpState = BlimpWarriorState_NotInBlimp;

	}
// Not to C++
    event PoppedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		m_BlimpState = BlimpWarriorState_NotInBlimp;
	}
// Not to C++
    event PushedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		m_BlimpState = BlimpWarriorState_Gunner;
	}

// Not to C++
	event PausedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		m_BlimpState = BlimpWarriorState_NotInBlimp;
	}
// Not to C++
	event ContinuedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		m_BlimpState = BlimpWarriorState_Gunner;
	}

	// Not to C++
	event Tick( float DeltaTime )
	{
		//UpdateAimInTheOpen(FALSE);;
		SetAimToStrightAhead();
		UpdateHeadtracking();
	}

Begin:
	m_SubStateDebugInfoTag="Begin";

	while( true )
	{
		StopFiring();
	}
}





state Ride_Blimp_Dying
{
	// Not to C++
	function OnSeeEnemy(int playerIdx, bool bNewEnemy)
	{
		//`log(" ChadAI - " @ self @ "Ride_Blimp_Dying::OnSeeEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
		//CheckForEnemy(false);
	}
	
	// Not to C++
	event OnHearEnemy(int playerIdx)
	{
		//`log(" ChadAI - " @ self @ "Ride_Blimp_Dying::OnHearEnemy -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
		//CheckForEnemy(false);
	}

	// Not to C++
	function BeginState(Name PreviousStateName)
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		m_BlimpState = BlimpWarriorState_Dying;
	}
	
	// Not to C++
	function EndState(Name NextStateName)
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		m_BlimpState = BlimpWarriorState_NotInBlimp;

	}
// Not to C++
    event PoppedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		m_BlimpState = BlimpWarriorState_NotInBlimp;
	}
// Not to C++
    event PushedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		m_BlimpState = BlimpWarriorState_Dying;
	}

// Not to C++
	event PausedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

		m_BlimpState = BlimpWarriorState_NotInBlimp;
	}
// Not to C++
	event ContinuedState()
	{
		;

		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;

		m_BlimpState = BlimpWarriorState_Dying;
	}

	// Not to C++
	event Tick( float DeltaTime )
	{
		//UpdateAimInTheOpen(FALSE);;
		//SetAimToStrightAhead();
		//UpdateHeadtracking();
	}

// 	event bool NotifyBump(Actor Other, vector HitNormal)
// 	{
// 		local Pawn bumpPawn;
// 		local Controller bumpController;
// 		local vector groundBoundedLoc;
// 		local vector GroundNormal;
// 		local vector AirNormal;
// 		
// 		bumpPawn = Pawn(Other);
// 		bumpController = GetController(bumpPawn);
// 
// 
// 		`AILOG(2, 'JumpDown', "-NotifyBump Hit: " @ Other @ " m_JumpDownSubState: " @ m_MantleGoalInfo.m_JumpDownSubState @ " pawn.loc: " @ Pawn.Location @ " ( WorldInfo.TimeSeconds - m_TimeJumpDownStarted ): " @ ( WorldInfo.TimeSeconds - m_MantleGoalInfo.m_TimeJumpDownStarted ) );
// 
// 		//`log(" ChadAI - JumpDown NotifyBump- Hit: " @ Other @ " m_JumpDownSubState: " @ m_MantleGoalInfo.m_JumpDownSubState @ " pawn.loc: " @ Pawn.Location @ " ( WorldInfo.TimeSeconds - m_TimeJumpDownStarted ): " @ ( WorldInfo.TimeSeconds - m_MantleGoalInfo.m_TimeJumpDownStarted ) @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
// 
// 		if (Pawn != None && bumpPawn != None && bumpController != None && m_MantleGoalInfo.m_JumpDownSubState != JumpDown_HitBottom )
// 		{
// 			`AILOG(2, 'JumpDown', "notify bump go to JumpDown_DeathFromAbove "@Other);
// 			// try to step aside for them
// 			//StepAsideFor(bumpPawn);
// 			groundBoundedLoc = Pawn.Location;
// 			groundBoundedLoc.Z = Other.Location.Z;
// 			GroundNormal = Normal(Other.Location - groundBoundedLoc);
// 			AirNormal = Normal(Pawn.Location - Other.Location);
// 
// 			//`log(" ChadAI - NotifyBump " @ Other @ " Other.Location: " @ Other.Location @ " groundBoundedLoc: " @ groundBoundedLoc @ " GroundNormal: " @ GroundNormal @ " -!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-! ");
// 
// 			if( Other != Pawn )
// 			{
// 				// magic jump down knockback force
// 				Other.TakeDamage(300, Self, Other.Location, GroundNormal * 75000.0f , class'TPDamageTypeImpactGrenade');
// 				//Pawn.TakeDamage(0, Pawn(Other).Controller, Pawn.Location, AirNormal * 55000.0f , class'TPDamageTypeImpactGrenade');
// 			}
// 
// 			m_MantleGoalInfo.m_JumpDownSubState = JumpDown_DeathFromAbove;
// 		}
// 		//return Super.NotifyBump(Other,HitNormal);
// 
// 		return false;
// 	}

	// Not to C++
    event bool NotifyLanded(vector HitNormal, actor Wall)
    {
		//local vector groundNormal;
		//local vector groundBoundedLoc;
		//local vector AirNormal;
		

		;

		//`log(" ChadAI - JumpDown NotifyBump- Hit: " @ Other @ " m_JumpDownSubState: " @ m_MantleGoalInfo.m_JumpDownSubState @ " pawn.loc: " @ Pawn.Location @ " ( WorldInfo.TimeSeconds - m_TimeJumpDownStarted ): " @ ( WorldInfo.TimeSeconds - m_MantleGoalInfo.m_TimeJumpDownStarted ) @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		if (Pawn != None )
		{
			;
			// try to step aside for them
			//StepAsideFor(bumpPawn);
// 			groundBoundedLoc = Pawn.Location;
// 			groundBoundedLoc.Z = Other.Location.Z;
// 			groundNormal = Normal(Other.Location - groundBoundedLoc);

			// TPDamageTypeGrapple
			Pawn.TakeDamage(Pawn.Health, Self, Pawn.Location, HitNormal * 55000.0f , class'TPDamageTypeImpactGrenade');
		}

		//Pawn.Velocity = vect(0,0,0);

        return true;
    }

Begin:
	m_SubStateDebugInfoTag="Begin";

	TPPawn(Pawn).InitRagdoll();

	
		TP_AiStartFiring();
	



	while( true )
	{
		StopFiring();
		Sleep(0.1);
	}
}



