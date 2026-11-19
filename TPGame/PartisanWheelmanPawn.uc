class PartisanWheelmanPawn extends PartisanPawn
	placeable
	config(Game);

simulated event PostBeginPlay()
{
    super(TPPawn).PostBeginPlay();
    //give the Pistol
	//CreateInventory(class'Pistol');
}

