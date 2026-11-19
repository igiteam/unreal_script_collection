/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class SpectatorCam_AutoFraming extends Object
	native(Camera)
	config(Camera);

/** Ref to the camera object that owns this mode object. */
var transient GearSpectatorCamera SpectatorCam;

/** InterpSpeed for the camera's FOV. */
var() const protected float FOVInterpSpeed;

/** InterpSpeed for the camera orientation. */
var() const protected float RotInterpSpeed;

var() protected const vector2d AcceptableFOVRange;

/** When setting FOV, defines how much far from the screen edge to try and keep pawns.  e.g. 0.1 is a 10% "safe zone". */
var() protected const float BorderBufferPercentage_Horizontal;
var() protected const float BorderBufferPercentage_Vertical;


enum EAutoFramingPawnTracePoint
{
	PawnTrace_Head,
	PawnTrace_Above,
	PawnTrace_Left,
	PawnTrace_Right,
};

/** Internal struct. */
struct native AutoframingWatchedPawn
{
	var GearPawn					GP;
	var vector						LookatLoc;
	var float						LastRelevantTime;
	var EAutoFramingPawnTracePoint	LastTracePoint;
	var float						NormalizedWeight;		// 0..1
};

/** How long a pawn will stay fully "relevant" after it disappears from sight. */
var() protected const float						RelevanceLagTime;
/** How long it takes a pawn to "fade" from relevance. */
var() protected const float						RelevanceFadeTime;


/** Distance from the pawn to test for non-head vis traces. */
var() protected const float						PawnTraceRadius;
/** What portion of velocity vector is used to bias the lookat for velocity.  Here for tweaking. */
var() protected const float						VelBiasFactor;


/** we cache these up from the battle cam path for use in the autoframing and interpolation code. */
struct native BattleCamStation
{
	var() vector BaseLocation;
	var() rotator BaseRotation;
	var() float BaseFOV;

	var rotator LastFramedDeltaRotation;
	var float LastFramedFOV;

	var bool bResetInterp;

	var init array<AutoframingWatchedPawn>		RelevantPawnList;
};
var init protected transient array<BattleCamStation> CachedBattleCamStations;


var() protected const float UserControlMaxYawDelta;
var() protected const float UserControlMaxPitchDelta;

var protected transient float UserControlLastYawDelta;
var protected transient float UserControlLastPitchDelta;

var() protected const float UserControYawInterpSpeed;
var() protected const float UserControPitchInterpSpeed;

/** Screen-space ratio.  1.f means all the way in. */
var() protected const float UserControlMaxZoomIn;
/** Screnn space ratio.  1.f means you can see double. */
var() protected const float UserControlMaxZoomOut;
var() protected const float UserControlZoomInterpSpeed;

var protected transient float UserControlLastDeltaFOV;


/** Debugging vars */
var() protected bool bDebugSkipFOVAdj;
var() protected bool bDebugShowWatchedPawns;


cpptext
{
protected:
	FAutoframingWatchedPawn* FindRelevantPawnEntryForStation(FBattleCamStation& Station, AGearPawn const* GP);
	FLOAT FindOptimalFOV(TArray<FAutoframingWatchedPawn> const& VisiblePawnList, FVector const& BaseLoc, FRotator const& BaseRot) const;
	FLOAT CalcHFovFromVFov(FLOAT VFovRad) const;
	FLOAT CalcVFovFromHFov(FLOAT HFovRad) const;
	void UpdateRelevantPawnListForStation(FBattleCamStation& Station, FVector& OutCentroid, FVector const& BaseLoc, FRotator const& BaseRot);
	void DoAutoframingForStation(INT StationIdx, FLOAT DeltaTime);
	FBattleCamStation* GetBattleCamStation(INT StationIdx);
public:
};

/** Sets Loc/Rot/FOV of camera.  Does all the work, basically. */
simulated native function UpdateCamera(CameraActor CamActor, SeqAct_SpectatorCameraPath CameraPath, float DeltaTime, out TViewTarget OutVT);

simulated native function CacheBattleCamStations(SeqAct_SpectatorCameraPath CameraPath);

function OnBecomeActive( GameCameraBase OldCamera )
{
	local GearPC_MP GPC;

	GPC = GearPC_MP(SpectatorCam.PlayerCamera.PCOwner);
	if (GPC != None)
	{
		CacheBattleCamStations(GPC.BattleCamPath);
	}

	UserControlLastDeltaFOV = 0.f;
	UserControlLastYawDelta = 0.f;
	UserControlLastPitchDelta = 0.f;
}


defaultproperties
{
	RelevanceLagTime=2.f
	RelevanceFadeTime=2.f
	PawnTraceRadius=64.f

	bDebugSkipFOVAdj=FALSE
	bDebugShowWatchedPawns=FALSE

	FOVInterpSpeed=0.5f
	RotInterpSpeed=1.f

	AcceptableFOVRange=(X=40.f,Y=100.f)

	BorderBufferPercentage_Horizontal=0.2f
	BorderBufferPercentage_Vertical=0.2f

	VelBiasFactor=0.3f

	UserControlMaxYawDelta=4096.f
	UserControlMaxPitchDelta=4096.f
	UserControYawInterpSpeed=4.f
	UserControPitchInterpSpeed=4.f
	UserControlZoomInterpSpeed=4.f
	UserControlMaxZoomIn=0.7f
	UserControlMaxZoomOut=1.f
}
