class ACTION_PlayDead extends SASScriptAction;

var(Action) bool	mbHold;
var(Action) name	mPawnTag;


function bool DoAction(
	SASScriptInterface	aInterface )
{
	local SASGameInfo	gi;
	local SASTerrorist	terr;

	if ( mPawnTag == 'None' )
	{
		if ( aInterface.mAIController == None )
		{
			return true;
		}

		if ( (aInterface.mAIController.Pawn != None) 
			&& (SASTerrorist( aInterface.mAIController.Pawn ) != None) )
		{
			SASTerrorist( aInterface.mAIController.Pawn ).PlayActingDead( mbHold );
		}
	}
	else
	{
		gi = SASGameInfo( mOwnerScript.Level.Game );
		if ( gi != None )
		{
			foreach gi.AllSASPawns ( class'SASTerrorist', terr, mPawnTag )
			{
				terr.PlayActingDead( mbHold );
			}
		}
	}

	return true;
}


// Decompiled with UE Explorer.
defaultproperties
{
    mbHold=true
}