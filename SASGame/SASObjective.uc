//------------------------------------------------------------------------------
// SASObjective.uc
//
//------------------------------------------------------------------------------

class SASObjective extends Object
	native
	hidecategories(Object)
	collapsecategories
	editinlinenew;

//------------------------------------------------------------------------------
// enums
//

//------------------------------------------------------------------------------
// variables
//
var() export const eObjectivePriority	mPriority;			// Primary or secondary objective.

var() export editinline array<SASTriggeredScriptCondition>	mTConditions;			// Set of trigger conditions

var() export Localized String	mTextString;		// Objective description.
var() export bool				mbActive;			// Active or passive objective.
var() export bool				mbPassiveFailOnMissionFail;	// Fail passive objective if mission fails.
var() export bool				mbPassiveFailIfNotDone;		// Fail passive objective if not completed by mission end.
var() export eObjectiveType		mType;				// Win or lose type.
var() export const int			mScoreSuccess;		// Score on success.
var() export const int			mScoreFailed;		// Score on failure.
var() export bool				mbEnabled;			// Whether to process this objective or not.
var() bool						mbEndMission;		// End mission when this objective is met ?

var eObjectiveStatus			mStatus;			// Status.
var() eObjectiveBool			mBool;				// conditions are logically ANDed or ORed
var   bool						mbDone;
var   float						mScore;

var float mActivationTime;							// Level time at which this condition was activated
var float mCompletionTime;							// Level time at which this condition was completed

var(Sounds) Sound				mSuccessSound;		// sound to play when objective succeeded
var(Sounds) Sound				mFailSound;			// sound to play when objective failed

//------------------------------------------------------------------------------
//::Function PreBeginPlay ()
//::{
//::	// If we're enabled at mission start, set our activation time to zero
//::	if (mbEnabled)
//::	{
//::		mActivationTime = 0.0;
//::	} // if
//::} // PreBeginPlay

//------------------------------------------------------------------------------
// 
//
function Init ()
{
	local int i;

	for ( i = 0; i < mTConditions.Length; i++ )
	{
		mTConditions [i].Init ( None );
	} // for
}

//------------------------------------------------------------------------------
// Call when objective is activated part-way through mission
Function activate (float time)
{
	local int i;

	mbEnabled = true;
	mStatus = OBJECTIVESTATUS_InProgress;
	mActivationTime = time;

	for (i = 0; i < mTConditions.Length; i++)
	{
		mTConditions [i].setStartTime (time);
	} // for
} // activate

//------------------------------------------------------------------------------
//
//
function setScore ( SASGRI gri )
{
	local float	pc;
	local int	i;
	local float thisScore;

	if ( !mbDone )
	{
		mScore = 0;
		pc = 0;

		Log ( "Objective" @self @"priority" @mPriority @"'" $mTextString $"'" );

		if ( mBool == OBJECTIVEBOOL_And )
		{
			// ANDed conditions, all % get added
			for ( i = 0; i < mTConditions.Length; i++ )
			{
				pc = mTConditions [ i ].getCompletionPercentage ( gri );
				thisScore = ( float ( mScoreSuccess - mScoreFailed ) * pc + float ( mScoreFailed ) ); // * ( i + 1 );
				mScore += thisScore;
				Log ( " &&    condition" @i @", completion" @pc @"+[" $thisScore $"]" );
			}
		}
		else
		{
			// ORed conditions, use only triggered condition's &
			for ( i = 0; i < mTConditions.Length; i++ )
			{
				pc = mTConditions [ i ].getCompletionPercentage ( gri );
				if ( pc == 1.0 )
				{
					mScore = float ( mScoreSuccess );
					Log ( " ||    condition" @i @", completion" @pc @"****" );
				}
				else
				{
					Log ( " ||    condition" @i @", completion" @pc );
				}
			}
		}

		Log ( "Objective" @self @"mScore" @mScore);

		mbDone = true;
	}
}

//------------------------------------------------------------------------------
//
//
function float getScore ( SASGRI gri )
{
	if ( !mbDone )
	{
		setScore ( gri );
	}

	return mScore;
} // getScore

//------------------------------------------------------------------------------
//
//
//::function String getStatusString ( SASGRI gri, optional int aIdx )
//::{
//::	if ( aIdx < mTConditions.Length )
//::	{
//::		return mTConditions [ aIdx ].getStatusString ( gri );
//::	}
//::	return "";
//::} // getStatusString

//------------------------------------------------------------------------------
//
//
function String GetProgressString ( SASGRI gri, optional int aIdx )
{
	if ( aIdx < mTConditions.Length )
	{
		return mTConditions [ aIdx ].GetProgressString ( gri );
	}
	return "";
} // getStatusString

//------------------------------------------------------------------------------
// defaultproperties
//

// Decompiled with UE Explorer.
defaultproperties
{
    mPriority=1
    mTextString="Objective description text"
    mbActive=true
    mType=1
    mScoreSuccess=50
    mScoreFailed=-50
    mbEnabled=true
    mStatus=2
}