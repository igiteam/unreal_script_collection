/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPlayerCamera extends GamePlayerCamera
	config(Camera)
	native(Camera);

// NOTE FOR REFERENCE
// >> IS LOCAL->WORLD (no transpose)
// << IS WORLD->LOCAL (has the transpose)

/////////////////////
// Camera Modes
/////////////////////

/** Implements spectator camera. */
var() editinline transient GearSpectatorCamera		SpectatorCam;
/** Implements the debug face-cam, used for previewing FaceFX stuff. */
var() editinline transient GearDebugFaceCamera		DebugFaceCam;
/** Camera for screen shots */
var() editinline transient GearScreenshotCamera	    ScreenshotCam;
/** Main Gameplay camera */
var() transient protectedwrite GearGameplayCamera   GameplayCam;


/////////////////////
// Camera Modifiers
/////////////////////

/** Camera modifier for camera bone animation */
var(Camera) private editinline	CameraModifier	    GearCamMod_CameraBone;


/////////////////////
// Shaky-cam management
/////////////////////

/** The pawn that was last used to cache the animnodes used for shakycam.  Changing viewtarget pawns will trigger a re-cache. */
var protected transient Pawn						ShakyCamAnimNodeCachePawn;
/** AnimNode names for the "standing idle" camera animation. */
var() protected const array<name>					StandingIdleSequenceNodeNames;
/** Cached refs to the standing idle animations. */
var protected transient array<AnimNodeSequence>	StandingIdleSequenceNodes;


cpptext
{
	void AddPawnToHiddenActorsArray( APawn *PawnToHide );
	void RemovePawnFromHiddenActorsArray( APawn *PawnToHide );
};

protected function CacheShakyCamAnimNodes(Pawn TargetPawn)
{
	local SkeletalMeshComponent SkelComp;
	local name TmpName;
	local int NameIdx;

	// cache anim nodes used for shakycam management
//	RoadieRunSequenceNode = SkelComp.FindAnimNode(RoadieRunSequenceNodeName);

	SkelComp = TargetPawn.Mesh;
	if( SkelComp != none )
	{
		StandingIdleSequenceNodes.Length = StandingIdleSequenceNodeNames.Length;
		foreach StandingIdleSequenceNodeNames(TmpName, NameIdx)
		{
			StandingIdleSequenceNodes[NameIdx] = AnimNodeSequence(SkelComp.FindAnimNode(TmpName));
		}
	}

	ShakyCamAnimNodeCachePawn = TargetPawn;
}

 
 function UpdateShakyCam(Pawn TargetPawn)
 {
 	local GearPawn TargetGP;
 	local GearPC GPC;
 	local float StandingIdleWeight;
 	local bool bInCombat;
 	local AnimNodeSequence TmpAnimNode;
 
 	TargetGP = GearPawn(TargetPawn);
 	if (TargetGP == None)
 	{
 		return;
 	}
 	GPC = GearPC(TargetGP.Controller);			// ok to be null
 
 
 	// make sure everything is cached properly
 	// handles target changes, which should be rare
 	if (ShakyCamAnimNodeCachePawn != TargetGP)
 	{
 		CacheShakyCamAnimNodes(TargetGP);
 	}
 
 	// don't do anything to roadie run, actually
 
 	// apply an increased amount of camera bone motion if we've been recently shot at
 	bInCombat = ( TargetGP.WorldInfo.TimeSeconds - TargetGP.LastShotAtTime < 5.0f ) || ( GPC != None && GPC.IsInCombat() );
 
 	// maybe scale back the idle camera anim
 	if (!bInCombat && IsZero(TargetGP.Velocity) && (GPC != None) && Abs(GPC.RemappedJoyRight) < GPC.DeadZoneThreshold && Abs(GPC.RemappedJoyUp) < GPC.DeadZoneThreshold)
 	{
 		// negate the idle shake entirely
 		StandingIdleWeight = 0.f;
 	}
 	else if (TargetGP.IsInAimingPose())
 	{
 		// steadier when aiming
 		// @fixme, this will eventually be set in the AnimTree, and then this can be removed
 		StandingIdleWeight = 0.5f;
 	}
 	else
 	{
 		StandingIdleWeight = 1.f;
 	}
 
 	// @fixme HACK disabled for now, until we can get these working better
 	StandingIdleWeight = 0.f;
 
 	// apply scaling to the nodes in question.
 	foreach StandingIdleSequenceNodes(TmpAnimNode)
 	{
 		if (TmpAnimNode.ActiveCameraAnimInstance != None)
 		{
 			TmpAnimNode.ActiveCameraAnimInstance.ApplyTransientScaling(StandingIdleWeight);
 		}
	}
}
 

