//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDPlayerControllerMP_FTD extends HDPlayerControllerMP;


var const int 	HEALTH_RECOVER;
var bool		bHasUsedRecover;


/* Reset()
reset actor to initial state - used when restarting level without reloading.
*/
function Reset()
{
	Super.Reset();

	bHasUsedRecover = false;
}


reliable server function ServerRecoverHealth()
{
	if( Pawn != none && Pawn.Health > 0 && !bHasUsedRecover )
	{
		Pawn.Health = Min( Pawn.HealthMax, Pawn.Health + HEALTH_RECOVER );
		bHasUsedRecover = true;
	}
}

exec function SwitchWeapon(byte T)
{
	if( T == 10 )
	{
		ServerRecoverHealth();
	}
}


auto state PlayerWaiting
{
    exec function KickOffMatch( optional byte FireModeNum )
	{
		local HDFightToDeath FTD;

		FTD = HDFightToDeath( WorldInfo.Game );
		if( FTD != none )
		{
			FTD.Kickoff();
		}
	}
}


state Dead
{
	function EndState(name NextStateName)
	{
		Super.EndState( NextStateName );

		bHasUsedRecover = false;
	}
}

state RoundEnded
{
	function EndState(name NextStateName)
	{
		Super.EndState( NextStateName );

		bHasUsedRecover = false;
	}
}


state Spectating
{
    exec function KickOffMatch()
	{
		local HDFightToDeath FTD;

		FTD = HDFightToDeath( WorldInfo.Game );
		if( FTD != none )
		{
			FTD.Kickoff();
		}
	}
}


