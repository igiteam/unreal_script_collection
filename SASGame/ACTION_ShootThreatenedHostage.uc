//=============================================================================
// ACTION_ShootThreatenedHostage.uc
//
// Script action to make a terrorist shoot at a hostage it is covering.
// If the terrorist acted on is not covering a hostage then nothing will happen.
//=============================================================================

class ACTION_ShootThreatenedHostage extends SASScriptAction;

//-----------------------------------------------------------------------------
// Member Vars

var(Action) name	mTerroristTag;


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	local SASTerrorist	terrorist;

	if ( mTerroristTag == 'None' )
	{
		// When no tag specified, act on controller running the script.
		if ( (aInterface.mAICOntroller != None) && 
			(aInterface.mAIController.Pawn != None) && 
			(SASTerroristController( aInterface.mAIController ) != None) )
		{
			terrorist = SASTerrorist( aInterface.mAIController.Pawn );
		}
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

	terrorist.KillThreatenedHostage();

	return true;
}


