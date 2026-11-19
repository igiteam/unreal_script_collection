class ACTION_StopPlayDead extends SASScriptAction;

var(Action) name	mPawnTag;
var(Action) bool	mbRecoverToIdle;

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
			SASTerrorist( aInterface.mAIController.Pawn ).EndActingDead( mbRecoverToIdle );
		}
	}
	else
	{
		gi = SASGameInfo( mOwnerScript.Level.Game );
		if ( gi != None )
		{
			foreach gi.AllSASPawns ( class'SASTerrorist', terr, mPawnTag )
			{
				terr.EndActingDead( mbRecoverToIdle );
			}
		}
	}

	return true;
}

