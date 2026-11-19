//------------------------------------------------------------------------------
// SASObjectiveMgr.uc
//
//------------------------------------------------------------------------------

class SASObjectiveMgr extends ReplicationInfo
	native
	placeable
	hidecategories(Actor,Advanced,Collision,Events,Force,Karma,LightColor,Lighting,Object,Sound,Movement,Display);

#exec OBJ LOAD FILE=..\Sounds\blueone.uax PACKAGE=BlueOne

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//------------------------------------------------------------------------------
//
//
const MAXNUMOBJECTIVES	= 16;

//------------------------------------------------------------------------------
// variables
//

// We would like this to ba a static array of [MAXNUMOBJECTIVES] size because
// it's easier (i.e. possible) to replicate but we're stuck with legacy level
// design. So I have to work around this.
// Therefore I'm using 'mMessages' & 'mObjectiveStatus'
// to replicate stuff around the network.
// N.B. there can only be [MAXNUMOBJECTIVES] set in this array. :-(
var(Objectives) export editinline array<SASObjective>		mObjectives;	// array of script triggers
var(Objectives) export edfindable editinline SASLevelScript	mLevelScript;	// level script triggered when objectives completed
var(Objectives)	export float	mActionDelayTimer;						// script trigger delay

var int							mObjectiveFlags; 

var eObjectivePriority			mPriority[MAXNUMOBJECTIVES];
//var String						mMessages[MAXNUMOBJECTIVES];			// output strings
var int							mNumObjectives;							// actual number of objectives

var(Strings) Localized String	mObjectiveChars[9];						// localizable label string
var(Strings) Localized String	mStrObjective;							// localizable label string
var(Strings) Localized String	mStatusStrings[4];						// localizable label string

var float						mScore;									// final score

var eObjectiveStatus			mObjectiveStatus[MAXNUMOBJECTIVES];		// for replication. objective status -
																		// mirrors mbEnabled flag in SASObjective.uc

var bool						mbActionTriggered;						// don't re-trigger a triggered script!

var(Sounds)	Array<Sound>		mCasualtySounds;						// mission end casualty report
var(Sounds) Array<Sound>		mGradeSounds;							// mission end sounds heard when player is successful

var(Debug) String				mLabelObjectives;
var(Debug) Array<String>		mLabelsStatus;

replication
{
	reliable if ( bNetInitial && ( Role == ROLE_Authority ) )
		mPriority,
		//mMessages,
		mNumObjectives;

	reliable if ( bNetDirty && ( Role == ROLE_Authority ) )
		mObjectiveStatus,
		mScore;
}

event PostNetBeginPlay()
{
	Super.PostNetBeginPlay();
}

native function StartDemoRecording();

// extract data to player profile 
native simulated function UpdatePlayerProfile ();

//------------------------------------------------------------------------------
// PawnKilled
//
// Called when an SASPawn is killed. Passes event notification onto each
// script.
native function PawnKilled (
	SASPawn		aKilled,
	Actor		aKiller);

//------------------------------------------------------------------------------
// PawnIncapacitated
//
// Called when an SASPawn is incapacitated. Passes event notification onto each
// script.
native function PawnIncapacitated (
	SASPawn		aIncap);

//------------------------------------------------------------------------------
// PawnCaptured
//
// Called when an SASPawn is captured. Passes event notification onto each
// script.
native function PawnCaptured (
	SASPawn		aCaptured);

//------------------------------------------------------------------------------
// CapturedPawnKilled
//
// Called when a captured pawn is killed. Passes event notification onto each
// script
native function CapturedPawnKilled (
	SASPawn		aKilled,
	Actor		aKiller);

//------------------------------------------------------------------------------
// VolumeCleared
//
// Called when SASSquadManager determines that a volume is cleared
native function VolumeCleared (
	SASAssaultVolume aVolume );

//------------------------------------------------------------------------------
// PawnEvacuated
//
// Called when pawn (i.e. hostage) gets to evacuation point.
native function PawnEvacuated (
   SASPawn aEvacuatedPawn );

//------------------------------------------------------------------------------
// EventTriggered
//
// Called when an event is triggered in the level. Passes event notification 
// onto each script.
native function EventTriggered (
	name		aEventName);

