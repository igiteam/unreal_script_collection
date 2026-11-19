
class PVTracerFast extends Tracer; 

simulated function PostBeginPlay()
{
	local rotator TracerRotation;

	// Adjust tracer rotation to improve visibility for player
	TracerRotation = Rotation;
	TracerRotation.Roll=16930;  // 93 deg
	SetRotation( TracerRotation );

	Super.PostBeginPlay();
}

simulated function HitWall( vector HitNormal, actor HitWall )
{
	Owner.Spawn(class'ZombieEffects.impact_dustLight',,,Location,rotation);

	Super.HitWall(HitNormal, HitWall); 
}


// Decompiled with UE Explorer.
defaultproperties
{
    TracerAmbientSound=none
    Speed=13000.0000000
    MaxSpeed=14000.0000000
    AmbientSound=none
    DrawScale3D=(X=70.0000000,Y=1000.0000000,Z=3.0000000)
    AmbientGlow=255
}