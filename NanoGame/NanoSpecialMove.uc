/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoSpecialMove extends GameSpecialMove
	config(Pawn)
	native(SpecialMoves)
	abstract;

/** Cached NanoPawn that owns this special move */
var protected transient NanoPawn    MyNP;
var protected transient NanoAI	    MyAI;
var protected transient NanoPC      MyPC;

var() class<NanoAICmd_SpecialMoveStub>	AICommandClass;
var() NanoAICmd_SpecialMoveStub			AICommand;

/*
 * indicates that the client and server should update this move independently, without synchronizing position or timing,
 * while this move is in progress, correcting if necessary only after the entire move has been completed
 */
var const bool bUseUnsynchedServerMove;

/*
 * indicates whether this move should skip the physics simulation in TickSimulated.  Useful when needing to lock a pawn into
 * a certain physics, since Pawn::TickSimulated() attempts to guess at the best physics to use
 */
var const bool bSkipSimulatedPhysics;

/*
 * indicates whether or not the clients (local and remote) should ignore server replicated bases while doing the special move.
 * Useful for moves where base changes happen after animations are complete, to keep the pawn from skipping around.
 * ONLY use this if you can ensure that when the special move is over, the bases will be synched!!!
 */
var const bool bIgnoreServerBaseChange;

/*
 * indicates whether or not this special move should force the orbit camera (if active) to use the traditional camera origin interpolation
 * code instead of trying trashing the origin data and attempting to keep the camera orbiting around the pawn
 */
var const bool bSkipOrbitCameraBlend;

/*
 * indicates whether this special move should skip MeshTranslationOffset blending in NanoPawn::UpdateMesh().  Useful if we need to lock in
 * an offset for the duration of the special move.  SetMeshTranslationOffset() will still work, but it will not be blended back to the default
 */
var const bool bLockMeshTranslationOffset;

/** Whether player should update desired rotation while in this special move */
var bool bUpdatePlayerDesiredRotation;

/////////////// Surface Orientation
/** Do standard floor conform. That is keeping upper body normal, and rotating and moving feet IK. */
var const bool		bDoIKFloorConform;
/** Alternate version where full Mesh rotation is conformed to the ground. */
var const bool		bDoMeshFloorConform;
/** Enable foot placement component of floor conform */
var			bool	bDoFootPlacement;

/** Running speed/animation play rate modifier */
var() protected const config float SpeedModifier;

/** Disable movement (but doesn't necessarily stop physics, just blocks inputs). */
var	protected const			    bool	bDisableMovement;
var transient privatewrite		bool	bMovementDisabled;

/** Whether to make on the pawn that we are disabling all boids **/
var	protected const			    bool	bDisableAllBoids;
var protected transient         bool    bSavedDisableAllBoids;

/** Scale factor for root motion. To fix up issues of the pawn mesh being scaled and causing it to move too far */
var float RootMotionScaleFactor;


/** TRUE if playing a camera anim */
var transient protected bool bPlayingCameraAnim;

/** This is the camera animation to play when this special move starts **/
var CameraAnim CameraAnimToPlayWhenStartingThisSpecialMove;


function InitSpecialMove( GamePawn InPawn, Name InHandle )
{
	Super.InitSpecialMove( InPawn, InHandle );
	MyNP = NanoPawn(PawnOwner);
	MyAI = NanoAI(PawnOwner.Controller);
	MyPC = NanoPC(PawnOwner.Controller);
}


/**
 * By Default we want all special moves to be interruptible by HitReactions / Hit Reaction type SpecialMoves
 **/
function bool CanOverrideMoveWith( Name NewMove )
{
	if( NewMove == 'NSM_Melee_HitReaction' )
	{
		return TRUE;
	}

	if( NewMove == 'NSM_StunnedAndDazed_AI' )
	{
		return TRUE;
	}

	return Super.CanOverrideMoveWith( NewMove );
}