//------------------------------------------------------------------------------
// EventUntriggered
//
// Called when an event is triggered in the level. Passes event notification 
// onto each script.
native function EventUntriggered (
	name		aEventName);


//------------------------------------------------------------------------------
// SecondaryObjectiveCompleted
//
// Called whenever a secondary objective is completed by the player
native function SecondaryObjectiveCompleted (
	SASSecondaryObjective		aObjective);


//------------------------------------------------------------------------------
// SetStatus
//
// run through all objectives and set appropriate status, also sets replicated
// status array
//native function SetStatus ();
native function bool SetStatus (
	SASObjective	aObjective );


//------------------------------------------------------------------------------
//
//
simulated function DrawDebug ( Canvas aCanvas )
{
	local int				i,
							j;
	local float				xWidth,
							yWidth,
							xPos,
							yPos;
	local PlayerController	pc;
	local SASGRI			gri;
	local SASObjective		ob;

	pc = Level.GetLocalPlayerController ();

	if ( ( pc != None ) && ( pc.GameReplicationInfo != None ) )
	{
		gri = SASGRI ( pc.GameReplicationInfo );
	}

	xPos = 40;
	yPos = 100;

//	aCanvas.Font = aCanvas.SmallFont;
	aCanvas.StrLen ( mLabelObjectives, xWidth, yWidth );	// I'm just looking for the font height here ...
	aCanvas.SetDrawColor ( 255, 255, 255 );
	aCanvas.SetPos ( xPos, yPos );
	aCanvas.DrawText ( mLabelObjectives @"[" $mNumObjectives $"]" );
	yPos += yWidth * 1.5f;

	for ( i = 0; i < mNumObjectives; i++ )
	{
		ob = mObjectives[i];

		aCanvas.SetPos ( xPos, yPos );
		aCanvas.DrawText ( ob.mTextString @mStatusStrings [ ob.mStatus ] );
		yPos += yWidth;

		for ( j = 0; j < ob.mTConditions.Length; j++ )
		{
			aCanvas.SetPos ( xPos, yPos );
			if ( ob.mBool == OBJECTIVEBOOL_And )
			{
				aCanvas.DrawText ( " &&   condition [" $j $"]" @ob.GetProgressString ( gri, j ) );
			}
			else
			{
				aCanvas.DrawText ( " ||   condition [" $j $"]" @ob.GetProgressString ( gri, j ) );
			}
			yPos += yWidth;
		}

		yPos += yWidth * 0.5f;
	}
}

//------------------------------------------------------------------------------
// PreBeginPlay
//
// Initialize values etc. before bNetInitial is cleared. Gets the objective
// description strings to clients.
simulated event PreBeginPlay ()
{
	local int i;

	mNumObjectives = mObjectives.Length;

	if ( mNumObjectives >= MAXNUMOBJECTIVES )
	{
		mNumObjectives = MAXNUMOBJECTIVES - 1;
	}

	for ( i = 0; i < mNumObjectives; i++ )
	{
		// init conditions
		mObjectives[i].Init ();

		// set objective status for replication
		if ( ( mObjectives[i] != None ) && mObjectives[i].mbEnabled )
		{
			mObjectives[i].mStatus	= OBJECTIVESTATUS_InProgress;
			mObjectiveStatus[i]		= OBJECTIVESTATUS_InProgress;
		}
		else
		{
			mObjectives[i].mStatus	= OBJECTIVESTATUS_Disabled;
			mObjectiveStatus[i]		= OBJECTIVESTATUS_Disabled;
		}

		// update objective message strings for replication
		//if ( mObjectives[i].mTextString != "" )
		//{
		//	mMessages[i] = mObjectives[i].mTextString;
		//}

		// replicate priority
		mPriority[i] = mObjectives[i].mPriority;
	}
}

