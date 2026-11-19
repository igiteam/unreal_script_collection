class PickupGrenade extends SFRMPickup
	abstract
	notplaceable;

function PreBeginPlay()
{
	SetStaticMesh(StaticMesh(DynamicLoadObject("CBS_DYN_Weapon.ThirdPerson.HH_hegrenade", class'StaticMesh')));
}


// Decompiled with UE Explorer.
defaultproperties
{
    PickupName="Grenade"
    PickupMessage="You picked up a grenade."
    CollisionRadius=34.0000000
}