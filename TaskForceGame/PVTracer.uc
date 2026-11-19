
class PVTracer extends Tracer; 

simulated function HitWall( vector HitNormal, actor HitWall )
{
	Owner.Spawn(class'ZombieEffects.impact_generic',,,Location,rotator(HitNormal));
	Super.HitWall(HitNormal, HitWall); 
}


// Decompiled with UE Explorer.
defaultproperties
{
    TracerAmbientSound=none
    Speed=1000.0000000
    MaxSpeed=10000.0000000
    AmbientSound=none
    DrawScale3D=(X=20.0000000,Y=250.0000000,Z=1.0000000)
}