//=============================================================================
// SASLaserBeamProjector.uc
//
//=============================================================================

class SASLaserBeamProjector extends Projector;

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Structs

//-----------------------------------------------------------------------------
// Member Vars
var transient Actor		mAttachActor;
var transient Name		mAttachBone;

var transient Pawn		mInstigator;
var transient vector	mAttachPoint;
var transient vector	mRelativeLocation;
var transient rotator	mRelativeRotation;


simulated function PostNetBeginPlay()
{
	Log("SASLaserBeamProjector::PostNetBeginPlay");
	Super.PostNetBeginPlay();
}


//-----------------------------------------------------------------------------
// Native Functions

//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions

simulated function SetAttachBone(Actor actor, Name bone)
{
	mAttachActor = actor;
	//mAttachBone = bone;

	//mAttachActor.AttachToBone(self, mAttachBone);
}

//-----------------------------------------------------------------------------

simulated function UnsetAttachBone()
{
	if (mAttachActor != None)
	{
	//	mAttachActor.DetachFromBone(self);
	}
	mAttachActor = None;
	mAttachBone = '';
}

//-----------------------------------------------------------------------------

simulated function SetAttachPoint(Pawn instigator, vector relativeLocation, rotator relativeRotation)
{
	mInstigator = instigator;
	mRelativeLocation = relativeLocation;
	mRelativeRotation = relativeRotation;

	SetLocation(mInstigator.Location);
	SetBase(mInstigator);
	SetRelativeLocation(mRelativeLocation);
	SetRelativeRotation(mRelativeRotation);
}

//-----------------------------------------------------------------------------

simulated function UnsetAttachPoint()
{
	SetBase(None);
	mAttachActor = None;
}

//-----------------------------------------------------------------------------



//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    MaterialBlendingOp=1
    FrameBufferBlendingOp=2
    ProjTexture=Texture'SFXTx.lights.FxL_LaserDot'
    FOV=1
    MaxTraceDistance=1500
    bProjectBSP=false
    bProjectTerrain=false
    bProjectParticles=false
    bProjectOnAlpha=true
    bDynamicAttach=true
    Texture=none
    DrawScale=0.0000000
    bStatic=false
    bHidden=false
    bAlwaysRelevant=true
    bHardAttach=true
    bGameRelevant=true
}