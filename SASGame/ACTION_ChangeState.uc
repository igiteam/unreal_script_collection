//=============================================================================
// ACTION_ChangeState.uc
//
// Script action to change the state of the scripting controller.
// Script will end execution on this action.
//=============================================================================

class ACTION_ChangeState extends SASScriptAction;

//-----------------------------------------------------------------------------
// Enums

// List of states changes allowed from script
enum eStateType
{
	ST_Surrender,
	ST_SprayFire,
};

//-----------------------------------------------------------------------------
// Member Vars

var(Action) eStateType	mState;


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	if ( aInterface.mAIController == None )
	{
		return true;
	}

	switch ( mState )
	{
	case ST_Surrender:
		aInterface.mAIController.DoSurrender();
		break;

	case ST_SprayFire:
		aInterface.mAIController.DoSprayFire();
		break;
	}
	
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	local name	stateName;

	switch ( mState )
	{
	case ST_Surrender:
		stateName = 'Surrendering';
		break;
	}

	return mActionString@stateName;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Change State"
}