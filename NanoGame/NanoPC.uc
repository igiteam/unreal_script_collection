/**
 * NanoPC holds all of the nano specific PlayerController functions and vars
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPC extends NanoPCBase
	config(Game)
	native(PC);

// portions of this should be promoted to GameFramework.  (e.g. all of the parts that POIs, objectives, etc. need)

// to get compiling
var bool bDisableCameraTargetingDOF;

var config float SwordLockOnDistance;
var config float SwordLockOnIdealDistanceBuffer;

var transient bool bUpdatingPlayerView;
var transient float LastPlayerViewInputTime;
var transient rotator ControlsRemapRotation;
var transient bool bRemapControls;
var transient float OriginalJoyUp, OriginalJoyRight;
var transient float RemappedJoyUp, RemappedJoyRight;


var transient float LastJoyUp, LastJoyRight;
var transient float DeltaJoyUp, DeltaJoyRight;


/** Whether player input selected the last target or not */
var transient bool bPlayerSelectedMeleeTarget;
/** Last time left thumbstick was idle */
var transient float LastRawJoyIdleInputTime;

/** Distance at which you can dash attack */
var config float DashAttackRange;

//// start nano vars

/** Stack of player inputs being used by the controller */
var transient array<PlayerInput> PlayerInputStack;
/** Reference to the main NanoPlayerInput object so that update calls (like camera reorienting) can still happen */
var transient NanoPlayerInput_Base MainPlayerInput;
/** List of Kismet input events */
var transient const array<SeqEvt_Input> InputEvents;

/** Last pawn I possessed */
var transient Pawn LastPawn;

/** List of triggers we're currently interacting with */
var transient array<Trigger> CurrentlyUsingTriggers;
/** Object that we started absorbing */
var transient array<NanoInterface_Interact> CurrentlyAbsorbingObjects;

var transient Actor TargetedActor;
var transient array<TargetSortInfo>	RecentTargetedActorList;
var config float RecentTargetedActorBufferTime;
var transient bool bSoftTargetLock;
var transient float TargetSnapCounter;

/** The grapple target that we're targeting to grapple.  NOTE:  If we are actively grappling, this is NOT the current actor we're grappling.  This is the next in the chain.  Check NSM_Grapple.GrappleActor for the actively grappling actor */
var transient Actor GrappleTarget;

/** Set of targets that the ricochet moon is tracking */
var transient array<Actor> RicochetMoonTargets;

/** This is the projectile we are SetViewTarget to! **/
var transient NanoProj_ThrownWeapon FollowedThrownWeapon;

/** Pointer to currently thrown moon (can only have one out at a time) */
var transient NanoProj_ThrownRicochetMoon ThrownMoon;
var transient NanoProj_RicochetMoonHook	  ThrownHook;

/** If you have infinite nano power */
var transient bool bInfiniteNanoPower;
/** If you have infinite combo points */
var transient bool bInfiniteComboPoints;

var float ActiveJuggleDuration;
var float ActiveJuggleRecoveryDuration;

/**
* We use this to have an easier time dealing with the disparate layouts we have. 
* 
* look into maybe even having multiple NanoPlayerInput_<type> for each scheme?
**/
enum EControllerScheme
{
	ECS_Mage,
	ECS_Ninja,
	ECS_Rambo,
	ESC_MAX
};

var transient EControllerScheme CurrControlScheme;

/** Max Targetable distance **/
var float MaxTargetableDistance;

/** Original view rotation when interp started */
var transient Rotator OrigViewRotation;
/** View rotation when interp completes */
var transient Rotator DesiredViewRotation;
/** Duration of the view interpolation */
var transient float	  ViewRotationInterpDuration;
/** Time remaining until the view rotation interp completes */
var transient float	  ViewRotationInterpTimer;

var transient bool bLockedOnTargetedActor;

/** If set, the viewtarget will be updated to face Focus in PlayerTick() */
var transient bool bUpdateViewTargetToFocus;
/** Back up the original rotation of the view target camera when we set a focus for it */
var transient rotator BriefingCameraOriginalRotation;

/** If true, the current camera look at is from a special move, and will be cleared in NanoPawn::Landed() */
var transient bool bCameraLookAtIsFromSpecialMove;

var transient float DebugTextMaxLen;
var bool bDebugAnimation;
var bool bDebugAnimOther;
var bool bDebugLogAnimation;
var transient array<Name> DebugAnimList;
var bool bDebugCamera;
var bool bDebugTargeting;
var bool bDebugAwareness;
var bool bDebugMelee;
var transient array<TargetSortInfo> DebugMeleeTargets;
var transient array<TargetSortInfo> DebugMeleeAttackers;
var bool bDebugJump;
var bool bDebugNetwork;
var bool bDebugTraversal;
var float DebugaForward, DebugaStrafe;
var Vector DebugAccelX, DebugAccelY;
var bool bDebugInput;
var bool bDebugAimOffset;

/** 
 * Juggle dirs that we use in PlayerTick.  This allows to shoot and then have some time to move the thumbstick to juggle.  Instead of having 
 * to have the thumbstick already moved when shooting.
 **/
var transient vector JuggleDir;
var transient float JuggleMag;
var transient float JuggleZ;
var transient bool bDidJuggle;


var transient array<GameCrowdAgent> NearbyCrowdAgentList;

/** Struct for encapsulating basic overview of memory used by streaming city */
struct native StreamingCityMemStats
{
	/** Mem used for static meshes that are part of always-loaded LOD maps. */
	var int     LowLODStaticMeshes;
	/** Mem used for textures that are part of always-loaded LOD maps. */
	var int     LowLODTextures;
	
	/** Mem used for static meshes that are part of streamed high LOD maps. */
	var int     HighLODStaticMeshes;
	/** Mem used for textures that are part of streamed high LOD maps. */
	var int     HighLODTextures;

	/** Mem used for static meshes from shared content packages */	
	var int     PackageStaticMeshes;
	/** Mem used for textures from shared content packages */	
	var int     PackageTextures;	
};

/** Reference to the debug camera, if one is active */
var transient NanoDebugCameraActor DebugCam;

/** Class that handles the dynamic music system. **/
var transient NanoMusicManager MusicManager;

/** If true, the IRIS is active, and should be drawn on the HUD */
var transient bool bIRISActive;


/** Looping sounds for chaos**/
var transient AudioComponent AC_ChaosIsActive;

/** helper bool for determine if we were in a ConfrontRadius or not**/
var transient bool bInsideConfrontRadius;


/** The sound mode we saved off before switching to the chaos announce sound mode **/
var transient protected name SavedChaosAnnounceSoundMode;

/** How much the controller rotated last update.  Useful for communicating input to other systems, since the absolute controller rotation now decoupled from the camera. */
var protectedwrite transient rotator LastDeltaRot;

/** How long after the sword is used until the weapon auto holsters **/
var config float TimeBeforeMeleeWeaponAutoHolsters;


//// CrowdTraversalSpeed values
//// Based on their current speed, the player's pawn will slow to this speed when colliding with crowd members
var config float CrowdTraversalSpeed_FromRunning;
var config float CrowdTraversalSpeed_FromJogging;
var config float CrowdTraversalSpeed_FromWalking;

var config float CrowdTraversalSpeed_DurationToForceSlowerVelocity;

var transient bool bCrowdTraversalSpeed_FromRunning;
var transient bool bCrowdTraversalSpeed_FromJogging;
var transient bool bCrowdTraversalSpeed_FromWalking;

var transient float CrowdTraversalSpeed_TimeToAllowFullSpeed;



cpptext
{
	virtual void PreBeginPlay();

	virtual UBOOL Tick(FLOAT DeltaSeconds, ELevelTick TickType);
	virtual UBOOL WantsLedgeCheck();
	virtual UBOOL StopAtLedge();

	virtual FRotator SetRotationRate(FLOAT deltaTime);
}

delegate OnPreciseDestinationReached()
{
	`log(`location);
}

/** Returns the CurrentSoundMode **/
simulated final function name GetCurrentSoundMode()
{
	return CurrentSoundMode;
}

function SetPreciseDestination(vector NewDestination, optional delegate<OnPreciseDestinationReached> DelegateToCall)
{
	if (IsZero(NewDestination))
	{
		//`log( "SetPreciseDestination" @ `showvar(NewDestination) );
		bPreciseDestination = FALSE;
	}
	else
	{
		bPreciseDestination = TRUE;

		OnPreciseDestinationReached = DelegateToCall;
		Pawn.DestinationOffset = Pawn.CylinderComponent.CollisionRadius * 0.7f;

		SetDestinationPosition(NewDestination);

		`log(`location@`showvar(NewDestination)@`showvar(BP2Vect(DestinationPosition))@VSize(Pawn.Location-NewDestination));		
	}
}

event ReachedPreciseDestination()
{
	`log(`location@VSize(Pawn.Location-BP2Vect(DestinationPosition)));
	OnPreciseDestinationReached();
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	MusicManager = Spawn( class'NanoMusicManager', self );

	SetSoundMode( 'Default' );

	SetTimer( 5.0f, FALSE, nameof(CheckForPreviouslyOnNano) );
}


simulated event Destroyed()
{
	if( MusicManager != None )
	{
		MusicManager.Destroy();
	}

	Super.Destroyed();
}


event Possess(Pawn aPawn, bool bVehicleTransition)
{
	Super.Possess(aPawn,bVehicleTransition);

	// Cache a reference to the NanoPawn to save repeated castings
	MyNP = NanoPawn(aPawn);
	MyTurret = NanoTurretBase(aPawn);

	// we need to fly here as we are going to be on splines in the air and on top of proc buildings (which sometimes the 
    // sentinel travel location is in the building itself
	if( ( WorldInfo.Game.MyAutoTestManager != none ) 
		&& ( WorldInfo.Game.MyAutoTestManager.SentinelTaskDescription ~= "TravelTheWorld" )
		)
	{
		CheatManager.Fly();
	}
}

reliable client function ClientRestart(Pawn NewPawn)
{
	Super.ClientRestart(NewPawn);

	// Cache a reference to the NanoPawn to save repeated castings
	MyNP = NanoPawn(NewPawn);
	MyTurret = NanoTurretBase(NewPawn);
}

function OnSetActiveWeapon(SeqAct_SetActiveWeapon Action)
{
	if( Action.WeaponClass != None )
	{
		SwitchToWeapon(Action.WeaponClass, None, TRUE);
	}
}

simulated function bool IsButtonPressed(EGameButtons Button, optional bool bRaw)
{
	if( PlayerInput == None )
	{
		`log("IsButtonPressed:  Called on server with no PlayerInput!");
		ScriptTrace();
	}
	if (bRaw)
	{
		return NanoPlayerInput_Base(PlayerInput).InputButtonDataList[Button].RawActive != 0;
	}
	else
	{
		return NanoPlayerInput_Base(PlayerInput).InputButtonDataList[Button].Active != 0;
	}
}

simulated function ForceButtonRelease(EGameButtons Button)
{
	local NanoPlayerInput_Base NPI;
	NPI = NanoPlayerInput_Base(PlayerInput);
	if (NPI != None)
	{
		NPI.ForceButtonRelease(Button);
	}
}

function SetCinematicMode( bool bInCinematicMode, bool bHidePlayer, bool bAffectsHUD, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsButtons )
{
	Super.SetCinematicMode(bInCinematicMode, bHidePlayer, bAffectsHUD, bAffectsMovement, bAffectsTurning, bAffectsButtons);

	if ( bAffectsButtons )
	{
		if ( bInCinematicMode )
		{
			DisableInput(TRUE, TRUE, TRUE);
		}
		else
		{
			EnableInput(TRUE, TRUE, TRUE);
		}
	}
}

function bool CanSlideOverLedge()
{
	local vector HitLocation, HitNormal;
	local vector TraceStart, TraceEnd;
	if( MyNP == None || !MyNP.bIsSwordActive )
	{
		return FALSE;
	}

	if( !IsPushingStraightAhead(0.2))
	{
		// need to check here to see if we are not going forward
		TraceStart = MyNP.Location; // We assume that the middle of the player cylinder is hanging
		TraceEnd = TraceStart + ((vect(0,0,-1) * MyNP.LedgeCheckThreshold));
		if( Trace( HitLocation, HitNormal, TraceEnd, TraceStart, FALSE, MyNP.GetCollisionExtent() * vect(0.5,0.5,1) ) == None )
		{
			return TRUE;
		}
	}

	return FALSE;
}

event NotifyFallingHitWall(vector HitN, Actor HitA)
{
	local NanoSkill JumpSkill;

	JumpSkill = MyNP.GetActiveSkill(class'NanoSkill_Jump');
	if (JumpSkill != None && `TimeSince(JumpSkill.LastActivateTime) < 0.3f)
	{
		// tweak vel slightly so that physics will maintain our original velocity
		// this is to help with mantle jumps where the player is likely to clip geometry for the first couple of frames, but we still want to retain velocity
		MyNP.Velocity.Z += 2;
	}

	if( MyNP.bIsSwordDashing )
	{
		StopFiring();
	}
}

/** Called when pawn stops at ledge */
event StoppedAtLedge()
{
	local NanoPawn NP;

	NP = NanoPawn(Pawn);
	if(NP != none)
	{
		NP.ForceDashStop();
	}
}


function CallServerMove
(
 SavedMove NewMove,
 vector ClientLoc,
 byte ClientRoll,
 int View,
 SavedMove OldMove
 )
{
	local NanoSavedMove PendingNanoMove;

	// @TODO - stolen from GearPC, not sure exactly why this is setup this way, need someone who understands the code better to clean up

	// @TODO compress old move if it exists
	if ( OldMove != None )
	{
		PendingNanoMove = NanoSavedMove(OldMove);
		OldMove = None;
		SendServerMove(PendingNanoMove, vect(1,2,3), ClientRoll, View, None);
	}

	// @TODO - combine pending move?
	// @TODO - compress cover info in CoverServerMove?
	if ( PendingMove != None )
	{
		PendingNanoMove = NanoSavedMove(PendingMove);
		PendingMove = None;
		SendServerMove(PendingNanoMove, vect(1,2,3), ClientRoll, View, None);
	}
	SendServerMove(NewMove, ClientLoc, ClientRoll, View, OldMove);
}

final function SendServerMove
(
 SavedMove NewMove,
 vector ClientLoc,
 byte ClientRoll,
 int View,
 SavedMove OldMove
 )
{
	local NanoSavedMove NanoMove;
	NanoMove = NanoSavedMove(NewMove);

	if( (MyNP != None) && (MyNP.PreviousSpecialMoveTime < NewMove.TimeStamp) && MyNP.IsDoingASpecialMove() && MyNP.ActiveSpecialMove.bUseUnsynchedServerMove )
	{
		UnsynchedServerMove(NewMove.TimeStamp, View);
	}
	else if (NanoMove.bIsJumpMove)
	{
		JumpServerMove
		(
		NewMove.TimeStamp,
		NewMove.Acceleration * 10,
		ClientLoc,
		NewMove.CompressedFlags(),
		ClientRoll,
		View,
		NanoMove.bHoldingJump,
		NanoMove.DashPip,
		NanoMove.LastJumpLevel,
		NanoMove.LastWallJumpNormal * 10,
		NanoMove.bLastJumpWasForward,
		NanoMove.JumpStickDir
		);
	}
	else if (NanoMove.bIsDashMove)
	{
		DashServerMove
		(
		NewMove.TimeStamp,
		NewMove.Acceleration * 10,
		ClientLoc,
		NewMove.CompressedFlags(),
		ClientRoll,
		View,
		NanoMove.DashPip,
		NanoMove.bIsBamfing
		);
	}
	else if (NanoMove.bIsAttachedToWallMove)
	{
		AttachedWallServerMove
		(
		NewMove.TimeStamp,
		NewMove.Acceleration * 10,
		ClientLoc,
		NewMove.CompressedFlags(),
		ClientRoll,
		View,
		NanoMove.WallStabThrottle,
		NanoMove.SwordAttachDir * 100.0
		);
	}
	else
	{
		ServerMove
		(
		NewMove.TimeStamp,
		NewMove.Acceleration * 10,
		ClientLoc,
		NewMove.CompressedFlags(),
		ClientRoll,
		View
		);
	}
}
/**
 * This version sent when client is doing a special move with bUseUnsynchedServerMove set
 * when this is the case, we update the special move independantly of the client and don't synchronize position until after
 * the special move is complete
 */
unreliable server function UnsynchedServerMove(float TimeStamp, int View)
{
	local rotator ViewRot, PawnRot;
	local int maxPitch;
	local float DeltaTime;

	// If this move is outdated, discard it.
	if (CurrentTimeStamp >= TimeStamp)
	{
		return;
	}
	// make sure we're in the right state
	else if (!IsInState('PlayerWalking'))
	{
		//`log(GetFuncName() @ "in state "$GetStateName());
		return;
	}
	// make sure we have a GearPawn
	else if ( MyNP == None )
	{
		// client has incorrect Pawn
		if (Pawn != None)
		{
			GivePawn(Pawn);
		}
		return;
	}
	// make sure we're actually doing a special move that ignores synching
	else if (!MyNP.IsDoingASpecialMove() || !MyNP.ActiveSpecialMove.bUseUnsynchedServerMove)
	{
		//`log(GetFuncName() @ "move with invalid special move "@MyGearPawn.SpecialMove);
		return;
	}


	// client and server update this move in parallel, only replicating Rotation updates,
	// then resyncronize position after the move is complete

	// just update timestamps and rotation
	CurrentTimeStamp = TimeStamp;
	LastActiveTime = WorldInfo.TimeSeconds;
	// ServerTimeStamp forced to current time during update in AGearPC::Tick() so no extra physics updates occur
	ViewRot.Pitch = (View & 65535);
	ViewRot.Yaw = (View >> 16);
	ViewRot.Roll = 0;
	SetRotation(ViewRot);

	// Update the rotation based on the view rotation, so we can keep synched with the pawn's rotation
	DeltaTime = FMin(MaxResponseTime,TimeStamp - CurrentTimeStamp);
	if( Pawn != None )
	{
		PawnRot.Roll	= 0;
		PawnRot.Yaw		= ViewRot.Yaw;
		if( (Pawn.Physics == PHYS_Swimming) || (Pawn.Physics == PHYS_Flying) )
		{
			maxPitch = 2;
		}
		else
		{
			maxPitch = 0;
		}

		if( (ViewRot.Pitch > maxPitch * Pawn.MaxPitchLimit) && (ViewRot.Pitch < 65536 - maxPitch * Pawn.MaxPitchLimit) )
		{
			if( ViewRot.Pitch < 32768 )
			{
				PawnRot.Pitch = maxPitch * Pawn.MaxPitchLimit;
			}
			else
			{
				PawnRot.Pitch = 65536 - maxPitch * Pawn.MaxPitchLimit;
			}
		}
		else
		{
			PawnRot.Pitch = ViewRot.Pitch;
		}
		Pawn.FaceRotation(PawnRot, DeltaTime);
	}

	// acknowledge receipt of this successful servermove()
	PendingAdjustment.TimeStamp = TimeStamp;
	PendingAdjustment.bAckGoodMove = 1;
}

unreliable server function JumpServerMove
(
	float	TimeStamp,
	vector	InAccel,
	vector	ClientLoc,
	byte	MoveFlags,
	byte	ClientRoll,
	int		View,
	bool    bHoldingJump,
	int		DashPip,
	int		JumpLevel,
	vector	WallJumpNormal,
	bool	bJumpWasForward,
	vector  StickDir
)
{
	local NanoPawn NP;
	local NanoSkill_Jump JumpSkill;
	NP = NanoPawn(Pawn);
	if (NP != None)
	{
		if( !MyNP.bIsJumping )
		{
			NP.JumpHoldTime = WorldInfo.TimeSeconds;

			JumpSkill = NP.GetSkill(class'NanoSkill_Jump');
			JumpSkill.AttemptJump(MyNP, StickDir, TRUE);
		}

		if( JumpSkill == None )
		{
			JumpSkill = NP.GetActiveSkill(class'NanoSkill_Jump');
		}

		if( !bHoldingJump )
		{
			NP.JumpHoldTime = -1.f;
		}

	}
	if (DashPip >= 0)
	{
		DashServerMove(TimeStamp,InAccel,ClientLoc,MoveFlags,ClientRoll,View,DashPip, FALSE);
	}
	else
	{
		Super.ServerMove(TimeStamp,InAccel,ClientLoc,MoveFlags,ClientRoll,View);
	}
}

unreliable server function DashServerMove
(
	float	TimeStamp,
	vector	InAccel,
	vector	ClientLoc,
	byte	MoveFlags,
	byte	ClientRoll,
	int		View,
	int		DashPip,
	bool    bIsBamfing
)
{
	local NanoPawn NP;
	local NanoSkill_Dash DashSkill;
	NP = NanoPawn(Pawn);
	if (NP != None)
	{
		if(NP.bIsAttachedToWall)
		{
			NP.DetachFromWall();
		}

		// start the dash for the server
		if( !NP.bIsDashing )
		{
			NP.ActivateSkill(class'NanoSkill_Dash');
		}
		// and set the correct level in case we missed the initial dash somehow
		DashSkill = NP.GetActiveSkill(class'NanoSkill_Dash');
		DashSkill.SetDashPips(DashPip);

/*		// if we need to be bamfing, do it before we dash
		if( bIsBamfing && !NP.bIsBamfing )
		{
			GetPRI().ActivateSkill(NP,class'NanoSkill_Bamf');
		}*/
	}
	// make sure to call the super version since the local version will consider us no longer dashing
	Super.ServerMove(TimeStamp,InAccel,ClientLoc,MoveFlags,ClientRoll,View);
}

unreliable server function AttachedWallServerMove
(
	float	TimeStamp,
	vector	InAccel,
	vector	ClientLoc,
	byte	MoveFlags,
	byte	ClientRoll,
	int		View,
	float	WallStabThrottle,
	vector	WallAttachDir
)
{
	local NanoPawn NP;
	NP = NanoPawn(Pawn);
	if (NP != None)
	{
		// Ensure being attached to wall is up to date
		if(!NP.bIsAttachedToWall)
		{
			NP.AttachToWall(WallAttachDir/100.0);
		}

		// And update stabbing throttle on server
		NP.WallStabThrottle = WallStabThrottle;
	}

	Super.ServerMove(TimeStamp,InAccel,ClientLoc,MoveFlags,ClientRoll,View);
}

