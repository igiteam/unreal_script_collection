class ACTION_MoveToAssaultVolume extends SASLatentScriptAction;

var(Action) name	mAssaultVolTag;

var SASAssaultVolume	mTgtAssaultVol;


///////////////////////////////////////////////////////////////////////////////
// Init
//
function Init(
	SASScriptedSequence	aScript )
{
	Super.Init( aScript );

	if ( mAssaultVolTag != 'None' )
	{
		foreach mOwnerScript.AllActors( Class'SASAssaultVolume', mTgtAssaultVol, mAssaultVolTag )
		{
			break;
		}
	}

	if ( mTgtAssaultVol == None )
	{
		LogHuman( "ACTION_MoveToAssaultVolume: No target AV found for "$self$" in "$mOwnerScript);
	}
}


///////////////////////////////////////////////////////////////////////////////
// MoveToGoal
//
// Inidicates that this is a latent move action.
function bool MoveToGoal()
{
	return true;
}


///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	local NavigationPoint	NP;

	if ( (aInterface.mAIController != None) && (mTgtAssaultVol != None) )
	{	
		// Pick random nav point within AV
		if ( mTgtAssaultVol.mNavPoints.Length > 0 )
		{
			NP = mTgtAssaultVol.mNavPoints[Rand( mTgtAssaultVol.mNavPoints.Length )];
			if ( NP != None )
			{
				aInterface.mScriptMoveTarget = NP;
				aInterface.mScriptMoveTargetOfs = vect(0,0,0);

				return Super.DoAction( aInterface );
			}
		}
	}

	// Skip action if somthing went wrong.
	return true;
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mAssaultVolTag;
}


//-----------------------------------------------------------------------------
// Default Properties







// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Move to Assault Volume"
}