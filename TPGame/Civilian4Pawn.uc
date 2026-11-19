class Civilian4Pawn extends CivilianPawn
	placeable
	config(Game);


//***********************************************************************
// INCLUDES
//***********************************************************************









#linenumber 10



simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	SetMoveSpeeds( class'TPTuneManager'.static.Get().GetTuneData().Civilian4MoveData );
}

