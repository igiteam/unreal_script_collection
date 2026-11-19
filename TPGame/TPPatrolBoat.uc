class TPPatrolBoat extends TPPatrolBoat_Persistent
	placeable;

var () float Bouyancy;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	Buoyancy = Bouyancy;
}
