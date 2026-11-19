//=============================================================================
// SASBBMessage.uc
//=============================================================================

class SASBBMessage extends Actor
	native;

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Member Vars

var Int mReason;				// message reason code
var Actor mSender;				// actor that sent this message

var Float mCreationTime;		// time at which this msg was created
var Float mLastUpdateTime;		// time at which this msg was last updated

var Float mRelevance;			// relevance value. 
var Float mRelevanceDecayTime;	// relevance decay time - num of secs for relevance to go to zero

// storage

var Actor mActor;
var Vector mVector;

//-----------------------------------------------------------------------------
// Native Functions

//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions

//::function Clear()
//::{
//::	mReason = 0;
//::	mRelevance = 0.f;			// messages removed when relevance goes to 0.
//::}

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    DrawScale3D=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    NetUpdateFrequency=0.0000000
    NetPriority=0.0000000
    LODBias=0.0000000
    Texture=none
    DrawScale=0.0000000
    ScaleGlow=0.0000000
    SoundRadius=0.0000000
    CollisionRadius=0.0000000
    CollisionHeight=0.0000000
    Mass=0.0000000
    MessageClass=none
    mIllumination=0.0000000
    DrawType=0
    RemoteRole=0
    Role=0
    MaxLights=0
    Style=0
    SoundVolume=0
    SoundPitch=0
    bLightingVisibility=false
    bUseDynamicLights=false
    bLightAffectsStatic=false
    bAcceptsProjectors=false
    bReplicateMovement=false
    bMovable=false
    bBlockZeroExtentTraces=false
    bBlockNonZeroExtentTraces=false
    bJustTeleported=false
    ModulateX2=false
    RenderModulateX2=false
}