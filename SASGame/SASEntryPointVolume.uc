class SASEntryPointVolume extends Actor
	notplaceable
	native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

var SASEntryPoint	mLinkedEP;

event PreBeginPlay()
{
	Super.PreBeginPlay();
	bHidden = true;
}

simulated event PostNetBeginPlay()
{
	Super.PostNetBeginPlay();
	bHidden = true;
}



// Decompiled with UE Explorer.
defaultproperties
{
    StaticMesh=StaticMesh'SFXSm.Misc.FxMisc_DoorSpace'
    CollisionRadius=1.0000000
    CollisionHeight=1.0000000
    DrawType=8
    bStatic=true
    bUnlit=true
    bCollideActors=true
    bBlockNonZeroExtentTraces=false
    bEdShouldSnap=true
}