function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	local NanoAICmd_SpecialMoveStub AIOwnerActiveCommand;
	local NanoAI AI;

	Super.SpecialMoveStarted( bForced, PrevMove );
	
	AI = NanoAI(PawnOwner.Controller);

	// Reset variables
	bPlayingCameraAnim = FALSE;

	// Push AICommand if it is defined.
	if( AI != None && AICommandClass != None && MyAI.Pawn != None )
	{
		AIOwnerActiveCommand = NanoAICmd_SpecialMoveStub(MyAI.GetActiveCommand());

		if( AIOwnerActiveCommand == None || AIOwnerActiveCommand.AllowPushOfDefaultCommandForSpecialMove( MyNP.ActiveSpecialMoveName ) )
		{
			AICommand = AICommandClass.static.PushSpecialMoveCommand(MyAI);
			if( AICommand == None )
			{
				`Warn(PawnOwner.WorldInfo.TimeSeconds @ PawnOwner @ class @ GetFuncName() @ "Failed to push AICommand:" @ AICommandClass);
			}
		}
	}

	// If movement is disabled set acceleration to zero.
	if( bDisableMovement )
	{
		SetMovementLock(TRUE);
	}

	bSavedDisableAllBoids = MyNP.bDisableAllBoids; // save off
	MyNP.bDisableAllBoids = bDisableAllBoids;


	SetUpRootMotionScaling();

	// possibly play a camera animation when starting this special move
	if( CameraAnimToPlayWhenStartingThisSpecialMove != None )
	{
		PlayCameraAnim(MyNP, CameraAnimToPlayWhenStartingThisSpecialMove,,, 0.25f, 0.25f,,,,, TRUE);
	}
}


function SetUpRootMotionScaling()
{
	// NO matter what my scale is always do the same amount of movement when doing the SpecialMove
	// so if a NSM needs to have differing distances based on scale then override this
	RootMotionScaleFactor = default.RootMotionScaleFactor / ( PawnOwner.DrawScale*PawnOwner.Mesh.Scale);

	PawnOwner.Mesh.RootMotionAccelScale.X = RootMotionScaleFactor / PawnOwner.DrawScale3D.X;
	PawnOwner.Mesh.RootMotionAccelScale.Y = RootMotionScaleFactor / PawnOwner.DrawScale3D.Y;
	PawnOwner.Mesh.RootMotionAccelScale.Z = RootMotionScaleFactor / PawnOwner.DrawScale3D.Z;
}


function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	super.SpecialMoveEnded(PrevMove, NextMove);

	// reset the standing still time as otherwise "standing still" special moves will end up having the camera just ZOOOOOM
	// in immediately after the NSM is finished
	MyNP.LastStandingStillTime = MyNP.WorldInfo.TimeSeconds + 3;

	if( NanoPC(PawnOwner.Controller) != None )
	{
		if( bPlayingCameraAnim )
		{
			NanoPC(PawnOwner.Controller).MainPlayerInput.ForcePitchCentering(FALSE);
		}
	}

	// If movement was disabled, toggle it back on
	if( bMovementDisabled )
	{
		SetMovementLock(FALSE);
	}

	MyNP.bDisableAllBoids = bSavedDisableAllBoids; // restore

	// reset
	RestoreRootMotionScaling();

}


function RestoreRootMotionScaling()
{
	RootMotionScaleFactor					= default.RootMotionScaleFactor;
	PawnOwner.Mesh.RootMotionAccelScale		= PawnOwner.default.Mesh.RootMotionAccelScale;
	PawnOwner.Mesh.RootMotionMode			= PawnOwner.default.Mesh.RootMotionMode;
}


/** Gives the special move a chance to intercept and trap input.  Returns TRUE if the input should NOT be passed on */
function bool FilterButtonInput(Name ButtonName,bool bPressed,int ButtonIdx);

function float GetSpeedModifier()
{
	return SpeedModifier;
}

/** Locks or Unlocks Pawn movement */
final function SetMovementLock(bool bEnable)
{
	if( bMovementDisabled != bEnable )
	{
		bMovementDisabled = bEnable;

		if( MyPC != None )
		{
			// enable means SET the movementlock to be active
			if( bEnable == TRUE )
			{
				// stop the pawn's dashing
				MyPC.MyNP.bIsDashing = FALSE;
				MyPC.DisableInput( TRUE, TRUE, FALSE );

				// we might be in between the input reading and PlayerMove(), so we need to zero the inputs
				// to make sure a stray tick of motion doesn't get in
				if( MyPC.PlayerInput != None )
				{
					MyPC.PlayerInput.aForward = 0.f;
					MyPC.PlayerInput.aStrafe = 0.f;
					MyPC.PlayerInput.aUp = 0.f;
				}
			}
			else
			{
				MyPC.EnableInput( TRUE, TRUE, TRUE );
			}
		}

		// Set acceleration to zero
		if( bEnable )
		{
			SetMovementLock_ZeroOutMovementVariables();
		}
	}
}

function SetMovementLock_ZeroOutMovementVariables()
{
	PawnOwner.ZeroMovementVariables();
}


simulated function RootMotionExtracted(SkeletalMeshComponent SkelComp, out BoneAtom ExtractedRootMotionDelta);
	


/** Play a CameraAnim */
function CameraAnimInst PlayCameraAnim
(
 NanoPawn		PawnToPlay,
 CameraAnim		InCameraAnim,
 optional float	Rate=1.f,
 optional float	Scale=1.f,
 optional float	BlendInTime,
 optional float	BlendOutTime,
 optional bool	bLoop,
 optional bool	bRandomStartTime,
 optional float	Duration,
 optional bool	bSingleInstance,
 optional bool bSkipSpaceCheck
 )
{
	local NanoPC	PCToPlay;

	PCToPlay = NanoPC(PawnToPlay.Controller);

	// Only play camera animations on local human players
	if (PCToPlay == None || !PawnToPlay.IsLocallyControlled() || PCToPlay.PlayerCamera == None || InCameraAnim == None)
	{
		return None;
	}

	if (!bSkipSpaceCheck && !PCToPlay.CameraAnimHasEnoughSpace(InCameraAnim, Scale))
	{
		`log("PlayCameraAnim failed CameraAnimHasEnoughSpace:" @ PCToPlay.CameraAnimHasEnoughSpace(InCameraAnim, Scale));
		return None;
	}

	// Set flag so we can cancel force pitch centering at the end.
	// @fixme -- this only works for PCOwner. Need to come up with a better system for any PC
	if( PawnToPlay == PawnOwner )
	{
		bPlayingCameraAnim = TRUE;
	}
	else
	{
		// A little hacky... but should work for what we need.
		if( PawnToPlay.ActiveSpecialMove != None )
		{
			PawnToPlay.ActiveSpecialMove.bPlayingCameraAnim = TRUE;
		}
	}

	// Force pitch centering so camera animation plays properly
	PCToPlay.MainPlayerInput.ForcePitchCentering(TRUE);

	// Play camera animation
	return PCToPlay.PlayerCamera.PlayCameraAnim(InCameraAnim, Rate, Scale, BlendInTime, BlendOutTime, bLoop, bRandomStartTime, Duration, bSingleInstance);
}



defaultproperties
{
	AICommandClass=class'NanoAICmd_SpecialMoveStub'
	RootMotionScaleFactor=1.0f
	bDisableAllBoids=TRUE
}