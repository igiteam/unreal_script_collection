//=============================================================================
// ACTION_ChangeStickyCPRange.uc
//
// Script action to change the range of sticky CPs with a specified matching
// tag.
//=============================================================================

class ACTION_ChangeStickyCPRange extends SASScriptAction;

//-----------------------------------------------------------------------------
// Member Vars

var(Action) name	mStickyCPTag;
var(Action) float	mNewRange;


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	local SASGameInfo			gi;
	local SASAssaultVolume		av;
	local SASStickyCoverPoint	scp;
	local int					i, numCPsInAV;

	if ( mStickyCPTag != 'None' )
	{
		gi = mOwnerScript.GetGame();
		if ( gi != None )
		{
			// Loop through all assault volumes in the level.
			for ( av = gi.mAssaultVolumeList; av != None; av = av.mNextAssaultVolume )
			{
				// Loop through all the cover points in this assault volume.
				numCPsInAV = av.mCoverPoints.Length;
				for ( i = 0; i < numCPsInAV; ++i )
				{
					// Change range on CP if it has matching tag and is a sticky CP.
					if ( av.mCoverPoints[i].Tag == mStickyCPTag )
					{
						scp = SASStickyCoverPoint( av.mCoverPoints[i] );
						if ( scp != None )
						{
							scp.mRange = mNewRange;
						}
					}
				}
			}
		}
	}

	return true;
}

///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mStickyCPTag@mNewRange;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Change Sticky CP Range"
}