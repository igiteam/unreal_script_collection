//=============================================================================
// ACTION_CounterAction.uc
//
// Abstract base class of all actions which operate on counters. 
// Class finds and stores reference to the counter during level init.
//=============================================================================

class ACTION_CounterAction extends SASScriptAction
	abstract;

//-----------------------------------------------------------------------------
// Member Vars

var() name				mCounterTag;	// Name ID of our counter - must match name of counter specified in the leveldata object

var SASScriptCounter	mCounter;		// Ref to our counter


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// Init
//
// Called from ScriptedSequence which action belongs to at start of level to
// intialise action member data.
function Init(
	SASScriptedSequence		aScript )
{
	local int			i;
	local SASLevelData	levelData;

	Super.Init( aScript );

	// Init reference to destination object
	if ( mCounterTag != 'None' )
	{
		// Counters are stored in leveldata which is referenced in SASGRI class.
		// The GameInfo object is spawned before script initialisation so can
		// safely assume its leveldata reference has been inited.
		levelData = SASGRI( aScript.Level.Game.GameReplicationInfo ).mLevelData;
		if ( levelData != None )
		{
			for ( i = 0; i < levelData.mScriptCounters.Length; ++i )
			{
				if ( (levelData.mScriptCounters[i] != None)
					&& (levelData.mScriptCounters[i].mTag == mCounterTag) )
				{
					mCounter = levelData.mScriptCounters[i];
					break;
				}
			}
		}

	}

	if ( mCounter == None )
	{
		LogHuman( "ACTION_CounterAction: Could not find counter "$mCounterTag$" for "$self$" in "$mOwnerScript );
	}
}

