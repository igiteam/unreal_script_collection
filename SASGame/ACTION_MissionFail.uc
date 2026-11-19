//=============================================================================
// ACTION_MissionFail.uc
//
//=============================================================================

class ACTION_MissionFail extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	SASGRI ( mOwnerScript.Level.GetLocalPlayerController ().GameReplicationInfo ).mbMissionFailed = true;
	SASGameInfo ( mOwnerScript.Level.Game ).EndMission ();

	return true;
}

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Mission Fail"
}