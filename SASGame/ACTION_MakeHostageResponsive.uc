//=============================================================================
// ACTION_MakeHostageResponsive.uc
//
//=============================================================================

class ACTION_MakeHostageResponsive extends SASScriptAction;

//-----------------------------------------------------------------------------
// Member Vars

var(Action) name	mHostageTag;
var(Action) bool	mbResponsive;


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	local SASHostage	hostage;

	foreach mOwnerScript.GetGame().AllSASPawns( class'SASHostage', hostage, mHostageTag )
	{
		hostage.mbUnresponsive = !mbResponsive;
	}

	return true;
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mHostageTag@mbResponsive;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mbResponsive=true
    mActionString="Make hostage responsive"
}