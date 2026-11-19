//=============================================================================
// SASGRI.uc
//=============================================================================

class SASGRI extends GameReplicationInfo
	native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//------------------------------------------------------------------------------
// Constants
//

const MAXNUMRADIOLOGENTRIES	= 28;

//------------------------------------------------------------------------------
// structs
//

//------------------------------------------------------------------------------
// variables
//

var SASLevelData			mLevelData;					// Level specific (non-placeable) editable data.
var DifficultySetting		mDifficultySetting;			// Current difficulty setting.
var int						mRepDifficultyIndex;		// Replicated difficulty index.
var int						mCampaignIndex;				// - Replicated campaign and
var int						mMissionIndex;				// - mission indices.

// Score stats
var bool					mbFirstTime;
var bool					mbRecordStats;

// Game-wide stats
var int						mSquadMembers;
var int						mSquadMembersKilled;
var int						mSquadMembersCaptured;
var int						mSquadMembersIncapacitated;

var int						mTerrorists;
var int						mTerroristsKilled;
var int						mTerroristsCaptured;
var int						mTerroristsEvacuated;
var int						mTerroristsIncapacitated;
var int						mTerroristsSurrenderedAndKilled;

var	int						mHostages;
var	int						mHostagesKilled;
var int						mHostagesCaptured;
var int						mHostagesEvacuated;
var int						mHostagesIncapacitated;

var bool					mbRoundComplete;

//var SASSquadManager		mSquadManager;			// this might yet end up in here ...
var SASObjectiveMgr			mObjectiveManager;
var SASBoobyTrapMgr			mBoobyTrapManager;

// cyclic buffer(s) for passing message pointers & times around the network
var String					mRadioMessageTextList[MAXNUMRADIOLOGENTRIES];
var float					mRadioMessageTimeList[MAXNUMRADIOLOGENTRIES];
var	int						mMaxNumRadioLogEntries;
var int						mRadioLogEntriesHead;

var int						mNumActiveTerrorists;
var float					mScore;
var float					mScorePC;
var float					mLevelEndTime;
var float					mLevelIdealTime;

var int						mSabreSquadNumTeamSwaps;		// How many promotions/demotions have occured in current SS round.


//------------------------------------------------------------------------------
// 
//
replication
{
	reliable if ( bNetInitial && ( Role == ROLE_Authority ) )
		mLevelData,
		mObjectiveManager,
		mDifficultySetting,
		mRepDifficultyIndex,
		mMaxNumRadioLogEntries,
		mCampaignIndex,
		mMissionIndex,
		mLevelIdealTime;

	reliable if ( bNetDirty && ( Role == ROLE_Authority ) )
//		mBoobyTrapManager,
		mRadioMessageTextList,
		mRadioMessageTimeList,
		mRadioLogEntriesHead,
		mbRoundComplete,
		mSabreSquadNumTeamSwaps;

//	reliable if ( bNetDirty && mbRoundComplete && ( Role == ROLE_Authority ) )
	reliable if ( mbRoundComplete && ( Role == ROLE_Authority ) )
		//mHostagesSaved,
		mNumActiveTerrorists,
		mSquadMembersKilled,
		mSquadMembersCaptured,
		mSquadMembersIncapacitated,
		mTerroristsKilled,
		mTerroristsCaptured,
		mTerroristsEvacuated,
		mTerroristsIncapacitated,
		mTerroristsSurrenderedAndKilled,
		mHostagesKilled,
		mHostagesCaptured,
		mHostagesEvacuated,
		mHostagesIncapacitated,
		mSquadMembers,
		mTerrorists,
		mHostages,
		mLevelEndTime;
}

// extract data to player profile 
native simulated function UpdatePlayerProfile ();

native function GetCampaignAndMissionIndices();

//------------------------------------------------------------------------------
// PreBeginPlay
//
// get stuff in before bNetInitial!
event PreBeginPlay ()
{
	Super.PreBeginPlay();

	TimeRestart ();

	mbRoundComplete = false;
	mRadioLogEntriesHead = 0;
	mMaxNumRadioLogEntries = MAXNUMRADIOLOGENTRIES;

	countPawns ();

	// Init the difficulty level to zero.
	// The correct setting will be applied later by the SASGameInfo object
	// which created me.
	if ( class'SASDifficulty'.Default.mSettings.Length > 0 )
	{
		mDifficultySetting = class'SASDifficulty'.Default.mSettings[0];
		mRepDifficultyIndex = 0;
	}

	// Get the campaign and mission index for replication.
	if ( Role == ROLE_Authority )
	{
		GetCampaignAndMissionIndices();
	}

	InitLevelData();

	// Set the level ideal completion time depending on if playing single player or co-op game.
	if ( Level.Game != None )
	{
		if ( Level.Game.mGameTypeId == 2 )
		{
			mLevelIdealTime = mLevelData.mTimeIdealCoop;
		}
		else
		{
			mLevelIdealTime = mLevelData.mTimeIdeal;
		}
	}
}

