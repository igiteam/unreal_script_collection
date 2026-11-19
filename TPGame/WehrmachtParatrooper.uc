class WehrmachtParatrooper extends WehrmachtPawn
	placeable
	config(Game);

var StaticMesh ptrooper_ammo;
var StaticMesh gasMask;



function InitStaticGear()
{
	local int gearSet;
    local int gearIndex;
    local TPGear.GearInfoType Gi;

    gearIndex = Gear.Length;
    gearSet = rand(4);

    switch(gearSet)
    {
    case 0:
		Gi.StaticMeshName = ptrooper_ammo;
		Gi.SocketName = 'ptrooper_ammo';
		Gi.DetachUponDeath = false;
		Gear[gearIndex] = Spawn(class'TPGear');
		Gear[gearIndex].AttachTo(self, Gi);
		gearIndex++;

		Gi.StaticMeshName = GasMaskMesh;
		Gi.SocketName = GasMaskSocket;
		Gi.DetachUponDeath = false;
		Gear[gearIndex] = Spawn(class'TPGear');
		Gear[gearIndex].AttachTo(self, Gi);
		gearIndex++;

    case 1:
		Gi.StaticMeshName = ptrooper_ammo;
		Gi.SocketName = 'ptrooper_ammo';
		Gi.DetachUponDeath = false;
		Gear[gearIndex] = Spawn(class'TPGear');
		Gear[gearIndex].AttachTo(self, Gi);
		gearIndex++;
        break;
    case 2:
		Gi.StaticMeshName = GasMaskMesh;
		Gi.SocketName = GasMaskSocket;
		Gi.DetachUponDeath = false;
		Gear[gearIndex] = Spawn(class'TPGear');
		Gear[gearIndex].AttachTo(self, Gi);
		gearIndex++;
        break;
    case 3:
        break;
    }
}

function InitDroppableGear()
{
    // Don't init any droppable gear
    InitHelmet();
}


