#exec Texture Import File=Textures\S_KVehFact.dds Name=S_KVehFact Mips=Off MASKED=1

//=============================================================================
// KVehicle spawner location.
//=============================================================================
class KVehicleFactory extends Actor 
	placeable;

var()	class<KVehicle>		VehicleClass;
var()	int					MaxVehicleCount;

var		int					VehicleCount;

event onCreatedVehicle(KVehicle newV);
event Trigger( Actor Other, Pawn EventInstigator )
{
	local KVehicle CreatedVehicle;

	if(VehicleCount >= MaxVehicleCount)
		return;

	if(VehicleClass != None)
	{
		CreatedVehicle = spawn(VehicleClass,self , , Location, Rotation);
		VehicleCount++;
		CreatedVehicle.ParentFactory = self;
		onCreatedVehicle(CreatedVehicle);
	}
}



// Decompiled with UE Explorer.
defaultproperties
{
    bHidden=true
    bNoDelete=true
    RemoteRole=0
    Texture=Texture'S_KVehFact'
    bDirectional=true
}