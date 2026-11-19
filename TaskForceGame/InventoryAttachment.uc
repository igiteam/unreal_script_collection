class InventoryAttachment extends Actor
	native
	nativereplication;

function InitFor(Inventory I)
{
	// Zombie
	SetDrawScale(I.ThirdPersonScale);
	if ( I.ThirdPersonMesh != None )
		LinkMesh(I.ThirdPersonMesh);
	else if ( I.ThirdPersonStaticMesh != None )
	{
		SetStaticMesh(I.ThirdPersonStaticMesh);
		SetDrawType(DT_StaticMesh);
//		SetDrawScale(DrawScale);
	}
	// Zombie

	Instigator = I.Instigator;
}

native simulated function Reskin(Material Skin0, Material Skin1);
		

// Decompiled with UE Explorer.
defaultproperties
{
    DrawType=2
    bOnlyDirtyReplication=true
    RemoteRole=2
    NetUpdateFrequency=10.0000000
    bUseLightingFromBase=true
}