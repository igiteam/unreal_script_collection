// Hacked Health Pickup, used like this until Vertical Slice is over
class TPDroppedHealthPickup extends TPDroppedPickup
								hidecategories(TPDroppedPickup)
								native
								config(Game);

var() class<TPSkeletalMeshPickup> VisibleMesh;
var() config int HealPercentage;
var const SkeletalMeshActor UsedMesh;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

simulated function PostBeginPlay()
{
	if (HealPercentage <= 0)
	{
		if (Instigator == none)
		{
			;
			Destroy();
		}
	}
}
simulated function Destroyed()
{
	super.Destroyed();
	UsedMesh.Destroy();
}

simulated function name GetPickupName ( )
{
    local string PickupName;

    PickupName = "Take";
    PickupName @= "Health";

    return name(PickupName);
}

