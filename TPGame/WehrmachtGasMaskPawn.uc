class WehrmachtGasMaskPawn extends WehrmachtPawn;

var StaticMesh FaceGasMaskMesh;
var Name FaceGasMaskSocket;


function InitGear()
{
	local int gearIndex;
    local TPGear.GearInfoType Gi;
	
	super.InitGear();
	
	//Add the gas mask
	gearIndex = Gear.Length;
	
	
	Gi.StaticMeshName = FaceGasMaskMesh;
	Gi.SocketName = FaceGasMaskSocket;
	Gi.DetachUponDeath = false;
	Gear[gearIndex] = Spawn(class'TPGear');
	Gear[gearIndex].AttachTo(self, Gi);
	
	
}