function InitLevelData()
{
	if ( Role == ROLE_Authority )
	{
		foreach AllActors ( class'SASLevelData', mLevelData )
		{
			break;
		}
		if ( mLevelData == None )
		{
			warn ( "No leveldata class exists in level." );
			mLevelData = Spawn( class'SASLevelData' );
		}
	}
}

// might use somethinf like this ...
//::function StartMissionTimer ()
//::{
//::	StartLevelTimer ( 1, true );
//::}
//::function StopMissionTimer ()
//::{
//::	StartLevelTimer ( 1, false );
//::}

//------------------------------------------------------------------------------
// EndLevel
//
// Signal we've ended the level
function EndMission ()
{
	if ( mbRoundComplete )
	{
		return;
	}

	mLevelEndTime = GetLevelTimer(mLevelData.mWhichTimerIsOverallTimer);

	// GP: Moved this to be calculated on activating the HUD stats screen. This
	// was required as training missions calculate the score in the HUD code and
	// we don't want to update the player profile until that has been done.
	//UpdateScores ();
	//UpdatePlayerProfile ();

	mbRoundComplete = true;
}


//::function float GetLevelEndTime ()
//::{
//::	return mLevelEndTime;
//::}

//------------------------------------------------------------------------------
Function countPawns ()
{
	local SASSoldier	s;
	local SASHostage	h;
	local SASTerrorist	t;

	// Count squad members
	mSquadMembers = 0;
	Foreach AllActors ( class'SASSoldier', s )
	{
		mSquadMembers++;
	} // Foreach

	// Count terrorists
	mTerrorists = 0;
	Foreach AllActors ( class'SASTerrorist', t )
	{
		mTerrorists++;
	} // Foreach

	// tot up hostages/hostages saved
	mHostages = 0;
	foreach AllActors ( class'SASHostage', h )
	{
		if ( h.mPawnType != PAWN_Scripted )
		{
			mHostages++;
		}
	} // Foreach

} // countPawns
//------------------------------------------------------------------------------
// UpdateScores
//
simulated function UpdateScores ()
{
	local SASPRI		pri;
	local Pawn			playerpawn;
	local PlayerController pc;

	pc = Level.GetLocalPlayerController();
	pri = SASPRI ( pc.PlayerReplicationInfo );
	playerpawn = pc.Pawn;

	// get default scoring and objectives scoring
	if ( mbRecordStats )
	{
		mScore = pri.GetUpdatedScore ();

		LOG( "Scoring: Player score = "$mScore ); 

		if ( mObjectiveManager != None )
		{
			mScore += mObjectiveManager.mScore;
			LOG( "Scoring: score to "$mScore$" after adding objective score" );
		}
		
		// Score the targets
		LOG("Scoring: adding "$mTargetScore$" for targets");
		mScore += mTargetScore;
				
		// ensure player is still alive before adding in time bonus
		if ( ( playerpawn != None ) && ( playerpawn.Health > 0 ) )
		{
			LOG("Scoring: adding time bonus of "$mLevelData.mTimeDifferenceScorePerSecond$" per second for "$mLevelIdealTime - mLevelEndTime$" seconds: score goes from "$mScore);
			mScore = mScore + ( mLevelIdealTime - mLevelEndTime ) * mLevelData.mTimeDifferenceScorePerSecond;
			LOG("Scoring: to "$mScore);
		}
	}

	// clamp score within level's min & max scores
	mScore = FClamp ( mScore, mLevelData.mMinPossibleScore, mLevelData.mMaxPossibleScore );
	LOG( "Scoring: Final score = "$mScore );

	// get percentage for grade
	mScorePC = 100 / (mLevelData.mMaxPossibleScore - mLevelData.mMinPossibleScore) * mScore;
	LOG( "Scoring: Final score percent = "$mScorePC );

	mbRecordStats = false;
}