function PostBeginPlay()
{
	super.PostBeginPlay();

	// Setup camera modes
 	if (SpectatorCam == None)
 	{
 		SpectatorCam = GearSpectatorCamera(CreateCamera(class'GearSpectatorCamera'));
 	}
 	if (DebugFaceCam == None)
 	{
 		DebugFaceCam = GearDebugFaceCamera(CreateCamera(class'GearDebugFaceCamera'));
 	}
	if (GameplayCam == None)
	{
		GameplayCam = GearGameplayCamera(CreateCamera(class'GearGameplayCamera'));
	}

	// Setup camera modifiers
 	if( GearCamMod_CameraBone == None )
 	{
 		GearCamMod_CameraBone = GearCamMod_CameraBone(CreateCameraModifier(class'GearCamMod_CameraBone'));
 	}
}

protected function GameCameraBase FindBestCameraType(Actor CameraTarget)
{
 	local GameCameraBase BestCam;
 	local GearPawn TargetGP;

	TargetGP = GearPawn(CameraTarget);

 	if (CameraStyle == 'screenshot')
 	{
 		BestCam = ScreenshotCam;
 	}
 	else

	// if not using a game-specific camera (i.e. not 'default'), we'll let the engine handle it
	if (CameraStyle == 'default')
	{
 		if (GearPC(PCOwner).bDebugFaceCam)
 		{
 			BestCam = DebugFaceCam;
 		}
 		else if ( (PCOwner.IsSpectating() && TargetGP == None && Vehicle(CameraTarget) == None )	||		// spectating something other than a pawn
 				  (GearSpectatorPoint(CameraTarget) != None) )				// looking through a spectator point
 		{
 			// if spectating or attached to a SpectatorPoint, use Spectator
 			BestCam = SpectatorCam;
 		}
		else if (CameraActor(CameraTarget) != None)
		{
			// if attached to a CameraActor and not spectating, use Fixed
			BestCam = FixedCam;
		}
		else
 		{
			BestCam = GameplayCam;
 		}
	}

	return BestCam;
}


/**
 * Query ViewTarget and outputs Point Of View.
 *
 * @param	OutVT		ViewTarget to use.
 * @param	DeltaTime	Delta Time since last camera update (in seconds).
 */
function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime)
{
	local Pawn P;
	local name CachedCameraStyle;
	local TPOV OrigPOV;

	// hack to allow debug camera rendering during other debug cameras
	// this will force the gears camera to run
	CachedCameraStyle = CameraStyle;
	CameraStyle = 'default';
	OrigPOV = OutVT.POV;

	super.UpdateViewTarget(OutVT, DeltaTime);

	// then we'll run the engine camera code if necessary to override it
	CameraStyle = CachedCameraStyle;
	if (CameraStyle != 'default')
	{
		OutVT.POV = OrigPOV;
		super(Camera).UpdateViewTarget(OutVT, DeltaTime);
	}

	// update any shakycam weights
	P = Pawn(OutVT.Target);
 	if (P != None)
 	{
 		UpdateShakyCam(P);
 	}
}

/**
 * Sets transient scaling on all active camera anims
 *
 * @param	Scale		Scaling to use.
 */
function ApplyTransientCameraAnimScale(float Scale)
{
	local int CameraAnimIdx;
	for (CameraAnimIdx = 0; CameraAnimIdx < ActiveAnims.length; ++CameraAnimIdx)
	{
		ActiveAnims[CameraAnimIdx].ApplyTransientScaling(Scale);
	}
}

/**
 * Static.  Plays a code-driven camera shake in world space to all LOCAL players, with distance-based attenuation.
 */
simulated static function PlayWorldCameraShake(CameraShake Shake, Actor ShakeInstigator, vector Epicenter, float InnerRadius, float OuterRadius, float Falloff, bool bTryForceFeedback, optional bool bOrientShakeTowardsEpicenter )
{
 	local GearPawn GP;

	super.PlayWorldCameraShake(Shake, ShakeInstigator, Epicenter, InnerRadius, OuterRadius, Falloff, bTryForceFeedback);

	// maybe do a near-miss cringe on big enough shakes
	if( ShakeInstigator != None )
	{
 		foreach ShakeInstigator.WorldInfo.AllPawns(class'GearPawn', GP)
 		{
 			if( VSize(GP.Location - Epicenter) < InnerRadius + ((OuterRadius - InnerRadius) * 0.25f) )
 			{
 				// Trigger a CringeOverlayAnim
 				GP.TryPlayNearMissCringe();
 			}
 		}
	}
}

defaultproperties
{
	StandingIdleSequenceNodeNames=("AR_Idle_Ready","AR_Idle_Ready_Aim")
	ThirdPersonCameraClass=None     // using GameplayCam var instead, for consistency
	FixedCameraClass=class'GearFixedCamera'
	CameraShakeCamModClass=class'GearCamMod_ScreenShake'
}