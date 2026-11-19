class EinsteinPawn extends PartisanPawn
	placeable
	config(Game);

//***********************************************************************
// INCLUDES
//***********************************************************************









#linenumber 9


simulated event PostBeginPlay()
{
    super(TPPawn).PostBeginPlay();
    //give the Pistol
	//CreateInventory(class'Pistol');

	SetMoveSpeeds( class'TPTuneManager'.static.Get().GetTuneData().EinsteinMoveData );
}

function SetUniform( eUniform newUniform )
{
	Uniform = newUniform;
}

