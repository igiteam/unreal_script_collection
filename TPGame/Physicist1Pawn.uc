class Physicist1Pawn extends PartisanPawn
	placeable
	config(Game);

simulated event PostBeginPlay()
{
    super(TPPawn).PostBeginPlay();
    //give the Pistol
	//CreateInventory(class'Pistol');
}

function SetUniform( eUniform newUniform )
{
	Uniform = newUniform;
}