unreliable server function ServerMove
(
	float	TimeStamp,
	vector	InAccel,
	vector	ClientLoc,
	byte	MoveFlags,
	byte	ClientRoll,
	int		View
)
{
	local NanoPawn NP;
	NP = NanoPawn(Pawn);
	if (NP != None)
	{
		if( NP.bIsAttachedToWall )
		{
			NP.DetachFromWall();
		}

		if( NP.bIsDashing )
		{
			NP.DeactivateSkill(class'NanoSkill_Dash');
		}

		if( NP.JumpHoldTime > 0.f )
		{
			NP.JumpHoldTime = -1.f;
		}

		if( NP.bIsJumping )
		{
			NP.DeactivateSkill(class'NanoSkill_Jump');
		}
	}
	Super.ServerMove(TimeStamp,InAccel,ClientLoc,MoveFlags,ClientRoll,View);
}

reliable server function ServerRestartPlayer()
{
	`log(WorldInfo.TimeSeconds@`location);
	WorldInfo.Game.RestartPlayer(self);
}

////////////////////// BEGIN SPECIAL MOVES //////////////////////

/** Returns TRUE if player is doing a special move */
function bool IsDoingASpecialMove()
{
	return (MyNP != None && MyNP.IsDoingASpecialMove());
}

/**
 * Returns TRUE if player is current performing TestMove.
 */
simulated function bool IsDoingSpecialMove( Name AMove )
{
	return (MyNP != None && MyNP.IsDoingSpecialMove(AMove));
}

/**
 * returns true if player can perform requested special move
 * @param bForceCheck - Allows you to skip the single frame condition (which will be incorrect on clients since LastCanDoSpecialMoveTime isn't replicated)
 */
final native function bool CanDoSpecialMove( Name AMove, optional bool bForceCheck );

/**
 * Perform a special move locally, and replicate it to server if necessary
 * @network: local player.
 */
final event DoSpecialMove( Name NewMove, optional bool bForceMove = FALSE, optional GamePawn InInteractionPawn, optional Actor InInteractionActor, optional INT InSpecialMoveFlags = 0 )
{
	local SpecialMoveStruct	NewMoveStruct;
	local bool bUpdatingSMFlags;

`if(`notdefined(FINAL_RELEASE))
	if( LocalPlayer(Player) == None )
	{
		`Warn(GetFuncName() @ "has to be called from local player!");
		ScriptTrace();
		return;
	}
`endif

	bUpdatingSMFlags = (MyNP.ActiveSpecialMoveName == NewMove && MyNP.InteractionPawn == InInteractionPawn && MyNP.InteractionActor == InInteractionActor);

	if( bForceMove || bUpdatingSMFlags || CanDoSpecialMove(NewMove) )
	{
		// Build new move struct
		NewMoveStruct = MyNP.FillSpecialMoveStructFromParams( NewMove, InInteractionPawn, InInteractionActor, InSpecialMoveFlags );

		// simulate the move locally
		MyNP.DoSpecialMoveFromStruct( NewMoveStruct, bForceMove );

		// Replicate action to the server w/ updated inputs
		if( Role < Role_Authority )
		{
			if( bUpdatingSMFlags )
			{
				ClientToServerUpdateSpecialMoveFlags(NewMoveStruct);
			}
			else
			{
				ClientToServerDoSpecialMove( NewMoveStruct, bForceMove, RemappedJoyUp, RemappedJoyRight, Pawn.Rotation.Yaw );
			}
		}
	}
}

/** updates special move flags for the current special move
 * need to make sure the server hasn't already ended that special move
 */
reliable server private function ClientToServerUpdateSpecialMoveFlags( SpecialMoveStruct NewMoveStruct )
{
	if( MyNP != None && MyNP.ActiveSpecialMoveName == NewMoveStruct.SpecialMoveName && MyNP.InteractionPawn == NewMoveStruct.InteractionPawn && MyNP.InteractionActor == NewMoveStruct.InteractionActor )
	{
		MyNP.DoSpecialMoveFromStruct(NewMoveStruct);
	}
}

/**
 * Perform a special move on the server.
 * Called from DoSpecialMove().
 * @network: server.
 */
reliable server final function ClientToServerDoSpecialMove( SpecialMoveStruct NewMoveStruct, bool bForceMove, float PlayerJoyUp, float PlayerJoyRight, int RotYaw )
{
	local rotator NewRot;

	//`log("serverdospecialmove "$NewMove@GetStateName());
	if( MyNP != None )
	{
		//`log("serverdospecialmove "$NewMove);
		// Copy over
		RemappedJoyRight = PlayerJoyRight;
		RemappedJoyUp	 = PlayerJoyUp;

		NewRot		= Pawn.Rotation;
		NewRot.Yaw	= RotYaw;
		Pawn.SetRotation(NewRot);
		
		// if we can't do the move, ask the client to send it again
		if( bForceMove || MyNP.CanDoSpecialMove(NewMoveStruct.SpecialMoveName) || NewMoveStruct.SpecialMoveName == '' )
		{
			MyNP.DoSpecialMoveFromStruct( NewMoveStruct, bForceMove );
		}
		else if( !IsLocalPlayerController() )
		{
			ClientVerifySpecialMove( NewMoveStruct.SpecialMoveName );
		}
	}
}

/** called when the server failed to do a special move we asked; i.e. we are out of sync. Re-send the current special move if necessary.
 * @todo: better would be to make SpecialMoves part of the ServerMove/ClientAdjustPosition structure, but that requires
 * 	more specific animation ticking control
 */
reliable client final function ClientVerifySpecialMove( Name FailedMove )
{
	local SpecialMoveStruct NewMoveStruct;

	if( MyNP != None && (MyNP.ActiveSpecialMoveName == FailedMove || MyNP.ActiveSpecialMoveName == '') )
	{
		NewMoveStruct = MyNP.FillSpecialMoveStructFromParams( MyNP.ActiveSpecialMoveName, MyNP.InteractionPawn, MyNP.InteractionActor, MyNP.SpecialMoveFlags );
		ClientToServerDoSpecialMove( NewMoveStruct, FALSE, RemappedJoyUp, RemappedJoyRight, Pawn.Rotation.Yaw );
	}
}

/** Replicated function to owning client, called only from ServerDictateSpecialMove() */
reliable client final function ServerToClientDoSpecialMove( SpecialMoveStruct NewMoveStruct, bool bForceMove )
{
	if( MyNP != None )
	{
		MyNP.DoSpecialMoveFromStruct( NewMoveStruct, bForceMove );
	}
}

/** Stop current special move */
final function EndSpecialMove()
{
	if( IsDoingASpecialMove() )
	{
		if( MyNP != None )
		{
			if( MyNP.IsLocallyControlled() )
			{
				MyNP.LocalEndSpecialMove();
			}
			else
			{
				MyNP.ServerEndSpecialMove();
			}
		}
	}
}


/** Server forces a special move to be replicated to the owning player. */
final event ServerDictateSpecialMove( Name NewMove, optional GamePawn InInteractionPawn, optional Actor InInteractionActor, optional INT InSpecialMoveFlags = 0 )
{
	local SpecialMoveStruct	NewMoveStruct;

	if( WorldInfo.NetMode == NM_Client )
	{
		`log(WorldInfo.TimeSeconds @ GetFuncName() @ "Called on non servers!!" );
		ScriptTrace();
		return;
	}

	// Build new move struct
	NewMoveStruct = MyNP.FillSpecialMoveStructFromParams( NewMove, InInteractionPawn, InInteractionActor, InSpecialMoveFlags );

	// if dedicated server, replicate special move to local player (client)
	if( LocalPlayer(Player) == None )
	{
		ServerToClientDoSpecialMove( NewMoveStruct, TRUE );
	}

	// Do special move right away on server.
	MyNP.DoSpecialMoveFromStruct( NewMoveStruct, TRUE );
}

/**
 * Notification called when a new special move is started.
 * Note: It is NOT safe to start a different special move from here!!
 */
function SpecialMoveStarted( Name NewMove )
{
}


/** Start as PhysicsSpectator by default */
auto state PlayerWaiting
{
Begin:
	PlayerReplicationInfo.bOnlySpectator = FALSE;
	WorldInfo.Game.bRestartLevel = FALSE;
	WorldInfo.Game.RestartPlayer( Self );
	WorldInfo.Game.bRestartLevel = TRUE;
	SetCameraMode('ThirdPerson');
}

function bool PerformSwordAttack(int SuggestedFireMode)
{
	local NanoWeap_Melee MeleeWeap;


	//`log( `showvar(MyNP.bJuggled) @ `showvar(MyNP.bStunned) @ `showvar(MyNP.bPlayingHitReaction) @ `showvar(MyNP.TeslaShock_NoAttack_ActiveUntil) );

	if( MyNP != None && !MyNP.bJuggled && !MyNP.bStunned && !MyNP.bPlayingHitReaction && MyNP.TeslaShock_NoAttack_ActiveUntil < WorldInfo.TimeSeconds)
	{
		MeleeWeap = NanoWeap_Melee(MyNP.MyNanoWeapon);

		// if we are allowed buffered input and we have already pressed a button for normal non-buffered input
		// grab the input and push it to the combo
		if( ( MeleeWeap.bBufferedInputAllowed == TRUE ) && ( MeleeWeap.ComboInput.ButtonPressed != GB_Max ) )
		{
			NanoWeap_Melee(MyNP.Weapon).FillBufferedComboInput();
		}
		
		if( MeleeWeap.WeaponSheet.AttackAnimState != AAS_None )
		{
			//`log( `showvar(MeleeWeap.WeaponSheet.AttackAnimState) @ `showvar(MeleeWeap.bAttackRecover_AllowTransitionToBaseAttack) @ `showvar(MeleeWeap.bAttackRecover_AllowTransitionToNextCombo) );

			if( MeleeWeap.bAttackRecover_AllowTransitionToBaseAttack == TRUE )
			{
				`log( "Transitioning back to base attack" @ `showvar(MeleeWeap.bAttackRecover_AllowTransitionToNextCombo) );

				MeleeWeap.FillComboInput();

				MeleeWeap.DesiredComboIdx = MeleeWeap.ResolveMeleeAttackIndex(); // Try to resolve our base attack

				MeleeWeap.ReachedComboTransitionPoint( TRUE );
			}
			else if( MeleeWeap.bAttackRecover_AllowTransitionToNextCombo == TRUE )
			{
				`log( "IMMEDIATELY transitioning to the next combo" @ `showvar(MeleeWeap.bAttackRecover_AllowTransitionToNextCombo) );
				MeleeWeap.ClearTimer( nameof(MeleeWeap.PossiblyPlayAttackRecoverToReadyPositionAnim) );

				MeleeWeap.FillComboInput();
				MeleeWeap.DesiredComboIdx = MeleeWeap.ResolveComboAttackIndex( MeleeWeap.AttackIdx );

				MeleeWeap.ReachedComboTransitionPoint( TRUE );
			}
		}
		else
		{
			StartFire(SuggestedFireMode);
		}


		// always spawn a crowd repulsor
		MyNP.SpawnWeaponCrowdPanicRepulsor( class'NanoCrowd_PanicRepulsor_MeleeWeaponSwung' );

		return TRUE;
	}
	

	return FALSE;
}


function AutoSheathMeleeWeapon()
{
	// if it is a melee weapon
	if( NanoWeap_Melee(MyNP.Weapon) != None )
	{
		MyNP.HolsterCurrentWeapon();
	}
}


function bool PerformSwordThrow()
{
	StartFire(2);
	return TRUE;
}