//------------------------------------------------------------------------------
// TimeRestart
//
simulated function TimeRestart()
{
	ResetLevelTimer(0);	
}

//------------------------------------------------------------------------------
// GetTimeString
//
// A pretty-printer for time
simulated function String GetTimeString (float aTime)
{
	local String			tTimeSeconds,
							tTimeMinutes;
	local int				tSeconds;
	local int				tMinutes;

	tMinutes = aTime / 60.0;
	tSeconds = aTime - ( tMinutes * 60 );
	
	if ( tMinutes < 10 )
	{
		tTimeMinutes = "0"$tMinutes;
	}
	else
	{
		tTimeMinutes = ""$tMinutes;
	}

	if ( tSeconds < 10 )
	{
		tTimeSeconds = "0" $ tSeconds;
	}
	else
	{
		tTimeSeconds = "" $ tSeconds;
	}

	return ( tTimeMinutes $ ":" $ tTimeSeconds );
}

//------------------------------------------------------------------------------
// AddMessageToRadioLog
//
function AddMessageToRadioLog ( String aMessage )
{
	// GP: Disabled radio messages for Beta.
	return;

	if ( aMessage == "" )
	{
		return;
	}

	mRadioMessageTextList[mRadioLogEntriesHead] = aMessage;
	mRadioMessageTimeList[mRadioLogEntriesHead] = GetLevelTime();

	mRadioLogEntriesHead++;

	if ( mRadioLogEntriesHead >= mMaxNumRadioLogEntries )
	{
		mRadioLogEntriesHead = 0;
	}
}

//------------------------------------------------------------------------------
// GetRadioLogMessages
//
// get all messages with time for the radio log.
simulated function String GetRadioLogMessages ()
{
	local String	strRadioLog;
	local int		i,
					entry;

	strRadioLog = "";

	// find head of list
	entry = mRadioLogEntriesHead - 1;

	// concatenate string array
	for ( i = 0; i < mMaxNumRadioLogEntries; i++ )
	{
		if ( entry < 0 )
		{
			entry = mMaxNumRadioLogEntries - 1;
		}
		if ( mRadioMessageTextList[entry] != "" )
		{
			strRadioLog = strRadioLog $GetTimeString ( mRadioMessageTimeList[entry] ) $": " $mRadioMessageTextList[entry] $"|";
		}
		entry--;
	}

	return strRadioLog;
}

function ScorePawnCaptured( 
	SASPawn aCapturedPawn,
	bool	abIncrement )
{
	local int val;

	if ( abIncrement )
	{
		val = 1;
	}
	else
	{
		val = -1;
	}

	switch ( aCapturedPawn.mPawnType )
	{
	case PAWN_Soldier:
		mSquadMembersCaptured+=val;
		break;

	case PAWN_Terrorist:
		mTerroristsCaptured+=val;
		break;

	case PAWN_Hostage:
		mHostagesCaptured+=val;
		break;
	}
}

function ScorePawnIncapacitated(
	SASPawn	aIncapPawn,
	bool	abIncrement )
{
	local int val;

	if ( abIncrement )
	{
		val = 1;
	}
	else
	{
		val = -1;
	}

	switch ( aIncapPawn.mPawnType )
	{
	case PAWN_Soldier:
		mSquadMembersIncapacitated+=val;
		break;

	case PAWN_Terrorist:
		mTerroristsIncapacitated+=val;
		break;

	case PAWN_Hostage:
		mHostagesIncapacitated+=val;
		break;
	}
}

//------------------------------------------------------------------------------
//
//
// Pawn captured
function PawnCaptured ( SASPawn aCapturedPawn )
{
	if ( mbRecordStats )
	{
		// Unscore incapacitated.
		if ( aCapturedPawn.mbIsIncapacitated )
		{
			ScorePawnIncapacitated( aCapturedPawn, false );
		}

		// Score capture.
		ScorePawnCaptured( aCapturedPawn, true );
	}

	// Inform level objectives of capture event
	if ( mObjectiveManager != None )
	{
		mObjectiveManager.PawnCaptured ( aCapturedPawn );
		mObjectiveManager.Update ();
	}
}

