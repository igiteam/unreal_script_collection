
class Tracer extends SFRMProjectile; 

var()	Sound	TracerAmbientSound; 

simulated function PostBeginPlay()
{
	Super.PostBeginPlay(); 

	if (TracerAmbientSound != None) 
		AmbientSound = TracerAmbientSound;
}

simulated function Destroyed()
{
	AmbientSound = None;
	Super.Destroyed(); 
}

simulated function HitWall( vector HitNormal, actor HitWall )
{
	Destroy(); 
}

simulated function Landed( vector HitNormal )
{
	HitWall(HitNormal, None);
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	//local vector HitNormal;

	If ( Other!=Instigator )
	{
		// hack, so we always have a valid location for the HitNormal
		if (Other == None)
			Other = Self; 

		Destroy();
	}
}
	
	



// Decompiled with UE Explorer.
defaultproperties
{
    TracerAmbientSound=Sound'CBW_DYN_Foley.whizzes.whizz1'
    Speed=10000.0000000
    MaxSpeed=25000.0000000
    Damage=0.0000000
    DrawType=8
    bUseDynamicLights=false
    AmbientSound=Sound'CBW_DYN_Foley.whizzes.whizz1'
    DrawScale3D=(X=20.0000000,Y=300.0000000,Z=1.0000000)
    SoundRadius=150.0000000
    SoundVolume=255
    CollisionRadius=1.0000000
    CollisionHeight=1.0000000
    bBlockZeroExtentTraces=false
    bBlockNonZeroExtentTraces=false
}