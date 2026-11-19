//=============================================================================
// ACTION_EnableObjective.uc
//
// Script action to enable a mission objective which has started the mission in
// a disabled state
//=============================================================================

class ACTION_EnableObjective extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var (Action) SASObjective			mObjective;

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	local SASObjectiveMgr om;
	local int i;
	local SASGRI gri;

	Log ("Enable Objective " $mObjective);

	foreach mOwnerScript.allActors (class'SASObjectiveMgr', om)
	{
		break;
	} // foreach

	if (om == None)
	{
		Log ("ACTION_EnableObjective can't find manager");
		return false;
	} // if

	gri = SASGRI (om.Level.Game.GameReplicationInfo);
	mObjective.activate (gri.GetLevelTimer(0));

	// Search objective manager for this objective
	for ( i = 0; i < om.mNumObjectives; i++ )
	{
		if (om.mObjectives [i] == mObjective)
		{
			om.mObjectiveStatus [i] = OBJECTIVESTATUS_InProgress;
			break;
		} // if
	} // for

	return true;	
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mObjective;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Enable Objective"
}