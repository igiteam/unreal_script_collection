//=============================================================================
// ACTION_Timer.uc
//
// Script action to do something to one of the level timers
//=============================================================================

class ACTION_Timer extends SASScriptAction;

enum eTimerAction
{
	TA_PAUSE,
	TA_UNPAUSE,
	TA_RESET,
	TA_SHOW
};

// To force him to make it a valid number
enum eWhichTimer
{
	WT_0,
	WT_1,
	WT_2,
	WT_3,
	WT_4,
	WT_5,
	WT_6,
	WT_7,
	WT_8,
	WT_9,
	WT_NONE
};

//-----------------------------------------------------------------------------
// Member Vars

var (Action) eTimerAction Action;
var (Action) eWhichTimer  WhichTimer;


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	// Hmm, I'm causing myself trouble everywhere because I don't have a const
	// for the number of timers in the game
	local byte which_timer;
	
	which_timer = WhichTimer;
	
	if (WhichTimer == WT_0)
	{
		// You're not allowed to affect timer 0 at all, apart from asking it to be shown.
		if (Action != TA_SHOW)
		{
			LogHuman("You can only 'show' timer 0: "$mOwnerScript);
			return true;
		}
	}
	else
	if (WhichTimer == WT_NONE)
	{
		which_timer = 255;
	}
	
	switch (Action)
	{
	case TA_PAUSE:
		mOwnerScript.Level.Game.GameReplicationInfo.StartLevelTimer(which_timer, false);
		break;
		
	case TA_UNPAUSE:
		mOwnerScript.Level.Game.GameReplicationInfo.StartLevelTimer(which_timer, true);
		break;
		
	case TA_RESET:
		mOwnerScript.Level.Game.GameReplicationInfo.ResetLevelTimer(which_timer);
		break;
		
	case TA_SHOW:
		SASHUD(mOwnerScript.Level.GetLocalPlayerController().myHUD).mWhichTimerToShow = which_timer;
		break;
	}
	
	return true;
}

///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return Action@WhichTimer;
}


//-----------------------------------------------------------------------------
// Default Properties

