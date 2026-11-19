//=============================================================================
// ACTION_SetEngagePcts.uc
//
// Script action to change the engage type weightings for terrorists.
//=============================================================================

class ACTION_SetEngagePcts extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action) float	mNewAggressivePct;
var(Action) float	mNewCoverPct;
var(Action) float	mNewRetreatPct;


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// Init
//
function Init(
	SASScriptedSequence	aScript )
{
	local float total, scale;

	Super.Init( aScript );

	// Normalise percentages
	mNewAggressivePct	= Max( mNewAggressivePct, 0.0 );
	mNewCoverPct		= Max( mNewCoverPct, 0.0 );
	mNewRetreatPct		= Max( mNewRetreatPct, 0.0 );
	total = mNewAggressivePct + mNewCoverPct + mNewRetreatPct;
	if ( total == 0.0 )
	{
		mNewAggressivePct	= 0.34;
		mNewCoverPct		= 0.33;
		mNewRetreatPct		= 0.33;
	}
	else
	{
		scale = 1.0 / total;

		mNewAggressivePct	*= scale;
		mNewCoverPct		*= scale;
		mNewRetreatPct		*= scale;
	}
}


///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	local SASTerroristController	TC;

	if ( aInterface.mAIController != None )
	{
		TC = SASTerroristController( aInterface.mAIController );
		if ( (TC != None) && (TC.mTerrorist != None) )
		{
			TC.mTerrorist.mAlertAggressivePct	= mNewAggressivePct;
			TC.mTerrorist.mAlertCoverPct		= mNewCoverPct;
			TC.mTerrorist.mAlertRetreatPct		= mNewRetreatPct;

			// TODO: Notify controller of change.
		}
	}

	return true;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="SetEngagePcts"
}