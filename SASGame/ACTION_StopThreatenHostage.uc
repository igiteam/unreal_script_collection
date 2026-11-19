//=============================================================================
// ACTION_StopThreatenHostage.uc
//
// Script action to make a terrorist stop covering a hostage.
// If the terrorist acted on is not currently covering a hostage, nothing will happen.
//=============================================================================

class ACTION_StopThreatenHostage extends SASScriptAction;

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

	terrorist.StopThreateningHostage();

	return true;
}

