//=============================================================================
// ACTION_CallToRallyPoint.uc
//
// Script action to tell non-combat active terrorists to move toward a point
// on the map.
//=============================================================================

class ACTION_CallToRallyPoint extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action) edfindable SASTerroristRallyPoint	mRallyPoint;			// Rally point actor
var(Action) name								mTerroristTag;			// Optional tag to specify which terrorists to call to rp. (if none then all are called).


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	local SASTerrorist				terrorist;
	local SASTerroristController	TC;

	if ( mRallyPoint != None )
	{
		foreach mOwnerScript.GetGame().AllSASPawns( class'SASTerrorist', terrorist, mTerroristTag )
		{
			if ( terrorist.Controller != None )
			{
				TC = SASTerroristController( terrorist.Controller );
				if ( TC != None )
				{
					TC.CallToRallyPoint( mRallyPoint );
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
	return mActionString@mRallyPoint;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Call to rally point"
}