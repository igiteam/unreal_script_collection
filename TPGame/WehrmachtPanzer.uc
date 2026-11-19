class WehrmachtPanzer extends WehrmachtPawn
	placeable
	config(Game);



function DetachHat()
{
    super.DetachHat();
}

function InitStaticGear()
{
	//Do nothing
}

function InitDroppableGear()
{
    super.InitDroppableGear();// helmet
}


