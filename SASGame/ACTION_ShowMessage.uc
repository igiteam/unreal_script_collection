//=============================================================================
// ACTION_ShowMessage.uc
//
// Script action to display a string
//=============================================================================

class ACTION_ShowMessage extends SASScriptAction;

//-----------------------------------------------------------------------------
// Member Vars

var(Action) Localized String		mMessage;
var(Action) float				    mDisplayTime;

// JS this system is deprecated really, but occasionally they might want to do it.
var(Action) bool					mNoReallyIDoWantToShowAMessageWithoutAWav;

// JS and maybe it's a debug message
//js shouldn't display in final release
var(Action) bool					mItsADebugMessage;

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
// Start animation on aController's pawn
function bool DoAction(
	SASScriptInterface	aInterface )
{
	if ( SASGameInfo( mOwnerScript.Level.Game ) != None )
	{
		// This should go to all pc huds in range...
		if (mItsADebugMessage)
		{
			// well, only if you're a developer
			// IsDeveloper is a static function of actor, so we need to find an object which is derived off actor...
			if (mOwnerScript.IsDeveloper())
			{
				SASGameInfo( mOwnerScript.Level.Game ).BroadcastShowMessage( "*DEBUG* "$mMessage, 'SASPawn', mDisplayTime );
			}
		}
		else
		if (mNoReallyIDoWantToShowAMessageWithoutAWav)
			SASGameInfo( mOwnerScript.Level.Game ).BroadcastShowMessage( mMessage, 'SASPawn', mDisplayTime );
		else
			LogHuman(""$self$" displaying legacy message "$mMessage);
	}
	else
	{
		Warn( "SASGameInfo(aController.Level.Game) == None" );
	}

	return true;	
}

//-----------------------------------------------------------------------------
// Default Properties

