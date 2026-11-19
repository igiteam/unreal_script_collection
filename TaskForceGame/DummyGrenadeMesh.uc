class DummyGrenadeMesh extends Actor;

function PreBeginPlay()
{
	SetStaticMesh(StaticMesh(DynamicLoadObject("CBS_DYN_Weapon.ThirdPerson.HH_hegrenade", class'StaticMesh')));
}


// Decompiled with UE Explorer.
defaultproperties
{
    DrawType=8
    CollisionRadius=0.0000000
    CollisionHeight=0.0000000
    bBlockZeroExtentTraces=false
    bBlockNonZeroExtentTraces=false
}