function Actor GetActivelyJuggledActor()
{
	local float Dist2DSq;
	local Actor A;

	if( MyNP != None && MyNP.LastCausedJuggleActor != None && `TimeSince(MyNP.LastCausedJuggleTime) < ActiveJuggleDuration )
	{
		A = Actor(MyNP.LastCausedJuggleActor);
		Dist2DSq = VSizeSq2D(A.Location-MyNP.Location);
		if( Dist2DSq > 4096 /*64^2*/ )
		{
			if( !MyNP.LastCausedJuggleActor.IsValidJuggleTarget() )
			{
				MyNP.LastCausedJuggleTime = WorldInfo.TimeSeconds + ActiveJuggleDuration;
				MyNP.LastCausedJuggleActor = None;
				return None;
			}
			return MyNP.LastCausedJuggleActor;
		}
	}
	return None;
}

function bool GetLockedToTargetedActorInfo( out Actor out_TargActor, out float out_InterpSpeed )
{
	local Actor JuggledActor;

	if( MyNP != None && !MyNP.IsAttachedToPerch() )
	{
		JuggledActor = GetActivelyJuggledActor();
		if( JuggledActor != None )
		{
			out_TargActor = JuggledActor;
			out_InterpSpeed = 40.f;
			return TRUE;
		}
		else if( TargetedActor != None && Abs(PlayerInput.aTurn) < 0.2 )
		{
			if( TargetedActor.Base != MyNP && IsViewLockedToTarget() )
			{
				out_TargActor = TargetedActor;
				out_InterpSpeed = 8.f;
				return TRUE;
			}
		}
	}

	return FALSE;
}

function bool IsViewLockedToTarget()
{
	//Disable view locking for now
/*	local NanoInterface_Targetable NTI;

	if( MyNP != None && MyNP.bIsDoingMeleeAttack )
	{
		NTI = NanoInterface_Targetable(TargetedActor);
		if( NTI != None && NTI.IsValidSwordDashTarget( MyNP ) )
		{
			return TRUE;			
		}
	}
*/
	return IsLockedOnWithSword() || IsLockedOnWithGun() || IsLockedOnWithHop();
}

function bool IsLockedOnWithSword()
{
	return bLockedOnTargetedActor && MyNP != None && MyNP.bIsSwordActive;
}

function bool IsLockedOnWithGun()
{
	return (GetActivelyJuggledActor() != None);
}

function bool IsLockedOnWithHop()
{
	return MyNP != None && MyNP.bIsDoingCarHop;
}

event Rotator GetMovementRelativeRotation( Actor RelActor )
{
	if( RelActor != None )
	{
		if( MyNP.bIsSwordDashing || IsLockedOnWithSword() || IsLockedOnWithGun() )
		{
			return Rotator(RelActor.Location - MyNP.Location);
		}
	}

	return PlayerCamera.GetCameraRotation();
}

state PlayerWalking
{
ignores SeePlayer, HearNoise, Bump;

	event BeginState(Name PreviousStateName)
	{
		local NanoPawn NP;

		DoubleClickDir = DCLICK_None;
		bPressedJump = false;
		GroundPitch = 0;
		if ( Pawn != None )
		{
			Pawn.ShouldCrouch(false);
			NP = NanoPawn(Pawn);
			// Need to do check below, otherwise releasing left trigger detaches you from car.
			if( Pawn.Physics != PHYS_Falling && Pawn.Physics != PHYS_RigidBody && Pawn.Physics != PHYS_Flying && !NP.IsAttachedToPerch()) // FIXME HACK!!!
			{
				Pawn.SetPhysics(PHYS_Walking);
			}
		}
	}

	function ProcessViewRotation( float DeltaTime, out Rotator out_ViewRotation, Rotator DeltaRot )
	{
		local NanoInterface_Targetable TargetInterface;
		local vector CamLoc, TargetLoc;
		local rotator BaseRot, IdealRot;
		local float	InterpSpeed;
		local Actor TargActor;

		Super.ProcessViewRotation(DeltaTime,out_ViewRotation,DeltaRot);

		// if targeting with a locked target then interpolate towards the target
		if( GetLockedToTargetedActorInfo( TargActor, InterpSpeed ) )
		{
			GetActorEyesViewPoint(CamLoc,BaseRot);
			TargetInterface = NanoInterface_Targetable(TargActor);
			if(TargetInterface != None)
			{
				TargetLoc = TargetInterface.GetTargetedLocation();
			}
			else
			{
				TargetLoc = TargActor.Location;
			}
	
			IdealRot = rotator(TargetLoc - CamLoc);
			IdealRot.Pitch = Clamp( IdealRot.Pitch, -5460, 5460 );
			if( MyNP.bIsSwordDashing )
			{	
				IdealRot.Pitch = 0;
			}

			out_ViewRotation = RInterpTo(out_ViewRotation,IdealRot,DeltaTime,InterpSpeed);
		}
	}

	function PlayerMove( float DeltaTime )
	{
		local vector			X,Y,Z, NewAccel;
		local eDoubleClickDir	DoubleClickMove;
		local rotator			OldRotation;
		local bool				bSaveJump;
		local float				DistToTarget, IdealDist;
		local Actor				TargActor;
		local float				InterpSpeed;
		local NanoPawn			NP;

		NP = NanoPawn(Pawn);

		DebugaForward = -999.f;
		DebugaStrafe = -999.f;

		if( Pawn == None )
		{
			GotoState('Dead');
			return;
		}

		NP.bLimitFallAccel = NP.default.bLimitFallAccel;

		if( MyNP.bStunned || NP.bIsDoingMeleeAttack || MyNP.bSliding )
		{
			NewAccel = vect(0,0,0);
			NP.bLimitFallAccel = FALSE;
		}
		// auto-dash
		else if( NP.bIsSwordDashing && TargetedActor != None  )
		{
			MyNP.bLimitFallAccel = FALSE;
			GetAxes(GetMovementRelativeRotation(TargetedActor),X,Y,Z);

			// accel/vel will be handled in NanoPawn.CalcVelocity
			NewAccel = X;
			NewAccel = Pawn.AccelRate * Normal(NewAccel);
			NP.bLimitFallAccel = FALSE;
		}
		else if( IsLockedOnWithSword() && GetLockedToTargetedActorInfo( TargActor, InterpSpeed ) )
		{
			// Update acceleration.
			GetAxes(GetMovementRelativeRotation(TargActor),X,Y,Z);
			IdealDist = GetIdealLockonDistance();
			DistToTarget = VSize2D(TargActor.Location - MyNP.Location);											

			// if too close only allow strafing/backpedaling
			if( PlayerInput.aForward > 0.f && DistToTarget < IdealDist )
			{
				NewAccel = PlayerInput.aStrafe * Y * 0.5;
			}
			else
			{
				NewAccel = PlayerInput.aForward * X + PlayerInput.aStrafe * Y * 0.5;
			}
			NewAccel.Z	= 0;
			NewAccel = Pawn.AccelRate * Normal(NewAccel) * 0.5f;

			if (PlayerInput.aForward > -0.2 && PlayerInput.aForward < 0.2 && TargActor.Physics == PHYS_Walking)
			{
				if (DistToTarget < IdealDist - 16)
				{
					NewAccel -= Pawn.AccelRate * X * 0.05;
				}
			}				
		}
		else if( IsLockedOnWithHop() )
		{
			// Do not limit the fall acceleration with the pawn when hopping cars, so we can keep up with traffic
			NP.bLimitFallAccel = FALSE;
		}
		else if( MyNP.bIsDashing )
		{
			NewAccel = Vector(MyNP.Rotation) * MyNP.AccelRate;
		}
		else 
		{
			if( IsLockedOnWithGun() && GetLockedToTargetedActorInfo( TargActor, InterpSpeed ) )
			{
				GetAxes(GetMovementRelativeRotation(TargActor),X,Y,Z);
			}
			else
			{
				GetAxes(GetMovementRelativeRotation(None),X,Y,Z);
			}

			DebugaForward = PlayerInput.aForward;
			DebugaStrafe = PlayerInput.aStrafe;
			DebugAccelX = X;
			DebugAccelY = Y;

			NewAccel = PlayerInput.aForward * X + PlayerInput.aStrafe * Y;
			NewAccel.Z = 0;
			NewAccel = Pawn.AccelRate * Normal(NewAccel);
	
		}
		
		DoubleClickMove = PlayerInput.CheckForDoubleClickMove( DeltaTime/WorldInfo.TimeDilation );

		// Update rotation.
		OldRotation = Rotation;
		UpdateRotation( DeltaTime );
		bDoubleJump = false;

		if( bPressedJump && Pawn.CannotJumpNow() )
		{
			bSaveJump = true;
			bPressedJump = false;
		}
		else
		{
			bSaveJump = false;
		}

		if( Role < ROLE_Authority ) // then save this move and replicate it
		{
			ReplicateMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
		}
		else
		{
			ProcessMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
		}
		bPressedJump = bSaveJump;
	}

	function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
	{
		Super.ProcessMove( DeltaTime, NewAccel, DoubleClickMove, DeltaRot );

		UpdatePawnDesiredRotation();
	}
}

state Targeting extends PlayerWalking
{
	function bool IsViewLockedToTarget() 
	{ 
		return TRUE;
	}
}

/** Returns TRUE if our current target is a stab mantle target that we can jump towards */
function bool CheckForStabMantle( Actor CheckActor, optional float DistScale = 1.f, optional bool bLogDebug )
{
	local NanoInterface_StabMantle NISM;
	local NanoSkill_Jump JumpSkill;
	local float Dist2D, TargetDistScale;

	// Check we have a NanoPawn, and they are not already dash-attacking
	JumpSkill = MyNP.GetSkill(class'NanoSkill_Jump');
	NISM = NanoInterface_StabMantle(CheckActor);
	if(  NISM != None  
		&& MyNP != None  
		&& NISM.IsValidStabMantleTarget() == TRUE
		&& !MyNP.bIsDoingStabMantle 
		&& !MyNP.bIsDoingCarHop
		&&!MyNP.bStabMantling
		&&!MyNP.bIsPlatformJumping
		&&(MyNP.Physics == PHYS_Falling || NanoPawn_MetaCorp_BullRamBase(TargetedActor) != None) 
		)
	{
		Dist2D = VSize2D(CheckActor.Location - MyNP.Location);

		TargetDistScale = NISM.GetTargetDistanceScaling();
	
		// make sure the target is close enough and below'ish us
		if( Dist2D < MyNP.StabDashMaxDist * DistScale * TargetDistScale )
		{
			if( (MyNP.Location.Z + (JumpSkill.GetMaxStabMantleHeight(MyNP)* DistScale*TargetDistScale)) > CheckActor.Location.Z || 
				NanoPawn_MetaCorp_BullRamBase(TargetedActor) != None )
			{
				return TRUE;
			}
		}
	}

	if( bLogDebug && MyNP.Physics == PHYS_Falling )
	{
		`log( `location@"FAILED"@`showvar(CheckActor)@`showvar(MyNP.Physics)@`showvar(Dist2D)@`showvar(MyNP.StabDashMaxDist));
		`log( "Z/S/A"@MyNP.Location.Z@JumpSkill.GetMaxStabMantleHeight(MyNP)@MyNP.Location.Z+JumpSkill.GetMaxStabMantleHeight(MyNP)@CheckActor.Location.Z );
		ConsoleCommand("Pause");
	}
	
	return FALSE;
}

/** Returns TRUE if the test actor is a valid candidate for lockon */
final function bool IsValidLockOnTarget(Actor TestActor, bool bDashRange)
{
	local float MeleeLockOnDistance;
	local NanoInterface_Targetable NTI;

	if(bDashRange)
	{
		MeleeLockOnDistance = DashAttackRange;
	}
	else
	{
		MeleeLockOnDistance = SwordLockOnDistance;
	}

	NTI = NanoInterface_Targetable(TestActor);
	return (NTI != None && 
			NTI.IsTargetable() && 
			Pawn != None && 
			(VSize2D(TestActor.Location - Pawn.Location) < MeleeLockOnDistance));
}

final function float GetIdealLockonDistance()
{
	local float IdealDist, R, H;

	if( TargetedActor != None )
	{
		TargetedActor.GetBoundingCylinder( R, H );
		IdealDist = R + MyNP.GetCollisionRadius() + SwordLockOnIdealDistanceBuffer;
	}
	return IdealDist;
}

delegate float RateTarget( Actor A, const out vector CamLoc, const out rotator CamRot, float MaxRange, float MinFOV )
{
	return -1.f;
}

function LockedOnTargetedActor( bool bLock )
{
	//when AI takes hit need to call AI.EngageMeleeWith
}

function TryToHopToNewCar()
{
	if( MyNP.IsAttachedToPerch() && (NanoVehicle_ElevatorBase(MyNP.Base) == None) && (NanoVehicleAgent(TargetedActor) != None) )
	{
		MyNP.AttemptHopToCar();
	}
}

function SpawnDefaultHUD()
{
	if ( LocalPlayer(Player) == None )
		return;

	MyNanoHUD = Spawn(class'NanoHUD_Base',self);
	MyHud = MyNanoHUD;
}

reliable client function ClientSetHUD(class<HUD> newHUDType)
{
	Super.ClientSetHUD(newHUDType);

	MyNanoHud = NanoHUD_Base(MyHud);
}

event InitInputSystem()
{
	local bool bPushInputObject;
	local LocalPlayer LP;

	if ( PlayerInput == None )
	{
		bPushInputObject = true;
	}

	Super.InitInputSystem();

	LP = LocalPlayer(Player);

	// Push the newly created playerinput onto the player input stack if there wasn't one already.
	if ( bPushInputObject )
	{
		MainPlayerInput = NanoPlayerInput_Base(PlayerInput);
		MainPlayerInput.OnInputObjectCreate();
		PushPlayerInput( PlayerInput );
		MainPlayerInput.ClearInputBuffer( GB_Max );
		MainPlayerInput.FilterInputBuffer( GB_Max, FALSE );
	}

	// reset the post processing when we get a new PC
	LP.RemoveAllPostProcessingChains();
	LP.InsertPostProcessingChain(LP.Outer.GetWorldPostProcessChain(), INDEX_NONE, true);

}

simulated function NanoPRI GetPRI()
{
	return NanoPRI(PlayerReplicationInfo);
}

/** Pushes a player input object to the stack and sets the current player input to be that new object. */
final function PushPlayerInput( PlayerInput NewPlayerInput )
{
	local NanoPlayerInput_Base PrevInputObject;
	local int InteractionIdx;

	if ( NewPlayerInput != None )
	{
		if ( PlayerInputStack.length > 0 )
		{
			PrevInputObject = NanoPlayerInput_Base(PlayerInputStack[PlayerInputStack.length-1]);
		}

		// Add the new input
		PlayerInputStack.AddItem( NewPlayerInput );

		// Set the current input object to the new one
		InteractionIdx = Interactions.Find(PlayerInput);
		PlayerInput = NewPlayerInput;
		if ( InteractionIdx == INDEX_NONE )
		{
			Interactions[Interactions.Length] = PlayerInput;
		}
		else
		{
			Interactions[InteractionIdx] = PlayerInput;
		}

		// Call the function that allows the new input object to perform any needed tasks when getting pushed to the top of the stack.
		NanoPlayerInput_Base(PlayerInput).PushedOnTopOfInputStack( PrevInputObject, false );

		// If there was already an input object on the stack call the function that lets it handle
		// it's being pushed back from the front of the stack.
		if ( PrevInputObject != None )
		{
			PrevInputObject.PushedBackOnInputStack();
		}
	}

	UpdateControllerConfig();
}


/** Pops a player input object from the stack and sets the current player input to be the next input object in the stack. */
final function PopPlayerInput( optional PlayerInput PlayerInputToPop )
{
	local NanoPlayerInput_Base PrevInputObject;
	local int IndexToRemove, InteractionIdx;
	local bool bRemovedCurrentInputHandler;

	if (  PlayerInputStack.length > 0 )
	{
		// Find the index to remove
		IndexToRemove = (PlayerInputToPop != None) ? PlayerInputStack.Find(PlayerInputToPop) : PlayerInputStack.length-1;

		// Could not find the input to remove so bail
		if ( IndexToRemove == INDEX_NONE )
		{
			return;
		}

		// Set the input object to be removed
		PrevInputObject = NanoPlayerInput_Base(PlayerInputStack[IndexToRemove]);

		// Determine if the input object to be removed is the currently active input handler
		bRemovedCurrentInputHandler = (PlayerInput == PrevInputObject) ? true : false;

		// Remove it
		PlayerInputStack.RemoveItem( PrevInputObject );
	}

	// If the input handler that got removed was active, to some cleanup
	if ( bRemovedCurrentInputHandler )
	{
		if ( PlayerInputStack.length > 0 )
		{
			// Set the input object to be the last in the list
			InteractionIdx = Interactions.Find(PlayerInput);
			PlayerInput = PlayerInputStack[PlayerInputStack.length-1];
			if ( InteractionIdx == INDEX_NONE )
			{
				Interactions[Interactions.Length] = PlayerInput;
			}
			else
			{
				Interactions[InteractionIdx] = PlayerInput;
			}

			// Call the function that will allow the old input object to perform any needed tasks now that it's becoming the front of the list.
			NanoPlayerInput_Base(PlayerInput).PoppedToTopOfInputStack( PrevInputObject, false );
		}

		// Let the input object that is being popped off of the stack to perform any needed tasks if it was active
		if ( PrevInputObject != None )
		{
			PrevInputObject.PoppedOffOfInputStack();
		}
	}

	UpdateControllerConfig();
}


/**
* This will set the bindings array with the updated key/value pair for the various controllers configs
* we support.
*
* @todo:  when updating this look at the UTConsolePlayerController  LoadSettingsFromProfile
**/
function UpdateControllerConfig()
{
// 	UpdateControllerSettings_Worker( 'XboxTypeS_LeftX', "GBA_Strafe" );
// 	UpdateControllerSettings_Worker( 'XboxTypeS_LeftY', "GBA_Movement" );
// 	UpdateControllerSettings_Worker( 'XboxTypeS_RightX', "GBA_LookX" );
// 	UpdateControllerSettings_Worker( 'XboxTypeS_RightY', "GBA_LookY" );
// 	UpdateControllerSettings_Worker( 'XboxTypeS_LeftThumbstick', "GBA_Crouch" );
// 	UpdateControllerSettings_Worker( 'XboxTypeS_RightThumbstick', "GBA_Zoom" );
//
// 	UpdateControllerSettings_Worker( 'XboxTypeS_LeftTrigger', "GBA_Target" );
// 	UpdateControllerSettings_Worker( 'XboxTypeS_RightTrigger', "GBA_Shoot" );
//
// 	UpdateControllerSettings_Worker( 'XboxTypeS_LeftShoulder', "GBA_Taccom" );
// 	UpdateControllerSettings_Worker( 'XboxTypeS_RightShoulder', "GBA_Reload" );

}

private function UpdateControllerSettings_Worker( name TheName, string TheCommand )
{
	local int BindIndex;

	for( BindIndex = 0;BindIndex < PlayerInput.Bindings.Length; ++BindIndex )
	{
		if( PlayerInput.Bindings[BindIndex].Name == TheName )
		{
			PlayerInput.Bindings[BindIndex].Command = TheCommand;
		}
	}
}

function RemapControlsByRotation( Rotator DeltaRot, out float NewRight, out float NewUp )
{
	local Vector	Controls, NewControls;

	Controls.X	= PlayerInput.RawJoyRight;
	Controls.Y	= PlayerInput.RawJoyUp;

	// don't do anything if controls are blank
	if( IsZero(Controls) )
	{
		NewRight	= 0.f;
		NewUp		= 0.f;
		return;
	}

	// rotate by DeltaRot
	DeltaRot.Pitch = 0;
	//@note we can't normalize here since that will delete any -1.f < x < 0 < x < 1.f values
	//NewControls = Normal(Controls >> DeltaRot);
	NewControls = Controls >> DeltaRot;

	NewRight	= NewControls.X;
	NewUp		= NewControls.Y;
	//`log( "Controls:" $ Controls @ "NewControls:" $ NewControls );
}

function InterpViewRotation( Rotator DesiredRot, float InterpTime )
{
	local GamePlayerCamera					Cam;
	local NanoThirdPersonCamera				TPC;

	Cam = GamePlayerCamera(PlayerCamera);
	if( Cam != None )
	{
		TPC = NanoThirdPersonCamera(Cam.CurrentCamera);
		if( TPC != None )
		{
			TPC.InterpToRot(DesiredRot, InterpTime);
		}
	}

	MyNP.UpdateAirControl();
}

function LevelViewRotation(float InterpTime)
{
	local vector CamLoc;
	local rotator CamRot;

	GetPlayerViewPoint(CamLoc, CamRot);

	CamRot.Pitch = 0;

	InterpViewRotation(CamRot, InterpTime);
}

function bool ShouldIgnorePlayerViewRotationInput()
{
	local GamePlayerCamera					Cam;
	local NanoThirdPersonCamera				TPC;
	local Cam3p_Melee						MeleeCam;

	Cam = GamePlayerCamera(PlayerCamera);
	if( Cam != None )
	{
		TPC = NanoThirdPersonCamera(Cam.CurrentCamera);
		if( TPC != None )
		{
			MeleeCam = Cam3p_Melee(TPC.CurrentCamMode);
			if( MeleeCam != None && MeleeCam.bInterpRotByTime )
			{
				return TRUE;
			}
		}
	}

	if( MyNP != None && (MyNP.MantleState != MANTLE_None && MyNP.MantleState != MANTLE_Jump) )
	{
		return TRUE;
	}

	if(	GetActivelyJuggledActor() != None )
	{
		//`log(`location@"juggling");
		return TRUE;
	}
	if( IsViewLockedToTarget() )
	{
		//`log(`location@"target lock");
		return TRUE;
	}

	return FALSE;
}

function bool ShouldUpdatePawnDesiredRotation()
{
	// if we ahve the gun out we want to update the pawn's desired rotation
	if( NanoWeap_MP7(MyNP.Weapon) != None )
	{
		return TRUE;
	}

	if( MyNP == None || MyNP.bIsDoingAttack || MyNP.bStabMantling || MyNP.Physics == PHYS_Flying || MyNP.bIsPlatformJumping )
	{
		return FALSE;
	}

	if( MyNP.Physics == PHYS_Falling )
	{
		return FALSE;
	}

	if( MyNP.ActiveSpecialMove != None && !MyNP.ActiveSpecialMove.bUpdatePlayerDesiredRotation )
	{
		return FALSE;
	}

	if( MyNP.InteractionPawn != None )
	{
		if( MyNP.InteractionType != PAWNINTER_Tackle )
		{
			return FALSE;
		}
	}


	if( MyNP.SplineBase != None )
	{
		return FALSE;
	}
	
	if( MyNP.InFreeCam() )
	{
		return FALSE;
	}

	return TRUE;
}


function UpdatePawnDesiredRotation()
{
	local GamePlayerCamera		Cam;
	local Rotator				DesiredRot, CamRot;
	local Vector                Dir;

	if( ShouldUpdatePawnDesiredRotation() )
	{
		Cam = GamePlayerCamera(PlayerCamera);
		CamRot = Cam.Rotation;

		if( MyNP.CurrentLadder != None )
		{
			if( MyNP.bClimbingUp )
			{
				MyNP.SetDesiredRotation( MyNP.CurrentLadder.Rotation + rot(0,32768,0) );
			}
			else
			{
				MyNP.SetDesiredRotation( MyNP.CurrentLadder.Rotation );
			}
		}
		// should be able to use this to look where we are pointing the right thumbstick
		else if( NanoWeap_MP7(MyNP.Weapon) != None )
		{
			NanoWeap_MP7(MyNP.Weapon).GetAimRotation(CamRot);

			MyNP.SetDesiredRotation( CamRot,,,, FALSE );
		}
		else if( ( !bCameraLookFaceTarget && Cam != None ) )
		{
			Dir.X = PlayerInput.RawJoyUp;
			Dir.Y = PlayerInput.RawJoyRight;

			CamRot = Normalize(CamRot);

			Dir = Dir >> CamRot;
			if( !IsZero(Dir) )
			{
				DesiredRot.Yaw = Rotator(Dir).Yaw;
				MyNP.SetDesiredRotation( DesiredRot,,,, FALSE );
			}
		}
		else
		{
			DesiredRot.Yaw = Rotation.Yaw;
			MyNP.SetDesiredRotation( DesiredRot,,,, FALSE );
		}
	}
}


function UpdateRotation( float DeltaTime )
{
	local Rotator DeltaRot, newRotation, ViewRotation;
	local GameThirdPersonCamera Cam3p;

`if(`notdefined(FINAL_RELEASE))
	if (bCheatFlying)
	{
		DeltaRot.Yaw	= PlayerInput.aTurn;
		DeltaRot.Pitch	= PlayerInput.aLookUp;
		SetRotation(Rotation + DeltaRot);
		Pawn.SetRotation(Rotation);
		return;
	}
`endif

	ViewRotation = Rotation;
	
	Cam3p = NanoPlayerCamera(PlayerCamera).Cam_3p;

	// if the camera look target or the POI wants us to face it, adjust here
	if( bCameraLookFaceTarget || (bLookingAtPointOfInterest && IsHoldingPOIButton(TRUE)) )
	{
		if ( bCameraLookFaceTarget || PlayerInput.aForward != 0.f || PlayerInput.aStrafe != 0.f )
		{
			DeltaRot.Yaw = Cam3p.LastYawAdjustment;
			DeltaRot.Pitch = Cam3p.LastPitchAdjustment;
		}
	}
	else
	{
		if( ViewRotationInterpTimer > 0.f )
		{
			ViewRotationInterpTimer = FMax( ViewRotationInterpTimer - DeltaTime, 0.f );
			NewRotation = RLerp( OrigViewRotation, DesiredViewRotation, 1.f - (ViewRotationInterpTimer/ViewRotationInterpDuration), TRUE );
			DeltaRot = newRotation - ViewRotation;

			if( ViewRotationInterpTimer <= 0.f )
			{
				MyNP.UpdateAirControl();
			}
		}
		else
		{
			if( !ShouldIgnorePlayerViewRotationInput() ) 
			{
				// Calculate Delta to be applied on ViewRotation
				DeltaRot.Yaw	= PlayerInput.aTurn;
				DeltaRot.Pitch	= PlayerInput.aLookUp;

				if( DeltaRot.Yaw != 0 || DeltaRot.Pitch != 0 )
				{
					LastPlayerViewInputTime = WorldInfo.TimeSeconds;
				}
			}
		}
	}
	
	// Apply adhesion
	if ( bTargetAdhesionEnabled && Pawn != None && Pawn.Physics == PHYS_Walking && (VSize2D(Pawn.Velocity) > 0 || abs(PlayerInput.RawJoyLookUp) > 0.f || abs(PlayerInput.RawJoyLookRight) > 0.f))
	{
		NanoPlayerInput_Base(PlayerInput).ApplyTargetAdhesion( DeltaTime, NanoWeapon(Pawn.Weapon), DeltaRot.Yaw, DeltaRot.Pitch ); // UT3
	}

	ProcessViewRotation( DeltaTime, ViewRotation, DeltaRot );
	Cam3p.AdjustFocusPointInterpolation(DeltaRot);			// adjust for focus points

	LastDeltaRot = DeltaRot;

	ViewRotation = Normalize(ViewRotation);     // keep within sane boundaries
	SetRotation(ViewRotation);

	ViewShake( deltaTime );
}

simulated function ResetPlayerView( optional float Duration = -1.f )
{
	local int YawDiff;

	if( MyNP != None )
	{
		if( Duration < 0.f )
		{
			YawDiff = MyNP.DesiredRotation.Yaw - Rotation.Yaw;
			Duration = YawDiff / 16384.f;
		}

		InterpViewRotation( MyNP.DesiredRotation, Duration );
	}
}

state Dead
{
	event BeginState(Name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);
		Camera('ThirdPerson');
	}
}

/** Returns TRUE if we either have the weapon in our hand, or the moon is out flying */
simulated function bool IsRicochetMoonActive()
{
	//local NanoPawn NP;
	//NP = NanoPawn(Pawn);

	//CONTENTMOVEBROKE
// 	if( (NP != None) && ((NanoWeap_RicochetMoonHook(NP.MyNanoWeapon) != None) || (ThrownHook != None)) )
// 	{
// 		return TRUE;
// 	}

	//CONTENTMOVEBROKE
// 	if( (NP != None) && ((NanoWeap_RicochetMoon(NP.MyNanoWeapon) != None) || (ThrownMoon != None)) )
// 	{
// 		return TRUE;
// 	}

	return FALSE;
	
}


/** Returns TRUE if we either have the weapon in our hand. */
simulated function bool IsOrbitalsActive()
{
	local NanoPawn NP;
	NP = NanoPawn(Pawn);

	if( (NP != None) && ((NanoWeap_Orbitals_Base(NP.MyNanoWeapon) != None) ) )
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}


/** Called to add targets to moon target list */
simulated function UpdateRicochetMoonTargets()
{
	local Actor HitActor;
	local Vector CamLoc;
	local Rotator CamRot;

	GetActorEyesViewPoint(CamLoc,CamRot);

	HitActor = SelectTarget_Worker( StandardRateTarget, 4096.f, 0.3f, CamLoc, CamRot );

	if( HitActor != None &&
		NanoInterface_Targetable(HitActor) != None &&
		RicochetMoonTargets.Find( HitActor ) == INDEX_NONE )
	{
		//CONTENTMOVEBROKE
		//if( NanoWeap_RicochetMoonHook(MyNP.Weapon) != None || ThrownHook != None )
		//{
		//	if( NanoVehicleAgent(HitActor) != None )
		//	{
		//		// do nothing
		//	}
		//	else
		//	{
		//		RicochetMoonTargets.Length = 0;
		//		RicochetMoonTargets.AddItem( HitActor );
		//	}			
		//}
		//else
		//{
			// we don't to auto add cars as they are not a valid target
			if( ( ThrownMoon != none ) && ( NanoVehicleAgent(HitActor) != none ) )
			{
				// do nothing
			}
			else
			{
				//`log( "UpdateRicochetMoonTargets adding: " @ HitActor ); 
				RicochetMoonTargets.AddItem( HitActor );
			}
		//}
	}
}

event PlayerTick( float DeltaTime )
{
	local int Idx;
	local Actor CamViewTarget;

	local vector CamLoc;
	local rotator CamRot;
	local vector HitL, HitN;
	local Actor HitA;
	//local TraceHitInfo HitInfo;


	Super.PlayerTick(DeltaTime);

	if( MyNP == None )
	{
		return;
	}

	// Update joy idle time if player is not giving input on left thumbstick 
	if( Abs(PlayerInput.RawJoyUp) <= 0.2f && Abs(PlayerInput.RawJoyRight) <= 0.2f )
	{
		LastRawJoyIdleInputTime = WorldInfo.TimeSeconds;
	}

	bLockedOnTargetedActor = IsButtonPressed(GB_LeftTrigger,TRUE);
	MyNP.bLockedOnTarget = bLockedOnTargetedActor;


	// Clean up recently targeted actors buffer 
	for( Idx = 0; Idx < RecentTargetedActorList.Length; Idx++ )
	{
		if( `TimeSince( RecentTargetedActorList[Idx].Rating ) > RecentTargetedActorBufferTime )
		{
			RecentTargetedActorList.Remove( Idx--, 1 );
		}
	}
	Idx = RecentTargetedActorList.Find( 'Target', TargetedActor );
	if( Idx >= 0 )
	{
		RecentTargetedActorList.Remove( Idx--, 1 );
	}


	// Special handling for multi-targeting for moon
	if( IsRicochetMoonActive() )
	{
		UpdateRicochetMoonTargets();
	}

	// don't update target while dashing at it
	if( ( (MyNP.bIsSwordDashing || MyNP.bIsDoingAttack || MyNP.bIsDoingCarHop) )
		)
	{
		// nothing
	}
	// or if we have a gun.  The gun is doing it's own specialized target picking
	// this need to be changed into the "handleinput" style function where the object tells us
	// if it "ate" the input
	else if( ( NanoWeap_MP7(MyNP.Weapon) != None ) && ( MyNP.bIsTargeting == FALSE ) )
	{
		//NanoWeap_MP7(MyNP.Weapon).TryToPickTarget( MyNP );
	}
	else if( ( NanoWeap_MP7(MyNP.Weapon) != None ) && ( MyNP.bIsTargeting == TRUE ) )
	{
		MyNP.GetActorEyesViewPoint(CamLoc,CamRot);

		// trace should be a lot smarter
		// maybe trace out and then do for all pawns nearby, do dist to line segment
		// and then choose the closest?
		// do we want to force move the aiming location?
		// if we do move the aiming location, then do you stay locked on it?
		HitA = MyNP.Trace(HitL,HitN,CamLoc+vector(CamRot)*MaxTargetableDistance,CamLoc,TRUE,vect(1,1,1),,TRACEFLAG_Bullet);

				//FlushPersistentDebugLines();
		//DrawDebugLine(CamLoc,CamLoc + vector(CamRot) * MaxTargetableDistance,0,0,255,TRUE);

		if( ( NanoInterface_Targetable(HitA) != None ) && ( NanoInterface_Targetable(HitA).IsTargetable() == TRUE ) )
		{
		
			SetTargetedActor( HitA );

			// trace out for hitting skel mesh
// 			MyNP.Trace(HitL,HitN,CamLoc+vector(CamRot)*MaxTargetableDistance,CamLoc,TRUE,,HitInfo,TRACEFLAG_Bullet);
// 			//`log("we hit a NTI" @ `showvar(HitA) @ `showvar(HitInfo.HitComponent) );
// 
// 			// if we hit a skel mesh then don't set the guntarget as we want to shoot at a specific location (e.g. headshot)
// 			// if we didn't hit then we hit the cylinder and our aim is bad so set the auto aiming
// 			if( SkeletalMeshComponent(HitInfo.HitComponent) != None )
// 			{
// 				NanoWeap_MP7(MyNP.Weapon).GunTarget = None;
// 				MyNP.bForceAimAnim = FALSE; // this is setting a flag that the NanoWeap_MP7 GetAdjustedAimFor uses to determine if it should skip auto correcting the shots
// 			}
// 			else
// 			{
// 				NanoWeap_MP7(MyNP.Weapon).GunTarget = NanoInterface_Targetable(HitA);
// 				MyNP.bForceAimAnim = TRUE; // this is setting a flag that the NanoWeap_MP7 GetAdjustedAimFor uses to determine if it should skip auto correcting the shots
// 			}
		}
		else
		{
			SetTargetedActor( None );
			NanoWeap_MP7(MyNP.Weapon).GunTarget = None;
			MyNP.bForceAimAnim = FALSE; // this is setting a flag that the NanoWeap_MP7 GetAdjustedAimFor uses to determine if it should skip auto correcting the shots
		}
	}
	// Auto-update target
	else 
	{
		SelectTarget(StandardRateTarget,MaxTargetableDistance,,FALSE);
	}

	// Update grapple target (todo:  might need to amortize this, but since targeting does this every tick, we might as well too, since this is more light weight)

	if( MyNP.CanDoSpecialMove('NSM_Grapple') )
	{
		SelectGrappleTarget();
	}
	else if( GrappleTarget != None )
	{
		SetGrappleTarget(None);
	}

	// make sure to update IsInCombat
	IsInCombat();

	DoJuggling();

	// update the view target's rotation, if needed by the mission briefing
	if( bUpdateViewTargetToFocus )
	{
		CamViewTarget = CameraActor(GetViewTarget());
		if( (CamViewTarget != None) && (Focus != None) )
		{
			// Face the focus with the camera actor
 			CamViewTarget.SetRotation(rotator(Focus.Location - CamViewTarget.Location));
		}
		else
		{
			// Something failed...stop trying to update the camera
			bUpdateViewTargetToFocus = FALSE;

			if( CamViewTarget != None )
			{
				CamViewTarget.SetRotation(BriefingCameraOriginalRotation);
			}
		}
	}

	ModifyVelocityBasedOnCrowdInteraction();

	TickResponseSystemSoundSystem();

	UpdatebIsHiddenByCrowd();

}


