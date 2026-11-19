class TracerB extends Actor
	native; 

var float StartSpeed;
var Sound TracerAmbientSound;

simulated function Destroyed()
{
	AmbientSound = None;
	Super.Destroyed(); 
}

simulated function HitWall( vector HitNormal, actor HitWall )
{
	Velocity = vect(0,0,0);
	bHidden = true;
	AmbientSound = None;
	SetTimer(0,false);
}

simulated function Landed( vector HitNormal )
{
	HitWall(HitNormal, None);
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	If ( Other != Instigator )
	{
		Velocity = vect(0,0,0);
		bHidden = true;
		AmbientSound = None;
		SetTimer(0,false);
	}
}
	
simulated function Timer()
{
	Velocity = vect(0,0,0);
	bHidden = true;
	AmbientSound = None;
	SetTimer(0,false);
}

simulated event StartTracer(float TracerLifeTime, Rotator TracerRotation, vector TracerLocation)
{
	local vector Directional;

	if( bHidden )
	{
		SetRotation(TracerRotation);
		Directional = Normal(vector(TracerRotation));
		Velocity = Directional * StartSpeed;
		SetLocation(TracerLocation + (Directional * 30.0));
		bHidden = false;
		//AmbientSound = TracerAmbientSound;
		SetTimer(0.25,false);
	}
}	




// Decompiled with UE Explorer.
defaultproperties
{
    StartSpeed=40000.0000000
    Physics=6
    DrawType=8
    StaticMesh=StaticMesh'CBS_DYN_Weapon.FX.Tracer3D'
    bUseDynamicLights=false
    bAcceptsProjectors=false
    DrawScale3D=(X=20.0000000,Y=3.0000000,Z=3.0000000)
    AmbientGlow=200
    SoundRadius=300.0000000
    SoundVolume=255
    CollisionRadius=1.0000000
    CollisionHeight=1.0000000
    bCollideActors=true
    bCollideWorld=true
    bCollideSkeletalBoxes=true
    bBlockZeroExtentTraces=false
    bBlockNonZeroExtentTraces=false
}