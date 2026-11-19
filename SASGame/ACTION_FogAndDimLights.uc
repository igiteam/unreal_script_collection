//=============================================================================
// ACTION_TriggerEvent.uc
//
// Script action to trigger an event.
//=============================================================================

class ACTION_FogAndDimLights extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action) name	mTag;			// Name of tag of lights and zones to affect
var(Action) float	mNewDistanceFogEnd;

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	local ZoneInfo zi;
	local Light l;
	
	// find all tagged lights and zones and play with their data
	foreach mOwnerScript.AllActors(class 'ZoneInfo', zi, mTag)
	{
		zi.bakDistanceFogStart = zi.DistanceFogStart;
		zi.bakDistanceFogEnd = zi.DistanceFogEnd;
		zi.DistanceFogEnd = mNewDistanceFogEnd;
		zi.DistanceFogStart = 0;
		zi.DistanceFogBlendTime = 4.0;
		zi.bDistanceFog = true;
		zi.bFadeInFogDistances = true;
	}

	foreach mOwnerScript.AllActors(class 'Light', l, mTag)
	{
		l.bCorona = false;
	}

	return true;	
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mTag@mNewDistanceFogEnd;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="FogAndDimLights"
}