function ModifyVelocityBasedOnCrowdInteraction()
{
	if( CrowdTraversalSpeed_TimeToAllowFullSpeed > WorldInfo.TimeSeconds )
	{
		//`log( `showvar(Normal(Pawn.Velocity)) );


		if( bCrowdTraversalSpeed_FromWalking == TRUE )
		{
			Pawn.Velocity = Normal(Pawn.Velocity) * CrowdTraversalSpeed_FromWalking;
		}
		else if( bCrowdTraversalSpeed_FromJogging == TRUE )
		{
			Pawn.Velocity = Normal(Pawn.Velocity) * CrowdTraversalSpeed_FromJogging;
		}
		else if( bCrowdTraversalSpeed_FromRunning == TRUE )
		{
			Pawn.Velocity = Normal(Pawn.Velocity) * CrowdTraversalSpeed_FromRunning;
		}

		//`log( `showvar(VSize2D(Pawn.Velocity)) );
	}
	else
	{
		bCrowdTraversalSpeed_FromRunning = FALSE;
		bCrowdTraversalSpeed_FromJogging = FALSE;
		bCrowdTraversalSpeed_FromWalking = FALSE;
	}
}


function SpecialMove_FocusCameraOnPawn()
{
	SetFocusPoint(FALSE,MyNP,vect2d(6.f, 6.f),vect2d(1.f, 1.f),85.f,TRUE,TRUE,FALSE,'b_MF_Head',FALSE);
	bCameraLookAtIsFromSpecialMove = TRUE;
}

function SpecialMove_ClearCameraFocus()
{
	ClearFocusPoint(FALSE, FALSE);
	bCameraLookAtIsFromSpecialMove = FALSE;
}

/** We do juggling in the playertick to allow us time to actually move the stick instead of having to have it moved when the actual shot hits **/
simulated function DoJuggling()
{
	if( bDidJuggle == FALSE && MyNP != none && GetActivelyJuggledActor() != none )
	{
	    MyNP.LastCausedJuggleActor.ResolveJuggleVars( self, JuggleMag, JuggleZ, JuggleDir, FALSE );
	    MyNP.LastCausedJuggleActor.ApplyJuggle( JuggleMag, JuggleZ, JuggleDir, MyNP, TRUE );
		bDidJuggle = TRUE;
	}
}

