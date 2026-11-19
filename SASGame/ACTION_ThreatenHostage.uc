//=============================================================================
// ACTION_ThreatenHostage.uc
//
//=============================================================================

class ACTION_ThreatenHostage extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action) name	mHostageTag;			// Tag of hostage to threaten
var(Action) name	mTerroristTag;			// Tag of terrorist to use, if 'None' then acts on terrorist running the script.
var(Action) float	mHostageKillRangeFromEnemy;		// Min range of enemy before shooting hostage.


///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	local SASHostage	hostage;
	local SASTerrorist	terrorist;

	// Find hostage with matching tag

	if ( mHostageTag == 'None' )
	{
		Warn( "" );
		return true;
	}

	foreach mOwnerScript.GetGame().AllSASPawns( class'SASHostage', hostage, mHostageTag )
	{
		break;
	}

	if ( hostage == None )
	{
		Warn( "" );
		return true;
	}

	// Now find terrorist with matching tag - if mTerroristTag not specified then 
	// use the terrorist running the script.

	if ( mTerroristTag == 'None' )
	{
		if ( (aInterface.mAIController == None) 
			|| (aInterface.mAIController.Pawn == None) )
		{
			return true;
		}

		terrorist = SASTerrorist( aInterface.mAIController.Pawn );
	}
	else
	{
		foreach mOwnerScript.GetGame().AllSASPawns( class'SASTerrorist', terrorist, mTerroristTag )
		{
			break;
		}
	}

	if ( terrorist == None )
	{
		Warn( "" );
		return true;
	}

	terrorist.ThreatenHostage( hostage, mHostageKillRangeFromEnemy ); 

	return true;
}



// Decompiled with UE Explorer.
defaultproperties
{
    mHostageKillRangeFromEnemy=150.0000000
}