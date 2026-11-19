class OLCollectiblePickup extends OLPickableObject
	native
	placeable;

var() name CollectibleName;

cpptext
{
	virtual void Pickup(AOLHero* hero);
	FString GetPickableName();
}

native function bool ShouldShowCollectible();

function PostBeginPlay()
{
	if (!ShouldShowCollectible())
	{
		SetHidden(TRUE);
	}
}


defaultproperties
{
	Begin Object Name=PickupMeshComp
		StaticMesh=StaticMesh'Interactive_Objects.PickupObjects.Document-01'
	End Object
	PickupMesh=PickupMeshComp	

	bPickupOnNotify=false

	AttachPositionOffset=(X=10.5,Y=-8)
}