final simulated function SetTargetedActor(Actor NewTargetedActor)
{
	local int Idx;

	//ScriptTrace();
	//`log( `showvar(NewTargetedActor) );

	// Safety check - should not target things that don't implement the interface
	if(NewTargetedActor != None && (NanoInterface_Targetable(NewTargetedActor) == None || !NanoInterface_Targetable(NewTargetedActor).IsTargetable()))
	{
		`log("SetTargetedActor:"@NewTargetedActor@"does not implement NanoInterface_Targetable or isn't targetable!!");
		//ScriptTrace();
		return;
	}

	if( NewTargetedActor != TargetedActor )
	{
		if( TargetedActor != None )
		{
			Idx = RecentTargetedActorList.Find( 'Target', TargetedActor );
			if( Idx < 0 )
			{
				Idx = RecentTargetedActorList.Length;
				RecentTargetedActorList.Length = RecentTargetedActorList.Length + 1;
			}
			RecentTargetedActorList[Idx].Target = TargetedActor;
			RecentTargetedActorList[Idx].Rating = WorldInfo.TimeSeconds;

			RecentTargetedActorList.Sort(ReverseTargetSort);
		}

		ClearTimer(nameof(SelectTarget));
		//`log( "Oh snap! Setting TargetedActor" @ `showvar(TargetedActor) );
		TargetedActor = NewTargetedActor;

		if (Role < ROLE_Authority)
		{
			ServerSetTargetedActor(TargetedActor);
		}
	}
}

reliable server function ServerSetTargetedActor(Actor NewTargetedActor)
{
	TargetedActor = NewTargetedActor;
}

simulated function bool ForceSelectTarget( optional delegate<RateTarget> TargetEval, optional float MaxRange, optional float MinFOV = 0.3f, optional bool bUseStickDir, optional bool bUsePawnRotWithInput )
{
	return Global.SelectTarget( TargetEval, MaxRange, MinFOV, bUseStickDir, bUsePawnRotWithInput );
}

/** Attempts to select a new targeted actor, returns TRUE if a new target was found */
final simulated function bool SelectTarget(optional delegate<RateTarget> TargetEval, optional float MaxRange, optional float MinFOV = 0.3f, optional bool bUseStickDir, optional bool bUsePawnRotWithInput )
{
	local Actor Best;
	local vector CamLoc, HitL, HitN;
	local rotator CamRot;

	if( Pawn == none )
	{
		return FALSE;
	}

	if( bLockedOnTargetedActor )
	{
		return FALSE;
	}

	if (TargetEval == None)
	{
		TargetEval = StandardRateTarget;
	}

	if (MaxRange <= 0.f)
	{
		if (MyNP != None && MyNP.bIsSwordActive)
		{
			MaxRange = 1024.f;
		}
		else
		{
			MaxRange = MaxTargetableDistance;
		}
	}

	GetActorEyesViewPoint(CamLoc,CamRot);
	if( bUseStickDir )
	{
		CamRot = GetDirFromLeftStick( CamRot, bUsePawnRotWithInput );
	}

	Best = SelectTarget_Worker( TargetEval, MaxRange, MinFOV, CamLoc, CamRot );

	//`log(`location @ `showvar(TargetedActor) @ `showvar(Best) );

	// If we did not select anything, do a straight trace
	if( (Best == None) )
	{
		Best = Pawn.Trace(HitL, HitN, CamLoc + vector(CamRot) * MaxTargetableDistance, CamLoc, TRUE);
		// Don't target if it doesn't implement interface, or if it doesn't want to be targetable
		if(NanoInterface_Targetable(Best) == None || !NanoInterface_Targetable(Best).IsTargetable())
		{
			Best = None;
		}

		// so since we do another trace above we have to make certain that we didn't just trace against a dead pawn
		// if we did then we want to set the actor we have target to none so it clears the targeting
		if( (Pawn(Best) != None && Pawn(Best).Health <= 0) || Best == None )
		{
			SetTargetedActor(None);
			return TRUE;
		}
	}

	if( Best != None )
	{
		SetTargetedActor(Best);
		return TRUE;
	}

	return FALSE;
}

delegate int TargetSort(TargetSortInfo A, TargetSortInfo B)
{
	// bigger is better!
	return (A.Rating < B.Rating ? -1 : 0);
}
delegate int ReverseTargetSort(TargetSortInfo A, TargetSortInfo B)
{
	// smaller is better!
	return (A.Rating > B.Rating ? -1 : 0);
}


simulated function Rotator GetDirFromLeftStick( Rotator BaseRot, optional bool bUsePawnRotWithInput )
{
	local Vector X, Y, Z;
	if( Abs(RemappedJoyUp) > 0.3f || Abs(RemappedJoyRight) > 0.3f )
	{
		GetAxes(BaseRot,X,Y,Z);
		BaseRot = rotator(X * RemappedJoyUp + Y * RemappedJoyRight);
	}
	else if( bUsePawnRotWithInput )
	{
		return MyNP.DesiredRotation;
	}
	return BaseRot;
}

/** This will find the best target based on the set of TargetableActors and the passed in eval function. **/
final simulated function Actor SelectTarget_Worker( delegate<RateTarget> TargetEval, float MaxRange, float MinFOV, const out Vector CamLoc, const out Rotator CamRot )
{
	local Actor A;
	local array<TargetSortInfo> PotentialTargets;
	local TargetSortInfo NewTarget;
	//local NanoGRI GRI;
	local NanoInterface_Targetable NTI;
	local float Dist;
	local float BestRating;

	local array<Actor> TargetableWithinMaxRange;

	local int MyTeamNum;

	MyTeamNum = GetTeamNum();

	//GRI = NanoGRI(WorldInfo.GRI);

	//FlushPersistentDebugLines();
	//DrawDebugLine(CamLoc,CamLoc + vector(CamRot) * MaxRange,0,0,255,TRUE);

	// PAIN!!!!!!
	// targetable actors can be collided with / shot.  So we should be able to do an Octree test to get the actors around us
	// and then foreach over them instead of every single one in the entire level
	// double pain:  need to have our own TargetableActors octree!

	TargetableWithinMaxRange = NanoGRI(WorldInfo.GRI).FindAllNanoInterface_TargetableAroundPlayerPawn( MyNP, MaxRange );

	//`log( `showvar(TargetableWithinMaxRange.Length) @ `showvar(GRI.TargetableActors.Length) );

	//`log ("" );

	foreach TargetableWithinMaxRange(A)
	//foreach GRI.TargetableActors(A)
	{
		NTI = NanoInterface_Targetable(A);

		//`log( "SelectTarget_Worker" @ NTI @ A );

		if( NTI == None )
		{
			continue;
		}

		if( !NTI.ShouldIgnoreDistance() )
		{
			Dist = VSize(Pawn.Location - A.Location);
			if( Dist > MaxRange )
			{
				continue;
			}
		}

		// as we are doing this for hundreds of actors
		// do a quick rendertime and dist cull check here so we don't do extra line checking function calling which is slow
		if( !NTI.IsTargetable() )
		{
			//`log( "skipping " @ A @ "IsTargetable() is false" );
			continue; // skip this actor
		}

		// don't auto target friendlies!
		if( A.GetTeamNum() == MyTeamNum )
		{
			continue;
		}


		NewTarget.Target = A;
		NewTarget.Rating = TargetEval(A,CamLoc,CamRot,MaxRange,MinFOV);
		// check if the rating is higher than the highest already to avoid costly LineOfSightTo
		if( NewTarget.Rating > BestRating && LineOfSightTo(A) )
		{
			BestRating = NewTarget.Rating;
			PotentialTargets.AddItem(NewTarget);
		}
	}


	//`log( `showvar(PotentialTargets.Length) @ `showvar(BestRating) );

	if( PotentialTargets.Length > 0 )
	{
		//foreach PotentialTargets(NewTarget)
		//{
		//	`log( " " @ `showvar(NewTarget.Target) @ `showvar(NewTarget.Rating) );
		//}

		return PotentialTargets.Sort(TargetSort).Target;
	}

	return None;
}

final function float StandardRateTarget( Actor A, const out vector CamLoc, const out rotator CamRot, float MaxRange, float MinFOV )
{
	local float Priority, Weight;
	local float Dist, ViewDot, Pct;
	local NanoInterface_Targetable NTI;

	NTI = NanoInterface_Targetable(A);

	Weight = -1.f;
	if( NTI.IsTargetable() && NTI.ShouldRateTarget() )
	{
		Priority = NTI.GetBasePriority(self,NanoPawn(Pawn));
		if (Priority > 0.f )
		{
			ViewDot = Normal(A.Location - CamLoc) dot vector(CamRot);
			if( ViewDot > 0.3f )
			{
				Pct = FPctByRange( ViewDot, 0.3f, 1.f );
				Weight = Priority * Pct;
				Dist = VSize(A.Location - CamLoc);
				if( !NTI.ShouldIgnoreDistance() && (Dist < MaxRange) )
				{
					Weight *= (1.f - Dist/MaxRange);
				}
			}
		}
	}
//	`log(WorldInfo.TimeSeconds@`location@`showvar(A)@`showvar(Priority)@`showvar(Dist)@`showvar(ViewDot)@`TimeSince(A.LastRenderTime)@`showvar(Weight));
	return Weight;
}

final function float MeleeStickRateTarget( Actor A, const out vector CamLoc, const out rotator CamRot, float MaxRange, float MinFOV )
{
	local float Priority, Weight;
	local float Dist, ViewDot, Pct;
	local NanoInterface_Targetable NTI;

	NTI = NanoInterface_Targetable(A);

	Weight = -1.f;
	if( NTI.IsTargetable( TQT_MeleeAttack ) )
	{
		Priority = NTI.GetBasePriority(self,NanoPawn(Pawn));
		if (Priority > 0.f )
		{
			ViewDot = Normal(A.Location - CamLoc) dot vector(CamRot);
			if( ViewDot > MinFOV )
			{
				Dist = VSize(A.Location - CamLoc);
				if( NTI.ShouldIgnoreDistance() || (Dist < MaxRange) )
				{
					Pct = FPctByRange( ViewDot, -1.f, 1.f );
					Weight = Priority * Pct;
				}
			}

//			`log(WorldInfo.TimeSeconds@`location@`showvar(A)@`showvar(Priority)@`showvar(Dist)@`showvar(MaxRange)@`showvar(ViewDot)@`showvar(MinFOV)@`showvar(Pct)@`showvar(Weight), bDebug );
		}
	}

	return Weight;
}

final function float GunRateTarget( Actor A, const out vector CamLoc, const out rotator CamRot, float MaxRange, float MinFOV )
{
	local float Priority, Weight;
	local float Dist, ViewDot, Pct;
	local NanoInterface_Targetable NTI;

	NTI = NanoInterface_Targetable(A);

	Weight = -1.f;
	if( NTI.IsTargetable( TQT_GunAttack ) )
	{
		Priority = NTI.GetBasePriority(self,NanoPawn(Pawn));
		if (Priority > 0.f )
		{
			ViewDot = Normal(A.Location - CamLoc) dot vector(CamRot);
			//`log( `showvar(ViewDot) @ `showvar(MinFOV) );

			if( ViewDot > MinFOV )
			{
				Dist = VSize(A.Location - CamLoc);
				if( NTI.ShouldIgnoreDistance() || (Dist < MaxRange)  )
				{
					Pct = FPctByRange( ViewDot, -1.f, 1.f );
					Weight = Priority * Pct;
				}

				// avoid already stunned targets
				if (NanoPawn(A) != None && NanoPawn(A).bStunned)
				{
					Weight *= 0.5f;
				}
			}

//			`log(WorldInfo.TimeSeconds@`location@`showvar(A)@`showvar(Priority)@`showvar(Dist)@`showvar(MaxRange)@`showvar(ViewDot)@`showvar(MinFOV)@`showvar(Pct)@`showvar(Weight), bDebug );
		}
	}

	return Weight;
}

/** Looks for NanoPawn_MetaCorp_NanoInfantry  and targets them **/
final function float BullRamRateTarget( Actor A, const out vector CamLoc, const out rotator CamRot, float MaxRange, float MinFOV )
{
	local float Priority, Weight;
	local float Dist, ViewDot, PointDist;
	local vector CamCross, ClosestPt;
	local CylinderComponent CylComp;
	local NanoInterface_Targetable NTI;

	NTI = NanoInterface_Targetable(A);

	Weight = -1.f;
	if( NanoPawn_MetaCorp_NanoInfantry(A) != none && NTI.IsTargetable() )
	{
		Priority = NTI.GetBasePriority(self,NanoPawn(Pawn));
		if (Priority > 0.f && (WorldInfo.TimeSeconds - A.LastRenderTime) < 2.0f ) // if we have not seen this actor for 2 second then don't allow targeting of it
		{
			ViewDot = Normal(A.Location - CamLoc) dot vector(CamRot);
			if (ViewDot > MinFOV)
			{
				Weight = Priority * ViewDot;
				Dist = VSize(A.Location - CamLoc);
				if (Dist < MaxRange)
				{
					Weight += Priority * (1.f - Dist/MaxRange) * 0.5f;
					if (Dist <= MaxRange * 0.25)
					{
						Weight *= 1.25f;
					}
					// if dealing with a cylinder comp
					CylComp = CylinderComponent(A.CollisionComponent);
					if (CylComp != None)
					{
						// adjusted the location to the nearest edge of the cylinder
						CamCross = Normal(vector(CamRot) cross vect(0,0,1));
						if (CamCross dot (A.Location - CamLoc) > 0.f)
						{
							ClosestPt = A.Location - CamCross * CylComp.CollisionRadius;
						}
						else
						{
							ClosestPt = A.Location + CamCross * CylComp.CollisionRadius;
						}
					}
					else
					{
						ClosestPt = A.Location;
 					}
					PointDist = PointDistToLine(ClosestPt,vector(CamRot),CamLoc);
					//`log(`showvar(PointDist)@"orig"@PointDistToLine(A.Location,vector(CamRot),CamLoc));
					//`log(`showvar(MaxRange)@`showvar(Dist)@`showvar((MaxRange * 0.25f) * FMax(0.1,(Dist/MaxRange))));
					if (PointDist < (MaxRange * 0.25f) * FMax(0.25,(Dist/MaxRange)))
					{
						Weight *= 1.f - (PointDist/((MaxRange * 0.25f) * FMax(0.25,(Dist/MaxRange))));
					}
					else
					{
						Weight = -1.f;
					}
				}
				else
				{
					Weight = -1.f;
				}
			}
			else
			{
				Weight = -1.f;
			}
		}
	}
	//`log(WorldInfo.TimeSeconds@`location@`showvar(A)@`showvar(Priority)@`showvar(PointDist)@`showvar(Dist)@`showvar(ViewDot)@`TimeSince(A.LastRenderTime)@`showvar(Weight));
	return Weight;
}


final function float SnapSelectionRateTarget(Actor A, const out vector CamLoc, const out rotator CamRot, float MaxRange)
{
	local float Weight;
	local vector NewDir;
	Weight = -1.f;
	if( A != TargetedActor && NanoInterface_Targetable(A).IsTargetable() )
	{
		NewDir = Normal(A.Location - Pawn.Location);
		if (NewDir dot vector(CamRot) > 0.f)
		{
			Weight = 1.f - (VSize(TargetedActor.Location - A.Location)/MaxRange);
		}
		//`log(`location@`showvar(A)@`showvar(Weight));
	}
	return Weight;
}


final function float ChainedAttackRateTarget(Actor A, const out vector CamLoc, const out rotator CamRot, float MaxRange)
{
	local float Priority, Weight;
	local float Dist, ViewDot, PointDist;
	Weight = -1.f;
	Priority = NanoInterface_Targetable(A).GetBasePriority(self,NanoPawn(Pawn));
	if (Priority > 0.f)
	{
		ViewDot = Normal(A.Location - CamLoc) dot vector(CamRot);
		if (ViewDot > 0.f)
		{
			Weight = Priority * ViewDot;
			Dist = VSize(A.Location - CamLoc);
			if (Dist < MaxRange)
			{
				Weight += Priority * (1.f - Dist/MaxRange) * 0.5f;
				PointDist = PointDistToLine(A.Location,vector(CamRot),CamLoc);
				if (PointDist < MaxRange)
				{
					Weight *= 1.f - (PointDist/MaxRange);
				}
				else
				{
					Weight = -1.f;
				}
			}
			else
			{
				Weight = -1.f;
			}
		}
		else
		{
			Weight = -1.f;
		}
	}
	//`log(WorldInfo.TimeSeconds@`location@`showvar(A)@`showvar(Priority)@`showvar(PointDist)@`showvar(Dist)@`showvar(ViewDot));
	return Weight;
}

/** Grapple target selection */
simulated function SelectGrappleTarget()
{
	local Actor BestTarget, CurrentlyGrapplingActor, TestActor;
	local NanoInterface_Grapple GrappleTest;
	local float BestWeight, MaxDistance, Weight, ViewDot, Distance;
	local vector TestLocation;
	local Actor HitActor;
	local Vector HitLocation, HitNormal;
	
	// If we're currently grappling, cache the target we're currently going for so we don't select it again
	if( MyNP.ActiveSpecialMoveName == 'NSM_Grapple' )
	{
		CurrentlyGrapplingActor = NSM_Grapple(MyNP.ActiveSpecialMove).GrappleTarget;
	}

	// Cache the maximum distance squared that we should consider GrappleTargets in
	MaxDistance = square(class'NSM_Grapple'.default.MaxGrappleDistance);

	foreach NanoGRI(WorldInfo.GRI).GrappleActors(TestActor)
	{
		GrappleTest = NanoInterface_Grapple(TestActor);

		if( TestActor == None || GrappleTest == None )
		{
			// If the GrappleActor is outdated, remove it from the pool
			NanoGRI(WorldInfo.GRI).GrappleActors.RemoveItem(TestActor);
		}
		else if( GrappleTest.IsGrapplable() && TestActor != CurrentlyGrapplingActor )
		{
			// Test the grapple target's desired location
			TestLocation = GrappleTest.GetGrappleLocation(MyNP);
			if( GrappleTest.CanGrappleFromAbove() || Pawn.Location.Z < TestLocation.Z )
			{
				// Favor grapple points aligned with the pawn's current rotation
				ViewDot = Normal(TestLocation - Pawn.Location) dot vector(Pawn.Rotation);

				if( ViewDot > 0.f )
				{
					Weight = FPctByRange(ViewDot, 0.3f, 1.f);
					Distance = VSizeSq(TestLocation - Pawn.Location);

					// Check for distance within the sweet spot
					if( Distance <= MaxDistance )
					{
						HitActor = Pawn.Trace( HitLocation, HitNormal, TestLocation, Pawn.Location, TRUE, Pawn.GetCollisionExtent() * 1.1f );
						if( HitActor == None )
						{
							// Weight closer grapple targets higher
							Weight *= 1.f - Distance / MaxDistance;

							// Update the best grapple point, if needed
							if( (Weight >= BestWeight) || (BestTarget == None) )
							{
								BestTarget = TestActor;
								BestWeight = Weight;
							}
						}
					}
				}
			}
		}
	}

	// If we've updated, notify the pawn and the server
	if( BestTarget != GrappleTarget )
	{
		SetGrappleTarget(BestTarget);
	}
}

simulated function SetGrappleTarget( Actor NewTarget )
{
	if( WorldInfo.NetMode == NM_Client )
	{
		ServerSetGrappleTarget(NewTarget);
	}

	GrappleTarget = NewTarget;

	if( NewTarget != None )
	{
		MyNP.NotifyGrappleTarget();
	}
	else
	{
		MyNP.NotifyGrappleTargetInvalid();
	}
}

reliable server function ServerSetGrappleTarget( Actor NewTarget )
{
	GrappleTarget = NewTarget;
}


/** Handle action for putting a message up on the screen */
function OnNanoMessageWindow(SeqAct_NanoMessageWindow InAction)
{
	//SHOW
	if(InAction.InputLinks[0].bHasImpulse  == TRUE)
	{
		MyNanoHUD.MessageString1 = InAction.Message1;
		MyNanoHUD.MessageString2 = InAction.Message2;
		MyNanoHUD.MessageBoxOffset = InAction.MessageBoxOffset;

		if(InAction.MessageTime == 0.0)
		{
			MyNanoHUD.MessageEndTime = WorldInfo.TimeSeconds + 9999999.0;
		}
		else
		{
			MyNanoHUD.MessageEndTime = WorldInfo.TimeSeconds + InAction.MessageTime;
		}
	}
	// HIDE
	else if( InAction.InputLinks[1].bHasImpulse == TRUE )
	{
		MyNanoHUD.MessageEndTime = WorldInfo.TimeSeconds - 1.0;
	}
}

/** Helper to display the mission briefing dialog on the player's HUD */
simulated event SetMissionBriefingText(string Speaker, string DialogText, float TimeToDisplay)
{
	if( MyNanoHUD != None )
	{
		MyNanoHUD.SetMissionBriefingDialog(Speaker, DialogText, TimeToDisplay);
	}
}

simulated event ClearMissionBriefingText()
{
	if( MyNanoHUD != None )
	{
		MyNanoHUD.ClearMissionBriefingDialog();
	}
}

simulated event SetBriefingCameraLookAt(Actor NewCamTarget)
{
	local NanoPawnBase          MyNanoPawn;
	local SkelControlLookAt		HeadControl;
	local bool					bDoNoInterpolate;

	// If there is nothing to do, return!
	if( NewCamTarget == Focus )
	{
		return;
	}

	MyNanoPawn = NanoPawnBase(Pawn);

	Focus = NewCamTarget;

	// First, handle the case where the view is a camera (have to manually update the camera's rotation)
	if( CameraActor(GetViewTarget()) != None )
	{
		if( NewCamTarget != None )
		{
			// Set flag to cause the viewtarget's rotation to be updated in playertick()
			bUpdateViewTargetToFocus = TRUE;
			// Back up the original rotation so that it may be restored when we cut away from the camera
			BriefingCameraOriginalRotation = NewCamTarget.Rotation;
		}
		else
		{
			// If no actor is specified, clear the flag, and restore the original rotation
			bUpdateViewTargetToFocus = FALSE;
			GetViewTarget().SetRotation(BriefingCameraOriginalRotation);
		}

		return;
	}

	// Otherwise, handle camera look at for the pawn (including head control)
 	if( NewCamTarget != None )
 	{
 		// Set the focus, using default, hardcoded values
  		SetFocusPoint(
  			TRUE,
  			NewCamTarget,
  			vect2d(3.f, 3.f),
  			vect2d(1.f, 1.f),
  			-1.f,
  			false,      // always focus, maybe true?
  			false,
  			true,       // ignore trace, maybe false?
  			'b_MF_Head',
  			false);     // rotate player with camera
 	}
 	else
 	{
		// Clear the pawn's focus
 		ClearFocusPoint(TRUE, FALSE);
 	}
 	
 	// Turn on the head tracking for the pawn
 	HeadControl = MyNanoPawn.HeadTrackSkelControl;
 	if( HeadControl != None && (NewCamTarget != MyNanoPawn) )
 	{
 		// set for the first time, do not interpolate
 		// use interpolation for in between target transitions.
 		if( MyNanoPawn.HeadLookAtActor == None )
 		{
 			bDoNoInterpolate = TRUE;
 		}
 		MyNanoPawn.HeadLookAtActor = NewCamTarget;
 
 		if( MyNanoPawn.HeadLookAtActor != None )
 		{
 			MyNanoPawn.HeadLookAtBoneName = 'b_MF_Head';
 			HeadControl.DesiredTargetLocation = MyNanoPawn.GetHeadLookTargetLocation();
 			if( bDoNoInterpolate )
 			{
 				HeadControl.TargetLocation = HeadControl.DesiredTargetLocation;
 			}
 			HeadControl.SetSkelControlActive(TRUE);
 		}
 		else
 		{
 			HeadControl.SetSkelControlActive(FALSE);
 		}
 	}
}

/** Util that grabs memory used by different sorts of city resources*/
native function GetStreamingCityStats(out StreamingCityMemStats OutStats) const;

/** Console command for grabbing and printing mem stats for streaming city */
exec function StreamingCityStats()
{
	local StreamingCityMemStats Stats;
	
	GetStreamingCityStats(Stats);
	
	`log("--- StreamingCityMemStats ---");
	`log("LowLODStaticMeshes:"@(Stats.LowLODStaticMeshes/1024)@"KB");
	`log("LowLODTextures:"@(Stats.LowLODTextures/1024)@"KB");
	`log("HighLODStaticMeshes:"@(Stats.HighLODStaticMeshes/1024)@"KB");
	`log("HighLODTextures:"@(Stats.HighLODTextures/1024)@"KB");
	`log("PackageStaticMeshes:"@(Stats.PackageStaticMeshes/1024)@"KB");
	`log("PackageTextures:"@(Stats.PackageTextures/1024)@"KB");	
}

/** Util that decides if we are trying to run in a straight line, or if we are turning/strafing */
native function bool IsPushingStraightAhead(optional float Threshold = 0.2) const;

function UpStickFlick()
{
	MyNanoHUD.HUDFilterButtonInput('DPad_Up',TRUE,-1);
}

function DownStickFlick()
{
	MyNanoHUD.HUDFilterButtonInput('DPad_Down',TRUE,-1);
}

function RightStickFlick()
{
	MyNanoHUD.HUDFilterButtonInput('DPad_Right',TRUE,-1);
}

function LeftStickFlick()
{
	MyNanoHUD.HUDFilterButtonInput('DPad_Left',TRUE,-1);
}

/**	Hook to let player know a refresh of crowd agent info is coming */
event NotifyCrowdAgentRefresh()
{
	NearbyCrowdAgentList.Length = 0;
}

/** Hook to let player know crowd member is in range */
event NotifyCrowdAgentInRadius( GameCrowdAgent Agent )
{
	//local float VelSize;

	if( Pawn == None )
		return;
	
	//VelSize = VSize(Pawn.Velocity);
	//`log( `showvar(VelSize) @ Agent );
	//if( VelSize > 180.f )
	//{
		if( Agent.Health > 0 )
		{
			NearbyCrowdAgentList[NearbyCrowdAgentList.Length] = Agent;
		}
	//}
}

event PlayCrowdAgentPushReaction( GameCrowdAgent Agent, EDirection Dir )
{
	local NanoCrowd_PedestrianBase SkelAgent;
	local float PawnVel;

	SkelAgent = NanoCrowd_PedestrianBase(Agent);
	if( SkelAgent != None )
	{
		SkelAgent.PlayPushedReactionAnim( Dir );
	}


	PawnVel = VSize2D(Pawn.Velocity);

	if( PawnVel >= 1000 )
	{
		bCrowdTraversalSpeed_FromRunning = TRUE;
		CrowdTraversalSpeed_TimeToAllowFullSpeed = WorldInfo.TimeSeconds + CrowdTraversalSpeed_DurationToForceSlowerVelocity;
	}
	else if( PawnVel >= 400 )
	{
		bCrowdTraversalSpeed_FromJogging = TRUE;
		CrowdTraversalSpeed_TimeToAllowFullSpeed = WorldInfo.TimeSeconds + CrowdTraversalSpeed_DurationToForceSlowerVelocity;
	}
	else if( PawnVel >= 10 )
	{
		bCrowdTraversalSpeed_FromWalking = TRUE;
		CrowdTraversalSpeed_TimeToAllowFullSpeed = WorldInfo.TimeSeconds + CrowdTraversalSpeed_DurationToForceSlowerVelocity;
	}

}


function UpdatebIsHiddenByCrowd()
{
	local int NumCrowd;
	local int NumPanickedCrowd;
	local GameCrowdAgent GCA;

	foreach NearbyCrowdAgentList( GCA )
	{
		if( GCA.bIsPanicked == TRUE )
		{
			NumPanickedCrowd++;
		}
		else
		{
			NumCrowd++;
		}
	}

	MyNP.bIsHiddenByCrowd = FALSE;
	MyNP.NumNonPanickedCrowdAround = NumCrowd;
	MyNP.NumPanickedCrowdAround = NumPanickedCrowd;

	if( NumPanickedCrowd > MyNP.NumPanickedCrowdToHideUs )
	{
		MyNP.bIsHiddenByCrowd = TRUE;
	}

	if( NumCrowd > MyNP.NumNonPanickedCrowdToHideUs )
	{
		MyNP.bIsHiddenByCrowd = TRUE;
	}

}


/** Util for drawing debug text, which will wrap to a new column when it goes off the bottom of the screen */
function DrawDebugText(NanoHUD_Base H, String Text)
{
	local float XL, YL;

	if( H.Canvas.CurY >= H.Canvas.SizeY * 0.95f )
	{
		H.Canvas.SetPos(H.Canvas.CurX + DebugTextMaxLen + 8.f, H.Canvas.SizeY * 0.05f);
		DebugTextMaxLen = 0.f;
	}

	H.Canvas.StrLen(Text, XL, YL);
	if( XL > DebugTextMaxLen )
	{
		DebugTextMaxLen = XL;
	}

	H.Canvas.DrawText(Text,,,,H.Text_NoClipShadowed);
}

/** Toggle animation debugging. */
exec function DebugAnimation( optional bool bLog, optional bool bDebugOther )
{
	bDebugAnimation = !bDebugAnimation;
	bDebugLogAnimation = bLog;
	bDebugAnimOther = bDebugOther;
	MyNanoHud.SetDebugDraw(DebugDraw_Animation, bDebugAnimation);
}

/** Function to draw info about current anim state on the screen */
function DebugDraw_Animation(NanoHUD_Base H)
{
	local Canvas							Canvas;
	local NanoPawn							DebugPawn;
	local AnimNode							Node;
	local int								i;
	local SkelControlBase					SkelControl;
	local String							Text, NodeStr;
	local AnimTree                          AnimTreeRootNode;
	local AnimNodeSequence					SeqNode;
	local AnimNodeBlendByProperty			PropNode;
	local AnimTree.AnimGroup				AnimGroup;
	local AnimNodeBlendList					BlendListNode;
	local int								AnimIdx;

	Canvas = H.Canvas;
	DebugPawn = NanoPawn(Pawn);

	if( bDebugAnimOther )
	{
		foreach WorldInfo.AllPawns( class'NanoPawn', DebugPawn )
		{
			if( DebugPawn != Pawn && DebugPawn.Health > 0 )
				break;
		}
	}

	if( DebugPawn == None )
		return;

	Canvas.Font = class'Engine'.Static.GetTinyFont();
	Canvas.SetDrawColor(0, 255, 0, 255);
	Canvas.SetPos(Canvas.SizeX * 0.05f, Canvas.SizeY * 0.05f);

	DebugTextMaxLen = 0.f;

	// ANIMTREE
	DrawDebugText(H, "* AnimTree *" );
	DrawDebugText(H, "*"@DebugPawn@"*" );
	Canvas.SetDrawColor(255, 0, 0, 255);
	DrawDebugText(H, "* Phys"@DebugPawn.Physics@"Vel"@DebugPawn.Velocity@"*" );
	DrawDebugText(H, "* RMM"@DebugPawn.Mesh.RootMotionMode@"RM Vel"@DebugPawn.Mesh.RootMotionVelocity@"RM Accel Scale"@DebugPawn.Mesh.RootMotionAccelScale@"*" );
	Canvas.SetDrawColor(0, 255, 0, 255);
	ForEach DebugPawn.Mesh.AllAnimNodes(class'AnimNode', Node)
	{
		// Skip non relevant nodes
		if( Node.NodeTotalWeight < 0.00001f )
		{
			continue;
		}
		
		NodeStr = Node.NodeName != '' ? String(Node.NodeName) : "";
		SeqNode = AnimNodeSequence(Node);
		if( SeqNode != None )
		{
			Canvas.SetDrawColor(255, 0, 255, 255);
			DrawDebugText(H, Node.Class $ " (" $ SeqNode.AnimSeqName $") W:" $ int(Node.NodeTotalWeight*100.f) );
		}
		else
		{
			Canvas.SetDrawColor(0, 255, 0, 255);

			Text = ((Node.NodeName != '' && Node.NodeName != 'None') ? Node.Class $ " (" $ Node.NodeName $ ")" : String(Node.Class));

			BlendListNode = AnimNodeBlendList(Node);
			if( BlendListNode != None )
			{
				PropNode = AnimNodeBlendByProperty(Node);
				if(PropNode != None)
				{
					DrawDebugText(H, Text @ "("$ PropNode.PropertyName $")" @ "W:" $ int(Node.NodeTotalWeight*100.f) @ "C:" $ BlendListNode.ActiveChildIndex @ "W:" $ int(BlendListNode.Children[BlendListNode.ActiveChildIndex].Weight*100.f)@NodeStr );					
				}
				else
				{
					DrawDebugText(H, Text @ "W:" $ int(Node.NodeTotalWeight*100.f) @ "C:" $ BlendListNode.ActiveChildIndex @ "W:" $ int(BlendListNode.Children[BlendListNode.ActiveChildIndex].Weight*100.f)@NodeStr );
				}
			}
			else
			{
				DrawDebugText(H, Text @ "W:" $ int(Node.NodeTotalWeight*100.f)@NodeStr );
			}
		}
	}

	// ANIMNODESEQUENCES
	Canvas.SetDrawColor(0, 255, 0, 255);
	// if overlapping half the screen then insert a line break and push down
	if (Canvas.CurY > Canvas.ClipY * 0.7)
	{
		DrawDebugText(H, " ");
	}
	else
	{
		// otherwise keep at half the screen
		Canvas.SetPos(Canvas.CurX,Canvas.ClipY * 0.7);
	}
	DrawDebugText(H, "* AnimNodeSequences *");
	ForEach DebugPawn.Mesh.AllAnimNodes(class'AnimNodeSequence', SeqNode)
	{
		AnimIdx = DebugAnimList.Find( SeqNode.AnimSeqName );

		// Skip non relevant nodes
		if( SeqNode.NodeTotalWeight < 0.00001f )
		{
			if( AnimIdx >= 0 )
			{
				DebugAnimList.Remove( AnimIdx, 1 );
			}

			continue;
		}

		Canvas.SetDrawColor(255, 0, 255, 255);

		Text = (SeqNode.Class != class'AnimNodeSequence') ? String(SeqNode.Class) @ "" : "";
		Text = Text $ "(" $ SeqNode.AnimSeqName $ ") W:" $ int(SeqNode.NodeTotalWeight*100.f) @ "P:" $ int(SeqNode.GetNormalizedPosition()*100.f) @ "R:"$SeqNode.Rate;
		Text = Text @  "RBO:"@SeqNode.RootBoneOption[0]$"/"$SeqNode.RootBoneOption[1]$"/"$SeqNode.RootBoneOption[2] @ "RRO:"@"RBO:"@SeqNode.RootRotationOption[0]$"/"$SeqNode.RootRotationOption[1]$"/"$SeqNode.RootRotationOption[2];
		DrawDebugText(H, Text);

		if( AnimIdx < 0 )
		{
			`log( "Anim:"@SeqNode.AnimSeqName@"W:"@int(SeqNode.NodeTotalWeight*100.f), bDebugLogAnimation  );
			DebugAnimList[DebugAnimList.Length] = SeqNode.AnimSeqName;
		}
	}

	Canvas.SetDrawColor(0, 255, 0, 255);

	H.Canvas.SetPos(H.Canvas.CurX + DebugTextMaxLen + 8.f, H.Canvas.SizeY * 0.05f);
	DebugTextMaxLen = 0.f;

	// CONTROLLERS
	DrawDebugText(H, "* Bone Controllers *");
	AnimTreeRootNode = AnimTree(DebugPawn.Mesh.Animations);
	if( AnimTreeRootNode != None )
	{
		for(i=0; i<AnimTreeRootNode.SkelControlLists.Length; i++)
		{
			SkelControl = AnimTreeRootNode.SkelControlLists[i].ControlHead;

			if( SkelControl == None )
			{
				continue;
			}

			// Bone name
			Canvas.SetDrawColor(0, 255, 0, 255);
			DrawDebugText(H, String(AnimTreeRootNode.SkelControlLists[i].BoneName) );

			while( SkelControl != None )
			{
				if( SkelControl.ControlStrength < 0.00001f )
				{
					Canvas.SetDrawColor(255, 0, 0, 255);
				}
				else
				{
					Canvas.SetDrawColor(0, 255, 0, 255);
				}

				if( TRUE ) //SkelControl.ControlStrength > 0.00001f )
				{
					DrawDebugText(H, "  " @ SkelControl.Class $ " (" $ SkelControl.ControlName $") W:" $ int(SkelControl.ControlStrength*100.f) );
				}

				SkelControl = SkelControl.NextControl;
			}
		}
	}

	H.Canvas.SetPos(H.Canvas.CurX + DebugTextMaxLen + 8.f, H.Canvas.SizeY * 0.05f);
	DebugTextMaxLen = 0.f;

	// ANIM GROUPS
	DrawDebugText(H, "* Anim Groups *");
	if( AnimTreeRootNode != None )
	{
		for(i=0; i<AnimTreeRootNode.AnimGroups.Length; i++)
		{
			AnimGroup = AnimTreeRootNode.AnimGroups[i];
			if( AnimGroup.SynchMaster == None || AnimGroup.SynchMaster.NodeTotalWeight < 0.00001f )
			{
				Canvas.SetDrawColor(255, 0, 0, 255);
			}
			else
			{
				Canvas.SetDrawColor(0, 255, 0, 255);
			}

			DrawDebugText(H,  AnimGroup.GroupName @ "RateScale:" $ AnimGroup.RateScale @ "NumNodes:" $ AnimGroup.SeqNodes.Length @ "P:" $ AnimTreeRootNode.GetGroupRelativePosition(AnimGroup.GroupName));
			if( AnimGroup.SynchMaster != None )
			{
				DrawDebugText(H,  "  SynchMaster:" $ AnimGroup.SynchMaster @ "W:" $ int(AnimGroup.SynchMaster.NodeTotalWeight*100.f));
			}
			else
			{
				DrawDebugText(H,  "  SynchMaster:None");
			}

			if( AnimGroup.NotifyMaster != None )
			{
				DrawDebugText(H,  "  NotifyMaster:" $ AnimGroup.NotifyMaster @ "W:" $ int(AnimGroup.NotifyMaster.NodeTotalWeight*100.f));
			}
			else
			{
				DrawDebugText(H,  "  NotifyMaster:None");
			}
		}
	}
}


/** Toggle camera debugging. */
exec function DebugCamera()
{
	bDebugCamera = !bDebugCamera;
	MyNanoHud.SetDebugDraw(DebugDraw_Camera, bDebugCamera);
}

exec function ToggleDrawCamera()
{
	MyNP.bDebugShowCameraLocation = !MyNP.bDebugShowCameraLocation;
}

function DebugDraw_Camera(NanoHUD_Base H)
{
	local Canvas							Canvas;
	local NanoPawn							DebugPawn;
	local GamePlayerCamera					Cam;
	local NanoThirdPersonCamera				TPC;
	local NanoThirdPersonCameraMode			TPCM;
//	local Cam3p_Melee						MeleeCam;
	local Color ZoneColor;
	local int i;
	local Vector X, Y, Z;
	local SafeZoneInfo Info;
	local Vector2D U,V,W;

	Canvas = H.Canvas;
	DebugPawn = NanoPawn(Pawn);
	Cam = GamePlayerCamera(PlayerCamera);
	TPC = NanoThirdPersonCamera(Cam.CurrentCamera);
	if( Cam == None || TPC == None )
	{
		return;
	}	
	TPCM = NanoThirdPersonCameraMode(TPC.CurrentCamMode);
	//MeleeCam = Cam3p_Melee(TPCM);

	Canvas.Font = class'Engine'.Static.GetMediumFont();
	Canvas.SetDrawColor(0, 255, 0, 255);
	Canvas.SetPos(Canvas.SizeX * 0.05f, Canvas.SizeY * 0.05f);

	DebugTextMaxLen = 0.f;

	DrawDebugText( H, " Camera Bone:"@DebugPawn.DebugCameraBone );
	DrawDebugText( H, " Camera:"@Cam );
	DrawDebugText( H, " Camera Type:"@TPC );
	DrawDebugText( H, " Camera Mode:"@TPCM );
	DrawDebugText( H, " Pawn Rot:"@Normalize(DebugPawn.Rotation)@"DesiredRot:"@Normalize(DebugPawn.DesiredRotation) );
	DrawDebugText( H, " Controller Rot:"@Normalize(Rotation) );

	Canvas.SetDrawColor(255, 255, 255, 255);
	DrawDebugText( H, "---" );
	Canvas.SetDrawColor(0, 0, 255, 255);
	DrawDebugText( H, " Camera State:"@TPC.TransitionState );
	DrawDebugText( H, " Cam Orig Loc:"@Cam.Location@"Cam Orig Rot:"@Cam.Rotation );
	if( DebugPawn.DebugCameraBone != '' )
	{
		DrawDebugText( H, " Cam Bone Loc:"@DebugPawn.Mesh.GetBoneLocation(DebugPawn.DebugCameraBone)@"Cam Bone Rot:"@QuatToRotator(DebugPawn.Mesh.GetBoneQuaternion(DebugPawn.DebugCameraBone)) );
	}
	DrawDebugText( H, " Last Ideal Loc:"@DebugPawn.DebugLastIdealCameraBoneLoc@"Delta From Ideal:"@DebugPawn.DebugDeltaIdealCameraBoneLoc@"DeltaSize"@VSize(DebugPawn.DebugDeltaIdealCameraBoneLoc) );
	DrawDebugText( H, " Last Ideal Rot:"@DebugPawn.DebugLastIdealCameraBoneRot@"Delta From Ideal:"@DebugPawn.DebugDeltaIdealCameraBoneRot );
	DrawDebugText( H, " FOV:"@TPC.GetDesiredFOV(DebugPawn) );
		
/*	
	Canvas.SetDrawColor(255, 255, 255, 255);
	DrawDebugText( H, "---" );
	Canvas.SetDrawColor(255, 0, 0, 255);
	DrawDebugText( H, " bInterpLocation:"@TPCM.bInterpLocation );
	DrawDebugText( H, " bInterpLocByTime:"@TPCM.bInterpLocByTime );
	DrawDebugText( H, " bInterpToIdealLocThenLock:"@TPCM.bInterpToIdealLocThenLock );
	DrawDebugText( H, " InterpLocTimeRemaining:"@TPCM.InterpLocTimeRemaining );

	DrawDebugText( H, " bInterpRotation:"@TPCM.bInterpRotation );
	DrawDebugText( H, " bInterpRotByTime:"@TPCM.bInterpRotByTime );
	DrawDebugText( H, " bInterpToIdealRotThenLock:"@TPCM.bInterpToIdealRotThenLock );
	DrawDebugText( H, " InterpRotTimeRemaining:"@TPCM.InterpRotTimeRemaining );
	DrawDebugText( H, " bUseCameraBoneRotation:"@TPCM.bUseCameraBoneRotation );

	DrawDebugText( H, " DesiredAutoPan:"@TPC.DesiredAutoPan@"AutoPan"@TPC.AutoPan@"AutoPanInterpSpeed:"@TPC.AutoPanRotInterpSpeed );
	DrawDebugText( H, " DesiredAutoSlide:"@TPC.DesiredAutoSlide@"AutoSlide"@TPC.AutoSlide@"AutoSlideInterpSpeed:"@TPC.AutoSlideLocInterpSpeed );
	if( MeleeCam != None )
	{
		Canvas.SetDrawColor(255, 255, 255, 255);
		DrawDebugText( H, "---" );
		Canvas.SetDrawColor(255, 0, 0, 255);
		DrawDebugText( H, " DesiredRot:"@MeleeCam.DesiredViewRotation@"ActualRot"@MeleeCam.ActualViewRotation );
		DrawDebugText( H, " bCombatCamera:"@MeleeCam.bCombatCamera );
		DrawDebugText( H, " bPlayerSelectedMeleeTarget:"@bPlayerSelectedMeleeTarget );
		DrawDebugText( H, " bIsDoingAttack:"@DebugPawn.bIsDoingAttack );
		DrawDebugText( H, " AdjustRotationLimit:"@MeleeCam.AdjustRotationLimit );
		DrawDebugText( H, " AdjustRotationDelay:"@MeleeCam.AdjustRotationDelay );
		DrawDebugText( H, " AdjustRotationStartTime:"@`TimeSince( MeleeCam.AdjustRotationStartTime ) );
	}	

	Canvas.SetDrawColor(255, 255, 255, 255);
	DrawDebugText( H, "---" );
	Canvas.SetDrawColor(255, 0, 0, 255);
	DrawDebugText( H, " bValidateWorstLoc:"@TPCM.bValidateWorstLoc );
	DrawDebugText( H, " bSkipCameraCollision:"@TPCM.bSkipCameraCollision );
	DrawDebugText( H, " bDoPredictiveAvoidance:"@TPCM.bDoPredictiveAvoidance );
	
	
	Canvas.SetDrawColor(255, 255, 255, 255);
	DrawDebugText( H, "---" );
	Canvas.SetDrawColor(0, 0, 255, 255);
	DrawDebugText( H, " Desired Cam Type:"@TPC.DesiredCameraTypeByAnim );
	DrawDebugText( H, " bDesiredUseThirdPersonCamera:"@TPC.bDesiredUseThirdPersonCamera );
	DrawDebugText( H, " bUseThirdPersonCamera:"@TPC.bUseThirdPersonCamera );
	DrawDebugText( H, " TimeSince Transition:"@`TimeSince(TPC.LastTransitionTime) );
*/
	if( TPCM != None )
	{
		GetAxes( Cam.Rotation, X, Y, Z );
		for( i = 0; i < TPCM.SafeZoneList.Length; i++ )
		{
			Info = TPCM.SafeZoneList[i].Zone;
			if( Info == None || !Info.bActive )
				continue;

			Canvas.SetDrawColor(255, 255, 255, 255);
			DrawDebugText( H, "---" );
			DrawDebugText( H, "ZoneName:"@Info.ZoneName@"ActiveTime:"@Info.TotalTimeActive@"(Desired/Actual)" );
			if( (Info.ViolationFlags & (1 << SZV_Left)) != 0 || (Info.ViolationFlags & (1 << SZV_Right)) != 0 )
			{
				if( Info.bGoodAtLeastOnce_U )
				{
					Canvas.SetDrawColor(0, 0, 255, 255);
				}
				else
				{
					Canvas.SetDrawColor(255, 0, 0, 255);
				}
			}
			else
			{
				Canvas.SetDrawColor(0, 255, 0, 255);
			}
			DrawDebugText( H, " Left/Right: IN"@VSize(Info.DesiredOffset_U)@"/"@VSize(Info.Offset_U)@"("$Info.bGoodAtLeastOnce_U$")" );

			if( (Info.ViolationFlags & (1 << SZV_Up)) != 0 || (Info.ViolationFlags & (1 << SZV_Down)) != 0 )
			{
				if( Info.bGoodAtLeastOnce_V )
				{
					Canvas.SetDrawColor(0, 0, 255, 255);
				}
				else
				{
					Canvas.SetDrawColor(255, 0, 0, 255);
				}
			}
			else
			{
				Canvas.SetDrawColor(0, 255, 0, 255);
			}
			DrawDebugText( H, " Up/Down: OUT"@VSize(Info.DesiredOffset_V)@"/"@VSize(Info.Offset_V)@"("$Info.bGoodAtLeastOnce_V$")" );
			
			if( (Info.ViolationFlags & (1 << SZV_Front)) != 0 || (Info.ViolationFlags & (1 << SZV_Rear)) != 0 )
			{
				if( Info.bGoodAtLeastOnce_W )
				{
					Canvas.SetDrawColor(0, 0, 255, 255);
				}
				else
				{
					Canvas.SetDrawColor(255, 0, 0, 255);
				}
			}
			else
			{
				Canvas.SetDrawColor(0, 255, 0, 255);
			}
			DrawDebugText( H, " Front/Rear: OUT"@VSize(Info.DesiredOffset_W)@"/"@VSize(Info.Offset_W)@"("$Info.bGoodAtLeastOnce_W$")"  );
			Canvas.SetDrawColor(0, 0, 255, 255);
		//	DrawDebugText( H, ""@`showvar(TPC.ViolationOffset) );
		//	DrawDebugText( H, ""@`showvar(TPC.DesiredInterpViolationOffset) );
		//	DrawDebugText( H, ""@`showvar(TPC.InterpViolationOffset) );
		//	DrawDebugText( H, ""@`showvar(TPC.HardViolationOffset) );
			
			ZoneColor = MakeColor( 255, 0, 0, 255 );
			if( Info.ViolationFlags == 0 )
			{
				ZoneColor = MakeColor( 0, 255, 0, 255 );
			}

			Info.GetSafeZoneMinMax( U, V, W );
			DrawSafeZone( Canvas, U, V, ZoneColor );
		}
	}
}

final function DrawSafeZone( Canvas Canvas, Vector2D U, Vector2D V, Color ZoneColor )
{
	local Vector2D DrawU, DrawV;

	DrawU = U;
	if( DrawU.X < 0.f )
	{
		DrawU.X = 0.f;
	}
	if( DrawU.Y < 0.f )
	{
		DrawU.Y = 1.f;
	}

	DrawV = V;
	if( DrawV.X < 0.f )
	{
		DrawV.X = 0.f;
	}
	if( DrawV.Y < 0.f )
	{
		DrawV.Y = 1.f;
	}	
	
	if( V.X > 0.f )
	{
		Canvas.Draw2DLine( Canvas.SizeX * DrawU.X, Canvas.SizeY * DrawV.X, Canvas.SizeX * DrawU.Y, Canvas.SizeY * DrawV.X, ZoneColor );
	}
	if( U.Y > 0.f )
	{
		Canvas.Draw2DLine( Canvas.SizeX * DrawU.Y, Canvas.SizeY * DrawV.X, Canvas.SizeX * DrawU.Y, Canvas.SizeY * DrawV.Y, ZoneColor );
	}
	if( V.Y > 0.f )
	{
		Canvas.Draw2DLine( Canvas.SizeX * DrawU.Y, Canvas.SizeY * DrawV.Y, Canvas.SizeX * DrawU.X, Canvas.SizeY * DrawV.Y, ZoneColor );
	}
	if( U.X > 0.f )
	{
		Canvas.Draw2DLine( Canvas.SizeX * DrawU.X, Canvas.SizeY * DrawV.Y, Canvas.SizeX * DrawU.X, Canvas.SizeY * DrawV.X, ZoneColor );
	}	
}

exec function DebugAwareness()
{
	bDebugAwareness = !bDebugAwareness;
	MyNanoHud.SetDebugDraw(DebugDraw_Awareness, bDebugAwareness);
}

function DebugDraw_Awareness(NanoHUD_Base H)
{
	local Canvas							Canvas;
	local NanoPawn							DebugPawn;
	
	Canvas = H.Canvas;
	DebugPawn = NanoPawn(Pawn);


	Canvas.Font = class'Engine'.Static.GetTinyFont();
	Canvas.SetDrawColor(255, 255, 255, 255);
	Canvas.SetPos(Canvas.SizeX * 0.05f, Canvas.SizeY * 0.05f);
	DebugTextMaxLen = 0.f;

	DrawDebugText( H, " Velocity:"@DebugPawn.DebugVelSize );
	DrawDebugText( H, " DistFromImpact:"@DebugPawn.DebugDistFromImpact );
	DrawDebugText( H, " TimeFromImpact:"@DebugPawn.DebugTimeFromImpact );
	DrawDebugText( H, " PrepTimeRemaining:"@DebugPawn.DebugPrepTimeRemaining );
	DrawDebugText( H, " PrepRate:"@DebugPawn.DebugPrepRate );
	DrawDebugText( H, " LimbCtrlStrength:"@DebugPawn.DebugLimbCtrlStrength );
	
}

exec function DebugNetwork()
{
	bDebugNetwork = !bDebugNetwork;
	MyNanoHud.SetDebugDraw(DebugDraw_Network, bDebugNetwork);
}

function DebugDraw_Network( NanoHUD_Base H )
{
	local Canvas	Canvas;
//	local NanoPawn	DebugPawn;
	
	Canvas = H.Canvas;
//	DebugPawn = NanoPawn(Pawn);

	Canvas.Font = class'Engine'.Static.GetTinyFont();
	Canvas.SetDrawColor(255, 255, 255, 255);
	Canvas.SetPos(Canvas.SizeX * 0.8f, Canvas.SizeY * 0.9f);
	DebugTextMaxLen = 0.f;

	DrawDebugText( H, " NetMode:"@WorldInfo.NetMode );
}

exec function DebugTargeting()
{
	bDebugTargeting = !bDebugTargeting;
	MyNanoHud.SetDebugDraw(DebugDraw_Targeting, bDebugTargeting);
}

exec function DebugAccuracy()
{
	FlushPersistentDebugLines();
	MyNP.bWeaponDebug_Accuracy = !MyNP.bWeaponDebug_Accuracy;
}

function DebugDraw_Targeting(NanoHUD_Base H)
{
	local Canvas	Canvas;
	local Actor A;
	local array<TargetSortInfo> PotentialTargets;
	local TargetSortInfo NewTarget;
	local vector CamLoc;
	local rotator CamRot;
	local NanoInterface_Targetable NTI;
	local Vector	ScreenLoc;
	local float		X, Y, MaxRange;
	local int i;
	local float CollisionHeight, CollisionRadius;

	local array<Actor> TargetableWithinMaxRange;


	GetActorEyesViewPoint(CamLoc,CamRot);
	Canvas = H.Canvas;
	MaxRange = 4096.f;
	
	TargetableWithinMaxRange = NanoGRI(WorldInfo.GRI).FindAllNanoInterface_TargetableAroundPlayerPawn( MyNP, MaxRange );

	foreach TargetableWithinMaxRange(A)
	{
		// if not our pawn
		if( A != Pawn )
		{
			NTI = NanoInterface_Targetable(A);
			// as we are doing this for hundreds of actors
			// do a quick rendertime and dist cull check here so we don't do extra line checking function calling which is slow
			if( (WorldInfo.TimeSeconds - A.LastRenderTime) > 2.0f || // if we have not seen this actor for 2 second then don't allow targeting of it
				(Pawn != None && VSizeSq(Pawn.Location - A.Location) > MaxRange*MaxRange) ||
				 NTI == None ||
				!NTI.IsTargetable() )
			{
				continue; // skip this actor
			}
				
			NewTarget.Target = A;
			NewTarget.Rating = StandardRateTarget(A,CamLoc,CamRot,MaxRange,0.3f);
			if( NewTarget.Rating > 0.f && LineOfSightTo(A) )
			{
				PotentialTargets.AddItem(NewTarget);
			}
		}
	}

	for( i = 0; i < PotentialTargets.Length; i++ )
	{
		PotentialTargets[i].Target.GetBoundingCylinder( CollisionRadius, CollisionHeight );
		Canvas.SetDrawColor(255,0,0);
		ScreenLoc = Canvas.Project( PotentialTargets[i].Target.Location + vect(0,0,1) * CollisionHeight * 1.5f );
		X = ScreenLoc.X + 5;
		Y = ScreenLoc.Y;
		Canvas.SetPos( X, Y );

		Canvas.DrawText(PotentialTargets[i].Target$":"@PotentialTargets[i].Rating,TRUE);
	}
}

exec function DebugJump()
{
	bDebugJump = !bDebugJump;
	MyNanoHud.SetDebugDraw(DebugDraw_Jump, bDebugJump);
}

function DebugDraw_Jump(NanoHUD_Base H)
{
	local Canvas	Canvas;
	local vector	CamLoc;
	local rotator	CamRot;
	local NanoSkill_Jump JumpSkill;
		
	GetActorEyesViewPoint(CamLoc,CamRot);
	Canvas = H.Canvas;

	Canvas.Font = class'Engine'.Static.GetLargeFont();
	Canvas.SetDrawColor(255, 0, 0, 255);
	Canvas.SetPos(Canvas.SizeX * 0.05f, Canvas.SizeY * 0.05f);

	DebugTextMaxLen = 0.f;

	if( MyNP == None )
		return;
	JumpSkill = MyNP.GetSkill(class'NanoSkill_Jump');

	if( MyNP.Physics == PHYS_Falling )
	{
		DrawDebugText( H, " Max Jump Height:"@JumpSkill.MaxOfJump.Z-JumpSkill.JumpOrigin.Z);
		DrawDebugText( H, " Max Jump Dist:"@VSize2D(JumpSkill.JumpOrigin-JumpSkill.MaxOfJump) );
		DrawDebugText( H, " ---------------------------------------" );
		if( MyNP.Velocity.Z > 0 )
		{
			DrawDebugText( H, " Ground To Apex:"@WorldInfo.TimeSeconds-MyNP.LastJumpTime);
			DrawDebugText( H, " Apex To Ground:" );
		}
		else
		{
			DrawDebugText( H, " Ground To Apex:"@MyNP.StartFallingTime-MyNP.LastJumpTime);
			DrawDebugText( H, " Apex To Ground:"@WorldInfo.TimeSeconds-MyNP.StartFallingTime);
		}
		DrawDebugText( H, " Total Air Time:"@WorldInfo.TimeSeconds-MyNP.LastJumpTime);
	}
	else
	{
		DrawDebugText( H, " Max Jump Height:"@JumpSkill.MaxOfJump.Z-JumpSkill.JumpOrigin.Z);
		DrawDebugText( H, " Max Jump Dist:"@VSize2D(JumpSkill.JumpOrigin-JumpSkill.MaxOfJump) );
		DrawDebugText( H, " ---------------------------------------" );
		DrawDebugText( H, " Ground To Apex:"@MyNP.StartFallingTime-MyNP.LastJumpTime);
		DrawDebugText( H, " Apex To Ground:"@MyNP.LastLandingTime-MyNP.StartFallingTime);
		DrawDebugText( H, " Total Air Time:"@MyNP.LastLandingTime-MyNP.LastJumpTime);
	}
}

exec function DebugTraversal()
{
	bDebugTraversal = !bDebugTraversal;
	MyNanoHud.SetDebugDraw(DebugDraw_Traversal, bDebugTraversal);
}

function DebugDraw_Traversal( NanoHUD_Base H )
{
	local Canvas	Canvas;
	local vector	CamLoc;
	local rotator	CamRot, CamYawRot;
	local float		DrawX, DrawY, BoxSize, ArmLength;
	local Vector	VectToTarget, X, Y, Z;
	local float     DashTime, BleedPct;
	local NanoSkill_Dash DashSkill;
			
	GetActorEyesViewPoint(CamLoc,CamRot);
	CamYawRot.Yaw = CamRot.Yaw;
	GetAxes( CamYawRot, X, Y, Z );

	Canvas = H.Canvas;

	Canvas.Font = class'Engine'.Static.GetLargeFont();
	Canvas.SetDrawColor(0, 255, 0, 255);
	Canvas.SetPos(Canvas.SizeX * 0.05f, Canvas.SizeY * 0.05f);

	DebugTextMaxLen = 0.f;

	if( MyNP == None )
		return;
	
	Canvas.SetDrawColor(0, 255, 0, 255);
	DrawDebugText( H, " ------------------INPUT------------------" );
	DrawDebugText( H, " RawJoyUp:"@PlayerInput.RawJoyUp@"RawJoyRight"@PlayerInput.RawJoyRight );
	DrawDebugText( H, " RemappedJoyUp:"@RemappedJoyUp@"RemappedJoyRight"@RemappedJoyRight );
	DrawDebugText( H, " aForward:"@DebugaForward@"aStrafe"@DebugaStrafe);
	DrawDebugText( H, " X:"@DebugAccelX@"Y:"@DebugAccelY);
	DrawDebugText( H, " bRemapControls:"@bRemapControls );

	DrawDebugText( H, " ------------------PHYSICS------------------" );
	DrawDebugText( H, " Physics:"@MyNP.Physics );
	DrawDebugText( H, " Vel ("@VSize(MyNP.Velocity)@"):"@MyNP.Velocity@"Accel("@VSize(MyNP.Acceleration)@"):"@MyNP.Acceleration);
	DrawDebugText( H, " AccelRate:"@MyNP.AccelRate );
	DrawDebugText( H, " AngVel ("@VSize(MyNP.AngularVelocity)@"):"@MyNP.AngularVelocity );

	
	DrawDebugText( H, " ------------------NANOPAWN------------------" );
	DrawDebugText( H, " ActiveSpecialMove - Name:"@MyNP.ActiveSpecialMoveName@"Object:"@MyNP.ActiveSpecialMove );
	DrawDebugText( H, " Mantle State:"@MyNP.MantleState );

	DrawDebugText( H, " TeslaShock_NoRun_ActiveUntil: " @ WorldInfo.TimeSeconds - MyNP.TeslaShock_NoRun_ActiveUntil );
	DrawDebugText( H, " TeslaShock_NoJog_ActiveUntil: " @ WorldInfo.TimeSeconds - MyNP.TeslaShock_NoJog_ActiveUntil );
	DrawDebugText( H, " TeslaShock_NoJump_ActiveUntil: " @ WorldInfo.TimeSeconds - MyNP.TeslaShock_NoJump_ActiveUntil );
	DrawDebugText( H, " TeslaShock_NoAttack_ActiveUntil: " @ WorldInfo.TimeSeconds - MyNP.TeslaShock_NoAttack_ActiveUntil );

	DrawDebugText( H, " CanDoMeleeAttack(): " @ MyNP.CanDoMeleeAttack() );
	DrawDebugText( H, " bPlayingHitReaction:" @ MyNP.bPlayingHitReaction );

	


	if( MyNP.bIsDashing )
	{
		DashSkill = MyNP.GetSkill(class'NanoSkill_Dash');
		DashTime = `TimeSince(DashSkill.LastActivateTime);
		BleedPct = DashSkill.DashBleedOffPct;
	}
	DrawDebugText( H, " bIsDashing:"@MyNP.bIsDashing@"(TotalTime:"@DashTime@"BleedPct:"@BleedPct@") WantsToDash:"@MyNP.bWantsToDash );
	DrawDebugText( H, " bSliding:"@MyNP.bSliding );
	DrawDebugText( H, " bIsWalking:"@MyNP.bIsWalking );
	DrawDebugText( H, " bIsPlatformJumping:"@MyNP.bIsPlatformJumping );


	BoxSize = 5.f;
	ArmLength = 50.f;

	// DRAW INPUT
	DrawX = Canvas.ClipX * 0.5f - 50.f;
	DrawY = Canvas.ClipY * 0.15f;
	Canvas.SetPos( DrawX, DrawY );
	Canvas.SetDrawColor( 255, 255, 255 );
	DrawDebugText( H, " Stick Input" );

	DrawX = Canvas.ClipX * 0.5f  - (BoxSize * 0.5f);
	DrawY = Canvas.CurY + ArmLength * 1.2f;
	Canvas.SetPos( DrawX, DrawY );
	Canvas.SetDrawColor( 255, 255, 255, 255 );
	Canvas.DrawRect( BoxSize, BoxSize );
	DrawX += (BoxSize * 0.5f);
	DrawY += (BoxSize * 0.5f);

	Canvas.Draw2DLine( DrawX, DrawY, DrawX + (PlayerInput.RawJoyRight * ArmLength), DrawY - (PlayerInput.RawJoyUp * ArmLength), MakeColor(255, 255, 255, 255) );
	Canvas.Draw2DLine( DrawX, DrawY, DrawX + (RemappedJoyRight * ArmLength), DrawY - (RemappedJoyUp * ArmLength), MakeColor(0, 255, 0, 255) );

	VectToTarget = Vector(ControlsRemapRotation);
	VectToTarget.Z = 0;
	VectToTarget = Normal(VectToTarget);
	Canvas.Draw2DLine( DrawX, DrawY, DrawX + ((Y DOT VectToTarget) * ArmLength * 1.1f), DrawY - ((X DOT VectToTarget) * ArmLength * 1.1f), MakeColor(0, 128, 0, 255) );


	// DRAW PAWN ROTATION INFO
	DrawX = Canvas.ClipX * 0.5f - 50.f;
	DrawY = Canvas.CurY + ArmLength * 1.25f;
	Canvas.SetPos( DrawX, DrawY );
	Canvas.SetDrawColor( 0, 255, 0 );
	DrawDebugText( H, " Pawn Desired Rot:"@MyNP.DesiredRotation );
	Canvas.SetDrawColor( 0, 0, 255 );
	DrawDebugText( H, " Pawn Rot:"@MyNP.Rotation );

	DrawX = Canvas.ClipX * 0.5f  - (BoxSize * 0.5f);
	DrawY = Canvas.CurY + ArmLength * 1.2f;
	Canvas.SetPos( DrawX, DrawY );
	if( MyNP.IsDesiredRotationLocked() )
	{
		Canvas.SetDrawColor( 255, 0, 0, 255 );
	}
	else
	{
		Canvas.SetDrawColor( 255, 255, 255, 255 );
	}
	Canvas.DrawRect( BoxSize, BoxSize );
	DrawX += (BoxSize * 0.5f);
	DrawY += (BoxSize * 0.5f);
	
	VectToTarget = Vector( MyNP.DesiredRotation );
	VectToTarget.Z = 0;
	VectToTarget = Normal(VectToTarget);
	Canvas.Draw2DLine( DrawX, DrawY, DrawX + ((Y DOT VectToTarget) * ArmLength * 1.1f ), DrawY - ((X DOT VectToTarget) * ArmLength * 1.1f), MakeColor(0, 255, 0, 255) );

	VectToTarget = Vector( MyNP.Rotation );
	VectToTarget.Z = 0;
	VectToTarget = Normal(VectToTarget);
	Canvas.Draw2DLine( DrawX, DrawY, DrawX + ((Y DOT VectToTarget) * ArmLength), DrawY - ((X DOT VectToTarget) * ArmLength), MakeColor(0, 0, 255, 255) );

	VectToTarget = MyNP.Acceleration;
	VectToTarget.Z = 0;
	VectToTarget = Normal(VectToTarget);
	Canvas.Draw2DLine( DrawX, DrawY, DrawX + ((Y DOT VectToTarget) * ArmLength * 0.9f), DrawY - ((X DOT VectToTarget) * ArmLength * 0.9f), MakeColor(255, 0, 0, 255) );

	DrawDebugLine( Pawn.Location, Pawn.Location + Normal(Pawn.Acceleration) * 128.f, 255, 0, 0 );
}

exec function DebugAimOffset()
{
	bDebugAimOffset = !bDebugAimOffset;
	MyNanoHUD.SetDebugDraw(DebugDraw_AimOffset, bDebugAimOffset);
}

function DebugDraw_AimOffset(NanoHUD_Base H)
{
	local Canvas Canvas;
	local int Idx;
	local NanoAnim_AimOffset FAO, RAO;
	local Vector CamLoc;
	local Rotator CamRot, CamYawRot, ThreshRot;
	local float CamDotPawnRot;
	local float		DrawX, DrawY, BoxSize, ArmLength;
	local Vector	X, Y, Z, VectToTarget;

	GetActorEyesViewPoint(CamLoc,CamRot);
	CamYawRot.Yaw = CamRot.Yaw;
	GetAxes( CamYawRot, X, Y, Z );

	Canvas = H.Canvas;

	for( Idx = 0; Idx < MyNP.AimNodes.Length; Idx++ )
	{
		if( MyNP.AimNodes[Idx].NodeName == 'SMG_AimOffset_Front' )
		{
			FAO = MyNP.AimNodes[Idx];
		}
		else if( MyNP.AimNodes[Idx].NodeName == 'SMG_AimOffset_Rear' )
		{
			RAO = MyNP.AimNodes[Idx];
		}
	}
	GetActorEyesViewPoint( CamLoc, CamRot );
	CamDotPawnRot = Vector(CamRot) DOT Vector(MyNP.Rotation);

	Canvas.SetDrawColor( 0, 255, 0 );
	DrawDebugText( H, " Rear Aim:"@MyNP.bRearAim );
	DrawDebugText( H, " Front Aim Offset Aim -- X:"@FAO.Aim.X@"Y:"@FAO.Aim.Y@"   DesiredaAim -- X:"@FAO.DesiredAim.X@"Y:"@FAO.DesiredAim.Y );
	DrawDebugText( H, " Rear  Aim Offset Aim -- X:"@RAO.Aim.X@"Y:"@RAO.Aim.Y@"   DesiredaAim -- X:"@RAO.DesiredAim.X@"Y:"@RAO.DesiredAim.Y  );
	DrawDebugText( H, " CamRot:"@CamRot );
	DrawDebugText( H, " PawnRot:"@MyNP.Rotation );
	DrawDebugText( H, " Dot:"@CamDotPawnRot );
	DrawDebugText( H, " Profile:"@MyNP.AimOffsetProfileList[MyNP.AimOffsetProfileIdx].ProfileName );
	
	DrawX = Canvas.ClipX * 0.5f - 50.f;
	DrawY = Canvas.ClipY * 0.15f;
	Canvas.SetPos( DrawX, DrawY );
	Canvas.SetDrawColor( 0, 255, 0 );
	DrawDebugText( H, " PawnRot" );
	Canvas.SetDrawColor( 255, 0, 0 );
	DrawDebugText( H, " CamRot" );
	Canvas.SetDrawColor( 255, 255, 255 );
	DrawDebugText( H, " Front To Rear Trans" );
	Canvas.SetDrawColor( 0, 0, 255 );
	DrawDebugText( H, " Rear To Front Trans" );

	
	BoxSize = 5.f;
	ArmLength = 50.f;

	DrawX = Canvas.ClipX * 0.5f  - (BoxSize * 0.5f);
	DrawY = Canvas.CurY + ArmLength * 1.2f;
	Canvas.SetPos( DrawX, DrawY );
	Canvas.SetDrawColor( 255, 255, 255, 255 );
	Canvas.DrawRect( BoxSize, BoxSize );
	DrawX += (BoxSize * 0.5f);
	DrawY += (BoxSize * 0.5f);

	VectToTarget = Vector(MyNP.Rotation);
	VectToTarget.Z = 0;
	VectToTarget = Normal(VectToTarget);
	Canvas.Draw2DLine( DrawX, DrawY, DrawX + ((Y DOT VectToTarget) * ArmLength * 1.1f ), DrawY - ((X DOT VectToTarget) * ArmLength * 1.1f), MakeColor(0, 255, 0, 255) );

	VectToTarget = Vector(CamYawRot);
	VectToTarget.Z = 0;
	VectToTarget = Normal(VectToTarget);
	Canvas.Draw2DLine( DrawX, DrawY, DrawX + ((Y DOT VectToTarget) * ArmLength * 1.f ), DrawY - ((X DOT VectToTarget) * ArmLength * 1.f), MakeColor(255, 0, 0, 255) );

	ThreshRot.Yaw = MyNP.Rotation.Yaw + (MyNP.AimOffsetProfileList[MyNP.AimOffsetProfileIdx].TransDegrees_FrontToRear_Right * 182.f);
	VectToTarget = Vector(ThreshRot);
	VectToTarget.Z = 0;
	VectToTarget = Normal(VectToTarget);
	Canvas.Draw2DLine( DrawX, DrawY, DrawX + ((Y DOT VectToTarget) * ArmLength * 1.f ), DrawY - ((X DOT VectToTarget) * ArmLength * 0.9f), MakeColor(255, 255, 255, 255) );

	ThreshRot.Yaw = MyNP.Rotation.Yaw + (MyNP.AimOffsetProfileList[MyNP.AimOffsetProfileIdx].TransDegrees_FrontToRear_Left * 182.f);
	VectToTarget = Vector(ThreshRot);
	VectToTarget.Z = 0;
	VectToTarget = Normal(VectToTarget);
	Canvas.Draw2DLine( DrawX, DrawY, DrawX + ((Y DOT VectToTarget) * ArmLength * 1.f ), DrawY - ((X DOT VectToTarget) * ArmLength * 0.9f), MakeColor(255, 255, 255, 255) );

	ThreshRot.Yaw = MyNP.Rotation.Yaw + (MyNP.AimOffsetProfileList[MyNP.AimOffsetProfileIdx].TransDegrees_RearToFront_Right * 182.f);
	VectToTarget = Vector(ThreshRot);
	VectToTarget.Z = 0;
	VectToTarget = Normal(VectToTarget);
	Canvas.Draw2DLine( DrawX, DrawY, DrawX + ((Y DOT VectToTarget) * ArmLength * 1.f ), DrawY - ((X DOT VectToTarget) * ArmLength * 0.9f), MakeColor(0, 0, 255, 255) );

	ThreshRot.Yaw = MyNP.Rotation.Yaw + (MyNP.AimOffsetProfileList[MyNP.AimOffsetProfileIdx].TransDegrees_RearToFront_Left * 182.f);
	VectToTarget = Vector(ThreshRot);
	VectToTarget.Z = 0;
	VectToTarget = Normal(VectToTarget);
	Canvas.Draw2DLine( DrawX, DrawY, DrawX + ((Y DOT VectToTarget) * ArmLength * 1.f ), DrawY - ((X DOT VectToTarget) * ArmLength * 0.9f), MakeColor(0, 0, 255, 255) );
}

exec function DebugInput()
{
	bDebugInput = !bDebugInput;
	MyNanoHUD.SetDebugDraw(DebugDraw_Input, bDebugInput);
}

function DebugDraw_Input(NanoHUD_Base H)
{
	local Canvas	Canvas;
			
	Canvas = H.Canvas;

	Canvas.Font = class'Engine'.Static.GetLargeFont();
	Canvas.SetDrawColor(0, 255, 0, 255);
	Canvas.SetPos(Canvas.SizeX * 0.05f, Canvas.SizeY * 0.05f);

	DebugTextMaxLen = 0.f;

	Canvas.SetDrawColor( 0, 255, 0, 255 );
	DrawInputBufferInfo( H, GB_A );
	DrawInputBufferInfo( H, GB_X );
	DrawInputBufferInfo( H, GB_Y );
	DrawInputBufferInfo( H, GB_B );
	DrawInputBufferInfo( H, GB_LeftTrigger );
	DrawInputBufferInfo( H, GB_LeftBumper );
	DrawInputBufferInfo( H, GB_RightTrigger );
	DrawInputBufferInfo( H, GB_RightBumper );
}

function DrawInputBufferInfo( NanoHUD_Base H, EGameButtons Button )
{
	if( MainPlayerInput.IsInputFiltered(Button) )
	{
		H.Canvas.SetDrawColor( 255, 0, 0, 255 );
	}
	else
	{
		H.Canvas.SetDrawColor( 0, 255, 0, 255 );
	}
	DrawDebugText( H, Button$":"@MainPlayerInput.PollInputBuffer( Button ));
}

exec function DebugMelee()
{
	bDebugMelee = !bDebugMelee;
	MyNanoHud.SetDebugDraw(DebugDraw_Melee, bDebugMelee);
}

function DebugDraw_Melee(NanoHUD_Base H)
{
	local Canvas	Canvas;
	local vector	CamLoc;
	local rotator	CamRot, CamYawRot;
	local NanoWeap_Melee Weap;
	local float		DrawX, DrawY, BoxSize, ArmLength;
	local Vector	VectToTarget, X, Y, Z;
	local int i, j, Cnt;
	local float RatingPct, BestRating;
	local Controller C;
	local NanoAI AI;
	local Pawn P;
	local array< class<BoidMovementRule> > Rules;
			
	GetActorEyesViewPoint(CamLoc,CamRot);
	Canvas = H.Canvas;

	Canvas.Font = class'Engine'.Static.GetLargeFont();
	Canvas.SetDrawColor(0, 255, 0, 255);
	Canvas.SetPos(Canvas.SizeX * 0.05f, Canvas.SizeY * 0.05f);

	DebugTextMaxLen = 0.f;

	if( MyNP == None )
		return;
	Weap = NanoWeap_Melee(MyNP.Weapon);
	if( Weap == None )
		return;
	
	Canvas.SetDrawColor(0, 255, 0, 255);
	DrawDebugText( H, " DesiredAttackName:"@Weap.DesiredAttackName );
	DrawDebugText( H, " LastAttackName:"@Weap.LastAttackName );
	Canvas.SetDrawColor(255, 0, 0, 255);
	DrawDebugText( H, " ------------------COMBO INPUT------------------" );
	DrawDebugText( H, " RawJoyUp:"@Weap.ComboInput.RawJoyUp@"RawJoyRight"@Weap.ComboInput.RawJoyRight );
	DrawDebugText( H, " ButtonPressed:"@Weap.ComboInput.ButtonPressed );
	DrawDebugText( H, " AttackDir:"@Weap.ComboInput.AttackDir );
	DrawDebugText( H, " ComboDir:"@Weap.ComboInput.ComboDir );
	DrawDebugText( H, " ButtonPressed:"@Weap.ComboInput.ButtonPressed );
	Canvas.SetDrawColor(0, 0, 255, 255);
	DrawDebugText( H, " ------------------TARGET------------------" );
	DrawDebugText( H, " PendingComboTargetedActor:"@Weap.PendingComboTargetedActor@"Dist"@Weap.GetDistFromTargt( Weap.PendingComboTargetedActor ) );
	DrawDebugText( H, " ComboTargetedActor:"@Weap.ComboTargetedActor@"Dist"@Weap.GetDistFromTargt( Weap.ComboTargetedActor ) );
	DrawDebugText( H, " LastTargetedActor:"@Weap.LastTargetedActor );	
	DrawDebugText( H, " TargetedActor:"@TargetedActor );

	BoxSize = 5.f;
	ArmLength = 50.f;

	DrawX = Canvas.ClipX * 0.5f - 50.f;
	DrawY = Canvas.ClipY * 0.15f;
	Canvas.SetPos( DrawX, DrawY );
	Canvas.SetDrawColor( 255, 255, 255 );
	DrawDebugText( H, " Stick Input" );
	Canvas.SetDrawColor( 255, 0, 0 );
	DrawDebugText( H, " Targets" );

	DrawX = Canvas.ClipX * 0.5f  - (BoxSize * 0.5f);
	DrawY = Canvas.CurY + ArmLength * 1.2f;
	Canvas.SetPos( DrawX, DrawY );
	Canvas.SetDrawColor( 255, 255, 255, 255 );
	Canvas.DrawRect( BoxSize, BoxSize );
	DrawX += (BoxSize * 0.5f);
	DrawY += (BoxSize * 0.5f);

	// DRAW INPUT
	Canvas.Draw2DLine( DrawX, DrawY, DrawX + (PlayerInput.RawJoyRight * ArmLength), DrawY - (PlayerInput.RawJoyUp * ArmLength), MakeColor(255, 255, 255, 255) );
	Canvas.Draw2DLine( DrawX, DrawY, DrawX + (RemappedJoyRight * ArmLength), DrawY - (RemappedJoyUp * ArmLength), MakeColor(128, 128, 128, 255) );

	// DRAW TARGET INFO
	if( !MyNP.bIsDoingMeleeAttack )
	{
		UpdateDebugMeleeTargets();
	}
	
	CamYawRot.Yaw = CamRot.Yaw;
	GetAxes( CamYawRot, X, Y, Z );
	for( i = 0; i < DebugMeleeTargets.Length; i++ )
	{
		RatingPct = 1.f - (i / float(DebugMeleeTargets.Length));

		VectToTarget = DebugMeleeTargets[i].Target.Location - MyNP.Location;
		VectToTarget.Z = 0;
		VectToTarget = Normal(VectToTarget);
		Canvas.Draw2DLine( DrawX, DrawY, DrawX + ((Y DOT VectToTarget) * ArmLength * RatingPct), DrawY - ((X DOT VectToTarget) * ArmLength * RatingPct), MakeColor(255, 0, 0, 255) );
	}

	// DRAW PAWN ROTATION INFO
	DrawX = Canvas.ClipX * 0.5f - 50.f;
	DrawY = Canvas.CurY + ArmLength * 1.25f;
	Canvas.SetPos( DrawX, DrawY );
	Canvas.SetDrawColor( 0, 255, 0 );
	DrawDebugText( H, " Pawn Desired Rot:"@MyNP.DesiredRotation );
	Canvas.SetDrawColor( 0, 0, 255 );
	DrawDebugText( H, " Pawn Rot:"@MyNP.Rotation );

	DrawX = Canvas.ClipX * 0.5f  - (BoxSize * 0.5f);
	DrawY = Canvas.CurY + ArmLength * 1.2f;
	Canvas.SetPos( DrawX, DrawY );
	Canvas.SetDrawColor( 255, 255, 255, 255 );
	Canvas.DrawRect( BoxSize, BoxSize );
	DrawX += (BoxSize * 0.5f);
	DrawY += (BoxSize * 0.5f);
	
	VectToTarget = Vector( MyNP.DesiredRotation );
	VectToTarget.Z = 0;
	VectToTarget = Normal(VectToTarget);
	Canvas.Draw2DLine( DrawX, DrawY, DrawX + ((Y DOT VectToTarget) * ArmLength), DrawY - ((X DOT VectToTarget) * ArmLength), MakeColor(0, 255, 0, 255) );

	VectToTarget = Vector( MyNP.Rotation );
	VectToTarget.Z = 0;
	VectToTarget = Normal(VectToTarget);
	Canvas.Draw2DLine( DrawX, DrawY, DrawX + ((Y DOT VectToTarget) * ArmLength), DrawY - ((X DOT VectToTarget) * ArmLength), MakeColor(0, 0, 255, 255) );

	// DRAW ATTACKER INFO
	DrawX = Canvas.ClipX * 0.75f - 50.f;
	DrawY = Canvas.ClipY * 0.15f - 15.f;
	Canvas.SetPos( DrawX, DrawY );
	Canvas.SetDrawColor( 255, 0, 0 );
	DrawDebugText( H, " Potential Attackers" );
	Canvas.SetDrawColor( 0, 255, 0 );
	DrawDebugText( H, " Likely Attackers" );
	Canvas.SetDrawColor( 255, 255, 255 );
	DrawDebugText( H, " Active Attackers" );
	
	DrawX = Canvas.ClipX * 0.75f  - (BoxSize * 0.5f);
	DrawY = Canvas.CurY + ArmLength * 1.25f;
	Canvas.SetPos( DrawX, DrawY );
	Canvas.SetDrawColor( 255, 255, 255, 255 );
	Canvas.DrawRect( BoxSize, BoxSize );
	DrawX += (BoxSize * 0.5f);
	DrawY += (BoxSize * 0.5f);

	UpdateDebugMeleeAttackers();
	Cnt = -1;
	for( i = 0; i < DebugMeleeAttackers.Length; i++ )
	{
		if( Cnt < 0 || DebugMeleeAttackers[i].Rating < BestRating )
		{
			BestRating = DebugMeleeAttackers[i].Rating;
			Cnt++;
		}
		RatingPct = 1.f - (Cnt / float(DebugMeleeAttackers.Length));

		VectToTarget = DebugMeleeAttackers[i].Target.Location - MyNP.Location;
		VectToTarget.Z = 0;
		VectToTarget = Normal(VectToTarget);
		Canvas.Draw2DLine( DrawX, DrawY, DrawX + ((Y DOT VectToTarget) * ArmLength * RatingPct), DrawY - ((X DOT VectToTarget) * ArmLength * RatingPct), (Cnt == 0) ? MakeColor(0, 255, 0, 255) : MakeColor(255, 0, 0, 255) );
	}
	for( i = 0; i < MyNP.ActiveAttackerList.Length; i++ )
	{
		C = MyNP.ActiveAttackerList[i];
		if( C != None )
		{
			VectToTarget = C.Pawn.Location - MyNP.Location;
			VectToTarget.Z = 0;
			VectToTarget = Normal(VectToTarget);
			Canvas.Draw2DLine( DrawX, DrawY, DrawX + ((Y DOT VectToTarget) * ArmLength), DrawY - ((X DOT VectToTarget) * ArmLength), MakeColor(255, 255, 255, 255) );
		}
	}

	for( i = 0; i < DebugMeleeAttackers.Length; i++ )
	{
		P = Pawn(DebugMeleeAttackers[i].Target);
		if( P == None ) 
			continue;
		AI = NanoAI(P.Controller);
		if( AI == None )
			continue;

		for( j = 0; j < AI.BoidRules.Length; j++ )
		{
			if( AI.BoidRules[j].bActive )
			{
				if( Rules.Find( AI.BoidRules[j].Class ) < 0 )
				{
					AI.BoidRules[j].DrawDebugInfo( H );
					Rules.AddItem( AI.BoidRules[j].Class );
				}
			}
		}
	}
	for( i = 0; i < MyNP.ActiveAttackerList.Length; i++ )
	{
		AI = MyNP.ActiveAttackerList[i];
		if( AI == None )
			continue;

		for( j = 0; j < AI.BoidRules.Length; j++ )
		{
			if( AI.BoidRules[j].bActive )
			{
				if( Rules.Find( AI.BoidRules[j].Class ) < 0 )
				{
					AI.BoidRules[j].DrawDebugInfo( H );
					Rules.AddItem( AI.BoidRules[j].Class );
				}
			}
		}
	}
}

final function UpdateDebugMeleeTargets()
{
	local Actor A;
	local TargetSortInfo NewTarget;
	local Vector CamLoc;
	local Rotator CamRot;
	local Rotator RotFromLeftStick;

	local array<Actor> TargetableWithinMaxRange;

	TargetableWithinMaxRange = NanoGRI(WorldInfo.GRI).FindAllNanoInterface_TargetableAroundPlayerPawn( MyNP, 4096 );

	GetActorEyesViewPoint(CamLoc,CamRot);

//	`log( `location, bDebug );

	DebugMeleeTargets.Length = 0;

	foreach TargetableWithinMaxRange(A)
	{
		// if not our pawn
		if( A != Pawn && NanoPawn(A) != None )
		{
			NewTarget.Target = A;
			RotFromLeftStick = GetDirFromLeftStick( CamRot, TRUE );
			NewTarget.Rating = MeleeStickRateTarget( A, CamLoc, RotFromLeftStick, 1024.f, -1.f );
			if( NewTarget.Rating > 0.f )
			{
				DebugMeleeTargets.AddItem(NewTarget);
			}
		}
	}
	DebugMeleeTargets.Sort(TargetSort);
}

final function UpdateDebugMeleeAttackers()
{
	local TargetSortInfo NewTarget;
	local NanoAI AI;
	local int Idx;

//	`log( `location, bDebug );

	DebugMeleeAttackers.Length = 0;
	for( Idx = 0; Idx < MyNP.AttackerList.Length; Idx++ )
	{
		AI = MyNP.AttackerList[Idx];
		if( AI != None )
		{
			NewTarget.Target = AI.Pawn;
			NewTarget.Rating = AI.RateAttacker( MyNP, TRUE );
			if( NewTarget.Rating > 0.f )
			{
				DebugMeleeAttackers.AddItem(NewTarget);
			}
		}
	}

	DebugMeleeAttackers.Sort(TargetSort);
}

exec function SpawnDebugCamera()
{
	if( DebugCam == None )
	{
		// Spawn a debug camera with us as the owner...the camera's PBP() will handle resetting view targets
		DebugCam = Spawn(class'NanoDebugCameraActor', self,,,,,TRUE);
	}
}

function EndDebugCamera()
{
	if( DebugCam != None )
	{
		DebugCam.EndDebugCamera();
	}
}


exec function TestMusic( EMusicEvents InEvent )
{
	MusicManager.HandleMusicEvent( InEvent );
}

function OnToggleIris( SeqAct_ToggleIris Action )
{
	if (Action.InputLinks[0].bHasImpulse)
	{
		bIRISActive = TRUE;
	}
	else if (Action.InputLinks[1].bHasImpulse)
	{
		bIRISActive = FALSE;
	}
	else
	{
		bIRISActive = !bIRISActive;
	}

	// If specified, play a new movie
	if( (Action.MovieToPlay != None) && (MyNanoHUD.IRISTextureMovie != Action.MovieToPlay) )
	{
		MyNanoHUD.IRISTextureMovie = Action.MovieToPlay;
		// Stop in order to ensure that we play the movie from the beginning
		MyNanoHUD.IRISTextureMovie.Stop();
	}
}

function SetGoreCameraTarget(NanoPawn NewTarget, optional name NewTargetBone)
{
	if( NewTarget != None )
	{
		MyNP.GoreCamTarget = NewTarget;
		MyNP.GoreCamTargetBoneName = NewTargetBone;
	}
}

function ClearGoreCameraTarget()
{
	MyNP.GoreCamTarget = None;
	MyNP.GoreCamtargetBoneName = '';
}

event MayFall(bool bFloor, vector FloorNormal)
{
	local vector HitLocation, HitNormal;

	// if we have a clamped base and can't find it straight down, reverse the move so we don't fall
	if ( MyNP != None && MyNP.ClampedBase != None &&
		!TraceComponent(HitLocation, HitNormal, MyNP.ClampedBase.CollisionComponent, Pawn.Location - vect(0,0,1000), Pawn.Location, Pawn.GetCollisionExtent() * vect(0.5,0.5,1)) )
	{
		Pawn.bCanJump = false;
	}
}

function SwitchToWeapon(class<NanoWeaponBase> WeapClass, optional delegate<NanoPawn.WeaponFinishedSummoning> OnFinish, optional bool bForced)
{
	// Don't allow weapon switch while running with tackle victim, riding a car, or in cinematic mode
	if( (MyNP.InteractionPawn != None && MyNP.InteractionType != PAWNINTER_Pin) || MyNP.IsAttachedToPerch() || (bCinematicMode && !bForced) )
	{
		`warn( "Not allowed to switch weapons due to some flag / state" );
		return;
	}

	if(MyNP.Weapon == None || MyNP.Weapon.Class != WeapClass )
	{
		if( MyNP.Weapon == None || NanoWeapon(MyNP.Weapon).CanSwitchAwayFromWeapon() == TRUE || bForced == TRUE )
		{
			if (!MyNP.bSummoningInProgress)
			{
				MyNP.SummonWeapon(WeapClass,OnFinish);
			}
			else if (MyNP.PendingWeaponClass == WeapClass)
			{
				MyNP.WeaponFinishedSummoning = OnFinish;
			}
		}
	}
	else
	{
		if (OnFinish != None)
		{
			OnFinish();
		}
	}
}

function QuickSwitchUtilityPlan(EDirection InDir)
{
	local NanoPRI NPRI;

	NPRI = GetPRI();

	if(InDir == DIR_Up)
	{
		NPRI.EquipNanoPlan(NPRI.QuickBindPlans[0]);
	}
	else if(InDir == DIR_Down)
	{
		NPRI.EquipNanoPlan(NPRI.QuickBindPlans[1]);
	}
	else if(InDir == DIR_Left)
	{
		NPRI.EquipNanoPlan(NPRI.QuickBindPlans[2]);
	}
	else if(InDir == DIR_Right)
	{
		NPRI.EquipNanoPlan(NPRI.QuickBindPlans[3]);
	}

	// Note when we last changed plan, so we can show the options
	MyNanoHud.LastChangeUtilityPlanTime = WorldInfo.TimeSeconds;
}



function QuickSwitchWeaponPlan(EDirection InDir)
{
	local NanoPRI NPRI;

	NPRI = GetPRI();

	if(InDir == DIR_Up)
	{
		NPRI.EquipNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_HeavyRevolver", class'Class')) );
	}
	else if(InDir == DIR_Down)
	{
		NPRI.EquipNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_SemiAutoPistol", class'Class')) );
	}
	else if(InDir == DIR_Left)
	{
		NPRI.EquipNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_HoldOutPistol", class'Class')) );
	}
	else if(InDir == DIR_Right)
	{
		NPRI.EquipNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_HandCannon", class'Class')) );
	}

	// Note when we last changed plan, so we can show the options
	MyNanoHud.LastChangeUtilityPlanTime = WorldInfo.TimeSeconds;
}



/** 
 * So this will determine which sounds we should play based on if we are entering or exiting various spatial structures in the world.
 **/
final function TickResponseSystemSoundSystem()
{
	local bool bWasInsideConfrontRadius;

	local NanoGRI NGRI;
	local ChaosPacifismManager CM;


	bWasInsideConfrontRadius = bInsideConfrontRadius;

	NGRI = NanoGRI(WorldInfo.GRI);
	CM = NGRI.GetCurrentChaosManager();

	if( ( CM != None ) && ( CM.GetChaosLevel() > 0 ) )
	{
		bInsideConfrontRadius = !CM.ThereAreNoAIWithinConfrontPossibleThreatQuery();

		if( bInsideConfrontRadius == TRUE )
		{
			// play this sound every few seconds
			if( IsTimerActive( nameof(PlayWithinConfrontRadiusSound) ) == FALSE )
			{
				SetTimer( 3.0f + FRand() * 3.0f , FALSE, nameof(PlayWithinConfrontRadiusSound) );
			}
		}

		// if we are inside then we don't get to turn on escaping nor hiding music
		if( bInsideConfrontRadius == FALSE )
		{
			// check to see if you are hiding
			if( NGRI.NED.IsPlayerDoing( 'Hiding') == TRUE )
			{
				//`log( "OH HIDING!!" );
				NGRI.GetMusicManager().HandleMusicEvent( EME_PlayerHiding );
			}
			// check to see if you are escaping
			else if( NGRI.NED.IsPlayerDoing( 'Escaping') == TRUE )
			{
				//`log( "OH ESCAPING!!" );
				NGRI.NRSAM.PlayEvent( ENRS_Dispatcher_RebelIsEscaping, None );
				NGRI.GetMusicManager().HandleMusicEvent( EME_PlayerEscaping );	
			}
		}

	}

	// if you were inside and now are now are out then play 
	if( ( bWasInsideConfrontRadius == TRUE ) && ( bInsideConfrontRadius == FALSE ) )
	{
		//`log( "CR INSIDE AND NOW OUT" );
		NGRI.NRSAM.PlayEvent( ENRS_ConfrontRadius_Leave, None );

	}

	// if you were not inside and now are then play
	if( ( bWasInsideConfrontRadius == FALSE ) && ( bInsideConfrontRadius == TRUE ) )
	{
		//`log( "CR OUTSIDE AND NOW IN" );
		NGRI.NRSAM.PlayEvent( ENRS_ConfrontRadius_Enter, None );
	}

	// so sometimes an AI will be firing / attacking / doing something crazy and chaos will end
	// but their actions cause EME_CombatStarts to fire off.
	// so since we have a nice race condition there we will have a check here
	if( ( NGRI.GetMusicManager().CurrMusicEventID == EME_CombatStarts ) 
		&& ( CM.GetChaosLevel() == 0 )
		)
	{
		`warn( "We had no chaos but combat music was playing.  FORCIBLY stoppping it. ");

		ChaosStopped();
		NGRI.GetMusicManager().HandleMusicEvent( EME_CombatEnds );
		NGRI.GetNanoPC().SetSoundMode( 'Default' );
	}


	TickPacManHack();
}


function TickPacManHack()
{
	local NanoGRI NGRI;
	local NanoPC NPC;
	local vector PlayerLocation;

	local bool bInsideHotZone;
	
	local ChaosPacifismManager CM;


	NGRI = NanoGRI(WorldInfo.GRI);
	NPC = NGRI.GetNanoPC();

	if( NPC.Pawn == None )
	{
		return;
	}


	PlayerLocation = NPC.Pawn.Location;

	if( ( VSize(PlayerLocation-NGRI.NPES.Cloud_PacManCenter) < NGRI.NPES.GetHotZoneRadius() ) )
	{
		bInsideHotZone = TRUE;
	}

	if( bInsideHotZone == TRUE )
	{
		return;
	}


	CM = NGRI.GetCurrentChaosManager();

	if( ( CM != None ) && ( CM.GetChaosLevel() > 0 ) )
	{
		bInsideConfrontRadius = !CM.ThereAreNoAIWithinConfrontPossibleThreatQuery_AI();

		if( bInsideConfrontRadius == TRUE )
		{
			NGRI.NPES.UpdateHotZoneLocation();
		}
	}

}

function PlayWithinConfrontRadiusSound()
{
	NanoGRI(WorldInfo.GRI).NRSAM.PlayEvent( ENRS_ConfrontRadius_StandingIn, None );
}


function ChaosStarted()
{
	NanoGRI(WorldInfo.GRI).NRSAM.PlayEvent( ENRS_Chaos_Starts, None );

	if( AC_ChaosIsActive == None )
	{
		AC_ChaosIsActive = new(self) class'AudioComponent';
		//NanoGRI(WorldInfo.GRI).NRSAM.PlayEvent(  );
		//AC_ChaosIsActive.SoundCue = ;
		AC_ChaosIsActive.bAllowSpatialization = FALSE;
		AttachComponent( AC_ChaosIsActive );
	}
	AC_ChaosIsActive.FadeIn( 0.25f, 1.0f );

}


function ChaosStopped()
{
	// we prob do not want both of these playing at once
// 	NanoGRI(WorldInfo.GRI).NRSAM.PlayEvent( ENRS_Chaos_Ends, None );
// 	NanoGRI(WorldInfo.GRI).NRSAM.PlayEvent( ENRS_Dispatcher_RebelHasEscaped, None );
	NanoGRI(WorldInfo.GRI).GetMusicManager().HandleMusicEvent( EME_PlayerEscaped );

	if( AC_ChaosIsActive != None )
	{
		AC_ChaosIsActive.FadeOut( 0.25f, 0.0f );
	}
}


/** we override our sound mode setting to handle all our special needs **/
simulated function SetSoundMode( Name InSoundModeName )
{

	// check to see if we are not already in a mutually exclusive mode
	if( ( InSoundModeName == 'Combat_Dispatch' ) || ( InSoundModeName == 'Combat_ChaosAnnounce'  ) )
	{
			if( CurrentSoundMode == '' )
			{

			}
	}


	Super.SetSoundMode( InSoundModeName );
}


simulated function ChaosAnnounceSoundMode( float SoundModeDuration )
{
	SavedChaosAnnounceSoundMode = CurrentSoundMode;

	SetSoundMode( 'Combat_ChaosAnnounce' );

	if( SoundModeDuration != 0.0f )
	{
		SetTimer( SoundModeDuration, FALSE, nameof(RestoreFromChaosAnnounceSoundMode) );
	}
}


simulated function RestoreFromChaosAnnounceSoundMode()
{
	//`log( "RestoreFromChaosAnnounceSoundModeRestoreFromChaosAnnounceSoundModeRestoreFromChaosAnnounceSoundModeRestoreFromChaosAnnounceSoundModeRestoreFromChaosAnnounceSoundMode");
	//ScriptTrace();
	 SetSoundMode( SavedChaosAnnounceSoundMode );
}


/** This will reload all of the config files into the game so you can tweak values and see their results in game. **/
native exec function ReloadAllConfigFiles();

/** check to see if the player is on a navmesh which is considered bRooftop **/
final native function bool IsOnRoofTop() const;

function bool CanGainEXP()
{
	if( ( bInfiniteNanoPower == FALSE ) && ( bGodMode == FALSE ) )
	{
		return TRUE;
	}

	return FALSE;
}


exec function MCPTestGet()
{
	local NanoGRI GRI;
	local String foo, bar, key;


	GRI = NanoGRI(WorldInfo.GRI);

	foo = class'NanoTypes'.static.GetLocalPlayerUserName(); // "NewParent";
	bar = "NewKey2";

	GRI.MCP.DownloadFromMCP( foo, bar, key, self, 'TestCallBack' );
}


exec function MCPTestSet( optional string NewValue )
{
	local NanoGRI GRI;
	local MCPDatum Datum;
	local vector randval;

	GRI = NanoGRI(WorldInfo.GRI);


	randval = VRand();

	Datum.ID = class'NanoTypes'.static.GetLocalPlayerUserName(); // "NewParent";
	Datum.Key = "NewKey2";
	Datum.Value = String(randval); // "Frazzle0" ;
	if( NewValue != "" )
	{
		Datum.Value = NewValue;
	}


	GRI.MCP.UploadToMCP( Datum );
}

/** Post this players status string to the feed */
exec function NanoStatus(string NewStatus)
{
	if( NewStatus != "" )
	{
		NanoGRI(WorldInfo.GRI).MCP.UpdateLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.Status, NewStatus );

		MyNanoHUD.SlideTextMessage("Status Updated!", 1.5, class'Engine'.static.GetMediumFont(), None);
	}
}

/** Make a 'deal' with the company specified */
exec function NanoDeal(string NewCompany)
{
	NanoGRI(WorldInfo.GRI).MCP.UpdateLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.MadeDealWith, NewCompany );

	MyNanoHUD.SlideTextMessage("Deal Updated!", 1.5, class'Engine'.static.GetMediumFont(), None);
}

event TestCallBack( const out string Value )
{
	`log( self @ "TestCallBack" @ `showvar(Value) );
}


exec function TestProcMissions( bool bShouldTest )
{
	NanoGRI(WorldInfo.GRI).bTestProcMissions = bShouldTest;
}


exec function MCPPopulateData()
{
	NanoGRI(WorldInfo.GRI).MCP.UpdateLocalMCPDatum( "", class'NanoMCPKeys'.default.MOTD, "Hello Martin" );
	NanoGRI(WorldInfo.GRI).MCP.UpdateLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.NumHeadShots, "5" );
	NanoGRI(WorldInfo.GRI).MCP.UpdateLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.NumKills, "100" );
	NanoGRI(WorldInfo.GRI).MCP.UpdateLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.Currency, "666" );
	NanoGRI(WorldInfo.GRI).MCP.UpdateLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.EXP, "13" );

	//NanoGRI(WorldInfo.GRI).MCP.UploadAllDataToServer();
}