//------------------------------------------------------------------------------
// ObjectivesComplete
//
// test for end of game status, i.e. when all enabled primary objectives have
// been done. Ignore failed objectives to allow the player to play on.
function bool ObjectivesComplete ()
{
	local int i;
	local bool bIncomplete;
	local bool bEndMission;

	// can never complete, allow designers to edit/play cycle.
	if ( mNumObjectives == 0 )
	{
		return false;
	}

	// evaluate objectives status.
	bIncomplete = false;

	for ( i = 0; i < mNumObjectives; i++ )
	{
		// mission depends on primary objectives.
		if ( ( mObjectives[i].mPriority == OBJECTIVEPRIORITY_Primary ) && mObjectives[i].mbEnabled )
		{
			// primary objective in-progress.
			if ( ( mObjectives[i].mStatus == OBJECTIVESTATUS_InProgress ) && mObjectives[i].mbActive )
			{
				bIncomplete = true;
			}

			// primary objective failed. Allow mission to continue even if failed. Just flag it ...
			if ( mObjectives[i].mStatus == OBJECTIVESTATUS_Failed )
			{
				SASGRI ( Level.GetLocalPlayerController ().GameReplicationInfo ).mbMissionFailed = true;

				// ... unless the end mission flag is set
				if (mObjectives[i].mbEndMission)
				{
					bEndMission = true;
				} // if
			}
		}
	}

	if (bEndMission)
	{
		return true;
	} // if

	if ( bIncomplete )
	{
		return false;
	}

	return true;
}

//------------------------------------------------------------------------------
// FlipInProgressObjectiveStatus
//
// passive objectives (i.e. 'don't kill anyone' ..., c.f. 'kill 10 people') need
// their status set on level completion. You can't do anything to pass a passive
// objective, they just are!
// Also set status of negative type objectives.
function FlipInProgressObjectiveStatus ()
{
	local int i;
	local SASGRI gri;

	gri = SASGRI ( Level.GetLocalPlayerController ().GameReplicationInfo );

	// flip passive 'in-progress' objectives to 'success'
	for ( i = 0; i < mNumObjectives; i++ )
	{
		// only interested in objectives in-progress or disabled.
		switch ( mObjectives[i].mStatus )
		{
		case OBJECTIVESTATUS_InProgress:
		case OBJECTIVESTATUS_Disabled:
		
			// If failed mission, passive objectives with mbPassiveFailOnMissionFail set are failed.
			// Also if mbPassiveFailIfNotDone is set then passive objectives fail if not completed.
			if (	!mObjectives[i].mbActive && 
					(	(mObjectives[i].mbPassiveFailOnMissionFail && gri.mbMissionFailed) ||
						(mObjectives[i].mbPassiveFailIfNotDone)	) )
			{
				mObjectives[i].mStatus = OBJECTIVESTATUS_Failed;
				mObjectives[i].setScore ( gri );
				mObjectiveStatus[i]    = OBJECTIVESTATUS_Failed;
			}
			// if it's passive and hasn't yet failed, then by implication it's succeeded
			else if ( !mObjectives[i].mbActive || ( mObjectives[i].mType == OBJECTIVETYPE_Fail ) )
			{
				mObjectives[i].mStatus = OBJECTIVESTATUS_Succeeded;
				mObjectives[i].setScore ( gri );
				mObjectiveStatus[i]    = OBJECTIVESTATUS_Succeeded;
			}
			break;
		}
	}
}

//------------------------------------------------------------------------------
// GetObjectiveSound
//
function Sound GetObjectiveSound ( int aObjectiveNum )
{
	if ( aObjectiveNum < mNumObjectives )
	{
		switch ( mObjectives[aObjectiveNum].mStatus )
		{
		case OBJECTIVESTATUS_Succeeded:
			return mObjectives[aObjectiveNum].mSuccessSound;
			break;
		case OBJECTIVESTATUS_Failed:
			return mObjectives[aObjectiveNum].mFailSound;
			break;
		default:
			break;
		}
	}
	return None;
}

//------------------------------------------------------------------------------
// Update
//
// update objectives when events occur and run script (if there is one) on
// completion.
function Update ()
{
	local int		i;
	local SASGRI	gri;

//	SetStatus ();
	gri = SASGRI ( Level.GetLocalPlayerController ().GameReplicationInfo );
	if ( gri.mbRoundComplete )
	{
		return;
	}

	for ( i = 0; i < mNumObjectives; i++ )
	{
		if ( SetStatus ( mObjectives[i] ) )
		{
			// don't score passive objectives until EOM ...
			if ( mObjectives[i].mbActive )
			{
				mObjectives[i].setScore ( gri );
			}
			mObjectiveStatus[i] = mObjectives[i].mStatus;
		}
	}

	if ( ObjectivesComplete () )
	{
		Log ("Objectives complete");
		Log ("--- ending mission");

		SASGameInfo ( Level.Game ).EndMission ();
	} // if
}

