//=============================================================================
// SASSecondaryObjective.uc
//
// Secondary objective class in SAS.
//=============================================================================

class SASSecondaryObjective extends StaticMeshActor
	native
	placeable;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

var const SASSecondaryObjective	mNextSecondaryObjective;	// Used for linking the secondary objectives in a list. 

var bool			mbDisabled;					// True if objective has been disabled by an event.
var () float		mCompletionTime;			// How long space bar must be held to complete this objective
var () string		mDescriptionString;			// Name of this objective
var () string		mCompletionString;			// HUD message displayed when objective is completed
var bool			mCompleted;					// Set once objective has been completed
var() export edfindable SASLevelScript	mScript;	// script triggered when objective completed

var() Sound			mCompletionSound;
var() float			mCompletionSoundVolume;
var() float			mCompletionSoundRadius;

var() Sound			mProcessingSound;
var() float			mProcessingSoundVolume;
var() float			mProcessingSoundRadius;
var() float			mProcessingSoundRepeatTime;
var   float			mProcessingSoundTime;

var() bool			mStopAmbientSoundWhenCompleted;


replication 
{
	// Variables sent from server to clients.
	reliable if ( Role == ROLE_Authority )
		mbDisabled, 
		mCompleted;
}

function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	// Disable secondary objectives in multiplayer sabre-squad game mode.
	if ( Role == ROLE_Authority && Level.Game.mGameTypeID == 1 )
	{
		mbDisabled = true;
	}
}

//-----------------------------------------------------------------------------
function Complete()
{
	local SASGameInfo	gi;
	local SASGRI		gri;

	if ( Role != ROLE_Authority || mCompleted || mbDisabled )
	{
		return;
	}

	mCompleted = true;

	// Send HUD message to everyone.
	gi = SASGameInfo ( Level.Game );
	if ( gi!= None )
	{
		gi.BroadcastShowMessage (mCompletionString, 'SASSecondaryObjective', 5);
	} 

	// Tell objective manager.
	gri = SASGRI ( Level.GetLocalPlayerController ().GameReplicationInfo );
	if ( gri != None )
	{
		gri.SecondaryObjectiveCompleted (self);
	}

	if ( mScript != None )
	{
		mScript.RunScript();
	}

	if( mCompletionSound != None )
	{
		PlaySound( mCompletionSound,, mCompletionSoundVolume,, mCompletionSoundRadius );
	}
	
	if( mStopAmbientSoundWhenCompleted )
	{
		AmbientSound = None;
	}
}

//-----------------------------------------------------------------------------
simulated function bool IsCompleted()
{
	return mCompleted;
}

//-----------------------------------------------------------------------------
function Trigger(
	Actor	aOther, 
	Pawn	aEventInstigator )
{
	// Disable the objective if it's event gets triggered before it's been completed.
	if ( !mCompleted )
	{
		mbDisabled = true;
	}
}

//-----------------------------------------------------------------------------
// Default Properties
//
//-----------------------------------------------------------------------------

// Decompiled with UE Explorer.
defaultproperties
{
    mCompletionTime=2.0000000
    mDescriptionString="Secondary Objective"
    mCompletionString="Secondary Objective Completed"
    mCompletionSoundVolume=1.0000000
    mCompletionSoundRadius=50.0000000
    mProcessingSoundVolume=1.0000000
    mProcessingSoundRadius=50.0000000
    mProcessingSoundRepeatTime=1.0000000
    mStopAmbientSoundWhenCompleted=true
    StaticMesh=StaticMesh'Editor.TexPropCube'
    RemoteRole=2
    bStatic=false
    bAlwaysRelevant=true
    bSkipActorPropertyReplication=true
}