exec function MCPDump()
{
	NanoGRI(WorldInfo.GRI).MCP.DumpLocalCacheToLog();
}

exec function MCPTest()
{
	//NanoGRI(WorldInfo.GRI).MCP.UpdateRebelHandPrintsInWorld();
}


// much like blur's previously on blur
function CheckForPreviouslyOnNano()
{
	// don't show this in PIE to save the sanity of LDs :-)
	if( WorldInfo.IsPlayInEditor() == TRUE )
	{
		return;
	}

	//NanoGRI(WorldInfo.GRI).NTM.HandleTutorialEvent( EET_SomeoneGrabbedYourRebelHandPrint, 1 );


	// check to see if we have received our daily reward
	CheckForDailyReward();

	// check for Super Bomb!!
	SetTimer( 5.0f, TRUE, nameof(CheckForRebelSuperBomb) );

	// assurance game checking
	DoAssuranceGameChecking();

}


function CheckForRebelSuperBomb()
{
	local string UserName;
	local String CurrValueString;
	local NanoMCP MCP;

	MCP = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).MCP;
	UserName = "";


	MCP.FindStringValue( UserName, class'NanoMCPKeys'.default.RebelSuperBombForge_FoundBy, CurrValueString );

	// if I am NOT the one who found this bail out
	if( CurrValueString != class'NanoTypes'.static.GetLocalPlayerUserName() )
	{
		//`log( "User who found the RebelSuperBomb is not us" @ `showvar(CurrValueString) );
		return;
	}

	// so I am the one that found it.
	
	// has my mobile friend unlocked it yet?
	MCP.FindStringValue( UserName, class'NanoMCPKeys'.default.RebelSuperBombForge_BombState, CurrValueString ); // looking to see if mobile sent a decrypted Bomb back

	// if it has not been unlocked
	if( ( CurrValueString == "WaitingForDetonation" ) )
	{
		// check to make certain we don't already have the Bomb
		if( GetPRI().FindNanoPlan( class'NanoPlan_RebelSuperBomb' ) == INDEX_NONE )
		{
			`log( "OH YESSS SUPER Bomb TIME!!" );
			// give me the super Bomb!
			GetPRI().GiveNanoPlan( class'NanoPlan_RebelSuperBomb', TRUE );
			NanoGRI(WorldInfo.GRI).NTM.HandleTutorialEvent( EET_SuperRebelBomb_UnlockedByMobile, 1 );
		}
	}




}



function CheckForDailyReward()
{
	local string UserName;
	local String CurrValueString;
	local NanoMCP MCP;

	UserName = class'NanoMCPKeys'.default.MobileUserID; //class'NanoTypes'.static.GetLocalPlayerUserName();

	MCP = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).MCP;


	MCP.FindStringValue( UserName, class'NanoMCPKeys'.default.DailyPlayChoice_ReceivedReward, CurrValueString );


	if( CurrValueString == "Yes" )
	{
		`log( "Daily Reward" @ "we have already received our reward" );
		return;
	}


	`log( `showvar(UserName) );

	// we have not received it let's look for our choice

	MCP.FindStringValue( UserName, class'NanoMCPKeys'.default.DailyPlayChoice_Chose, CurrValueString );


	if( CurrValueString == "12Nano" )
	{
		MyNP.AddNanoBuckets( 12 );
		NanoGRI(WorldInfo.GRI).NTM.HandleTutorialEvent( EET_DailyPlay_12Nano, 1 );
		MCP.UpdateLocalMCPDatum( UserName, class'NanoMCPKeys'.default.DailyPlayChoice_ReceivedReward, "Yes" );
	}
	else if( CurrValueString == "2ForgeCores" )
	{
		MyNP.AddNanoForgeCoreBuckets( 2 );
		NanoGRI(WorldInfo.GRI).NTM.HandleTutorialEvent( EET_DailyPlay_2ForgeCores, 1 );
		MCP.UpdateLocalMCPDatum( UserName, class'NanoMCPKeys'.default.DailyPlayChoice_ReceivedReward, "Yes" );
	}
	else
	{
		`warn( "Bogus DailyPlay string" @ `showvar(CurrValueString) );
	}


}