//------------------------------------------------------------------------------
//
//
function PawnEvacuated ( SASPawn aEvacuatedPawn )
{
	if ( mbRecordStats )
	{
		switch ( aEvacuatedPawn.mPawnType )
		{
		case PAWN_Terrorist:
			mTerroristsEvacuated++;
			break;

		case PAWN_Hostage:
			mHostagesEvacuated++;
			break;
		}
	}

	if ( mObjectiveManager != None )
	{
		mObjectiveManager.PawnEvacuated ( aEvacuatedPawn );
		mObjectiveManager.Update ();
	}
}

//------------------------------------------------------------------------------
//
//
function VolumeCleared ( SASAssaultVolume aVolume )
{
	if ( mObjectiveManager != None )
	{
		mObjectiveManager.VolumeCleared ( aVolume );
		mObjectiveManager.Update ();
	}
}

//------------------------------------------------------------------------------
//
// Killed a pawn outright, with a flag passed in, in case he was incapacitated before this kill
//
function PawnKilled ( SASPawn aKilledPawn, SASPawn aKiller )
{
	local bool		bCapturedPawnKilled;

	bCapturedPawnKilled = false;

	if ( mbRecordStats )
	{
		// Unscore captured.
		if ( aKilledPawn.mbCaptured )
		{
			ScorePawnCaptured( aKilledPawn, false );
		}
		// Unscore incapacitated - note: if pawn is captured then this will already be unscored.
		else if ( aKilledPawn.mbIsIncapacitated )
		{
			ScorePawnIncapacitated( aKilledPawn, false );
		}

		switch ( aKilledPawn.mPawnType )
		{
		case PAWN_Soldier:
			mSquadMembersKilled++;
			break;

		case PAWN_Terrorist:
			mTerroristsKilled++;

			// did we kill a captured terrrorist?
			if ( aKilledPawn.mbCaptured )
			{
				bCapturedPawnKilled = true;
			}

			// Did we kill a captured/surrendered terrorist? - score down.
			if ( aKilledPawn.mbCaptured || SASTerrorist( aKilledPawn ).mbSurrendered )
			{
				mTerroristsSurrenderedAndKilled++;
			}
			break;

		case PAWN_Hostage:
			mHostagesKilled++;
			break;
		}
	}

	// Inform level objectives of kill event
	if ( mObjectiveManager != None )
	{
		mObjectiveManager.PawnKilled ( aKilledPawn, aKiller );

		if ( bCapturedPawnKilled )
		{
			mObjectiveManager.CapturedPawnKilled ( aKilledPawn, aKiller );
		}

		mObjectiveManager.Update ();
	}
} // PawnKilled

cleannative function TellScriptsPawnIncapacitated(SASPawn aIncapPawn, SASPawn aKiller);

//------------------------------------------------------------------------------
//
// Incapacitated a pawn
//
function PawnIncapacitated ( SASPawn aIncapPawn, SASPawn aKiller )
{
	if ( mbRecordStats )
	{
		if ( aIncapPawn.mbCaptured )
		{
			// Unscore captured.
			ScorePawnCaptured( aIncapPawn, false );
		}

		// Score incap.
		ScorePawnIncapacitated( aIncapPawn, true );
	} // if
	
	// tell all level scripts of kill event.
	TellScriptsPawnIncapacitated(aIncapPawn, aKiller);

	// Inform level objectives of kill event
	if ( mObjectiveManager != None )
	{
		mObjectiveManager.PawnIncapacitated ( aIncapPawn);
		mObjectiveManager.Update ();
	}

} // PawnIncapacitated

//------------------------------------------------------------------------------
//
//
function EventTriggered ( Name aEventName )
{
	if ( mObjectiveManager != None )
	{
		mObjectiveManager.EventTriggered ( aEventName );
		mObjectiveManager.Update ();
	}
}

//------------------------------------------------------------------------------
//
//
function EventUntriggered ( Name aEventName )
{
	if ( mObjectiveManager != None )
	{
		mObjectiveManager.EventUntriggered ( aEventName );
		mObjectiveManager.Update ();
	}
}

//------------------------------------------------------------------------------
//
//
function SecondaryObjectiveCompleted (SASSecondaryObjective objective)
{
	if ( mObjectiveManager != None )
	{
		mObjectiveManager.SecondaryObjectiveCompleted ( objective );
		mObjectiveManager.Update ();
	}
}

//------------------------------------------------------------------------------
//
//

// Decompiled with UE Explorer.
defaultproperties
{
    mbFirstTime=true
    mbRecordStats=true
}