class PartisanAmmoPawn extends PartisanPawn
	dependson(PartisanPawn);


var StaticMesh BottleMesh;
var Name BottleSocket;

var StaticMesh KnifeMesh;
var Name KnifeSocket;

var StaticMesh AmmoPackMesh;
var Name AmmoPackSocket;


function InitGear()
{	
	local int chance;
	local int gearIndex;
    local TPGear.GearInfoType Gi;
	
	super.InitGear();
	
	gearIndex = Gear.Length;
	
	
	//Pick one out of the three NOT to add
	chance = Rand(3);
	
	if( chance != 0 )
	{
		//Add the bottle
		Gi.StaticMeshName = BottleMesh;
		Gi.SocketName = BottleSocket;
		Gi.DetachUponDeath = false;
		Gear[gearIndex] = Spawn(class'TPGear');
		Gear[gearIndex].AttachTo(self, Gi);
		gearIndex++;
	}

	if( chance != 1 )
	{
		//Add the knife
		Gi.StaticMeshName = KnifeMesh;
		Gi.SocketName = KnifeSocket;
		Gi.DetachUponDeath = false;
		Gear[gearIndex] = Spawn(class'TPGear');
		Gear[gearIndex].AttachTo(self, Gi);
		gearIndex++;
	}


	if( chance != 2 )
	{
		//Add the ammo pack
		Gi.StaticMeshName = AmmoPackMesh;
		Gi.SocketName = AmmoPackSocket;
		Gi.DetachUponDeath = false;
		Gear[gearIndex] = Spawn(class'TPGear');
		Gear[gearIndex].AttachTo(self, Gi);
		gearIndex++;
	}
	
}