function DoAssuranceGameChecking()
{
	local string UserName;
	local String CurrValueString;

	UserName = class'NanoTypes'.static.GetLocalPlayerUserName();

	NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).MCP.FindStringValue( UserName, class'NanoMCPKeys'.default.CurrentAssuranceGame, CurrValueString );


	if( CurrValueString != "" )
	{
		// check to see if our partner has completed their end of the game
		NanoGRI(WorldInfo.GRI).NCM.UpdateAssuranceGames( ECET_None );
	}
}


// hack to make pausing actually be called able from a keystroke
exec function PauseIt()
{
	ServerPause();
}

/**
 * Returns true if there is enough space to play the camera anim
 */
simulated native final function bool	CameraAnimHasEnoughSpace( CameraAnim Anim, optional float  Scale = 1.f );



defaultproperties
{
	CameraClass=class'NanoPlayerCamera'
	CheatClass=class'NanoCheatManager'
	SavedMoveClass=class'NanoSavedMove'

	InputClass=class'NanoPlayerInput'

	CurrControlScheme=ECS_Mage

	MinHitWall=0.0 // Allow NotifyHitWall/HitWall

	MaxTargetableDistance=4096.0f

	ActiveJuggleDuration=1.0
	ActiveJuggleRecoveryDuration=0.5

	InputRequests(0)=(Inputs=((Type=IT_YAxis,Action=IMA_GreaterThan,Value=0.99f),(Type=IT_YAxis,Action=IMA_LessThan,Value=0.99f)),MatchDelegate=NanoPC.UpStickFlick);
	InputRequests(1)=(Inputs=((Type=IT_YAxis,Action=IMA_LessThan,Value=-0.99f),(Type=IT_YAxis,Action=IMA_GreaterThan,Value=-0.99f)),MatchDelegate=NanoPC.DownStickFlick);
	InputRequests(2)=(Inputs=((Type=IT_XAxis,Action=IMA_GreaterThan,Value=0.99f),(Type=IT_XAxis,Action=IMA_LessThan,Value=0.99f)),MatchDelegate=NanoPC.RightStickFlick);
	InputRequests(3)=(Inputs=((Type=IT_XAxis,Action=IMA_LessThan,Value=-0.99f),(Type=IT_XAxis,Action=IMA_GreaterThan,Value=-0.99f)),MatchDelegate=NanoPC.LeftStickFlick);

	bNotifyFallingHitWall=TRUE

	bInfiniteNanoPower=FALSE
}

