//=============================================================================
// SASTorchBeamProjector.uc
//
//=============================================================================

class SASTorchBeamProjector extends Projector
	native;

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
	Log("SASTorchBeamProjector::PostNetBeginPlay");
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
	mAttachBone = bone;

	mAttachActor.AttachToBone(self, mAttachBone);
}

//-----------------------------------------------------------------------------

simulated function UnsetAttachBone()
{
	if (mAttachActor != None)
	{
		mAttachActor.DetachFromBone(self);
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

simulated function Tick(float DeltaTime)
{
	TickIt(DeltaTime);
}

simulated function TickIt(float DeltaTime)
{
	local coords	C;

	if (mInstigator != None)
	{
		// Detach and reattach
		DetachProjector();
		SetLocation(mInstigator.Location);
		SetBase(mInstigator);
		SetRelativeLocation(mRelativeLocation);
		SetRelativeRotation(mRelativeRotation);
		//Log( "Instigator based" );
		AttachProjector();
	}
	//if (mAttachActor != None)
	//{
	//	DetachProjector();

		// Need to ensure attach actor skeletal mesh is updated.
		//if ( mAttachActor.Mesh != None )
		//{
		//	C = mAttachActor.GetBoneCoords('');
		//}

		

 	//	AttachProjector();
	//}
}
//-----------------------------------------------------------------------------
// Default Properties

// Fixed the "gun torch projecting on tree leaves and leaving outlines" bug by Sandeep Kowdley 13/4/5

// Decompiled with UE Explorer.
defaultproperties
{
    MaterialBlendingOp=1
    FrameBufferBlendingOp=2
    ProjTexture=Texture'SFXTx.lights.FxL_torch_decal'
    FOV=35
    MaxTraceDistance=1500
    bProjectBSP=false
    bProjectTerrain=false
    bProjectParticles=false
    bProjectOnAlpha=true
    bProjectOwner=false
    bDynamicAttach=true
    Texture=none
    DrawScale=0.0000000
    bStatic=false
    bHidden=false
    bAlwaysRelevant=true
    bHardAttach=true
    bGameRelevant=true
}