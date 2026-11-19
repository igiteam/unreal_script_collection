//=============================================================================
// ACTION_SeekCover.uc
//
// Script action to make a terrorist try to take cover. The action can be 
// used to take the nearest cover or to seek cover from a specified location.
// If cover cannot be found then controller will continue running script.
//=============================================================================

class ACTION_SeekCover extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action) bool	mbTakeCoverFromLocation;
var(Action) Vector	mLocToCoverFrom;


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	// Action can only be used if script is running on terrorist controller.
	if ( (aInterface.mAIController != None)
		&& (aInterface.mAIController.mType == CONTROLLER_AITerrorist) )
	{
		SASTerroristController( aInterface.mAIController ).SeekCoverInAssaultVolume();
	}

	return true;
}

//-----------------------------------------------------------------------------
// Default Properties



// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Seek Cover"
}