//------------------------------------------------------------------------------
// EndMission
//
// called from SASGameInfo ...
function EndMission ()
{
	FlipInProgressObjectiveStatus ();

	if ( mLevelScript != None )
	{
		Log ("--- running level script");
		if ( mActionDelayTimer > 0 )
		{
			// run it later
			SetTimer ( mActionDelayTimer, false );
		}
		else
		{
			// run it now
			if ( !mbActionTriggered )
			{
				mLevelScript.RunScript ();
				mbActionTriggered = true;
			}
		}
	}

	UpdateScore();
}

//------------------------------------------------------------------------------
// Timer
//
function Timer ()
{
	// kill the timer
	SetTimer ( 0, false );

	// now, run the script
	if ( !mbActionTriggered )
	{
		mLevelScript.RunScript ();
		mbActionTriggered = true;
	}
}

//------------------------------------------------------------------------------
// UpdateScore
//
// Collate scores.
function UpdateScore ()
{
	local int		i;
	local SASGRI	gri;

	mScore = 0;
	gri = SASGRI ( Level.GetLocalPlayerController ().GameReplicationInfo );

	for ( i = 0; i < mNumObjectives; i++ )
	{
		mScore += mObjectives[i].getScore ( gri );
	}
	Log ( "ObjectiveMgr" @self @"mScore" @mScore);
}

//------------------------------------------------------------------------------
// GetUpdatedScore
//
// Update and return score for objectives system.
//::function float GetUpdatedScore ()
//::{
//::	UpdateScore ();
//::
//::	return mScore;
//::}

//------------------------------------------------------------------------------
// GetObjectiveMessages
//
// Get objective description strings for pause menu.
simulated function String GetObjectiveMessages ()
{
	local String	strObjectiveMessages;
	local int		i;

	if ( mNumObjectives > 0 )
	{
//		strObjectiveMessages = mMessages[0];

//		for ( i = 1; i < mNumObjectives; i++ )
		for ( i = 0; i < mNumObjectives; i++ )
		{
			if (mObjectiveStatus[i] != OBJECTIVESTATUS_Disabled )
			{
    			strObjectiveMessages = strObjectiveMessages $"|" $mObjectives[i].mTextString;
			}
		}
	}

	return strObjectiveMessages;
}

//GetObjectiveMessages for Pause Menu
//::simulated function String GetObjectivesMessages ()
//::{
//::	local String strObjectiveMessages;
//::	local int i;
//::	local eObjectiveStatus	status;
//::	
//::	if( mNumObjectives > 0 )
//::	{
//::		for( i = 0; i< mNumObjectives; i++ )
//::		{
//::			if( mObjectiveStatus[i] != OBJECTIVESTATUS_Disabled )
//::			{
//::				status = mObjectiveStatus[i];
//::				strObjectiveMessages = strObjectiveMessages $"|" $mObjectiveChars[i] $mMessages[i] $mStatusStrings[status];
//::			}
//::		}
//::	}
//::	
//::	return strObjectiveMessages;
//::}
				
		
//------------------------------------------------------------------------------
// defaultproperties 
//

// Decompiled with UE Explorer.
defaultproperties
{
    mObjectiveChars[0]="A. "
    mObjectiveChars[1]="B. "
    mObjectiveChars[2]="C. "
    mObjectiveChars[3]="D. "
    mObjectiveChars[4]="E. "
    mObjectiveChars[5]="F. "
    mObjectiveChars[6]="G. "
    mObjectiveChars[7]="H. "
    mObjectiveChars[8]="I. "
    mStrObjective="Obj "
    mStatusStrings[0]=": Disabled"
    mStatusStrings[1]=": Failed"
    mStatusStrings[3]=": Success"
    mCasualtySounds[0]=Sound'BlueOne.SAS_B1_endmission_05'
    mCasualtySounds[1]=Sound'BlueOne.SAS_B1_endmission_06'
    mCasualtySounds[2]=Sound'BlueOne.SAS_B1_endmission_07'
    mCasualtySounds[3]=Sound'BlueOne.SAS_B1_endmission_08'
    mLabelObjectives="Objectives"
    Texture=Texture'EditorTx.S_ObjectiveMgr'
    RemoteRole=1
    bStatic=true
}