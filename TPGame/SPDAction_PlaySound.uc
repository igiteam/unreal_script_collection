//=============================================================================
// SPDAction_PlaySound.
// 
//=============================================================================

class SPDAction_PlaySound extends SPDAction
	editinlinenew
	NotPlaceable
	collapsecategories
	dependson(SPDProcessManager)
	hidecategories(Object);


//***********************************************************************
// STRUCT DECLARATIONS
//***********************************************************************

//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************

/** Sound cue to play on the targeted actor(s) */
var() SoundCue PlaySound;

/** Additional dead space to append to SoundDuration */
var() float ExtraDelay;

/** Time taken for sound to fade in when action is activated. */
var()	float	FadeInTime;

/** Time take for sound to fade out when Stop input is fired. */
var()	float	FadeOutTime;

/** Time take for sound to fade out when Stop input is fired. */
var()  	bool	AttachToSpawner;


//***********************************************************************
// CPP TEXT
//***********************************************************************
// (cpptext)
// (cpptext)
// (cpptext)

//***********************************************************************
// FUNCTIONS/STATES
//***********************************************************************

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
function AttachIt( Actor oldActor, Actor newActor )
{
	newActor.SetHardAttach(true);
	newActor.SetBase( oldActor );
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
event SPDActionState Run( float elapsedTime, Actor Actor, SPDProcessManager manager, SPDDamage DamageInfo )
{
	local SPDSoundActor soundActor;
	local vector pos;

	pos = DamageInfo.location;
	
	soundActor = manager.Spawn( class'SPDSoundActor' ,,, pos );
	soundActor.PlaySound    = PlaySound;
	soundActor.ExtraDelay   = ExtraDelay;  
	soundActor.FadeInTime   = FadeInTime;
	soundActor.FadeOutTime  = FadeOutTime;
	soundActor.ShowDebug = DamageInfo.ShowDebug;

	if ( AttachToSpawner )
	{
		AttachIt( actor, soundActor );
	}
	
	return SPDActionState_Done;
}

