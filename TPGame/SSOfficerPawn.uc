class SSOfficerPawn extends WehrmachtPawn
	placeable
	config(Game);





simulated event PostBeginPlay()
{
    super(TPPawn).PostBeginPlay();
    //give the Pistol
	//CreateInventory(class'Pistol');
}

function InitGear()
{
    InitHelmet();
}

