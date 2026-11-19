//=============================================================================
// Heads up display
//=============================================================================
class SASDMHUD extends SASMPHUD;

simulated function bool InitHUD ()
{
	if ( mSASGRI == None )
	{
		InitSASGRI ();
		return false;
	}

	return true;
}

simulated function DrawIndicators ( Canvas aCanvas, SASPawn aPawn, float X, float Y )
{
}


simulated function DrawTime ( canvas aCanvas )
{
}
simulated function DrawObjectives ( canvas aCanvas )
{
}

//------------------------------------------------------------------------------
// DrawSquadStats
//
// MP-DM version of this
simulated function DrawSquadStats(
	Canvas aCanvas )
{
}
simulated function DrawRadioLog ( Canvas aCanvas )
{
}
//------------------------------------------------------------------------------
//
//
function InitSquadManager ()
{
}

//------------------------------------------------------------------------------
//
//
function InitObjectiveManager ()
{
}
