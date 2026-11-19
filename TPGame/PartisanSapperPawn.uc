class PartisanSapperPawn extends PartisanPawn;

var StaticMesh BottleMesh;
var Name BottleSocket;



function InitGear()
{	
	local int gearIndex;
    local TPGear.GearInfoType Gi;
	
	super.InitGear();
	
	gearIndex = Gear.Length;
	
	
	//Add the bottle
	Gi.StaticMeshName = BottleMesh;
	Gi.SocketName = BottleSocket;
	Gi.DetachUponDeath = false;
	Gear[gearIndex] = Spawn(class'TPGear');
	Gear[gearIndex].AttachTo(self, Gi);
	gearIndex++;
	
}



